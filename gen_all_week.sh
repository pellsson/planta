cd $(dirname $0)

span=$((7*24*60)) # 7 days
duration=60 # 1 minute duration
fps=20 # 20 fps
out=24hrs.mp4
find /dev/v4l/by-id/ -type l -printf "%f\n" | xargs -I{} sh gen_vid.sh images/{} $span $duration $fps $out

