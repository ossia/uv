#!/bin/bash

rm *.zip
export UV_VERSION=0.6.17
export UV_URL=https://github.com/astral-sh/uv/releases/download/$UV_VERSION
for UV_ARCH in uv-x86_64-apple-darwin.tar.gz uv-x86_64-pc-windows-msvc.zip uv-x86_64-unknown-linux-gnu.tar.gz uv-aarch64-pc-windows-msvc.zip uv-aarch64-unknown-linux-gnu.tar.gz uv-aarch64-apple-darwin.tar.gz; do

    mkdir -p uv
    (
        cd uv
        curl -L $UV_URL/$UV_ARCH -o $UV_ARCH
        
        if [[ $UV_ARCH  =~ \.zip$ ]]; then
          unzip $UV_ARCH
        elif  [[ $UV_ARCH  =~ \.gz$ ]]; then
          tar xaf $UV_ARCH
          mv ./*/* .
        fi
        rm uvx*
        rm *.zip
        rm *.tar.gz
        find . -type d -exec rm -rf {} \;
        cp ../addon.json .

        ARCH_NOEXT=$(basename $(basename $UV_ARCH .zip) .tar.gz)
        ARCH_NOEXT=$(echo ${ARCH_NOEXT}|sed 's/uv-//')

        7z a ../$ARCH_NOEXT.zip addon.json uv*
    )
    rm -rf uv
done
