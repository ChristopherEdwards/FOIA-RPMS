ACHSRGPR ;IHS/OIT/FCJ - GPRA REPORT DOS VS DATE PO ISS
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**18**;JUN 11, 2001
 ;
 ;Auth end DOS used, if not available then Auth Beg DOS
ST ;
 S ACHSIO=IO
 W !!,"This is a GPRA report to calculate the days between the Date of Service"
 W !,"and when the Purchase Order was issued. Date of Service is the estimated"
 W !,"End Date of Service, even if the document has been paid."
 W !!,"The Purchase Order will either be selected by Fiscal Year or the Date of"
 W !,"Service to fall within the Fiscal year Beginning and Ending date."
 W !!,"The report is selected and sorted by issue date."
 ;
FY ; Select FY.
 S ACHSACFY=$$FYSEL^ACHS(1)
 G:$D(DTOUT)!$D(DUOUT) EXT
 I '$D(^ACHS(9,DUZ(2),"FY",ACHSACFY)) W !!,*7,"Fiscal year '",ACHSACFY,"' does not exist. -- TRY AGAIN" G FY
FYDT ;BEG AND END DATES FOR THE FY, DOS >ACHSBFY OR <ACHSEFY
 I $P(^ACHSF(DUZ(2),0),U,7)=1 S ACHSBFY=ACHSACFY-1701_($P(^ACHSF(DUZ(2),0),U,6)-1),ACHSEFY=ACHSACFY-1700_($P(^ACHSF(DUZ(2),0),U,6)-1)
 E  S ACHSBFY=ACHSACFY-1700_($P(^ACHSF(DUZ(2),0),U,6)-1),ACHSEFY=ACHSACFY-1699_($P(^ACHSF(DUZ(2),0),U,6)-1)
 ;
BDT ; Enter beginning date.
 S ACHSBDT=$$DATE^ACHS("B","GPRA","")
 G EXT:$D(DUOUT)!$D(DTOUT)!(ACHSBDT<1)
EDT ; Enter the ending date.
 S ACHSEDT=$$DATE^ACHS("E","GPRA","")
 G BDT:$D(DUOUT),EXT:$D(DTOUT)!(ACHSEDT<1),EDT:$$EBB^ACHS(ACHSBDT,ACHSEDT)
DOS ; REPORT BY DOS WITHIN FY OR FY
 ; Enter FY or DOS
 S ACHSRTYD="F"
 S DIR(0)="S^F:Fiscal Year;D:Date of Service",DIR("B")="Fiscal Year",DIR("A")="Report PO's by "
 S DIR("?")="Report PO's by FY or by Date of service for sites that move money forward into one FY account."
 D ^DIR
 G EXT:$D(DUOUT),EXT:$D(DTOUT),EXT:$D(DIROUT)
 S ACHSRTYD=Y
TYPE ; TYPE OF REPORT SUMARRY OR DETAILED
 ; Enter Summary or Detail
 S DIR(0)="S^S:SUMMARY;D:DETAILED",DIR("A")="Report Type ",DIR("B")="SUMMARY"
 S DIR("?")="Detail will display indiviual PO, Summary will display only the totals"
 D ^DIR
 G EXT:$D(DUOUT),EXT:$D(DTOUT),EXT:$D(DIROUT)
 S ACHSRTYP=Y
DEV ; Select device for report.
 W !
 S %=$$PB^ACHS
 I %=U!$D(DTOUT)!$D(DUOUT) G EXT
 I %="B" D VIEWR^XBLM("CALC^ACHSRGPR"),EN^XBVK("VALM") G EXT
 K IOP,%ZIS
 S %ZIS="PQ"
 D ^%ZIS,SLV^ACHSFU:$D(IO("S"))
 K %ZIS
 I POP W !,*7,"No device specified." D HOME^%ZIS G EXT
 G:'$D(IO("Q")) CALC
 K IO("Q")
 I $E(IOST)'="P" W *7,!,"Please queue to printers only." G DEV
 S ZTIO="",ACHSQIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTRTN="CALC^ACHSRGPR",ZTDESC="CHS GPRA Report, "_ACHSRPT_", "_$$FMTE^XLFDT(ACHSBDT)_" to "_$$FMTE^XLFDT(ACHSEDT)
 F %="ACHSQIO","ACHSBDT","ACHSEDT","ACHSRTYP","ACHSACFY","ACHSEFY","ACHSBFY","ACHSRTYD" S ZTSAVE(%)=""
 D ^%ZTLOAD
 G:'$D(ZTSK) DEV
 ;
 ;end of interactive portion.  The rest performed by Taskman
 ;
 ;
CALC ;EP - TaskMan.
 D FC^ACHSUF
 I $D(ACHSERR),ACHSERR=1 G EXT
 S ACHSTRDT=ACHSBDT-1
 K ^TMP("ACHSRGPR",$J)
 S (^TMP("ACHSRGPR",$J,"TOTDOC"),^TMP("ACHSRGPR",$J,"TOTPDOC"),^TMP("ACHSRGPR",$J,"TOTADOC"))=0
 S (^TMP("ACHSRGPR",$J,"TOTDAY"),^TMP("ACHSRGPR",$J,"TOTPDAY"),^TMP("ACHSRGPR",$J,"TOTADAY"))=0
 ;
TRDT ; Loop thru transaction date x-ref.
 F  S ACHSTRDT=$O(^ACHSF(DUZ(2),"TB",ACHSTRDT)) Q:(ACHSTRDT>ACHSEDT)!(ACHSTRDT'?1N.N)  D
 .; Loop thru transaction type
 .S ACHSTYPE=""
 .F  S ACHSTYPE=$O(^ACHSF(DUZ(2),"TB",ACHSTRDT,ACHSTYPE)) Q:ACHSTYPE=""  D
 ..Q:ACHSTYPE'="I"
 ..S DA=0
 ..F  S DA=$O(^ACHSF(DUZ(2),"TB",ACHSTRDT,ACHSTYPE,DA)) Q:DA'?1N.N  D
 ...Q:('$D(^ACHSF(DUZ(2),"D",DA,0)))!($P(^ACHSF(DUZ(2),"D",DA,0),U,12)=4)   ;QUIT IF CANCELLED
 ...I ACHSRTYD="F" Q:ACHSACFY'=$P(^ACHSF(DUZ(2),"D",DA,0),U,27)   ;IF REPORT BY FY TEST FOR FY
 ...S ACHSDOCN=$P(^ACHSF(DUZ(2),"D",DA,0),U),(X1,ACHSORDT)=$P(^(0),U,2)
 ...D DOSDT
 ...;S (X2,ACHSEDOS)=$S($P(^ACHSF(DUZ(2),"D",DA,3),U,2)'="":$P(^ACHSF(DUZ(2),"D",DA,3),U,2),1:$P(^ACHSF(DUZ(2),"D",DA,3),U))
 ...I ACHSRTYD="D" Q:(ACHSEDOS<ACHSBFY)!(ACHSEDOS>ACHSEFY)   ;IF REPORT BY DOS TEST FOR DOS
 ...D ^%DTC
 ...S ACHSORDT=$E(ACHSORDT,4,5)_"/"_$E(ACHSORDT,6,7)_"/"_$E(ACHSORDT,2,3)
 ...S ACHSEDOS=$E(ACHSEDOS,4,5)_"/"_$E(ACHSEDOS,6,7)_"/"_$E(ACHSEDOS,2,3)
 ...I ACHSRTYP="D" D
 ....S ^TMP("ACHSRGPR",$J,ACHSDOCN)=$E(ACHSACFY,3,4)_"-"_ACHSFC_"-"_ACHSDOCN_U_ACHSEDOS_U_ACHSORDT
 ....I X>0 S $P(^TMP("ACHSRGPR",$J,ACHSDOCN),U,5)=X
 ....E  S $P(^TMP("ACHSRGPR",$J,ACHSDOCN),U,4)=$FN(X,"-")
 ...I X>0 S ^TMP("ACHSRGPR",$J,"TOTADAY")=^TMP("ACHSRGPR",$J,"TOTADAY")+X,^("TOTADOC")=^("TOTADOC")+1
 ...E  S ^TMP("ACHSRGPR",$J,"TOTPDAY")=^TMP("ACHSRGPR",$J,"TOTPDAY")+$FN(X,"-"),^("TOTPDOC")=^("TOTPDOC")+1
 ...S ^TMP("ACHSRGPR",$J,"TOTDOC")=^TMP("ACHSRGPR",$J,"TOTDOC")+1
 ...S ^TMP("ACHSRGPR",$J,"TOTDAY")=^TMP("ACHSRGPR",$J,"TOTDAY")+X
 D PRINT
 ;
EXT ; Kill vars, close device, quit.
 I $D(IO("S")) X ACHSPPC
 E  D ^%ZISC
 D EN^XBVK("ACHS"),^ACHSVAR:'$D(ZTQUEUED)
 K ^TMP("ACHSRGPR",$J)
 K DTOUT,DUOUT,ZTSK
 Q
 ;
DOSDT ;FIND THE DOS TO USE
 ;TEST FOR PAID DOCUMENT, USE ACT DOS OR EST EDOS IF NOT DEFINED USE EST BEG DOS
 S X2=""
 I $P(^ACHSF(DUZ(2),"D",DA,0),U,12)=3 D
 .S T=0 F  S T=$O(^ACHSF(DUZ(2),"D",DA,"T",T)) Q:T'?1N.N  I $P(^ACHSF(DUZ(2),"D",DA,"T",T,0),U,2)="P" S (X2,ACHSEDOS)=$P(^(0),U,10) Q
 I X2="" S (X2,ACHSEDOS)=$S($P(^ACHSF(DUZ(2),"D",DA,3),U,2)'="":$P(^ACHSF(DUZ(2),"D",DA,3),U,2),1:$P(^ACHSF(DUZ(2),"D",DA,3),U)) ;EDOS="" use EST Beg DOS
 Q
 ;
PRINT ; 
 S ACHSVNDR="",ACHST1=$$C^XBFUNC("GPRA REPORT-AVERAGE DAYS BETWEEN PO ISSUE AND DOS")
 S ACHST2=$$C^XBFUNC("For the period "_$$FMTE^XLFDT(ACHSBDT)_" through "_$$FMTE^XLFDT(ACHSEDT)),X3=0
 D BRPT^ACHSFU
 X:$D(IO("S")) ACHSPPO
 D:ACHSRTYP="D" HDR,DET
 S ACHSRTYP="S" D HDR,SUM
 G EXT Q
 ;
DET ;DETAILED REPORT
 S ACHSDOCN=""
 F  S ACHSDOCN=$O(^TMP("ACHSRGPR",$J,ACHSDOCN)) Q:ACHSDOCN'?1N.N  D  Q:$D(DUOUT)!$D(DTOUT)
 .W !,$P(^TMP("ACHSRGPR",$J,ACHSDOCN),U),?19,$P(^(ACHSDOCN),U,2),?35,$P(^(ACHSDOCN),U,3),?51,$J($P(^(ACHSDOCN),U,4),5),?65,$J($P(^(ACHSDOCN),U,5),5)
 .I $Y>ACHSBM D RTRN^ACHS Q:$D(DUOUT)!$D(DTOUT)  D HDR
 Q
SUM ;SUMMARY REPORT
 ;
 W !!,"TOTAL Documents:  ",$J(^TMP("ACHSRGPR",$J,"TOTDOC"),10)
 W !,"TOTAL Days: ",?18,$J(^TMP("ACHSRGPR",$J,"TOTDAY"),10)
 S ACHSAVG=0
 I ^TMP("ACHSRGPR",$J,"TOTDOC") S ACHSAVG=$S(^TMP("ACHSRGPR",$J,"TOTDOC")>0:^TMP("ACHSRGPR",$J,"TOTDAY")/^TMP("ACHSRGPR",$J,"TOTDOC"),1:0)
 W !,"Average Days: ",?18,$J(ACHSAVG,10,2),!
 W !!,"TOTAL Documents Prior or = to DOS:  ",?37,$J(^TMP("ACHSRGPR",$J,"TOTPDOC"),10)
 W !,"TOTAL Days for Prior or = to DOS: ",?37,$J(^TMP("ACHSRGPR",$J,"TOTPDAY"),10)
 S ACHSAVG=0
 I ^TMP("ACHSRGPR",$J,"TOTPDOC")>0 S ACHSAVG=$S(^TMP("ACHSRGPR",$J,"TOTDOC")>0:^TMP("ACHSRGPR",$J,"TOTPDAY")/^TMP("ACHSRGPR",$J,"TOTPDOC"),1:0)
 W !,"Average Days Prior or = to DOS: ",?37,$J(ACHSAVG,10,2),!
 W !!,"TOTAL Documents After DOS:  ",?28,$J(^TMP("ACHSRGPR",$J,"TOTADOC"),10)
 W !,"TOTAL Days After DOS: ",?28,$J(^TMP("ACHSRGPR",$J,"TOTADAY"),10)
 S ACHSAVG=0
 I ^TMP("ACHSRGPR",$J,"TOTADOC"),1>0 S ACHSAVG=$S(^TMP("ACHSRGPR",$J,"TOTDOC")>0:^TMP("ACHSRGPR",$J,"TOTADAY")/^TMP("ACHSRGPR",$J,"TOTADOC"),1:0)
 W !,"Average Days After DOS: ",?28,$J(ACHSAVG,10,2),!
 Q
 ;
HDR ; Paginate.
 S ACHSPG=ACHSPG+1
 W @IOF,!!?19,"***  CONTRACT HEALTH MANAGEMENT SYSTEM  ***",!,ACHSUSR,?71,"Page",$J(ACHSPG,3),!,ACHSLOC,!,ACHST1,!,ACHSTIME,!,ACHST2
 I ACHSRTYP="D" D
 .W !!,?50,"Days Prior",?64,"Days After"
 .W !,"PO Number",?16,"Date of Service",?33,"Date of Issue",?49,"or = to DOS",?67,"DOS"
 W !,$$REPEAT^XLFSTR("=",79),!
 Q
