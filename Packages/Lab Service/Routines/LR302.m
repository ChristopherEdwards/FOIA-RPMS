LR302 ;DALOI/FHS - LR*5.2*302 PATCH ENVIRONMENT CHECK ROUTINE;31-AUG-2001
 ;;5.2;LR;**302,1022**;September 20, 2007
 ;
 ; This VA Patch is being included as part of IHS Lab Patch 1022
 ; 
ENV ; Does not prevent loading of the transport global.
 ; Environment check is done only during the install.
 ;
 N XQA,XQAMSG
 ;
CHKNM ; Make sure the patch name exist
 I '$D(XPDNM) D  G EXIT
 . D BMES("No valid patch name exist")
 . S XPDQUIT=2
 ;
 D CHECK
 D EXIT
 Q
 ;
CHECK ; Perform environment check
 I $S('$G(IOM):1,'$G(IOSL):1,$G(U)'="^":1,1:0) D
 . D BMES("Terminal Device is not defined")
 . S XPDQUIT=2
 I $S('$G(DUZ):1,$D(DUZ)[0:1,$D(DUZ(0))[0:1,1:0) D
 . D BMES("Please log in to set local DUZ... variables")
 . S XPDQUIT=2
 I $P($$ACTIVE^XUSER(DUZ),"^")'=1 D
 . D BMES("You are not a valid user on this system")
 . S XPDQUIT=2
 S XPDIQ("XPZ1","B")="NO"
DUP64 ;Check ^LAM for duplicate Names or NLT codes
 D BMES("Checking WKLD CODE file (#64) for duplicate names or numbers.")
 H 5
DUP64P I $G(^XTMP("LRNLTD",0)) D DUPCHK Q
 W !
 N LRINS,LRDT,LRNLT
 S ^XTMP("LRNLTD",0)=$$HTFM^XLFDT(($H+90),1)_U_DT_U_"LR302 64.1 NLT ENTRIES"
 S LRINS=0 F  S LRINS=$O(^LRO(64.1,LRINS)) Q:LRINS<1  D
 . W "."
 . S LRDT=0 F  S LRDT=$O(^LRO(64.1,LRINS,1,LRDT)) Q:LRDT<1  D
 . . S LRNLT=0  F  S LRNLT=$O(^LRO(64.1,LRINS,1,LRDT,1,"B",LRNLT)) Q:LRNLT<1  D
 . . . S:'$D(^XTMP("LRNLTD",LRNLT)) ^(LRNLT)=""
DUPCHK ;
 N IEN,IENX,NAM,CNT,DUP,XREF,TEXT,DA,DIK
 S:$G(LRPOST) DIK="^LAM("
 F XREF="B","C" S (IEN,NAM,CNT)=0 D
 . F  S NAM=$O(^LAM(XREF,NAM)) Q:NAM=""  D
 . . K DUP S (CNT,IEN)=0 F  S IEN=$O(^LAM(XREF,NAM,IEN)) Q:IEN=""  I '$O(^(IEN,0)) D
 . . . S CNT=CNT+1,DUP(CNT)=NAM_U_IEN
 . . I CNT>1 S CNT=0 W ! F  S CNT=$O(DUP(CNT)) Q:CNT<1  D
 . . . S IENX=$P(DUP(CNT),U,2)
 . . . I $G(LRPOST),'$D(^XTMP("LRNLTD",IENX)) D  Q
 . . . . S DA=IENX D ^DIK
 . . . S TEXT=DUP(CNT)
 . . . S TEXT=$S('$D(^XTMP("LRNLTD",IENX)):"+",XREF="B"&(TEXT'["~"):"*",$P($P(TEXT,U),".",2)="0000 ":"*",1:"")_TEXT
 . . . D MES^XPDUTL(TEXT)
 Q:$G(LRPOST)
 D BMES("End of duplicate listing.")
 D BMES("If '*' duplicates were listed they should be resolved before patch install.")
 D BMES("Those '+' will be removed during the post install.")
 H 5
 Q
 ;
EXIT ;
 N XQA
 I $G(XPDQUIT) D BMES("--- Install Environment Check FAILED ---") Q
 D BMES("--- Environment Check is Ok ---")
 S XQAMSG="Loading of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 D BMES("Sending install loaded alert to mail group G.LMI")
 S XQA("G.LMI")=""
 D SETUP^XQALERT,TEXT
 H 5
 Q
 ;
PRE ;Pre-install entry point
 Q:'$D(XPDNM)
 N LAST
 D PTRSAV ;Save pointer information
 ;Remove old data
 N DIU,DIK,DA
 S DIU="^LAB(64.81,",DIU(0)="DS" D EN^DIU2
 K DIU
 S DIU="^LAB(95.3,",DIU(0)="DS" D EN^DIU2
 K DIU
 S DIU="^LAB(95.31,",DIU(0)="DS" D EN^DIU2
 K DIU
 S DIU="^LAB(64.061,",DIU(0)="DS" D EN^DIU2
 K DIU
 S DIU="^LAB(64.2,",DIU(0)="DS" D EN^DIU2
 K DIU
 S DIU="^LAB(64.3,",DIU(0)="DS" D EN^DIU2
 K DIU
 S DIU="^LAB(64.062",DIU(0)="DS" D EN^DIU2
DD D
 . N DIK,DA
 . S DIK="^DD(64,",DA(1)=64,DA=25 D ^DIK K DIK
 . S DIK="^DD(64.02,",DA(1)=64.02,DA=4 D ^DIK
 D BMES("*** Preinstall completed ***")
 Q
POST ;Post install repointing of historical data
 D POST^LR302PO
 D ^LR302P
 D
 . D BMES^LR302("Sending install completion alert to mail group G.LMI")
 . S XQAMSG="Installation of patch "_$G(XPDNM,"Unknown patch")_" completed on "_$$HTE^XLFDT($H)
 . S XQA("G.LMI")=""
 . D SETUP^XQALERT
 N LRPOST S LRPOST=1 D TEXT
 Q
PTRSAV ;Save pointer values into XTMP("LR302" to repointed after install
 D BMES("** Saving Pointer Values **")
 N LRPOST,LRIEN,LRIENSUB,LRPTR,LRDTLB,LRNODE,X,Y,ERR
 S LRPOST=1 D DUP64P K LRPOST
 S:$D(^LAM(0)) $P(^(0),U,3)=0
 S Y=$$FIND1^DIC(64,"","","87971.0000","E","","ERR")
 I Y D
 . N IEN,VAL
 . S IEN=+Y
 . I $D(^LAM(IEN,0))#2,$P(^(0),U,7)=68 D
 . . S VAL=$$FIND1^DIC(64.22,"","","TEST","B","","ERR")
 . . I VAL S $P(^LAM(IEN,0),U,7)=+VAL
 D ^LR302A
 Q
BMES(STR) ;EP - Write BMES^XPDUTL statements
 D BMES^XPDUTL($$CJ^XLFSTR(STR,IOM))
 Q
TEXT ; Alert the user that file #64 should not have any error before and after installing
 N STR W !
 S STR="Using VA FileMan menu ""UTILITY FUNCTIONS"", perform the option ""VERIFY FIELDS""," D BMES(STR)
 S STR="MODIFY WHAT FILE: WKLD CODE" D BMES(STR)
 S STR="VERIFY WHICH FIELD: ALL" D BMES(STR)
 S STR="DO YOU MEAN ALL THE FIELDS IN THE FILE? YES" D BMES(STR)
 I '$G(LRPOST) S STR="Ensure that this option runs CLEANLY before installation of this patch." D BMES(STR)
 H 10
 Q
STAR ;
 W $S(XREF="B"&(TEXT'["~"):"*",$P($P(TEXT,U),".",2)="0000 ":"*",1:"")_TEXT
 Q
