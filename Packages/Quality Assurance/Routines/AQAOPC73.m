AQAOPC73 ; IHS/ORDC/LJF - PRINT SINGLE CRIT RPRT-ASCII ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine prints the single criterion report in ASCII format
 ;using the delimiter the user has chosen.
 ;
 ; >> initialize variables
 D MONTHS ;set array for all months included in report
 ;use wide margin if date range has more than 7 months
 S AQAOIOMX=80
 I Y>7 S AQAOIOM=IOM,(AQAOIOMX,X)=132 X:IOT'="HFS" ^%ZOSF("RM")
 S AQAOLIN3="",$P(AQAOLIN3,"-",AQAOIOMX-10)=""
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 ;S X=$O(AQAOCR(0)),AQAOTY="TRENDS BY CRITERIA: "_AQAOCR(X) ;PATCH 3
 ;S AQAOTY=$E(AQAOTY,1,60) ;PATCH 3
 S AQAOTY="TRENDS BY MONTH FOR A CRITERION" ;PATCH 3
 S Y=AQAOBD X ^DD("DD") S AQAORNG="("_Y,Y=AQAOED-31 X ^DD("DD")
 S AQAORNG=AQAORNG_" - "_Y_")" ;date range
 ;
LOOP ; >> loop thru ^tmp to get data then print it
 S AQAOM=$$INDNAME ;set indicator heading
 D DLMHDG^AQAOUTIL,HDG2
 I '$D(AQAOCNT) W !,">> NO OCCURRENCES FOUND FOR THIS INDICATOR <<" Q  ;PATCH 3
 I AQAOTYPE="L" D LIST
 D HDG3,COUNTP ;print counts by month
 ;
 ;
EXIT ; >>> eoj        
 W !!,*7,"*** STOP CAPTURE NOW ***"
 I IOST["C-" D PRTOPT^AQAOVAR
 I $D(AQAOIOM),IOT'="HFS" S X=AQAOIOM X ^%ZOSF("RM")
 D ^%ZISC D KILL^AQAOUTIL
 K ^TMP("AQAOPC7",$J),^TMP("AQAOPC7A",$J),^UTILITY("DIQ1",$J)
 K ^TMP("AQAOPC7B",$J) ;PATCH 3
 Q
 ;
LIST ; >> SUBRTN to list occurrences
 S AQAOSUB=0 I '$D(AQAOXSN) D PRINT Q
 F  S AQAOSUB=$O(^TMP("AQAOPC7A",$J,AQAOSUB)) Q:AQAOSUB=""  D
 .W !!?AQAOIOMX-$L(AQAOSUB)\2,AQAOSUB,! D PRINT
 Q
 ;
PRINT ; >> SUBRTN to print each occurrence
 S AQAODT=0
 F  S AQAODT=$O(^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT)) Q:AQAODT=""  D
 .S AQAOID=0
 .F  S AQAOID=$O(^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT,AQAOID)) Q:AQAOID=""  D
 ..S X=^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT,AQAOID)
 ..S Y=AQAODT X ^DD("DD") ;PATCH 3
 ..S X(",")=" ",Y=$$REPLACE^XLFSTR(Y,.X) ;PATCH 3
 ..W !,AQAOID,AQAODLM,Y,AQAODLM,$P(X,U) ;PATCH 3
 ..W AQAODLM,$P(X,U,2),AQAODLM,$P(X,U,3)
 Q
 ;
 ;
COUNTP ; >> SUBRTN to to loop thru extra sort then print line
 S AQAOSUB=0  I '$D(AQAOXSN) D VALUES Q
 F  S AQAOSUB=$O(^TMP("AQAOPC7",$J,AQAOSUB)) Q:AQAOSUB=""  D
 .W !!,AQAOSUB,! D VALUES
 Q
 ;
VALUES ; >> SUBRTN to print criteria values by month
 D MONTHS ;PATCH 3
 S AQAOVAL=0
 F  S AQAOVAL=$O(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL)) Q:AQAOVAL=""  D
 .S AQAOSUBT=^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL) ;value subtl
 .W !,AQAOVAL
 .;
 .;fill in counts for all months
 .S AQAOMON=0
 .F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  D
 ..W AQAODLM
 ..I '$D(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)) Q
 ..S X=^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON) ;cnt 4 month;PATCH 3
 ..W X ;PATCH 3
 ..S AQAOARM(AQAOMON)=AQAOARM(AQAOMON)+X ;increment total
 .W AQAODLM,AQAOSUBT
 .;
 .;fill in percentages for all months for this criterion value
 .;W !,AQAODLM,(AQAOSUBT/AQAOCNT*100),"%" ;value as % of total;PATCH 3
 .W !,AQAODLM S AQAOMON=0 ;PATCH 3
 .F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  D  ;PATCH 3
 ..I '$D(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)) W AQAODLM Q  ;PATCH 3
 ..S X=^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON) ;PATCH 3
 ..W $J((X/^TMP("AQAOPC7B",$J,AQAOSUB,AQAOMON)*100),8,2),"%" ;PATCH 3
 ..W AQAODLM
 .W $J((AQAOSUBT/AQAOCNT(AQAOSUB)*100),8,2),"%" ;PATCH 3
 ;
 ;print monthly totals for this indicator
 W !,AQAOLIN3,!,"Monthly:" S AQAOMON=0
 F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  D
 .W AQAODLM,AQAOARM(AQAOMON) ;# of occ by month
 W AQAODLM,+AQAOCNT(AQAOSUB) ;PATCH 3
 ;                                 ;print % for each month for ind
 ;S AQAOMON=0 W ! ;PATCH 3
 ;F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  D  ;PATCH 3
 ;.W AQAODLM ;PATCH 3
 ;.W:AQAOCNT>0 (AQAOARM(AQAOMON)/AQAOCNT*100),"%" ;% of occ;PATCH 3
 W ! Q
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
HDG2 ; >> SUBRTN to print 2nd half of heading for listing
 W !,AQAORNG,!,AQAOM,!,AQAOLIN2 ;PATCH 3
 W !,"Case ID",AQAODLM,"Occ Date",AQAODLM,"Age",AQAODLM
 W "Sex",AQAODLM,"Value",!!
 Q
 ;
HDG3 ; >> SUBRTN to print 2nd half of heading for stats section
 W !,AQAORNG,!,AQAOM,!!,"Values  " ;PATCH 3
 S X=0
 F  S X=$O(AQAOARM(X)) Q:X=""  W AQAODLM,1700+$E(X,1,3),"/",$E(X,4,5)
 W AQAODLM," Totals",!
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
 Q AQAOM
