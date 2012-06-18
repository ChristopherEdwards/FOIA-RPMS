BAREDP07 ; IHS/SD/LSL - IMPORT CLAIM REPORTS ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
EN ; EP
 K IMP
 D ENP^XBDIQ1(90056.02,IMPDA,".01;.05","IMP(")
 W !,@IOF,!,"Reports for : ",?20,IMP(.01)
 W !,?20,IMP(.05)
 W !!,"Enter the list of Claim Status(s) you desire to print,"
 W !,"and in the sequence to be printed out.",!
 W !,"C - Claim Unmatched",?25,"R - Reason Unmatched",?50,"N - Not to Post"
 W !,"M - Matched",?25,"P - Posted",?50,"X - Claim & Reason Unmatched"
 W !,"A - All Categories",!,?5,"Example:   CRXN",!
 K DIR
 S DIR(0)="FO^0:6"
 D ^DIR
 K DIR
 I $L(Y)'>0 W !!,"NONE SELECTED - EXITING",! H 2 Q
 I Y="^" Q
 S Z="CRNMPX"
 I Y="A" S Y=Z
 S Z="CRNMPX"
 F I=1:1:$L(Y) I Z'[$E(Y,I) W !!,">>>BAD ENTRY<<<>>> ",Y H 2 G EN
 S BARINDX=Y
 S BARZ("C")="Claim Unmatched"
 S BARZ("P")="Posted"
 S BARZ("M")="Matched"
 S BARZ("N")="Not to Post"
 S BARZ("X")="Claim & Reason Unmatched"
 S BARZ("R")="Reason Unmatched"
 W !
 K DIR
 S DIR(0)="SOB^D:Detailed;B:Brief - One Line;S:Summary - Totals Only"
 S DIR("A")="Select the type of report: "
 D ^DIR
 K DIR
 Q:Y="^"
 S BARTYP=Y
 ; -------------------------------
 ;
PRT ; EP
 ;
 ; GET DEVICE (QUEUEING ALLOWED)
 S Y=$$DIR^XBDIR("S^P:PRINT Output;B:BROWSE Output on Screen","Do you wish to ","P","","","",1)
 K DA
 Q:$D(DIRUT)
 I Y="B" D  Q
 . S XBFLD("BROWSE")=1
 . S BARIOSL=IOSL
 . S IOSL=600
 . D VIEWR^XBLM("LOOP^BAREDP07")
 . D FULL^VALM1
 . W $$EN^BARVDF("IOF")
 . D CLEAR^VALM1  ;clears out all list man stuff
 . K XQORNEST,VALMKEY,VALM,VALMAR,VALMBCK,VALMBG,VALMCAP,VALMCNT,VALMOFF
 . K VALMCON,VALMDN,VALMEVL,VALMIOXY,VALMLFT,VALMLST,VALMMENU,VALMSGR,VALMUP
 . K VALMY,XQORS,XQORSPEW,VALMCOFF
 . ;
DEVE . ;
 . S IOSL=BARIOSL
 . K BARIOSL
 S XBRP="LOOP^BAREDP07"
 S XBNS="BAR;IMP*"
 S XBRX="EXIT^BAREDP07"
 D ^XBDBQUE
 K DIR
 S DIR(0)="E"
 S DIR("A")="<CR> - Continue"
 D ^DIR
 K DIR
 G EN
 ; *********************************************************************
 ;
ENDJOB ;
 Q
 ; *********************************************************************
 ;
LOOP ;EP CLAIMS
 S BARPG("HDR")=IMP(.01)_"   "_IMP(.05)_"   CLAIM REPORT"
 D BARHDR
 S TOT=0,CNT=0
 K INDTOT,INDCNT,ADJTOT
 F XI=1:1:$L(BARINDX) S IND=$E(BARINDX,XI) D INDEX Q:BARQUIT
 G:BARQUIT EXIT
 D FINISH
 G EXIT
 ; *********************************************************************
 ;
FINISH ; EP 
 W !!,?3,"Grand Totals",?50,$J(CNT,6,0),?65,"$ ",$J(TOT,9,2)," <P>"
 I BARTYP'="S" Q
 W !!,?10,"ADJUSTMENT totals: "
 S ADJ="",TOT=0
 F  S ADJ=$O(ADJTOT(ADJ)) Q:ADJ=""  D
 . W !,?15,ADJ,?65,"$ ",$J(ADJTOT(ADJ),9,2)
 . S TOT=TOT+ADJTOT(ADJ)
 W !,?67,"=========="
 W !,?65,"$ ",$J(TOT,9,2),!
 Q
 ; *********************************************************************
 ;
EXIT ; EP
 K CNT,TOT,IND,ADJ,INDTOT,INDCNT
 Q
 ; *********************************************************************
 ;
HEADER ; EP
 Q:"S"=BARTYP
 W !,"E-Claim",?20,"Pat",?50,"DOSB",?65,"<P>ay"
 W:BARTYP="D" !,?20,"HRN | HIC",?50,"DOSE",?65,"<B>ILL",!,?65,"<O>utstanding"
 W !
 Q
 ; *********************************************************************
 ;
INDEX ; EP
 I BARTYP'="S" W !!,?3,BARZ(IND)
 S INDTOT(IND)=0,INDCNT(IND)=0,BARQUIT=0
 S CLMDA=0
 F  S CLMDA=$O(^BAREDI("I",DUZ(2),IMPDA,30,"AC",IND,CLMDA)) Q:CLMDA'>0  D CLAIM  Q:$G(BARQUIT)
 Q:$G(BARQUIT)
 W !,?3,BARZ(IND),?35,"TOTALS",?50,$J(INDCNT(IND),6,0),?65,"$ ",$J(INDTOT(IND),9,2)," <P>"
 S TOT=TOT+INDTOT(IND)
 S CNT=CNT+INDCNT(IND)
 Q
 ; *********************************************************************
 ;
CLAIM ;EP
 ; WORK THE CLAIM
 K CLM,ADJ
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA",".01:.09","CLM(")
 S INDTOT(IND)=INDTOT(IND)+CLM(.04),INDCNT(IND)=INDCNT(IND)+1
 D PRINT
 W:"BS"'[BARTYP !
 I BARTYP="S" D TOTADJ
 Q
 ; *********************************************************************
 ;
TOTADJ ;EP
 ; for summary gather adj type totals
 K ADJ
 D ENPM^XBDIQ1(90056.0208,"IMPDA,CLMDA,0",".02;.04","ADJ(")
 N X,Y
 S I=0
 F  S I=$O(ADJ(I)) Q:I'>0  D
 . S X=ADJ(I,.02)
 . S Y=ADJ(I,.04)
 . S:Y="" Y="?"
 . S ADJTOT(Y)=$G(ADJTOT(Y))+X
 Q
 ; *********************************************************************
 ;
PRINT ; EP
 ; print Claim info
 I BARTYP="S" Q
 D BARPG
 Q:$G(BARQUIT)
 W !,CLM(.01),?20,$E(CLM(.06),1,25),?50,$E(CLM(.08),1,12),?65,"$ ",$J(CLM(.04),9,2)," <P>"
 I BARTYP="B" Q
 W !,?20,CLM(.07),?50,CLM(.09),?63,?65,"$ ",$J(CLM(.05),9,2)," <B>"
 K ADJ
 D BARPG Q:$G(BARQUIT)
 D ENPM^XBDIQ1(90056.0208,"IMPDA,CLMDA,0",".01:.05","ADJ(")
 F ADJ=1:1 Q:'$D(ADJ(ADJ))  D
 . W !,?9,"$",$J(ADJ(ADJ,.02),8,2),?20,ADJ(ADJ,.03)
 . I "RX"[BARTYP Q
 . W !,?20,ADJ(ADJ,.04),?50,ADJ(ADJ,.05)
 I "MPN"[IND D ARINFO
 Q
 ; *********************************************************************
 ;
ARINFO ; EP
 ; PRINT A/R INFO
 S DFN=$$VALI^XBDIQ1(90056.0205,"IMPDA,CLMDA",1.01)
 Q:'DFN
 D ENP^XBDIQ1(90056.0205,"IMPDA,CLMDA","1.01:1.07","CLM(")
 W !,?15,"AR",?20,$E(CLM(1.03),1,25),?50,$E(CLM(1.05),1,12),?65,"$ ",$J(CLM(1.07),9,2)," <O>"
 W !,?20,CLM(1.04),?50,$E(CLM(1.06),1,12),?65,"$ ",$J(CLM(1.02),9,2)," <B>"
 ;
END ;
 Q
 ; *********************************************************************
 ;
BARPG ;EP
 ; PAGE CONTROLLER
 ; this utility uses variables BARPG("HDR"),BARPG("DT"),BARPG("LINE"),BARPG("PG")
 ; kill variables by D EBARPG
 ;
 Q:($Y<(IOSL-5))!($G(DOUT)!$G(DFOUT))
 S:'$D(BARPG("PG")) BARPG("PG")=0
 S BARPG("PG")=BARPG("PG")+1
 I $E(IOST)="C",IOT["TRM" D EOP^BARUTL(0)
 I ($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT)) S BARQUIT=1
 ;
Q ;
 Q:($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT))
 ;
BARHDR ; EP
 ; write page header
 W:$Y @IOF
 W !
 Q:'$D(BARPG("HDR"))
 S:'$D(BARPG("LINE")) $P(BARPG("LINE"),"-",IOM-2)=""
 S:'$D(BARPG("PG")) BARPG("PG")=1
 I '$D(BARPG("DT")) D
 . S %H=$H
 . D YX^%DTC
 . S BARPG("DT")=Y
 U IO
 W ?(IOM-40-$L(BARPG("HDR"))/2),BARPG("HDR")
 W ?(IOM-40),BARPG("DT")
 W ?(IOM-10),"PAGE: ",BARPG("PG")
 W !,BARPG("LINE")
 ;
BARHD ; EP
 ; Write column header / message
 Q:"S"=BARTYP
 W !,"E-Claim",?20,"Pat",?50,"DOSB",?65,"$    <P>ay"
 W:BARTYP="D" !,?20,"HRN | HIC",?50,"DOSE",?65,"$    <B>ill",!,?65,"$    <O>ut"
 Q
 ; *********************************************************************
 ;
 I ($G(DIROUT)!$G(DUOUT)!$G(DTOUT)!$G(DROUT)) S BARQUIT=1
 Q
 ; *********************************************************************
 ;
EBARPG ;
 K BARPG("LINE"),BARPG("PG"),BARPG("HDR"),BARPG("DT")
 Q
