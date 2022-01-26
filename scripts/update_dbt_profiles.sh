#! /bin/bash

# make .dbt directory if it doesn't already exist
mkdir ~/.dbt -p

# copy profiles.yml to ~/.dbt
cp ../profiles.yml ~/.dbt/profiles.yml -i

# force Linux line endings in the file
cd ~/.dbt
sed 's/\r$//' ~/.dbt/profiles.yml > ~/.dbt/profiles.yml
