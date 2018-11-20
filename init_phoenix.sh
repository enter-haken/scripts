#!/bin/bash

# https://stackoverflow.com/questions/192249/how-do-i-parse-command-line-arguments-in-bash

POSITIONAL=()
while [[ $# -gt 0 ]]
do
    key="$1"

    case $key in
        -n|--name)
            NAME="$2"
            shift 2 # shift to next parameter
            ;;
        -l|--long-display-name)
            LONG_DISPLAY_NAME="$2"
            shift 2 # shift to next parameter
            ;;
        -s|--short-display-name)
            SHORT_DISPLAY_NAME="$2"
            shift 2 # shift to next parameter
            ;;


        -h|--help)
            HELP="HELP"
            shift 1 # shift to next parameter
            ;;
    esac
done
set -- "$POSITIONAL[@]"

if [ ! -z "$HELP" ]; then
    echo "init_phoenix"
    echo "============"
    echo ""
    echo "This script generates a scaffolding for creating a phoenix application with react frontend."
    echo ""
    echo "parameters:"
    echo "-n | --name: name of the new application: used in the elixir backend"
    echo "-l | --long-display-name: used in the title tag for the browser"
    echo "-s | --short-display-name: used " 
    echo ""
    exit 0
fi

if [ -z "$NAME" ]; then
    echo "missing mandatory -n | --name"
    exit 1
fi

mix phx.new $NAME --no-brunch --no-html 

cd $NAME

# todo:
# add a suitable list of valid files, which can statically served
ENDPOINT=$(find . -name "endpoint.ex" | grep "^./lib")
sed -i -e '/only:/d' -e 's/gzip: false,/gzip: false/' $ENDPOINT


ROUTER=$(find . -name "router.ex" | grep "^./lib")
WEBMODULE=`cat $ROUTER | head -n 1 | awk '{ print \$2 }' | cut -d. -f1`

ed $ROUTER <<EOT
10a

  scope "/", $WEBMODULE do
    get "/*path", RedirectController, :redirector
  end
.
wq
EOT

cat <<EOT >>$ROUTER

defmodule $WEBMODULE.RedirectController do
  use $WEBMODULE, :controller
  @send_to "/index.html"

  def redirector(conn, _params), do: redirect(conn, to: @send_to)

end
EOT

mix ecto.create

# the Makefile will compile the elixir / phoenix sources
# and the react frontend environment as well
# it can also will deploy the frontend sources to the
# "priv/static" directory of the project.

cat <<EOT >Makefile
.PHONY: default
default: compile

.PHONY: compile
compile:
	if [ ! -d deps ]; then mix deps.get; fi
	if [ -z "\$(ls -A ./priv/static/)" ]; then make -C frontend all; fi
	mix compile --force

.PHONY: clean
clean:
	rm ./deps/ -rf
	rm ./_build/ -rf
	rm ./priv/static/* -rf
	make -C frontend clean

.PHONY: run
run:
	if [ ! -d _build ]; then make; fi
	mix phx.server
EOT

mkdir frontend

# the frontend Makefile can
# * compile the react project
# * deploy the project
# * delete unneccessary files

cat <<EOT >frontend/Makefile
TARGET = '../priv/static'
PACKAGE_MANAGER = 'yarn'

.PHONY: default
default: build

.PHONY: build
build:
	if [ ! -d ./node_modules/ ]; then \$(PACKAGE_MANAGER) install; fi
	\$(PACKAGE_MANAGER) run build

.PHONY: deploy
deploy:
	if [ ! -d \$(TARGET) ]; then mkdir -p \$(TARGET); fi
	if [ ! -d build ]; then make; fi
	rm ../priv/static/* -rf
	
	cp ./build/index.html \$(TARGET)
	cp ./build/robots.txt \$(TARGET)
	cp ./build/favicon.ico \$(TARGET)
	cp ./build/asset-manifest.json \$(TARGET)
	cp ./build/manifest.json \$(TARGET)
	mkdir -p \$(TARGET)/static/js
	cp ./build/static/js/* \$(TARGET)/static/js

.PHONY: clean
clean:
	rm build/ -rf

.PHONY: clean_node_modules 
clean_node_modules:
	rm node_modules/ -rf

.PHONY: deep_clean
deep_clean: clean clean_node_modules

.PHONY: all
all: clean build deploy

.PHONY: run
run: 
	\$(PACKAGE_MANAGER) run start

EOT

# todo:
# replace dependencies with yarn install ....
cat <<EOT >frontend/package.json
{
  "name": "$NAME",
  "version": "0.1.0",
  "private": true,
  "dependencies": {
    "@material-ui/core": "1.1.0",
    "@material-ui/icons": "^1.1.0",
    "phoenix": "^1.3.0",
    "react": "^16.4.0",
    "react-dom": "^16.4.0",
    "react-scripts": "1.1.4",
    "uuid": "^3.2.1"
  },
  "scripts": {
    "start": "react-scripts start",
    "build": "react-scripts build",
    "test": "react-scripts test --env=jsdom",
    "eject": "react-scripts eject"
  }
}
EOT

mkdir frontend/public

cat <<EOT >frontend/public/index.html
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <link rel="manifest" href="%PUBLIC_URL%/manifest.json">
    <link rel="shortcut icon" href="%PUBLIC_URL%/favicon.ico">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Roboto:300,400,500">
    <title>$LONG_DISPLAY_NAME</title>
  </head>
  <body>
   <div id="root"></div>
 </body>
</html>
EOT

cat <<EOT >frontend/public/robots.txt
# See http://www.robotstxt.org/robotstxt.html for documentation on how to use the robots.txt file
#
# To ban all spiders from the entire site uncomment the next two lines:
# User-agent: *
# Disallow: /
EOT

cat <<EOT >frontend/public/manifest.json
{
  "short_name": "$SHORT_DISPLAY_NAME",
  "name": "$LONG_DISPLAY_NAME",
  "icons": [
    {
      "src": "favicon.ico",
      "sizes": "64x64 32x32 24x24 16x16",
      "type": "image/x-icon"
    }
  ],
  "start_url": "./index.html",
  "display": "fullscreen",
  "theme_color": "#000000",
  "background_color": "#ffffff"
}
EOT

cat <<EOT | base64 --decode >frontend/public/favicon.ico
iVBORw0KGgoAAAANSUhEUgAAAEAAAABACAYAAACqaXHeAAAAAXNSR0IArs4c6QAAAAlwSFlzAAAL
EwAACxMBAJqcGAAABCRpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADx4OnhtcG1ldGEgeG1sbnM6
eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IlhNUCBDb3JlIDUuNC4wIj4KICAgPHJkZjpSREYg
eG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4K
ICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIKICAgICAgICAgICAgeG1sbnM6dGlm
Zj0iaHR0cDovL25zLmFkb2JlLmNvbS90aWZmLzEuMC8iCiAgICAgICAgICAgIHhtbG5zOmV4aWY9
Imh0dHA6Ly9ucy5hZG9iZS5jb20vZXhpZi8xLjAvIgogICAgICAgICAgICB4bWxuczpkYz0iaHR0
cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8iCiAgICAgICAgICAgIHhtbG5zOnhtcD0iaHR0
cDovL25zLmFkb2JlLmNvbS94YXAvMS4wLyI+CiAgICAgICAgIDx0aWZmOlJlc29sdXRpb25Vbml0
PjI8L3RpZmY6UmVzb2x1dGlvblVuaXQ+CiAgICAgICAgIDx0aWZmOkNvbXByZXNzaW9uPjU8L3Rp
ZmY6Q29tcHJlc3Npb24+CiAgICAgICAgIDx0aWZmOlhSZXNvbHV0aW9uPjcyPC90aWZmOlhSZXNv
bHV0aW9uPgogICAgICAgICA8dGlmZjpPcmllbnRhdGlvbj4xPC90aWZmOk9yaWVudGF0aW9uPgog
ICAgICAgICA8dGlmZjpZUmVzb2x1dGlvbj43MjwvdGlmZjpZUmVzb2x1dGlvbj4KICAgICAgICAg
PGV4aWY6UGl4ZWxYRGltZW5zaW9uPjY0PC9leGlmOlBpeGVsWERpbWVuc2lvbj4KICAgICAgICAg
PGV4aWY6Q29sb3JTcGFjZT4xPC9leGlmOkNvbG9yU3BhY2U+CiAgICAgICAgIDxleGlmOlBpeGVs
WURpbWVuc2lvbj42NDwvZXhpZjpQaXhlbFlEaW1lbnNpb24+CiAgICAgICAgIDxkYzpzdWJqZWN0
PgogICAgICAgICAgICA8cmRmOkJhZy8+CiAgICAgICAgIDwvZGM6c3ViamVjdD4KICAgICAgICAg
PHhtcDpNb2RpZnlEYXRlPjIwMTUtMDYtMDhUMDg6MDY6NTk8L3htcDpNb2RpZnlEYXRlPgogICAg
ICAgICA8eG1wOkNyZWF0b3JUb29sPlBpeGVsbWF0b3IgMy4zLjI8L3htcDpDcmVhdG9yVG9vbD4K
ICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CiAgIDwvcmRmOlJERj4KPC94OnhtcG1ldGE+CoGHVX4A
AABfSURBVHgB7dABDQAAAMKg909tDjeIQGHAgAEDBgwYMGDAgAEDBgwYMGDAgAEDBgwYMGDAgAED
BgwYMGDAgAEDBgwYMGDAgAEDBgwYMGDAgAEDBgwYMGDAgAEDBgy8DwxAQAABFkGY6wAAAABJRU5E
rkJggg==
EOT

mkdir frontend/src

cat <<EOT >frontend/src/index.js
import React from 'react';
import ReactDOM from 'react-dom';

import App from './App';

ReactDOM.render(<App />, document.getElementById('root'));
EOT

cat <<EOT >frontend/src/App.js
import React, { Component } from 'react';
import AppBar from './AppBar';

class App extends Component {
  render() {
    return (
      <AppBar /> 
    );
  }
}

export default App;
EOT

cat <<EOT >frontend/src/AppBar.js
import React from 'react';
import PropTypes from 'prop-types';
import { withStyles } from '@material-ui/core/styles';
import AppBar from '@material-ui/core/AppBar';
import Toolbar from '@material-ui/core/Toolbar';
import Typography from '@material-ui/core/Typography';
import IconButton from '@material-ui/core/IconButton';
import MenuIcon from '@material-ui/icons/Menu';

const styles = {
  root: {
    flexGrow: 1,
  },
  menuButton: {
    marginLeft: -18,
    marginRight: 10,
  },
};

function DenseAppBar(props) {
  const { classes } = props;
  return (
    <div className={classes.root}>
      <AppBar position="static">
        <Toolbar variant="dense">
          <IconButton className={classes.menuButton} color="inherit" aria-label="Menu">
            <MenuIcon />
          </IconButton>
          <Typography variant="title" color="inherit">
            $LONG_DISPLAY_NAME 
          </Typography>
        </Toolbar>
      </AppBar>
    </div>
  );
}

DenseAppBar.propTypes = {
  classes: PropTypes.object.isRequired,
};

export default withStyles(styles)(DenseAppBar);
EOT

make

echo "generator finished!"
echo ""
echo "change directory to"
echo ""
echo "  $ cd $NAME"
echo ""
echo "and run the application with"
echo ""
echo "  $ make run"
echo ""
echo "enjoy coding!"
