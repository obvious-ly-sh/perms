#!/bin/bash
if [[ $# -eq 3 ]];
then
    group="${1}";
    permissions="${2}";
    path="${3}";

    if grep -q "${group}" /etc/group;
    then
        if [[ -d "${path}" || -f "${path}" ]];
        then
            permissions_command="chmod g=";
            if [[ "${permissions}" != "none" ]];
            then
                for (( index=0; index<${#permissions}; index++ ));
                do
                    permission="${permissions:$index:1}";
                    if [[ "${permission}" == "r" || "${permission}" == "w" || "${permission}" == "x" ]];
                    then
                        permissions_command="${permissions_command}${permission}";
                    else
                        echo "Error : the permission '${permission}' is incorrect. It should be 'r', 'w', 'x' or 'none'.";
                        exit 4;
                    fi
                done
            fi
            permissions_command="${permissions_command} ${path}";
            `sudo chgrp ${group} ${path} && ${permissions_command}`;
            exit 0;
        else
            echo "Error : the path '${path}' is not reachable.";
            exit 3;
        fi
    else
        echo "Error : the group '${group}' is not existing.";
        exit 2;
    fi
else
    echo "Error : invalid argument(s) supplied.";
    echo "Usage : ${0} <group> <permissions [(r, w, x) | (none)]> <path>";
    exit 1;
fi