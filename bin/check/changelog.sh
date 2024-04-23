#!/bin/bash
set -Eeuo pipefail
# Check that issues in CHANGELOG are up-to-to-date

first_line=$(head -1 <CHANGELOG.md)
version=$(echo "$first_line" | cut -d" " -f1 | cut -d'[' -f2)
if [[ -z "$version" ]]; then
    echo "Version can not be extracted from the first line <$first_line> of the CHANGELOG"
    exit 1
fi

echo "version=$version"
changelog=$(bin/release/changelog_extract.py "$version" | grep '^\* ')
issues=$(bin/release/get_release_note.py "$version" | grep '^\* ')

if [ "$changelog" != "$issues" ];  then
    echo "Diff in issues in CHANGELOG"
    diff <(echo "$changelog") <(echo "$issues")
    exit 1
fi

