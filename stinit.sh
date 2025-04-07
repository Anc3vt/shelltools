#!/bin/bash

export ST_USER_HOME=~/.shelltools
mkdir -p $ST_USER_HOME

touch $ST_USER_HOME/env

. $ST_USER_HOME/env
. $ST_HOME/functions

export PATH=$PATH:$ST_HOME/
export PATH=$PATH:$ST_HOME/common
export PATH=$PATH:$ST_HOME/run
