ABMDBAN ; IHS/ASDST/DMJ - 3P Billing Banner ; 
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;ORIGINAL - TMD, BILLINGS AREA OFFICE
 ;
 ; IHS/SD/SDR - v2.5 p12 - UFMS
 ;   If user is logged into cashiering session and they are exiting
 ;   TPB they should get a message letting them know they are still
 ;   logged in.  Also added warning msg for "outstanding" open and
 ;   closed sessions.
 ;
 ; IHS/SD/SDR - abm*2.6*1 - NO HEAT - Added patch# to menu header
 ;
 S ABMM(0)=$S($D(Y(0)):$P(Y(0),U,2),$D(XQY0):$P(XQY0,U,2),1:$P($G(^XUTL("XQ",$J,"S")),U,3))
 ;
BEG ;
 G XIT:'$D(DUZ(2))
 S ABMM("SITE")=$P(^DIC(4,DUZ(2),0),"^",1)
 G XIT:$G(XQNO1)]""
 I '$D(IOF)!'$D(IO) S IOP="HOME" D ^%ZIS
NCNV ;CONVERSION NOT COMPLETE
 I '$D(^ABMCNVRT("ABMCNVRT","COMPLETE")) D
 .W $$EN^ABMVDF("IOF")
 .W !!!,$$EN^ABMVDF("RVN"),*7,"WARNING:",$$EN^ABMVDF("RVF")
 .W " Version 2.0 conversion has NOT completed. Contact your Site Manager."
 .W !!,"Do not use package until conversion has completed."
 .F  W ! Q:$Y+4>IOSL
 .S DIR(0)="E" D ^DIR K DIR
 W !,$$EN^ABMVDF("IOF"),!!
 I ABMM(0)["Third Party Billing" D
 .S ABMM(0)="Main Menu"
 .I '$D(ABMM("OUT")) S ABM("F1")=1
 W !?11,"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
 W !?11,"|"
 S ABMM("VER")=$O(^DIC(9.4,"C","ABM",""))
 I ABMM("VER")]"",$D(^DIC(9.4,ABMM("VER"),"VERSION"))
 S ABMM("VER")=$S('$T:"VERSION 1.0",1:"VERSION "_^DIC(9.4,ABMM("VER"),"VERSION"))
 S ABMM("VER")=ABMM("VER")_$S(+$$LAST^ABMENVCK("IHS 3P BILLING SYSTEM",$P(ABMM("VER")," ",2))'=0:"p"_+$$LAST^ABMENVCK("IHS 3P BILLING SYSTEM",$P(ABMM("VER")," ",2)),1:"")  ;abm*2.6*1 NO HEAT
 S ABMM("TITL")="THIRD PARTY BILLING SYSTEM - VER "_$P(ABMM("VER")," ",2) W ?80-$L(ABMM("TITL"))\2,ABMM("TITL"),?69,"|"
 W !,?11,"+",?80-$L(ABMM(0))\2,$$EN^ABMVDF("RVN"),ABMM(0),$$EN^ABMVDF("RVF"),?69,"+"
 W !?11,"|"
 W ?80-$L(ABMM("SITE"))\2,ABMM("SITE")
 W ?69,"|"
 ;
END ;
 W !?11,"+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+"
 I $D(^VA(200,DUZ,0)) D
 .W !,?11,"User: ",$P(^VA(200,DUZ,0),U),?52+$S($E(DT,6,7)<10:1,1:0)
 .D NOW^%DTC
 .W $$MDT^ABMDUTL(%)
 I $G(ABM("F1")) D
 .S X2=+$G(^ABMDPARM(DUZ(2),1,2))
 .S X1=DT
 .D ^%DTC
 .I X>1!(X="") D
 ..S Y=+$G(^ABMDPARM(DUZ(2),1,2))
 ..D DD^%DT
 ..W !!,$$EN^ABMVDF("RVN"),*7,"WARNING:",$$EN^ABMVDF("RVF")," The Claim Generator has not run since ",Y,"."
 ..W !?9,"Contact your Site Manager to investigate this problem."
 .I $P($G(^ABMDPARM(DUZ(2),1,0)),U,15)'="Y" D
 ..W *7,!!?5,"SITE PARAMETERS have not yet been reviewed. Access to the Claim"
 ..W !?5,"Editor is prevented until they are! The Site Parameters can be",!?5,"reviewed through the Table Maintenace Menu."
 .D FINDAOPN^ABMUCUTL  ;find all open sessions
 .S ABMFLG=0
 .S ABMSDT=0
 .F  S ABMSDT=$O(ABMO(ABMSDT)) Q:+ABMSDT=0  D  Q:ABMFLG=1
 ..I (DT)>($P(ABMSDT,".")) S ABMFLG=1
 .I $G(ABMFLG)=1 W !,"WARNING: Open cashiering sessions exist that should be reconciled for UFMS"
 .S ABMFLG="CLOSED"
 .D FINDACLS^ABMUCUTL  ;find all closed sessions
 .I $D(ABMO) W !,"WARNING: Cashiering sessions are closed and awaiting export to UFMS"
 K ABM("F1")
 ;
XIT ;
 D EN^XBVK("ABM")  ;local variable killer
 K X,Y,I,X1,X2,DUOUT,DTOUT,DIROUT,POP,ZTSK,ZTSAVE,ZTRTN,ZTDESC,%ZIS,TO,FR,BY,FLDS,PG,DIR,DIC,DIE,DIK,DA,DR,L,%X,%Y
 Q
 ;
OUT ;EP - Entry Point for all Option Exits
 K DIQ
 S ABMM(0)=$S($G(^XUTL("XQ",$J,"T")):$P($G(^XUTL("XQ",$J,^("T")-1)),U,3),1:"")
 I $P($G(Y(0)),U)="ABMMENU"!($P($G(XQY0),U)="ABMMENU") D SESSCK G XIT
 S ABMM("OUT")=""
 G BEG
 ;
SESSCK ;EP - Check if user has open session for UFMS
 S ABMUOPNS=$$FINDOPEN^ABMUCUTL(DUZ)
 I +$G(ABMUOPNS)'=0 D
 .W !!,"NOTE: You are still logged into your cashiering session.  To Close"
 .W !?6,"your session select Cashiering Options (UCSH), then Cashiering Sign In/"
 .W !?6,"Sign Out (CIO).",!
 .S DIR(0)="E",DIR("A")="Enter RETURN to Continue" D ^DIR K DIR
 Q
