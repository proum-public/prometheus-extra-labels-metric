#!/bin/bash
#
#
# Description: Expose metrics containing extra labels
#
# Author: Hauke Mettendorf <hauke@mettendorf.it>

set -eo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" ; pwd -P)"
PATH=$PATH:${SCRIPT_DIR}

function errorEcho {
    echo "${1}" 1>&2
    exit 1
}

function errorUsage {
    echo "${1}" 1>&2
    usage
    exit 1
}

# check prerequisites
for cmd in cat
do
    command -v ${cmd} > /dev/null || {  echo >&2 "${cmd} must be installed - exiting..."; exit 1; }
done

DEFAULT_TARGET_FILE="/run/prometheus/metrics/extra_labels.prom"

function usage() {
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Expose metrics containing extra labels"
  echo ""
  echo "        -f --target-file:            Destination file to print metrics to (default: ${DEFAULT_TARGET_FILE}) (ENV: TARGET_FILE)"
  echo ""
  echo "Environment variables:"
  echo ""
  echo "        TARGET_FILE                  Destination file to print metrics to (default: ${DEFAULT_TARGET_FILE})"
}

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        --target-file|-f)
        shift
        export TARGET_FILE="$2"
        shift
        ;;
        --help|-h|help)
        usage
        exit 0
        ;;
        *)
        shift
    esac
done

# Assign default values if optional argument is empty
for variable in TARGET_FILE; do
  if [[ -z ${!variable} || ${!variable} == '<no value>' ]]; then
    default_var_name="DEFAULT_${variable}"
    export "${variable}=${!default_var_name}"
  fi
done

# Create directory if necessary
mkdir -p "$(dirname ${TARGET_FILE})"

# Copy hostname to target
while true; do
  echo "# HELP extra_node_labels like hostname of node" > "${TARGET_FILE}"
  echo "# TYPE extra_node_labels gauge" >> "${TARGET_FILE}"
  echo "extra_node_labels{native_hostname=\"$(cat /etc/hostname)\"} 0" >> "${TARGET_FILE}"
  sleep 30
done
