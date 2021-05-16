#!/bin/bash -e
# Author : Quatrecentquatre-404
# Date : 09/06/2020
# GitHub link : https://github.com/Quatrecentquatre-404/perms

function main {
    local group="${1}"
    local group_status=$(grep "${group}" "/etc/group")
    if [[ -z "${group_status}" ]]; then
        echo "Error : the group '${group}' is not existing."
        exit 1
    fi

    local path="${3}"
    if ! [[ -d "${path}" && -f "${path}" ]]; then
        echo "Error : the path '${path}' is not reachable."
        exit 1
    fi

    local perms="${2}"
    local chmod_cmd="chmod g="
    if [[ "${perms}" != "none" ]]; then
        for (( index=0; index<"${#perms}"; index++ )); do
            permission="${perms:$index:1}"
            if [[ "${permission}" != "r" && "${permission}" != "w" && "${permission}" != "x" ]]; then
                echo "Error : the permission '${permission}' is incorrect. It should be 'r', 'w', 'x' or 'none'."
                exit 1
            fi
            chmod_cmd+="${permission}"
        done
    fi
    chmod_cmd+=" ${path}"


    local result=$(sudo chgrp "${group}" "${path}" && "${chmod_cmd}")
    exit 0
}

main "${@}"