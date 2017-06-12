PXRMSTAT ; SLC/PKR - Routines for dealing with status. ;11-Jun-2015 11:13;du
 ;;2.0;CLINICAL REMINDERS;**4,1005**;Feb 04, 2005;Build 23
 ;IHS/MSC/MGH Add IHS problem statuses
 ;===============================================
DEFAULT(FILENUM,STATUSA) ;Given the file number return the default
 ;statuses.
 ;Outpatient medications
 I FILENUM=52 D  Q
 . S STATUSA(0)=5,STATUSA(1)="ACTIVE",STATUSA(2)="DISCONTINUED"
 . S STATUSA(3)="DISCONTINUED (EDIT)",STATUSA(4)="EXPIRED"
 . S STATUSA(5)="SUSPENDED"
 ;
 ;Inpatient medications
 I FILENUM=55 D  Q
 . S STATUSA(0)=4,STATUSA(1)="ACTIVE",STATUSA(2)="DISCONTINUED (EDIT)"
 . S STATUSA(3)="DISCONTINUED (RENEWAL)",STATUSA(4)="EXPIRED"
 ;
 ;Non-VA meds
 I FILENUM="55NVA" D  Q
 . S STATUSA(0)=1,STATUSA(1)="ACTIVE"
 ;
 ;Radiology procedures
 I FILENUM=70 D  Q
 .  S STATUSA(0)=1,STATUSA(1)="COMPLETE"
 ;
 ;Orders
 I FILENUM=100 D  Q
 .  S STATUSA(0)=2,STATUSA(1)="ACTIVE",STATUSA(2)="PENDING"
 ;
 ;Problem List
 I FILENUM=9000011 D  Q
 . S STATUSA(0)=4,STATUSA(1)="A"
 . ;IHS/MSC/MGH Add IHS statuses
 . S STATUSA(2)="S",STATUSA(3)="E",STATUSA(4)="O"
 Q
 ;
 ;===============================================
GETSTATI(FILENUM,FINDPA,STATUSA) ;Return the list of statuses to search
 ;for in the array STATUSA. STATUSA(0) will contain the number found.
 N IND,NUM
 K STATUSA
 S (IND,NUM)=0
 ;Do Problem List first because it is a special case.
 I FILENUM=9000011 D  Q
 . N STAT
 . F  S IND=+$O(FINDPA(5,IND)) Q:IND=0  D
 .. S STAT=$S(FINDPA(5,IND)="ACTIVE":"A",FINDPA(5,IND)="INACTIVE":"I",1:"")
 .. I STAT'="" D
 ...I STAT="A" D ADDSTAT
 ...I STAT="I" S NUM=NUM+1,STATUSA(NUM)="I"
 . I NUM>0 S STATUSA(0)=NUM
 . ;I NUM=0 S STATUSA(0)=1,STATUSA(1)="A"
 . I NUM=0 D ADDSTAT S STATUSA(0)=NUM
 .;If the status multiple is not defined check USE INACTIVE PROBLEMS
 . I '$D(FINDPA(5)),$P($G(FINDPA(0)),U,9) S STATUSA(0)=2,STATUSA(2)="I"
 ;
 ;See if a status list is defined, if it is use it.
 F  S IND=+$O(FINDPA(5,IND)) Q:IND=0  D
 . S NUM=NUM+1,STATUSA(NUM)=FINDPA(5,IND)
 I NUM>0 S STATUSA(0)=NUM Q
 ;
 ;If no list is defined set the default statuses.
 D DEFAULT(FILENUM,.STATUSA)
 Q
 ;
ADDSTAT ;Add active statuses
 S NUM=NUM+1,STATUSA(NUM)="A"
 S NUM=NUM+1,STATUSA(NUM)="E"
 S NUM=NUM+1,STATUSA(NUM)="S"
 S NUM=NUM+1,STATUSA(NUM)="O"
 Q
