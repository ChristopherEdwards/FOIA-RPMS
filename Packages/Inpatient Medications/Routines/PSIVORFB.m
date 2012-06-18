PSIVORFB ;BIR/MLM-FILE/RETRIEVE ORDERS IN ^PS(55 ;05-Dec-2003 08:46;PLS
 ;;5.0; INPATIENT MEDICATIONS ;**3,18,28,68,58,85**;16 DEC 97
 ;
 ; Reference to ^PS(52.7 is supported by DBIA #2173.
 ; Reference to ^PS(52.6 is supported by DBIA #1231.
 ; Reference to ^PS(50.7 is supported by DBIA #2180.
 ; Reference to ^PS(51.2 is supported by DBIA #2178.
 ; Reference to ^PS(55 is supported by DBIA #2191.
 ; Reference to ^VA(200 is supported by DBIA #10060.
 ; Reference to ^DIC is supported by DBIA #10006.
 ; Reference to ^DIK is supported by DBIA #10013.
 ;
 ; Modified - IHS/CIA/PLS - 12/05/03 - Line NEW55+3
NEW55 ; Get new order number in 55.
 N DA,DD,DO,DIC,DLAYGO,X,Y
 I $D(^PS(55,+DFN)),'$D(^PS(55,+DFN,0)) D ENSET0^PSGNE3(+DFN)
 ; IHS/CIA/PLS - 12/05/03 - Reapplied IHS fix for HRN lookup
 ;S DIC="^PS(55,",DIC(0)="LN",DLAYGO=55,(DINUM,X)=+DFN D ^DIC Q:Y<0
 S DIC="^PS(55,",DIC(0)="LN",DLAYGO=55,DINUM=+DFN,X="`"_+DFN D ^DIC Q:Y<0
LOCK0 F  L +^PS(55,DFN,"IV",0):0 I  Q
 S ND=$S($D(^PS(55,DFN,"IV",0)):^(0),1:"^55.01") F DA=$P(ND,"^",3)+1:1 W "." I '$D(^PS(55,DFN,"IV",DA)) S $P(ND,"^",3)=DA,$P(ND,"^",4)=$P(ND,"^",4)+1,^PS(55,DFN,"IV",0)=ND Q
 L +^PS(55,DFN,"IV",+DA):0 E  G LOCK0
 S ^PS(55,DFN,"IV",+DA,0)=+DA,^PS(55,DFN,"IV","B",+DA,+DA)=""
 L -^PS(55,DFN,"IV",0) S ON55=+DA_"V"
 Q
 ;
SET55 ; Move data from local variables to 55.
 I '$D(ON55) W !,"*** Can't create this order at this time ***" Q
 N DA,DIK,ND,PSIVACT
 S:'$D(P(21)) (P(21),P("21FLG"))="" S ND(0)=+ON55,P(22)=$S(VAIN(4):+VAIN(4),1:.5) F X=2:1:23 I $D(P(X)) S $P(ND(0),U,X)=P(X)
 S ND(.3)=$G(P("INS"))
 S $P(ND(0),U,17)="A",ND(1)=P("REM"),ND(3)=P("OPI"),ND(.2)=$P($G(P("PD")),U)_U_$G(P("DO"))_U_+P("MR")_U_$G(P("PRY"))_U_$G(P("NAT"))
 F X=0,1,3,.2,.3 S ^PS(55,DFN,"IV",+ON55,X)=ND(X)
 S $P(^PS(55,DFN,"IV",+ON55,2),U,1,4)=P("LOG")_U_+P("IVRM")_U_U_P("SYRS"),$P(^(2),U,8,10)=P("RES")_U_$G(P("FRES"))_U_$S($G(VAIN(4)):+VAIN(4),1:"")
 S X=^PS(55,DFN,0) I $P(X,"^",7)="" S $P(X,"^",7)=$P($P(P("LOG"),"^"),"."),$P(X,"^",8)="A",^(0)=X
 S $P(^PS(55,DFN,"IV",+ON55,2),U,11)=+P("CLRK")
 S:+$G(P("CLIN")) ^PS(55,DFN,"IV",+ON55,"DSS")=P("CLIN")
 S:+$G(P("NINIT")) ^PS(55,DFN,"IV",+ON55,4)=P("NINIT")_U_P("NINITDT")
 ;S:'$D(PSIVUP) PSIVUP=+$$GTPCI^PSIVUTL K ^PS(55,DFN,"IV",+ON55,5) I $O(^PS(53.45,PSIVUP,4,0)) S %X="^PS(53.45,"_PSIVUP_",4,",%Y="^PS(55,"_DFN_",""IV"","_+ON55_",5," D %XY^%RCR
 F DRGT="AD","SOL" D PUTD55
 K DA,DIK S DA(1)=DFN,DA=+ON55,DIK="^PS(55,"_DA(1)_",""IV"",",PSIVACT=1 D IX^DIK
 Q
 ;
PUTD55 ; Move drug data from local array into 55
 K ^PS(55,DFN,"IV",+ON55,DRGT) S ^PS(55,DFN,"IV",+ON55,DRGT,0)=$S(DRGT="AD":"^55.02PA",1:"^55.11IPA")
 F X=0:0 S X=$O(DRG(DRGT,X)) Q:'X  D
 .S Y=^PS(55,DFN,"IV",+ON55,DRGT,0),$P(Y,U,3)=$P(Y,U,3)+1,DRG=$P(Y,U,3),$P(Y,U,4)=$P(Y,U,4)+1
 .S ^PS(55,DFN,"IV",+ON55,DRGT,0)=Y,Y=$P(DRG(DRGT,X),U)_U_$P(DRG(DRGT,X),U,3) S:DRGT="AD" $P(Y,U,3)=$P(DRG(DRGT,X),U,4) S ^PS(55,DFN,"IV",+ON55,DRGT,+DRG,0)=Y
 Q
GT55 ; Retrieve data from 55 into local array
 K DRG,DRGN,P S:'$D(ON55) ON55=ON S P("REN")="",Y=$G(^PS(55,DFN,"IV",+ON55,0)) F X=1:1:23 S P(X)=$P(Y,U,X)
 S P("21FLG")=P(21)
 S P("PON")=ON55,PSJORIFN=P(21),P(6)=P(6)_U_$P($G(^VA(200,+P(6),0)),U),(DRG,DRGN)="",P("REM")=$G(^PS(55,DFN,"IV",+ON55,1))
 S Y=$G(^PS(55,DFN,"IV",+ON55,2)),P("LOG")=$P(Y,U),P("IVRM")=$P(Y,U,2)_U_$P($G(^PS(59.5,+$P(Y,U,2),0)),U)
 S P("CLRK")=$P(Y,U,11)_U_$P($G(^VA(200,+$P(Y,U,11),0)),U),P("RES")=$P(Y,U,8),P("FRES")=$P(Y,U,9),P("SYRS")=$P(Y,U,4),P("OPI")=$G(^PS(55,DFN,"IV",+ON55,3))
 S P("INS")=$G(^PS(55,DFN,"IV",+ON55,.3))
 S P("CLIN")=$G(^PS(55,DFN,"IV",+ON55,"DSS"))
 S P("DTYP")=$S(P(4)="":0,P(4)="P"!(P(23)="P")!(P(5)):1,P(4)="H":2,1:3)
 D:'$D(PSJLABEL) GTPC(ON55) S ND=$G(^PS(55,DFN,"IV",+ON55,.2)),P("PD")=$S($P(ND,U):$P(ND,U)_U_$$OIDF^PSJLMUT1(+ND)_U_$P($G(^PS(50.7,+ND,0)),U),1:""),P("DO")=$P(ND,U,2),P("PRY")=$P(ND,U,4),P("NAT")=$P(ND,U,5)
 I P("PRY")="D",'+P("IVRM") S P("IVRM")=+$G(PSIVSN)_U_$P($G(^PS(59.5,+$G(PSIVSN),0)),U)
 S P("MR")=$P(ND,U,3),ND=$G(^PS(51.2,+P("MR"),0)),P("MR")=P("MR")_U_$S($P(ND,U,3)]"":$P(ND,U,3),1:$P(ND,U)) D GTCUM
 D GTDRG,GTOT^PSIVUTL(P(4))
K ; Kill and exit.
 K FIL,ND
 Q
GTDRG ; Get drug info and place in DRG(.
 F DRGT="AD","SOL" S FIL=$S(DRGT="AD":52.6,1:52.7) F Y=0:0 S Y=$O(^PS(55,DFN,"IV",+ON55,DRGT,Y)) Q:'Y  D
 .; naked ref below refers to line above
 .S DRG=$G(^(Y,0)),ND=$G(^PS(FIL,+DRG,0)),(DRGI,DRG(DRGT,0))=$G(DRG(DRGT,0))+1
 .S DRG(DRGT,+DRGI)=+DRG_U_$P(ND,U)_U_$P(DRG,U,2)_U_$P(DRG,U,3)_U_$P(ND,U,13)_U_$P(ND,U,11)
 Q
 ;
GTCUM ; Retrieve dispensing info.
 S ND=$G(^PS(55,DFN,"IV",+ON55,9)),P("LF")=$P(ND,U),P("LFA")=$P(ND,U,2),P("CUM")=$P(ND,U,3)
 Q
 ;
GTPC(ON) ; Retrieve Provider Comments and create "scratch" fields to edit
 ;S:'$D(PSIVUP) PSIVUP=+$$GTPCI^PSIVUTL K ^PS(53.45,PSIVUP,4)
 ;K ^PS(53.45,PSIVUP,4) I $O(^PS(55,DFN,"IV",+ON,5,0)) S %X="^PS(55,"_DFN_",""IV"","_+ON_",5,",%Y="^PS(53.45,"_PSIVUP_",4," D %XY^%RCR
 Q
 ;
SETNEW ; Create new order and set
 D NEW55,SET55
 Q
