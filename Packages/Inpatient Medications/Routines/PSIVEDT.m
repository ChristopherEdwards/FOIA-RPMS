PSIVEDT ;BIR/MLM-EDIT IV ORDER ; 10 Feb 98 / 3:23 PM
 ;;5.0; INPATIENT MEDICATIONS ;**4**;16 DEC 97
EDIT ;
 S DONE=0
 F PSIVE=1:1 S:DONE&$E(PSIVAC)="C" OREND=1 Q:PSIVE>$L(EDIT,U)!(DONE)  Q:'$L($P(EDIT,U,PSIVE))  D @($P(EDIT,U,PSIVE)) S:$E(PSIVAC,2)="N" PSIVOK=PSIVOK_U_$P(EDIT,U,PSIVE) I $E(X)=U,$L(X)>1 S:PSIVE>1 PSIVE=PSIVE-1 F  D FF Q:Y<0  D @Y Q:$E(X)'=U
 K EDIT,PSIVOK,PSGDI
 Q
 ;
1 ; Provider.
 S P(6)=$S('$G(^VA(200,+P(6),"PS")):"",'$P(^("PS"),U,4):P(6),$P(^("PS"),U,4)<DT:"",1:P(6))
 W !,"PROVIDER: "_$S($P(P(6),U,2)]"":$P(P(6),U,2)_"//",1:"") R X:DTIME S:'$T X=U S:X=U DONE=1 I $E(X)=U!(X=""&P(6)) Q
 I X["???",($E(P("OT"))="I"),(PSIVAC["C") D ORFLDS^PSIVEDT1 G 1
 I X]"" K DIC S DIC=200,DIC(0)="EQMZ",DIC("S")="I $D(^(""PS"")),^(""PS""),$S('$P(^(""PS""),U,4):1,$P(^(""PS""),U,4)>DT:1,1:0)" D ^DIC K DIC I Y>0 S P(6)=+Y_U_Y(0,0) Q
 S F1=53.1,F2=1 D ENHLP^PSIVORC1 W $C(7),!!,"A Provider must be entered.",!! G 1
 Q
 ;
3 ; Med Route.
 I P("MR")="" S X=$O(^PS(51.2,"B","INTRAVENOUS",0)) I $P($G(^PS(51.2,+X,0)),U,4) S P("MR")=+X_U_$P(^(0),U,3)
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
 I $E(PSIVAC)="O" W !!,"Only additives marked for use in IV Fluid Order Entry may be selected."
 S FIL=52.6,DRGT="AD",DRGTN="ADDITIVE" D DRG^PSIVEDRG,DKILL
 Q
 ;
58 ; Solution.
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
