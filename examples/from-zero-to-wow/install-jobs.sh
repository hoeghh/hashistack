#!/bin/bash

export NOMAD_ADDR=http://10.18.3.10:4646

# nomad job run jobs/http-echo.nomad 
nomad job run jobs/consul.nomad 
# nomad job run jobs/consul.nomad 