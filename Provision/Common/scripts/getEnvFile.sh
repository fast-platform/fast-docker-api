#!/bin/bash
function get_env()
{   
    VAR=$(grep $1 .env | xargs)
    IFS="=" read -ra VAR <<< "$VAR"
    local  __resultvar=$1
    local  myresult=${VAR[1]}
    if [[ "$__resultvar" ]]; then
        eval $__resultvar="'$myresult'"
    else
        echo "$myresult"
    fi
}

