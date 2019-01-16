#!
echo 'Unmounting /couchdb...'
umount /couchdb
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "(umount command exited with $RETVAL)"
fi 
echo 'Removing mapper device...'
dmsetup remove --retry offchain-db
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "(dmsetup command exited with $RETVAL)"
fi 
echo 'Mounting encrypted volume...'
echo -n $COUCHDB_LUKS_PASSPHRASE | cryptsetup -d - open /dev/offchain-db-crypto offchain-db
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "cryptsetup command exited with $RETVAL"
    exit 2
fi 
echo 'Mounting decrypted volume...'
mount /dev/mapper/offchain-db /couchdb
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "mount command exited with $RETVAL"
    exit 3
fi 
echo 'Starting CouchDB...'
/opt/couchdb/bin/couchdb
RETVAL=$?
if [ $RETVAL -ne 0 ]; then
    echo "couchdb command exited with $RETVAL"
    exit 4
fi 
