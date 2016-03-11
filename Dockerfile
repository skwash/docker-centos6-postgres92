FROM centos:centos6

RUN yum -y install epel-release; yum clean all
RUN yum -y install https://download.postgresql.org/pub/repos/yum/9.2/redhat/rhel-7-x86_64/pgdg-redhat92-9.2-2.noarch.rpm
RUN yum -y update

RUN yum install -y  postgresql92-server postgresql92-contrib

RUN /sbin/ifconfig

ENV PGDATA /pgdata

RUN mkdir $PGDATA
RUN chown postgres $PGDATA
RUN su -c - postgres /usr/pgsql-9.2/bin/initdb

# open up tcp access
RUN echo "host all all 0.0.0.0/0 md5" > $PGDATA/pg_hba.conf
# needed to createuser below
RUN echo "local all postgres trust" >> $PGDATA/pg_hba.conf

# superuser account
ENV SUPERUSER god
ENV SUPERPASS godmode

EXPOSE 5432

USER postgres

ENTRYPOINT ["/usr/pgsql-9.2/bin/postgres", "-i", "-c", "logging_collector=off"]
