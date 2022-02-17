with
    entr_src as (select * from {{ ref('dqc_entr_plant_sample') }})

select * from entr_src
