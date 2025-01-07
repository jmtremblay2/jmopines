#!/bin/bash

# might want to deploy not the latest and greatest so separate script to update
git pull
git submodule update --init --recursive