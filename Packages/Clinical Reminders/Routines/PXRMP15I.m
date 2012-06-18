PXRMP15I ; SLC/JVS - Patch 15 inits. ;2/3/03  15:48
 ;;1.5;CLINICAL REMINDERS;**15**;Jun 19, 2000
 ;
 Q
 ;
 ;===============================================================
DELEI ;If the Exchange File entry already exists delete it.
 ;
 N IND,LIST,PXRMVAL,NUM
 ;
 S PXRMVAL(1)="VA-ANTIPSYCHOTIC MED SIDE EFF EVAL"
 D FIND^DIC(811.8,"","","U",.PXRMVAL,"","","","","LIST")
 S NUM=$P(LIST("DILIST",0),U,1)
 I NUM'=0 D
 .F IND=1:1:NUM D
 .. N DA,DIK
 .. S DIK="^PXD(811.8,"
 .. S DA=LIST("DILIST",2,IND)
 .. D ^DIK
 ;
 S PXRMVAL(1)="VA-DEPRESSION SCREENING"
 D FIND^DIC(811.8,"","","U",.PXRMVAL,"","","","","LIST")
 S NUM=$P(LIST("DILIST",0),U,1)
 I NUM'=0 D
 .F IND=1:1:NUM D
 .. N DA,DIK
 .. S DIK="^PXD(811.8,"
 .. S DA=LIST("DILIST",2,IND)
 .. D ^DIK
 ;
 S PXRMVAL(1)="VA-POS DEPRESSION SCREEN FOLLOWUP"
 D FIND^DIC(811.8,"","","U",.PXRMVAL,"","","","","LIST")
 S NUM=$P(LIST("DILIST",0),U,1)
 I NUM'=0 D
 .F IND=1:1:NUM D
 .. N DA,DIK
 .. S DIK="^PXD(811.8,"
 .. S DA=LIST("DILIST",2,IND)
 .. D ^DIK
 Q
 ;
 ;===============================================================
PRE ;Pre-inits
 D DELEI
 Q
 ;
 ;===============================================================
POST ;Post-inits
 D SMEXINS
 Q
 ;
 ;===============================================================
SMEXINS ;Silent mode install.
 N IEN,PXRMVAL
 ;
 S PXRMVAL(1)="VA-ANTIPSYCHOTIC MED SIDE EFF EVAL"
 S PXRMVAL(2)="02/03/2003@15:04:26"
 S IEN=+$$FIND1^DIC(811.8,"","KU",.PXRMVAL)
 I IEN'=0 D
 . N TEXT
 . S TEXT="Installing reminder "_PXRMVAL(1)
 . D BMES^XPDUTL(TEXT)
 . D INSTALL^PXRMEXSI(IEN)
 ;
 S PXRMVAL(1)="VA-DEPRESSION SCREENING"
 S PXRMVAL(2)="02/03/2003@15:05:19"
 S IEN=+$$FIND1^DIC(811.8,"","KU",.PXRMVAL)
 I IEN'=0 D
 . N TEXT
 . S TEXT="Installing reminder "_PXRMVAL(1)
 . D BMES^XPDUTL(TEXT)
 . D INSTALL^PXRMEXSI(IEN)
 ;
 S PXRMVAL(1)="VA-POS DEPRESSION SCREEN FOLLOWUP"
 S PXRMVAL(2)="02/07/2003@11:47:16"
 S IEN=+$$FIND1^DIC(811.8,"","KU",.PXRMVAL)
 I IEN'=0 D
 . N TEXT
 . S TEXT="Installing reminder "_PXRMVAL(1)
 . D BMES^XPDUTL(TEXT)
 . D INSTALL^PXRMEXSI(IEN)
 Q
