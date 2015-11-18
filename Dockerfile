FROM mono:3
MAINTAINER Dmitry  K "d.p.karpov@gmail.com"

ENV D_TIME_ZONE Europe/Moscow
ENV D_CODEPAGE UTF-8 
ENV D_LANG ru_RU

RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo "Acquire::http {No-Cache=True;};" > /etc/apt/apt.conf.d/no-cache
ENV DEBIAN_FRONTEND noninteractive

ENV HOME /root

ADD ./deb/Duplicati.deb /

RUN apt-get update \
&& apt-get -y -o Dpkg::Options::="--force-confold" install --no-install-recommends \
    expect \
    libsqlite3-0 \
    unzip \
    make \
    locales \
&& dpkg -i /Duplicati.deb && rm /Duplicati.deb \
&& mozroots --import --sync \
&& apt-get autoremove -y \
&& apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Set locale (fix the locale warnings)
RUN localedef -v -c -i ${D_LANG} -f ${D_CODEPAGE} ${D_LANG}.${D_CODEPAGE} || :
RUN update-locale LANG=${D_LANG}.${D_CODEPAGE}
RUN echo "${TIME_ZONE}" > /etc/timezone && dpkg-reconfigure --frontend noninteractive tzdata

ENTRYPOINT ["/usr/bin/duplicati-commandline"]

