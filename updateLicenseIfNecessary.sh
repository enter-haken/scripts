#!/usr/bin/env bash
if [ ! -f ./LICENSE ]; then
    echo "LICENSE file not found."
    exit 0; 
fi

if [ ! -d ./.git ]; then
    echo "not a git directory"
    exit 0;
fi

copyright=$(git log --pretty=format:"%an|%ad"       \
            --date=format:%Y | sort | uniq |        \
    awk 'BEGIN {FS="|"}                             \
    {                                               \
      if ($1==currentName) {                        \
              year=year "," $2;                     \
      }                                             \
      else {                                        \
          if (currentName) {                        \
              print "(c) " year " " currentName;    \
          };                                        \
          currentName=$1;                           \
          year=$2;                                  \
      }                                             \
    }                                               \
    END {                                           \
        if (currentName) {                          \
            print "(c) " year " " currentName;      \
        }                                           \
    }')

license=$(cat LICENSE | sed -e "s/(c).*$/$copyright/g")
echo "$license" > LICENSE
