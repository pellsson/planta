cd $(dirname $0)
now=$(date +%Y-%m-%d_%H:%M)
find /dev/v4l/by-id/ -type l -printf "%f\n" | xargs -I{} mkdir -p images/{}
find /dev/v4l/by-id/ -type l -printf "%f\n" | xargs -I{} avconv -f video4linux2 -s 1280x960 -i /dev/v4l/by-id/{} -vframes 1 images/{}/$now.jpg
