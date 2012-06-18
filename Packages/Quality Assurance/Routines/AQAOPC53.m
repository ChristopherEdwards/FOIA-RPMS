AQAOPC53 ; IHS/ORDC/LJF - PRINT QRT PROGRESS RPT-ASCII ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints the qtr progress report in ASCII format for use
 ;in PC-based applications.  Basic format is the same as in ^AQAOPC52.
 ;
INIT ; >> initialize variables
 D MONTHS ;set array for all months included in report
 ;use wide margin if date range has more than 7 months
 I Y>7 S AQAOIOM=IOM,(AQAOIOMX,X)=132 X:IOT'="HFS" ^%ZOSF("RM")
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY=$S($D(AQAORPTT):AQAORPTT,1:"CLOSED OCCURRENCES REPORT")
 S Y=AQAOBD X ^DD("DD") S AQAORNG="("_Y,Y=AQAOED-31 X ^DD("DD")
 S AQAORNG=AQAORNG_" - "_Y_")" ;date range
 S AQAOLIN3="",$P(AQAOLIN3,"-",70)=""
 ;
LOOP ; >> loop thru ^tmp to get data then print it
 D DLMHDG^AQAOUTIL,HDG2
 S AQAOF=0
 F  S AQAOF=$O(^TMP("AQAOPC5",$J,1,AQAOF)) Q:AQAOF=""  Q:AQAOSTOP=U  D
 .S AQAOIND=0
 .F  S AQAOIND=$O(^TMP("AQAOPC5",$J,1,AQAOF,AQAOIND)) Q:AQAOIND=""  Q:AQAOSTOP=U  D
 ..S AQAOM=$$INDNAME^AQAOPC52 ;set indicator heading
 ..W !!,AQAOF,!,AQAOM,!
 ..S AQAOIT=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND))
 ..I AQAOIT=0 W !,">>> NO OCCURRENCES FOUND FOR THIS INDICATOR <<<" Q
 ..E  D COUNTP ;prnt counts by month
 ..D ACTDLM^AQAOPC54 ;include action plans
 ;
 ;
EXIT ; >>> eoj        
 W !!,*7,"*** STOP CAPTURE NOW ***"
 I IOST["C-" D PRTOPT^AQAOVAR
 I $D(AQAOIOM),IOT'="HFS" S X=AQAOIOM X ^%ZOSF("RM")
 D ^%ZISC D KILL^AQAOUTIL
 K ^TMP("AQAOPC5",$J),^TMP("AQAOPC5A",$J)
 Q
 ;
 ;
 ;
COUNTP ; >> SUBRTN to print line for all find/act combos with counts by month
 S AQAOFA=0 ;get next finding
 F  S AQAOFA=$O(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA)) Q:AQAOFA=""  Q:AQAOSTOP=U  D
 .S AQAOAC=0 ;get next action for this finding
 .F  S AQAOAC=$O(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC)) Q:AQAOAC=""  Q:AQAOSTOP=U  D
 ..S AQAOFAT=^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC) ;f/a subtl
 ..W !,AQAOFA,"/",AQAOAC,AQAODLM
 ..;
 ..;                   ;fill in counts for all months
 ..S AQAOMON=0
 ..F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  Q:AQAOSTOP=U  D
 ...S X=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC,AQAOMON))
 ...I X=0 W "0",AQAODLM Q
 ...W X,AQAODLM S AQAOARM(AQAOMON)=AQAOARM(AQAOMON)+X ;print count
 ..W AQAOFAT
 ..;
 ..;fill in percentages for all months for this find/act combo
 ..W !,AQAODLM S AQAOMON=0
 ..F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  Q:AQAOSTOP=U  D
 ...S X=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC,AQAOMON))
 ...I X=0 W "0.00%",AQAODLM Q
 ...W $J(X/AQAOIT*100,8,2),"%",AQAODLM ;month as %
 ..W $J(AQAOFAT/AQAOIT*100,8,2),"%" ;find/act as % of totl
 ;
 ;
 ;print monthly totals for this indicator
 W !,"Monthly:",AQAODLM S AQAOMON=0
 F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  Q:AQAOSTOP=U  D
 .W AQAOARM(AQAOMON),AQAODLM ;# of occ by month
 W AQAOIT
 ;                       ;print % for each month for this indicator
 S AQAOMON=0 W !,AQAODLM
 F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  Q:AQAOSTOP=U  D
 .W:(AQAOIT>0) $J(AQAOARM(AQAOMON)/AQAOIT*100,8,2),"%",AQAODLM ;% of occ
 W !
 Q
 ;
 ;
MONTHS ; >> SUBRTN to create array for months in report&init their counts
 S X=AQAOBD,Y=0 F  Q:X>AQAOED  D
 .I $E(X,4,5)=13 S X=($E(X,1,3)+1)_"0100"
 .S AQAOARM($E(X,1,5))=0
 .S X=X+100,Y=Y+1
 Q
 ;
 ;
HDG2 ; >> SUBRTN to print 2nd half of heading
 W "  ",AQAORNG,!
 W !!,"Find/Act",AQAODLM
 S X=0
 F  S X=$O(AQAOARM(X)) Q:X=""  W 1700+$E(X,1,3),"/",$E(X,4,5),AQAODLM
 W " Totals"
 W !
 Q
