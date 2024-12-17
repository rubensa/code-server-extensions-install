#!/bin/bash -i

installExtensions() {
  echo "Installing extensions"

  local extensions_file=
  if [ $# -eq 0 ]; then
    echo "Extensions file not specified"
    return 1
  else
    extensions_file=$1
  fi

  # Install extensions if file exists
  if  [ -e ${extensions_file} ]; then

    if [ -f ~/.vscode-server/bin/*/bin/code-server ]; then
      extensions=( $(sed '/^[[:blank:]]*#/d;s/\/\/.*//' ${extensions_file} | jq -r -c '.extensions[]') )
      ~/.vscode-server/bin/*/bin/code-server ${extensions[@]/#/--install-extension }
    elif [ -f ~/.vscode-server-insiders/bin/*/bin/code-server-insiders ]; then
      extensions=( $(sed '/^[[:blank:]]*#/d;s/\/\/.*//' ${extensions_file} | jq -r -c '.extensions[]') )
      ~/.vscode-server-insiders/bin/*/bin/code-server-insiders ${extensions[@]/#/--install-extension }
    else
      echo "Could not find code-server command"
      return 1
    fi
  else
    echo "Could not find ${extensions_file} file"
  fi

  echo "Extensions installed"
}

onCreateCommand() {
  # Get current script path
  local SCRIPTPATH=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

  local DEVCONTAINER_FOLDER=${SCRIPTPATH:-$PWD/.devcontainer}
  local WORKSPACE_FOLDER=${CONTAINER_WORKSPACE_FOLDER:-$PWD}

  echo "Creating"

  installExtensions ${DEVCONTAINER_FOLDER}/extensions.local.json || exit 1

  echo "Created"
}

onCreateCommand