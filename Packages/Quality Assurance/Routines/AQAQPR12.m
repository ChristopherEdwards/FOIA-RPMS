AQAQPR12 ;IHS/ANMC/LJF - ADMISSIONS BY PROVIDER; [ 08/06/92  4:29 PM ]
 ;;2.2;STAFF CREDENTIALS;;01 OCT 1992
 ;
 ;>>> initialize variables <<<
 S AQAQPAGE=0,AQAQSTOP="",AQAQDUZ=$P(^DIC(3,DUZ,0),U,2)
 S AQAQSITE=$P(^DIC(4,DUZ(2),0),U)    ;set site
 S AQAQRG=$E(AQAQBDT,4,5)_"/"_$E(AQAQBDT,6,7)_"/"_$E(AQAQBDT,2,3)_" to "
 S AQAQRG=AQAQRG_$E(AQAQEDT,4,5)_"/"_$E(AQAQEDT,6,7)_"/"_$E(AQAQEDT,2,3)
 S AQAQLINE="",$P(AQAQLINE,"=",80)=""
 S AQAQLIN2="",$P(AQAQLIN2,"-",80)=""
 S (AQAQICNT,AQAQSCNT,AQAQWCNT,AQAQTCNT,AQAQTICT,AQAQTWCT)=0
 ;
 I '$D(^UTILITY("AQAQPR1",$J)) D HEAD W !!,">>> NO DATA FOR DATES",!! G WAIT
 ;
 ;>>> pull data by provider, then print <<<
 S AQAQPRV=0
 F  S AQAQPRV=$O(^UTILITY("AQAQPR1",$J,AQAQPRV)) Q:AQAQPRV=""  Q:AQAQSTOP=U  D
 .I (AQAQSCNT>0)!(AQAQICNT>0) D COUNT
 .I AQAQPAGE=0 D HEAD
 .E  D NEWPG Q:AQAQSTOP=U
 .W !!?80-$L(AQAQPRV)/2,AQAQPRV,!  ;print provider subheading
 .S (AQAQDT,AQAQLST)=0
 .F  S AQAQDT=$O(^UTILITY("AQAQPR1",$J,AQAQPRV,AQAQDT)) Q:AQAQDT=""  Q:AQAQSTOP=U  D
 ..I $E(AQAQLST,4,5)'=$E(AQAQDT)&(AQAQLST'=0) D COUNT  ;if new month, get subcounts
 ..S DFN=0
 ..F  S DFN=$O(^UTILITY("AQAQPR1",$J,AQAQPRV,AQAQDT,DFN)) Q:DFN=""  Q:AQAQSTOP=U  D
 ...S AQAQSTR=^(DFN) D LINE  ;print line with admission data
 ;
 ;>>> do last month subcount, then print totals <<<
 G END:AQAQSTOP=U
 I (AQAQSCNT>0)!(AQAQICNT>0)!(AQAQWCNT>0) D COUNT
 D NEWPG W !!,"        ADMISSIONS: ",AQAQTCNT
 W !,"    ICU ADMISSIONS: ",AQAQTICT
 W !,"  TOTAL ADMISSIONS: ",AQAQTCNT+AQAQTICT
 W !,"NEWBORN ADMISSIONS: ",AQAQTWCT
 W !,AQAQLINE
WAIT I IOST["C-" W ! K DIR S DIR(0)="E",DIR("A")="RETURN to continue" D ^DIR
 ;
 ;
END ;EP;>>> eoj <<<
 W @IOF D ^%ZISC D KILL^AQAQUTIL K ^UTILITY("AQAQPR1",$J) Q
 ;
 ;>>> END OF MAIN ROUTINE <<<
 ;
 ;
NEWPG ;***> SUBRTN for end of page control
 I IOST'?1"C-".E D HEAD S AQAQSTOP="" Q
 I AQAQPAGE>0 K DIR S DIR(0)="E" D ^DIR S AQAQSTOP=X
 I AQAQSTOP'=U D HEAD
 Q
 ;
HEAD ;***> SUBRTN to print heading
 I (IOST["C-")!(AQAQPAGE>0) W @IOF
 W !,AQAQLINE S AQAQPAGE=AQAQPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,AQAQDUZ,?80-$L(AQAQSITE)/2,AQAQSITE
 S AQAQTY="ADMISSIONS BY PROVIDER"
 W ! D ^%T W ?80-$L(AQAQTY)/2,AQAQTY,?70,"Page: ",AQAQPAGE
 S Y=DT X ^DD("DD") W !,Y,?30,AQAQRG  ;date range
 W !,AQAQLINE
 W !,"Admit Date",?20,"Patient",?43,"Ward",?48,"Srv",?55,"Admitting DX"
 W !,AQAQLIN2
 Q
 ;
LINE ;***> SUBRTN to print line of data and increment counts
 S Y=AQAQDT X ^DD("DD") W !,Y    ;admit date/time
 W ?20,$E($P(AQAQSTR,U),1,20)  ;patient name
 W ?43,$E($P(AQAQSTR,U,2),1,3),?48,$E($P(AQAQSTR,U,3),1,3)  ;ward & srv
 W ?55,$E($P(AQAQSTR,U,4),1,23)  ;admitting dx
 I $P(AQAQSTR,U,5)=1 S AQAQICNT=AQAQICNT+1  ;increment icu count
 E  I $P(AQAQSTR,U,3)="NEWBORN" S AQAQWCNT=AQAQWCNT+1  ;newborn count
 E  S AQAQSCNT=AQAQSCNT+1   ;increment subcount
 I $Y>(IOSL-5) D NEWPG
 Q
 ;
COUNT ;***> SUBRTN to print subcounts and increment totals
 W !,"        Admissions: ",AQAQSCNT S AQAQTCNT=AQAQTCNT+AQAQSCNT
 W !,"    ICU Admissions: ",AQAQICNT S AQAQTICT=AQAQTICT+AQAQICNT
 W !,"  Total Admissions: ",AQAQICNT+AQAQSCNT
 W !,"Newborn Admissions: ",AQAQWCNT S AQAQTWCT=AQAQTWCT+AQAQWCNT
 W !,AQAQLINE S (AQAQSCNT,AQAQICNT,AQAQWCNT)=0
 Q
