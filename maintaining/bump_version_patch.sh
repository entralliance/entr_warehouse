#! /bin/bash
CURRENT_VERSION=$(yq eval '.version' dbt_project.yml)
NEXT_VERSION=$(echo $CURRENT_VERSION | awk -F '.' '{$NF = $NF + 1;} 1' | sed 's/ /./g')
yq eval ".version = \"$NEXT_VERSION\"" -i dbt_project.yml
git commit -m "Bump version (patch)" dbt_project.yml
