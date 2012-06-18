SDLTE ;ALB/LDB - ENTER/EDIT SCHEDULING LETTERS ; [ 09/13/2001  2:28 PM ]
 ;;5.3;Scheduling;;Aug 13, 1993
 ;IHS/ANMC/LJF  8/18/2000 added edit of parents greeting field
 ;                        added screen for inactive letter types
 ;
RD ;
 S DIC("S")="I $P(^VA(407.6,+Y,0),U,3)="""""  ;IHS/ANMC/LJF 8/18/2000
 S DIC=407.6,DIC("A")="SELECT TYPE OF LETTER: ",DIC(0)="AEQMZ" D ^DIC G:+Y'>0 EXIT S T=+Y S (DIC,DLAYGO)=407.5,DIC(0)="AQELM",DIC("A")="SELECT LETTER: ",DIC("S")="I $P(^(0),""^"",2)="_""""_$P(^VA(407.6,+T,0),"^")_""""
 ;S DIC("DR")="1////"_$P(^VA(407.6,+T,0),"^") D ^DIC G:Y'>0 EXIT S SDLT=+Y,DA=SDLT,DIE=407.5,DR=".01;1;2;3",DR(2,407.52)=".01",DR(2,407.53)=".01" D ^DIE G:$D(Y) EXIT D EXIT W !! G RD  ;IHS/ANMC/LJF 8/18/2000
 S DIC("DR")="1////"_$P(^VA(407.6,+T,0),"^") D ^DIC G:Y'>0 EXIT S SDLT=+Y,DA=SDLT,DIE=407.5,DR=".01;9999999.01;1;2;3",DR(2,407.52)=".01",DR(2,407.53)=".01" D ^DIE G:$D(Y) EXIT D EXIT W !! G RD  ;IHS/ANMC/LJF 8/18/2000
EXIT K DA,DIC,DIE,DR,SDLT,T,X,Y Q
