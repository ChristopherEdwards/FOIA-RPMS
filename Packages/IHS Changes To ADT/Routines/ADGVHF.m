ADGVHF ; IHS/ADC/PDW/ENM - CREATE VHOSP IF MISSING ; [ 03/25/1999  11:48 AM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
 ;
 ; -- select date range
DATE S %DT="AEQ",%DT("A")="Beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
DATE2 S %DT("A")="Ending date: ",X="" D ^%DT G DATE:Y=-1 S DGEDT=Y
 I DGEDT<DGBDT W *7,!!?5,"Ending date MUST NOT be before beginning date",! G DATE2
 I DGEDT'<DT S X1=DT,X2=-1 D C^%DTC S DGEDT=X
 ;
 ; -- select print device
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G LOOP
QUE K IO("Q") S ZTRTN="LOOP^ADGVHF" S ZTDESC="FIX MISSING VHOSP"
 F I="DGBDT","DGEDT" S ZTSAVE(I)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
 ;
END K Y,DGBDT,DGEDT D HOME^%ZIS Q
 ;
LOOP ;EP; loop thru discharges to check for missing vhosps
 S DGPG=0,DGDUZ=$P(^VA(200,DUZ,0),U,2),DGSITE=$P(^DIC(4,DUZ(2),0),U)
 S DGLIN="",$P(DGLIN,"=",80)="",DGLIN2="",$P(DGLIN2,"-",80)=""
 S DGQ="" D HED
 ;
 S DGDT=DGBDT-.0001,DGEND=DGEDT+.2400
 F  S DGDT=$O(^DGPM("ATT3",DGDT)) Q:DGDT=""!(DGDT>DGEND)!(DGQ=U)  D
 . S DGDSC=0
 . F  S DGDSC=$O(^DGPM("ATT3",DGDT,DGDSC)) Q:DGDSC=""!(DGQ=U)  D
 .. S DGD=$G(^DGPM(DGDSC,0)) Q:DGD=""
 .. S DGADM=$P(^DGPM(DGDSC,0),U,14) ;corresponding adm
 .. S DGA=$G(^DGPM(DGADM,0)) Q:DGA=""
 .. S DGV=$P($G(^DGPM(DGADM,"IHS")),U)
 .. I DGV]"",$O(^AUPNVINP("AD",DGV,0)) Q  ;entry okay
 .. D ADD
 ;
 K DFN,DGD,DGDUZ,DGLIN,DGLIN2,DGPG,DGSITE,DGTY
 K DGQ,DGDT,DGBDT,DGEDT,DGEND,DGDSC,DGADM,DGA,DGV D ^%ZISC
 Q
 ;
 ;
ADD ; -- SUBRTN to set variables to call apcdalvr
 D ^APCDEIN S DFN=$P(DGA,U,3)
 I DGV="" D
 . NEW DGPMA,DGPMDA,DGPMCA
 . S DGPMA=DGA,(DGPMDA,DGPMCA)=DGADM D APCDALV^ADGCALLS
 . S DGV=$P($G(^DGPM(DGADM,"IHS")),U)
 S APCDALVR("APCDPAT")=DFN
 S APCDALVR("APCDTDT")="`"_$P(DGD,U,4)
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.02 (ADD)]"
 S:$P(DGA,U,18)=10 APCDALVR("APCDTTT")=$$TFAC
 S APCDALVR("APCDLOOK")=$E(+DGD,1,12)
 S APCDALVR("APCDTDCS")="`"_$$DSRV
 S APCDALVR("APCDTADS")="`"_$P(^DGPM($O(^DGPM("APHY",DGADM,0)),0),U,9)
 S APCDALVR("APCDTAT")="`"_$P(DGA,U,4)
 S APCDALVR("APCDVSIT")=DGV
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) D MSG(2),NEWPG,KILL Q
 D MSG(1),KILL Q
 ;
KILL ; -- kill apcd variables
 D APCDEKL^ADGCALLS Q
 ;
TFAC() ; -- transfer facility
 NEW X S X=$P(DGD,U,5)
 Q $S(X["DIC(4":"VA/IHS.`",1:"VENDOR.`")_+X
 ;
DSRV() ; -- discharge service
 NEW X,Y
 S Y=9999999.9999999-$G(^DGPM(+$P(^DGPM(DGADM,0),U,17),0)) Q:'Y 0
 S X=$O(^DGPM("ATID6",+DFN,+$O(^DGPM("ATID6",+DFN,Y)),0))
 Q $P($G(^DGPM(+X,0)),U,9)
 ;
NEWPG ; -- end of page control
 I IOST'["C-" D HED Q
 K DIR S DIR(0)="E" D ^DIR S DGQ=X
 I DGQ'=U D HED
 Q
 ;
HED ; -- heading
 I (DGPG>0)!(IOST["C-") W @IOF
 W !,DGLIN S DGPG=DGPG+1
 W !?11,"*****Confidential Patient Data Covered by Privacy Act*****"
 W !,DGDUZ,?80-$L(DGSITE)/2,DGSITE S DGTY="FIX MISSING V HOSP ENTRIES"
 W ! D TIME^ADGUTIL W ?80-$L(DGTY)/2,DGTY,?70,"Page: ",DGPG
 S Y=DT X ^DD("DD") W !,Y
 W !,DGLIN2,!
 Q
 ;
MSG(DGN) ; -- prints message
 I $Y>(IOSL-4) D NEWPG Q:DGQ=U
 W !!,$P(^DPT(DFN,0),U),?25,$$HRC^ADGF(DFN),?35,$P($T(LINE+DGN),";;",2)
 Q
 ;
LINE ;;
 ;;V Hospitalization entry ADDED!
 ;;ERROR: Cannot add entry-call computer dept!
