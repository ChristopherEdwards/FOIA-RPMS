PSOMAUEX ;BIR/SAB-Auto expire of prescriptions ;10/10/96
 ;;7.0;OUTPATIENT PHARMACY;**40,73,139**;DEC 1997
 ;External reference to ^PS(59.7 is supported by DBIA 694
 ;External reference to STATUS^ORQOR2 is supported by DBIA 3458
 ;
 I '$G(DT) S DT=$$DT^XLFDT
 W @IOF,!!?10," ******* Auto Expire of Prescriptions *******"
 W !!,"You need to run this job only if expired prescriptions are showing up as active"
 W !,"orders on the Orders tab in CPRS. This could be due to the following:"
 W !,"1. The Expire Prescriptions [PSO EXPIRE PRESCRIPTIONS] option was not"
 W !,"   queued as a daily task.       *****  AND *****"
 W !,"2. Those patient's prescription(s) were never being accessed/viewed in"
 W !,"   Patient Prescription Processing [PSO LM BACKDOOR ORDERS] option.",!
 W !,"*******************************************************************************"
 W !,"* For sites that have not queued the Expire Prescriptions job on their        *"
 W !,"* daily task schedule, you  should do so by selecting the Queue Background    *"
 W !,"* Jobs [PSO AUTOQUEUE JOBS] option from the Maintenance (Outpatient Pharmacy) *"
 W !,"* [PSO MAINTENANCE] option and in the Edit Option Schedule template make an   *"
 W !,"* entry for Expire Prescriptions [PSO EXPIRE PRESCRIPTIONS] option and        *"
 W !,"* schedule it to run daily.                                                   *"
 W !,"*******************************************************************************"
 W !!
 S ZZIDT=$S($P($G(^PS(59.7,1,49.99)),"^",7):$P(^PS(59.7,1,49.99),"^",7),1:$P($G(^PS(59.7,1,49.99)),"^",4))
 I 'ZZIDT D  Q  ; V7.0 inst. dt not found, quit this job
 .W !!!,"***** Outpatient installation date was not found, *****"
 .W !,"***** therefore this job cannot be run!!!!!       *****",!!
 ;
 ; - Ask for START DATE
 K %DT S %DT(0)=-DT,%DT="AEP",%DT("A")="Start Date: "
 S %DT("B")=$$FMTE^XLFDT($$FMADD^XLFDT(ZZIDT\1-121))
 W ! D ^%DT I Y<0!($D(DTOUT)) Q
 S ZZIDT=Y
 ;
 K %DT D NOW^%DTC S %DT="RAEX",%DT(0)=%,%DT("A")="Select the Date/Time to queue this job: "
 W ! D ^%DT K %DT I $D(DTOUT)!(Y<0) W !!!?10,"Job not queued!" Q
 S ZTDTH=$G(Y),ZTSAVE("ZZIDT")="",ZTIO="",ZTRTN="EN^PSOMAUEX",ZTDESC="Auto expire of Rxs "
 D ^%ZTLOAD
 W:$D(ZTSK) !!,"Task Queued !",!
 Q
EN S X1=ZZIDT,X2=-121 D C^%DTC S ZZDT=X  ;setting the start date to 120 days before the install date
 S X1=DT,X2=-1 D C^%DTC S CDT=X  ; setting the end date to todate-1
 F  S ZZDT=$O(^PSRX("AG",ZZDT)) Q:'ZZDT!(ZZDT>CDT)  D EN1
 K PSOEXRX,PSOEXSTA,ZZIDT,ZZDT,CDT,ORN,PIFN,PSUSD,PRFDT,PDA,PSDTEST S:$D(ZTQUEUED) ZTREQ="@"
 Q
EN1 ;
 F PSOEXRX=0:0 S PSOEXRX=$O(^PSRX("AG",ZZDT,PSOEXRX)) Q:'PSOEXRX  D
 .Q:$P($G(^PSRX(PSOEXRX,2)),"^",6)'=ZZDT
 .I $D(^PSRX(PSOEXRX,0)) D EN2
 Q
EN2 ;
 S DA=$O(^PS(52.5,"B",PSOEXRX,0))
 I DA,$P($G(^PS(52.5,DA,0)),"^",2),$P($G(^(0)),"^",3) S DIK="^PS(52.5," D ^DIK K DIK
 I $D(^PS(52.4,PSOEXRX,0)) S DIK="^PS(52.4,",DA=PSOEXRX D ^DIK K DIK
 I $G(^PSRX(PSOEXRX,"H"))]"" K:$P(^PSRX(PSOEXRX,"H"),"^") ^PSRX("AH",$P(^PSRX(PSOEXRX,"H"),"^"),PSOEXRX) S ^PSRX(PSOEXRX,"H")=""
 S PSOEXSTA=$P($G(^PSRX(PSOEXRX,"STA")),"^")
 I PSOEXSTA=11 D
 .S $P(^PSRX(PSOEXRX,0),"^",19)=1
 .S ORN=$P($G(^PSRX(PSOEXRX,"OR1")),"^",2)
 .I ORN,+$$STATUS^ORQOR2(ORN)=6 D
 ..D EN^PSOHLSN1(PSOEXRX,"SC","ZE","Prescription is expired")
 I (PSOEXSTA="")!(PSOEXSTA>9) Q
 ;
 ;get only those Rxs whoes status lies within 0 & 9
 I PSOEXSTA?1N,+$P($G(^PSRX(PSOEXRX,2)),"^",6),+$P($G(^(2)),"^",6)<DT D
 .S $P(^PSRX(PSOEXRX,"STA"),"^")=11
 .I $P($G(^PSRX(PSOEXRX,"OR1")),"^",2) D
 ..D EN^PSOHLSN1(PSOEXRX,"SC","ZE","Prescription past expiration date")
 .S (PIFN,PSUSD,PRFDT)=0
 .F  S PIFN=$O(^PSRX(PSOEXRX,1,PIFN)) Q:'PIFN  S PSUSD=PIFN,PRFDT=+$P($G(^PSRX(PSOEXRX,1,PIFN,0)),"^")
 .I $G(PSUSD),'$P($G(^PSRX(PSOEXRX,1,PSUSD,0)),"^",18) D EN3
 Q
EN3 ;
 S (PSDTEST,PDA)=0 F  S PDA=$O(^PSRX(PSOEXRX,"L",PDA)) Q:'PDA  S:$P($G(^PSRX(PSOEXRX,"L",PDA,0)),"^",2)=PSUSD PSDTEST=1
 Q:PSDTEST
 S DA=PSOEXRX K CMOP D ^PSOCMOPA
 I $G(CMOP(CMOP("L")))="",$G(CMOP("S"))="L" S PSDTEST=1
ENX I 'PSDTEST K ^PSRX(PSOEXRX,1,PSUSD),^PSRX("AD",PRFDT,PSOEXRX,PSUSD),^PSRX(PSOEXRX,1,"B",PRFDT,PSUSD) D NSET
 Q
NSET ;
 N PSONM,PSONMX
 S PSONM="" F PSONMX=0:0 S PSONMX=$O(^PSRX(PSOEXRX,1,PSONMX)) Q:'PSONMX  S PSONM=PSONMX
 S ^PSRX(PSOEXRX,1,0)="^52.1DA^"_$G(PSONM)_"^"_$G(PSONM)
 Q
