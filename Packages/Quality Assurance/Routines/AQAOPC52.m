AQAOPC52 ; IHS/ORDC/LJF - PRINT QTR PROGRESS RPRT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn prints occ finding/action counts by month in a matrix,
 ;months along the top and finding/action pairs down the side.
 ;Totals by month and totals by finding/action pair are also printed.
 ;Any action plans associated with the indicator are printed at the 
 ;bottom of each indicator page.
 ;
INIT ; >> initialize variables
 D MONTHS ;set array for all months included in report
 ;use wide margin if date range has more than 7 months
 S AQAOIOMX=80
 I Y>7 S AQAOIOM=IOM,(AQAOIOMX,X)=132 X:IOT'="HFS" ^%ZOSF("RM")
 S AQAOLIN3="",$P(AQAOLIN3,"-",AQAOIOMX-10)=""
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY=$S($D(AQAORPTT):AQAORPTT,1:"PROGRESS REPORT")
 S Y=AQAOBD X ^DD("DD") S AQAORNG="("_Y,Y=AQAOED-31 X ^DD("DD")
 S AQAORNG=AQAORNG_" - "_Y_")" ;date range
 ;
LOOP ; >> loop thru ^tmp to get data then print it
 S AQAOF=0
 F  S AQAOF=$O(^TMP("AQAOPC5",$J,1,AQAOF)) Q:AQAOF=""  Q:AQAOSTOP=U  D
 .S:AQAOTYP=1 AQAOIND=$O(^TMP("AQAOPC5",$J,1,AQAOF,0)),AQAOM=$$INDNAME
 .I AQAOPAGE=0 D HEADING^AQAOUTIL,HDG2 I 1
 .E  D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 .S AQAOIND=0
 .F  S AQAOIND=$O(^TMP("AQAOPC5",$J,1,AQAOF,AQAOIND)) Q:AQAOIND=""  Q:AQAOSTOP=U  D
 ..I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ..S AQAOM=$$INDNAME ;set indicator heading
 ..I AQAOTYP>1 W !!,AQAOM,!
 ..S AQAOIT=$G(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND))
 ..I AQAOIT=0 W !?10,">> NO OCCURRENCES FOUND FOR THIS INDICATOR <<" Q
 ..E  D COUNTP ;print counts by month
 ..D ACTION^AQAOPC54 ;include action plans
 ;
 ;
EXIT ; >>> eoj        
 I IOST["C-" D PRTOPT^AQAOVAR
 I $D(AQAOIOM),IOT'="HFS" S X=AQAOIOM X ^%ZOSF("RM")
 D ^%ZISC D KILL^AQAOUTIL
 K ^TMP("AQAOPC5",$J),^TMP("AQAOPC5A",$J),^TMP("AQAOPC5B",$J)
 Q
 ;
 ;
 ;
COUNTP ; >> SUBRTN to print line for all find/act combos with counts by month
 D MONTHS ;PATCH 2
 S AQAOFA=0 ;get next finding
 F  S AQAOFA=$O(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA)) Q:AQAOFA=""  Q:AQAOSTOP=U  D
 .S AQAOAC=0 ;get next action for this finding
 .F  S AQAOAC=$O(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC)) Q:AQAOAC=""  Q:AQAOSTOP=U  D
 ..S AQAOFAT=^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC) ;f/a subtl
 ..I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ..W !,AQAOFA,"/",AQAOAC,?8
 ..;
 ..;fill in counts for all months
 ..S AQAOMON=0
 ..F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  Q:AQAOSTOP=U  D
 ...I '$D(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC,AQAOMON)) D  Q
 ....S X=$X+9 W ?X
 ...S X=^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC,AQAOMON)
 ...W ?($X+1),$J(X,8) ; print count for month
 ...S AQAOARM(AQAOMON)=AQAOARM(AQAOMON)+X ;increment total
 ..W ?AQAOIOMX-11,$J(AQAOFAT,8)
 ..;
 ..;fill in percentages for all months for this find/act combo
 ..I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ..W !?8 S AQAOMON=0
 ..F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  Q:AQAOSTOP=U  D
 ...I '$D(^TMP("AQAOPC5A",$J,AQAOF,AQAOIND,AQAOFA,AQAOAC,AQAOMON)) D  Q
 ....S X=$X+9 W ?X
 ..W ?AQAOIOMX-12,$J(AQAOFAT/AQAOIT*100,8,2),"%" ;find/act as % total
 ;
 ;
 ;print monthly totals for this indicator
 I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 W !?9,AQAOLIN3,!,"Monthly:" S AQAOMON=0
 F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  Q:AQAOSTOP=U  D
 .W ?($X+1),$J(AQAOARM(AQAOMON),8) ;# of occ by month
 W ?AQAOIOMX-11,$J(+AQAOIT,8)
 ;                                 ;print % for each month for ind
 S AQAOMON=0 W !?8
 F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  Q:AQAOSTOP=U  D
 .W:AQAOIT>0 $J(AQAOARM(AQAOMON)/AQAOIT*100,8,2),"%" ;% of occ
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
 W ?AQAOIOMX-$L(AQAORNG)/2,AQAORNG,!
 I AQAOTYP=1 W ?AQAOIOMX-$L(AQAOM)/2,AQAOM
 E  W ?AQAOIOMX-$L(AQAOF)/2,AQAOF
 W !,AQAOLIN2,!,"Find/Act"
 S X=0
 F  S X=$O(AQAOARM(X)) Q:X=""  W ?($X+2),1700+$E(X,1,3),"/",$E(X,4,5)
 W ?AQAOIOMX-9," Totals"
 W !,AQAOLINE
 Q
 ;
 ;
INDNAME()          ;ENTRY POINT EXTR VAR - sets the indicator heading variable
 S AQAOT=^AQAO(2,AQAOIND,0),AQAOM=$P(AQAOT,U)_"-"_$P(AQAOT,U,2)
 S Y=$P(AQAOT,U,3),C=$P(^DD(9002168.2,.03,0),U,2) D Y^DIQ
 S AQAOZ=" ("_Y ;add on process vs. outcome
 S Y=$P(AQAOT,U,4),C=$P(^DD(9002168.2,.04,0),U,2) D Y^DIQ
 S AQAOZ=AQAOZ_"/"_Y ;add on sentinel vs. rate-based
 S Y=$P(AQAOT,U,5) I Y]"" S C=$P(^DD(9002168.2,.05,0),U,2) D Y^DIQ
 S AQAOZ=$S(Y="":AQAOZ_")",1:AQAOZ_"/"_Y_")"),AQAOM=AQAOM_AQAOZ
 S AQAOM="*** "_AQAOM_" ***"
 Q AQAOM
