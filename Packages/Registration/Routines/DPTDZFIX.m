DPTDZFIX ; IHS/ANMC/LJF - RESET MERGE TO RUN AGAIN; [ 10/03/2001  8:13 AM ]
 ;1.0;PATIENT MERGE;
 ;
 Q  ;must use entry point
 ;
ASK ;EP; resets entry that merged but produced errors to ready state
 I '$D(^XTMP("DPTDZFIX")) D
 . D MSG("Need to run search for Lab pointers first.",1,0,0)
 . D LRFIND     ;need current list of LRDFN links
 D MSG("Last search for lab pointers run on "_$$FMTE^XLFDT(+$G(^XTMP("DPTDZFIX",0))),2,1,0)
 ;
 NEW DPTDN,DIC,DA,DR,DIQ
 NEW DPTDN S DPTDN=$$READ("NO","Enter DUPLICATE RECORD #") Q:DPTDN<1
 S DIC="^VA(15,",DA=DPTDN,DIQ(0)="CR" D EN^DIQ  ;show entry
 ;
 Q:'$$READ("Y","Okay to reset to run merge again")
 ;
 I $P($G(^VA(15,DPTDN,0)),U,5)'=2 D  Q
 . D MSG("NOT MERGED!  Reset not allowed.",1,1,0) D PAUSE
 ;
 D RESET(DPTDN)
 ;
 S DIC="^VA(15,",DA=DPTDN,DIQ(0)="CR" D EN^DIQ  ;show updated entry
 ;
 D MSG("WARNING: Please run merge right away as the FROM patient now",2,0,0)
 D MSG("does NOT look merged to any patient lookup!!",1,0,0)
 D PAUSE
 Q
 ;
RESET(IEN) ; -- make changes to entry in files 15 and 2
 Q:$P($G(^VA(15,IEN,0)),U,5)'=2  ;must have been merged before
 ;
 ;find FROM entry based on Merge Direction field
 S X=$P(^VA(15,IEN,0),U,4),FROM=$P(^VA(15,IEN,0),U,X)
 Q:FROM=""
 ;
 ;update merge status and remarks fields
 S $P(^VA(15,IEN,0),U,5)=1       ;reset to ready state
 S X=$P(^VA(15,IEN,0),U,8)       ;date resolved on last merge attempt
 S $P(^VA(15,IEN,1),U)="MERGE RUN ORIGINALLY ON "_$$FMTE^XLFDT(X)
 ;
 ;set LRDFN if needed
 S X=$G(^XTMP("DPTDZFIX",FROM))  ;see if LRDFN exists in ^LR
 I X,$P(^LR(X,0),U,3)=FROM S ^DPT(FROM,"LR")=X  ;set LRDFN into DPT
 ;
 ; call IX1^DIK to re-index entry to fire xrefs
 S DIK="^VA(15,",DA=IEN D IX1^DIK
 ;
 ; clean up zero node of DPT
 S X=$$STRIP^XLFSTR($P(^DPT(+FROM,0),U),"*")   ;strip * off of from pat
 K ^DPT("B",$P(^DPT(+FROM,0),U),+FROM)         ;kill xref with *
 S $P(^DPT(+FROM,0),U)=X,^DPT("B",X,+FROM)=""  ;reset name and xref
 S $P(^DPT(+FROM,0),U,19)=""                   ;take merged to ien off
 Q
 ;
LOOP ;EP; -- called to reset all past merges to ready status
 NEW DPTDZN
 S DPTDZN=0
 F  S DPTDZN=$O(^VA(15,DPTDZN)) Q:'DPTDZN  D
 . Q:$P($G(^VA(15,DPTDZN,0)),U,5)'=2   ;quit if not merged
 . Q:$P($G(^VA(15,DPTDZN,1)),U)]""     ;remarks mean already rerun
 . D RESET(DPTDZN)
 . W !,DPTDZN
 Q
 ;
PAUSE ;EP -- ask user to press return - no form feed
 ; called by option DPTD IHS MERGE VIEW
 NEW DIR Q:IOST'["C-"
 S DIR(0)="E",DIR("A")="Press ENTER to continue" D ^DIR
 Q
 ;
READ(TYPE,PROMPT,DEFAULT,HELP,SCREEN,DIRA) ; calls reader, returns response
 NEW DIR,Y
 S DIR(0)=TYPE
 I $D(SCREEN) S DIR("S")=SCREEN
 I $G(PROMPT)]"" S DIR("A")=PROMPT
 I $G(DEFAULT)]"" S DIR("B")=DEFAULT
 I $D(HELP) S DIR("?")=HELP
 I $D(DIRA(1)) S Y=0 F  S Y=$O(DIRA(Y)) Q:Y=""  S DIR("A",Y)=DIRA(Y)
 D ^DIR
 Q Y
 ;
MSG(DATA,PRE,POST,BEEP) ; -- writes line to device
 NEW I
 I PRE>0 F I=1:1:PRE W !
 W DATA
 I POST>0 F I=1:1:POST W !
 I $G(BEEP)>0 F I=1:1:BEEP W $C(7)
 Q
 ;
LRFIND ;EP; -- finds all LRDFN entries in Lab without matching entries in DPT
 D ^XBKVAR                            ;set min kernel variables
 K ^XTMP("DPTDZFIX")
 S ^XTMP("DPTDZFIX",0)=DT             ;shows date last run
 NEW LR,DFN
 S LR=0 F  S LR=$O(^LR(LR)) Q:LR'>0  D
 . I '$D(^LR(LR,0)) Q                 ;no zero node
 . Q:$P(^LR(LR,0),U,2)'=2             ;file must = 2 (^DPT)
 . S DFN=+$P(^LR(LR,0),U,3)           ;patient ien
 . I '$D(^DPT(DFN,0)) Q               ;no entry in DPT
 . I '$D(^DPT(DFN,"LR")) S ^XTMP("DPTDZFIX",DFN)=LR  ;set xtmp
 Q
 ;
SCHED ;EP; -- find all merged patients with Scheduling data
 ; and set "S" nodes in DPT for those found
 NEW CLINIC S U="^"
 S CLINIC=0 F  S CLINIC=$O(^SC(CLINIC)) Q:'CLINIC  D
 . S DATE=0 F  S DATE=$O(^SC(CLINIC,"S",DATE)) Q:'DATE  D
 .. S N=0 F  S N=$O(^SC(CLINIC,"S",DATE,1,N)) Q:'N  D
 ... S PAT=+$G(^SC(CLINIC,"S",DATE,1,N,0)) Q:'PAT
 ... Q:$P($G(^DPT(PAT,0)),U,19)=""   ;not merged from patient
 ... ; reset pointer in ^SC using merged to patient
 ... S $P(^SC(CLINIC,"S",DATE,1,N,0),U)=$P(^DPT(PAT,0),U,19)
 ... ;W !,PAT
 Q
