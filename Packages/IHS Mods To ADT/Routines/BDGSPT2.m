BDGSPT2 ; IHS/OIT/LJF - LIST TEMPLATE CODE FOR USER ACCESS RESTRICTIONS
 ;;5.3;PIMS;**1008,1009**;MAY 28, 2004
 ;IHS/OIT/LJF 08/23/2007 ROUTINE ADDED with Patch 1008
 ;
USER ;EP; Select User whose access will be restricted
 ; called by option BDG SECURITY RESTRICTIONS
 NEW BDGUSR,SCREEN,HELP
 ;restrict person from accessing their own user record
 S SCREEN="I (+Y'=DUZ),($P(^VA(200,+Y,0),U,11)=""""),($P(^VA(200,+Y,0),U,3)]"""")"
 S HELP="Select an active user.  Cannot select yourself."
 S BDGUSR=+$$READ^BDGF("PO^200:EMQZ","Select USER",,HELP,SCREEN) Q:BDGUSR<1
 D EN,USER
 Q
 ;
EN ;EP; -- main entry point for BDG SECURITY RESTRICTIONS list template
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SECURITY RESTRICTIONS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X=$$GET1^DIQ(200,+$G(BDGUSR),.01)
 S VALMHDR(1)=$$PAD("User:",12)_X_$$SP(7)_$$GET1^DIQ(200,+$G(BDGUSR),8)
 S VALMHDR(2)=$$SP(12)_"Last Signed on "_$$GET1^DIQ(200,+$G(BDGUSR),202)
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BDGSPT2",$J),^TMP("BDGSPT2A",$J)
 ;
 ; find entries and sort by status and then by patient name
 NEW STATUS,DFN,PATNM,SORT
 S DFN=0 F  S DFN=$O(^BDGSPT(BDGUSR,1,DFN)) Q:'DFN  D
 . S PATNM=$$GET1^DIQ(2,DFN,.01)
 . S STATUS=$$STATUS(BDGUSR,DFN,2)  ;2=long format
 . S SORT=$S(STATUS["RESTRICTED":1,STATUS["TEMPORARY":2,1:3)
 . S ^TMP("BDGSPT2A",$J,SORT,PATNM,DFN)=STATUS
 ;
 ; now take sorted list and create display array
 S COUNT=0
 S SORT=0 F  S SORT=$O(^TMP("BDGSPT2A",$J,SORT)) Q:'SORT  D
 . I VALMCNT>0 D SET("",.VALMCNT,$G(COUNT),0)
 . S PATNM=0 F  S PATNM=$O(^TMP("BDGSPT2A",$J,SORT,PATNM)) Q:PATNM=""  D
 . . S DFN=0 F  S DFN=$O(^TMP("BDGSPT2A",$J,SORT,PATNM,DFN)) Q:'DFN  D
 . . . S COUNT=COUNT+1
 . . . S LINE=$$PAD($J(COUNT,3)_$$SP(3)_$E(PATNM,1,25),33)
 . . . S LINE=$$PAD(LINE_$J($$HRCN^BDGF2(DFN,DUZ(2)),6),43)
 . . . S LINE=LINE_^TMP("BDGSPT2A",$J,SORT,PATNM,DFN)
 . . . D SET(LINE,.VALMCNT,COUNT,DFN)
 ;
 I '$D(^TMP("BDGSPT2",$J)) S VALMCNT=1,^TMP("BDGSPT2",$J,1,0)=$$SP(15)_"NO RESTRICTED RECORDS FOUND"
 K ^TMP("BDGSPT2A",$J)
 Q
 ;
SET(LINE,NUM,COUNT,IEN) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGSPT2",$J,NUM,0)=LINE
 S ^TMP("BDGSPT2",$J,"IDX",NUM,COUNT)=IEN
 Q
 ;
ADD ;EP; called by BDG RESTRICTED ADD protocol
 D FULL^VALM1
 I '$D(^BDGSPT(BDGUSR)) D ADDUSER
 I '$D(^BDGSPT(BDGUSR)) D  Q
 . W !!,"PROBLEM ADDING USER TO FILE - CONTACT IT DEPARTMENT"
 . S VALMBCK="R"
 . D PAUSE^BDGF
 ;
 S DA(1)=BDGUSR,DIC="^BDGSPT("_DA(1)_",1,",DIC(0)="AEMQLZ",DLAYGO=9009018.11
 S DIC("P")=$P(^DD(9009018.1,1,0),U,2)
 S DIC("DR")=".02///"_$$NOW^XLFDT_";.03///`"_DUZ
 D ^DIC
 D RESET
 Q
 ;
LIFT ;EP; called by BDG RESTRICTED LIFT protocol
 D FULL^VALM1
 NEW DATE,DFN
 D GETPAT Q:'$G(DFN)
 ;
 ; code if restriction already lifted
 S DATE=$O(^BDGSPT(BDGUSR,1,DFN,1,"A"),-1)
 I DATE,$P($G(^BDGSPT(BDGUSR,1,DFN,1,DATE,0)),U,4)="" D  D RESET Q
 . W !!,$$STATUS(BDGUSR,DFN,2)
 . Q:'$$READ^BDGF("Y","Do You Want to Change the EFFECTIVE DATE","NO")
 . NEW DIE,DA,DR
 . S DIE="^BDGSPT("_BDGUSR_",1,"_DFN_",1,",DA=DATE,DA(1)=DFN,DA(2)=BDGUSR
 . S DR=".03R;.07///"_$$NOW^XLFDT_";.08///`"_DUZ
 . D ^DIE
 ;
 ; and if new restriction being added
 NEW DIC,DA,X,Y
 S DIC="^BDGSPT("_BDGUSR_",1,"_DFN_",1,",DIC(0)="L",DLAYGO=9009018.111
 S DIC("P")=$P(^DD(9009018.11,1,0),U,2)
 S X=$$NOW^XLFDT,DA(1)=DFN,DA(2)=BDGUSR
 S DIC("DR")=".02///`"_DUZ_";.03R"
 D ^DIC
 D RESET
 Q
 ;
RESUME ;EP; called by BDG RESTRICTED RESUME protocol
 D FULL^VALM1
 NEW DATE,DFN
 D GETPAT Q:'$G(DFN)
 ;
 S DATE=$O(^BDGSPT(BDGUSR,1,DFN,1,"A"),-1)
 I 'DATE D  Q
 . W !!,"ACCESS CURRENTLY RESTRICTED; NOTHING TO RESUME"
 . D PAUSE^BDGF,RESET
 ;
 NEW X,QUIT
 S X=$$GET1^DIQ(9009018.111,DATE_","_DFN_","_BDGUSR,.04) I X]"" D  I $G(QUIT) D RESET Q
 . W !!,"RESTRICTION LAST RESUMED ON "_X
 . I '$$READ^BDGF("Y","Do You Want to Edit the Last RESUME DATE","NO") S QUIT=1
 ;
 ; enter or edit resume date
 NEW DIE,DA,DR,X,Y
 S DIE="^BDGSPT("_BDGUSR_",1,"_DFN_",1,"
 S DA=DATE,DA(1)=DFN,DA(2)=BDGUSR
 S DR=".04;.05///"_$$NOW^XLFDT_";.06///`"_DUZ
 D ^DIE
 D RESET
 Q
 ;
VIEW ;EP; called by BDG RESTRICTED VIEW protocol
 D FULL^VALM1
 NEW DFN
 D GETPAT Q:'$G(DFN)
 ;
 D EN^BDGSPT3
 S VALMBCK="R"
 Q
 ;
ADDUSER ; adds user to file if not already there
 NEW DIC,DLAYGO,X,Y
 S (DIC,DLAYGO)=9009018.1,DIC(0)="L",X="`"_BDGUSR D ^DIC
 Q
 ;
GETPAT ; -- select patient from listing
 NEW X,Y,Z,BDGPAT
 D FULL^VALM1
 S BDGPAT=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("BDGSPT2",$J,"IDX",Y)) Q:Y=""  Q:BDGPAT]""  D
 . S Z=$O(^TMP("BDGSPT2",$J,"IDX",Y,0))
 . Q:^TMP("BDGSPT2",$J,"IDX",Y,Z)=""
 . I Z=X S BDGPAT=^TMP("BDGSPT2",$J,"IDX",Y,Z)
 S DFN=BDGPAT
 Q
 ;
RESET ;EP; return from protocol & rebuild list
 S VALMBCK="R" D TERM^VALM0,HDR,INIT Q
 ;
HELP ;EP -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP -- exit code
 K ^TMP("BDGSPT2",$J)
 Q
 ;
EXPND ;EP -- expand code
 Q
 ;
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
STATUS(USR,PAT,MODE) ;EP; returns restriction status for user/patient pair
 ; called by this routine and computed field STATUS
 ; also called by ^DGSEC to determine access for user to this patient
 ; If MODE=1, then return short format (default)
 ; If MODE=2, then return long format
 I ('$G(USR))!('$G(PAT)) Q "UNKNOWN"
 I '$D(^BDGSPT(USR,1,PAT)) Q "ACCESS ALLOWED"
 I '$O(^BDGSPT(USR,1,PAT,0)) Q "RESTRICTED ACCESS"
 ;
 ; find last restriction lifted edit date
 NEW DATE,END
 S DATE=$O(^BDGSPT(USR,1,PAT,1,"A"),-1)
 I 'DATE Q "RESTRICTED ACCESS"
 I $P(^BDGSPT(USR,1,PAT,1,DATE,0),U,3)>$$NOW^XLFDT Q "RESTRICTED ACCESS UNTIL "_$$GET1^DIQ(9009018.111,DATE_","_PAT_","_USR,.03)
 S END=$P(^BDGSPT(USR,1,PAT,1,DATE,0),U,4)
 I END="" Q "ACCESS REINSTATED"_$S($G(MODE)=2:" on "_$$GET1^DIQ(9009018.111,DATE_","_PAT_","_USR,.03),1:"")
 I END>DT Q "TEMPORARY ACCESS"_$S(MODE=2:" until "_$$GET1^DIQ(9009018.111,DATE_","_PAT_","_USR,.04),1:"")
 Q "RESTRICTED ACCESS"
 ;
LIFTCHK(USER,DFN,DTIEN,LIFT) ;EP; called by input transform
 ; make sure date restriction lifted is not before first restriction
 ; AND not before last time restriction resumed
 I LIFT<($P(^BDGSPT(USER,1,DFN,0),U,2)\1) Q 0   ;check against first restriction
 NEW LAST S LAST=$O(^BDGSPT(USER,1,DFN,1,DTIEN),-1)
 I (LAST),(LIFT<$P(^BDGSPT(USER,1,DFN,1,LAST,0),U,4)) Q 0  ;check aginst last resumption
 Q 1
 ;
RESUMCHK(USER,DFN,DTIEN,RESUME) ;EP; called by input transform
 ; Make sure date restriction resumes is not before date lifted
 I RESUME<$P(^BDGSPT(USER,1,DFN,1,DTIEN,0),U,3) Q 0
 Q 1
