#!/bin/bash

SYNCH_DIR=$1
BACKUP_DIR=$2

SYNCH_DIR_CONTENT=($(ls $SYNCH_DIR))
BACKUP_DIR_CONTENT=($(ls $BACKUP_DIR))

#copy files from forsynch directory to backup directory
for synch_file in ${SYNCH_DIR_CONTENT[@]}
do
 ADD_TO_LOG=1
 for backup_file in ${BACKUP_DIR_CONTENT[@]}
  do
   if [ $synch_file == $backup_file ]
    then
     ADD_TO_LOG=0
     break
   fi
  done
 if [ $ADD_TO_LOG -eq 1 ]
  then
   echo " `date +%F` `date +%H`:`date +%M` added  $synch_file" >> "$BACKUP_DIR/task3.log"
  fi
 cp "$SYNCH_DIR/$synch_file" "$BACKUP_DIR/$synch_file"
done


#remove files from backup directory if they removed from forsynch directory
for backup_file in ${BACKUP_DIR_CONTENT[@]}
 do
  NEED_TO_REMOVE=0
  for synch_file in ${SYNCH_DIR_CONTENT[@]}
   do
    if [ $backup_file == $synch_file ]
     then
      NEED_TO_REMOVE=0
      break
     else
      NEED_TO_REMOVE=1
    fi
   done
 if [ $NEED_TO_REMOVE -eq 1 ] && [ $backup_file != "task3.log" ]
  then
   rm "$BACKUP_DIR/$backup_file"
   echo " `date +%F` `date +%H`:`date +%M` removed  $backup_file" >> "$BACKUP_DIR/task3.log"
  fi
done

