scripts
=======

some scripts for daily usage

## battery_power.sh

Shows the current state of the battery for a notebook.

## pullAllSubdirectoryies.sh

make a `git pull` on all subdirectories.

## lock.sh

locks the current stream when 

    xscreensaver &

is activated.

## docker_reset.sh

* stops the docker deamon
* delete /var/lib/docker recursively
* starts the docker daemon

## schema.sh

generate erm like database schema from postgresql db

    ./schema.sh | dot -Tpng > schema.png

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)


## db_init

generate some inital sql files for bootsrapping a postgres database

    db_init -u postgres -s test -d postgres

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)

Contact
-------

Jan Frederik Hake, <jan_hake@gmx.de>. [@enter_haken](https://twitter.com/enter_haken) on Twitter.
