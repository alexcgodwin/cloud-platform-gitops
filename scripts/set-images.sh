#!/usr/bin/env bash
set -euo pipefail
env=${1:?env}; tag=${2:?tag}; f="environments/$env/kustomization.yaml"
sed -E -i "s/newTag: \"[^\"]+\"/newTag: \"$tag\"/g" "$f"
