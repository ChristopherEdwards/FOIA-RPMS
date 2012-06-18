BDGPOST3 ; IHS/ANMC/LJF - ADT POSTINIT (TRANSFER FACILITY) ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 Q
 ;
EN ;EP; builds new transfer facility file while converting entries in
 ; both ADT and PCC to point to new file
 ; Changes made in Patient Movement file and V Hospitalization file
 NEW BDGN,FAC,NAME,FILE,IEN,DIE,DR,DR
 ;
 Q:$D(^BDGX(10))   ;already done
 D BMES^XPDUTL("Converting transfer facility entries to straight pointers...")
 ;
 ; first loop thru Patient Movement file
 S BDGN=0 F  S BDGN=$O(^DGPM(BDGN)) Q:'BDGN  D
 . Q:$P($G(^DGPM(BDGN,0)),U,5)'[";"   ;no data to convert
 . S FAC=$P(^DGPM(BDGN,0),U,5),FILE=$S(FAC["DIC":4,1:9999999.11)
 . S NAME=$$GET1^DIQ(FILE,+FAC,.01) Q:NAME=""   ;get name
 . S ^XTMP("BDGPOST3A",$J,"LAST")="DGPM^"_BDGN
 . ;
 . ; create entry in new file if not already there
 . I '$D(^AUTTTFAC("B",NAME)) D ADD(NAME,FAC) Q:'$D(^AUTTTFAC("B",NAME))
 . ;
 . ; change pointer in file 405
 . S IEN=$O(^AUTTTFAC("B",NAME,0)) I 'IEN D ERRLOG Q
 . S DIE=405,DA=BDGN,DR=".05///`"_IEN D ^DIE
 ;
 ; now change all V Hospitalization entries
 K X S X="  Now converting transfer facility entries in V Hospitalization file..."
 D MES^XPDUTL(.X)
 S BDGN=0 F  S BDGN=$O(^AUPNVINP(BDGN)) Q:'BDGN  D
 . Q:$P($G(^AUPNVINP(BDGN,0)),U,9)'[";"  ;no data to convert
 . S FAC=$P(^AUPNVINP(BDGN,0),U,9),FILE=$S(FAC["DIC":4,1:9999999.11)
 . S NAME=$$GET1^DIQ(FILE,+FAC,.01) Q:NAME=""   ;get name
 . S ^XTMP("BDGPOST3A",$J,"LAST")="VHOSP^"_BDGN
 . ;
 . ; create entry in new file if not already there
 . I '$D(^AUTTTFAC("B",NAME)) D ADD(NAME,FAC) Q:'$D(^AUTTTFAC("B",NAME))
 . ;
 . ; change pointer in file 405
 . S IEN=$O(^AUTTTFAC("B",NAME,0)) I 'IEN D ERRLOG Q
 . S DIE=9000010.02,DA=BDGN,DR=".09///`"_IEN D ^DIE
 K X S X=$$REPEAT^XLFSTR(" ",20)_"Done." D MES^XPDUTL(.X)
 Q
 ;
ADD(NAME,FAC) ; add entry to ^AUTTTFAC
 NEW DIC,DD,DO,X,DIE,DR,DA,Y
 S DIC="^AUTTTFAC(",DLAYGO=9999999.91,X=NAME,DIC(0)="L" D FILE^DICN
 I Y<1 D ERRLOG Q
 ; add link if IHS facility
 I FAC["DIC" S DIE=9999999.91,DA=+Y,DR=".03///"_(+FAC) D ^DIE
 Q
 ;
ERRLOG ; record errors
 S ^XTMP("BDGPOST3",$J,FAC)="" Q
