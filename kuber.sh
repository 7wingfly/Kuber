#!/bin/bash
export K="kubectl"
export NAMESPACE="default"

print_help () {
    printf "\nAvailable Kuber commands: \n\n"
    printf " /ctx              Creates menu from which to select a context\n"
    printf " /ctx <context>    Sets the active context by name\n"
    printf " /ns               Creates menu from which to select a namespace\n"
    printf " /ns <namespace>   Sets the active namespace by name\n"
    printf " /q or /quit       Exits Kuber\n"
    printf " /? or /help       Displays this help message\n\n"
}

generate_menu () {
    local MENU_ITEMS=($1)
    local OUTPUT_VAR=$2
    echo ""
    for i in "${!MENU_ITEMS[@]}"; do
        echo "$((i+1)) - ${MENU_ITEMS[$i]}"    
    done
    echo ""
    read -r -p "Enter a number between 1 and ${#MENU_ITEMS[@]}: " NS_SELECTION
    if ! [[ "$NS_SELECTION" =~ ^[0-9]+$ ]]; then    
        printf "\nAnswer '$NS_SELECTION' is not a number\n"
    elif (( NS_SELECTION < 1 )) || (( NS_SELECTION > ${#MENU_ITEMS[@]})); then
        printf "\nAnswer '$NS_SELECTION' is out of range\n"
    else
        eval $OUTPUT_VAR="${MENU_ITEMS[(($NS_SELECTION-1))]}"
    fi
}

exec_k8s_cmd () {    
    result=$($K -n $NAMESPACE $1)
    echo "$result"
    user_input
}

user_input () {   
    read -r -p "$($K config current-context) > $NAMESPACE > " input
    if [[ $input = /* ]]; then
        if [[ $input = "/ctx" ]]; then
            generate_menu "$($K config get-contexts -o name)" result
            if [[ ! -z $result ]] && [[ $result != "" ]]; then                
                $K config use-context $result
                result=""
            fi        
        elif [[ $input = "/ctx "* ]]; then
            $K config use-context $(echo $input | cut -d' ' -f2)
        elif [[ $input = "/ns" ]]; then
            generate_menu "$($K get ns -o name | cut -d'/' -f2)" result
            if [[ ! -z $result ]] && [[ $result != "" ]]; then
                NAMESPACE=$result
                echo "Switched to namespace \"$NAMESPACE\""
                result=""
            fi
        elif [[ $input = "/ns "* ]]; then
            NAMESPACE=$(echo $input | cut -d' ' -f2)
            echo "Switched to namespace \"$NAMESPACE\""
        elif [[ $input = "/q" ]] || [[ $input = "/quit" ]]; then
            echo "Goodbye!"
            exit 0
        elif [[ $input = "/help" ]] || [[ $input = "/?" ]]; then
            print_help                
        else
            printf "Unknown Kuber command '$input' \n"
            print_help
        fi
        user_input
    else
        exec_k8s_cmd "$input"
    fi        
}

printf "\nWelcome to Kuber v0.1 Alpha\nWritten by Benjamin Watkins 2020\n\nType /? for a list of available Kuber commands\n\n"

user_input