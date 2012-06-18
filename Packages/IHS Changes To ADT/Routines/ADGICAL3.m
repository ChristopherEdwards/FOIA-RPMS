ADGICAL3 ; IHS/ADC/PDW/ENM - DS INCOMPLETE CHARTS LIST PRINT ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGIOM=IOM,X=132 X ^%ZOSF("RM")
 S DGPAGE=0,DGSTOP=""
 S DGDUZ=$P(^VA(200,DUZ,0),U,2),DGFAC=$P(^DIC(4,DUZ(2),0),U)
 S DGX=$E(DGBDT,4,5)_"/"_$E(DGBDT,6,7)_"/"_($E(DGBDT,1,3)+1700)
 S DGY=$E(DGEDT,4,5)_"/"_$E(DGEDT,6,7)_"/"_($E(DGEDT,1,3)+1700)
 S DGDTS="from "_DGX_" to "_DGY  ;printable date range
 S (DGLIN,DGLIN1)="",$P(DGLIN,"-",132)="",$P(DGLIN1,"=",132)=""
 D HEAD
 ;
 ;***> loop thru ^utility
 S DGNAM=0
A1 S DGNAM=$O(^TMP("DGZICAL",$J,DGNAM)) G END:DGNAM="" S DFN=0
A2 S DFN=$O(^TMP("DGZICAL",$J,DGNAM,DFN)) G A1:DFN="" S DGDFN2=0
A3 S DGDFN1=$O(^TMP("DGZICAL",$J,DGNAM,DFN,DGDFN1)) G A2:DGDFN1=""
 ;
 ;***> set variables
 S DGSTR=^TMP("DGZICAL",$J,DGNAM,DFN,DGDFN1)
 S DGAD=$P(DGSTR,U,2),DGSV=$P(DGSTR,U,6)
 S DGOPD=$P(DGSTR,U,3),DGOPR=$P(DGSTR,U,4),DGCOM=$P(DGSTR,U,5)
 ;
 ;***> print line
 W !!,$$NAME,?18,$J($P(DGSTR,U),7)
 W:DGAD'="" ?27,$E(DGAD,4,5)_"/"_$E(DGAD,6,7)_"/"_$E(DGAD,2,3)
 W ?38 W:DGSV'="" $E($P($G(^DIC(45.7,DGSV,0)),U,3),1,3)
 W:DGOPD'="" ?44,$E(DGOPD,4,5)_"/"_$E(DGOPD,6,7)_"/"_$E(DGOPD,2,3)
 W:DGOPR'="" ?55,$E(DGOPR,4,5)_"/"_$E(DGOPR,6,7)_"/"_$E(DGOPR,2,3)
 ;
 G A3:'$D(^ADGDSI(DFN,"DT",DGDFN1,"P",0))
 ;
 ;**> loop thru & find provi with chart deficiencies for this admission
 S DGDFN2=0
A4 S DGDFN2=$O(^ADGDSI(DFN,"DT",DGDFN1,"P",DGDFN2)) G A3:+DGDFN2'=DGDFN2
 S DGPRV=$P(^ADGDSI(DFN,"DT",DGDFN1,"P",DGDFN2,0),U)
 W:$X>65 ! W ?65
 W:DGPRV'="" $E($P($G(^VA(200,DGPRV,0)),U),1,18)  ;provider name
 ;
 ;***> find all chart deficiencies for provider
 S DGX=0 F  Q:+DGX'=DGX  Q:DGSTOP=U  D
 .S DGX=$O(^ADGDSI(DFN,"DT",DGDFN1,"P",DGDFN2,"CD",DGX)) Q:+DGX'=DGX
 .S DGY=$P(^ADGDSI(DFN,"DT",DGDFN1,"P",DGDFN2,"CD",DGX,0),U)
 .I DGY'="",$D(^ADGCD(DGY,0)) W ?90,$E($P(^ADGCD(DGY,0),U),1,16)
 .I ($Y+6)>IOSL D NEWPG
 I $X>110 W ! I ($Y+6)>IOSL D NEWPG G END:DGSTOP=U
 W ?110,$E(DGCOM,1,13),?123,$E($$INS^ADGMREC(DFN),1,8)
 G END:DGSTOP=U G A4
 ;
 ;***> eoj
END W !!,DGLIN,!,"Total Count:  ",DGCNT
 I IOST["C-" D PRTOPT^ADGVAR
 S X=DGIOM X ^%ZOSF("RM") K DGIOM
 W @IOF D KILL^ADGUTIL K ^TMP("DGZICAL",$J)
 D ^%ZISC Q
 ;
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 W ?37,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?132-$L(DGFAC)\2,DGFAC
 W ! D TIME^ADGUTIL W ?52,"DS INCOMPLETE CHARTS LIST"
 S DGPAGE=DGPAGE+1 W ?122,"Page ",DGPAGE
 W !,$E(DT,4,5)_"/"_$E(DT,6,7)_"/"_$E(DT,2,3),?52,DGDTS
 W !!,"Patient Name",?20,"HRCN",?27,"Surg Date",?38,"Srv"
 W ?44,"Op Dict",?55,"Op Rvcd",?65,"Provider",?90,"Chart Def"
 W ?110,"Comments",?122,"Insurance",!,DGLIN1
 Q
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E G HEAD
 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 G HEAD:DGSTOP'=U Q
 ;
 ;
NAME() ; -- returns printable name
 NEW N
 S N=$S(DGSRT=1:DGNAM,1:$P(^DPT(DFN,0),U))
 Q $E(N,1,15)
