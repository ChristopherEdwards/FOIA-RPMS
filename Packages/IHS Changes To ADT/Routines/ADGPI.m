ADGPI ; IHS/ADC/PDW/ENM - PATIENT INQUIRY ; [ 09/17/2002  4:19 PM ]
 ;;5.0;ADMISSION/DISCHARGE/TRANSFER;;MAR 25, 1999
 ;
SP ; -- select patient
 N DFN,DIC,Y,X S DIC="^DPT(",DIC(0)="AEQMZ"
 D ^DIC K DIC Q:Y'>0  S DFN=+Y D EN G SP
 ;
EN ;EP; entry point - input DFN
 Q:'$D(DFN)  D DM,CS,DS,SV,FA,KVA^VADPT,IN,PG Q
 ;
DM ; -- demographic data
 N DGDPTN0,DGDPTN11,DGDPTN13,DGPATN0,DGPATN11
 S DGDPTN0=^DPT(DFN,0),DGDPTN11=$G(^(.11)),DGDPTN13=$G(^(.13))
 S DGPATN0=$G(^AUPNPAT(DFN,0)),DGPATN11=$G(^(11))
 W !!?13,"***Confidential Patient Data Covered by Privacy Act***"
 W !!,$P(DGDPTN0,U),?32,"HRCN: ",$$HRCN^ADGF,?54,"DOB: ",$$DOB
 W !,$P(DGDPTN11,U),?31,"PHONE: ",$P(DGDPTN13,U),?53,"PROV: ",$$PCP
 W !,$P(DGDPTN11,U,4),"  ",$$ST,"  ",$P(DGDPTN11,U,6)
 W ?32,"ELIG: ",$$ELIG,?54,"SSN: ",$P(DGDPTN0,U,9) Q
 ;
CS ; -- current status
 ;D INP^DGRPD Q
 D INP^ADGRPD Q  ;9/17/02 WAR Modified to allow for v5.3 DaySurgery
 ;
DS ; -- last day surgery
 S X="SRZPEP" X ^%ZOSF("TEST") I $T S DGCK=$$LASTDS^SRZPEP
 Q:$G(DGCK)
 Q:'$D(^ADGDS(DFN))  N X,Y,DGDSN0,DGDSN2 S (X,Y)=0
 F  S X=$O(^ADGDS(DFN,"DS","AA",X)) Q:'X  S Y=X
 Q:'Y  S X=$O(^ADGDS(DFN,"DS","AA",Y,0)) Q:'X
 Q:'$D(^ADGDS(DFN,"DS",X,0))  S DS=X,DGDSN0=^(0),DGDSN2=$G(^(2))
 W !!,"DAY SURGERY date: ",$$DSDT
 W:DGDSN2 ?38,"Released: ",$$DSRL,"  LOS: ",$$DSLS
 I $P(DGDSN2,U,3)="Y" W ?38,"**CANCELLED**"
 I $P(DGDSN2,U,4)="Y" W ?38,"**NO-SHOW**"
 W !?9,"Service: ",$$DSSV,?38,"Provider: ",$$DSPR Q
 ;
SV ; -- scheduled visit
 Q:'$D(^ADGAUTH(DFN,1,0))  N X,Y,DGSVN0 S (X,Y)=0
 F  S X=$O(^ADGAUTH(DFN,1,X)) Q:'X  D
 . S DGSVN0=^ADGAUTH(DFN,1,X,0)
 . Q:$P(DGSVN0,U,5)=""!("IQD"'[$P(DGSVN0,U,5))
 . D @("SV"_$P(DGSVN0,U,5))
 Q
 ;
SVI ; -- scheduled admit
 N X S X=+DGSVN0
 W !!?10,"Scheduled Admit for ",$E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 S X=$P(DGSVN0,U,7) W:X ?43,"Ward: ",$E($P($G(^DIC(42,+X,0)),U),1,3)
 S X=$P(DGSVN0,U,3) W:X ?55,"Service: ",$P($G(^DIC(45.7,+X,0)),U,3) Q
 ;
SVQ ; -- scheduled quarters
 N X S X=+DGSVN0 W !!?10,"Scheduled for Quarters on "
 W $E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3) S X=$P(DGSVN0,U,2)
 W ?50,"Provider: " W:X $E($P($G(^DIC(45.7,+X,0)),U,3),1,20) Q
 ;
SVD ; -- scheduled day surgery
 N X S X=+DGSVN0 W !!?10,"Scheduled for Day Surgery on "
 W $E(X,4,5),"/",$E(X,6,7),"/",$E(X,2,3)
 S X=$P(DGSVN0,U,3) W:X "  Service: ",$P(^DIC(45.7,X,0),U,3) Q
 ;
FA ; -- scheduled future appointments
 ;9/17/02 WAR Chgd to accomodate v5.3 DaySurgery
 ;D FA^DGRPD Q
 D FA^ADGRPD Q
 ;
IN ; -- insurance (from health summary)
 ;N APCHSPAT,APCHSCKP,APCHSNPG,APCHSCVD,APCHSBRK,APCHSQ
 S APCHSPAT=DFN,APCHSCKP="",APCHSNPG=0,APCHSBRK=""
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$E(Y,6,7)_""/""_$E(Y,2,3)"
 W !! D ^APCHS5 Q
 ;
PG ; -- page
 N X,Y K DIR S DIR(0)="E" D ^DIR K DIR,X Q
 ;
DOB() ; -- date of birth
 N Y S Y=$P(DGDPTN0,U,3) X ^DD("DD") Q Y
 ;
ELIG() ; -- eligibility status
 N Y,C S Y=$P(DGPATN11,U,12) S C=$P(^DD(9000001,1112,0),U,2)
 D Y^DIQ Q $E(Y,1,13)
 ;
ST() ; -- state 
 Q $P($G(^DIC(5,+$P(DGDPTN11,U,5),0)),U,2)
 ;
DSDT() ; -- day surgery date/time
 N Y S Y=+DGDSN0 X ^DD("DD") Q Y
 ;
DSSV() ; -- day surgery treating specialty
 Q $E($P($G(^DIC(45.7,+$P(DGDSN0,U,5),0)),U),1,20)
 ;
DSPR() ; -- day surgery provider
 Q $E($P($G(^VA(200,+$P(DGDSN0,U,6),0)),U),1,20)
 ;
DSRL() ; -- day surgery release date/time
 N Y S Y=+DGDSN2 X ^DD("DD") Q Y
 ;
DSLS() ; -- day surgery length of stay
 Q:'DS "" D  Q X_" hrs"
 . K ^UTILITY("DIQ1",$J) S DR(9009012.01)=8,DA(9009012.01)=DS
 . S DIC=9009012,DA=DFN,DR=1 D EN^DIQ1
 . S X=$G(^UTILITY("DIQ1",$J,9009012.01,DS,8))
 . K ^UTILITY("DIQ1",$J),DIC,DA,DR
 ;
PCP() ; -- primary care provider
 I $P(^DD(9000001,.14,0),U,2)["200" Q $E($P($G(^VA(200,+$P(^AUPNPAT(DFN,0),U,14),0)),U),1,20)
 Q $E($P($G(^DIC(16,+$P(^AUPNPAT(DFN,0),U,14),0)),U),1,20)
