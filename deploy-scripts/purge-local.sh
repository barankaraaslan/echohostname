#!/bin/sh

kind version && export KIND_PATH=kind || export KIND_PATH=./tmp/bin/kind

$KIND_PATH delete clusters echohostname
docker image rm echohostname
rm -rf tmp