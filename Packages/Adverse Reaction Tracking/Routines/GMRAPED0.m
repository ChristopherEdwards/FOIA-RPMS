GMRAPED0 ;HIRMFO/RM,WAA-VERIFIER EDIT OF DRUG A/AR ;09-Feb-2011 17:05;MGH
 ;;4.0;Adverse Reaction Tracking;**17,1002**;Mar 29, 1996;Build 32
 ;IHS/MSC/MGH added data to edit source
EN1 ; ENTRY TO EDIT INFO SPECIFIC TO DRUG A/AR FOR VERIFIER
 K GMRAINGR,GMRACLAS
 I '$D(^XUSEC("GMRA-ALLERGY VERIFY",DUZ)) G Q1
 S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0)) G:GMRAPA(0)="" Q1
 F GMRAINGR=0:0 S GMRAINGR=$O(^GMR(120.8,GMRAPA,2,GMRAINGR)) Q:GMRAINGR'>0  S X=$S($D(^GMR(120.8,GMRAPA,2,GMRAINGR,0)):^(0),1:"") I +X>0 S Y=$S($D(^PS(50.416,+X,0)):^(0),1:"") I $P(Y,U)'="" S GMRAINGR($P(Y,U),+X)=Y
 F GMRACLAS=0:0 S GMRACLAS=$O(^GMR(120.8,GMRAPA,3,GMRACLAS)) Q:GMRACLAS'>0  S X=$S($D(^GMR(120.8,GMRAPA,3,GMRACLAS,0)):^(0),1:"") I +X>0 S Y=$S($D(^PS(50.605,+X,0)):^(0),1:"") I $P(Y,U)'="" S GMRACLAS($P(Y,U),+X)=Y
 S GMRAPA(0)=$G(^GMR(120.8,GMRAPA,0))
 W @IOF
 W !,"CAUSATIVE AGENT: ",$P(GMRAPA(0),U,2)
 W !?11,"TYPE: ",$$OUTTYPE^GMRAUTL($P(GMRAPA(0),U,20))
 W !?4,"INGREDIENTS: " S Y="",GMRAPRSW=0 F  S Y=$O(GMRAINGR(Y)) Q:Y=""  F X=0:0 S X=$O(GMRAINGR(Y,X)) Q:X'>0  W:GMRAPRSW ! W ?17,Y S:'GMRAPRSW GMRAPRSW=1
 W !,"VA DRUG CLASSES: "
 S Y="",GMRAPRSW=0 F  S Y=$O(GMRACLAS(Y)) Q:Y=""  F X=0:0 S X=$O(GMRACLAS(Y,X)) Q:X'>0  W:GMRAPRSW ! W ?17,Y," - ",$P(GMRACLAS(Y,X),U,2) S:'GMRAPRSW GMRAPRSW=1
 W !,"       OBS/HIST: ",$S($P(GMRAPA(0),U,6)="o":"OBSERVED",$P(GMRAPA(0),U,6)="h":"HISTORICAL",1:"")
 D  ;Sign/Symptoms
 .N GMRAVFY
 .S GMRAVFY=1
 .D EN1^GMRADSP3
 .Q
 W !,"      MECHANISM: ",$S($P(GMRAPA(0),U,14)="A":"ALLERGY",$P(GMRAPA(0),U,14)="P":"PHARMACOLOGIC",$P(GMRAPA(0),U,14)="U":"UNKNOWN",1:"")
YNED W !!,"Would you like to edit any of this data" S %=0 D YN^DICN I '% W !?4,$C(7),"ANSWER YES IF YOU WISH TO CHANGE ANY OF THE DATA ABOVE, ELSE ANSWER NO." G YNED
 S:%=-1 GMRAOUT=1 G Q1:%=2!GMRAOUT
 D EN1^GMRAPED3 G:GMRAOUT Q1 I GMRAAR'="" S DIE="^GMR(120.8,",DA=GMRAPA,DR=".02////^S X=GMRAAR(0);1////^S X=GMRAAR"_$S($D(GMRAAR("O")):";3.1////"_GMRAAR("O"),1:"") D ^DIE
 S GMRAPA(0)=$G(^GMR(120.8,+GMRAPA,0))
 S GMRAEN=GMRAPA_";GMR(120.8," D INPTYPE^GMRAUTL(GMRAEN) G Q1:GMRAOUT
 S DA=GMRAPA,DIE="^GMR(120.8,",DR="2" D ^DIE S:$D(Y) GMRAOUT=1 G Q1:GMRAOUT
 S GMRAPA(0)=$G(^GMR(120.8,+GMRAPA,0))
 D DRGCLS^GMRAPED1
 ;IHS/MSC/MGH added to edit source
 S DA=GMRAPA,DIE="^GMR(120.8,",DR="9999999.11" D ^DIE S:$D(Y) GMRAOUT=1 G Q1:GMRAOUT
 I 'GMRAOUT F  K Y D  Q:GMRAOUT!('$D(Y))
 .S GMRAPA(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
 .S DR="6(O)bserved or (H)istorical Allergy/Adverse Reaction",DIE="^GMR(120.8,",DA=GMRAPA D ^DIE
 .I $D(Y) S GMRAOUT=1 Q
 .S GMRANEW(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
 .I $P(GMRANEW(0),"^",6)="" W $C(7),"  Required??" S Y="" Q
 .Q:$P(GMRANEW(0),"^",6)=$P(GMRAPA(0),"^",6)
 .I $P(GMRAPA(0),"^",6)'=$P(GMRANEW(0),"^",6) D  Q
 ..W !!,"You cannot change the type of reaction.  If this is incorrect",!,"please exit and mark this entry as entered-in-error and then re-enter",!,"the correct information.",!
 ..S DIE="^GMR(120.8,",DR="6////"_$P(GMRAPA(0),"^",6),DA=GMRAPA D ^DIE S Y="" Q
 ..Q
 .Q
 I 'GMRAOUT D EN1^GMRAPER2(GMRAPA,"120.8",.GMRAOUT)
 ;Added into the snomed event
 ;I 'GMRAOUT D MECH Q:GMRAOUT
 ;Add the event type IHS/MSC/MGH
 I 'GMRAOUT D EVENT Q:GMRAOUT
 S GMRAPA(0)=$S($D(^GMR(120.8,GMRAPA,0)):^(0),1:"")
 S GMRAOUT=0 G EN1
Q1 ;Exit
 K GMRAEN,X,GMRAAR
 K DA,DIE,DR,DIC
 Q
MECH ;Mechanism for ADRs
 F  W !!,?5,"Choose one of the following:",! D  Q:GMRAOUT!('$D(Y))
 .F GMRAMEC="A - ALLERGY","P - PHARMACOLOGICAL","U - UNKNOWN" W !,?20,GMRAMEC
 .W ! S DIE="^GMR(120.8,",DA=GMRAPA,DR=17 D ^DIE
 .S:$D(Y) GMRAOUT=1
 .Q
 Q
EVENT N DIC,DA,DR,DIE,X,Y,IEN,TXT,MECH
 S TXT=""
 S DIE="^GMR(120.8,",DA=GMRAPA,DR=9999999.13
 D ^DIE
 I X'="" S TXT=$P($G(^BEHOAR(90460.06,X,0)),U,1)
 ;Add the mechanism in here
 S MECH=$S(TXT="DRUG ALLERGY":"A",TXT="FOOD ALLERGY":"A",TXT="DRUG INTOLERANCE":"P",1:"U")
 S DIE="^GMR(120.8,",DA=GMRAPA,DR="17///^S X=MECH" D ^DIE
 S:$D(Y) GMRAOUT=1
 Q
HELP ; HELP FOR A/AR LOOKUP
 W !!?4,"Would you like to see a list of:",!?6,"1  Local Allergies (Food/Drug/Other)",!?6,"2  Drug Classes",!?6,"3  Drug Ingredients",!?6,"4  National Drugs",!?6,"5  Local Drugs"
 R !?4,"Select a number (1-5):",X:DTIME S:'$T X="^^" I "^^"[X S:X="^^"!(X=U) GMRAOUT=1 Q
 I X\1'=X!(X<1)!(X>5) W !?7,$C(7),"ANSWER WITH THE NUMBER (1-5) OF THE SELECTION FOR",!?7,"WHICH YOU WISH TO SEE MORE HELP." G HELP
 S DIC=$S(X=1:120.82,X=2:50.605,X=3:50.416,X=4:50.6,1:50) D HLPLK
 G HELP
HLPLK ; LOOKUP ON FILE IN DIC
 S DIC(0)="E",X="??" S:DIC=50.416 D="P" S:DIC=50.605 DIC("W")="W ?10,$P(^(0),U,2)",DIC(0)="SE",D="C" D ^DIC:DIC'=50.605&(DIC'=50.416),IX^DIC:DIC=50.605!(DIC=50.416)
 Q
DIC ; VALIDATE LOOKUP FOR A/AR
 S:$D(DTOUT) X="^^" I X="^^" S GMRAOUT=1 Q
 S:$D(DUOUT) Y=0 Q:+Y'>0
YNOK W !?3,X,"   OK" S %=1 D YN^DICN S:%=-1 GMRAOUT=1,Y=-1 S:%=2 Y=-1 I % W ! Q
 W !?5,$C(7),"ANSWER YES IF THIS IS THE CORRECT ALLERGY/ADVERSE REACTION,",!?5,"ELSE ANSWER NO."
 G YNOK
HEAD ; Header for reactions
 W @IOF
 W !,"Reactions: (cont.) "
 Q
