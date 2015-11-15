# Duplicati #
Duplicati is a backup client that securely stores encrypted, incremental, compressed backups on cloud storage services and remote file servers. It works with Amazon S3, Windows Live SkyDrive, Google Drive (Google Docs), Rackspace Cloud Files or WebDAV, SSH, FTP (and many more). Duplicati is open source and free.

Duplicati has built-in AES-256 encryption and backups can be signed using GNU Privacy Guard. A built-in scheduler makes sure that backups are always up-to-date. Last but not least, Duplicati provides various options and tweaks like filters, deletion rules, transfer and bandwidth options to run backups for specific purposes.

Duplicati is licensed under LGPL and available for Windows and Linux (.NET 2.0+ or Mono required). The Duplicati project was inspired by duplicity. Duplicati and duplicity are similar but not compatible. Duplicati is available in English, Spanish, French, German, Danish, Portugese, Italian, and Chinese.

### Duplicati Features ###
* Duplicati uses AES-256 encryption (or GNU Privacy Guard) to secure all data before it is uploaded.
* Duplicati uploads a full backup initially and stores smaller, incremental updates afterwards to save bandwidth and storage space.
* A scheduler keeps backups up-to-date automatically.
* Encrypted backup files are transferred to targets like FTP, Cloudfiles, WebDAV, SSH (SFTP), Amazon S3 and others.
* Duplicati allows backups of folders, document types like e.g. documents or images, or custom filter rules. 
* Duplicati is available as application with an easy-to-use user interface and as command line tool.
* Duplicati can make proper backups of opened or locked files using the Volume Snapshot Service (VSS) under Windows or the Logical Volume Manager (LVM) under Linux. This allows Duplicati to back up the Microsoft Outlook PST file while Outlook is running.

Now, run Duplicati in docker:

`docker run --rm -v /data_folder:/backup_folder:ro intersoftlab/duplicati backup /backup_folder <target url>`

###Дополнительные параметры###

* `-e LC_ALL=<CODEPAGE>`

[Command Line Howto](https://code.google.com/p/duplicati/wiki/CommandLineHowto)

