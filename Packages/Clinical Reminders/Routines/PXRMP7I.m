PXRMP7I ; SLC/PKR - Patch 7 inits. ;01/15/2002
 ;;1.5;CLINICAL REMINDERS;**7**;Jun 19, 2000
 ;
 Q
 ;===============================================================
DELDD N DIU
 ;Delete the data dictionaries that are being updated, leave the data.
 S DIU(0)=""
 F DIU=800,811.6 D EN^DIU2
 Q
 ;
 ;===============================================================
DELEI ;If the Exchange File entry already exists delete it.
 N IND,LIST,LUVALUE,NUM,TEXT
 S LUVALUE(1)="VA-MST SCREENING"
 D FIND^DIC(811.8,"","","U",.LUVALUE,"","","","","LIST")
 S NUM=$P(LIST("DILIST",0),U,1)
 I NUM=0 Q
 S TEXT="Deleting Exchange File entry "_LUVALUE(1)
 F IND=1:1:NUM D
 . N DA,DIK
 . S DIK="^PXD(811.8,"
 . S DA=LIST("DILIST",2,IND)
 . D BMES^XPDUTL(TEXT)
 . D ^DIK
 Q
 ;
 ;===============================================================
MST ;Change MST dialogs to VA- and National
 N NAME,PXRMINST,TEXT
 S PXRMINST=1
 S TEXT="Renaming existing MST REMINDER DIALOGS:"
 D BMES^XPDUTL(TEXT)
 S NAME="TEXT MST STATUS QUESTIONS" D VACHG(NAME)
 S NAME="HF MST NO" D VACHG(NAME)
 S NAME="HF MST YES" D VACHG(NAME)
 S NAME="HF PATIENT REFUSED (MST)" D VACHG(NAME)
 S NAME="TEXT MST SERVICES" D VACHG(NAME)
 Q
 ;===============================================================
PRE ;Pre-inits
 D DELEI
 D DELDD
 D MST
 Q
 ;
 ;===============================================================
POST ;Post-inits
 D SMEXINS
 Q
 ;
 ;===============================================================
SMEXINS ;Silent mode install.
 N IEN,LUVALUE
 S LUVALUE(1)="VA-MST SCREENING"
 S LUVALUE(2)="01/15/2002@08:55:40"
 S IEN=+$$FIND1^DIC(811.8,"","KU",.LUVALUE)
 I IEN'=0 D
 . N TEXT
 . S TEXT="Installing reminder "_LUVALUE(1)
 . D BMES^XPDUTL(TEXT)
 . D INSTALL^PXRMEXSI(IEN)
 Q
 ;
 ;===============================================================
VACHG(OLD) ;Rename dialogs and change to national
 N DA,DIE,DR,NEW,SUB,X
 S NEW="VA-"_OLD,STATUS="NATIONAL"
 ;Quit if new name already defined
 S SUB=$O(^PXRMD(801.41,"B",NEW,"")) Q:SUB
 ;Quit if old name not defined
 S SUB=$O(^PXRMD(801.41,"B",OLD,"")) Q:'SUB
 ;Change name
 S DIE="^PXRMD(801.41,",DR=".01///^S X=NEW",DA=SUB
 D ^DIE
 ;Status becomes national
 S DIE="^PXRMD(801.41,",DR="100///^S X=STATUS",DA=SUB
 D ^DIE
 ;Message
 S TEXT="New name: "_NEW
 D BMES^XPDUTL(TEXT)
 Q
