PXRMP1I ; SLC/DT/PJH - Inits for PXRM*1.5*1 ;08/25/2000
 ;;1.5;CLINICAL REMINDERS;**1**;Jun 19, 2000
 ;
 Q
 ;
 ;===============================================================
DELDD ;Delete data dictionaries
 N DIU
 S DIU(0)="DT"
 S DIU=810.2
 D EN^DIU2
 ;
 S DIU(0)="T"
 S DIU=810.3
 D EN^DIU2
 Q
 ;
 ;=======================================================================
CHGREM ;Rename previously distributed reminder name
 D CHGRNAM("VA-NATIONAL EPI DB UPDATE","VA-NATIONAL EPI LAB EXTRACT")
 Q
 ;
CHGRNAM(OLD,NEW) ;Rename
 N DA,DIE,DR,X
 S DA=$O(^PXD(811.9,"B",OLD,"")) Q:'DA
 S DIE="^PXD(811.9,",DR=".01///^S X=NEW"
 D ^DIE
 Q
 ;
 ;=======================================================================
CHGHFNM ;Rename previously distributed health factor
 I $D(^AUTTHF("B","PREV POS TEST FOR HEP C")) D
 . D CHGHFNAM("PREV POS TEST FOR HEP C","PREV POSITIVE TEST FOR HEP C")
 Q
 ;
CHGHFNAM(OLD,NEW) ;Change health factor name
 N DA,DIE,DR,X
 S DA=$O(^AUTTHF("B",OLD,"")) Q:'DA
 S DIE="^AUTTHF(",DR=".01///^S X=NEW"
 D ^DIE
 Q
 ;
 ;=======================================================================
CHGTRM ;Rename previously distributed reminder term
 I $D(^PXRMD(811.5,"B","HBs Ab")) D
 . D CHGTNAM("HBs Ab","HBs Ab positive")
 I $D(^PXRMD(811.5,"B","HBe Ag")) D
 . D CHGTNAM("HBe Ag","HBe Ag positive")
 I $D(^PXRMD(811.5,"B","PREV POSITIVE TEST FOR HEP C")) D
 . D CHGTNAM("PREV POSITIVE TEST FOR HEP C","PREVIOUSLY ASSESSED HEP C RISK")
 Q
 ;
 ;=======================================================================
CHGTNAM(OLD,NEW) ;Change term name
 N DA,DIE,DR,X
 S DA=$O(^PXRMD(811.5,"B",OLD,"")) Q:'DA
 S DIE="^PXRMD(811.5,",DR=".01///^S X=NEW"
 D ^DIE
 Q
 ;
 ;===============================================================
PRE ;These are the pre-installation actions
 ;Change national term and definition names related to EPI update
 S PXRMINST=1
 D CHGREM
 D CHGTRM
 D CHGHFNM
 D DELDD
 Q
 ;
 ;======================================================================
POST ;These are the post-installation actions
 D DDUP("PREV POSITIVE TEST FOR HEP C")
 D CTERMS
 K PXRMINST
 Q
 ;
 ;=======================================================================
CTERMS ;Connect the terms to findings.
 N REMIEN,TERMLIST
 S REMIEN=$O(^PXD(811.9,"B","VA-HEP C RISK ASSESSMENT",""))
 D TERMLIST(REMIEN,.TERMLIST)
 D HFTERMS(REMIEN,.TERMLIST)
 Q
 ;
 ;=======================================================================
DDUP(NAME) ;Delete duplicates
 N FIRST,SUB
 S SUB=0,FIRST=1
 F  S SUB=$O(^AUTTHF("B",NAME,SUB)) Q:'SUB  D
 .I FIRST S FIRST=0 Q
 .N DA,DIK,Y
 .S DA=SUB,DIK="^AUTTHF(" D ^DIK
 Q
 ;
 ;=======================================================================
HFTERMS(REMIEN,TERMLIST) ;Connect terms using health factors.
 N HFIEN
 S HFIEN=$O(^AUTTHF("B","PREV POSITIVE TEST FOR HEP C",""))
 K FDA,FDAIEN
 S FDAIEN(1)=TERMLIST("PREVIOUSLY ASSESSED HEP C RISK")
 S FDA(811.5,"?1,",.01)="PREVIOUSLY ASSESSED HEP C RISK"
 S FDA(811.5,"?1,",.02)="N"
 S FDA(811.52,"?+2,?1,",.01)=HFIEN_";AUTTHF("
 D UPDATE(.FDA,.FDAIEN)
 ;
 ;S HFIEN=$O(^AUTTHF("B","RISK FACTOR FOR HEPATITIS C",""))
 ;K FDA,FDAIEN
 ;S FDAIEN(1)=TERMLIST("RISK FACTOR FOR HEPATITIS C")
 ;S FDA(811.5,"?1,",.01)="RISK FACTOR FOR HEPATITIS C"
 ;S FDA(811.5,"?1,",.02)="N"
 ;S FDA(811.52,"?+2,?1,",.01)=HFIEN_";AUTTHF("
 ;D UPDATE(.FDA,.FDAIEN)
 Q
 ;
 ;=======================================================================
TERMLIST(REMIEN,TERMLIST) ;Build the list of terms in the reminder.
 N TERM,TERMNAME
 S TERM=""
 F  S TERM=$O(^PXD(811.9,REMIEN,20,"E","PXRMD(811.5,",TERM)) Q:+TERM=0  D
 . S TERMNAME=$P(^PXRMD(811.5,TERM,0),U,1)
 . S TERMLIST(TERMNAME)=TERM
 Q
 ;
 ;=======================================================================
UPDATE(FDA,FDAIEN) ;Do the update.
 N MSG
 D UPDATE^DIE("","FDA","FDAIEN","MSG")
 Q
