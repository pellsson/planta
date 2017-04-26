cam=${1?First parameter must be set to cam folder}
span=${2:-$((24*60))} # time span, in minutes
duration=${3:-60}
fps=${4:-20}
out=${5:-$span-$duration-$fps.mp4}

echo "Camera:   $cam"
echo "Span:     $span"
echo "Duration: $duration"
echo "FPS:      $fps"
echo "Outfile:  $out"

first=$(basename $(ls -t $cam/*.jpg | head -1))
first=$(echo $first | sed 's/://') # remove :
first=$(echo $first | sed 's/_/ /') # remove _
first=$(echo $first | sed 's/.jpg//') # remove .jpg

increment=$(($span / ($duration*$fps)))

if [ $increment -eq 0 ];
then
	increment=1
fi

cd $cam

framedir=$(mktemp -d)

echo "Building input list in $framedir..."
frame=1

i=$(($duration * $fps))
while [ $i -ne 0 ];
do
	fn=$(date '+%Y-%m-%d_%H:%M.jpg' -d "$first -$(($i * $increment)) minutes")
	if [ -f $fn ]; then
		ln -s $(pwd)/$fn $framedir/$(printf %08d $frame).jpg
		frame=$(($frame + 1))
	else
		echo "Missing image $fn!"
	fi
	i=$((i - 1))
done

avconv -r $fps -i $framedir/%08d.jpg -c:v libx264 -profile:v high -pix_fmt yuv420p -crf 20 -y $out
rm -fr $framedir

