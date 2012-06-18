ADGDSQA1 ; IHS/ADC/PDW/ENM - DAY SURGERY PROVIDER QA REPORT PRINT ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;***> initialize variables
 S DGFAC=$P(^DIC(4,DUZ(2),0),U),DGPAGE=0  ;facility name/page #
 S DGDUZ=$P(^VA(200,DUZ,0),U,2)  ;user's initials
 S (DGLIN,DGLIN1)="",$P(DGLIN,"=",132)="",$P(DGLIN1,"-",132)="" ;lines
 S Y=DGBDT D DD^%DT S DGX=Y S Y=DGEDT-.2400 D DD^%DT S DGY=Y
 S DGDTLIN="from "_DGX_" to "_DGY  ;date range line set
 S X=132,DGZRM=IOM X ^%ZOSF("RM") D HEAD
 S (DGPRV,DGPRC,DGCNT,DGOBS,DGADM,DGADWK,DGCHT)="",DGDT=0
 ;
 ;***> step thru utility file for sorted data
A1 S DGDT=$O(^TMP($J,DGDT)) G TOTAL:DGDT="" S DGNM=0
A2 S DGNM=$O(^TMP($J,DGDT,DGNM)) G A1:DGNM="" S DFN=0
A3 S DFN=$O(^TMP($J,DGDT,DGNM,DFN)) G A2:DFN="" S DGSTR=^(DFN)
 ;
 ;chart #/service/provider
 S DGCHT=$P(DGSTR,U),DGSRV=$P(DGSTR,U,2),DGPRV=$P(DGSTR,U,3)
 ;procedure/los on obsrv/admitted?
 S DGPRC=$P(DGSTR,U,4),DGOBS=$P(DGSTR,U,5),DGADM=$P(DGSTR,U,6)
 ;admitted w/in limit/comments/increment count
 S DGADWK=$P(DGSTR,U,7),DGCMT=$P(DGSTR,U,8),DGCNT=DGCNT+1
 ;
PRINT ;***> print line of data
 W !,$E(DGDT,4,5)_"/"_$E(DGDT,6,7)_"/"_$E(DGDT,2,3),?11,$E(DGNM,1,20)
 W ?34,DGCHT,?41,$E(DGSRV,1,3)
 W:DGPRV'="" ?47,$S($D(^VA(200,DGPRV,0)):$E($P(^(0),U),1,20),1:"??")
 W ?70,$E(DGPRC,1,25),?100,$S(DGOBS="":"",1:"OBS ")
 W ?100,$S(DGADM="":"",1:"ADMIT")
 W ?100,$S(DGADWK="":"",1:"ADM W/IN WEEK")
 W ?115,DGCMT
 I $Y>(IOSL-8) D NEWPG G END1:DGSTOP=U
 G A3
 ;
 ;***> print total
TOTAL W !!,DGLIN1,!?5,"TOTAL PATIENTS:  ",+DGCNT
 ;
END ;***> eoj
 I IOST["C-" D PRTOPT^ADGVAR
END1 W @IOF S X=DGZRM X ^%ZOSF("RM")
 D KILL^ADGUTIL K ^TMP($J) D ^%ZISC Q
 ;
 ;
NEWPG ;***> subrtn for end of page control
 I IOST'?1"C-".E D HEAD S DGSTOP="" Q
 I DGPAGE>0 K DIR S DIR(0)="E" D ^DIR S DGSTOP=X
 I DGSTOP'=U D HEAD
 Q
 ;
HEAD ;***> subrtn to print heading
 I (IOST["C-")!(DGPAGE>0) W @IOF
 S DGPAGE=DGPAGE+1
 W ?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?132-$L(DGFAC)\2,DGFAC,?125,"Page ",DGPAGE
 W ! D TIME^ADGUTIL W ?49,"DAY SURGERY PROVIDER QA REPORT"
 S Y=DT D DD^%DT W !,Y,?48,DGDTLIN,!
 W !,"DATE",?11,"PATIENT",?34,"HRCN",?41,"SRV",?47,"PROVIDER"
 W ?70,"PROCEDURE",?100,"ACTION",?117,"COMMENTS",!,DGLIN
 Q
