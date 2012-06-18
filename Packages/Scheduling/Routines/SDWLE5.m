SDWLE5 ;;IOFO BAY PINES/TEH - WAITING LIST-ENTER/EDIT;06/12/2002 ; 20 Aug 2002  2:10 PM
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
EN ;
 ;POSITION (404.57)
 K DIR,DIC,DR,DIE,SDWLSCR S DA=SDWLDA K SDWLTH,SDWLMAX
 S SDWLERR=0,SDWLY="Position",SDWLVAR=$S($D(SDWLSP):SDWLSP,1:0)
 S (SDWLYN,SDWLTYE)=6,SDWLVBR="SDWLSP",SDWLF=404.57
 S SDWLMAX=$P(^SCTM(404.57,0),U,3)
 I $D(^SDWL(409.3,SDWLDA,0)),$P(^(0),U,3)="" D
 .S DIE="^SDWL(409.3,",DR="2////^S X=SDWLIN",DA=SDWLDA D ^DIE
 S SDWLA=0 F  S SDWLA=$O(^SCTM(404.57,SDWLA)) Q:SDWLA<1  D
 .S SDWLMAX=0,X=$$PCPOSCNT^SCAPMCU1(SDWLA,DT,0),SDWLMAX(SDWLA)="" I $P(^SCTM(404.57,SDWLA,0),U,8)>X!($P(^SCTM(404.57,SDWLA,0),U,8)=X) K SDWLMAX(SDWLA)
 .S X=$G(^SCTM(404.57,SDWLA,0)) I +$P(X,U,4)=0 S SDWLTH(SDWLA)="" K SDWLMAX(SDWLA)
 .I '$D(SDWLSCR) S SDWLN=0
 .S SDWLSCR="I $P(^SCTM(404.57,+Y,0),U,2)=SDWLCPT,'$D(SDWLTH(+Y)),$D(SDWLMAX(+Y))"
 .I '$O(SDWLMAX(0)) W !,"No Position for this Team meets Wait List Criteria" S SDWLERR=1,DUOUT=1
 G END:SDWLERR
EN0 W ! D EN1
 I $D(DUOUT),SDWLVAR G END
 S DR=SDWLYN_"////^S X=SDWLVAR",DIE=409.3 D ^DIE S @SDWLVBR=SDWLVAR G END
 Q
EN1 ;;-DIR READ
 K DIR,DR,DIE,DIC,DUOUT
 S DIR("S")=SDWLSCR
 I $D(SDWLVAR),SDWLVAR S DIR("B")=$$EXTERNAL^DILFD(409.3,SDWLYN,,SDWLVAR)
 S DIR(0)="PAO^"_SDWLF_":EMNZ",DIR("A")="Select "_SDWLY_": " D ^DIR I $D(DTOUT) S DUOUT=1
 I X["^" S DUOUT=1 Q
 I X="@" W *7," ??" G EN1
 I X="" W *7,"Required or '^' to quit." G EN1
 I $D(SDWLVAR),SDWLVAR S X=SDWLVAR,Y=SDWLVAR_"^"_X
 S DUOUT=$S(X=0:1,X="":1,X["^":1,$D(DTOUT):1,X="@":1,1:0) I 'DUOUT K DUOUT
 I $D(DUOUT) Q
 G EN1:Y<0 S SDWLVAR=+Y
 Q
END K SDWLA,SDWLMAX,SDWLTH,SDWLSCR,DIR,DIC,DIE,DR
 Q 
