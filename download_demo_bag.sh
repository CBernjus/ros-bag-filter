#!/bin/bash

# Check if the file 'demo.bag' already exists
if [ -f "demo.bag" ]; then
  echo "The file 'demo.bag' already exists."
else
  # Download the demo bag file
  wget https://storage.googleapis.com/cruise-webviz-public/demo.bag
fi