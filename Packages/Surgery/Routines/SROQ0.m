SROQ0 ;B'HAM ISC/ADM - QUARTERLY REPORT (CONTINUED) ; [ 09/07/00  12:43 PM ]
 ;;3.0; Surgery ;**62,70,77,50,95**;24 Jun 93
 ;
 ; Reference to ^DIC(45.3 supported by DBIA #218
 ;
 ;** NOTICE: This routine is part of an implementation of a nationally
 ;**         controlled procedure.  Local modifications to this routine
 ;**         are prohibited.
 ;
 S SR(0)=^SRF(SRTN,0),DFN=$P(SR(0),"^") I '$D(^TMP("SRDPT",$J,DFN)) S ^TMP("SRDPT",$J,DFN)="",SRDPT=SRDPT+1
 D DEM^VADPT S X1=SRSD,X2=$P(VADM(3),"^"),SRAGE=$E(X1,1,3)-$E(X2,1,3)-($E(X1,4,7)<$E(X2,4,7)) I SRAGE>60 S SR60=SR60+1
 S SRDEATH=0,SRREL="" I $P(VADM(6),"^"),SRSD<$P(VADM(6),"^") S X1=SRSD,X2=30 D C^%DTC I $P(VADM(6),"^")'>X S SRDEATH=1
 I SRDEATH S ^TMP("SRDTH",$J,DFN)=""
 S SRMM=$P(SR(0),"^",3) I SRMM="J" S SRMAJOR=SRMAJOR+1
 S SRIOSTAT=$P(SR(0),"^",12) I SRIOSTAT'="I"&(SRIOSTAT'="O") S VAIP("D")=SRSD D IN5^VADPT S SRIOSTAT=$S(VAIP(13):"I",1:"O") K VAIP
 I SRIOSTAT="I" S SRINPAT=SRINPAT+1
 S Y=$P($G(^SRF(SRTN,1.1)),"^",3),C=$P(^DD(130,1.13,0),"^",2) D:Y'="" Y^DIQ S SRASA=$P(Y,"-")
 S SREM=$P(SR(0),"^",10) I SREM="EM"!(SRASA["E") S SREMERG=SREMERG+1
COMP ; check for post-op complications
 S SRPOC=0 I $O(^SRF(SRTN,16,0)) S SRPOC=1,SRCOMP=SRCOMP+1
ASA ; find ASA class for major procedures
 I SRMM="J" S Z=$E(SRASA) S:Z="" Z=7 S SRASA(Z)=SRASA(Z)+1
SP ; find specialty data
 S X=$P(SR(0),"^",4),Y=$S(X:$P(^SRO(137.45,X,0),"^",2),1:"ZZ") S SRSS=$S(Y:$P(^DIC(45.3,Y,0),"^"),1:Y) I '$D(SRSPEC(SRSS)) S SRSS="ZZ"
 F I=1:1:4 S SRP(I)=$P(^TMP("SRSS",$J,SRSS),"^",I)
 I '$D(^TMP("SRDPT",$J,DFN,SRSS)) S ^TMP("SRDPT",$J,DFN,SRSS)="",SRP(1)=SRP(1)+1
 S SRP(2)=SRP(2)+1 S:SRMM="J" SRP(3)=SRP(3)+1 S:SRMM'="J" SRP(4)=SRP(4)+1
 S ^TMP("SRSS",$J,SRSS)=SRP(1)_"^"_SRP(2)_"^"_SRP(3)_"^"_SRP(4) K SRP
 D ^SROQ0A
WC ; clean wound ?
 S SRCLEAN=0 I $P($G(^SRF(SRTN,"1.0")),"^",8)="C" S SRWC=SRWC+1,SRCLEAN=1
CAT ; complication categories
 S SRW=0
 I SRPOC S SRC=0 F  S SRC=$O(^SRF(SRTN,16,SRC)) Q:'SRC  S SRCAT=$P(^SRF(SRTN,16,SRC,0),"^",2) I SRCAT D
 .S SRCAT=$S(SRCAT=33:29,SRCAT=34:32,1:SRCAT)
 .S SRC(SRCAT)=SRC(SRCAT)+1 I SRCLEAN,(SRCAT=1!(SRCAT=2)) S SRW=1
 I $O(^SRF(SRTN,10,0)) S SRC=0 F  S SRC=$O(^SRF(SRTN,10,SRC)) Q:'SRC  S SRCAT=$P(^SRF(SRTN,10,SRC,0),"^",2) I SRCAT S SRC(SRCAT)=SRC(SRCAT)+1 I SRCLEAN,(SRCAT=1!(SRCAT=2)) S SRW=1
 I SRW S SRIN=SRIN+1
 Q
HDR ; print page header
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 I SRHDR,$E(IOST)="C" W !!,"Press RETURN to continue, or '^' to quit: " R X:DTIME I '$T!(X["^") S SRSOUT=1 Q
 S SRHDR=1 I $E(IOST)'="P" W @IOF Q
 S SRPAGE=SRPAGE+1 I 'SRFLG D HDR1 Q
 W:$Y @IOF W !,?23,"QUARTERLY REPORT - SURGICAL SERVICE",?76,"PAGE",!,?35,"VERSION 3.0",?78,SRPAGE
 I SRINST["ALL DIV" W !!,?(80-$L("Hospital: "_SRINST)\2),"Hospital: ",SRINST,!,?30,"Station Number: ",SRSTATN
 I SRINST'["ALL DIV" W !!,?3,"Hospital: ",SRINST,?55,"Station Number: ",SRSTATN
 W !,?3,"For Dates: ",SRSD,?32,"to: ",SRED,?55,"Fiscal Year: ",SRYR,! F I=1:1:80 W "="
 Q
HDR1 ; print header if not quarterly report
 I $D(ZTQUEUED) D ^SROSTOP I SRHALT S SRSOUT=1 Q
 W:$Y @IOF W !,?24,"SUMMARY REPORT - SURGICAL SERVICE",?76,"PAGE",!,?35,"VERSION 3.0",?78,SRPAGE
 W !!,?(80-$L("Hospital: "_SRINST)\2),"Hospital: ",SRINST,!,?30,"Station Number: ",SRSTATN
 W !,?20,"For Dates: ",SRSD,"  to: ",SRED I $E(IOST)="P" W ! F I=1:1:80 W "="
 Q
QTR D CHECK I '$D(X) D HELP
 K SRX,SRY
 Q
CHECK I ($L(X)'=4&($L(X)'=6))!(X'["-") K X Q
 I $P(X,"-",2)?1N,"1243"'[$P(X,"-",2) K X Q
 I $L(X)=4 D FOUR Q
 I X'?4N1"-"1N K X Q
 S SRX=$P(X,"-") I SRX<1996!(SRX>2010) K X Q
 S SRY=$P(X,"-",2) I "1234"'[SRY K X Q
 S X=SRX_SRY
 Q
HELP K SRHELP S SRHELP(1)="",SRHELP(2)="Answer must be in format :  FISCAL YEAR-QUARTER",SRHELP(3)="",SRHELP(4)="NOTE:  A hyphen (-) must separate FISCAL YEAR and QUARTER.  The FISCAL"
 S SRHELP(5)="       YEAR must be in the range 1996 to 2010.",SRHELP(6)="",SRHELP(7)="FISCAL YEAR portion of answer may be entered in either 2 or 4 digit",SRHELP(8)="format, for example, 1996 or 96 for FISCAL YEAR 1996."
 S SRHELP(9)="",SRHELP(10)="QUARTER must be a number, (1, 2, 3 or 4).",SRHELP(11)="",SRHELP(12)="Example:  For second quarter of fiscal year 1996, enter 1996-2 or 96-2.",SRHELP(13)="" D EN^DDIOL(.SRHELP) K SRHELP
 Q
FOUR I X'?2N1"-"1N K X Q
 S SRX=$P(X,"-") I SRX>9&(SRX<96) K X Q
 S SRX=$S($E(X)=9:"19"_SRX,1:"20"_SRX),SRY=$P(X,"-",2),X=SRX_SRY
 Q
