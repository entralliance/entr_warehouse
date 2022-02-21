Welcome to the ENTR Data Warehouse

## Background

## Getting Started

The [ENTR Runtime](https://github.com/entralliance/entr_runtime) Docker container will be built with all of the dependencies needed for this tutorial including a standalone Apache Spark warehouse that can be used for running everything contained within this dbt project (and more!). We recommend building the ENTR Runtime if you're running this project for the first time or if you're new to dbt.

**Important:** Before building the ENTR Runtime container, make sure to point its warehouse volume share to the location where you have this project cloned.

### Running dbt

From a terminal opened at the root of this project (`cd ~/host/warehouse` if using ENTR runtime), run the following commands in sequence:

1. Run `dbt debug` to validate that this dbt project is connected to a warehouse.
2. Run `dbt deps` to install all package dependencies required for this dbt project.
3. Run `dbt seed` to create tables from the example CSVs located in the `seeds/` directory in this project - this step will likely take several minutes since the sample data sets have tens of thousands of rows.
    * Note: these seeds emulate source tables that an industry user would want to get into the ENTR standard table schema defined in this project - see the [integration guidelines]() for how to put your data into a production data warehousing pipeline.
4. Run `dbt run` to materialize the example models in the warehouse.
5. Run `dbt test` to run the dbt tests that validate model output in this project.

### Explore the Models
Once you've gotten through step 4 above, you can query the models generated by dbt using Beeline, which is installed in the ENTR Runtime. From a terminal, run `beeline` then enter in your JDBC connection/credentials to connect to the data warehouse - this is the command to run from Beeline to connect to the warehouse built in the ENTR Runtime container: `!connect jdbc:hive2://localhost:10000/entr_warehouse -n -p`

From Beeline (or any other interactive querying tool compatible with your warehouse), you can run `select * from seed_asset_wind_turbine;` to view one of the tables seeded in step 3 above. You can run any SQL `select` statement from any models generated in this project to see what they look like, but we suggest limiting the number of rows displayed by adding a limit at the end of the query, e.g. `select * from dim_entr_tag_list limit 10;`

## Running OpenOA

Docs TBD

## Integration with your dbt Project

The ENTR Warehouse is *(going to be)* built as a dbt package that can be installed with dbt deps. Place this package in your project's `packages.yml` file and run `dbt deps` to install it.

### Connecting to your Warehouse

The ENTR runtime will build your dbt profile to connect to its standalone Spark warehouse. If you'd rather connect to a different warehouse, set up a new `entr_warehouse` dbt profile in your ~/.dbt directory.

### Running dbt in Production

Guidelines TBD

## Contributing

Contribution guidelines TBD.

## Development Standards

### Model Naming

If you're new to dbt, we recommend reading [this dbt Discourse article](https://discourse.getdbt.com/t/how-we-structure-our-dbt-projects/355) giving an overview of how dbt recommends structuring dbt projects.

In addition to the model name prefixes recommended by dbt, we've added some standards for naming models that relate specifically to this ENTR project and that also relate to general modeling of operational (mostly time-series) data from renewable projects.

TODO:
* add explanation of `map_` models
* add explanation of `exp_` models
* add explanation of `dim_` models
* add explanation of `base_` models
* add explanation of `seed_` naming convention
* add explanation of `int_` models
* add explanation of how to apply DQC methods
* explain Marts (vs. Staging)

#### Staging Models

In the words of dbt maintainers: "The goal of the staging layer is to create staging models. Staging models take raw data, and clean and prepare them for further analysis."

What happens to sources in the staging layer:
* type casting, e.g. converting timestamp strings to timestamp type
* column renaming
* dimensional foreign key tie-in, e.g. adding `plant_id` linking records containing plant-level data to the plant dimension (`dim_asset_plant`)
    * we generally recommend stripping out metadata that can be found within a dimension once that dimension's foreign key is added to a staging model, e.g. if a `plant_id` is tied into the staging model, remove `plant_name` from that staging model
* implementing *globally-applicable* data quality control (data scrubbing) methods, e.g. adding logic to remove absolute wind direction records that aren't between 0 and 360 degrees
* reshaping data to commonly used table schema
* unit conversion


#### Marts Models

### Data Quality-Related Modeling

### Styling

TODO: add all styling standards, e.g. where to put `ref` CTEs


## Resources:
- Learn more about dbt from the [dbt docs](https://docs.getdbt.com/docs/introduction)
- Check out the [dbt Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt Slack chat](http://slack.getdbt.com/) for live discussions and support
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the dbt blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices
