FROM centos:6

ARG LEANOTE_VERSION=2.6.1
ARG LEANOTE_BINARY=https://jaist.dl.sourceforge.net/project/leanote-bin/2.6.1/leanote-linux-amd64-v2.6.1.bin.tar.gz

RUN yum install -y wget

RUN mkdir -p /app/leanote/data/logs \
    && mkdir -p /app/install_tmp \
    && mkdir -p /app/leanote/data/conf

RUN cd /app/install_tmp \
    && wget -c https://jaist.dl.sourceforge.net/project/leanote-bin/${LEANOTE_VERSION}/leanote-linux-amd64-v${LEANOTE_VERSION}.bin.tar.gz -O /app/install_tmp/leanote-linux-amd64.tar.gz \
    && tar -xzf leanote-linux-amd64.tar.gz -C /app \
    && cd /app && rm -rf install_tmp

RUN mkdir -p /app/leanote/data/public/upload \
    && mkdir -p /app/leanote/data/files \
    && mkdir -p /app/leanote/data/mongodb_backup \
    && ln -s /app/leanote/data/public/upload /app/leanote/public/upload \
    && ln -s /app/leanote/data/files /app/leanote/files \
    && ln -s /app/leanote/mongodb_backup /app/leanote/data/mongodb_backup \
    && ln -s /app/leanote/conf /app/leanote/data/conf

RUN chmod -R 755 /app/leanote/bin/

VOLUME ["/app/leanote/data/public/upload","/app/leanote/data/files","/app/leanote/data/conf"]

EXPOSE 9000

CMD ["sh","/app/leanote/bin/run.sh"]