[![](https://images.microbadger.com/badges/image/intersoftlab/duplicati.svg)](https://microbadger.com/images/intersoftlab/duplicati "Get your own image badge on microbadger.com")

# Supported tags and respective Dockerfile links #
  - `1.3.4` [(Dockerfile)](https://github.com/dmitryint/docker-duplicati/blob/duplicati_1.3.4/Dockerfile)
  - `1.3.4-dev` [(Dockerfile)](https://github.com/dmitryint/docker-duplicati/blob/duplicati_1.3.4-dev/Dockerfile)
  - `2.0` [(Dockerfile)](https://github.com/dmitryint/docker-duplicati/blob/duplicati_2.0/Dockerfile)

  - `canary`, `latest` [(Dockerfile)](https://github.com/dmitryint/docker-duplicati/blob/duplicati_canary/Dockerfile)
  
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

### Getting Help ###
* [Oficial duplicati wiki](https://github.com/duplicati/duplicati/wiki)
* Get command-line help
```bash
docker run --rm -it \
    -v /root/.config/Duplicati/:/root/.config/Duplicati/ \
    -v /data:/data \
    -e MONO_EXTERNAL_ENCODINGS=UTF-8 \
    intersoftlab/duplicati:canary help
```

### Start duplicati with web interface ###
To start with the web interface, run the following command:
```bash
docker run --rm -it \
    -v /root/.config/Duplicati/:/root/.config/Duplicati/ \
    -v /data:/data \
    -e DUPLICATI_PASS=duplicatiPass \
    -e MONO_EXTERNAL_ENCODINGS=UTF-8 \
    -p 8200:8200 \
    intersoftlab/duplicati:canary
```

Here you can see more [examples](examples).

### Initializing a fresh instance ###
When a container is started for the first time, it will execute files with extensions .sh, .sqlite that are found in `/docker-entrypoint-init.d`. Files will be executed in alphabetical order.
You can easily populate your Duplicati configuration by mounting configuration files into that directory.

### Known errors ###

- **Error massage:** `The authorization header is malformed; the Credential is mal-formed; expecting "/YYYYMMDD/REGION/SERVICE/aws4_request".`

  **Discussion there:** https://github.com/duplicati/duplicati/issues/2603

  **Workaround:** start Docker container with the following option: `-v /etc/localtime:/etc/localtime:ro`
