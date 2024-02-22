#sweetpotato

sql -U postgres -h db5.sgn.cornell.edu -d cxgn_batatabase -c "
COPY (
SELECT o.name as object, t.name as type, s.name as subject, cv.name
FROM cvterm_relationship cr
JOIN cvterm o on (cr.object_id = o.cvterm_id)
JOIN cvterm s on (cr.subject_id = s.cvterm_id)
JOIN cvterm t on (cr.type_id = t.cvterm_id)
JOIN cv on (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id != (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm on(type_id = cvterm_id)
    WHERE name = 'trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > spbase_composed_terms.csv 

#yam

psql -U postgres -h db5.sgn.cornell.edu -d cxgn_yambase -c "
COPY (
SELECT o.name as object, t.name as type, s.name as subject, cv.name
FROM cvterm_relationship cr
JOIN cvterm o on (cr.object_id = o.cvterm_id)
JOIN cvterm s on (cr.subject_id = s.cvterm_id)
JOIN cvterm t on (cr.type_id = t.cvterm_id)
JOIN cv on (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id != (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm on(type_id = cvterm_id)
    WHERE name = 'trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > yambase_composed_terms.csv 

#banana

psql -U postgres -h db5.sgn.cornell.edu -d cxgn_musabase -c "
COPY (
SELECT o.name as object, t.name as type, s.name as subject, cv.name
FROM cvterm_relationship cr
JOIN cvterm o on (cr.object_id = o.cvterm_id)
JOIN cvterm s on (cr.subject_id = s.cvterm_id)
JOIN cvterm t on (cr.type_id = t.cvterm_id)
JOIN cv on (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id != (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm on(type_id = cvterm_id)
    WHERE name = 'trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > musabase_composed_terms.csv

#cassava

psql -U postgres -h db8.sgn.cornell.edu -d cxgn_cassava -c "
COPY (
SELECT o.name as object, t.name as type, s.name as subject, cv.name
FROM cvterm_relationship cr
JOIN cvterm o on (cr.object_id = o.cvterm_id)
JOIN cvterm s on (cr.subject_id = s.cvterm_id)
JOIN cvterm t on (cr.type_id = t.cvterm_id)
JOIN cv on (s.cv_id = cv.cv_id)
WHERE t.name = 'contains' AND cv.cv_id != (
    SELECT cvprop.cv_id
    FROM cvprop
    JOIN cvterm on(type_id = cvterm_id)
    WHERE name = 'trait_ontology'
)
ORDER BY s.name)
To STDOUT With CSV HEADER DELIMITER ',';
" > cassava_composed_terms.csv

