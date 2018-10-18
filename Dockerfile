FROM xxyl80/c7-systemd

ARG LEANOTE_VERSION=2.6.1
#ARG LEANOTE_HOME=/app/leanote

RUN yum install -y wget
RUN touch /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "[mongodb-org-3.6]" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "name=MongoDB Repository" >> //etc/yum.repos.d/mongodb-3.6.repo \
    && echo "baseurl=https://repo.mongodb.org/yum/redhat/\$releasever/mongodb-org/3.6/x86_64/" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "gpgcheck=1" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "enabled=1" >> /etc/yum.repos.d/mongodb-3.6.repo \
    && echo "gpgkey=https://www.mongodb.org/static/pgp/server-3.6.asc" \ >> /etc/yum.repos.d/mongodb-3.6.repo \
    && yum install -y mongodb-org

RUN systemctl enable mongod

RUN mkdir -p /app/leanote/install_tmp
RUN cd /app/leanote/install_tmp
RUN wget https://jaist.dl.sourceforge.net/project/leanote-bin/2.6.1/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz
RUN tar -xzvf leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz
RUN cp -r leanote/* /app/leanote
RUN cd /app/leanote
RUN rm -rf install_tmp

#RUN mongorestore -h localhost -d leanote --dir /app/leanote/mongodb_backup/leanote_install_data/

VOLUME ["/app/leanote/"]

EXPOSE 9000

CMD ["sh", "/app/leanote/bin/run.sh"]


