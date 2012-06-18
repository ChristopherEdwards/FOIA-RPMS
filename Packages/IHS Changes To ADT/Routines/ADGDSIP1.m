ADGDSIP1 ; IHS/ADC/PDW/ENM - DS CHART DEFICIENCY LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
A ;--main
 U IO D INI F DGII=1:1:DGNUM D LPRV Q:DGSTOP=U
 I DGSTOP=U D END1 Q
 I DGSUMPG=2!(DGSUMPG=3) D
 . I DGPAGE>0,(IOST["C-") K DIR S DIR(0)="E" D ^DIR Q:X=U
 . D ^ADGDSIP2          ;summary page
 I DGSTOP=U D END1 Q
 D END Q
 ;
INI ;--initialize variables
 S DGSTOP="",DGFLG=0,DGPAGE=0,$P(DGLIN,"=",80)=""
 S DGDUZ=$P(^VA(200,DUZ,0),U,2) S DGFAC=$P(^DIC(4,DUZ(2),0),U)
 K ^TMP("DGZICPL1",$J)   ;summary page counts
 Q
 ;
END ;--cleanup
 I IOST?1"C-".E D PRTOPT^ADGVAR
END1 D KILL^ADGUTIL,^%ZISC
 K ^TMP("DGZICPL",$J),^TMP("DGZICPL1",$J)
 Q
 ;
LPRV ;--loop provider
 N PR
 S PR="" F  S PR=$O(^TMP("DGZICPL",$J,PR)) Q:PR=""!(DGSTOP=U)  D
 . D PINI,NEWPG,LUTL Q:DGSTOP=U
 . D:DGSUMPG=1!(DGSUMPG=3) TOTALS D SUM
 Q
 ;
PINI ;--provider name and zero counts
 S DGPRVN=PR,DGTCNT=0
 F DGI="SIG","ISG","SUM","ASH","OPR","DEL" S DGCNT(DGI)=0
 Q
 ;
LUTL ;--loop disch date, patient name, dfn
 N SD,NM,DFN
 S SD=0 F  S SD=$O(^TMP("DGZICPL",$J,PR,SD)) Q:'SD!(DGSTOP=U)  D
 . S NM=""
 . F  S NM=$O(^TMP("DGZICPL",$J,PR,SD,NM)) Q:NM=""!(DGSTOP=U)  D
 .. S DFN=0
 .. F  S DFN=$O(^TMP("DGZICPL",$J,PR,SD,NM,DFN)) Q:'DFN!(DGSTOP=U)  D 1
 Q
 ;
1 ;--incomplete chart file data
 N N,CHT,SUM,OPD,OPR,J
 S N=^TMP("DGZICPL",$J,PR,SD,NM,DFN)
 S CHT=$P(N,U),OPD=$P(N,U,2),OPR=$P(N,U,3)
 ;--total incomplete charts for provider
 S DGTCNT=DGTCNT+1,^TMP("DGZICPL1",$J,"Z",DFN)=""
 ;--write patient line
 I DGSUMPG'=2 D  Q:DGSTOP=U
 . I $Y>(IOSL-6) D NEWPG Q:DGSTOP=U
 . W !!,$E(NM,1,20),?22,$J(CHT,6)
 . W ?30,$E(SD,4,5)_"/"_$E(SD,6,7)_"/"_$E(SD,2,3)
 . W:OPD'="" ?40,$E(OPD,4,5)_"/"_$E(OPD,6,7)_"/"_$E(OPD,2,3)
 . W:OPR'="" ?50,$E(OPR,4,5)_"/"_$E(OPR,6,7)_"/"_$E(OPR,2,3)
 ;--loop deficiencies
 F J=4:1 Q:'$P(N,U,J)  D CHDEF
 ;--loop delinquencies ("isg" 'del sig) 
 S J="" F  S J=$O(DGA(J)) Q:J=""  S DGCNT(J)=DGCNT(J)+1
 K DGA S DGFLG=0
 Q
 ;
CHDEF ;--chart deficiencies 
 N CD,GRP
 S DGX=^ADGCD($P(N,U,J),0),CD=$P(DGX,U),GRP=$P(DGX,U,3)
 I GRP="" W:DGSUMPG'=2 ?59,CD,! Q
 ;--deficient for signature
 I GRP="SIG",(SD>DGDEL) S DGA("ISG")=1,GRP="" W:DGSUMPG'=2 ?59,CD,! Q
 ;--not delinquent (a sheet excluded)
 ;I SD>DGDEL,(GRP'="ASH") S GRP="" W:DGSUMPG'=2 ?59,CD,! Q
 I SD>DGDEL S GRP="" W:DGSUMPG'=2 ?59,CD,! Q
 ;--delinquent charts
 S DGA(GRP)=1
 I DGFLG'=DFN D
 . S DGCNT("DEL")=DGCNT("DEL")+1,DGFLG=DFN
 . S ^TMP("DGZICPL1",$J,"ZZ",DFN)=""
 W:DGSUMPG'=2 ?59,$S(GRP="":" ",1:"*"),CD,$S(GRP="":" ",1:"*"),!
 Q
 ;
TOTALS ;--print totals for each provider
 ;--incomplete
 I $Y>(IOSL-9) D NEWPG Q:DGSTOP=U
 W !!?20,"TOTAL INCOMPLETE CHARTS: ",$J(DGTCNT,3)
 I DGCNT("ISG") D
 . W !?17,"# Incomplete for SIGNATURE: ",$J(DGCNT("ISG"),3)
 ;--delinquent
 W !!?20,"TOTAL DELINQUENT CHARTS: ",$J(DGCNT("DEL"),3)
 I DGCNT("OPR") D
 . W !?17,"# Delinquent for OP REPORT: ",$J(DGCNT("OPR"),3)
 I DGCNT("SIG") D
 . W !?17,"# Delinquent for SIGNATURE: ",$J(DGCNT("SIG"),3)
 Q
 ;
SUM ;--set ^TMP for summary page
 S ^TMP("DGZICPL1",$J,DGPRVN)=DGTCNT_U_DGCNT("ISG")_U_DGCNT("DEL")_U_DGCNT("OPR")_U_DGCNT("SIG")
 Q
 ;
HEAD ;--heading
 Q:DGSUMPG=2
 I DGPAGE>0!(IOST["C-") W @IOF
 W ?12,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !?80-$L(DGFAC)/2,DGFAC,!,DGDUZ
 W ?22,"DAY SURGERY INCOMPLETE CHART LIST FOR"
 W !,$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3)
 W ?80-$L(DGPRVN)/2,DGPRVN
 S DGPAGE=DGPAGE+1 W ?65,"Page ",DGPAGE
 W !!,"Patient Name",?22,"HRCN",?30,"Surg Date",?40,"Op Dict"
 W ?50,"Op Rcvd",?60,"Chart Deficiency",!,DGLIN
 Q
 ;
NEWPG ;--page control
 Q:DGSUMPG=2
 ;--printer
 I DGPAGE=0!(IOST'?1"C-".E) D HEAD Q
 ;--terminal
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 Q:X=U  D HEAD Q
