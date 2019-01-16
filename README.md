# Sources for CouchDB encryption paper

We use a custom-built docker image that adds cryptsetup to couchdb.  See the Dockerfile for details.

Then we do:

`kubectl create -f offchain-db.yaml`

to start the offchain-db service and deployment.  This maps `/tmp/data/init.sh` and `/dev/offchain-db-crypto` (the encrypted block device), and executes:

```
command: [ "bash", "-c", "/tmp/data/init.sh" ]
```

init.sh executes:

```
echo -n $COUCHDB_LUKS_PASSPHRASE | cryptsetup -d - open /dev/offchain-db-crypto offchain-db
```

using the LUKS passphrase stored in `$COUCHDB_LUKS_PASSPHRASE` (a kubernetes secret).  This maps `/dev/offchain-db-crypto` to the cleartext device `/dev/mapper/offchain-db`.  Then init.sh executes:

```
mount /dev/mapper/offchain-db /couchdb
```
to mount the cleartext device on /couchdb.  Finally, init.sh executes:

```
/opt/couchdb/bin/couchdb
```

to start CouchDB.


          
          

