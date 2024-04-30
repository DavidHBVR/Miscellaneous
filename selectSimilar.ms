-- Fonction pour obtenir le nombre de faces d'un objet mesh
fn getFaceCount obj =
(
    if classOf obj == Editable_Mesh then
        return obj.numfaces
    else
        return 0 -- Retourne 0 si ce n'est pas un mesh
)

-- Fonction pour obtenir la bounding box d'un objet
fn getBoundingBox obj =
(
    return nodeGetBoundingBox obj (matrix3 1)
)

-- Fonction pour obtenir le volume de la bounding box alignée sur les axes
fn getAxisAlignedBoundingBoxVolume box =
(
    local size = box[2] - box[1]
    return size.x * size.y * size.z
)

-- Fonction pour vérifier si deux bounding boxes sont similaires en volume avec une tolérance de 10%
fn areBoundingBoxesSimilarByVolume box1 box2 tolerance:0.02 =
(
    local volume1 = getAxisAlignedBoundingBoxVolume box1
    local volume2 = getAxisAlignedBoundingBoxVolume box2

    local minVolume = volume1 * (1 - tolerance)
    local maxVolume = volume1 * (1 + tolerance)

    return (volume2 >= minVolume) and (volume2 <= maxVolume)
)

-- Fonction pour vérifier si deux valeurs de polygones sont similaires avec une tolérance de 10%
fn areCountsSimilar count1 count2 tolerance:0.02 =
(
    local minCount = count1 * (1 - tolerance)
    local maxCount = count1 * (1 + tolerance)
    return (count2 >= minCount) and (count2 <= maxCount)
)

-- Fonction pour trouver les objets similaires
fn findSimilarMeshes referenceObjects selectedObjects =
(
    local similarObjects = #()
    local refCounts = for ref in referenceObjects collect getFaceCount ref
    local refBoxes = for ref in referenceObjects collect getBoundingBox ref

    for obj in selectedObjects where classOf obj == Editable_Mesh do
    (
        local objCount = getFaceCount obj
        local objBox = getBoundingBox obj
        for i = 1 to referenceObjects.count do
        (
            if areCountsSimilar objCount refCounts[i] and areBoundingBoxesSimilarByVolume objBox refBoxes[i] then
            (
                append similarObjects obj
            )
        )
    )
    return similarObjects
)

-- Interface utilisateur pour exécuter les fonctions avec un picking multiple
rollout selectSimilarMeshesRollout "Select Similar Meshes" width:300 height:700
(
     button btn_pick "Pick Reference" pos:[10,10] width:130 height:30
    label lbl_pickInfo "Press ESC to stop picking" pos:[10,45] width:280 height:20
    
    button btn_clearSelection "Clear Selection" pos:[150,10] width:130 height:30
    button btn_select "Select Similar" pos:[10,70] width:280 height:30

    button btn_pickUnpick "Pick Unpick Reference" pos:[10,120] width:130 height:30
    label lbl_unpickInfo "Press ESC to stop picking" pos:[10,155] width:280 height:20
    
    button btn_clearUnpick "Clear Unpick List" pos:[150,120] width:130 height:30
    button btn_deselect "Deselect Similar" pos:[10,180] width:280 height:30

    -- Définir la hauteur et la position des listes
    local listHeight = 100
    local listWidth = 140
    local listSpacing = 10
    local listPositionY = 220
    
    -- Liste des objets de sélection
    listBox lst_pickedObjects "Ref. Objects for Selection:" pos:[10, listPositionY] width:listWidth height:listHeight multiselect:false withScrollBars:true

    -- Liste des objets de désélection
    listBox lst_pickedUnpickObjects "Ref. Objects for Deselection:" pos:[160, listPositionY] width:listWidth height:listHeight multiselect:false withScrollBars:true

    local pickedReferenceObjects = #() 
    local pickedUnpickObjects = #() 
	
	-- Bouton pour vider la liste des objets de sélection
    on btn_clearSelection pressed do
    (
        pickedReferenceObjects = #()
        lst_pickedObjects.items = #()
    )

    -- Bouton pour vider la liste des objets de désélection
    on btn_clearUnpick pressed do
    (
        pickedUnpickObjects = #()
        lst_pickedUnpickObjects.items = #()
    )

  on btn_pick pressed do
(
    local objs = #()
    while not keyboard.escPressed do -- Continue picking until ESC is pressed
    (
        local obj = pickObject()
        if obj != undefined and isProperty obj #name then -- Check if obj is not undefined and has a property 'name'
        (
            appendIfUnique pickedReferenceObjects obj
            append objs obj.name -- Add object name to temporary list
        )
        else
            break
    )
    lst_pickedObjects.items += objs -- Update the list box with newly picked objects
)


    on btn_select pressed do
    (
        local currentSelection = getCurrentSelection()
        local similarObjects = findSimilarMeshes pickedReferenceObjects currentSelection
        clearSelection()
        select similarObjects
    )

    on btn_pickUnpick pressed do
(
    local objsUnpick = #()
    while not keyboard.escPressed do -- Continue picking until ESC is pressed
    (
        local obj = pickObject()
        if obj != undefined and isProperty obj #name then -- Check if obj is not undefined and has a property 'name'
        (
            appendIfUnique pickedUnpickObjects obj
            append objsUnpick obj.name -- Add object name to temporary list
        )
        else
            break
    )
    lst_pickedUnpickObjects.items += objsUnpick -- Update the list box with newly picked objects for unpicking
)

  on btn_deselect pressed do
(
    local currentSelection = getCurrentSelection()
    local objectsToDeselect = findSimilarMeshes pickedUnpickObjects currentSelection
    unselectObjects objectsToDeselect
)
)

-- Fonction pour obtenir la sélection actuelle dans la scène
fn getSceneSelection = 
(
    return selection as array
)

-- Fonction pour désélectionner une liste d'objets
fn unselectObjects objectsToDeselect =
(
    local allSelected = getCurrentSelection()
    
    -- Créer une nouvelle sélection qui exclut les objets à désélectionner
    local newSelection = for obj in allSelected where (findItem objectsToDeselect obj) == 0 collect obj

    -- Appliquer la nouvelle sélection
    select newSelection
)

-- Afficher le rollout
createDialog selectSimilarMeshesRollout
