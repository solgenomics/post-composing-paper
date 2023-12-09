-- Use this query to extract the data and then calculate the groups in R
-- Extract accessions phenotyped with post-composed
select accessionsxtraits.accession_id as id, accessions.accession_name as accession, count(accessionsxtraits.accession_id) as total 
from accessionsxtraits 
inner join accessions on accessionsxtraits.accession_id = accessions.accession_id
where accessionsxtraits.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%')
group by accessionsxtraits.accession_id, accessions.accession_name
order by total desc;


-- This is to get traits for each group
-- With that will be possible to find out which trait root is more frequent
-- After extracting the traits, use R or excel to check the freequency of the trait root
SELECT 
    T.trait_id,
    T.trait_name,
    COUNT(AX.accession_id) AS appearance_count
FROM 
    accessionsxtraits AX
INNER JOIN 
    traits T ON AX.trait_id = T.trait_id
INNER JOIN 
    accessionsxtrials AT ON AX.accession_id = AT.accession_id
WHERE 
    AX.accession_id IN (
        SELECT 
            AX2.accession_id
        FROM 
            accessionsxtraits AX2
        INNER JOIN 
            traits T2 ON AX2.trait_id = T2.trait_id
        WHERE 
            T2.trait_name LIKE '%COMP%'
        GROUP BY 
            AX2.accession_id
        HAVING 
            COUNT(DISTINCT AX2.trait_id) >= 23 -- Set values for each group
    )
    AND (T.trait_name LIKE '%COMP%') -- Filtering out traits containing 'COMP'
GROUP BY 
    T.trait_id, T.trait_name
ORDER BY 
    appearance_count DESC, T.trait_name;
   

-- Couting post composed traits in each group
-- Also is possible to count pre-composed traits in each group
-- getting the total number of traits
SELECT 
    COUNT(DISTINCT T.trait_id) AS total_traits
FROM 
    accessionsxtraits AX
INNER JOIN 
    traits T ON AX.trait_id = T.trait_id
WHERE 
    AX.accession_id IN (
        SELECT 
            AX2.accession_id
        FROM 
            accessionsxtraits AX2
        INNER JOIN 
            traits T2 ON AX2.trait_id = T2.trait_id
        WHERE 
            T2.trait_name LIKE '%COMP%'
        GROUP BY 
            AX2.accession_id
        HAVING 
            (COUNT(DISTINCT AX2.trait_id) >= 16 and COUNT(DISTINCT AX2.trait_id) < 23 ) -- have to change this to grab the interval
    )
   AND (T.trait_name not LIKE '%COMP%') -- also have to change this to count post composed or pre-composed;
   
-- Count accessions in different groups
select count(*) as total_lines
from (select distinct accessionsxtraits.accession_id AS id, accessions.accession_name AS accession, count(accessionsxtraits.accession_id) AS total 
	from accessionsxtraits 
	inner join accessions ON accessionsxtraits.accession_id = accessions.accession_id
    where accessionsxtraits.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%')
    group by accessionsxtraits.accession_id, accessions.accession_name
    having count(accessionsxtraits.accession_id) < 16 
) as subquery

