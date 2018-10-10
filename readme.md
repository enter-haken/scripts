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


## db_init

generate some inital sql files for bootsrapping a postgres database

    $ db_init -u postgres -s test -d postgres

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)

## phoenix_init

generate a new elixir phoenix application with react frontend

    $ phoenix_init.sh -n application_name -s "Application name" -l "Application name - This name is shown in the app bar"

## generate_react_makefile

    $ generate_react_makefile

This scripts generates a `Makefile` around a `create-react-app` application.

## book_init

generate some inital markdown files for bootstrapping a book

    book_init -a "Jan Frederik Hake" -t "Awesome book" -f awesome

* `-a|--author` author of the book (mandatory)
* `-t|--title` book title (mandatory)
* `-f|--filename` filename used for the pdf / tex file without any extension (mandatory)
* `-v|--pdfviewer` default pdf viewer (default `evince`)

## updateLicenseIfNecessary

    $ updateLicenseIfNecessary.sh

Updates the years for a project with a MIT license.

e.g:

    The MIT License (MIT)
    Copyright (c) 2016,2017,2018 Jan Frederik Hake
    
    Permission is hereby granted, free of charge, to any person obtaining a copy ...

# myip

gets your current external ip address

Contact
-------

Jan Frederik Hake, <jan_hake@gmx.de>. [@enter_haken](https://twitter.com/enter_haken) on Twitter.
