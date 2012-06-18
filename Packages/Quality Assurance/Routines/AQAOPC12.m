AQAOPC12 ; IHS/ORDC/LJF - PRINT OCC BY INDICATOR W/ CRIT ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains the code to print the trending report by review
 ;criteria based on the selected indicator and date range.
 ;
INIT ; >>> initialize variables
 I $D(AQAOIOMX),IOT'="HFS" D
 .S X=AQAOIOMX X ^%ZOSF("RM")
 .S X="IOPTCH16" D ENDR^%ZISS W IOPTCH16
 D INIT^AQAOUTIL S AQAOHCON="Patient"
 S AQAOTY="OCCURRENCES BY INDICATOR WITH CRITERIA VALUES"
 S AQAORG=$E(AQAOBD,4,5)_"/"_$E(AQAOBD,6,7)_"/"_$E(AQAOBD,2,3)_" to "
 S AQAORG=AQAORG_$E(AQAOED,4,5)_"/"_$E(AQAOED,6,7)_"/"_$E(AQAOED,2,3)
 ;
 ; >>> print report
 I AQAOTYP="L" D LISTING
 I AQAOSTOP'=U D SUMMARY^AQAOPC13
 ;
END ; >>> eoj
 I $D(AQAODLM) W !!,*7,"*** STOP CAPTURE NOW ***",!
 I $D(AQAOIOMX),IOT'="HFS" S X=IOM X ^%ZOSF("RM")
 I $D(IOPTCH16),IOT'="HFS" S X="IOPTCH10" D ENDR^%ZISS W IOPTCH10
 D ^%ZISC I AQAOSTOP=U W @IOF
 I '$D(ZTQUEUED),AQAOSTOP="" D PRTOPT^AQAOVAR
 K ^TMP("AQAOPC1",$J) K ^TMP("AQAOPC11",$J)
 K IOPTCH10,IOPTCH16 D KILL^AQAOUTIL Q
 ;
 ;
LISTING ; >>> SUBRTN to print occurrence listing if selected
 Q:'$D(^TMP("AQAOPC1",$J))  ;no entries
 I $D(AQAODLM) D DLMHDG I 1 ;ascii file heading
 E  D HEADING^AQAOUTIL,HDG1 ;printed heading
 S AQAOSUB=0 I '$D(AQAOXSN) D LIST2 Q  ;straight listing
 ;                                     ;extra sort listing
 F  S AQAOSUB=$O(^TMP("AQAOPC1",$J,AQAOSUB)) Q:AQAOSUB=""  Q:AQAOSTOP=U  D LIST2
 Q
 ;
 ;
LIST2 ; >> SUBRTN for each AQAOSUB list occ and criteria
 I AQAOSUB'=0 W !!?AQAOIOMX-$L(AQAOSUB)/2,AQAOSUB,! ;extra sort headng
 S AQAODT=0
 F  S AQAODT=$O(^TMP("AQAOPC1",$J,AQAOSUB,AQAODT)) Q:AQAODT=""  Q:AQAOSTOP=U  D
 .S AQAON=0
 .F  S AQAON=$O(^TMP("AQAOPC1",$J,AQAOSUB,AQAODT,AQAON)) Q:AQAON=""  Q:AQAOSTOP=U  D
 ..S AQAOSTR=^TMP("AQAOPC1",$J,AQAOSUB,AQAODT,AQAON)
 ..I '$D(AQAODLM),($Y>(IOSL-4)) D NEWPG^AQAOUTIL Q:AQAOSTOP=U  D HDG1
 ..S Y=AQAODT X ^DD("DD") I $D(AQAODLM) S Y=$P(Y,",")_" "_$P(Y,",",2)
 ..I $D(AQAODLM) W !,$P(AQAOSTR,U),AQAODLM,Y ;case & date ASCII format
 ..E  W !,$P(AQAOSTR,U),?10,$E(Y_" ",1,11) ;print case & date
 ..D CRITLOOP ;loop thru criteria and print values
 Q
 ;
 ;
CRITLOOP ; >> SUBRTN to loop thru crit values for occurrence and print
 K AQAOCX S (Z,AQAOSV)=1
 ;put criteria into print order, then print them
 F I=2:2 S X=$P(AQAOSTR,U,I),Y=$P(AQAOSTR,U,I+1) Q:X=""  D
 .S Y=Y_"      ",Y=$E(Y,1,6) ;make sure 6 characters long
LOOPBACK .I $D(AQAOCX(Z,X)) S Z=Z+1 G LOOPBACK ;some may have more than one
 .S AQAOCX(Z,X)=Y ;set array=line# (Z) & value (Y)
 .S:(Z>AQAOSV) AQAOSV=Z S Z=1 ;update highest line #, reset Z
 ;
 G CRITPRT:AQAOSV=1 ;one line of data only
 S X=0 F  S X=$O(AQAOCR(X)) Q:X=""  D  ;fill in lines #2 and above
 .F Z=2:1:AQAOSV I '$D(AQAOCX(Z,X)) S AQAOCX(Z,X)="      "
 ;
CRITPRT S Z=0 F  S Z=$O(AQAOCX(Z)) Q:Z=""  W:Z>1 !?21 D  ;print each line
 .S X=0 ;print each criterion value
 .F  S X=$O(AQAOCX(Z,X)) Q:X=""  D
 ..W $S($D(AQAODLM):AQAODLM,1:"  "),AQAOCX(Z,X)
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
