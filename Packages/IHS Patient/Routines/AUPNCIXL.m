AUPNCIXL ; IHS/CMI/LAB - AQ XREFS ON LAB/MEAS 24-MAY-1993 ;  
 ;;2.0;IHS PCC SUITE;**2**;MAY 14, 2009
 ;; MODIFIED TO SUPPORT Q-MAN 1.3 BY GIS/OHPRD MAY 21,1991
 ;
AQKILL1 ;EP - V LAB
 N AMQQKKK S AMQQKKK=""
AQ1 ; ENTRY POINT FROM V LAB DD
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,B,C,%,E,F S (A,F)=X
 K:$D(AMQQKKK) ^AUPNVLAB("AQ",(X_";"),DA) ;IHS/OHPRD/JCM 8/3/94
 S X=$P($G(^AUPNVLAB(DA,0)),U,4) I X="" S X=F S:'$D(AMQQKKK) ^AUPNVLAB("AQ",(X_";"),DA)="" Q  ;IHS/OHPRD/JCM 8/3/94
 D AQEN S X=F
 Q
 ;
AQKILL ; EP
 N AMQQKKK S AMQQKKK=""
AQ ; EP - VLAB
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 N A,B,C,%,E
 I X="" Q
 S %=$D(^AUPNVLAB(DA,0)) Q:'%  S %=^(0)
 S A=+% I 'A Q
 K:'$D(AMQQKKK) ^AUPNVLAB("AQ",$P(^AUPNVLAB(DA,0),U)_";",DA) ;IHS/OHPRD/JCM 8/3/94
 S:$D(AMQQKKK) ^AUPNVLAB("AQ",$P(^AUPNVLAB(DA,0),U)_";",DA)="" ;IHS/OHPRD/JCM 8/3/94
AQEN S B=$O(^AMQQ(5,"AQ",A,"")) I B="" Q
 I B="S" S C=X D AQSET Q
 I "><"[$E(X) S X=$E(X,2,99)
 D @("AQ"_B)
 Q
 ;
AQZ I "nN"[$E(X) S C=0 D AQSET Q
 I "tT"[$E(X) S C=1 D AQSET Q
 I $E(X,1,2)?1N1"+" S C=+X I X,X<5 S C=X+1 D AQSET Q
 Q
 ;
AQSET S %=A_";"_C
 I $D(AMQQKKK) K ^AUPNVLAB("AQ",%,DA) Q
 S ^AUPNVLAB("AQ",%,DA)=""
 Q
 ;
AQT I "nN"[$E(X) S C="000000000" D AQSET Q
 I "pP"[$E(X) S C="000000001" D AQSET Q
 I $E(X,1,2)="1:" S C=+$P(X,":",2) I C S E="000000000" D AQPAD,AQSET Q
 Q
 ;
AQN S C=+X I C S E="0000" D AQPAD,AQSET
 Q
 ;
AQQ S C=("Nn"'[$E(X))
 D AQSET
 Q
 ;
AQPAD S %=$P(C,"."),%=$E(E,1,$L(E)-$L(%))_%
 I $P(C,".",2) S %=%_"."
 S C=%_$P(C,".",2)
 Q
 ;
LSTUFF ; SETS V LAB "AQ" XREF
 K ^AUPNVLAB("AQ")
 F DA=0:0 S DA=$O(^AUPNVLAB(DA)) Q:'DA  S X=$G(^(DA,0)),X=$P(X,U,4) I X'="" D AQ W *13,DA
 Q
 ;
AQEKILL1 ; EP - V EXAM .01
 N AMQQKKK S AMQQKKK=""
AQE1 ; ENTRY POINT TO SET V EXAM "AQ" XREF FROM .01 FIELD
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,B,C,%,E S A=X
 K:$D(AMQQKKK) ^AUPNVXAM("AQ",(X_";"),DA) ;IHS/OHPRD/JCM 8/3/94
 N X S X=$P($G(^AUPNVXAM(DA,0)),U,4) I X="" S X=A S:'$D(AMQQKKK) ^AUPNVXAM("AQ",(X_";"),DA)="" Q  ;IHS/OHPRD/JCM 8/3/94
 D EXEN
 Q
 ;
AQEKILL ; EP - V EXAM AQ
 N AMQQKKK S AMQQKKK=""
AQE ; ENTRY POINT FROM V EXAM DATA DICTIONARY
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,B,C,%,E
 S A=+$G(^AUPNVXAM(DA,0)) I 'A Q
 K:'$D(AMQQKKK) ^AUPNVXAM("AQ",$P(^AUPNVXAM(DA,0),U)_";",DA) ;IHS/OHPRD/JCM 8/3/94
 S:$D(AMQQKKK) ^AUPNVXAM("AQ",$P(^AUPNVXAM(DA,0),U)_";",DA)="" ;IHS/OHPRD/JCM 8/3/94
EXEN S C=("Nn"'[$E(X))
 S %=A_";"_C
 I $D(AMQQKKK) K ^AUPNVXAM("AQ",%,DA) Q
 S ^AUPNVXAM("AQ",%,DA)=""
 Q
 ;
ESTUFF ; SETS V EXAM XREF
 K ^AUPNVXAM("AQ")
 F DA=0:0 S DA=$O(^AUPNVXAM(DA)) Q:'DA  S X=$G(^(DA,0)),X=$P(X,U,4) D AQE W *13,DA
 Q
 ;
AQSKILL1 ; ENTRY POINT TO KILL V SKIN TEST "AQ" XREF FROM .01 FIELD
 N AMQQKKK S AMQQKKK=""
AQS1 ; ENTRY POINT TO SET V SKIN TEST "AQ" XREF FROM .01 FIELD
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,B,C,%,E S A=X
 K:$D(AMQQKKK) ^AUPNVSK("AQ",(X_";"),DA) ;IHS/OHPRD/JCM 8/3/94
 N X S X=$P($G(^AUPNVSK(DA,0)),U,5) I X="" S X=A S:'$D(AMQQKKK) ^AUPNVSK("AQ",(X_";"),DA)="" Q  ;IHS/OHPRD/JCM 8/4/94
 ;N X S X=$P(^AUPNVSK(DA,0),U,4) I X="" Q  ;IHS/OHPRD/JCM
 D SKEN
 Q
 ;
AQSKILL ; ENTRY POINT FOR AQ XREF FOR V SKIN TEST FILE
 N AMQQKKK S AMQQKKK=""
AQS ; ENTRY POINT FOR AQ XREF FOR V SKIN TEST FILE
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,B,C,%,E
 S A=+$G(^AUPNVSK(DA,0)) I 'A Q
 K:'$D(AMQQKKK) ^AUPNVSK("AQ",$P(^AUPNVSK(DA,0),U)_";",DA) ;IHS/OHPRD/JCM 8/3/94
 S:$D(AMQQKKK) ^AUPNVSK("AQ",$P(^AUPNVSK(DA,0),U)_";",DA)="" ;IHS/OHPRD/JCM 8/3/94
SKEN S %=A_";"_(X\1)
 I $D(AMQQKKK) K ^AUPNVSK("AQ",%,DA) Q
 S ^AUPNVSK("AQ",%,DA)=""
 Q
 ;
SSTUFF ; SETS V SKIN TEST AQ XREF WITHOUT CALLING FILEMAN
 K ^AUPNVSK("AQ")
 F DA=0:0 S DA=$O(^AUPNVSK(DA)) Q:'DA  S X=$G(^(DA,0)),X=$P(X,U,5) D AQS W *13,DA
 Q
 ;
AQRKILL1 ; ENTRY POINT TO KILL V RAD "AQ" XREF FROM .01 FIELD
 N AMQQKKK S AMQQKKK=""
AQR1 ; ENTRY POINT TO SET V RAD "AQ" XREF FROM .01 FIELD
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,% S A=X
 K:$D(AMQQKKK) ^AUPNVRAD("AQ",(X_";"),DA) ;IHS/OHPRD/JCM 8/8/94
 N X S X=$P(^AUPNVRAD(DA,0),U,5) I X="" S X=A S:'$D(AMQQKKK) ^AUPNVRAD("AQ",(X_";"),DA)="" Q  ;IHS/OHPRD/JCM 8/8/94
 D RADEN
 Q
 ;
AQRKILL ; ENTRY POINT FOR AQ XREF FOR V RAD FILE
 N AMQQKKK S AMQQKKK=""
AQR ; ENTRY POINT FROM V RAD ,"AQ" XREF, .05 FIELD
 I $P($G(^AUTTSITE(1,0)),U,19)'="Y" Q
 I X="" Q
 N A,%
 S A=+$G(^AUPNVRAD(DA,0)) I 'A Q
 K:'$D(AMQQKKK) ^AUPNVRAD("AQ",$P(^AUPNVRAD(DA,0),U)_";",DA) ;IHS/OHPRD./JCM 8/8/94
 S:$D(AMQQKKK) ^AUPNVRAD("AQ",$P(^AUPNVRAD(DA,0),U)_";",DA)="" ;IHS/OHPRD/JCM 8/8/94
RADEN S %=A_";"_X
 I $D(AMQQKKK) K ^AUPNVRAD("AQ",%,DA) Q
 S ^AUPNVRAD("AQ",%,DA)=""
 Q
 ;
RSTUFF ; SETS V RAD XREF WITHOUT CALLING FILEMAN
 K ^AUPNVRAD("AQ")
 F DA=0:0 S DA=$O(^AUPNVRAD(DA)) Q:'DA  S X=$G(^(DA,0)),X=$P(X,U,5) D AQR W *13,DA
 Q
 ;
WHBUL ;
 NEW XMSUB,XMDUZ,XMTEXT,XMY,AUPNC
 KILL ^TMP($J,"AUPNDEBUL")
 ;get default case manager
 S X=$P($G(^BWSITE(AUPNSITE,0)),U,2)
 I X="" Q
 S XMY(X)=""
 D WRITEMSG
SUBJECT S XMSUB="* * * IMPORTANT WOMEN'S HEALTH INFORMATION * * *"
SENDER S XMDUZ="PCC - Pap Smear entry auto add to WH"
 S XMTEXT="^TMP($J,""AUPNDEBUL"","
 D ^XMD
 KILL ^TMP($J,"AUPNDEBUL")
 Q
 ;
WRITEMSG ;
 S AUPNC=0
 S X="*********** WOMEN'S HEALTH INFORMATION *************" D SET
 S X="This message is to inform you that a Pap Smear was entered into PCC" D SET
 S X="for Patient "_$P(^DPT(AUPNDFN,0),U)_" (Chart #: "_$$HRN^AUPNPAT(AUPNDFN,AUPNSITE)_").  The date of the" D SET
 S X="Pap Smear was "_$$FMTE^XLFDT(AUPNWHDT)_".  An attempt was made to " D SET
 S X="automatically add this Pap Smear to the Women's Health module." D SET
 S X="This attempt failed because the patient is not on the WH Register." D SET
 S X="Review the information and if appropriate, add this patient to your" D SET
 S X="Register.  This Pap Smear may be manually added to the" D SET
 S X="patient's profile after the patient is added to the Register." D SET
 S X=" " D SET
 Q
 ;;  
SET ;
 S AUPNC=AUPNC+1
 S ^TMP($J,"AUPNDEBUL",AUPNC)=X
 Q
PAP(T) ;EP - called from V LAB AWH xref
 I '$G(T) Q 0
 I $P($G(^LAB(60,T,0)),U)="PAP SMEAR" Q 1
 NEW S
 S S=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 I 'S Q 0
 I $D(^ATXLAB(S,21,"B",T)) Q 1
 Q 0
WH(AUPNDFN,AUPNDA,AUPNVST,AUPNSITE) ;EP - called from xref on V LAB .01
 I '$G(AUPNSITE) Q  ;no site
 I $P($G(^APCCCTRL(AUPNSITE,0)),U,9)'=1 Q  ;does not specify to pass them
 ;called to create a WH entry for PAP SMEAR
 NEW AUPNWHDT
 I '$G(AUPNDFN) Q
 I '$G(AUPNVST) Q
 I '$D(^AUPNVSIT(AUPNVST)) Q
 Q:$D(DIGFLINE)  ;in MFI
 I '$D(^DPT(AUPNDFN,0)) Q
 S AUPNWHDT=$P($P(^AUPNVSIT(AUPNVST,0),U),".")
 I '$D(^BWP(AUPNDFN,0)) D EN^XBNEW("WHBUL^AUPNCIXL","AUPNDFN;AUPNDA;AUPNVST;AUPNWHDT;AUPNSITE") Q  ;women is not on WH register
 D EN^XBNEW("WH1^AUPNCIXL","AUPNDFN;AUPNDA;AUPNVST;AUPNWHDT")
 K AUPNDFN,AUPNDA,AUPNVST,AUPNWHDT
 Q
WH1 ;
 ;check to see if pap already there, if not add it.
 ;go through procedures in a date range for this patient, check proc type
 NEW D,X,Y,G,V,T
 S T=$O(^BWPN("B","PAP SMEAR",0))
 I 'T Q
 S (G,V)=0 F  S V=$O(^BWPCD("C",AUPNDFN,V)) Q:V=""!(G)  D
 .Q:'$D(^BWPCD(V,0))
 .I $P(^BWPCD(V,0),U,4)'=T Q
 .I AUPNWHDT'=$P(^BWPCD(V,0),U,12) Q
 .S G=1
 .Q
 I G Q  ;already has pap smear
 ;ADD PAP TO WH PROCEDURE FILE
PROC ;---> Create PAP SMEAR Procedure in BW PROCEDURE File #9002086.1.
 ;---> 1=IEN of Procedure Type in File #9002086.2.
 ;
 ;---> Optional use of DR string.
 S AUPNDR=".02////"_AUPNDFN_";.03////"_$P($G(^AUPNVSIT(AUPNVST,0)),U)_";.04////1"
 S AUPNDR=AUPNDR_";.1////"_$P(^AUPNVSIT(AUPNVST,0),U,6)
 S AUPNDR=AUPNDR_";.12////"_$P($G(AUPNWHDT),".")_";.14////o"
 S AUPNDR=AUPNDR_";.18////"_DUZ_";.19////"_DT
 S AUPNERR=0
 ;
 D NEW2^BWPROC(AUPNDFN,1,AUPNWHDT,AUPNDR,"",.AUPNDADA,.AUPNERR)
 I AUPNERR<0 D  Q
 .S BWERR="Software error: Failed to create PAP in Women's Health."
 ;
 ;---> BWDA=IEN of just created Procedure in BW PROCEDURE File.
 ;---> Following line will call ^APCDALV and ^APCDALVR.
 ;---> Call to APCDALV will look for same date Visit and prompt
 ;---> if time does not match.  (See +53^BWPCC.)
STORE ;---> STORE VISIT AND V FILE IEN'S IN WH PROCEDURE FILE #9002086.1.
 I $G(AUPNDADA) D
 .N DR
 .S DR="5.01////"_AUPNVST_";5.02////"_AUPNDA
 .S DIE="^BWPCD(",DA=AUPNDADA
 .D ^DIE
 .K DIE,DA,DR
 Q
