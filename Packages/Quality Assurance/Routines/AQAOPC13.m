AQAOPC13 ; IHS/ORDC/LJF - PRINT OCC BY INDICATOR W/ CRIT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contians the entry point called by ^AQAOPC12 to print the
 ;summary page for the trending report by review criteria.
 ;
SUMMARY ;ENTRY POINT called by ^AQAOPC12  >>> print summary page(s)
 I $D(AQAODLM) D SUMDLM Q
 D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 W !,"TOTAL OCCURRENCES FOR DATE RANGE:",?65,$J(AQAOCNT,3)
 W !?15,"THRESHOLD/TRIGGER:  "
 I $P(^AQAO(2,AQAOIND,0),U,5)]"" W ?70,$J($P(^(0),U,5),6,2),"%"
 ;
 S AQAOSUB=0 I '$D(AQAOXSN) D SUM2 Q
 F  S AQAOSUB=$O(^TMP("AQAOPC11",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D SUM2
 Q
 ;
 ;
SUM2 ; >> SUBRTN for each AQAOSUB, print totals
 I AQAOSUB'=0 W !!,AQAOSUB,":"
 S AQAOC=0
 F  S AQAOC=$O(^TMP("AQAOPC11",$J,AQAOSUB,AQAOC)) Q:AQAOC=""  Q:AQAOSTOP=U  D
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 .W !!,"CR",AQAOC,?8,AQAOCR(AQAOC) ;criteria number and name
 .S X=$O(^AQAO1(6,AQAOC,"IND","B",AQAOIND,0)) I X]"" D
 ..S X=$P(^AQAO1(6,AQAOC,"IND",X,0),U,2) I X]"" W ?70,$J(X,6,2),"%"
 .S (AQAOV,AQAOCT,AQAOCTP)=0
 .F  S AQAOV=$O(^TMP("AQAOPC11",$J,AQAOSUB,AQAOC,AQAOV)) Q:AQAOV=""  Q:AQAOSTOP=U  D
 ..S AQAOARR(AQAOV)=^TMP("AQAOPC11",$J,AQAOSUB,AQAOC,AQAOV)
 ..S AQAOCT=AQAOCT+^TMP("AQAOPC11",$J,AQAOSUB,AQAOC,AQAOV) ;subtotal
 ..I AQAOV'="N/A" S AQAOCTP=AQAOCTP+AQAOARR(AQAOV) ;subtotl 4 percentage
 .S AQAOV=0 F  S AQAOV=$O(AQAOARR(AQAOV)) Q:AQAOV=""  Q:AQAOSTOP=U  D
 ..I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ..;                     ;print totals for each value for each criteria
 ..W !?9,"TOTAL '",$E(AQAOV,1,40),"':",?65,$J(AQAOARR(AQAOV),3)
 ..Q:(AQAOV="N/A")
 ..W ?70,$J((AQAOARR(AQAOV)/AQAOCTP)*100,6,2),"%" ;compare threshold/trigger
 .Q:AQAOSTOP=U  W !?64,"____"
 .W !?10,"SUBTOTAL FOR CR",AQAOC,":",?64,$J(AQAOCT,4) ;prnt subtotal
 .K AQAOARR
 Q
 ;
 ;
SUMDLM ; >>> SUBRTN to print summary page(s) in ASCII format
 W !!!,"**SUMMARY DATA**"
 S X=^AQAO(2,AQAOIND,0) W !!,$P(X,U),AQAODLM,$P(X,U,2) ;ind # and name
 I $P(X,U,5)]"" W AQAODLM,"THRESHOLD/TRIGGER:  ",$P(X,U,5),"%"
 W !,"TOTAL OCCURRENCES FOR DATE RANGE:",AQAODLM,$J(AQAOCNT,3)
 ;
 S AQAOSUB=0 I '$D(AQAOXSN) D SUMDLM2 Q
 F  S AQAOSUB=$O(^TMP("AQAOPC11",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D SUMDLM2
 Q
 ;
 ;
SUMDLM2 ; >> SUBRTN for each AQAOSUB, print totals
 I AQAOSUB'=0 W !!,AQAOSUB,":"
 S AQAOC=0
 F  S AQAOC=$O(^TMP("AQAOPC11",$J,AQAOSUB,AQAOC)) Q:AQAOC=""  D
 .W !!,"CR",AQAOC,AQAODLM,AQAOCR(AQAOC) ;criteria number and name
 .S (AQAOV,AQAOF)=0 ;AQAOF is flag for line feed
 .F  S AQAOV=$O(^TMP("AQAOPC11",$J,AQAOSUB,AQAOC,AQAOV)) Q:AQAOV=""  D
 ..;                ;print totals for each value for each criteria
 ..W:AQAOF=1 !,AQAODLM
 ..W AQAODLM,"TOTAL '",AQAOV,"':"
 ..W AQAODLM,$J(^TMP("AQAOPC11",$J,AQAOSUB,AQAOC,AQAOV),3),AQAODLM
 ..W $J((^TMP("AQAOPC11",$J,AQAOSUB,AQAOC,AQAOV)/AQAOCNT)*100,2,2),"%"
 ..S AQAOF=1 Q
 Q
 ;
 ;
HDG1 ; >> SUBRTN to print second half of heading
 S X=$P(^AQAO(2,AQAOIND,0),U)_":  "_$P(^(0),U,2) ;indicatr
 W ?AQAOIOMX-$L(X)/2,X,!?AQAOIOMX-$L(AQAORG)/2,AQAORG
 W !,AQAOLINE,!,"Case #",?11,"Occ Date  "
 S X=0 F  S X=$O(AQAOCR(X)) Q:X=""  S Y="  CR"_X_"   ",Y=$E(Y,1,8) W Y
 Q
 ;
 ;
DLMHDG ; >> SUBRTN to print second half of heading for ASCII format
 W !!!!,"***OCCURRENCE LISTINGS***",!,AQAORG,!
 W !,"Printed by ",AQAODUZ," Printed on " S %H=$H D YX^%DTC W Y
 W !,"Case #",AQAODLM,"Occ Date "
 S X=0 F  S X=$O(AQAOCR(X)) Q:X=""  W AQAODLM,"CR",X
 Q
 ;
 ;
HDG2 ; >> SUBRTN to print second half of heading2    
 S X=$P(^AQAO(2,AQAOIND,0),U)_":  "_$P(^(0),U,2)_" (SUMMARY PAGE)"
 W ?AQAOIOMX-$L(X)/2,X,!?AQAOIOMX-$L(AQAORG)/2,AQAORG,!,AQAOLINE,!
 Q
