#!/bin/bash
cd $(dirname $0)

span=$((7*24*60)) # 7 days
duration=30 # 1 minute duration
fps=20 # 20 fps
out=week.mp4
find /dev/v4l/by-id/ -type l -printf "%f\n" | xargs -I{} bash gen_vid.sh images/{} $span $duration $fps $out

