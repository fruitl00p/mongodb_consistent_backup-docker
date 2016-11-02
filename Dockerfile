FROM mongo:3
MAINTAINER Robin Speekenbrink <docker@kingsquare.nl>

ENV RELEASE 1.3.1
ENV SHA f896b8e39796d08d420153587ff3736f0ec81c60
ENV BUILD_DEPS \
    ca-certificates \
    wget \
    make \
    gcc \
    virtualenv

RUN set -x && \
	apt-get update && apt-get install -y --no-install-recommends $BUILD_DEPS python-dev python-virtualenv python && rm -rf /var/lib/apt/lists/* && \
    wget -O /tmp/package.tgz https://github.com/Percona-Lab/mongodb_consistent_backup/archive/$RELEASE.tar.gz && \
    sha1sum /tmp/package.tgz | grep -q $SHA && \
    tar -xvz -C /tmp -f /tmp/package.tgz && \
    rm /tmp/package.tgz && \
    cd /tmp/mongodb_consistent_backup-$RELEASE && \
    make && \
    make install && \
    cd / && \
    rm -rfR /tmp/mongodb_consistent_backup-$RELEASE && \
	apt-get purge -y --auto-remove $BUILD_DEPS

CMD ["/usr/local/bin/mongodb-consistent-backup"]