FROM mono:4
MAINTAINER Dmitry  K "d.p.karpov@gmail.com"

ADD ./entrypoint.sh /entrypoint.sh

ENV DUPLICATI_VER 2.0.1.52_canary_2017-03-13

ENV D_CODEPAGE UTF-8 
ENV D_LANG en_US

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
ENV DEBIAN_FRONTEND noninteractive

ENV HOME /root

RUN echo 'Acquire::ForceIPv4 "true";' | tee /etc/apt/apt.conf.d/99force-ipv4 && \
apt-get update && \
apt-get -y -o Dpkg::Options::="--force-confold" install --no-install-recommends \
    expect \
    libsqlite3-0 \
    unzip \
    locales && \
curl -sSL https://updates.duplicati.com/canary/duplicati-${DUPLICATI_VER}.zip -o /duplicati-${DUPLICATI_VER}.zip && \
unzip duplicati-${DUPLICATI_VER}.zip -d /app && \
rm /duplicati-${DUPLICATI_VER}.zip && \
apt-get purge -y --auto-remove unzip && \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Issues with CloudFiles, Skydrive, GoogleDocs and S3
# CloudFiles, Skydrive, GoogleDocs and S3 use SSL which requires you to trust their certificate issuer. 
# Run this command to let Mono use the same certificates that Mozilla (Firefox) uses:
# https://code.google.com/p/duplicati/wiki/LinuxHowto#Issues_with_,_Skydrive,_and_S3
# /usr/bin/mozroots --import --sync 
RUN /usr/bin/mozroots --import --sync

# Set locale (fix the locale warnings)
RUN localedef -v -c -i ${D_LANG} -f ${D_CODEPAGE} ${D_LANG}.${D_CODEPAGE} || : && \
update-locale LANG=${D_LANG}.${D_CODEPAGE}

RUN mkdir -p /docker-entrypoint-init.d
RUN chmod +x /entrypoint.sh

VOLUME /root/.config/Duplicati
VOLUME /docker-entrypoint-init.d

EXPOSE 8200
ENTRYPOINT ["/entrypoint.sh"]

