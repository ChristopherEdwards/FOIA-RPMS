PSIVEDT ;BIR/MLM-EDIT IV ORDER ;02-Apr-2013 19:38;PLS
 ;;5.0; INPATIENT MEDICATIONS ;**4,110,127,133,134,1015**;16 DEC 97;Build 62
 ;
 ; Reference to ^DD(53.1 is supported by DBIA 2256.
 ; Reference to ^PS(52.7 is supported by DBIA 2173.
 ; Reference to ^PS(52.6 is supported by DBIA 1231.
 ; Reference to ^PS(51.2 is supported by DBIA 2178.
 ; Reference to ^PS(50.7 is supported by DBIA 2180.
 ; Reference to ^PS(55 is supported by DBIA 2191.
 ;
 ; Modified - IHS/MSC/PB - 4/20/12 - added line at EDIT+1
 ;                       - 4/20/12 - added line tag 9999999
 ;                       - 9/14/12 - modified line edit+5
 ;                       - 2/11/13 - modified line OFFSET+7 to read Beyond Use Date
 ;                       - 3/22/13 - changed prompt at 9999999+6 to read Beyond Use Days
 ;                       - 3/25/13 - added line OFFSET+6 to set the default value of the Beyond Use Days prompt
 ;                                 - Modified EDIT + 1 to set APSPON to +$G(ON) commented out the line to add field 9999999 to the EDIT variable.
 ;                       - 04/02/13 - Line EDIT+6
EDIT ;
 ;IHS/MSC/PB line below modified to check the iv room parameter to determine if
 ;the expiration date prints on the iv label.
 ;IHS/MSC/PB - Line below changed to correct a problem with saving and then resetting the value of the variable ON should have set APSPON=$G(ON) not +$G(ON)
 ;I $P($G(^PS(59.5,+P("IVRM"),9999999)),"^")=1 S APSPON=+$G(ON) S:$G(EDIT)'[9999999 EDIT=EDIT_U_9999999
 ;I $P($G(^PS(59.5,+P("IVRM"),9999999)),"^")=1 S APSPON=$G(ON) S:$G(EDIT)'[9999999 EDIT=EDIT_U_9999999
 I +$G(^PS(59.5,+P("IVRM"),9999999)) S APSPON=$G(ON) S:$G(EDIT)'[9999999 EDIT=EDIT_U_9999999  ;IHS/MSC/PLS - 04/02/12
 I $G(DFN)&($G(PSJORD)["V") I $$COMPLEX^PSJOE(DFN,PSJORD) D
 . N X,Y,PARENT,P2ND S P2ND=$S($G(^PS(55,PSGP,"IV",+PSJORD,.2)):$G(^PS(55,PSGP,"IV",+PSJORD,.2)),1:$G(^PS(55,PSGP,5,+PSJORD,.2)))
 . S PARENT=$P(P2ND,"^",8)
 . I PARENT D FULL^VALM1 W !!?5,"This order is part of a complex order. Please review the following ",!?5,"associated orders before changing this order." D CMPLX^PSJCOM1(PSGP,PARENT,PSJORD)
 S DONE=0
 F PSIVE=1:1 S:DONE&$E(PSIVAC)="C" OREND=1 Q:PSIVE>$L(EDIT,U)!(DONE)  Q:'$L($P(EDIT,U,PSIVE))  D @(+$P(EDIT,U,PSIVE)) S:$E(PSIVAC,2)="N" PSIVOK=PSIVOK_U_$P(EDIT,U,PSIVE) I $E(X)=U,$L(X)>1 S:PSIVE>1 PSIVE=PSIVE-1 F  D FF Q:Y<0  D @Y Q:$E(X)'=U
 K EDIT,PSIVOK,PSGDIV
 Q
 ;
1 ; Provider.
 I $G(P("RES"))="R" I $G(PSJORD)["P",$P($G(^PS(53.1,+$G(ON),0)),"^",24)="R" D  Q
 . W !!?5,"This is Renewal order. Provider may not be edited at this point." D PAUSE^VALM1
 I $G(DFN)&($G(ON)["V") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Provider may not be edited at this point." D PAUSE^VALM1
 S P(6)=$S('$G(^VA(200,+P(6),"PS")):"",'$P(^("PS"),U,4):P(6),$P(^("PS"),U,4)<DT:"",1:P(6))
 W !,"PROVIDER: "_$S($P(P(6),U,2)]"":$P(P(6),U,2)_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $E(X)=U!(X=""&P(6)) Q
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS^PSIVEDT1 G 1
 I X]"" K DIC S DIC=200,DIC(0)="EQMZ",DIC("S")="I $D(^(""PS"")),^(""PS""),$S('$P(^(""PS""),U,4):1,$P(^(""PS""),U,4)>DT:1,1:0)" D ^DIC K DIC I Y>0 S P(6)=+Y_U_Y(0,0) Q
 S F1=53.1,F2=1 D ENHLP^PSIVORC1 W $C(7),!!,"A Provider must be entered.",!! G 1
 Q
 ;
3 ; Med Route.
 I $G(P("RES"))="R" I $G(PSJORD)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . W !!?5,"Med Route may not be edited at this point." D PAUSE^VALM1
 I $G(DFN)&($G(ON)["V") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Med Route may not be edited at this point." D PAUSE^VALM1
 S P(6)=$S('$G(^VA(200,+P(6),"PS")):"",'$P(^("PS"),U,4):P(6),$P(^("PS"),U,4)<DT:"",1:P(6))
 I P("MR")="" D
 .N AD,SOL,OI,RT,RTCNT
 .S AD=0 F  S AD=$O(DRG("AD",AD)) Q:'AD  S OI=$P(DRG("AD",AD),"^",6) I OI S OI(OI)=""
 .S SOL=0 F  S SOL=$O(DRG("SOL",SOL)) Q:'SOL  S OI=$P(DRG("SOL",SOL),"^",6) I OI S OI(OI)=""
 .S OI="" F  S OI=$O(OI(OI)) Q:'OI  S RT=$P(^PS(50.7,OI,0),"^",6) S:RT="" RT="NONE" S RT(RT)=$P($G(^PS(51.2,+RT,0)),"^",3)
 .S RT="" F RTCNT=0:1 S RT=$O(RT(RT)) Q:RT=""
 .Q:RTCNT>1
 .S RT=$O(RT("")) I RT]"" S P("MR")=RT_"^"_$G(RT(RT))
 W !,"MED ROUTE: "_$S($P(P("MR"),U,2)]"":$P(P("MR"),U,2)_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I X=U!(X=""&P("MR"))!($E(X)=U) Q
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS^PSIVEDT1 G 3
 I X]"" K DIC S DIC=51.2,DIC(0)="EQMZ",DIC("S")="I $P(^(0),U,4)" D ^DIC K DIC I Y>0 S P("MR")=+Y_U_$P(Y(0),U,3) Q
 S F1=53.1,F2=3 D ENHLP^PSIVORC1 W $C(7),!!,"A Med Route must be entered." G 3
 Q
 ;
10 ; Start Date.
 D 10^PSIVEDT1
 Q
 ;
25 ; Stop Date.
 D 25^PSIVEDT1
 Q
26 ; Schedule
 D 26^PSIVEDT1
 Q
 ;
39 ; Admin Times.
 D 39^PSIVEDT1
 Q
 ;
57 ; Additive.
 I $G(P("RES"))="R" I $G(PSJORD)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . W !!?5,"Additive may not be edited at this point." D PAUSE^VALM1
 I $G(DFN)&($G(ON)["V") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Provider may not be edited at this point." D PAUSE^VALM1
 I $E(PSIVAC)="O" W !!,"Only additives marked for use in IV Fluid Order Entry may be selected."
 S FIL=52.6,DRGT="AD",DRGTN="ADDITIVE" D DRG^PSIVEDRG,DKILL
 Q
 ;
58 ; Solution.
 I $G(P("RES"))="R" I $G(PSJORD)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . W !!?5,"Solution may not be edited at this point." D PAUSE^VALM1
 S FIL=52.7,DRGT="SOL",DRGTN="SOLUTION" D DRG^PSIVEDRG
 ;
DKILL ; Kill for drug edit.
 K DRGI,DRGN,DRGT,DRGTN,FIL,PSIVSTR
 Q
 ;
59 ; Infusion Rate.
 D 59^PSIVEDT1
 Q
 ;
62 ; IV Room.
 N DIR S DIR(0)="PA^59.5",DIR("A")="IV Room: ",DIR("??")="^S F1=59.5,F2=.01 D ENHLP^PSIVORC1" S:P("IVRM") DIR("B")=$P(P("IVRM"),U,2)
 D ^DIR Q:$D(DIRUT)  I Y>0 S P("IVRM")=Y W $P($P(Y,U,2),X,2)
 Q
 ;
63 ; Remarks.
 D 63^PSIVEDT1
 Q
 ;
64 ; Other Print Info.
 D 64^PSIVEDT1
 Q
 ;
66 ; Provider's comments.
 N DA,DIE,DIR S DA=PSIVUP,DIE="^PS(53.45,",DR=4 D ^DIE S PSGSI=X,Y=1
 Q
 ;
101 ; Orderable Item.
 I $G(P("RES"))="R" I $G(PSJORD)["P",$P($G(^PS(53.1,+ON,0)),"^",24)="R" D  Q
 . W !!?5,"This is Renewal order. Orderable Item may not be edited at this point." D PAUSE^VALM1
 I $G(DFN)&($G(ON)["V") I $$COMPLEX^PSJOE(DFN,ON) D  Q
 .Q:$G(PSJBKDR)  W !!?5,"This is a Complex Order. Orderable Item may not be edited at this point." D PAUSE^VALM1
 W !,"Orderable Item: "_$S(P("PD"):$P(P("PD"),U,2)_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $E(X)=U!(X=""&P("PD")) Q
 I X]"" N DIC S DIC="^PS(50.7,",DIC(0)="EMQZ",DIC("B")=$S(P("PD")]"":+$P(("PD"),U),1:""),DIC("S")="S PSJSCT=1 I $$DRGSC^PSIVUTL(Y,PSJSCT) K PSJSCT" D ^DIC K DIC I Y>0 S P("PD")=Y Q
 W $C(7),!!,"Orderable Item is required!",!! G 101
 Q
109 ; Dosage Ordered.
 W !,"DOSAGE ORDERED: "_$S(P("DO")]"":P("DO")_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $E(X)=U!(P("DO")]""&(X="")) Q
 I X="???" D ORFLDS^PSIVEDT1 G 109
 D:X]"" CHK^DIE(53.1,109,"",X,.X) I $G(X)="^" W $C(7),!!,"Enter the dosage in which the Orderable Item entered should be dispensed.",! W "Answer must be 1-20 characters in length." G 109
 S P("DO")=X
 Q
 ;
FF ; up-arrow to another field.
 N DIC S X=$P(X,U,2),DIC="^DD(53.1,",DIC(0)="QEM",DIC("S")="I U_PSIVOK_U[(U_+Y_U)" D ^DIC K DIC S Y=+Y
 Q
 ;
NEWDRG ; Ask if adding a new drug.
 K DIR S DIR(0)="Y",DIR("A")="Are you adding "_$P(TDRG,U,2)_" as a new "_$S(DRGT="AD":"additive",1:"solution")_" for this order",DIR("B")="NO" D ^DIR I $D(DTOUT)!$D(DUOUT) Q
 I Y S (DRGI,DRG(DRGT,0))=DRG(DRGT,0)+1,DRG=TDRG,DRG(DRGT,+DRGI)=+DRG_U_$P(DRG,U,2) I DRGT="SOL" S X=$G(^PS(52.7,+DRG,0)),$P(DRG(DRGT,DRG),U,3)=$P(X,U,3)
 Q
9999999 ;IHS/MSC/PB - 4/25/12 added to allow edits of the stability offset value - 4/20/12 PB
 S II="A",OFFSET=31 F  S II=$O(DRG(II)) Q:II=""  S JJ=0 F  S JJ=$O(DRG(II,JJ)) Q:JJ'>0  D
 .Q:$P(DRG(II,JJ),"^",7)=""
 .S:$P(DRG(II,JJ),"^",7)<OFFSET OFFSET=$P(DRG(II,JJ),"^",7)
 S:OFFSET=31 OFFSET=0
 ;;IHS/MSC/PB - 3/23/13 added line below to set the current offset value as default
 S:$G(^PS(53.1,+$G(ON),9999999))>0 OFFSET=$G(^PS(53.1,+ON,9999999))
 ;IHS/MSC/PB - 2/11/13 changed the prompt below to be Beyond Use Date
 ;W !,"Stability Offset Value: "_OFFSET_"//" R X:DTIME
 ;IHS/MSC/PB - 3/22/13 changed Date to Days
 ;W !,"Beyond Use Date: "_OFFSET_"//" R X:DTIME
 I $D(P("OFFSET")) S OFFSET=P("OFFSET")
 W !,"Beyond Use Days: "_OFFSET_"//" R X:DTIME
 I X="^" S OFFSET=OFFSET Q
 I X>30 W !,"Max value is 30..." G 9999999
 I X<0 W !,"Minimum value is 0 (zero)..." G 9999999
 I X="?" W !,"Number of days into the future from IV Label print where the IV will expire." G 9999999
 S:X'="" OFFSET=X
 S ON=APSPON,P("OFFSET")=OFFSET
 ;ADD CODE TO PUT VALUE INTO 53.1
 S DA=+ON,DIE="^PS(53.1,",DR="9999999.01////"_$G(OFFSET) D ^DIE K DIE,DA,DR
 ;
 Q
