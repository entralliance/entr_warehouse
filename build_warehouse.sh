# Script builds the warehouse. When the script finishes, check Google BigQuery.

dbt seed --profiles-dir .
dbt run --profiles-dir .
