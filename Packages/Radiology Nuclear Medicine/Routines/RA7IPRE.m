RA7IPRE ;HIRMFO/GJC - Pre-init Driver patch seven ;02/01/99  08:04
VERSION ;;5.0;Radiology/Nuclear Medicine;**7**;Mar 16, 1998
 Q:'$D(XPDNM)  ; must be in KIDS to run this software
EN1 ; This entry point will delete the Exam Status (#3) field
 ; from the Examinations (#70.03) sub-file.  The new data
 ; dictionary will have the new "AE" cross reference defined.
 ; The code to delete the Exam Status field will not delete
 ; the data linked to that field. (cross references will not
 ; be effected)
 Q:'$D(XPDNM)  ; must be in KIDS to run this software
 K %,%Z,DA,DIC,DIK,X,Y
 S DIK="^DD(70.03,",DA(1)=70.03,DA=3 D ^DIK
 K %,%Z,DA,DIC,DIK,X,Y
 Q
