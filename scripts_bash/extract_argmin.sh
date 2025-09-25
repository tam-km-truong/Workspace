#!/bin/bash
set -euo pipefail

tail -n +2 "$1" | awk '
{
    min = $2
    idx = 0
    for (i = 3; i <= NF; i++) {
        if ($i < min) {
            min = $i
            idx = i - 2
        }
    }
    print idx
}'