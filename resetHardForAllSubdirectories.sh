#!/bin/bash
ls | xargs -I{} git -C {} reset --hard 
