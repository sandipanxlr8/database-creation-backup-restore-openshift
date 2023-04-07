
FROM mariadb:10.2

COPY backup.sh /opt/backup.sh

RUN chmod a+x /opt/backup.sh

ENTRYPOINT /opt/backup.sh
