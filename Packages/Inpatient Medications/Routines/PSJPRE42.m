PSJPRE42 ; B'ham ISC/CML3 - MOVE SITE PARAMETERS ;2/18/92  16:56
 ;;3.2;;**28**
 ;
 W @IOF,!?18,"MOVE SITE PARAMETERS TO WARD PARAMETER FILE"
 W !!?2,"This option is designed to allow you to seed the Inpatient Ward Parameter file",!,"with data from the Inpatient Site Parameter file.  After the ward list is built,",!,"select the Inpatient site from which you want to move data.  Then"
 W " select the",!,"ward(s) which you want to seed with the site data.  The data from the selected",!,"Inpatient site will then be moved to each ward selected.",!!,"BUILDING the ward list..."
 D BWL
 I 'PSG F  W !!,"The data move has already been completed.",!,"Would you like to edit any of the entries in the Ward Parameter file" S %=0 D YN^DICN Q:%  W !!?2,"Enter 'YES' to edit the Ward Parameter file.  Enter 'NO' to exit this option."
 I 'PSG G:%=1 ENWE G DONE
 ;
IS ;
 S DIC="^PS(59.4,",DIC(0)="AEMQZ" W ! D ^DIC I Y'>0 G DONE
 S IS=+Y,ISND=Y(0) F Q=1,2,5,6,10,12,13,14,15,16,17,18,19,20,21,22,23,25,26,27,28,29,30 S $P(ISND,"^",Q)=""
 ;
 S DIR(0)="LAO^1:"_PSG,DIR("A")="Select WARD(S) (1-"_PSG_"): ",DIR("?")="^D WH^PSJPRE42" W ! D ^DIR G:'Y IS
 W !!,"Working..." F Q1=0:1 Q:'$D(Y(Q1))  F Q2=1:1 S X=$P(Y(Q1),",",Q2) Q:'X  D WS
 D BWL G:PSG IS F  W !!,"The data move has been completed to all wards.",!,"Would you like to edit any of the wards" S %=0 D YN^DICN Q:%  W !!?2,"Enter 'YES' to edit the Ward Parameter file.  Enter 'NO' to exit this option."
 G:%=1 ENWE G DONE
 ;
BWL ; build ward list
 K PSG S (PSG,Q)=0
 F  S Q=$O(^DIC(42,Q)) Q:'Q  I '$D(^PS(59.6,"B",Q)) S X=$G(^DIC(42,Q,0)),PSG=PSG+1,PSG(PSG)=Q_"^"_$P(X,"^")
 Q
 ;
WH ;
 W !!?2,"Select the ward(s) to which you want to move the data from the selected",!,"Inpatient site.  Choose, by number, from the following wards:"
 S Q=0 F  S Q=Q+1 Q:Q>PSG  W !,$J(Q,3),". ",$P(PSG(Q),"^",2) S Q=Q+1 Q:Q>PSG  W ?26,$J(Q,3),". ",$P(PSG(Q),"^",2) S Q=Q+1 Q:Q>PSG  W ?52,$J(Q,3),". ",$P(PSG(Q),"^",2)
 Q
 ;
WS ;
 N Y S X=+PSG(X),$P(ISND,"^")=X,DIC="^PS(59.6,",DIC(0)="L",DLAYGO=59.6 W "." D ^DIC W "." I Y>0 S ^PS(59.6,+Y,0)=ISND,DA=+Y,DIK=DIC D IX1^DIK
 Q
 ;
ENWE ;
 K DA,DIC,DIE,DR F  S DIC="^PS(59.6,",DIC(0)="AEMQ" W ! D ^DIC Q:Y'>0  S DA=+Y,DIE=DIC,DR=".03;.04;.07;.08;.15;.12;.13;.16;.14;.11;.24" D ^DIE
 ;
DONE ;
 D ENKV^PSGSETU K IS,ISND,PSG,Q1,Q2 Q
 ;
ENDL ; device look-up
 N DA,DIC,DIE,DIX,DO,DR
 S DIC="^%ZIS(1,",DIC(0)="EIMZ" D DO^DIC1,^DIC I Y'>0 K X Q
 S X=Y(0,0) Q
 ;
ENDH(X) ; device help
 N DA,DIC,DIE,DO,DR,DZ
 S DIC="^%ZIS(1,",DIC(0)="EIM" D DO^DIC1,^DIC Q
