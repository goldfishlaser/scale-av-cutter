#!/usr/bin/env bash

#### set environment variable for project root ####
project_root=$PWD

#### set asciidoctor version ####
version=2.0.17

#### Create dist/ directory, if none exists ####
if [ ! -r ./dist ]; then
    mkdir dist
fi

#### Create dist/user-manual/ directory, if none exists ####
if [ ! -r ./dist/user_manual ]; then
    mkdir dist/user_manual
fi

#### Copy assets to dist/user_manual
cp -r user_manual/assets dist/user_manual

#### generate landing page as html ####
clitool="asciidoctor"
cmdargs="index.adoc -o dist/index.html"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating landing page as html via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating landing page as html..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

#### generate scale av user manual as html ####
clitool="asciidoctor"
cmdargs="user_manual/index.adoc -o dist/user_manual/index.html -r asciidoctor-diagram"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating scale av cutter user manual as html via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating scale av cutter user manual as html..."
    cd $workdir
    eval $cmd
    cd $project_root
fi

#### generate scale av user manual as pdf ####
clitool="asciidoctor"
cmdargs="user_manual/index.adoc -o dist/user_manual/scale-av-cutter-user-manual.pdf -r asciidoctor-pdf -r asciidoctor-diagram -b pdf"
cmd="$clitool $cmdargs"
workdir=$project_root
podmancmd="podman run --rm -v "$workdir:/src" -w "/src" docker.io/asciidoctor/docker-asciidoctor:1.27.0 $cmd"
condition="$clitool --version | grep $version"

if ! eval $condition; then
    echo "asciidoctor $version not installed"
    echo "generating scale av cutter user manual as pdf via podman..."
    cd $project_root
    eval $(echo $podmancmd)
else
    echo "generating scale av cutter user manual as pdf..."
    cd $workdir
    eval $cmd
    cd $project_root
fi
