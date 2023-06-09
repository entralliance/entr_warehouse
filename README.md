Welcome to the ENTR Data Warehouse

## Background

The ENTR Warehouse is a [dbt](https://www.getdbt.com/) project with the goal of providing a common ground of data (formats and transformation methods) upon which renewable energy industry users can build and share analytical applications. Once an industry user integrates his or her data into the generic fact and dimension tables in the ENTR model, he or she will then be able to utilize any associated applications that were built on top of the standard ENTR table schema.

## Getting Started

The [ENTR Runtime](https://github.com/entralliance/entr_runtime) Docker image contains all of the dependencies needed for this tutorial including a standalone Apache Spark warehouse that can be used for running everything contained within the ENTR Warehouse dbt project. See the [installation guide](https://entralliance.github.io/install.html) for how to build and set up the ENTR Runtime.

## ENTR Data Model

[dbt docs](https://docs.getdbt.com/docs/building-a-dbt-project/documentation#overview) for the entr_warehouse dbt project can be found at https://entralliance.github.io/entr_warehouse. This interface is useful for exploring and understanding the ENTR data model.

## How to Bring Your Own Data

*Note:* the following steps require at least basic experience with building models in dbt.

## Loading New Data from Files

The ENTR Runtime image contains pre-built models defined by the ENTR Warehouse based on open-source example data; however, for users wishing to bring their own data, the ENTR Warehouse supports setup of new sources from CSV and other Spark-readable file types by leveraging the [dbt-external-tables](https://github.com/dbt-labs/dbt-external-tables/tree/main) package from dbt-labs.
* With a clone of this entr_warehouse project mounted to the ENTR Runtime, drop a copy of the file you'd like to process through the ENTR data model into the `data/` directory
* Within the `models/staging/` directory, write out the source definition for the new file within a YML file in the staging directory using the [dbt-external-tables](https://github.com/dbt-labs/dbt-external-tables/tree/main) guides as needed
    * **Note**: the new files can be added to any YML file in the `models` folder but must be mapped under the `entr_warehouse`:

```yaml
sources:
  - name: entr_warehouse
    tables:
      - name: <new table name>
        description: <description of new source table>
        external:
          location: '<path to data file withing the container>' # e.g. "/home/jovyan/src/entr_warehouse/data/la_haute_borne_plant_data_sample.csv" - this depends on where you've mounted the entr_warehouse dir in the container
          using: csv # specify for different file types accordingly
          options:
            header: 'true' # optional but used with the ENTR sample data
```

* Run `dbt run-operation stage_external_sources` to make the file available as a table in the ENTR runtime Spark warehouse and as a source relation in dbt from which you can start building further transformations
* See the four files within the `data/` folder and their corresponding source definitions within the [entr_sample_data.yml file](https://github.com/entralliance/entr_warehouse/blob/main/models/staging/entr_sample_data/entr_sample_data.yml) for examples

**TODO: Replace outdated docs!!!**
<!-- 
### Transforming New Data to ENTR Standard Formats

Once the new file is set as a source, you will need to transform the data into the standard ENTR fact table format - to build the dbt transformations, you'll need to define and map the dimensional components of the new data utilizing the standard ENTR dimension table formats.

#### 1. (Optional) Create an Intermediate Model to Facilitate Table Reshaping

* You'll likely notice that the initial step in the transformation of the example sources (files) is just performing type casting (see the examples within the models/staging/entr_sample_data/intermediate directory), e.g. the [int_entr_scada_sample__cast](https://github.com/entralliance/entr_warehouse/blob/main/models/staging/entr_sample_data/intermediate/int_entr_scada_sample__cast.sql) model, which just performs type casting on the raw data as a preliminary step
    * Prepares the data for reshaping/pivoting; we expect this will be a frequently necessary staging step for source files with tags corresponding to data types
    * Assignment of dimensional keys, e.g. in the [int_entr_era5_sample model](https://github.com/entralliance/entr_warehouse/blob/e3eeb3e693349a2a6297274d686ef7f884a5bc18/models/staging/entr_sample_data/intermediate/int_entr_era5_sample__cast.sql#L4-L5) - see below for further detail

#### 2. Establish Link Between New Facts and Dimensions

* For the assignment of dimensional foreign keys, which is required for all ENTR Warehouse fact tables in their current state, the ENTR dimensions must be extended. For example, if the data you're preparing is not from La Haute Borne, a new plant must be added as a record within the [seeds/seed_asset_plant](https://github.com/entralliance/entr_warehouse/blob/main/seeds/seed_asset_plant.csv) dbt CSV seed file in order for the transformations to run properly, and the same goes for the other dimensional data assignments.
    * **Note**: not every field within the dimensions will be useful or used in analyses or transformations, so it may be ok to leave some blank to start depending on your use case
* In addition to extending the seeded ENTR dimensions, it may be useful or necessary to seed mapping files that are specific to a source to facilitate the translation of data into ENTR vernacular; we expect this to most commonly be done for mapping identifiers in the data you bring to ENTR tag IDs within the ENTR dimension
    * For example, the following files map the example 4 La Haute Borne example data sets' fields to ENTR tags. These tables are used to join on the ENTR tag IDs to the appropriate fields once the source table has been reshaped/unpivoted to have the original column names in a field
        * [seed_la_haute_borne_era5_tag_map](https://github.com/entralliance/entr_warehouse/blob/main/seeds/seed_la_haute_borne_era5_tag_map.csv)
        * [seed_la_haute_borne_merra2_tag_map](https://github.com/entralliance/entr_warehouse/blob/main/seeds/seed_la_haute_borne_merra2_tag_map.csv)
        * [seed_la_haute_borne_scada_tag_map](https://github.com/entralliance/entr_warehouse/blob/main/seeds/seed_la_haute_borne_scada_tag_map.csv)
        * [seed_plant_data_tag_map](https://github.com/entralliance/entr_warehouse/blob/main/seeds/seed_plant_data_tag_map.csv)
    * **Note**: we don't yet have standards defined for creating new ENTR tags, but that functionality will be coming soon

#### 3. Align Staging Model with Associated ENTR Fact Table Schema

* Once all metadata about the new data from the newly loaded file is available, the last staging step is transforming the data into the relevant ENTR generic fact table schema, which can be found in this project's dbt docs, e.g. [fct_entr_wtg_scada](https://entralliance.github.io/entr_warehouse/#!/model/model.entr_warehouse.fct_entr_wtg_scada) for the generic wind turbine SCADA data fact table schema - the staging model [stg_entr_scada_sample](https://github.com/entralliance/entr_warehouse/blob/main/models/staging/entr_sample_data/stg_entr_scada_sample.sql) performs the final transformation on the example SCADA data from La Haute Borne to make it match the table schema of the fct_entr_wtg_scada model. The current generic ENTR fact tables are as follows:
    * [fct_entr_plant_data](https://entralliance.github.io/entr_warehouse/#!/model/model.entr_warehouse.fct_entr_plant_data)
    * [fct_entr_wtg_scada](https://entralliance.github.io/entr_warehouse/#!/model/model.entr_warehouse.fct_entr_wtg_scada)
    * [fct_entr_reanalysis_data](https://entralliance.github.io/entr_warehouse/#!/model/model.entr_warehouse.fct_entr_reanalysis_data)
        * **Note**: this model is a good example showing 2 staged data sets (the ERA5 and MERRA-2 La Haute Borne reanalysis data) flowing into the same generic ENTR fact table for guidance in the following step

#### 4. Add Newly Staged Data to ENTR Fact Table

Once a staging model has been created for your new source data that matches the associated generic ENTR fact table schema, you will just need to union that new staging model with the generic ENTR fact table to make the new data ready for consumption by ENTR-based applications. The [fct_entr_reanalysis_data](https://entralliance.github.io/entr_warehouse/#!/model/model.entr_warehouse.fct_entr_reanalysis_data) shows how multiple staging models are combined in the generic ENTR reanalysis model. -->


## General dbt Learning Resources

- [Learn more about dbt](https://docs.getdbt.com/docs/introduction)
- Check out the [dbt Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt Slack chat](http://slack.getdbt.com/) for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
