FROM centos:6

ARG LEANOTE_VERSION=2.6.1
ARG LEANOTE_BINARY=https://jaist.dl.sourceforge.net/project/leanote-bin/2.6.1/leanote-linux-amd64-v2.6.1.bin.tar.gz

RUN yum install -y curl
RUN touch /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "[mongodb-org-3.6]" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "name=MongoDB Repository" >> //etc/yum.repos.d/mongodb-3.6.repo \
    && echo "baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.6/x86_64/" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" \ >> /etc/yum.repos.d/mongodb-3.6.repo \
    && yum install -y mongodb-org

RUN mkdir -p /app/mongodb/data 
RUN nohup mongod --dbpath /app/mongodb/data >> /app/mongodb/mongodb.log 2>&1 &

RUN mkdir -p /app/install_tmp
RUN cd /app/install_tmp \
    && curl -o /app/install_tmp/leanote-linux-amd64.tar.gz https://jaist.dl.sourceforge.net/project/leanote-bin/2.6.1/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz \
    && tar -xzvf leanote-linux-amd64.tar.gz -C /app \
    && cd /app && rm -rf install_tmp

RUN mkdir -p /app/leanote/data/public/upload \
    && mkdir -p /app/leanote/data/files \
    && mkdir -p /app/leanote/data/mongodb_backup \
    && mkdir -p /app/leanote/mongodb_install_data \
    && cp -r /app/leanote/mongodb_backup /app/leanote/mongodb_install_data \
    && ln -s /app/leanote/data/public/upload /app/leanote/public/upload \
    && ln -s /app/leanote/data/files /app/leanote/files \
    && ln -s /app/leanote/data/mongodb_backup /app/leanote/mongodb_backup 

RUN touch /app/leanote/bin/startLeanote.sh \
    && mkdir /app/leanote/data/logs \
    && echo '#!/bin/bash' >> /app/leanote/bin/startLeanote.sh \
    && echo "cd /app/leanote/bin/ \\" >> /app/leanote/bin/startLeanote.sh \
    && echo "&& nohup ./run.sh >> /app/leanote/data/logs/leanote.log 2>&1 & \\" >> /app/leanote/bin/startLeanote.sh \
    && chmod -R 755 /app/leanote/bin/

RUN mongorestore -h localhost -d leanote --dir /app/leanote/mongodb_backup/leanote_install_data/

VOLUME ["/app/leanote/data","/app/leanote/data/logs"]

EXPOSE 9000

ENTRYPOINT ["/app/leanote/bin/startLeanote.sh"]
