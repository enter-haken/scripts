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

# random_image.sh

gets a randomly generated image 

    $ ./random_image.sh -x 100 -y 100 -f test.jpg

will produce

![test][test]

    $ ./random_image.sh -x 100 -y 100 -m swirl -f test2.jpg

will produce

![test2][test2]

# clone_or_pull.py 

creates a directory for a given github user and clones every repository into it.
If the directory is available, a `git pull` is tried.

    $ ./clone_or_pull.py -u enter-haken

# picsum.sh

downloads some random images from [picsum.photos](https://picsum.photos/) an save them with an uuid + .jpg

    $ ./picsum.sh
      % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                     Dload  Upload   Total   Spent    Left  Speed
    100  5151    0  5151    0     0  21197      0 --:--:-- --:--:-- --:--:-- 21197
    --2019-05-20 15:10:35--  https://picsum.photos/id/0/5616/3744
    Resolving picsum.photos (picsum.photos)... 104.37.178.1
    Connecting to picsum.photos (picsum.photos)|104.37.178.1|:443... connected.
    HTTP request sent, awaiting response... 200 OK
    Length: 997119 (974K) [image/jpeg]
    Saving to: ‘0de7ff9e-f174-43df-94e5-c9830dce8e1c.jpg’
    
    0de7ff9e-f174-43df-94e5-c9830dce 100%[==========================================================>] 973.75K  5.05MB/s    in 0.2s
    
    2019-05-20 15:10:35 (5.05 MB/s) - ‘0de7ff9e-f174-43df-94e5-c9830dce8e1c.jpg’ saved [997119/997119]

    ...

    $ ls -1
    00dbbf9d-c869-4bc2-85e5-90ea01746b3d.jpg
    0108769e-e510-442f-a30f-bdc520023a40.jpg
    0de7ff9e-f174-43df-94e5-c9830dce8e1c.jpg
    ...


Contact
-------

Jan Frederik Hake, <jan_hake@gmx.de>. [@enter_haken](https://twitter.com/enter_haken) on Twitter.

[stack]: https://docs.haskellstack.org/en/stable/install_and_upgrade
[hakyll]: https://jaspervdj.be/hakyll
[test]: test.jpg
[test2]: test2.jpg
