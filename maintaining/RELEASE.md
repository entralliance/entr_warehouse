# Release Guidelines

## Branching Strategy

At any point, there should be two long-lived branches:
- `main` (default): This reflects the most recent release of dbt-utils
- `dev`: This reflects the next batch of code to release

The `dev` branch should be merged into `main` branch when new releases are created - any contributing branches will first be merged into `dev` before a new release.


## Release Process

1. Create the PR to merge `dev` into `main`
1. Run the appropriate version bump script and push automatically committed changes 
    - Note: we maintain the package version in the `dbt_project.yml` - this version will dictate the tag used for the auto-generated draft release
    - Release type guide:

        | Scenario                                   | Release type |
        |--------------------------------------------|--------------|
        | Package rearchitecture                     | major        |
        | Breaking changes                           | minor        |
        | Bug fixes & other minor updates            | patch        |

1. Update the compatible dbt package range
1. Validate CI checks including the version change in the logs from the "version-conflict-check" action
1. Merge the pull request
1. Release the automatically drafted tag release (created by the "draft-release") action
    - Open the drafted release and generate the automatic GH changelog by clicking "Generate release notes"
    - Add any necessary descriptive context about the changes in the release above the auto-generated changelogs
    - Click "Publish release"

### Follow-Up Tasks

- Merge `main` into `dev`
- Delete any branches that were merged that haven't already been deleted
