#!/bin/sh
INDIR=/srv/ftp/in
OUTDIR=/srv/ftp/out

log () {
    logger "[$(date)] $@"
};

inotifywait -qme close_write -m --format %f $INDIR/ | while read filename; do
    mime=`file --mime-type -b "$INDIR/$filename"`;
    log "Found mime", $mime

    case $mime in
        'video/mp4')
            log "$filename is a video file $mime"
            # Warning: Colons in this string will cause the filter to fail
            avconv -i "$INDIR/$filename" -y -strict experimental -f mp4 \
              -vf drawtext="fontfile=$INDIR/DejaVuSans.ttf:\
                            text='Exported on date %m.%d.%Y':\
                            fontcolor=white@0.5:\
                            fontsize=20:\
                            x=(W-w)/2:y=(H-h)/3:\
                            shadowx=3:shadowy=3:shadowcolor=black" \
              "$OUTDIR/$filename";
              log "Uploading..."
              url=`python upload.py "$filename"`
              log "Uploaded. Available at" $url
            ;;
        'application/pdf')
            log $filename "is a PDF", $mime
            log "Doing nothing."
            ;;
        'image/jpeg')
            log $filename "is a JPEG", $mime
            log "Doing nothing."
            ;;
        *)
            log $filename "has no action defined", $mime
            log "Doing nothing."
            ;;
    esac
done
