ADGCRBL2 ; IHS/ADC/PDW/ENM - PRINT CODED A SHEET LIST ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S (DGZTOT,DGZETOT)=0  ;patient and a sheet counts
 S DGPAGE=0,DGSTOP=""  ;page # & U flag
 S DGDUZ=$P(^VA(200,DUZ,0),U,2)  ;user's initials
 S DGFAC=$P(^DIC(4,DUZ(2),0),U)  ;facility name
 S DGLIN="",$P(DGLIN,"=",80)=""  ;line variable
 ;
DSCH ;***> sort by discharge dates and print info
 S DGZDDT=0 D HEAD
DS1 S DGZDDT=$O(^TMP("DGZCRBL",$J,DGZDDT)) G TOTAL:DGZDDT=""
 S DGZNAME=0
 I $Y>(IOSL-5) D NEWPG I DGSTOP=U G END
 W !?25,"DISCHARGED ON: ",$$FMTE^XLFDT(DGZDDT,"2D"),! ;print dsch date
 ;
DS2 S DGZNAME=$O(^TMP("DGZCRBL",$J,DGZDDT,DGZNAME))
 I DGZNAME="" W ! G DS1
 S DFN=0
DS3 S DFN=$O(^TMP("DGZCRBL",$J,DGZDDT,DGZNAME,DFN)) G DS2:DFN=""
 S DGZIDFN=0
DS4 S DGZIDFN=$O(^TMP("DGZCRBL",$J,DGZDDT,DGZNAME,DFN,DGZIDFN))
 G DS3:DGZIDFN=""
 ;
 S DGSTR=^TMP("DGZCRBL",$J,DGZDDT,DGZNAME,DFN,DGZIDFN)
 S DGZVDFN=+DGSTR,DGZVDT=$P(DGSTR,U,2),DGZTOT=DGZTOT+1
 S DGCHT=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 W !,$E(DGZNAME,1,20),?25,$J(DGCHT,6)  ;print name & chart #
 W ?35,$$FMTE^XLFDT(DGZVDT,"2D") ;admit date
 S Y=$P(^AUPNVSIT(DGZVDFN,0),U,13) W ?49,$$FMTE^XLFDT(Y,"2D") ;dt mod
 S Y=$P(^AUPNVSIT(DGZVDFN,0),U,14) I Y]"" S DGZETOT=DGZETOT+1
 W ?62,$$FMTE^XLFDT(Y,"2D") ;dt exp
 I $Y>(IOSL-5) D NEWPG I DGSTOP=U G END1
 G DS4
 ;
TOTAL ;***> print totals
 W !!?10,"Total Coded A Sheets: ",DGZTOT
 W !?16,"Total Exported: ",DGZETOT,!
 ;
END ;***> eoj
 K DIR
 I IOST["C-" S DIR(0)="E",DIR("A")="Press RETURN to continue" D ^DIR
END1 W @IOF D KILL^ADGUTIL
 K ^TMP("DGZCRBL",$J) D ^%ZISC Q
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 I DGPAGE>0 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 S DGPAGE=DGPAGE+1
 W ?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?(80-$L(DGFAC)/2),DGFAC,?70,"Page ",DGPAGE
 W ! D TIME^ADGUTIL W ?33,"CODED A SHEETS" S Y=DT X ^DD("DD") W !,Y
 W ?28,"for ",$E(DGZBDT,4,5)_"/"_$E(DGZBDT,6,7)_"/"_$E(DGZBDT,2,3)
 W " to ",$E(DGZEDT,4,5)_"/"_$E(DGZEDT,6,7)_"/"_$E(DGZEDT,2,3)
 W !!,"PATIENT NAME",?25,"CHART #",?35,"ADMIT DATE"
 W ?49,"LAST MOD",?62,"EXPORTED ON",!,DGLIN,!
 Q
