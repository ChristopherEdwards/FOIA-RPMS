PXRMBXTL ; SLC/PKR,PJH - Build expanded taxonomies. ;10/03/2000
 ;;1.5;CLINICAL REMINDERS;**2**;Jun 19, 2000
 ;
 ;=======================================================================
CHECK(TAXIEN,KI) ;Check for expanded taxonomy, make sure it is current,
 ;build or rebuild if necessary.
 N DATEBLT,ICD0SUM,ICD9SUM,ICPTDATE,REBUILD,TEMP,TEMP0
 ;
 S TEMP=$G(^PXD(811.3,TAXIEN,0))
 ;
 ;See if the expanded taxonomy should be rebuilt.
 S REBUILD=0
 ;Check the date built, if it is 0 then rebuild.
 S DATEBLT=+$P(TEMP,U,2)
 I DATEBLT=0 S REBUILD=1
 ;
 ;Check for changes in the ICD0 file.
 I 'REBUILD D
 . S ICD0SUM=+$P(TEMP,U,4)
 . S TEMP0=^ICD0(0)
 . I (ICD0SUM)'=(+$P(TEMP0,U,3)+$P(TEMP0,U,4)) S REBUILD=1
 ;
 ;Check for changes in the ICD9 file.
 I 'REBUILD D
 . S ICD9SUM=+$P(TEMP,U,6)
 . S TEMP0=^ICD9(0)
 . I (ICD9SUM)'=(+$P(TEMP0,U,3)+$P(TEMP0,U,4)) S REBUILD=1
 ;
 ;Check for changes in the ICPT file.
 I 'REBUILD D
 . S ICPTDATE=$P(TEMP,U,8)
 . I ICPTDATE'=$$CPTDIST^ICPTAPIU S REBUILD=1
 ;
 I REBUILD D
 . I $D(^PXD(811.3,TAXIEN)) D DELEXTL(TAXIEN)
 . D EXPAND(TAXIEN,KI)
 Q
 ;
 ;=======================================================================
DELEXTL(TAXIEN) ;Delete an expanded taxonomy.
 I '$$LOCKXTL(TAXIEN) Q
 N DA,DIK
 S DIK="^PXD(811.3,"
 S DA=TAXIEN
 D ^DIK
 D ULOCKXTL(TAXIEN)
 Q
 ;
 ;=======================================================================
EXPAND(TAXIEN,KI) ;Build an expanded taxonomy. If KI is defined then
 ;entry KI is being deleted so skip it.
 I '$$LOCKXTL(TAXIEN) Q
 N DATEBLT,HIGH,ICD0SUM,ICD9SUM,ICPTDATE,IND,LOW
 N NICD0,NICD9,NICPT,NRCPT,TEMP
 S DATEBLT=$$NOW^XLFDT
 S $P(^PXD(811.3,TAXIEN,0),U,1)=TAXIEN
 S $P(^PXD(811.3,TAXIEN,0),U,2)=DATEBLT
 ;
 S (IND,NICD0)=0
 F  S IND=$O(^PXD(811.2,TAXIEN,80.1,IND)) Q:+IND=0  D
 . I KI=IND Q
 . S TEMP=^PXD(811.2,TAXIEN,80.1,IND,0)
 . S LOW=$P(TEMP,U,1)
 . S HIGH=$P(TEMP,U,2)
 . I HIGH="" S HIGH=LOW
 . D ICD0(LOW,HIGH,.NICD0)
 S TEMP=^ICD0(0)
 S ICD0SUM=+$P(TEMP,U,3)+$P(TEMP,U,4)
 S $P(^PXD(811.3,TAXIEN,0),U,3)=NICD0
 S $P(^PXD(811.3,TAXIEN,0),U,4)=ICD0SUM
 ;
 S (IND,NICD9)=0
 F  S IND=$O(^PXD(811.2,TAXIEN,80,IND)) Q:+IND=0  D
 . I KI=IND Q
 . S TEMP=^PXD(811.2,TAXIEN,80,IND,0)
 . S LOW=$P(TEMP,U,1)
 . S HIGH=$P(TEMP,U,2)
 . I HIGH="" S HIGH=LOW
 . D ICD9(LOW,HIGH,.NICD9)
 S TEMP=^ICD9(0)
 S ICD9SUM=+$P(TEMP,U,3)+$P(TEMP,U,4)
 S $P(^PXD(811.3,TAXIEN,0),U,5)=NICD9
 S $P(^PXD(811.3,TAXIEN,0),U,6)=ICD9SUM
 ;
 S (IND,NICPT,NRCPT)=0
 F  S IND=$O(^PXD(811.2,TAXIEN,81,IND)) Q:+IND=0  D
 . I KI=IND Q
 . S TEMP=^PXD(811.2,TAXIEN,81,IND,0)
 . S LOW=$P(TEMP,U,1)
 . S HIGH=$P(TEMP,U,2)
 . I HIGH="" S HIGH=LOW
 . D ICPT(LOW,HIGH,.NICPT,.NRCPT)
 S ICPTDATE=$$CPTDIST^ICPTAPIU
 S $P(^PXD(811.3,TAXIEN,0),U,7)=NICPT
 S $P(^PXD(811.3,TAXIEN,0),U,8)=ICPTDATE
 S $P(^PXD(811.3,TAXIEN,0),U,9)=NRCPT
 ;
 ;Build the cross-references
 N DA,DIK
 S DIK="^PXD(811.3,"
 S DA=TAXIEN
 D IX1^DIK
 ;
 D ULOCKXTL(TAXIEN)
 Q
 ;
 ;=======================================================================
ICD0(LOW,HIGH,NICD0) ;Build the list of internal entries for ICD0
 ;(File 80.1).
 N END,IEN,IND
 S IND=LOW_" "
 S END=HIGH_" "
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 . S IEN=$O(^ICD0("BA",IND,""))
 . I +IEN>0 D
 .. S NICD0=NICD0+1
 .. S ^PXD(811.3,TAXIEN,80.1,NICD0,0)=IEN
 . S IND=$O(^ICD0("BA",IND))
 Q
 ;
 ;=======================================================================
ICD9(LOW,HIGH,NICD9) ;Build the list of internal entries for ICD9
 ;(File 80).
 N END,IEN,IND
 S IND=LOW_" "
 S END=HIGH_" "
 F  Q:(IND]END)!(+IND>+END)!(IND="")  D
 . S IEN=$O(^ICD9("BA",IND,""))
 . I +IEN>0 D
 .. S NICD9=NICD9+1
 .. S ^PXD(811.3,TAXIEN,80,NICD9,0)=IEN
 . S IND=$O(^ICD9("BA",IND))
 Q
 ;
 ;=======================================================================
ICPT(LOW,HIGH,NICPT,NRCPT) ;Build the list of internal entries
 ;for ICPT (File 81).
 N IEN,IND,RADIEN
 S IND=LOW
 F  Q:(IND]HIGH)!(+IND>+HIGH)!(IND="")  D
 . S IEN=$O(^ICPT("B",IND,""))
 . I +IEN>0 D
 .. S NICPT=NICPT+1
 .. S ^PXD(811.3,TAXIEN,81,NICPT,0)=IEN
 ..;Determine if this is a radiology procedure.
 .. S RADIEN=+$O(^RAMIS(71,"D",IEN,""))
 .. I RADIEN>0 D
 ... S NRCPT=NRCPT+1
 ... S ^PXD(811.3,TAXIEN,71,NRCPT,0)=IEN_U_RADIEN
 . S IND=$O(^ICPT("B",IND))
 Q
 ;
 ;=======================================================================
LOCKXTL(TAXIEN) ;Lock the expanded taxonomy entry. This may be called during
 ;reminder evalution in which case PXRMXTLK will be defined or during
 ;a taxonomy edit in which case PXRMXTLK will be undefined.
 N IND,LC,LOCK
 I $D(PXRMXTLK) S LC=30
 E  S LC=2
 S LOCK=0
 F IND=1:1:LC Q:LOCK  D
 . L +^PXD(811.3,TAXIEN):1
 . S LOCK=$T
 ;If we can't get lock take appropriate action.
 I 'LOCK D
 . I $D(PXRMXTLK) S PXRMXTLK=TAXIEN
 . E  D
 .. N TEXT
 .. S TEXT="Could not get lock for expanded taxonomy "_TAXIEN_" try again later."
 .. D EN^DDIOL(TEXT)
 Q LOCK
 ;
 ;=======================================================================
ULOCKXTL(TAXIEN) ;Unlock the expanded taxonomy.
 L -^PXD(811.3,TAXIEN)
 Q
 ;
