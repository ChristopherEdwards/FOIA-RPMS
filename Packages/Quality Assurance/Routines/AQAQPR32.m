AQAQPR32 ;IHS/ANMC/LJF - DISCHARGES BY PROVIDER & DX; [ 07/09/1999  2:26 PM ]
 ;;2.2;STAFF CREDENTIALS;**8**;JULY 9, 1999
 ;;AQAQ*2*8;Y2K FIX;CS;2990708
 ;
 ;>>> initialize variables <<<
 S AQAQPAGE=0,AQAQSTOP="",AQAQDUZ=$P(^DIC(3,DUZ,0),U,2)
 S AQAQSITE=$P(^DIC(4,DUZ(2),0),U) ;set site
 ;BEGIN Y2K FIX BLOCK
 ;S AQAQRG=$E(AQAQBDT,4,5)_"/"_$E(AQAQBDT,6,7)_"/"_$E(AQAQBDT,2,3)_" to "
 ;S AQAQRG=AQAQRG_$E(AQAQEDT,4,5)_"/"_$E(AQAQEDT,6,7)_"/"_$E(AQAQEDT,2,3)
 S AQAQRG=$E(AQAQBDT,4,5)_"/"_$E(AQAQBDT,6,7)_"/"_($E(AQAQBDT,1,3)+1700)_" to " ; Y2000
 S AQAQRG=AQAQRG_$E(AQAQEDT,4,5)_"/"_$E(AQAQEDT,6,7)_"/"_($E(AQAQEDT,1,3)+1700) ; Y2000
 ;END Y2K FIX BLOCK
 S AQAQLINE="",$P(AQAQLINE,"=",80)=""
 S AQAQLIN2="",$P(AQAQLIN2,"-",80)=""
 S AQAQTCT=0,AQAQPRV=""
 ;
 I '$D(^UTILITY("AQAQPR3",$J)) D HEAD W !!,">>> NO DATA FOUND!!" G WAIT
 ;
 ;
 ;>>> loop1=get next provider & start new page & new counts
 S AQAQPRV=0
LOOP1 S AQAQPRV=$O(^UTILITY("AQAQPR3",$J,AQAQPRV)) G TOTALS:AQAQPRV=""
 G END:AQAQSTOP=U I AQAQPAGE=0 D HEAD
 E  D NEWPG G END:AQAQSTOP=U ;print heading with provider name
 S (AQAQGCT,AQAQPCT)=0 ;aqaqgct=icd group count;aqaqpct=prov count
 ;
 ;>>> loop2=for provider, get each icd code & subcount by icd groupings
 S AQAQICD=0
LOOP2 S AQAQICD=$O(^UTILITY("AQAQPR3",$J,AQAQPRV,AQAQICD))
 I AQAQICD="" D PROVCNT^AQAQPR33 G LOOP1 ;subtotal by prov & then loop
 I AQAQGCT=0 D GETGRP^AQAQPR33 ;print name of icd grouping
 I AQAQICD>($P(AQAQRNG,"-",2)_".999") D SUBCNT^AQAQPR33 ;group subcnt
 I (AQAQICD?1"V".E),(AQAQRNG'?1"V".E) D SUBCNT^AQAQPR33 ;v-codes
 ;
 ;>>> loop3&loop4=for each icd code, pull by visit date & visit dfn
 S AQAQDT=0
LOOP3 S AQAQDT=$O(^UTILITY("AQAQPR3",$J,AQAQPRV,AQAQICD,AQAQDT))
 G LOOP2:AQAQDT="" S AQAQVDFN=0
LOOP4 S AQAQVDFN=$O(^UTILITY("AQAQPR3",$J,AQAQPRV,AQAQICD,AQAQDT,AQAQVDFN))
 G LOOP3:AQAQVDFN="" S AQAQSTR=^(AQAQVDFN) D LINE ;print visit data
 G END:AQAQSTOP=U G LOOP4 ;quit if "^" entered OR continue looping
 ;
 ;
TOTALS ;>>> print facility totals <<<
 I $Y>(IOSL-4) D NEWPG
 W !!,"***TOTAL DIAGNOSES:  ",AQAQTCT,"***",!,AQAQLINE
WAIT I IOST["C-" W ! K DIR S DIR(0)="E",DIR("A")="RETURN to continue" D ^DIR
 ;
END ;EP;>>> eoj <<<
 W @IOF D ^%ZISC D KILL^AQAQUTIL K ^UTILITY("AQAQPR3",$J) Q
 ;
 ;
LINE ;***> SUBRTN to print line of visit data
 S AQAQV=^AUPNVSIT(AQAQVDFN,0),AQAQVDT=$P(AQAQV,U) ;visit node
 ;BEGIN Y2K FIX BLOCK
 ;W !,$E(AQAQVDT,4,5)_"/"_$E(AQAQVDT,6,7)_"/"_$E(AQAQVDT,2,3)_"-" ;adm
 W !,$E(AQAQVDT,4,5)_"/"_$E(AQAQVDT,6,7)_"/"_($E(AQAQVDT,1,3)+1700)_"-" ; Y2000;adm
 ;END Y2K FIX BLOCK
 ;BEGIN Y2K FIX BLOCK
 ;W $E(AQAQDT,4,5)_"/"_$E(AQAQDT,6,7)_"/"_$E(AQAQDT,2,3) ;dsc date
 W $E(AQAQDT,4,5)_"/"_$E(AQAQDT,6,7)_"/"_($E(AQAQDT,1,3)+1700) ; Y2000;dsc date
 ;END Y2K FIX BLOCK
 S AQAQY=$P(AQAQV,U,5),AQAQY=$P($G(^AUPNPAT(AQAQY,41,DUZ(2),0)),U,2)
 W ?23,$J(AQAQY,6) ;patient chart #
 S AQAQX=$P(^AUPNVINP($P(AQAQSTR,U,2),0),U,5)
 W:AQAQX'="" ?32,$E($P(^DIC(45.7,AQAQX,0),U),1,3) ;discharge srv
 S AQAQX=$P(^AUPNVPOV($P(AQAQSTR,U),0),U,12),AQAQZ=$P(^(0),U,4)
 W ?37,AQAQX ;primary or secondary
 W ?42,$E($P(^AUTNPOV(AQAQZ,0),U),1,37) ;provider narrative for dx
 S AQAQGCT=AQAQGCT+1,AQAQPCT=AQAQPCT+1 ;increment counts
 I $Y>(IOSL-5) D NEWPG
 Q
 ;
 ;
NEWPG ;EP;***> SUBRTN for end of page control
 I IOST'?1"C-".E D HEAD S AQAQSTOP="" Q
 I AQAQPAGE>0 K DIR S DIR(0)="E" D ^DIR S AQAQSTOP=X
 I AQAQSTOP'=U D HEAD
 Q
 ;
HEAD ;***> SUBRTN to print heading
 W @IOF,!,AQAQLINE S AQAQPAGE=AQAQPAGE+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,AQAQDUZ,?80-$L(AQAQSITE)/2,AQAQSITE
 S AQAQTY="INPATIENT DIAGNOSES BY PROVIDER"
 W ! D ^%T W ?80-$L(AQAQTY)/2,AQAQTY,?70,"Page: ",AQAQPAGE
 S Y=DT X ^DD("DD") W !,Y,?80-$L(AQAQPRV)/2,AQAQPRV ;prov name
 W !?30,AQAQRG,!,AQAQLINE ;date range and line
 W !,"Visit",?23,"Patient",!,"Dates",?23,"Chart #",?32,"Srv",?37,"P/S"
 W ?42,"Diagnosis Narrative",!,AQAQLIN2
 Q
