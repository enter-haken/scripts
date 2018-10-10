#!/bin/sh
if [ ! -f LICENSE ]; then
    break; 
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
