VAUTOMA ;ALB/MLI - GENERIC ONE, MANY, ALL ROUTINE ; 15 APRIL 88 [ 10/19/2000  10:31 AM ]
 ;;5.3;Registration;**111,1010**;Aug 13, 1993
 ;IHS/ANMC/LJF  8/17/2000 added inactivation info to clinic choice list
 ;             10/19/2000 removed N from DIC(0) so ?? in alpha order
 ;cmi/anch/maw 05/15/2009 added code to pass in div name for DIC("B") when selecting division
 ;
 ;;MAS VERSION 5.1;
DIVISION ;-- cmi/maw PATCH 1010 modified to get division name
 N VADIV,VADIVNM,VADICA
 S VADIV=$$DIV^BSDU()
 I $G(VADIV) S VADIVNM=$$DIVNM^BSDU(VADIV)
 S VAUTVB="VAUTD",DIC="^DG(40.8,",VAUTNI=2,VAUTSTR="division",VAUTNALL=1,DIC("A")=$G(VADIVNM) G FIRST
CLINIC ;S DIC="^SC(",DIC("S")="I $P(^(0),U,3)=""C""&'$G(^(""OOS""))&$S(VAUTD:1,$D(VAUTD(+$P(^(0),U,15))):1,'+$P(^(0),U,15)&$D(VAUTD(+$O(^DG(40.8,0)))):1,1:0)",VAUTSTR="clinic",VAUTVB="VAUTC" G FIRST ;IHS/ANMC/LJF 8/17/2000
 S DIC="^SC(",DIC("S")="I $P(^(0),U,3)=""C""&'$G(^(""OOS""))&$S(VAUTD:1,$D(VAUTD(+$P(^(0),U,15))):1,'+$P(^(0),U,15)&$D(VAUTD(+$O(^DG(40.8,0)))):1,1:0)",VAUTSTR="clinic",VAUTVB="VAUTC"  ;IHS/ANMC/LJF 8/17/2000
 S DIC("W")=$$INACTMSG^BSDU  ;IHS/ANMC/LJF 8/17/2000 added this line
 G FIRST  ;IHS/ANMC/LJF 8/17/2000
 ;  DIC("S") modified in CLINIC call, to exclude Occasion of Service locations.  abr - 11/25/96
 ;
PATIENT S DIC="^DPT(",VAUTSTR="patient",VAUTVB="VAUTN" G FIRST
WARD S DIC="^DIC(42,",VAUTSTR="ward",VAUTVB="VAUTW",DIC("S")="I $S(VAUTD:1,$D(VAUTD(+$P(^(0),U,11))):1,'+$P(^(0),U,11)&$D(VAUTD(^DG(40.8,+$O(^DG(40.8,0)),0))):1,1:0)" G FIRST
FIRST S DIC(0)="EQMNZ",DIC("A")="Select "_VAUTSTR_": " K @VAUTVB S (@VAUTVB,Y)=0
 S DIC(0)="EQMZ"  ;IHS/ANMC/LJF 10/19/2000
REDO ;cmi/maw 5/15/5009 added for default of division logged into
 N VADICA S VADICA=$S($G(VADIVNM)]"":VADIVNM_"// ",'$D(VAUTNALL):"ALL// ",1:"") W !,DIC("A")_VADICA R X:DTIME G ERR:(X="^")!'$T D:X["?" QQ S X=$S(X=""&($G(VADIVNM)]""):VADIVNM,1:X) I X="" G:$D(VAUTNALL) ERR S @VAUTVB=1 G QUIT
 ;W !,DIC("A") W:'$D(VAUTNALL) "ALL// " R X:DTIME G ERR:(X="^")!'$T D:X["?" QQ I X="" G:$D(VAUTNALL) ERR S @VAUTVB=1 G QUIT
 S DIC("A")="Select another "_VAUTSTR_": " D ^DIC G:Y'>0 FIRST D SET
 F VAI=1:0:19 W !,DIC("A") R X:DTIME G ERR:(X="^")!'$T K Y Q:X=""  D QQ:X["?" S:$E(X)="-" VAUTX=X,X=$E(VAUTX,2,999) D ^DIC I Y>0 D SET G:VAX REDO S:'VAERR VAI=VAI+1
 G QUIT
SET S VAX=0 I $D(VAUTX) S J=$S(VAUTNI=2:+Y,1:$P(Y(0),"^")) K VAUTX S VAERR=$S($D(@VAUTVB@(J)):0,1:1) W $S('VAERR:"...removed from list...",1:"...not on list...can't remove") Q:VAERR  S VAI=VAI-1 K @VAUTVB@(J) S:$O(@VAUTVB@(0))']"" VAX=1 Q
 S VAERR=0 I $S($D(@VAUTVB@($P(Y(0),U))):1,$D(@VAUTVB@(+Y)):1,1:0) W !?3,*7,"You have already selected that ",VAUTSTR,".  Try again." S VAERR=1
 I VAUTNI=1 S @VAUTVB@($P(Y(0),U))=+Y Q
 I VAUTNI=3 S @VAUTVB@($P(Y(0,0),U))=+Y Q
 S @VAUTVB@(+Y)=$P(Y(0),U) Q
QQ W !,"ENTER:" W:($D(@(VAUTVB))=1&'$D(VAUTNALL)) !?5,"- Return for all ",VAUTSTR,"s, or" W !?5,"- A ",VAUTSTR," and return when all ",VAUTSTR,"s have been selected--limit 20"
 W !?5,"Imprecise selections will yield an additional prompt."
 W !?5,"(e.g. When a user enters 'A', all items beginning with 'A' are displayed.)"
 I $O(@VAUTVB@(0))]"" W !?5,"- An entry preceeded by a minus [-] sign to remove entry from list."
 I $O(@VAUTVB@(0))]"" W !,"NOTE, you have already selected:" S VAJ=0 F VAJ1=0:0 S VAJ=$O(@VAUTVB@(VAJ)) Q:VAJ=""  W !?8,$S(VAUTNI=1:VAJ,1:@VAUTVB@(VAJ))
 Q
ERR S Y=-1
QUIT S:'$D(Y) Y=1 K DIC,J,VAERR,VAI,VAJ,VAJ1,VAX,VAUTNALL,VAUTNI,VAUTSTR,VAUTVB,X Q
