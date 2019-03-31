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

    $ schema.sh | dot -Tpng > schema.png

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)


## init_db 

generate some inital sql files for bootsrapping a postgres database

    $ init_db.sh -u postgres -s test -d postgres

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)

## init_phoenix 

generate a new elixir phoenix application with react frontend

    $ init_phoenix.sh -n application_name -s "Application name" -l "Application name - This name is shown in the app bar"

## generate_react_makefile

    $ generate_react_makefile.sh

This scripts generates a `Makefile` around a `create-react-app` application.

## generate_elixir_makefile

    $ generate_elixir_makefile.sh

This script generates a scaffolding `Makefile` for an `elixir` application.

## init_book 

generate some inital markdown files for bootstrapping a book

    init_book.sh -a "Jan Frederik Hake" -t "Awesome book" -f awesome

* `-a|--author` author of the book (mandatory)
* `-t|--title` book title (mandatory)
* `-f|--filename` filename used for the pdf / tex file without any extension (mandatory)
* `-v|--pdfviewer` default pdf viewer (default `evince`)

## init_hakyll

generate a scaffold for a [hakyll][hakyll] project.

    $ ./init_hakyll.sh -n project_name

* - n|--name project name

This script needs [stack][stack] installed.

## updateLicenseIfNecessary

    $ updateLicenseIfNecessary.sh

Updates the years for a project with a MIT license.

e.g:

    The MIT License (MIT)
    Copyright (c) 2016,2017,2018 Jan Frederik Hake
    
    Permission is hereby granted, free of charge, to any person obtaining a copy ...

# myip

gets your current external ip address

# brightness.sh

sets the backlight value for intel displays

     $ sudo ./brightness.sh -v 3000

sets the`/sys/class/backlight/intel_backlight/brightness` value to 3000

Contact
-------

Jan Frederik Hake, <jan_hake@gmx.de>. [@enter_haken](https://twitter.com/enter_haken) on Twitter.

[stack]: https://docs.haskellstack.org/en/stable/install_and_upgrade
[hakyll]: https://jaspervdj.be/hakyll
