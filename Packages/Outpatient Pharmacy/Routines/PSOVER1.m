PSOVER1 ;BHAM ISC/SAB - verify one rx ;01-Jul-2011 10:13;PLS
 ;;7.0;OUTPATIENT PHARMACY;**32,46,90,131,1002,1004,1007,1011**;DEC 1997;Build 17
 ;External reference ^PSDRUG( supported by DBIA 221
 ;External reference to PSOUL^PSSLOCK supported by DBIA 2789
 ;External reference ^PS(55 supported by DBIA 2228
 ;External reference to PSSORPH is supported by DBIA 3234
 ; Modified - IHS/CIA/PLS - 01/29/04 - Line CHANGE+3
 ;            IHS/CIA/PLS - 12/16/04 - Lines REDO+1, EDIT+1, new EP (CHKPRV)
 ;            IHS/MSC/PLS - 07/10/08 - Changed references to PSOVER array to PSOVERA
 ;            IHS/MSC/PLS - 06/30/11 - Lines REDO+5 and new NVA EP to match patch 202
REDO S (DRG,PSODRUG("NAME"))=$P(^PSDRUG(+$P(^PSRX(PSONV,0),"^",6),0),"^"),PSODRUG("VA CLASS")=$P(^(0),"^",2)
 I '$D(PSODFN) S PSODFN=$P(^PSRX(PSONV,0),"^",2)
 ; IHS/CIA/PLS - 12/16/04 - Added check and message.
 I '$$CHKPRV(PSONV) D  Q
 .W !,"This prescription lacks an ordering provider and can't",!,"be processed until one is selected!"
 S (STA,DNM)="",PSDPSTOP=0,$P(PSONULN,"-",79)="-" F  S STA=$O(PSOSD(STA)) Q:STA=""  F  S DNM=$O(PSOSD(STA,DNM)) Q:DNM=""  K PSZZZDUP I $P(PSOSD(STA,DNM),"^",2)<10 D
 .;IHS/MSC/PLS - 06/30/2011
 .I STA="ZNONVA" D NVA Q
 .;I PSODRUG("NAME")=$P(DNM,"^")&(PSONV'=$P(PSOSD(STA,DNM),"^")) S PSZZZDUP=1 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" W ! D ^DIR K DIR D DUP^PSODRDUP S PSDTSTOP=1
 .I PSODRUG("NAME")=$P(DNM,"^")&(PSONV'=$P(PSOSD(STA,DNM),"^")) S PSZZZDUP=1 K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" W ! D ^DIR K DIR S PSDTSTOP=1
 .I PSODRUG("VA CLASS")]"",$E(PSODRUG("VA CLASS"),1,4)=$E($P(PSOSD(STA,DNM),"^",5),1,4),PSODRUG("NAME")'=$P(DNM,"^") K DIR S DIR(0)="E",DIR("A")="Press RETURN to continue" W ! D ^DIR K DIR D CLS^PSODRDUP S PSDTSTOP=1
 .I $G(PSZZZDUP),$G(PSVFLAG),$P($G(^PSRX($P(PSOSD(STA,DNM),"^"),"STA")),"^")=12,$D(^PS(52.4,$P(PSOSD(STA,DNM),"^"),0)) S DA=$P(PSOSD(STA,DNM),"^"),DIK="^PS(52.4," D ^DIK K DIK
 .I $G(PSZZZDUP),$G(PSVFLAG),$P($G(^PSRX($P(PSOSD(STA,DNM),"^"),"STA")),"^")'=12 S PSZZQUIT=1
 K MSG I $G(PSZZQUIT),$G(PSVFLAG) K PSZZQUIT,PSODRUG,PSODFN,PSZZZDUP,DNM,PSDTSTOP D CLEAN Q
 K PSODRUG,PSODFN,PSZZZDUP,DNM,PSZZQUIT
ALLR ;Allergy check
 G:'$P($G(^PSRX(PSONV,3)),"^",6) EDIT
 I '$G(PSDTSTOP) K DIR S DIR(0)="E" D ^DIR K DIR I $D(DTOUT)!($D(DUOUT)) K PSDTSTOP G OUT
 W !!,"A Drug-Allergy Reaction exists for this medication!",!!,"***SIGNIFICANT*** Allergy Reaction"
 W !,"Drug: ",$P($G(^PSDRUG(+$P($G(^PSRX(PSONV,0)),"^",6),0)),"^")
 I $O(^PSRX(PSONV,"DAI",0)) W !?6,"Ingredients: " D
 .F PSPPP=0:0 S PSPPP=$O(^PSRX(PSONV,"DAI",PSPPP)) Q:'PSPPP  I $G(^(PSPPP,0))'="" W:$X+$L($G(^PSRX(PSONV,"DAI",PSPPP,0)))+2>IOM !?19 W $G(^PSRX(PSONV,"DAI",PSPPP,0))_", "
 W ! K DIR,PSPPP S DIR(0)="Y",DIR("B")="Y",DIR("A")="Do you want to intervene?" D ^DIR K DIR I X["^"!($D(DTOUT))!($D(DUOUT)) K PSDTSTOP G OUT
 I Y S PSORX("INTERVENE")=0 D EN1^PSORXI(PSONV)
EDIT I $G(PKI1)=2 D DCV1^PSOPKIV1 G OUT
 ; IHS/CIA/PLS - 12/16/04 - Corrected misspelling
 ;K PSDTSTOP S DIR("A")="EDIT",DIR("B")="N",DIR(0)="SB^Y:YES;N:NO;P:PROFILE",DIR("?")="Enter Y to change this RX, P to see a profile, or N to procede with verification"
 K PSDTSTOP S DIR("A")="EDIT",DIR("B")="N",DIR(0)="SB^Y:YES;N:NO;P:PROFILE",DIR("?")="Enter Y to change this RX, P to see a profile, or N to proceed with verification"
 D ^DIR K DIR I Y="Y",$G(PSOACT)]"" S VALMBCK="R" G OUT
 I $D(DIRUT),$G(PSOCLK) S PSOCQ=1 G OUT
 I $D(DIRUT),$G(PSOACT)]"" S VALMBCK="R" G OUT
 G VERIFY:Y="N",PROF:Y="P",OUT:"YNP"'[$E(Y)
CHANGE S DA=PSONV,(PSRX1,PSRX2)=$P(^PSRX(PSONV,0),"^",6)
 S DEA1=1,DEA2=0,PSDOLD=+DA,DIE="^PSRX(",DR="3;7;8;9;4;5;12;1;22;11;"_$S($P(PSOPAR,"^",12):"35;",1:"")_$S($P(PSOPAR,"^",15):"10.6",1:"")_";@2" D ^DIE
 ;I PSRX1'=PSRX2,DEA1'=DEA2 S DR="6////"_PSRX1 D ^DIE
 ;IHS/CIA/PLS - 01/29/04 - Prompt for IHS fields
 S DR="27;9999999.06;9999999.02;17;28;29;9999999.14" D ^DIE
 D EXPIRE K DIE,DR,DEA1,DEA2,P(5),PSRX1,PSRX2
 K PSD(PSDOLD) S PSDNEW=$P(^PSDRUG($P(^PSRX(PSONV,0),"^",6),0),"^")_"^"_PSONV,PSD(PSDNEW)=PSONV_"^*^1^"_$P(^PSDRUG($P(^PSRX(PSONV,0),"^",6),0),"^",2)
 S DA=PSONV D ^PSORXPR
 G EDIT:PSDNEW=PSDOLD,REDO
PROF I '$D(PSOSD) W !,$C(7),"This patient has no other prescriptions on file",!! G EDIT Q
 D ^PSODSPL G EDIT Q
 ;
EXPIRE S RX0=^PSRX(DA,0),X1=$P($P(RX0,"^",13),"."),X2=$P(RX0,"^",9)+1*$P(RX0,"^",8),X2=$S($P(RX0,"^",8)=X2:X2,X2<181:184,X2=360:366,1:X2),X=X1 D:X1&X2 C^%DTC
 K ^PS(55,PSDFN,"P","A",+$P(^PSRX(DA,2),"^",6),DA) S ^PS(55,PSDFN,"P","A",X,DA)="",$P(^PSRX(DA,2),"^",6)=X,$P(^PS(52.4,DA,0),"^",7)=X Q
VERIFY G:'$P(PSOPAR,"^",2) VERY
 S DIR("A")="VERIFY FOR "_PSONAM_" ? (Y/N/Delete/Quit): ",DIR("B")="Y",DIR(0)="SA^Y:YES;N:NO;D:DELETE;Q:QUIT"
 S DIR("?",1)="Enter Y (or return) to verify this prescription",DIR("?",2)="N to leave this prescription non-verified and to end this session of verification",DIR("?")="D to delete this prescription"
 D ^DIR K DIR G OUT:Y="N",QUIT:"Q^"[$E(Y),DELETE:Y="D"
VERY I $G(PKI1)=1 D REA^PSOPKIV1 G:'$D(PKIR) VERIFY
 K ^PSRX(PSONV,"DAI") S $P(^PSRX(PSONV,3),"^",6)=""
 K ^PSRX(PSONV,"DRI"),SPFL
 I '$O(^PSRX(PSONV,6,0)) D  I $D(DUOUT)!($D(DTOUT)) W !!,"Rx: "_$P(^PSRX(DA,0),"^")_" not Verified!!",! H 2 G OUT
 .W !!,"Dosing Instructions Missing. Please add!",!
 .I $P($G(^PSRX(PSONV,"SIG")),"^")]"",'$P($G(^("SIG")),"^",2) W "SIG: "_$P(^PSRX(PSONV,"SIG"),"^"),!
 .I $P($G(^PSRX(PSONV,"SIG")),"^",2),$O(^PSRX(PSONV,"SIG1",0)) D  K I
 ..W "SIG: " F I=0:0 S I=$O(^PSRX(PSONV,"SIG1",I)) Q:'I  W ^PSRX(PSONV,"SIG1",I,0),!
 .S DA=PSONV,PSOVER=1 K DIR,DIRUT,DUOUT,DTOUT
 .S PSODRUG("IEN")=$P(^PSRX(DA,0),"^",6),PSODFN=$P(^(0),"^",2),PSORXED("IRXN")=DA,PSODRUG("OI")=$P(^PSRX(DA,"OR1"),"^")
 .D DOSE^PSSORPH(.DOSE,PSODRUG("IEN"),"O",PSODFN),^PSOORED3
 .K PSODFN,PSODRUG("IEN"),DOSE,PSOVER
 .I '$G(ENT) S DUOUT=1
 .Q:$D(DUOUT)!($D(DTOUT))
 .K DIR,DIRUT,DUOUT,DTOUT S DIE=52,DR=114 D ^DIE K DIE,DR,DTOUT
 .I X'="" D SIG^PSOHELP D:$G(INS1)]"" EN^DDIOL($E(INS1,2,9999999)) S PSORXED("SIG",1)=$E(INS1,2,9999999)
 .D EN^PSOFSIG(.PSORXED,1),UDSIG^PSOORED3 H 2
 S DA=PSONV,$P(^PSRX(DA,2),"^",10)=DUZ I $P(^PSRX(DA,2),"^",2)>DT,$P(PSOPAR,"^",6) S (SPFL1,PSOVER)="",PSORX("FILL DATE")=$P(^(2),"^",2),RXF=0 D UPSUS S PSTRIVER=1 D SUS^PSORXL K PSORX("FILL DATE"),PSTRIVER G KILL
 ; IHS/MSC/PLS - 07/10/08
 ;S PSOVER(PSONV)="" S $P(^PSRX(PSONV,"STA"),"^")=0,$P(PSOSD("NON-VERIFIED",DRG),"^",2)=0,PSOSD("ACTIVE",DRG)=PSOSD("NON-VERIFIED",DRG)
 S PSOVERA(PSONV)="" S $P(^PSRX(PSONV,"STA"),"^")=0,$P(PSOSD("NON-VERIFIED",DRG),"^",2)=0,PSOSD("ACTIVE",DRG)=PSOSD("NON-VERIFIED",DRG)
 I $G(PKI1)=1,$G(PKIR)]"" D ACT^PSOPKIV1(DA)
 K PSOSD("NON-VERIFIED",DRG) D EN^PSOHLSN1(PSONV,"SC","CM","")
KILL S DA=PSONV,DIK="^PS(52.4," D ^DIK K DA,DIK D DCORD^PSONEW2
OUT K DIRUT,DTOUT,DUOUT,UPFLAGX D CLEAN Q
DELETE K UPFLAGX D DELETE^PSOVER2 G:$G(UPFLAGX) OUT K PSOSD("NON-VERIFIED",$G(DRG)) Q
QUIT S PSOQUIT="" D CLEAN Q
UPSUS S $P(PSOSD("NON-VERIFIED",DRG),"^",2)=5,PSOSD("ACTIVE",DRG)=PSOSD("NON-VERIFIED",DRG) K PSOSD("NON-VERIFIED",DRG) D EN^PSOHLSN1(PSONV,"SC","CM","")
 Q
CLEAN ;cleans up tmp("psorxdc") global
 I $O(^TMP("PSORXDC",$J,0)) F RORD=0:0 S RORD=$O(^TMP("PSORXDC",$J,RORD)) Q:'RORD  D
 .D PSOUL^PSSLOCK(RORD_$S($P(^TMP("PSORXDC",$J,RORD,0),"^")="P":"S",1:""))
 .W !,$S($P(^TMP("PSORXDC",$J,RORD,0),"^")=52:"Prescription",1:"Pending Order")_" #"_$S($P(^TMP("PSORXDC",$J,RORD,0),"^")=52:$P(^PSRX(RORD,0),"^"),1:RORD)_" NOT Discontinued."
 K ^TMP("PSORXDC",$J),RORD
 Q
KV1 ;
 K PSOANSQD,DRET,LST,PSOQUIT,PSODRUG,PSONEW,SIG,PSODIR,PHI,PRC,ORCHK,ORDRG,PSOSIGFL,PSORX("ISSUE DATE"),PSORX("FILL DATE"),CLOZPAT
KV K DIR,DIRUT,DTOUT,DUOUT
 Q
NVA ;
 I $P(PSOSD(STA,DNM),"^",11) D NVA^PSODRDU1 Q
 N PSOOI,CLASS,FLG,X,Y,RXREC,IFN
 S (Y,FLG)=""
 S RXREC=$P(PSOSD(STA,DNM),"^",10),PSOOI=+$G(^PS(55,DFN,"NVA",RXREC,0)),IFN=RXREC N DNM
 F  S Y=$O(^PSDRUG("ASP",PSOOI,Y)) Q:Y=""!(FLG)  S DNM=$P(^PSDRUG(Y,0),"^"),CLASS=$P(^PSDRUG(Y,0),"^",2) I PSODRUG("NAME")=DNM!(CLASS=PSODRUG("VA CLASS")) D DSP^PSODRDU1 S FLG=1 Q
 Q
 ; Ensure that the prescription has a provider
CHKPRV(RXIEN) ; EP
 N DIR,RET,Y
 S RET=$P(^PSRX(RXIEN,0),U,4)
 I 'RET D
 .S DIR("A")="Select Ordering Provider",DIR("B")=""
 .W !!,"This prescription is missing an Ordering Provider."
 .W !,"Enter ^ to bypass, ^^ to exit loop.",!
 .S DIR(0)="52,4" D ^DIR
 .S RET=+Y
 .I $D(DIROUT) S PSOQUIT=1 Q
 .I RET>0 D
 ..S $P(^PSRX(RXIEN,0),U,4)=RET
 ..D ^PSORXPR
 Q RET
