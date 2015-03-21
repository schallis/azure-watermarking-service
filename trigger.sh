#!/bin/sh
INDIR=/srv/ftp/in
OUTDIR=/srv/ftp/out

inotifywait -qme close_write -m --format %f $INDIR/ | while read filename; do
    mime=`file --mime-type -b $INDIR/$filename`;

    case $mime in
        'video/mp4')
            echo $filename "is a video file", $mime
            # Warning: Colons in this string will cause the filter to fail
            avconv -i $INDIR/$filename -y -strict experimental -f mp4 \
              -vf drawtext="fontfile=$INDIR/DejaVuSans.ttf:\
                            text='Exported on date %m.%d.%Y':\
                            fontcolor=white@0.5:\
                            fontsize=20:\
                            x=(W-w)/2:y=(H-h)/3:\
                            shadowx=3:shadowy=3:shadowcolor=black" \
              $OUTDIR/$filename;
              echo "Uploading..."
              url=`python upload.py $filename`;
              echo "Uploaded. Available at" $url
              mail -s "Watermarked file available" "steve@stevechallis.com" <<EOF
Hi,

You requested a watermarked version of $filename which is now
available for download at:

$url

Thank you,

Your friendly Watermarking bot
EOF
              echo "Notified user via email"
            ;;
        'application/pdf')
            echo $filename "is a PDF", $mime
            ;;
        *)
            echo $filename "not recognized", $mime
            ;;
    esac
done
