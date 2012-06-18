AQAQPR22 ;IHS/ANMC/LJF - PROCEDURES BY PROVIDER(PCC DATA); [ 07/09/1999  2:25 PM ]
 ;;2.2;STAFF CREDENTIALS;**8**;JULY 9, 1999
 ;;AQAQ*2*8;Y2K FIX;CS;2990708
 ;
 ;>>> initialize variables <<<
 S AQAQPAGE=0,AQAQSTOP="",AQAQDUZ=$P(^DIC(3,DUZ,0),U,2)
 S AQAQSITE=$P(^DIC(4,DUZ(2),0),U) ;set site
 ;BEGIN Y2K FIX BLOCK
 ;S AQAQRG=$E(AQAQBDT,4,5)_"/"_$E(AQAQBDT,6,7)_"/"_$E(AQAQBDT,2,3)_" to "
 ;S AQAQRG=AQAQRG_$E(AQAQEDT,4,5)_"/"_$E(AQAQEDT,6,7)_"/"_$E(AQAQEDT,2,3)
 S AQAQRG=$E(AQAQBDT,4,5)_"/"_$E(AQAQBDT,6,7)_"/"_($E(AQAQBDT,1,3)+1700)_" to "
 S AQAQRG=AQAQRG_$E(AQAQEDT,4,5)_"/"_$E(AQAQEDT,6,7)_"/"_($E(AQAQEDT,1,3)+1700) ; Y2000
 ;END Y2K FIX BLOCK
 S AQAQLINE="",$P(AQAQLINE,"=",80)=""
 S AQAQLIN2="",$P(AQAQLIN2,"-",80)=""
 S AQAQTCT=0,AQAQPRV=""
 ;
 I '$D(^UTILITY("AQAQPR2",$J)) D HEAD W !!,">>> NO DATA FOUND!!" G WAIT
 ;
 ;
 ;>>> loop1=get next provider & start new page & new counts
 S AQAQPRV=0
LOOP1 S AQAQPRV=$O(^UTILITY("AQAQPR2",$J,AQAQPRV)) G TOTALS:AQAQPRV=""
 G END:AQAQSTOP=U I AQAQPAGE=0 D HEAD
 E  D NEWPG G END:AQAQSTOP=U ;print heading with provider name
 S (AQAQGCT,AQAQPCT)=0 ;aqaqgct=icd group count;aqaqpct=prov count
 ;
 ;>>> loop2=for provider, get each icd code & subcount by icd groupings
 S AQAQICD=0
LOOP2 S AQAQICD=$O(^UTILITY("AQAQPR2",$J,AQAQPRV,AQAQICD))
 I AQAQICD="" D PROVCNT^AQAQPR23 G LOOP1 ;subtotal by prov & then loop
 I AQAQGCT=0 D GETGRP^AQAQPR23 ;print name of icd grouping
 I AQAQICD>($P(AQAQRNG,"-",2)_".999") D SUBCNT^AQAQPR23 ;group subcnt
 ;
 ;>>> loop3&loop4=for each icd code, pull by visit date & visit dfn
 S AQAQDT=0
LOOP3 S AQAQDT=$O(^UTILITY("AQAQPR2",$J,AQAQPRV,AQAQICD,AQAQDT))
 G LOOP2:AQAQDT="" S AQAQVDFN=0
LOOP4 S AQAQVDFN=$O(^UTILITY("AQAQPR2",$J,AQAQPRV,AQAQICD,AQAQDT,AQAQVDFN))
 G LOOP3:AQAQVDFN="" S AQAQSTR=^(AQAQVDFN) D LINE ;print visit data
 G END:AQAQSTOP=U G LOOP4 ;quit if "^" entered OR continue looping
 ;
 ;
TOTALS ;>>> print facility totals <<<
 I $Y>(IOSL-4) D NEWPG
 W !!,"***TOTAL PROCEDURES:  ",AQAQTCT,"***",!,AQAQLINE
WAIT I IOST["C-" K DIR S DIR(0)="E",DIR("A")="RETURN to continue" D ^DIR
 ;
END ;EP;>>> eoj <<<
 W @IOF D ^%ZISC D KILL^AQAQUTIL K ^UTILITY("AQAQPR2",$J) Q
 ;
 ;
LINE ;***> SUBRTN to print line of visit data
 ;BEGIN Y2K FIX BLOCK
 ;W !,$E(AQAQDT,4,5)_"/"_$E(AQAQDT,6,7)_"/"_$E(AQAQDT,2,3) ;visit date
 W !,$E(AQAQDT,4,5)_"/"_$E(AQAQDT,6,7)_"/"_($E(AQAQDT,1,3)+1700) ; Y2000;visit date
 ;END Y2K FIX BLOCK
 S AQAQX=$P(^AUPNVPRC($P(AQAQSTR,U),0),U,6),AQAQZ=$P(^(0),U,4)
 ;BEGIN Y2K FIX BLOCK
 ;W ?10,$E(AQAQX,4,5)_"/"_$E(AQAQX,6,7)_"/"_$E(AQAQX,2,3) ;proc date
 W ?11,$E(AQAQX,4,5)_"/"_$E(AQAQX,6,7)_"/"_($E(AQAQX,1,3)+1700) ; Y2000;proc date
 ;END Y2K FIX BLOCK
 S AQAQX=^AUPNVSIT(AQAQVDFN,0) W ?22,$P(AQAQX,U,7) ;serv category
 S AQAQY=$P(AQAQX,U,5),AQAQY=$P($G(^AUPNPAT(AQAQY,41,DUZ(2),0)),U,2)
 W ?26,$J(AQAQY,6) ;patient chart #
 W ?36,$E($P(^AUTNPOV(AQAQZ,0),U),1,43) ;provider narrative for proc
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
 S AQAQTY="PROCEDURES BY PROVIDER"
 W ! D ^%T W ?80-$L(AQAQTY)/2,AQAQTY,?70,"Page: ",AQAQPAGE
 S Y=DT X ^DD("DD") W !,Y,?80-$L(AQAQPRV)/2,AQAQPRV ;prov name
 W !?30,AQAQRG,!,AQAQLINE ;date range and line
 W !,"Visit",?11,"Proc.",?20,"Visit",?26,"Patient"
 W !,"Date",?11,"Date",?20,"Type",?26,"Chart #"
 W ?36,"Procedure Narrative",!,AQAQLIN2
 Q
