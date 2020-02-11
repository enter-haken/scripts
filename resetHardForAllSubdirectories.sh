#!/usr/bin/env bash
ls | xargs -I{} git -C {} reset --hard 
