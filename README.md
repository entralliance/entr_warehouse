Welcome to the ENTR Data Warehouse

## Background

The ENTR Warehouse is a [dbt](https://www.getdbt.com/) project with the goal of providing a common ground of data (formats and transformation methods) upon which renewable energy industry users can build and share analytical applications. Once an industry user integrates his or her data into the generic fact and dimension tables in the ENTR model, he or she will then be able to utilize any associated applications that were built on top of the standard ENTR table schema.


## Getting Started

The [ENTR Runtime](https://github.com/entralliance/entr_runtime) Docker image contains all of the dependencies needed for this tutorial including a standalone Apache Spark warehouse that can be used for running everything contained within the ENTR Warehouse dbt project. See the [installation guide](https://entralliance.github.io/install.html) for how to build and set up the ENTR Runtime.


## ENTR Data Model

[dbt docs](https://docs.getdbt.com/docs/building-a-dbt-project/documentation#overview) for the entr_warehouse dbt project can be found at https://entralliance.github.io/entr_warehouse. This interface is useful for exploring and understanding the ENTR data model.


## How to Bring Your Own Data

*Note:* the following steps require at least basic experience with building models in dbt.

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


## General dbt Learning Resources

- [Learn more about dbt](https://docs.getdbt.com/docs/introduction)
- Check out the [dbt Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt Slack chat](http://slack.getdbt.com/) for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
