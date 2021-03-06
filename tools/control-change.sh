#!/bin/bash

service etcd start

service postgresql start

#su postgres -c 'pgbouncer -d /etc/pgbouncer/pgbouncer.ini'
cd /etc/pg_ddm/
source venv/bin/activate
cd admin

if [[ -f "/etc/pg_ddm/mask_ruby/import.rb" ]]; then

    ruby /etc/pg_ddm/mask_ruby/import.rb
    rm -rf /etc/pg_ddm/mask_ruby/import.rb

fi

if [[ -f "/etc/pg_ddm/mask_ruby/mask.sql" ]]; then
    su postgres -c 'psql -d docker < /etc/pg_ddm/mask_ruby/mask.sql'
    rm /etc/pg_ddm/mask_ruby/mask.sql
fi

python3 app.py &
su pg_ddm -c 'pg_ddm /etc/pg_ddm/pg_ddm.ini'
exit
