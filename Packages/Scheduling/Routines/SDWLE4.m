SDWLE4 ;;IOFO BAY PINES/TEH - WAITING LIST-ENTER/EDIT;06/12/2002 ; 20 Aug 2002  2:10 PM
 ;;5.3;scheduling;**263**;AUG 13 1993
 ;
 ;
 ;******************************************************************
 ;                             CHANGE LOG
 ;                                               
 ;   DATE                        PATCH                   DESCRIPTION
 ;   ----                        -----                   -----------  
 ;   
 ;CLINIC (409.32)
 ;
EN K DIR,DIC,DIE,DR
 I $D(SDWLSC) S X=$$EXTERNAL^DILFD(409.3,8,,SDWLSC),DIC("B")=$S($D(SDWLSC):X,1:"") I DIC("B")="" K DIC("B")
 I $D(^SDWL(409.3,SDWLDA,0)),$P(^(0),U,9) S DIC("B")=$$EXTERNAL^DILFD(409.3,8,,$P(^(0),U,9))
 S SDWLERR=0
 K X,Y
 S DIC(0)="QEMNZA",DIC("A")="Select Clinic: ",DIC("S")="I $P(^SDWL(409.32,+Y,0),U,6)=SDWLINE,'$P(^(0),U,4),$P(^(0),U,2)'=""""",DIC=409.32 D ^DIC
 I X="^" S DUOUT=1 G END
 I X="" W *7," Required" G EN
 I Y<0 S DUOUT=1 G END
 I $D(DTOUT) S DUOUT=1
 I $D(SDWLSC),Y<0 G END
 I Y<0 W " Required or ""^"" to Quit" G EN
EN1 S SDWLSC=+Y,DA=SDWLDA,DIE="^SDWL(409.3,",DR="8////^S X=SDWLSC" D ^DIE
 K DIR,DIC,DIE,DR
END Q
