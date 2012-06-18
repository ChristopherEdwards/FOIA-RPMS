BKMIHSM ;PRXM/HC/BWF - BKMV HEALTH SUMMARY; [ 1/12/2005  7:16 PM ] ; 13 Jun 2005  3:34 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 ;HEALTH SUMMARY PROGRAM
 ;RETURNS ALL HEALTH SUMMARY INFORMATION
 Q
HS(DFN,HS,BOTH) ; EP - Main entry point for BWF PAT REC EDIT
 ; INPUT: DFN - Patient internal entry number
 ;        HS - (optional) Array with Names of health summary being requested
 ;        BOTH - (optional) If set will call Supplement when summaries are done
 D CLEAR^VALM1
 N APCHSTYP,APCHSPAT,SCRAP,X,ZT
 I '$D(HS) D PROMPT Q:X["^"!(X=""&'$D(HS))
 K %ZIS,IOP,IOC,ZTIO S %ZIS="MQ" D ^%ZIS Q:POP
 S BOTH=$G(BOTH)
 I $D(IO("Q")) D  Q
 . S ZTRTN="HS1^BKMIHSM"
 . S ZTSAVE("DFN")="",ZTSAVE("BKMIEN")="",ZTSAVE("BOTH")=BOTH
 . S ZTSAVE("BKMVSUPP*")="",ZTSAVE("HS*")="",ZT=""
 . K IO("Q") D ^%ZTLOAD W:$D(ZTSK) !,"REQUEST QUEUED" H 2
 . D ^%ZISC
HS1 ;Entry point for queued report
 N LOOP,QUIT
 S LOOP=0,QUIT=""
 F  S LOOP=$O(HS(LOOP)) Q:LOOP=""  D  Q:QUIT
 .Q:HS(LOOP)=""
 .S APCHSTYP=$O(^APCHSCTL("B",HS(LOOP),0))
 .Q:'APCHSTYP
 .S APCHSPAT=DFN
 .D EN1^APCHS
 .I IOST["C-" S QUIT=$$PAUSE^BKMSUPP3() Q:QUIT
 .I $O(HS(LOOP)) W @IOF
 Q:QUIT
 I 'BOTH D ^%ZISC Q
 D ONE^BKMSUPP(DFN)
XIT ; CLEAN UP VARIABLES
 K DIC,DIE,X,Y,DA,HS,STOP,NUM
 Q
PROMPT ;
 N NUM
 S NUM=1
 ; PRX/DLS 4/3/2006 Set DIC("B") equal to "ADULT REGULAR" for default Health Summary selection (it it exists).
ASK ;
 NEW DIC
 S DIC="^APCHSCTL(",DIC(0)="AEQM",DIC("A")="Select "_$S(NUM>1:"additional ",1:"")_"Health Summary type: "
 I $$FIND1^DIC(9001015,"","","ADULT REGULAR","B","","") S DIC("B")="ADULT REGULAR"
 D ^DIC
 I $D(DTOUT)!$D(DUOUT)!(Y=-1) Q
 S X=$P(Y,U,2)
 S HS(NUM)=X
 Q
