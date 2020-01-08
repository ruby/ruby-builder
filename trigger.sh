#!/bin/sh
tag=builds-with-bundler
git tag "$tag"
git push origin "$tag"
