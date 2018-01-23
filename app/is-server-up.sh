#!/bin/bash
if curl 172.17.0.1:3000; then
   exit 0
else
    exit 1
fi
