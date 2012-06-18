BDGCCEN ; IHS/ANMC/LJF - CURRENT INPT CENSUS ;  [ 05/28/2002  10:15 AM ]
 ;;5.3;PIMS;**1003**;mAY 28, 2004
 ;IHS/ITSC/LJF 6/22/2005 PATCH 1003 added date/time to header on paper
 ;
 NEW X S X=$$BROWSE^BDGF I X="B" D EN Q
 I X=U Q
 ;4/26/02 WAR - Commented out next line per LJF1
 ;D ^%ZTLOAD K ZTSK,IO("Q") D HOME^%ZIS Q
 ;IHS/ANMC/LJF 5/22/2002 (Next line per Linda's LJF2 5/22/02)
 ;D ZIS^BDGF("QP","EN^BDGCCEN","CURRENT INPT CENSUS")
 D ZIS^BDGF("QP","EN^BDGCCEN","CURRENT INPT CENSUS","")
 Q
 ;
 ;
EN ;EP; -- main entry point for BDG CURRENT CENSUS
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG CURRENT CENSUS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 Q
 ;
INIT ; -- init variables and list array
 NEW WD,CNT,PT,S,TOTAL,SRV,ARRAY,NUM,X,TOTAL1,LINE,FIRST,TOTAL2
 K ^TMP("BDGCCEN",$J)
 S VALMCNT=0
 ;
 ; loop thru current inpatients by ward and count
 S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S NUM=$G(NUM)+1
 . S (CNT,PT)=0 F  S PT=$O(^DPT("CN",WD,PT)) Q:'PT  S CNT=CNT+1
 . S ARRAY(NUM)=WD_U_CNT,TOTAL=$G(TOTAL)+CNT
 ;
 ; loop thru current inpatients by service and count
 S S=0 F  S S=$O(^DPT("ATR",S)) Q:S=""  D
 . S (CNT,PT)=0 F  S PT=$O(^DPT("ATR",S,PT)) Q:'PT  S CNT=CNT+1
 . S X=$$GET1^DIQ(45.7,S,.01) I X["OBSERVATION" S X="ZZ"_X
 . S SRV(X)=CNT,TOTAL1=$G(TOTAL1)+CNT
 ;
 S (S,NUM)=0 F  S S=$O(SRV(S)) Q:S=""  D
 . S X=S I X["ZZ" S X=$P(X,"ZZ",2)   ;put observation srvs last
 . S NUM=NUM+1,$P(ARRAY(NUM),U,3)=X_U_SRV(S)
 ;
 ; take array with counts and set into display array
 S X=0,FIRST=1 F  S X=$O(ARRAY(X)) Q:'X  D
 . ;
 . ; separate observation services from others by a dashed line
 . I $P(ARRAY(X),U,3)["OBSERVATION" D
 .. S TOTAL2=$G(TOTAL2)+$P(ARRAY(X),U,4)  ;total observations
 .. I FIRST D SET($$SP(35)_$$REPEAT^XLFSTR("-",33),.VALMCNT) S FIRST=0
 . ;
 . S LINE=$$PAD($$SP(2)_$P(ARRAY(X),U),20)_$J($P(ARRAY(X),U,2),5)
 . S LINE=$$PAD(LINE,34)_$P(ARRAY(X),U,3)
 . S LINE=$$PAD(LINE,60)_$J($P(ARRAY(X),U,4),5)
 . D SET(LINE,.VALMCNT)
 ;
 ; add totals to display array
 S LINE=$$SP(20)_$$REPEAT^XLFSTR("_",8)
 S LINE=$$PAD(LINE,60)_$$REPEAT^XLFSTR("_",8)
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$PAD($$SP(20)_$J(+$G(TOTAL),5),60)_$J(+$G(TOTAL1),5)
 D SET(LINE,.VALMCNT)
 ;
 I $G(TOTAL2) D    ;if have observation pt count
 . S LINE=$$PAD($$SP(40)_"(Observation Pts =",60)_$J(TOTAL2,5)_"  )"
 . D SET(LINE,.VALMCNT)
 ;
 Q
 ;
SET(LINE,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGCCEN",$J,NUM,0)=LINE
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,WARD
 ;U IO
 U IO D HDG  ;IHS/ANMC/LJF 5/22/2002 (per Linda's LJF2 5/22/02)
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGCCEN",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGCCEN",$J,BDGX,0)
 . W !,BDGLN
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 ;
 ;IHS/ITSC/LJF 6/22/2005 PATCH 1003 added date/time; centered better
 ;D HDR W @IOF,?24,"Current Inpatient Census"
 NEW X W @IOF S X="Current Inpatient Census for "_$$FMTE^XLFDT($$NOW^XLFDT) W ?(80-$L(X)\2),X
 ;F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 S X="** "_$$CONF^BDGF_" **" W !,?(80-$L(X)\2),X
 ;
 W !,$$REPEAT^XLFSTR("-",80)
 W !?2,"Ward",?20,"# of Pts",?34,"Service",?60,"# of Pts"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGCCEN",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
