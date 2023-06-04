#! /bin/bash
CURRENT_VERSION=$(yq eval '.version' dbt_project.yml)
NEXT_VERSION=$(echo $CURRENT_VERSION | awk -F '.' '{$2 = $2 + 1; $3 = 0;} 1' | sed 's/ /./g')
yq eval ".version = \"$NEXT_VERSION\"" -i dbt_project.yml
git commit -m "Bump version (minor)" dbt_project.yml
