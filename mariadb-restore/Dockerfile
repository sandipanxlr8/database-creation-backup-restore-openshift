FROM mariadb:10.2

COPY restore.sh /opt/restore.sh

RUN chmod a+x /opt/restore.sh

ENTRYPOINT /opt/restore.sh

