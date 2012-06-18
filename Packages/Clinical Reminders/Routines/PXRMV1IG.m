PXRMV1IG ; SLC/PKR - Inits for new REMINDER package (globals).;05/19/2000
 ;;1.5;CLINICAL REMINDERS;;Jun 19, 2000
 ;
 ;These routines are used to help converting from old style B
 ;cross-references to new style full length cross-references.
 ;
 ;=======================================================================
REINDEX(FILE) ;Rebuild all cross-references in a file.
 ;the second entry is the duplicate.
 N DIK,TEXT
 S TEXT="Rebuilding cross-references in file # "_FILE
 D BMES^XPDUTL(TEXT)
 S DIK=$$ROOT^DILFD(FILE)
 I DIK="" Q
 D IXALL^DIK
 Q
 ;
 ;=======================================================================
RMDUP(FILE) ;Remove any duplicate entries from file number FILE. We assume
 ;the second entry is the duplicate.
 N DA,DIK,IEN1,IEN2,NAME,NAME1,NAME2,ROOT,ROOTB,TEMP,TEMP1,TEXT
 S TEXT="Checking for duplicate entries in file # "_FILE
 D BMES^XPDUTL(TEXT)
 S ROOT=$$ROOT^DILFD(FILE)
 I ROOT="" Q
 S DIK=ROOT
 S ROOTB=ROOT_"""B"","
 S NAME=""
 S TEMP=ROOTB_""""_NAME_""")"
 F  S NAME=$O(@TEMP) Q:NAME=""  D
 . S TEMP=ROOTB_""""_NAME_""")"
 . S TEMP1=ROOTB_""""_NAME_""","""")"
 . S IEN1=$O(@TEMP1)
 . S TEMP1=ROOTB_""""_NAME_""","_IEN1_")"
 . S IEN2=$O(@TEMP1)
 . I +IEN2>0 D
 .. S TEMP1=ROOT_IEN1_",0)"
 .. S NAME1=$P(@TEMP1,U,1)
 .. S TEMP1=ROOT_IEN2_",0)"
 .. S NAME2=$P(@TEMP1,U,1)
 .. I NAME1=NAME2 D
 ... S TEXT="Removing duplicate entry "_IEN2_" for "_NAME
 ... D BMES^XPDUTL(TEXT)
 ... S DA=IEN2
 ...;Kill nodes 4,6,10, and 20 so none of the cross-references are fired.
 ... I FILE=811.9 D
 .... K ^PXD(811.9,IEN2,4)
 .... K ^PXD(811.9,IEN2,6)
 .... K ^PXD(811.9,IEN2,10)
 .... K ^PXD(811.9,IEN2,20)
 ... D ^DIK
 Q
 ;
 ;=======================================================================
TMPB(FILE) ;Delete the old B cross-reference and build a new temporary
 ;full length one so the install will find matches. FILE is the file
 ;number.
 N BXREF,IEN,NAME,ROOT,ROOTB,TEMP
 S ROOT=$$ROOT^DILFD(FILE)
 I ROOT="" Q
 S ROOTB=ROOT_"""B"")"
 ;Delete the old B.
 K @ROOTB
 S ROOTB=ROOT_"""B"","""
 S IEN=0
 F  S ENTRY=ROOT_IEN_")",IEN=$O(@ENTRY) Q:+IEN=0  D
 . S TEMP=ROOT_IEN_",0)"
 . S NAME=$P(@TEMP,U,1)
 . S BXREF=ROOTB_NAME_""","_IEN_")"
 . S @(BXREF)=""
 Q
 ;
 ;=======================================================================
INSAV ;Save inactive status of VA Reminders to file
 N NAME,SUB
 K ^TMP("PXRMV1IG",$J)
 S NAME="VA"
 F  S NAME=$O(^PXD(811.9,"B",NAME)) Q:$E(NAME,1,3)'="VA-"  D
 .S SUB=$O(^PXD(811.9,"B",NAME,"")) Q:'SUB  Q:'$D(^PXD(811.9,SUB,0))
 .S ^TMP("PXRMV1IG",$J,NAME)=$P($G(^PXD(811.9,SUB,0)),U,6)
 Q
 ;
 ;=======================================================================
INRES ;Restore inactive status of VA reminders
 N NAME,SUB,STA
 S NAME=""
 F  S NAME=$O(^TMP("PXRMV1IG",$J,NAME)) Q:NAME=""  D
 .S STA=$G(^TMP("PXRMV1IG",$J,NAME))
 .S SUB=$O(^PXD(811.9,"B",NAME,"")) Q:'SUB
 .S:$D(^PXD(811.9,SUB,0)) $P(^PXD(811.9,SUB,0),U,6)=STA
 K ^TMP("PXRMV1IG",$J)
 Q
 ;
 ;=======================================================================
CHANGE ;Rename old menu entries so they get overwritten
 D CHGNAM("PXRM REMINDER MENU","PXRM MANAGERS MENU")
 Q
 ;
 ;=======================================================================
CHGNAM(OLD,NEW) ;Change option name
 ;Skip if the new entry already exists
 I $D(^DIC(19,"B",NEW)) Q
 ;Rename option
 N DA,DIE,DR,X
 S DA=$O(^DIC(19,"B",OLD,"")) Q:'DA
 S DIE="^DIC(19,",DR=".01///^S X=NEW"
 D ^DIE
 Q
