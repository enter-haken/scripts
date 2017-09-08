#!/bin/bash
ls | xargs -I{} git -C {} pull
