import sys

from azure.storage import BlobService

CONTAINER='watermarked'

filename = sys.argv[1]
blob_service = BlobService()

# Retrieve/create container
if CONTAINER not in [c.name for c in blob_service.list_containers()]:
    blob_service.create_container(CONTAINER)

# Upload
blob_service.put_blob(CONTAINER, filename,
        file('/srv/ftp/out/' + filename).read(), 'BlockBlob')
url = blob_service.make_blob_url(CONTAINER, filename)

sys.stdout.write(url)
sys.stdout.flush()
sys.exit(0)

