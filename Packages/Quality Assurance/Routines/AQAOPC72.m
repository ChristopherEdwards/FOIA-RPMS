AQAOPC72 ; IHS/ORDC/LJF - PRINT SINGLE CRIT REPORT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine contains the code to print the report of criterion
 ;values by month for a particular indicator.
 ;
 ; >> initialize variables
 D MONTHS ;set array for all months included in report
 ;use wide margin if date range more than 7 months
 S AQAOIOMX=80
 I Y>7 S AQAOIOM=IOM,(AQAOIOMX,X)=132 X:IOT'="HFS" ^%ZOSF("RM")
 S AQAOLIN3="",$P(AQAOLIN3,"-",AQAOIOMX-10)=""
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 ;S X=$O(AQAOCR(0)),AQAOTY="CRITERION: "_AQAOCR(X)
 ;S AQAOTY=$E(AQAOTY,1,59)
 S AQAOTY="TRENDS BY MONTH FOR A CRITERION"
 S Y=AQAOBD X ^DD("DD") S AQAORNG="("_Y,Y=AQAOED-31 X ^DD("DD")
 S AQAORNG=AQAORNG_" - "_Y_")" ;date range
 ;
LOOP ; >> loop thru ^tmp to get data then print it
 S AQAOM=$$INDNAME ;set indicator heading
 I AQAOPAGE=0 D HEADING^AQAOUTIL
 I AQAOTYPE="L" D HDG2
 I '$D(AQAOCNT) D  G EXIT
 .W !?10,">> NO OCCURRENCES FOUND FOR THIS INDICATOR <<"
 I AQAOTYPE="L" D  G EXIT:AQAOSTOP=U D NEWPG^AQAOUTIL G EXIT:AQAOSTOP=U
 .D LIST
 D HDG3,COUNTP ;print counts by month
 ;
 ;
EXIT ; >>> eoj        
 I IOST["C-" D PRTOPT^AQAOVAR
 I $D(AQAOIOM),IOT'="HFS" S X=AQAOIOM X ^%ZOSF("RM")
 D ^%ZISC D KILL^AQAOUTIL
 K ^TMP("AQAOPC7",$J),^TMP("AQAOPC7A",$J),^TMP("AQAOPC7B",$J)
 K ^UTILITY("DIQ1",$J)
 Q
 ;
 ;
LIST ; >> SUBRTN to list occurrences
 S AQAOSUB=0 I '$D(AQAOXSN) D PRINT Q
 F  S AQAOSUB=$O(^TMP("AQAOPC7A",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D
 .W !!?AQAOIOMX-$L(AQAOSUB)\2,AQAOSUB,! D PRINT
 Q
 ;
PRINT ; >> SUBRTN to print each occurrence
 S AQAODT=0
 F  S AQAODT=$O(^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 .S AQAOID=0
 .F  S AQAOID=$O(^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT,AQAOID)) Q:AQAOID=""  Q:AQAOSTOP=U  D
 ..I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG2
 ..S X=^TMP("AQAOPC7A",$J,AQAOSUB,AQAODT,AQAOID)
 ..W !,AQAOID S Y=AQAODT X ^DD("DD") W ?10,Y
 ..W ?25,$P(X,U),?35,$P(X,U,2),?45,$P(X,U,3)
 Q
 ;
 ;
COUNTP ; >> SUBRTN to to loop thru extra sort then print line
 S AQAOSUB=0  I '$D(AQAOXSN) D VALUES Q
 F  S AQAOSUB=$O(^TMP("AQAOPC7",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D
 .W !!?AQAOIOMX-$L(AQAOSUB)\2,AQAOSUB,! D VALUES
 Q
 ;
VALUES ; >> SUBRTN to print criteria values by month
 D MONTHS ;set array for all months included in report
 S AQAOVAL=0
 F  S AQAOVAL=$O(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL)) Q:AQAOVAL=""  Q:AQAOSTOP=U  D
 .S AQAOSUBT=^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL) ;value subtl
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG3
 .W !!,AQAOVAL,?8
 .;
 .;fill in counts for all months
 .S AQAOMON=0
 .F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  Q:AQAOSTOP=U  D
 ..I '$D(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)) D  Q
 ...S X=$X+9 W ?X
 ..S X=^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)
 ..W ?($X+1),$J(X,8) ; print count for month
 ..S AQAOARM(AQAOMON)=AQAOARM(AQAOMON)+X ;increment total
 .W ?AQAOIOMX-11,$J(AQAOSUBT,8)
 .I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG3
 .;
 .;fill in percentages for all months for this criterion value
 .W !?8 S AQAOMON=0
 .F  S AQAOMON=$O(AQAOARM(AQAOMON)) Q:AQAOMON=""  Q:AQAOSTOP=U  D
 ..I '$D(^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)) D  Q
 ...S X=$X+9 W ?X
 ..S X=^TMP("AQAOPC7",$J,AQAOSUB,AQAOVAL,AQAOMON)
 ..S X=(X/^TMP("AQAOPC7B",$J,AQAOSUB,AQAOMON)*100)_"%"
 ..W ?($X+1),$J(X,8,2) ; print % for month
 .W ?AQAOIOMX-10,$J(AQAOSUBT/AQAOCNT(AQAOSUB)*100,8,2),"%"
 Q:AQAOSTOP=U
 ;
 ;
 ;print monthly totals for this indicator
 I $Y>(IOSL-4) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG3
 W !?9,AQAOLIN3,!,"Monthly:" S AQAOMON=0
 F  S AQAOMON=$O(AQAOARM(AQAOMON))  Q:AQAOMON=""  Q:AQAOSTOP=U  D
 .W ?($X+1),$J(AQAOARM(AQAOMON),8) ;# of occ by month
 W ?AQAOIOMX-11,$J(+$G(AQAOCNT(AQAOSUB)),8),! ;PATCH 3
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
HDG2 ; >> SUBRTN to print 2nd half of heading for listing
 W ?AQAOIOMX-$L(AQAORNG)/2,AQAORNG,!
 W ?AQAOIOMX-$L(AQAOM)/2,AQAOM,!,AQAOLIN2,!
 S X=$O(AQAOCR(0)) W ?3,"CRITERION: "_AQAOCR(X)
 W !,"Case ID",?10,"Occ Date",?25,"Age",?35,"Sex",?45,"Value"
 W !,AQAOLINE
 Q
 ;
HDG3 ; >> SUBRTN to print 2nd half of heading for stats pages
 W ?AQAOIOMX-$L(AQAORNG)/2,AQAORNG,!
 W ?AQAOIOMX-$L(AQAOM)/2,AQAOM,!,AQAOLIN2,!
 S X=$O(AQAOCR(0)) W ?3,"CRITERION: "_AQAOCR(X)
 W !,"Values  " S X=0
 F  S X=$O(AQAOARM(X)) Q:X=""  W ?($X+2),$E(X,4,5),"/",1700+$E(X,1,3)
 W ?AQAOIOMX-9," Totals",!,AQAOLINE
 Q
 ;
 ;
INDNAME() ;ENTRY POINT EXTR VAR - sets the indicator heading variable
 S AQAOT=^AQAO(2,AQAOIND,0),AQAOM=$P(AQAOT,U)_"-"_$P(AQAOT,U,2)
 S Y=$P(AQAOT,U,3),C=$P(^DD(9002168.2,.03,0),U,2) D Y^DIQ
 S AQAOZ=" ("_Y ;add on process vs. outcome
 S Y=$P(AQAOT,U,4),C=$P(^DD(9002168.2,.04,0),U,2) D Y^DIQ
 S AQAOZ=AQAOZ_"/"_Y ;add on sentinel vs. rate-based
 S Y=$P(AQAOT,U,5) I Y]"" S C=$P(^DD(9002168.2,.05,0),U,2) D Y^DIQ
 S AQAOZ=$S(Y="":AQAOZ_")",1:AQAOZ_"/"_Y_")"),AQAOM=AQAOM_AQAOZ
 S AQAOM="*** "_AQAOM_" ***"
 Q AQAOM
