================================
Azure Media Watermarking Service
================================

:Info: A simple concept service to visibly watermark media uploaded via FTP and serve it from Azure Blob storage.
:Author: Steven Challis <http://schallis.com>
:Requires: Ubuntu, vsftpd, libav-tools, inotify-tools, Azure account,
python-azure

Flow
====
FTP -> iNotify -> Detect media type -> Watermark -> Upload to Blob storage ->
Email user

.. image::
https://github.com/schallis/azure-watermarking-service/raw/master/flow.png

Setup
=====
.. code-block:: shell:::

    apt-get install vsftpd libav-tools inotify-tools
    mkdir -p /srv/ftp/in /srv/ftp/out

Running
=======
Daemonize trigger process and log with:

.. code-block:: shell:::

    export AZURE_STORAGE_ACCOUNT=<account>
    export AZURE_STORAGE_ACCESS_KEY='<key>'
    ./trigger.sh > /var/log/trigger.log 2>&1 &
    tailf /var/log/trigger.log


Kill with:

.. code-block:: shell:::

    killall trigger.log
