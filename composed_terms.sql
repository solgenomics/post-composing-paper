#sweetpotato

sql -U postgres -h db5.sgn.cornell.edu -d cxgn_batatabase -c "
COPY (
SELECT o.name AS trait, t.name AS relationship, s.name AS term, p.name AS parent, cv.name AS ontology
FROM cvterm_relationship cr
JOIN cvterm o ON (cr.object_id = o.cvterm_id)
JOIN cvterm s ON (cr.subject_id = s.cvterm_id)
JOIN cvterm t ON (cr.type_id = t.cvterm_id)
JOIN cvterm_relationship pr ON (s.cvterm_id = pr.subject_id AND pr.type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'is_a'))
JOIN cvterm p ON (pr.object_id = p.cvterm_id)
JOIN cv ON (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id IN (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm ON(type_id = cvterm_id)
    WHERE name LIKE '%ontology'
    AND name NOT LIKE '%trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > spbase_composed_terms.csv 

#yam

psql -U postgres -h db5.sgn.cornell.edu -d cxgn_yambase -c "
COPY (
SELECT o.name AS trait, t.name AS relationship, s.name AS term, p.name AS parent, cv.name AS ontology
FROM cvterm_relationship cr
JOIN cvterm o ON (cr.object_id = o.cvterm_id)
JOIN cvterm s ON (cr.subject_id = s.cvterm_id)
JOIN cvterm t ON (cr.type_id = t.cvterm_id)
JOIN cvterm_relationship pr ON (s.cvterm_id = pr.subject_id AND pr.type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'is_a'))
JOIN cvterm p ON (pr.object_id = p.cvterm_id)
JOIN cv ON (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id IN (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm ON(type_id = cvterm_id)
    WHERE name LIKE '%ontology'
    AND name NOT LIKE '%trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > yambase_composed_terms.csv 

#banana

psql -U postgres -h db5.sgn.cornell.edu -d cxgn_musabase -c "
COPY (
SELECT o.name AS trait, t.name AS relationship, s.name AS term, p.name AS parent, cv.name AS ontology
FROM cvterm_relationship cr
JOIN cvterm o ON (cr.object_id = o.cvterm_id)
JOIN cvterm s ON (cr.subject_id = s.cvterm_id)
JOIN cvterm t ON (cr.type_id = t.cvterm_id)
JOIN cvterm_relationship pr ON (s.cvterm_id = pr.subject_id AND pr.type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'is_a'))
JOIN cvterm p ON (pr.object_id = p.cvterm_id)
JOIN cv ON (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id IN (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm ON(type_id = cvterm_id)
    WHERE name LIKE '%ontology'
    AND name NOT LIKE '%trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > musabase_composed_terms.csv

#cassava

psql -U postgres -h db8.sgn.cornell.edu -d cxgn_cassava -c "
COPY (
SELECT o.name AS trait, t.name AS relationship, s.name AS term, p.name AS parent, cv.name AS ontology
FROM cvterm_relationship cr
JOIN cvterm o ON (cr.object_id = o.cvterm_id)
JOIN cvterm s ON (cr.subject_id = s.cvterm_id)
JOIN cvterm t ON (cr.type_id = t.cvterm_id)
JOIN cvterm_relationship pr ON (s.cvterm_id = pr.subject_id AND pr.type_id = (SELECT cvterm_id FROM cvterm WHERE name = 'is_a'))
JOIN cvterm p ON (pr.object_id = p.cvterm_id)
JOIN cv ON (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id IN (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm ON(type_id = cvterm_id)
    WHERE name LIKE '%ontology'
    AND name NOT LIKE '%trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > cassava_composed_terms.csv

