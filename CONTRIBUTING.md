# Contributing to ENTR_WAREHOUSE

This document describes the procedures and expectations associated with contributing to the ENTR_WAREHOUSE repository.

## Creating a new release

### Pre-release checklist

- Make sure that the develop branch reflects the version you'd like to release:

### Release procedure
Once you are sure that develop contains the code you wish to release, here's the procedure to make a release from dev.

1. `git checkout main`
2. `git merge dev`
3. `git push origin main`
4. `git tag -a v{major}.{minor}.{update}` (where the version number is replaced with the numeric version of this tag)
5. `git push origin v{major}.{minor}.{update}` (where the version number is the same as the tag you just made)
