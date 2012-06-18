SDWLE2 ;;IOFO BAY PINES/TEH - WAITING LIST-ENTER/EDIT;06/12/2002 ; 20 Aug 2002  2:10 PM
 ;;5.3;scheduling;**263**;AUG 13 1993
 ;
 ;
 ;******************************************************************
 ;                             CHANGE LOG
 ;                                               
 ;   DATE                        PATCH                   DESCRIPTION
 ;   ----                        -----                   -----------
 ;   
 ;   
 ;   
 ;      
 ;Service/Specialty sub-routine
 ;
EN K DIR,DIC,DR I $D(SDWLSS) S X=$$EXTERNAL^DILFD(409.3,7,,SDWLSS)
 S SDWLERR=0 I $D(SDWLSS) S DIC("B")=$S($D(SDWLSS):X,1:"") I DIC("B")="" K DIC("B")
 S DIC(0)="AEQ",DIC=409.31,DIC("A")="Select Service/Specialty: ",DIC("S")="I $D(^SDWL(409.31,""E"",SDWLINE,+Y))" D ^DIC
 I X["^" S DUOUT=1 G END
 I Y<0 W *7," Required" G EN
 S SDWLSSX=+Y,DIE="^SDWL(409.3,",DR="7///^S X=SDWLSSX" D ^DIE
 K DIR,DIC,DIE,DR
END Q
