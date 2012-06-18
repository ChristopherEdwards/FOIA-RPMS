ADGDSQA ; IHS/ADC/PDW/ENM - DAY SURGERY PROVIDER QA REPORT ; [ 12/16/2003  4:06 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;**3**;MAR 25, 1999
 ;
 ;IHS/ITSC/WAR 12/16/03 Added call to 'old'(?) init of IHS variales
 I '$D(DGOPT("QA1"))&($D(^DG(43,1,9999999.02))) D VAR^ADGVAR
 ;
 W @IOF,!!!?28,"DAY SURGERY PROVIDER QA REPORT",!!
 ;***> get date range
BDATE S %DT="AEQ",%DT("A")="Select beginning date: ",X="" D ^%DT
 G END:Y=-1 S DGBDT=Y
EDATE S %DT="AEQ",%DT("A")="Select ending date: ",X="" D ^%DT
 G END:Y=-1 S DGEDT=Y
 ;
PROV ;***> select one or all providers
 K DIR S DIR(0)="Y",DIR("A")="Print Report for ALL Providers"
 S DIR("B")="NO",DIR("?")="Answer NO to print for only ONE provider"
 D ^DIR S DGPV=Y G EDATE:$D(DUOUT),END:$D(DTOUT),END:$D(DIROUT)
ONE I Y=0 K DIR S DIR(0)="PO^6:EMQZ" D ^DIR
 G PROV:$D(DIRUT),ONE:Y=-1 S DGPV=Y
 ;
 ;***> get print device
 W !!,*7,"Report requires wide printer or condensed print.",!
 S %ZIS="PQ" D ^%ZIS G END:POP,QUE:$D(IO("Q")) U IO G CALC
QUE K IO("Q") S ZTRTN="CALC^ADGDSQA",ZTDESC="DAY SURG PROV QA"
 ;F DGI="DGBDT","DGEDT","DGPV" S ZTSAVE(DGI)=""
 F DGI="DGBDT","DGEDT","DGPV","DGOPT(""GEN"")","DGOPT(""QA"")","DGOPT(""QA1"")" S ZTSAVE(DGI)=""
 D ^%ZTLOAD D ^%ZISC K ZTSK
END K Y,DGBDT,DGEDT D HOME^%ZIS Q
 ;
 ;
CALC ;***> Set up sorted utility file for date range
 S DGDT=DGBDT-.0001,DGEDT=DGEDT+.2400 K ^TMP($J)
C1 S DGDT=$O(^ADGDS("AA",DGDT)) G NEXT:DGDT="",NEXT:DGDT>DGEDT S DFN=0
C2 S DFN=$O(^ADGDS("AA",DGDT,DFN)) G C1:DFN="" S DGDFN1=0
C3 S DGDFN1=$O(^ADGDS("AA",DGDT,DFN,DGDFN1)) G C2:DGDFN1=""
 G C3:'$D(^ADGDS(DFN,0)),C3:'$D(^ADGDS(DFN,"DS",DGDFN1,0)) S DGSTR=^(0)
 S (DGPRV,DGPRC,DGSRV,DGOBS,DGADM,DGADWK,DGNM,DGCMT)=""
 S DGPRV=$P(DGSTR,U,6) I DGPV'=1,DGPRV'=+DGPV G C3  ;wrong provider
 ;
 ;***> check for sent to obs, admit
 S DGSTR2=$G(^ADGDS(DFN,"DS",DGDFN1,2)),DGADM=$P(DGSTR2,U,2)  ;admit?
 S DGOBS=$P(DGSTR,U,7) G C4:DGADM="Y" ;obsrv?/skip next lines if admit
 ;
 ;***> check if admitted w/in time limit in site parameters
 ;IHS/ITSC/WAR 12/16/03 if parameter is not set - site never used DS -
 ;        I added $G to DGOPT("QA1") as defensive code. Chk Q41 of the
 ;        logged PIMS issues.
 ;S Y=9999999-DGDT,X1=$P(DGDT,"."),X2=$P(DGOPT("QA1"),U,2) D C^%DTC
 S Y=9999999-DGDT,X1=$P(DGDT,"."),X2=$P($G(DGOPT("QA1")),U,2) D C^%DTC
 S DGX=9999999-X
 S DGX=$O(^DGPM("ATID1",DFN,DGX))
 I DGX'="",DGX'>Y S DGADWK=9999999-DGX
 ;
C4 I (DGOBS="")&(DGADM="")&(DGADWK="") G C3
 ;
 ;***> set variables of data items to be printed
 S DGCHT=$S($D(^AUPNPAT(DFN,41,DUZ(2),0)):$P(^(0),U,2),1:"??") ;chrt #
 S DGPRC=$P(DGSTR,U,2),DGSRV=$P(DGSTR,U,5)  ;procedure/service
 S:DGSRV'="" DGSRV=$P($G(^DIC(45.7,DGSRV,0)),U)
 S DGCMT=$P($G(DGSTR2),U,6) S DGNM=$P(^DPT(DFN,0),U) ;comment/patient
 ;
 S ^TMP($J,$P(DGDT,"."),DGNM,DFN)=DGCHT_U_DGSRV_U_DGPRV_U_DGPRC_U_DGOBS_U_DGADM_U_DGADWK_U_DGCMT G C3
 ;
 ;***> go to print rtn
NEXT G ^ADGDSQA1
