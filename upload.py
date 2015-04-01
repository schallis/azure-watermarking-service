import sys
import smtplib
from email.mime.text import MIMEText

from azure.storage import BlobService

CONTAINER='watermarked'

filename = sys.argv[1]
SERVICE = BlobService()

def ensure_container(name):
    if name not in [c.name for c in SERVICE.list_containers()]:
        SERVICE.create_container(name)

def upload(container, filename):
    SERVICE.put_blob(container, filename,
            file('/srv/ftp/out/' + filename).read(), 'BlockBlob')
    url = SERVICE.make_blob_url(container, filename)
    return url

def send_email(msg)
    you = "steve@stevechallis.com"
    me = "ZONZA Watermarking Bot <stevenchallis@warehouse-db.warehouse-db.b4.internal.cloudapp.net>"
    msg = MIMEText(msg)
    msg['Subject'] = "Watermarked file available"
    msg['From'] = me
    msg['To'] = you

    s = smtplib.SMTP('localhost')
    s.sendmail(me, [you], msg.as_string())
    s.quit()

ensure_container(CONTAINER)
url = upload(CONTAINER, filename)

msg = """
Hi,

You requested a watermarked version of $filename which is now
available for download at:

{0}

Thank you,

The ZONZA watermarking robot
""".format(url)
send_email(msg)

# write URL to stdout for consumption by other apps
sys.stdout.write(url)
sys.stdout.flush()
sys.exit(0)

