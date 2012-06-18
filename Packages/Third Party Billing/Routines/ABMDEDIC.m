ABMDEDIC ; IHS/ASDST/DMJ - Claim Selection ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
CLM ;SELECT CLAIM
 K ABMP("CDFN")
 S DIR("A")="Select CLAIM or PATIENT"
 S DIR("?")="Enter either the Claim Number or a Patient Identifier (Name, HRN, SSN, DOB)"
 S DIR(0)="FO" D ^DIR K DIR
 Q:$D(DIRUT)
 S ABM("INPUT")=Y
 I Y=" " D  Q
 .S X=Y,DIC="^ABMDCLM(DUZ(2),",DIC(0)="EMQ" D ^DIC
 .Q:+Y<0
 .S ABMP("CDFN")=+Y
 I $D(^ABMDCLM(DUZ(2),+Y,0)) D
 .Q:$P($G(^ABMDCLM(DUZ(2),+Y,0)),U)=""
 .S DIC("W")="S ABMP(0)=^(0) D DICW^ABMDEDIC"
 .S ABMP("CDFN")=+Y
 .S X=Y,DIC="^ABMDCLM(DUZ(2),",DIC(0)="EM" D ^DIC
 .S DIR(0)="Y",DIR("A")="Correct Claim",DIR("B")="YES"
 .D ^DIR K DIR
 .I Y'=1 K ABMP("CDFN")
 I $G(ABMP("CDFN")) G XIT
PAT ;PATIENT LOOKUP
 S X=ABM("INPUT"),DIC="^AUPNPAT(",DIC(0)="EMQ",AUPNLK("ALL")=1
 D ^DIC
 I +Y<0 G CLM
 S ABM("STATUS")=$P(^DD(9002274.3,.04,0),"^",3)
 S ABMP("PDFN")=+Y,ABM("P0")=^DPT(ABMP("PDFN"),0)
 S $P(ABM("="),"=",80)=""
 D PAT^ABMDUTL(ABMP("PDFN"))
 S I="",ABM("CNT")=0 F  S I=$O(^ABMDCLM(DUZ(2),"B",ABMP("PDFN"),I),-1) Q:'I!($G(ABMP("CDFN")))!($D(DIRUT))  D
 .Q:$G(^ABMDCLM(DUZ(2),I,0))=""
 .I '(ABM("CNT")#5) D PAT^ABMDUTL(ABMP("PDFN"))
 .S ABM("CNT")=ABM("CNT")+1
 .S ABM("CNT",ABM("CNT"))=I
 .W !!,"(",ABM("CNT"),")"
 .W ?5,"Claim# ",I
 .S ABM("ZERO")=$G(^ABMDCLM(DUZ(2),I,0)) N J F J=1:1:8 S ABM(J)=$P(ABM("ZERO"),U,J)
 .S ABM(4)=$P(ABM("STATUS"),ABM(4)_":",2),ABM(4)=$P(ABM(4),";",1)
 .W ?20,$$SDT^ABMDUTL(ABM(2))
 .W ?31,$P($G(^ABMDVTYP(+ABM(7),0)),U)
 .W ?55,$P($G(^DIC(40.7,+ABM(6),0)),U)
 .W !,?6,$P($G(^AUTTLOC(+ABM(3),0)),U,2)
 .W ?21,$P($G(^AUTNINS(+ABM(8),0)),U)
 .W ?50,"Status: ",ABM(4)
 .I '(ABM("CNT")#5) D SEL
 I (ABM("CNT")#5) D SEL
 I '$G(ABMP("CDFN")) G CLM
 G XIT
SEL ;SELECT
 Q:$G(ABMP("CDFN"))
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="NAO^1:"_ABM("CNT"),DIR("A")="Select 1 to "_ABM("CNT")_": " D ^DIR K DIR
 I Y S ABMP("CDFN")=ABM("CNT",Y)
 I Y="",'$D(DTOUT) K DIRUT
 Q
 ;
DICW ;EP - for displaying claim identifiers
 I $G(DZ)["?" W ?46,$P(^DPT(+ABMP(0),0),U,2)," ",$$HDT^ABMDUTL($P(^(0),U,3))," ",$P(^(0),U,9)
 I  I $G(DUZ(2)),$D(^AUPNPAT(+ABMP(0),41,DUZ(2),0)) W ?68,$P($G(^AUTTLOC(DUZ(2),0)),U,7)," ",$P(^AUPNPAT(+ABMP(0),41,DUZ(2),0),U,2)
 I $G(X)'=+ABMP(0)!($G(DZ)["?") W !
 W ?17,"Clm:",Y,"  ",$$HDT^ABMDUTL($P(ABMP(0),U,2))," "
 I $P(ABMP(0),U,7) W $E($P($G(^ABMDVTYP($P(ABMP(0),U,7),0)),U),1,12)
 I $P(ABMP(0),U,6),$P(ABMP(0),U,3) W ?51,$E($P($G(^DIC(40.7,$P(ABMP(0),U,6),0)),U),1,15),?68,$E($P($G(^AUTTLOC($P(ABMP(0),U,3),0)),U,2),1,12)
 I $P(ABMP(0),U,8) W !?25,$E($P($G(^AUTNINS($P(ABMP(0),U,8),0)),U),1,30)
 I $P(ABMP(0),U,4)]"",$D(^DD(9002274.3,.04,0)) W ?57,$E($P($P($P(^(0),U,3),$P(ABMP(0),U,4)_":",2),";"),1,20)
 S DIW=1
 K ABMP(0)
 Q
 ;
CLM1 W !! K %P,DIR,DIC S DIR("A")="Select CLAIM or PATIENT",DIR(0)="FO^1:30",DIR("?")="Select the CLAIM NUMBER or a PATIENT IDENTIFIER"
 S ABM("D")="^ABMDCLM(DUZ(2),",ABM("D0")="QZEM"
 S DIR("?",1)="Enter either the Claim Number or a Patient Identifier (Name, HRN, SSN, DOB)"
 S DIR("?",2)=""
 S DIR("?")="      (NOTE: Existing Claims are displayed by entering ""??"")"
 S DIR("??")="^S X=""??"",DIC=ABM(""D""),DIC(0)=ABM(""D0"") D ^DIC"
 D ^DIR K DIR,ABM
 G XIT:$D(DIROUT)!$D(DIRUT)!$D(DUOUT)!$D(DTOUT)
 S DIC="^ABMDCLM(DUZ(2),",DIC(0)="ZMIE" D ^DIC K DIC
 G CLM1:+Y<1 S ABMP("CDFN")=+Y
 G XIT
 ;
XIT K ABM,AUPNLK("ALL")
 Q
 ;
MULT ;EP for Selecting Multiple Claims
 S AUPNLK("ALL")=1
 K DIC S ABM("C")=0,DIC="^ABMDCLM(DUZ(2),",DIC(0)="QEAM" W !
 F ABM=1:1 W ! D  Q:X=""!$D(DUOUT)!$D(DTOUT)
SELO .S ABM("E")=$E(ABM,$L(ABM)),DIC("A")="Select "_ABM_$S(ABM>3&(ABM<21):"th",ABM("E")=1:"st",ABM("E")=2:"nd",ABM("E")=3:"rd",1:"th")_" CLAIM: ",DIC(0)="QEAM" D ^DIC
 .Q:X=""!$D(DUOUT)!$D(DTOUT)
 .I +Y<1 G SELO
 .S ABMM(+Y)=""
 K DIC
 G XIT
