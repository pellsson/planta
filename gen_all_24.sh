cd $(dirname $0)

span=$((24*60)) # 24 hours
duration=30 # 1 minute duration
fps=20 # 20 fps
out=24hrs.mp4
find /dev/v4l/by-id/ -type l -printf "%f\n" | xargs -I{} sh gen_vid.sh images/{} $span $duration $fps $out
