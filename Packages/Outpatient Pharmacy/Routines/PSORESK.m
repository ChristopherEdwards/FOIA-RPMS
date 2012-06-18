PSORESK ;BIR/SAB-return to stock ;21-Aug-2008 14:56;SM
 ;;7.0;OUTPATIENT PHARMACY;**15,9,27,40,47,55,85,130,1002,1006,1007**;DEC 1997
 ;
 ; Modified - IHS/CIA/PLS - 03/31/04 - Lines BC1+35 and PAR+30
 ;                          12/07/04 - New RXLKUP  entry point
 ;                                     Line RXP
 ;            IHS/MSC/PLS - 10/18/07 - BC1+1 -Outside Pharmacy
 ;                          08/21/08 - Added additional parameter to CALLPOS calls.
 ;REF/IA
 ;^PSDRUG/221
 ;^PS(59.7/694
 ;L, UL, PSOL, and PSOUL^PSSLOCK/2789
 ;^PS(55/2228
 ;PSDRTS^PSDOPT0/3064
AC I '$D(PSOPAR) D ^PSOLSET I '$D(PSOPAR) W !!,"Outpatient Pharmacy Site Parameters are required!" Q
 S RESK=1,PSIN=+$P(^PS(59.7,1,49.99),"^",2) K PSODEF,^UTILITY($J,"PSOPCE") S PSOPCECT=1
BC K PSOWHERE,PSODEFLG,PSOINVTX,XTYPE W !! S DIR("A")="Enter/Wand PRESCRIPTION number",DIR("?")="^D HP^PSORESK1",DIR(0)="FO" D ^DIR K DIR I $D(DIRUT) K PSODEF G EX
 I X'["-" D BCI W:'$G(RXP) !,"INVALID Rx" G:'$G(RXP) BC G BC1
 I X["-" D  I $P(X,"-")'=$G(PSORESST) W !,$C(7),$C(7),"   INVALID STATION NUMBER !!",$C(7),$C(7),! K PSORESST G BC
 .K PSORESST S PSORESSX=$G(X) K PSORESAR S DA=$P($$SITE^VASITE(),"^") I $G(DA) S DIC=4,DIQ(0)="I",DIQ="PSORESAR",DR="99" D EN^DIQ1 S PSORESST=$G(PSORESAR(4,DA,99,"I")) K PSORESAR,DIQ,DA,DR S X=$G(PSORESSX) K PSORESSX
 I X["-" S RXP=$P(X,"-",2) I '$D(^PSRX(+$G(RXP),0))!($G(RXP)']"") W !,$C(7),$C(7),$C(7),"   NON-EXISTENT Rx" G BC
 G:$D(^PSRX(RXP,0)) BC1 W !,$C(7),$C(7),$C(7),"   IMPROPER BARCODE FORMAT" G BC
BC1 ;
 ;IHS/MSC/PLS - 10/18/07
 I $P($G(^PSRX(RXP,999999921)),U,3) D  G BC
 .W !,"Outside Pharmacy prescriptions can't be returned to stock!"
 S PSORRDFN=+$P($G(^PSRX(RXP,0)),"^",2)
 S PSOPLCK=$$L^PSSLOCK(PSORRDFN,0) I '$G(PSOPLCK) D LOCK^PSOORCPY K PSOPLCK G BC
 K PSOPLCK D PSOL^PSSLOCK(RXP) I '$G(PSOMSG) W !!,$S($P($G(PSOMSG),"^",2)'="":$P($G(PSOMSG),"^",2),1:"Another person is editing this order."),! K PSOMSG D UL^PSSLOCK(+$G(PSORRDFN)) G BC
 S PSOLOUD=1 D:$P($G(^PS(55,+$P(^PSRX(RXP,0),"^",2),0)),"^",6)'=2 EN^PSOHLUP($P(^PSRX(RXP,0),"^",2)) K PSOLOUD
 I $S('+$P($G(^PSRX(+RXP,"STA")),"^"):0,$P(^("STA"),"^")=11:0,$P(^("STA"),"^")=12:0,$P(^("STA"),"^")=14:0,$P(^("STA"),"^")=15:0,1:1) D STAT^PSORESK1 D UL G BC
 S COPAYFLG=1,QDRUG=$P($G(^PSRX(RXP,0)),"^",6),QTY=$P($G(^(0)),"^",7) I $O(^PSRX(RXP,1,0)) G REF
 S Y="O" I $O(^PSRX(RXP,"P",0)) D  I $D(DUOUT)!($D(DTOUT)) D UL G BC
 .S DIR(0)="SA^O:ORIGINAL;P:PARTIAL",DIR("B")="ORIGINAL",DIR("A",1)="",DIR("A",2)="There are Partials for this Rx.",DIR("A")="Which are you Returning To Stock? "
 .S DIR("?")=" Press return for Original. Enter 'P' for Partial" D ^DIR K DIR
 S XTYPE=$S(Y="O":"O",1:"P") G:Y="P" PAR
 I $P($G(^PSRX(RXP,2)),"^",15) W !,$C(7),$C(7),"Original fill for Rx # "_$P(^PSRX(RXP,0),"^")_" was Returned to Stock." D UL G BC
 I '$P($G(^PSRX(RXP,2)),"^",13),$P($G(^(2)),"^",2)'<PSIN W !,$C(7),$C(7),"Rx # "_$P(^PSRX(RXP,0),"^")_" was NOT released !" D UL G BC
 I $P($G(^PSRX(RXP,2)),"^",2)<PSIN D  D UL G BC
 .W !!,$C(7),$C(7),"Original Fill CANNOT be Returned!",!,"This fill entered before installation of version 6.  There are no refills.",!
 ;D CMOP^PSORESK1 I $G(PSXREL) K PSXREL G BC
 S PSOLOCRL=$P($G(^PSRX(RXP,2)),"^",13),PSOWHERE=$S($D(^PSRX("AR",+$G(PSOLOCRL),RXP,0)):1,1:0)
 W ! S DIR("B")="YES",DIR("A",1)="Are you sure you want to RETURN TO STOCK Rx # "_$P(^PSRX(RXP,0),"^")
 S DIR("A",2)="for "_$P(^DPT($P(^PSRX(RXP,0),"^",2),0),"^")_" ("_$E($P(^(0),"^",9),6,9)_")",DIR("A")="Drug: "_$P(^PSDRUG($P(^PSRX(RXP,0),"^",6),0),"^")
 I $G(PSOWHERE) S DIR("A",3)=" ",DIR("A",4)="   *** This prescription was filled at the CMOP *** ",DIR("A",5)=" "
 S DIR(0)="YO" D ^DIR K DIR I Y=0!($D(DIRUT)) D UL G BC
 ;ORI
 I $P($G(^PSRX(RXP,2)),"^",2)'<PSIN D  D UL,EX S (RESK,PSOPCECT)=1 G BC
 .I $T(PSDRTS^PSDOPT0)]"" D PSDRTS^PSDOPT0(RXP,"O^"_0,$P(^PSRX(RXP,2),"^",9),$P(^PSRX(RXP,0),"^",7)) D MSG
 .Q:$G(RETSK)
 .K PSOINVTX,PSODEFLG I $G(PSOWHERE),$G(^PSDRUG(QDRUG,660.1)) D INVT^PSORXDL I $G(PSODEFLG) W !!?5,"Prescription Not Returned to Stock!",! Q
 .I +$G(^PSRX(RXP,"IB")) D CP^PSORESK1 Q:'$G(COPAYFLG)
 .K DIR,DUOUT,DTOUT,DIRUT S DIR(0)="F^10:75",DIR("A")="Comments",DIR("?")="Comments are required, 10-75 characters.",DIR("B")=$S($D(PSODEF):PSODEF,1:"Per Pharmacy Request") D ^DIR D:$D(DIRUT)  Q:$D(DIRUT)  S (PSODEF,COM)=$G(Y) K DIR,X,Y
 ..W !!?5,"Prescription Not Returned to Stock!",!
 .I $G(^PSDRUG(QDRUG,660.1)) D
 ..I $G(PSOWHERE),'$G(PSOINVTX) Q
 ..S ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)+QTY
 .I $G(PSOWHERE) K ^PSRX("AR",+$G(PSOLOCRL),RXP,0)
 .D NOW^%DTC S DA=RXP,DA=RXP,DIE="^PSRX(",DR="31///@;32.1///"_% D ^DIE K DIE,DR,DA Q:$D(Y)
 .D ACT^PSORESK1 S DA=$O(^PS(52.5,"B",RXP,0)) I DA S DIK="^PS(52.5," D ^DIK
 .D CALLPOS^APSPFUNC(RXP,"","D","Returned to stock.")  ; IHS/CIA/PLS - 03/31/04
 .D EN^PSOHLSN1(RXP,"ZD") W !,"Rx # "_$P(^PSRX(RXP,0),"^")_" Returned to Stock.",!
REF I $O(^PSRX(RXP,1,0)),$O(^PSRX(RXP,"P",0)) D  I $D(DTOUT)!($D(DUOUT)) D UL G BC
 .S DIR(0)="SA^R:REFILL;P:PARTIAL",DIR("B")="REFILL",DIR("A",1)="",DIR("A",2)="There are Refills and Partials for this Rx.",DIR("A")="Which are you Returning To Stock? "
 .S DIR("?")=" Press return for Refill. Enter 'P' for Partial" D ^DIR K DIR
 I $O(^PSRX(RXP,1,0)),$O(^PSRX(RXP,"P",0)) S XTYPE=$S(Y="R":1,1:"P")
PAR S:$G(XTYPE)']"" XTYPE=1 S TYPE=0 F YY=0:0 S YY=$O(^PSRX(RXP,XTYPE,YY)) Q:'YY  S TYPE=YY
 I 'TYPE D UL,EX S (RESK,PSOPCECT)=1 G BC
 I $P($G(^PSRX(RXP,XTYPE,TYPE,0)),"^",16) W $C(7),!!,"Last Fill Already Returned to Stock !",! D UL,EX S (RESK,PSOPCECT)=1 G BC
 I '$P(^PSRX(RXP,XTYPE,TYPE,0),"^",$S(XTYPE:18,1:19)),$P(^(0),"^")'<PSIN W !!,$C(7),$C(7),$S(XTYPE:"Refill",1:"PARTIAL")_" #"_TYPE_" was NOT released !",! D UL G BC
 I '$P(^PSRX(RXP,XTYPE,TYPE,0),"^",$S(XTYPE:18,1:19)),$P(^(0),"^")<PSIN D  D UL G BC
 .W !!,$C(7),$C(7),$S(XTYPE:"Refill",1:"PARTIAL")_" #"_TYPE_" CANNOT be Returned!",!,"This fill entered before installation of version 6.",!
 W ! K DIR,DUOUT,DTOUT
 ;D CMOP1^PSORESK1 I $G(PSXREL) K PSXREL G BC
 K PSOLOCRL,PSOWHERE I $G(XTYPE) S PSOLOCRL=$P($G(^PSRX(RXP,XTYPE,+$G(TYPE),0)),"^",18),PSOWHERE=$S($D(^PSRX("AR",+$G(PSOLOCRL),RXP,+$G(TYPE))):1,1:0)
 W ! S DIR("B")="YES",DIR("A",1)="Are you sure you want to RETURN TO STOCK Rx # "_$P(^PSRX(RXP,0),"^")_$S(XTYPE:" Refill ",1:" Partial ")_"# "_TYPE,DIR(0)="Y"
 S DIR("A",2)="for "_$P(^DPT($P(^PSRX(RXP,0),"^",2),0),"^")_" ("_$E($P(^(0),"^",9),6,9)_")",DIR("A")="Drug: "_$P(^PSDRUG($P(^PSRX(RXP,0),"^",6),0),"^")
 I $G(PSOWHERE) S DIR("A",3)=" ",DIR("A",4)="   *** This prescription was filled at the CMOP *** ",DIR("A",5)=" "
 D ^DIR K DIR I 'Y!($D(DUOUT))!($D(DTOUT)) D UL G BC
 I $T(PSDRTS^PSDOPT0)]"" D
 .I XTYPE D PSDRTS^PSDOPT0(RXP,"R^"_TYPE,$P(^PSRX(RXP,1,TYPE,0),"^",9),$P(^(0),"^",4)) D MSG Q
 .D PSDRTS^PSDOPT0(RXP,"P^"_TYPE,$P(^PSRX(RXP,"P",TYPE,0),"^",9),$P(^(0),"^",4)) D MSG
 I $G(RETSK) D UL,EX G BC
 K PSOINVTX,PSODEFLG I $G(PSOWHERE),$G(^PSDRUG(QDRUG,660.1)) D INVT^PSORXDL I $G(PSODEFLG) W !!?5,"Prescription Not Returned to Stock!",! D UL G BC
 I +$G(^PSRX(RXP,"IB")),XTYPE D CP^PSORESK1 I '$G(COPAYFLG) D UL G BC
 K DIR,DIRUT,DTOUT,DUOUT S DIR(0)="F^10:75",DIR("A")="Comments",DIR("?")="Comments are required, 10-75 characters.",DIR("B")=$S($D(PSODEF):PSODEF,1:"Per Pharmacy Request") D ^DIR K DIR I $D(DIRUT) D  D UL G BC
 .W !!?5,"Prescription Not Returned to Stock!",!
 S (PSODEF,COM)=$G(Y) K X,Y
 D NOW^%DTC S QTY=$P(^PSRX(RXP,XTYPE,TYPE,0),"^",4) I $G(^PSDRUG(QDRUG,660.1)) D
 .I $G(PSOWHERE),'$G(PSOINVTX) Q
 .S ^PSDRUG(QDRUG,660.1)=^PSDRUG(QDRUG,660.1)+$G(QTY)
 I $G(PSOWHERE) K ^PSRX("AR",+$G(PSOLOCRL),RXP,$G(TYPE))
 S DA(1)=RXP,DA=TYPE,DIE="^PSRX("_DA(1)_","_$S(XTYPE:1,1:"""P""")_",",DR=$S(XTYPE:"17////@",1:"8////@")_";.01///@"
 W ! D ^DIE I $D(Y) D UL G BC
 D:XTYPE'="P" NPF
 D ACT^PSORESK1
 D CALLPOS^APSPFUNC(RXP,$S(TYPE:TYPE,1:""),"D","Returned to stock.")  ; IHS/CIA/PLS - 03/31/04 - Call POS Hook
 W !!,"Rx # "_$P(^PSRX(RXP,0),"^")_$S(XTYPE:" REFILL",1:" PARTIAL")_" #"_TYPE_" Returned to Stock" S DA=$O(^PS(52.5,"B",RXP,0)) I DA S DIK="^PS(52.5," D ^DIK
 K PSODISPP S:'$G(XTYPE) PSODISPP=1 D EN^PSOHLSN1(RXP,"ZD") K PSODISPP
 D UL G BC
EX ;
 K DA,DR,DIE,X,X1,X2,Y,RXP,REC,DIR,XDT,REC,RDUZ,DIRUT,PSOCPN,PSOCPRX,YY,QDRUG,QTY,TYPE,XTYPE,I,%,DIRUT,COPAYFLG,PSOINVTX,RESK,PSOPCECT,COM,PSOWHERE,PSOLOCRL,PSODEFLG,PSORRDFN,PSOMSG,PSOPLCK,PSDCS,PSDRS,RETSK
 Q
MSG I $G(PSDCS),'$G(PSDRS) W !!,"The PSDMGR key is required to return a CONTROLLED SUBSTANCE Rx to stock and",!,"update corresponding vault balances." S RETSK=1
 Q
BCI S RXP=0
 ; IHS/CIA/PLS - 12/07/04 - Change lookup to Extrinsic call
RXP ;S RXP=$O(^PSRX("B",X,RXP)) I $P($G(^PSRX(+RXP,"STA")),"^")=13 G RXP
 S RXP=$$RXLKUP(X)
 Q
UL ;
 I $G(RXP) D PSOUL^PSSLOCK(RXP)
 D UL^PSSLOCK(+$G(PSORRDFN))
 Q
NPF N PSOY I $G(TYPE)-1>0,+$P(^PSRX(RXP,1,TYPE-1,0),"^") D
 .S X1=+$P(^PSRX(RXP,1,$G(TYPE)-1,0),"^"),X2=$P(^PSRX(RXP,0),"^",8)-10\1
 .D C^%DTC S PSOY=X,X1=$P(^PSRX(RXP,2),"^",2),X2=TYPE*$P(^PSRX(RXP,0),"^",8)-10\1
 .D C^%DTC S X=$S(PSOY<X:X,1:PSOY)
 I $G(TYPE)-1<1 D
 .S X1=$P(^PSRX(RXP,2),"^",2),X2=$P(^PSRX(RXP,0),"^",8)-10\1
 .D C^%DTC S:$P(^PSRX(RXP,3),"^",8) X=""
 I $G(X) S DA=RXP,DIE=52,DR="102///"_X D ^DIE K DIE
 Q
 ; IHS/CIA/PLS - 12/07/04
 ; Perform lookup given partial or full prescription number.
 ; Screen allows non-deleted scripts and scripts for user selected division.
RXLKUP(X) ; EP
 N DIC,Y
 S DIC("S")="I $P($G(^(2)),U,9)=PSOSITE&($P($G(^(""STA"")),""^"")'=13)"
 S DIC(0)="EMQZ",DIC="^PSRX(" D ^DIC
 Q $S(+Y>0:+Y,1:0)
