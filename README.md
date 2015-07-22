# Redis Backup

To restore:

    service redis-server stop
    s3cmd get s3://<bucket>/redis-<date>.rdb /var/lib/redis/redis.rdb --force
    service redis-server start


# Elasticsearchd Backup

To restore:

    curl -XPOST 'http://localhost:9200/_snapshot/s3_backups/snapshot_YYYY-MM-DD/_restore'

The restore process will run in the backround

# PostgreSQL Backup

To restore:

    su postgres
    cd ~
    service postgresql stop
    envdir /etc/wal-e.d/env /home/wal-e/wal-e/bin/wal-e backup-fetch /var/lib/postgresql/9.3/main/ LATEST

Now create a `recovery.conf` in `/var/lib/postgresql/9.3/main/recovery.conf` with:

    restore_command = 'envdir /etc/wal-e.d/env /home/wal-e/wal-e/bin/wal-e wal-fetch "%f" "%p"'

And run

    service postgresql start

After successful restore, the `recovery.conf` file will be automatically
renamed to `recovery.done`.
