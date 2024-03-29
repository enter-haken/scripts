scripts
=======

some scripts for daily usage

### `battery_power.sh`

Shows the current state of the battery for a notebook.

### `pullAllSubdirectoryies.sh`

make a `git pull` on all subdirectories.

    #!/bin/bash
    ls | xargs -I{} git -C {} pull

This script is quiet simple. See also [`clone_or_pull`](clone_or_pull.py)

### `lock.sh`

locks the current stream when 

    xscreensaver &

is activated.

### `docker_reset.sh`

This script is a kind of hard reset for all docker containers

    #!/bin/bash
    
    sudo /etc/init.d/docker stop
    sudo rm /var/lib/docker/ -rf
    sudo /etc/init.d/docker start

use with care.

### `schema.sh`

generate erm like database schema from postgresql db

    $ schema.sh | dot -Tpng > schema.png

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)


### `init_db`

generate some inital sql files for bootsrapping a postgres database

    $ init_db.sh -u postgres -s test -d postgres

* `-u|--user` database user (default: `postgres`)
* `-d|--database` database name (default: `postgres`)
* `-s|--schema` database schema (default: `public`)

### `init_phoenix`

generate a new elixir phoenix application with react frontend

    $ init_phoenix.sh -n application_name -s "Application name" -l "Application name - This name is shown in the app bar"

### `generate_react_makefile`

    $ generate_react_makefile.sh

This scripts generates a `Makefile` around a `create-react-app` application.

### `generate_elixir_makefile`

    $ generate_elixir_makefile.sh

This script generates a scaffolding `Makefile` for an `elixir` application.

### `init_book`

generate some inital markdown files for bootstrapping a book

    init_book.sh -a "Jan Frederik Hake" -t "Awesome book" -f awesome

* `-a|--author` author of the book (mandatory)
* `-t|--title` book title (mandatory)
* `-f|--filename` filename used for the pdf / tex file without any extension (mandatory)
* `-v|--pdfviewer` default pdf viewer (default `evince`)

### `init_hakyll`

generate a scaffold for a [hakyll][hakyll] project.

    $ ./init_hakyll.sh -n project_name

* - n|--name project name

This script needs [stack][stack] installed.

### `updateLicenseIfNecessary`

    $ updateLicenseIfNecessary.sh

Updates the years for a project with a MIT license.

e.g:

    The MIT License (MIT)
    Copyright (c) 2016,2017,2018 Jan Frederik Hake
    
    Permission is hereby granted, free of charge, to any person obtaining a copy ...

### `myip.sh`

gets your current external ip address

    #!/bin/bash
    curl -s https://ipinfo.io/ip 

### `brightness.sh`

sets the backlight value for intel displays

     $ sudo ./brightness.sh -v 3000

sets the`/sys/class/backlight/intel_backlight/brightness` value to 3000

### `random_image.sh`

gets a randomly generated image 

    $ ./random_image.sh -x 100 -y 100 -f test.jpg

will produce

![test][test]

    $ ./random_image.sh -x 100 -y 100 -m swirl -f test2.jpg

will produce

![test2][test2]

### `clone_or_pull.py`

Creates a directory for a given github user and clones every repository into it.
If the directory is available, a `git pull` is tried.

    usage: clone_or_pull [-h] -u USER [-f]
    
    gets days left in relation to a given date 
    
    optional arguments:
      -h, --help            show this help message and exit
      -u USER, --user USER  github user name (default: None)
      -f, --with-forks      include forked repositories (default: False)

It also creates a file `repo_descriptions.txt` with a list of repositories and their descriptions.
Only the repositories with a description will be listed.
The `repo_descriptions.txt` file will be recreated on every invocation of `clone_or_pull.py`

Due to the github api has a [rate limit](https://developer.github.com/v3/#rate-limiting) 
for unauthorized request (currently up to 60 request per hour), the clone or pull request will sleep for 
**one hour** when the rate limit is reached. 

When you put the script directory into your path, you can execute it from everywhere within the filesystem.
In my case, I have created an symbolic link `clone_or_pull`, which is in my path.

    $ clone_or_pull -u enter-haken

When you have a folder like `~/src/other/complete` and you like to do a clone or pull 
for all subdirectories you can use a small script like `update_other_repos.sh` as seen below, 
to update multiple users.

### `update_other_repos.sh`

Executes a `clone_or_pull.py` for every subdirectory within the current path.
The result is written to `/tmp/clone_or_pull.log`.

    #!/bin/bash
    
    echo "starting cloning at $(date --iso-8601=seconds)" > /tmp/clone_or_pull.log
    cd ~/src/other/github/
    
    for user in $(ls -1); do
      clone_or_pull -u $user &>> /tmp/clone_or_pull.log
    done
    echo "stoped cloning at $(date --iso-8601=seconds)" >> /tmp/clone_or_pull.log

You can create a cron job (Vixie Cron)

    0 1 * * * ~/.local/bin/update_other_repos.sh

to update all github repositories at 1am every day.

### `get_forks.py`

Get a list of forked repositories for a given github user

    usage: get_forks.py [-h] -u USER
    
    gets a list of forks for a given github user 
    
    optional arguments:
      -h, --help            show this help message and exit
      -u USER, --user USER  github user name (default: None)

### `repo_list.sh`

When you have cloned repositories for several users, you can get an overview with `repo_list.sh`.

    #!/bin/bash
    
    for user in $(ls -1);
    do
      cat $user/repo_desc* | sed -e 's/^/'"$user"'\//';
    done

When you pipe the result to `vim`, you can use the `gf` command to jump directly into the project directory.

    ./repo_list.sh | sort | uniq | vim -

### `picsum.sh`

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

The script

    #!/bin/bash
    for image in $(curl https://picsum.photos/v2/list | jq '.[] | .download_url' -r);
    do
      wget -O $(uuidgen).jpg $image;
    done

uses `jq` for querying the json response.

### `uuid`

This is a shortcut for

    $ cat /proc/sys/kernel/random/uuid

### `remember`

This is a helper script for the [brain project][brain].

It does either preforms a search like

    $ remember.sh -s linux

or shows the complete `brain`

    $ remember.sh

Take a look at the [brain project][brain] for further information.

### `html`

generates html files from markdown documents using milligram css framework.

```
creating Makefile
create package.json

please install pandoc, nodejs and inotifywait before proceeding

start editing index.md

* make: build index.html
* make clean: delete build artefacts
* make wait: build index.html when index.md is saved
```

when you want to see the result, you can start a local web server.

```
$ python -m http.server
Serving HTTP on 0.0.0.0 port 8000 (http://0.0.0.0:8000/) ...
```

Contact
-------

[hake.one](https://hake.one). Jan Frederik Hake, <jan_hake@gmx.de>. [@enter_haken](https://twitter.com/enter_haken) on Twitter. [enter-haken#7260](https://discord.com) on discord.

[stack]: https://docs.haskellstack.org/en/stable/install_and_upgrade
[hakyll]: https://jaspervdj.be/hakyll
[test]: test.jpg
[test2]: test2.jpg
[brain]: https://github.com/enter-haken/brain/
