fn areGeometricallySimilar obj1 obj2 =
(
    if (classOf obj1 == Editable_Poly and classOf obj2 == Editable_Poly) then
    (
        -- Vérification du nombre de sommets et de faces
        return (getNumVerts obj1 == getNumVerts obj2) and (getNumFaces obj1 == getNumFaces obj2)
    )
    else
    (
        return false
    )
)

-- Fonction pour sélectionner un objet via le picking
fn pickReferenceObject =
(
    local pickedObject = pickObject()
    if pickedObject != undefined and isKindOf pickedObject Editable_Poly then
    (
        return pickedObject
    )
    else
    (
        messagebox "Objet non sélectionné ou non valide. Sélectionnez un objet Editable_Poly."
        return undefined
    )
)

-- Exécution du picking pour obtenir l'objet de référence
theReferenceObject = pickReferenceObject()

-- Vérification et sélection des objets similaires
if theReferenceObject != undefined then
(
    similarObjects = for obj in geometry where (areGeometricallySimilar obj theReferenceObject) collect obj
    select similarObjects
)
else
(
    print "Aucun objet de référence sélectionné."
)
