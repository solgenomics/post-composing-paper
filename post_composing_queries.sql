##Here are the queries for the Database objects table 

### head
-- Total Number of post composed traits / pre-composed traits 
select count(*) from traits t where trait_name like '%COMP%';
select count(*) from traits t where trait_name like '%CO_334%';

-- Total of trials with post composed traits
select count(distinct(trial_id)) from traitsxtrials where trait_id in (select trait_id from traits where trait_name like '%COMP%');

-- total of trials types and post composed elements
select trial_typesxtrials.trial_type_id, trial_types.trial_type_name as type_name, count(distinct(traitsxtrials.trial_id)) as total from traitsxtrials
inner join trial_typesxtrials on traitsxtrials.trial_id = trial_typesxtrials.trial_id
inner join trial_types on trial_typesxtrials.trial_type_id = trial_types.trial_type_id
where traitsxtrials.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%')
group by trial_typesxtrials.trial_type_id, trial_types.trial_type_name
order by total desc;

-- total of trial designs
select trial_design_id as trial_design, count(distinct trial_designsxtrials.trial_id  ) as total
from trial_designsxtrials
inner join traitsxtrials on trial_designsxtrials.trial_id = traitsxtrials.trial_id
where traitsxtrials.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%')
group by trial_design
order by total  desc;

-- Total of accessions phenotyped with post composed traits
select count(distinct accessionsxtraits.accession_id) as total_accessions
from accessionsxtraits
where accessionsxtraits.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%');

-- Query with top 100 accessions and total post composed traits
select accessionsxtraits.accession_id as id, accessions.accession_name as accession, count(accessionsxtraits.accession_id) as total
from accessionsxtraits
inner join accessions on accessionsxtraits.accession_id = accessions.accession_id
where accessionsxtraits.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%')
group by accessionsxtraits.accession_id, accessions.accession_name
order by total desc
limit 100;

-- total of plots phenotyped with post composed traits
select count(distinct plotsxtraits.plot_id) as total_plots
from plotsxtraits
where plotsxtraits.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%');

-- total of plants phenotyped with post composed traits
select count(distinct plantsxtraits.plant_id) as total_plants
from plantsxtraits
where plantsxtraits.trait_id in (select traits.trait_id from traits where traits.trait_name like '%COMP%');

-- tissue samples and post composed traits
select cvterm."name", traits.trait_name , count(stock.stock_id) as total
from nd_experiment_stock
inner join stock on nd_experiment_stock.stock_id = stock.stock_id
inner join cvterm on stock.type_id = cvterm.cvterm_id
inner join nd_experiment_project on nd_experiment_stock.nd_experiment_id = nd_experiment_project.nd_experiment_project_id
inner join traitsxtrials on nd_experiment_project.project_id  = traitsxtrials.trial_id
inner join traits on traitsxtrials.trait_id  = traits.trait_id
where stock.type_id = (select cvterm_id from cvterm where name = 'tissue_sample')
and traitsxtrials.trait_id  in (select traits.trait_id from traits where traits.trait_name like '%COMP%')
group by traits.trait_name, cvterm."name"
order by total desc;
