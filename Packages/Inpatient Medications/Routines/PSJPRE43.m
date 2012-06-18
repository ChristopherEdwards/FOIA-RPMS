PSJPRE43 ; B'ham ISC/CML3 - MOVE PICK LIST PARAMETERS ;9/4/91  18:30
 ;;3.2;;**28**
 ;
 W @IOF,!?18,"MOVE PICK LIST PARAMETERS TO WARD GROUP FILE"
 W !!?2,"This option is designed to allow you to seed the Inpatient Ward Group file",!,"with the PICK LIST data from the Inpatient Site Parameter file.  After the ward",!,"group list is built, select the Inpatient site from which you want to"
 W " move the",!,"pick list data.  Then select the ward group(s) which you want to seed with the",!,"pick list data.  The pick list data from the selected Inpatient site will then",!,"be moved to each ward group selected."
 W !!,"BUILDING the ward group list..." D BWL
 I 'PSG F  W !!,"The data move has already been completed.",!,"Would you like to edit any of the entries in the Ward Group file" S %=0 D YN^DICN Q:%  W !!?2,"Enter 'YES' to edit the Ward Parameter file.  Enter 'NO' to exit this option."
 I 'PSG G:%=1 ENWE G DONE
 ;
IS ;
 K DIC S DIC="^PS(59.4,",DIC(0)="AEMQZ",DIC("S")="I $G(^(5))]""""" W ! D ^DIC I Y'>0 G DONE
 S IS=+Y,ISND=$G(^PS(59.4,IS,5))
 ;
 S DIR(0)="LAO^1:"_PSG,DIR("A")="Select WARD GROUP(S) (1-"_PSG_"): ",DIR("?")="^D WH^PSJPRE43" W ! D ^DIR G:'Y IS
 W !!,"Working..."
 F Q1=0:1 Q:'$D(Y(Q1))  F Q2=1:1 S X=$P(Y(Q1),",",Q2) Q:'X  S ^PS(57.5,+PSG(X),5)=ISND
 D BWL G:PSG IS F  W !!,"The data move has been completed to all wards.",!,"Would you like to edit any of the ward groups" S %=0 D YN^DICN Q:%  W !!?2,"Enter 'YES' to edit the Ward Parameter file.  Enter 'NO' to exit this option."
 G:%=1 ENWE G DONE
 W !,"Working..."
 ;
BWL ; build ward list
 K PSG S (PSG,Q)=0
 F  S Q=$O(^PS(57.5,Q)) Q:'Q  S X=$G(^(Q,0)) I $P(X,"^",2)="P",'$D(^(5)) S PSG=PSG+1,PSG(PSG)=Q_"^"_$P(X,"^")
 Q
 ;
WH ;
 W !!?2,"Select the ward group(s) to which you want to move the pick list data from",!,"the selected Inpatient site.  Choose, by number, from the following ward",!,"groups:"
 S Q=0 F  S Q=Q+1 Q:Q>PSG  W !,$J(Q,3),". ",$P(PSG(Q),"^",2) S Q=Q+1 Q:Q>PSG  W ?26,$J(Q,3),". ",$P(PSG(Q),"^",2) S Q=Q+1 Q:Q>PSG  W ?52,$J(Q,3),". ",$P(PSG(Q),"^",2)
 Q
 ;
ENWE ;
 F  S DIC="^PS(57.5,",DIC(0)="AEMQ",DIC("S")="I $P($G(^(0)),U,2)=""P""" W ! D ^DIC Q:Y'>0  S DA=+Y,DIE=DIC,DR="5.02;5.03;S:X Y=""@3"";5.01;@3;5.04;S:X Y=""@5"";5.05;@5;S %=$G(^PS(57.5,DA,5)) S:$S($P(%,U,4):1,1:'$P(%,U,5)) Y="""";5.06" W ! D ^DIE
 ;
DONE ;
 D ENKV^PSGSETU K IS,ISND,PSG,Q1,Q2 Q
