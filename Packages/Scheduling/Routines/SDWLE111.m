SDWLE111 ;IOFO BAY PINES/TEH - WAITING LIST-ENTER/EDIT - WAIT LIST TYPE/INSTUTITION ;20 Aug 2002
 ;;5.3;scheduling;**263,273,280**;AUG 13 1993
 ;
 ;
 ;******************************************************************
 ;                             CHANGE LOG
 ;                                               
 ;   DATE                        PATCH                   DESCRIPTION
 ;   ----                        -----                   -----------
 ;10/01/2002                                             263                                             Logical Order Change   
 ;12/02/2002                      273                    line EN2+19 add '/' 
 ;   
 ;      
 ;
 ;ASK WAIT LIST TYPE
 ;
EN ;
 S SDWLFLG=0
 I $D(SDWLTY) W !,"Wait List Type: ",$$EXTERNAL^DILFD(409.3,4,,SDWLTY) W "//  (No Editing)" S SDWLTYE=SDWLTY G EN2
 ;10/01/2002 - TEH
 G ENS:$D(SDWLOPT)
 G EN0:SDWLTEM
 S DIR(0)="SO^1:PCMM TEAM ASSIGMENT;2:PCMM POSITION ASSIGNMENT;3:SERVICE/SPECIALTY;4:SPECIFIC CLINIC"
 I SDWLCP5'="" S DIR(0)="SO^1:PCMM TEAM ASSIGMENT;2:SERVICE/SPECIALTY;3:SPECIFIC CLINIC" D 
 .S DIR("L",1)="      Select Wait List Type: ",DIR("L",2)="",DIR("L",3)="          1. PCMM TEAM ASSIGMENT"
 .S DIR("L",4)="             2. SERVICE/SPECIALTY",DIR("L",5)="             3. SPECIFIC CLINIC",SDWLFLG=1
 G EN0:SDWLFLG
ENS I $D(SDWLOPT),SDWLOPT S DIR(0)="SO^;1:SERVICE/SPECIALTY;2:SPECIFIC CLINIC" D 
 .S DIR("L",1)="      Select Wait List Type: ",DIR("L",2)=""
 .S DIR("L",3)="             1. SERVICE/SPECIALTY",DIR("L")="             2. SPECIFIC CLINIC",SDWLFLG=1
 G EN1:SDWLFLG
EN0 I SDWLTEM,SDWLPOS D 
 .S DIR(0)="SO^;1:SERVICE/SPECIALTY;2:SPECIFIC CLINIC" D 
 .S DIR("L",1)="      Select Wait List Type: ",DIR("L",2)=""
 .S DIR("L",3)="             1. SERVICE/SPECIALTY",DIR("L")="             2. SPECIFIC CLINIC",SDWLFLG=1
 G EN1:SDWLFLG
 I SDWLWTE D 
 .S DIR(0)="SO^;1:SERVICE/SPECIALTY;2:SPECIFIC CLINIC" D 
 .S DIR("L",1)="      Select Wait List Type: ",DIR("L",2)=""
 .S DIR("L",3)="             1. SERVICE/SPECIALTY",DIR("L")="             2. SPECIFIC CLINIC",SDWLFLG=1
 G EN1:SDWLFLG
 I 'SDWLTEM D 
 .S DIR(0)="SO^1:PCMM TEAM ASSIGNMENT;2:SERVICE/SPECIALTY;3:SPECIFIC CLINIC" D 
 .S DIR("L",1)="      Select Wait List Type: ",DIR("L",2)=""
 .S DIR("L",2)=""
 .S DIR("L",3)="             1. PCMM TEAM ASSIGNMENT"
 .S DIR("L",4)="             2. SERVICE/SPECIALTY"
 .S DIR("L")="             3. SPECIFIC CLINIC",SDWLFLG=1
 G EN1:SDWLFLG
 I SDWLTEM D
 .S DIR(0)="SO^1:PCMM POSITION ASSIGNMENT;2:SERVICE/SPECIALTY;3:SPECIFIC CLINIC"
 .S DIR("L",1)="     Select Wait List Type: "
 .S DIR("L",2)=""
 .S DIR("L",3)="           1. PCMM POSITION ASSIGNMENT"
 .S DIR("L",4)="           2. SERVICE/SPECIALTY"
 .S DIR("L")="           3. SPECIFIC CLINIC",SDWLFLG=1
 G EN1:SDWLFLG
 S DIR("L",1)="     Select Wait List Type: "
 S DIR("L",2)=""
 S DIR("L",3)="           1. PCMM TEAM ASSIGMENT"
 S DIR("L",4)="           2. PCMM POSITION ASSIGNMENT"
 S DIR("L",5)="           3. SERVICE/SPECIALTY"
 S DIR("L")="           4. SPECIFIC CLINIC"
EN1 D ^DIR I X="" W " Required or '^' to Quit" G EN
 I $D(DUOUT) S SDWLERR=1 G END
 I 'SDWLTEM,'SDWLWTE S SDWLTYE=$S(Y=1:1,Y=2:3,Y=3:4)
 I SDWLPOS S SDWLTYE=$S(Y=1:1,Y=2:3,Y=3:4)
 I SDWLTEM S SDWLTYE=$S(Y=1:2,Y=2:3,Y=3:4)
 I SDWLPOS,SDWLTEM S SDWLTYE=$S(Y=1:3,Y=2:4)
 I SDWLWTE S SDWLTYE=$S(Y=1:3,Y=2:4)
 I $D(SDWLOPT),SDWLOPT S SDWLTYE=$S(Y=1:3,Y=2:4)
 S DIE="^SDWL(409.3,",DR="4///^S X=SDWLTYE" D ^DIE
 ;
EN2 ;ASK INSTITUTION (FILE 4)
 ;
 I SDWLTYE=2,$D(SDWLCPT),SDWLCPT S (SDWLINE,SDWLIN)=$P($G(^SCTM(404.51,+SDWLCPT,0)),U,7) G END
 I SDWLTYE=2,'SDWLCP3 S SDWLI=0 F  S SDWLI=$O(^SCTM(404.57,SDWLI)) Q:SDWLI<1  D
 .S SDWLL=+$P($G(^SCTM(404.57,SDWLI,0)),U,2),SDWLINL=+$P($G(^SCTM(404.51,+SDWLL,0)),U,7),SDWLINL(+SDWLINL)=""
 K DUOUT S SDWLERR=0 W !
 I $D(SDWLIN) D
 .S X=$S($D(SDWLIN):$$EXTERNAL^DILFD(409.32,.02,,SDWLIN),1:""),DIC(0)="Q",DIC=4,SDWLINE=SDWLIN D ^DIC D
 ..W !,"Select Institution: ",$P(Y,U,2)," //  (No Editing)" S SDWLERR=1
 I SDWLERR S SDWLERR=0 G END
 I SDWLTYE=1 S DIC("S")="I $D(^SCTM(404.51,""AINST"",+Y))"
 I SDWLTYE=2 S DIC("S")="I $D(SDWLINL(+Y))"
 I SDWLTYE=4 S DIC("S")="I $D(^SDWL(409.32,""ACT"",+Y))"
 I SDWLTYE=3 S DIC("S")="I $D(^SDWL(409.31,""E"",+Y))"
 S DIC("S")=DIC("S")_",$$GET1^DIQ(4,+Y_"","",11,""I"")=""N"",$$TF^XUAF4(+Y)"
 S DIC(0)="AEQNM",DIC="4",DIC("A")="Select Institution: " D ^DIC I Y<0,'$D(DUOUT) S SDWLERR=1 W "Required or '^' to Quit."
 I $D(DUOUT) S SDWLERR=1 Q
 G EN2:SDWLERR
 I Y>0 D 
 .K DIC,DIC("A"),DIC("S"),DIC(0),DIC("B") S (SDWLIN,SDWLINE)=+Y,DIE="^SDWL(409.3,"
 .I '$D(DUOUT),Y>0 S DR="2////^S X=SDWLIN",DIE="^SDWL(409.3,",DA=SDWLDA D ^DIE
 I $D(DUOUT) S SDWLERR=1
END Q
