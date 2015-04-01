BDMEDMUP ; IHS/CMI/LAB - EDITS FOR AUPNVSIT (VISIT:9000010) 24-MAY-1993 ; 20 Sep 2013  2:49 PM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**7,8**;JUN 14, 2007;Build 53
 ;
 W:$D(IOF) @IOF
 W !,$$CTR("DMS DATA ENTRY",80)
 W !!,$$CTR("Diabetes Patient Data Update",80)
 W !
 S BDMEDMPT="" D GETPAT
 I BDMEDMPT="" D XIT Q
 W !!,"The data you enter for the above patient will be updated in the PCC",!,"database.",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 W !!,"Okay, one more thing ... If you intend to update the DM Date of Onset, you"
 W !,"must have the patient's DM problem number available from the problem list"
 W !,"The problem number must be entered in the correct field in the following"
 W !,"format: XXnn, where XX is the facility abbreviation and nn is the"
 W !,"problem number, e.g.: MU7",!
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) D XIT Q
 I 'Y D XIT Q
 S BDMEDA="" D CREATE
 I BDMEDA="" W !!,"Exiting..." H 2 D XIT Q
 ;do screenman
 S DA=BDMEDA,DDSFILE=9003203.2,DR="[BDME DM UPDATE]" D ^DDS
 I $D(DIMSG) W !!,"ERROR IN SCREENMAN FORM!!  ***NOTIFY PROGRAMMER***" D DEL K DIMSG H 3 D XIT Q
 D UPDPCC
 I $D(BDMEDMER) W !!,"the following errors occurred when updating PCC" D
 .S X=0 F  S X=$O(BDMEDMER(X)) Q:X'=+X  W !?5,BDMEDMER(X)
 .Q
 D REF
 D XIT
 Q
 ;
UPDPCC ;update pcc
 W !!,"Updating PCC database....hold on a moment...",!
 D EN(BDMEDA,.BDMEDMER)
 Q
EN(BDMEDA,BDMEDMER) ;PEP - called from DM GUI
 I DUZ=2836 S ^LORITMP(1)=BDMEDA
 S BDMEERR=0
 K BDMEDMER
 Q:'$D(^BDMEDMUP(BDMEDA,0))
 S BDMEREC=^BDMEDMUP(BDMEDA,0)
 S BDMEREC1=$G(^BDMEDMUP(BDMEDA,11))
 ;S BDMERE14=$G(^BDMEDMUP(BDMEDA,14))
 I '$G(BDMEDMPT) S (AUPNPAT,BDMEDMPT)=$P(BDMEREC,U)  ;cmi/maw added 4/20/2004 for GUI Dms
 D PROB
 D HT
 D WT
 D BP^BDMEDMU2
 D SMOKEHF
 D TBHF^BDMEDMU2
 D SGHF^BDMEDMU2
 D FOOT^BDMEDMU1
 D EYE^BDMEDMU1
 D DEPR^BDMEDMU1
 D DENTAL^BDMEDMU1
 D PAP^BDMEDMU1
 D MAM^BDMEDMU1
 D FLU^BDMEDMU1
 D PNEU^BDMEDMU1
 D TD^BDMEDMU1
 D HEPB^BDMEDMU1
 D PPD^BDMEDMU2
 D EKG^BDMEDMU2
 D EDUC^BDMEDMU2
 D LAB^BDMEDMU2
 D MED^BDMEDMU2
 D RTLHF^BDMEDMU3
 D LPHF^BDMEDMU3
 D BTLHF^BDMEDMU3
DEL S DA=BDMEDA,DIK="^BDMEDMUP(" D ^DIK
 Q
REF ;update refusals?
 S DIR(0)="Y",DIR("A")="Do you want to enter any Patient REFUSALS/SERVICES NOT DONE",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G DEL
 I 'Y G DEL
 D REF^BDMEDMU3
 Q
ERR(T) ;EP
 S BDMEERR=BDMEERR+1,BDMEDMER(BDMEERR)=T
 Q
XIT ;
 D KILL^AUPNPAT
 K DIADD,DLAYGO
 D EN^XBVK("APCD"),EN^XBVK("AUPN")
 D ^XBFMK
 Q
PROB ;
 I $P(BDMEREC,U,3)="" Q
 I $P(BDMEREC,U,4)="" Q
 S N=$P(BDMEREC,U,4) ;problem number to update
 S BDMEN=$$PROBNUM(N)
 I 'BDMEN S T="<<< Could not update Problem Number "_N_" with Date of DM Onset. >>>" D ERR(T) Q
 S BDMED=$P(BDMEREC,U,3)
 D ^XBFMK
 S DA=BDMEN,DIE="^AUPNPROB(",DR=".13///"_$$FMTE^XLFDT(BDMED) D ^DIE
 I $D(Y) S T="<<< Could not update Problem Number "_N_" with Date of DM Onset.  DIE failed. >>>" D ERR(T)
 D ^XBFMK
 Q
HT ;
 K BDMEVSIT
 I $P(BDMEREC,U,5)="" Q
 I $P(BDMEREC,U,6)="" Q
 S BDMEDMDT=$P(BDMEREC,U,5)
 S BDMEMTYP=$O(^AUTTMSR("B","HT",0))
 D EVSIT ;get event visit
 I '$G(BDMEVSIT) S T="Could not Create PCC Visit when attempting to update height." D ERR(T) Q
 S (X,G)=0 F  S X=$O(^AUPNVMSR("AD",BDMEVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVMSR(X,0),U)=BDMEMTYP,$P(^AUPNVMSR(X,0),U,4)=$P(BDMEREC,U,6) S G=1
 I G S T="Already have a height of "_$P(BDMEREC,U,6)_" on Visit Date "_$$FMTE^XLFDT($P(^AUPNVSIT(BDMEVSIT,0),U)) D ERR(T) Q
 K APCDALVR
 S APCDALVR("APCDPAT")=BDMEDMPT
 S APCDALVR("APCDVSIT")=BDMEVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.01 (ADD)]"
 S APCDALVR("APCDTTYP")="`"_BDMEMTYP
 S APCDALVR("APCDTVAL")=$P(BDMEREC,U,6)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S T="Error creating V Measurement Entry for Height.  PCC not updated." D ERR(T)
 K APCDALVR
 Q
WT ;
 K BDMEVSIT
 I $P(BDMEREC,U,7)="" Q
 I $P(BDMEREC,U,8)="" Q
 S BDMEDMDT=$P(BDMEREC,U,7)
 S BDMEMTYP=$O(^AUTTMSR("B","WT",0))
 D EVSIT ;get event visit
 I '$G(BDMEVSIT) S T="Could not Create PCC Visit when attempting to update weight." D ERR(T) Q
 S (X,G)=0 F  S X=$O(^AUPNVMSR("AD",BDMEVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVMSR(X,0),U)=BDMEMTYP,$P(^AUPNVMSR(X,0),U,4)=$P(BDMEREC,U,8) S G=1
 I G S T="Already have a weight of "_$P(BDMEREC,U,8)_" on Visit Date "_$$FMTE^XLFDT($P(^AUPNVSIT(BDMEVSIT,0),U)) D ERR(T) Q
 K APCDALVR
 S APCDALVR("APCDPAT")=BDMEDMPT
 S APCDALVR("APCDVSIT")=BDMEVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.01 (ADD)]"
 S APCDALVR("APCDTTYP")="`"_BDMEMTYP
 S APCDALVR("APCDTVAL")=$P(BDMEREC,U,8)
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S T="Error creating V Measurement Entry for Weight.  PCC not updated." D ERR(T)
 K APCDALVR
 Q
SMOKEHF ;
 K BDMEVSIT
 I $P(BDMEREC,U,9)="" Q
 S BDMEDMDT=$S($P(BDMEREC1,U,14)]"":$P(BDMEREC1,U,14),1:DT)
 S BDMEMTYP=$P(BDMEREC,U,9)
 S BDMEMCAT=$P(^AUTTHF(BDMEMTYP,0),U,3)
 D EVSIT ;get event visit
 I '$G(BDMEVSIT) S T="Could not Create PCC Visit when attempting to update smoking health factor." D ERR(T) Q
 S (X,G)=0 F  S X=$O(^AUPNVHF("AD",BDMEVSIT,X)) Q:X'=+X!(G)  I $P(^AUPNVHF(X,0),U)=BDMEMTYP S G=1
 I G S T="Already have a health factor of "_$P(^AUTTHF($P(BDMEREC,U,9),0),U)_" on Visit Date "_$$FMTE^XLFDT($P(^AUPNVSIT(BDMEVSIT,0),U)) D ERR(T) Q
 K APCDALVR
 S APCDALVR("APCDPAT")=BDMEDMPT
 S APCDALVR("APCDVSIT")=BDMEVSIT
 S APCDALVR("APCDATMP")="[APCDALVR 9000010.23 (ADD)]"
 S APCDALVR("APCDTHF")="`"_BDMEMTYP
 D ^APCDALVR
 I $D(APCDALVR("APCDAFLG")) S T="Error creating V Health Factor Entry for Smoking.  PCC not updated." D ERR(T)
 K APCDALVR
 ;;update health status
 ;S BDMEHSE="",X=0 F  S X=$O(^AUPNHF("AC",BDMEDMPT,X)) Q:X'=+X!(BDMEHSE)  I $P(^AUTTHF($P(^AUPNHF(X,0),U),0),U,3)=BDMEMCAT S BDMEHSE=X
 ;I BDMEHSE D  Q
 ;.D ^XBFMK K DIADD
 ;.S DA=BDMEHSE,DIE="^AUPNHF(",DR=".01///`"_BDMEMTYP_";.03////"_DT D ^DIE
 ;.I $D(Y) S T="Error updating Health Status entry for Tobacco." D ERR(T)
 ;.D ^XBFMK
 ;D ^XBFMK
 ;;S X=BDMEMTYP,DIC("DR")=".02////"_BDMEDMPT_";.03////"_DT,DIC(0)="L",DIADD=1,DLAYGO=9000019,DIC="^AUPNHF(" D FILE^DICN
 ;I Y=-1 S T="Error adding health status entry for Tobacco." D ERR(T)
 D ^XBFMK K DIADD,DLAYGO
 Q
BSD ;
 K BDMEIN
 S BDMEIN("PAT")=BDMEDMPT
 S BDMEIN("VISIT DATE")=BDMEDMDT_".12"
 S BDMEIN("SITE")=DUZ(2)
 S BDMEIN("VISIT TYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S BDMEIN("SRV CAT")="E"
 S BDMEIN("TIME RANGE")=0
 S BDMEIN("USR")=DUZ
 K APCDALVR
 K BDMEBSDV
 D GETVISIT^APCDAPI4(.BDMEIN,.BDMEBSDV)
 S T=$P(BDMEBSDV(0),U,2)
 I T]"" Q  ;errored
 S V=$O(BDMEBSDV(0)) S BDMEVSIT=V
 I $G(BDMEBSDV(V))="ADD" D DEDT^APCDEA2(BDMEVSIT)
 Q
EVSIT ;EP - get/create event visit
 I $L($T(^BSDAPI4)) D  Q
 .D BSD
 K BDMEVSIT
 K APCDALVR
 S APCDALVR("APCDAUTO")=""
 S APCDALVR("APCDPAT")=BDMEDMPT
 S APCDALVR("APCDCAT")="E"
 S APCDALVR("APCDLOC")=DUZ(2)
 S APCDALVR("APCDTYPE")=$S($P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^APCCCTRL(DUZ(2),0),U,4),1:"O")
 S APCDALVR("APCDDATE")=BDMEDMDT_".12"
 D ^APCDALV
 S BDMEVSIT=$G(APCDALVR("APCDVSIT"))
 I $G(APCDALVR("APCDVSIT","NEW")) D DEDT^APCDEA2(BDMEVSIT)
 K APCDALVR
 Q
CREATE ;create entry in fileman file
 S BDMEDA=""
 D ^XBFMK
 S X=BDMEDMPT,DIC(0)="L",DIC("DR")=".02////^S X=DT",DIC="^BDMEDMUP(",DIADD=1,DLAYGO=9003203.2 K DD,DO,D0 D FILE^DICN
 I Y=-1 S T="Error creating fileman file entry.  Notify programmer" D ERR(T) Q
 S BDMEDA=+Y
 D ^XBFMK K DIADD,DLAYGO
 Q
GETPAT ;
 S BDMEDMPT=""
 W !
 I '$P($G(^BDMESITE(DUZ(2),0)),U,34) S AUPNLK("INAC")=1
 S DIC="^AUPNPAT(",DIC(0)="AEMQ" D ^DIC K DIC
 Q:Y<0
 I $D(BDMEPARM),$P(BDMEPARM,U,3)="Y" W !?25,"Ok" S %=1 D YN^DICN Q:%'=1
 S BDMEDMPT=+Y
 D INAC^APCDEA(BDMEDMPT,.X) I 'X S BDMEDMPT="" Q
 I DUZ("AG")="I" D ^APCDEMDI
 Q
 ;
VSIT01 ;EP;9000010,.01 (VISIT,VISIT/ADMIT DATE&TIME)
 I '$D(AUPNPAT) D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL(" <No direct entry allowed>") K X Q
 S:$E(X,6,7)="00" X=$E(X,1,5)_"01" S:$E(X,4,5)="00" X=$E(X,1,3)_"01"_$E(X,6,7)
 I $D(AUPNDOB),$D(AUPNDOD),AUPNDOB,$D(DT),DT D VSIT01B Q
 I '$D(AUPNTALK),'$D(ZTQUEUED) D EN^DDIOL("  <Required variables do not exist>")
 K X
 Q
VSIT01B ;
 I '$D(BDMEFVOK),DT_".9999"<X D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL("  <Future dates not allowed>") K X Q
 I DUZ("AG")="I",AUPNDOD,$P(X,".",1)>AUPNDOD D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL("  <Patient died before this date>") K X Q
 I $P(X,".",1)<AUPNDOB D:'$D(AUPNTALK)&('$D(ZTQUEUED)) EN^DDIOL("  <Patient born after this date>") K X Q
 Q
 ;
ID ;
 S:$E(BDMEDMDT,6,7)="00" BDMEDMDT=$E(BDMEDMDT,1,5)_"01" S:$E(BDMEDMDT,4,5)="00" BDMEDMDT=$E(BDMEDMDT,1,3)_"01"_$E(BDMEDMDT,6,7)
 Q
PROBN ;EP
 NEW BDMEPLOC,BDMEPPL,BDMEPN,BDMEPI
 S X=$$UP^XLFSTR(X)
 S:X["#" X=$P(X,"#")_$P(X,"#",2)
 S BDMEPPL="" F BDMEPI=1:1:$L(X) Q:$E(X,BDMEPI)?1N  S BDMEPPL=BDMEPPL_$E(X,BDMEPI)
 I BDMEPPL="" D EN^DDIOL("No facility code has been entered.") K X Q
 S BDMEPLOC="",BDMEPLOC=$O(^AUTTLOC("D",BDMEPPL,BDMEPLOC)) I BDMEPLOC="" D EN^DDIOL("NO Location Abbreviation - PLEASE NOTIFY YOUR SUPERVISOR") K X Q
 S BDMEPN=$P(X,BDMEPPL,2) I BDMEPN=""!(BDMEPN<0)!(BDMEPN>999.99) D EN^DDIOL("Invalid problem number") K X Q
 S BDMEPN=" "_$E("000",1,(3-$L($P(BDMEPN,"."))))_$P(BDMEPN,".")_"."_$P(BDMEPN,".",2)_$E("00",1,(2-$L($P(BDMEPN,".",2))))
 I '$D(^AUPNPROB("AA",AUPNPAT,BDMEPLOC,BDMEPN)) D EN^DDIOL("No Problem Number "_BDMEPN_" on file for this patient for location "_$P(^AUTTLOC(BDMEPLOC,0),U,2)_".") K X Q
 Q
PROBNUM(X) ;EP - get problem ien given problem number
 I $G(X)="" Q ""
 NEW BDMEPLOC,BDMEPPL,BDMEPN,BDMEPI,P
 S X=$$UP^XLFSTR(X)
 S:X["#" X=$P(X,"#")_$P(X,"#",2)
 S BDMEPPL="" F BDMEPI=1:1:$L(X) Q:$E(X,BDMEPI)?1N  S BDMEPPL=BDMEPPL_$E(X,BDMEPI)
 I BDMEPPL="" Q ""
 S BDMEPLOC="",BDMEPLOC=$O(^AUTTLOC("D",BDMEPPL,BDMEPLOC)) I BDMEPLOC="" Q ""
 S BDMEPN=$P(X,BDMEPPL,2) I BDMEPN=""!(BDMEPN<0)!(BDMEPN>999.99) Q ""
 S BDMEPN=" "_$E("000",1,(3-$L($P(BDMEPN,"."))))_$P(BDMEPN,".")_"."_$P(BDMEPN,".",2)_$E("00",1,(2-$L($P(BDMEPN,".",2))))
 S P=$O(^AUPNPROB("AA",AUPNPAT,BDMEPLOC,BDMEPN,0))
 Q P
 N DIC,DA,D,DZ S DIC="^AUTTLOC(",DIC(0)="E",D="D",DZ="??" D DQ^DICQ K Y,DIC,D
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
