SDWLE3 ;;IOFO BAY PINES/TEH - WAITING LIST-ENTER/EDIT;06/12/2002 ; 20 Aug 2002  2:10 PM
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
 ;ASK FOR SPECIFIC TEAM (404.51)
 K DIR,DIC,DR,DIE S DA=SDWLDA K SDWLTH,SDWLMAX
 I $D(SDWLST),'SDWLST K SDWLST
 S SDWLERR=0,SDWLY="Team",SDWLVAR=$S($D(SDWLST):SDWLST,1:0),SDWLSCR=""
 S (SDWLYN,SDWLTYE)=5,SDWLVBR="SDWLST"
EN1 W ! S SDWLS=SDWLY,SDWLX=$S(SDWLTYE=1:"T",SDWLTYE=2:"P",1:""),SDWLSX="     "_SDWLS
 S SDWLF="SCTM(404.51,"
 S SDWLA=0 F  S SDWLA=$O(^SCTM(404.58,"B",SDWLA)) Q:SDWLA=""  D
 .I $P($G(^SCTM(404.51,SDWLA,0)),U,7)'=SDWLIN Q
 .S SDWLB=0 F  S SDWLB=$O(^SCTM(404.58,"B",SDWLA,SDWLB)) Q:SDWLB=""  D
 ..S X=$G(^SCTM(404.58,SDWLB,0)) I $P(X,U,3)=0 S SDWLTH(SDWLA)=""
 ..S SDWLMAX=0,X=$$TEAMCNT^SCAPMCU1(SDWLA,DT),SDWLMAX(SDWLA)="" I X<$P($G(^SCTM(404.51,SDWLA,0)),U,8)!(X=$P($G(^SCTM(404.51,SDWLA,0)),U,8)) K SDWLMAX(SDWLA)
 .S SDWLSCR="I $P(^(0),U,7)=SDWLIN,'$D(SDWLTH(+Y)),$D(SDWLMAX(+Y))"
 D EN2 G END:$D(DUOUT)
 S DR=SDWLYN_"////^S X=SDWLVAR",DIE=409.3 D ^DIE S @SDWLVBR=SDWLVAR
 G END
EN2 ;-DIR READ
 K DIR,DR,DIE,DIC,DUOUT
 S DIR("S")=SDWLSCR
 I $D(SDWLVAR),SDWLVAR S DIR("B")=$$EXTERNAL^DILFD(409.3,SDWLYN,,SDWLVAR)
 S DIR(0)="PAO^"_SDWLF_":EMNZ",DIR("A")="Select "_SDWLY_": " D ^DIR I $D(DTOUT) S DUOUT=1
 I X["^" S DUOUT=1 Q
 I X="" W *7,"Required or '^' to quit." G EN2
 S DUOUT=$S(X=0:1,X="":1,X["^":1,$D(DTOUT):1,X="@":1,1:0) I 'DUOUT K DUOUT
 I X="@" W *7,"  No Deleting allowed." G EN2
 I $D(DUOUT) Q
 G EN2:Y<0 S SDWLVAR=+Y
 Q
END K SDWLA,SDWLMAX,SDWLTH,SDWLSCR,DIR,DIC,DIE,DR
 Q 
