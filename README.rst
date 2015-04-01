================================
Azure Media Watermarking Service
================================

:Info: A simple concept service to visibly watermark media uploaded via FTP and serve it from Azure Blob storage.
:Author: Steven Challis <http://schallis.com>
:Requires: Ubuntu, vsftpd, libav-tools, inotify-tools, Azure account, python-azure

Flow
====
FTP -> iNotify -> Detect media type -> Watermark -> Upload to Blob storage ->
Email user

.. image:: https://github.com/schallis/azure-watermarking-service/raw/master/flow.png

Setup
=====

Set up an Ubuntu VM on Azure and a storage account. You'll want to open TCP
ports endpoints 25003-25006 on the VM and enable public sharing on the storage
account container. A config file is included for vsftp which can be modified
and installed in `/etc/vsftpd.conf`

.. code-block:: shell:::

    apt-get install vsftpd libav-tools inotify-tools
    mkdir -p /srv/ftp/in /srv/ftp/out
    # install Upstart script
    sudo mv trigger.conf /etc/init/
    sudo chmod 644 /etc/init/trigger.conf
    sudo start trigger


Running
=======
Daemonize trigger process and log with:

.. code-block:: shell:::

    sudo start trigger
    tailf /var/log/syslog


Getting metadata field
======================

.. code-block:: shell:::
    xsltproc transform.xsl <metadata.xml> | xpath -q -e '//<field_name>/text()'
