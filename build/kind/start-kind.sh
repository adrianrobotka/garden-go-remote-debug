#!/bin/bash

set -e

cd "$(dirname "$0")"
kind create cluster --config cluster.yml --wait=4m
