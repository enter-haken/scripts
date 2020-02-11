#!/usr/bin/env bash
ls | xargs -I{} git -C {} pull
