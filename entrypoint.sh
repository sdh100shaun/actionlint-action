#!/bin/sh
set -eu

set --
set -- "$@" -color

# Process ignore patterns (one per line, safe from injection)
if [ -n "${INPUT_IGNORE:-}" ]; then
    while IFS= read -r pattern; do
        [ -n "$pattern" ] && set -- "$@" -ignore "$pattern"
    done <<ENDOFPATTERNS
${INPUT_IGNORE}
ENDOFPATTERNS
fi

if [ "${INPUT_SHELLCHECK:-true}" = "false" ]; then
    set -- "$@" -shellcheck=
fi

if [ "${INPUT_PYFLAKES:-true}" = "false" ]; then
    set -- "$@" -pyflakes=
fi

# Word-split intentional: space-separated file paths from trusted workflow author
if [ -n "${INPUT_FILES:-}" ]; then
    # shellcheck disable=SC2086
    set -- "$@" $INPUT_FILES
fi

exec actionlint "$@"
