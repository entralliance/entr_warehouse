{{config(materialized='table')}}

with
    entr_src as (select * from {{ ref('stg_entr_scada_sample') }})

select * from entr_src
