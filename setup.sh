#!/bin/bash

set -euo pipefail

create_backup() {
  local file=$1

  echo "creating backup: $file"
  mv "$file" "$file.backup.$(date +%Y%m%d_%H%M%S)"
}

add_link() {
  local source_path=$1
  local target_dir=$2

  local absolute_source=$(realpath "$source_path")
  local target=$target_dir/$(basename "$source_path")

  if [[ -L "$target" ]]
  then
    if [[ $(readlink -f "$target") == "$absolute_source" ]]
    then
      echo "symlink to $target already exists, skipping"
      return 0
    fi

    echo "replace symlink: $target"
    echo "  from: $(readlink "$target")"
    echo "  to: $absolute_source"
  elif [[ -e "$target" ]]
  then
    create_backup "$target"
  fi

  echo "linking $absolute_source to $target"
  ln -snf "$absolute_source" "$target"
}

link_files() {
  local target_dir=$1
  shift
  local files=("$@")

  for file in "${files[@]}"
  do
    add_link "$file" "$target_dir"
  done
}

link_dir() {
  local source_dir=$1
  local target_dir=$2

  [[ ! -d "$source_dir" ]] && return 0

  mkdir -p "$target_dir"

  local files=("$source_dir"/*)

  (( ${#files[@]} == 0 )) && return 0

  link_files "$target_dir" "${files[@]}"
}

main() {
  local home="${HOME}"
  local local_home=./home

  shopt -s dotglob nullglob

  for item in "$local_home"/*; do
    local name=$(basename "$item")

    if [[ -d "$item" ]]
    then
      link_dir "$item" "$home/$name"
      continue
    fi
    add_link "$item" "$home"
  done

  echo "Done"
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  main "$@"
fi
