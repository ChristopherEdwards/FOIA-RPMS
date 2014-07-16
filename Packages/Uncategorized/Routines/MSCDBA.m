MSCDBA ;Medsphere Systems Corp.- Clean out files for RPMS-FOIA release;10:30 AM  15 Aug 2013
 ;;1.0
 Q
 ;
ZAP ;Top level execution
 D FILES ;Clean up certain files
 D KGBLS ;Clean up non-FileMan compatiable globals
 D MENU ;Re-build menus
 D CNODES ; Clean old Job Nodes in XUTL
 D CPT ; Clean out CPT codes ;so/08.07.2013
 S $P(^VA(200,1,.1),"^",1)=$H ;Re-set (#11.2) DATE VERIFY CODE LAST CHANGED
EXIT ;
 W !,"DON'T forget to check routines: XUSHSH & XUSHSHP"
 Q
 ;
FILES ; Clean up files
 ;
F1 D  ;#9999999.25 -- BENEFICIARY FILE
 . W !,"Purging BENEFICIARY(#9999999.25) File..."
 . N X S X=$$KFILE(9999999.25) W !,?5,$P(X,U,2)
 . N IEN,FDA ;Add OTHER back into file @ IEN 8
 . S IEN(1)=8
 . S FDA(9999999.25,"+1,",.01)="OTHER"
 . S FDA(9999999.25,"+1,",.02)="08"
 . D UPDATE^DIE("E","FDA")
 . I $D(DIERR) W F1
 . D CLEAN^DILF
 .Q
 ;
F2 D  ;#9999999.03 -- TRIBE FILE
 . W !,"Purging TRIBE(#9999999.03) File..."
 . N X S X=$$KFILE(9999999.03) W !,?5,$P(X,U,2)
 . N IEN,FDA ;Add OTHER back into file @ IEN 8
 . S IEN(1)=1
 . S FDA(9999999.03,"+1,",.01)="OTHER"
 . S FDA(9999999.03,"+1,",.02)="998"
 . S FDA(9999999.03,"+1,",.04)="NO"
 . D UPDATE^DIE("E","FDA")
 . I $D(DIERR) W F2A
 . K FDA
 . S FDA(9999999.0311,"+1,"_IEN(1)_",",.01)="DEMO TRIBE"
 . D UPDATE^DIE("E","FDA")
 . I $D(DIERR) W F2B
 . D CLEAN^DILF
 .;
 ;
F3 D  ;Remove PMI data from #50.68 -- VA PRODUCT FILE
 . W !,"Removing PMI data from VA PRODUCT(#50.68) File."
 . N IEN S IEN=0
 . F  S IEN=$O(^PSNDF(50.68,IEN)) Q:'IEN  D
 .. S $P(^PSNDF(50.68,IEN,1),"^",5,7)="^^"
 ..Q
 .Q
 ;
F4 D  ;Remove Dangling Pointers from OPTION(#19) file
 . W !,"Remove Dangling Pointers from OPTION(#19) file."
 . N %,XQFL
 . S %=1,XQFL="OPTION"
 . D REMOVE^XQ3
 .Q
 ;
F5 D  ;Clean out any Messages
 . W !,"Removing MailMan Messages."
 . N XMZ S XMZ=0
 . F  S XMZ=$O(^XMB(3.9,XMZ)) Q:'XMZ  D
 .. N XMKILL,XMABORT
 .. S (XMKILL,XMABORT)=0
 .. S (XMKILL("MSG"),XMKILL("RESP"))=0
 .. D KILL^XMA32A(XMZ,.XMKILL,XMABORT)
 ..Q
 .Q
 ;
F6 D  ;Clean up #4.2 -- DOMAIN FILE
 . W !,"Cleaning  DOMAIN(#4.2) file."
 . N IEN S IEN=0
 . F  S IEN=$O(^DIC(4.2,IEN)) Q:'IEN  D
 .. I IEN=369 Q  ;DEMO.IHS.GOV
 .. I IEN=370 Q  ;WWW.IHS.GOV
 .. N FDA
 .. S FDA(4.2,IEN_",",.01)="@"
 .. D UPDATE^DIE("E","FDA")
 .. I $D(DIERR) W F15A
 .. D CLEAN^DILF
 ..Q
 .Q
 ;
F7 D  ;Clean up Global ^%ZTSCH( Nodes
 . W !,"Cleaning up Global ^%ZTSCH( Nodes."
 . N TASK S TASK=0
 . F  S TASK=$O(^%ZTSCH(TASK)) Q:'TASK  K ^%ZTSCH(TASK)
 . N SUB S SUB=$P(^%ZIS(14.7,1,0),U)
 . N NODE S NODE=""
 . F  S NODE=$O(^%ZTSCH("SUB",NODE)) Q:NODE=""  D
 .. I NODE=SUB Q  ;Leave this node alone
 .. K ^%ZTSCH("SUB",NODE)
 ..Q
 . K ^%ZTSCH("ER")
 . S ^%ZTSCH("ER")=""
 . K ^%ZTSCH("C")
 . S ^%ZTSCH("C",SUB)=0
 . K ^%ZTSCH("STARTUP")
 .Q
 ;
F8 D  ;Purge #19.2 -- OPTION SCHEDULING FILE
 . W !,"Purging OPTION SCHEDULING(#19.2) File."
 . N IEN S IEN=0
 . F  S IEN=$O(^DIC(19.2,IEN)) Q:'IEN  D
 .. N FDA
 .. S FDA(19.2,IEN_",",.01)="@"
 .. D UPDATE^DIE("E","FDA")
 .. I $D(DIERR) W F17
 .. D CLEAN^DILF
 ..Q
 .Q
 ;
ALLF ;Clean out data from all other NON-FOIA files
 N DATA
 F I=1:1 S DATA=$T(FTBL+I) Q:$P(DATA,";;")["EFTBL"  D
 . S DATA=$P(DATA,";;",2,3)
 . W !,"Purging ",$P(DATA,U,2),"(",$P(DATA,U),") File..."
 . N X
 . S X=$$KFILE($P(DATA,U))
 . W !,?5,$P(X,U,2)
 . Q
 ;
 Q
 ;
KGBLS ; Clean out Non-FileMan compatible globals
 K DATA
 F I=1:1 S DATA=$T(GTBL+I) Q:$P(DATA,";;")["EGTBL"  D
 . S DATA=$P(DATA,";;",2,3),DATA="^"_DATA
 . I '$D(@DATA) Q
 . W !,"Re-setting global "_DATA
 . K @DATA S @DATA="" ;Kill & re-set the top
 . Q
 Q
 ;
MENU ; Re-build menus
 D  ;Rebuild Menu Trees
 . W !,"Rebuilding Menu Trees."
 . D QUE^XQ81
 .Q
 ;
CNODES ; Clean old Job Nodes in XUTL
 D ^XQ82
 Q
 ;
CPT ; Clean out Copyrighted CPT codes
 K ^ICPT S ^ICPT(0)="CPT^81I"
 K ^DIC(81.1) S ^DIC(81.1,0)="CPT CATEGORY^81.1",^(0,"GL")="^DIC(81.1,"
 K ^DIC(81.3) S ^DIC(81.3,0)="CPT MODIFIER^81.3I",^(0,"GL")="^DIC(81.3,"
 S %=$P(^DD(757.02,1,0),U,2) I %'="RF" W !,"757.02,1 has changed" Q
 S $P(^DD(757.02,1,0),U,2)="F"
 S %=$P(^DD(757.02,2,0),U,2) I %'="RP757.03'" W !,"757.02,2 has changed" Q
 S $P(^DD(757.02,2,0),U,2)="P757.03'"
 S DA=0,DIE=757.02,DR="1///@;2///@"
 F  S DA=$O(^LEX(757.02,DA)) Q:DA'>0  D
 . S %=$P($G(^LEX(757.02,DA,0)),U,3)
 . I %=3!(%=4) D ^DIE
 . Q
 S $P(^DD(757.02,1,0),U,2)="RF"
 S $P(^DD(757.02,2,0),U,2)="RP757.03'"
 Q
 ;
KFILE(FILE) ;Delete all data in a file
 I '$D(FILE) Q 0
 I $G(^DIC(FILE,0,"GL"))="" Q "0^File Not Found." ;Global root missing
 N ROOT
 S ROOT=$$CREF^DILF(^DIC(FILE,0,"GL"))
 N HDR S HDR=$P(@ROOT@(0),U,1,2)_"^^"
 K @ROOT
 S @ROOT@(0)=HDR
 Q "1^File Sucessfully Purged."
 ;
FTBL ;Table of Non-FOIA Data files
 ;;50.621^PMI-ENGLISH
 ;;50.622^PMI-SPANISH
 ;;50.623^PMI MAP-ENGLISH
 ;;50.624^PMI MAP-SPANISH
 ;;50.625^WARNING LABEL-ENGLISH
 ;;50.626^WARNING LABEL-SPANISH
 ;;50.627^WARNING LABEL MAP
 ;;3.075^ERROR LOG
 ;;14.4^TASKS
 ;;3.081^SIGN-ON LOG
 ;;779.2^HLO APPLICATION REGISTRY
 ;;870^HL LOGICAL LINK
 ;;8992^ALERT
 ;;8992.1^ALERT TRACKING
 ;;19707.26^VEN EHP KIDS SUPPORT
 ;;19941.2^CIA AUTHENTICATION
 ;;19941.22^CIA LISTENER
 ;;19941.23^CIA EVENT LOG
 ;;19941.23^CIA EVENT LOG
 ;;9000038^NOTICE OF PRIVACY PRACTICES
 ;;9000039^RESTRICTED HEALTH INFORMATION
 ;;9999999.31^ADA CODE
EFTBL ;;
 ;
GTBL ;;Table of non-FileMan compatible files
 ;;ABPVGLOB
 ;;ACDPTMP
 ;;ACHSDATA
 ;;ACHSDEN1
 ;;ACHSEOBR
 ;;ACHSINS1
 ;;ADENDATA
 ;;ADEOADA
 ;;ADEREP
 ;;AGCHDFN
 ;;AGDMGLOB
 ;;AGELGLOB
 ;;AGHAGLOB
 ;;AGMCRP
 ;;AGSAMPLE
 ;;AGTXGLOB
 ;;AMHSDATA
 ;;ASMPITMP
 ;;ASUPDATA
 ;;AZAGMED
 ;;AZBMERST
 ;;AZHZSAV
 ;;AZHZTEMP
 ;;AZXZTMP3
 ;;BARSYNC
 ;;BARTMP
 ;;BCHRDATA
 ;;BMEGMED
 ;;DISV
 ;;DOSV
 ;;INPUT
 ;;TMP
EGTBL ;;
