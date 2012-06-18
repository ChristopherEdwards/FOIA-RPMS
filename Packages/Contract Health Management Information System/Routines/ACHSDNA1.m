ACHSDNA1 ; IHS/ITSC/JVK -EDIT THE STATUS OF A DENIAL AND APPEAL STATUS;  [ 10/31/2003  11:42 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,6**;JUNE 11,2001
 ;;ACHS*3.1*6 edit reversal as well as cancel ROUTINE IS A COPY OF ACHSDNC with enhanced features
 ;
 D VIDEO^ACHS
LOOK ; --- Select the Denial
 K DIR
 W !!
 ;
 K DFN S ACHDOCT="denial"
 D ^ACHSDLK
 I $D(ACHDLKER) D RTRN^ACHS Q
 S DA=ACHSA
 ;
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="Y" W !!,*7,*7,IORVON,"THE STATUS OF THIS DENIAL IS CANCELLED",IORVOFF,!! G EDIT
 ;
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="R" W !!,*7,*7,IORVON,"THE STATUS OF THIS DENIAL IS REVERSED",IORVOFF,!! G EDIT
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="" W !!,*7,*7,IORVON,"THE STATUS OF THIS DENIAL IS ACTIVE",IORVOFF,!! G EDIT
 ;
WHICH ;
 W !!,"Cancel,Reverse or Activate this denial? (C/R/A):  "
 D READ^ACHSFU
 ;
 I $G(ACHSQUIT)=1 K ACHSQUIT Q
 ;
 I $D(DTOUT)!$D(DUOUT) D RTRN^ACHS Q
 I Y'="A",Y'="C",Y'="R" K Y G WHICH
 N STATUS
 ;S STATUS=Y I STATUS="C" S STATUS="Y"
 S STATUS=$S(Y="A":"A",Y="C":"Y",Y="R":"R",1:"")
 ;
SURE ;
 ;IHS/SET/JVK ACHS*3.1*6
 N MSG S MSG="Are You Sure You Want To "_$S(STATUS="Y":"Cancel",STATUS="R":"Reverse",STATUS="A":"Activate")_" This Denial?"
 W !!,*7,*7,IORVON,MSG,!!,"The status change will be recorded",IORVOFF,!!
 S %=$$DIR^ACHS("Y",MSG_" (Y/N)","NO","This entry will not be recorded","",2)
 ;
 I ('%)!$D(DUOUT) W !!,*7,*7,"DENIAL LEFT UNCHANGED",!! D APPEAL
 ;
 I $D(DTOUT) D RTRN^ACHS Q
 ;
SET ;
 W !!,IORVON,"Now ",$S(STATUS="Y":"Cancelling",STATUS="R":"Reversing",STATUS="A":"Activate")_" Denial Number ",$P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U),IORVOFF
 I STATUS="A" S STATUS="@"
 I '$$DIE^ACHSDN("8///"_STATUS) K ACHSA,DIC,DFN Q
 W !,"Completed"
 W !,"Enter Notes",!
 I '$$DIE^ACHSDN(900,2) Q
APPEAL ;
 K DIR
 S DIR(0)="Y",DIR("A")="DO YOU WANT TO EDIT THE APPEAL STATUS",DIR("B")="NO"
 W !!
 D ^DIR
 ;ITSC-SET-JVK 5/27/03 ACHS*3.1*6
 ;I Y=1,'$$DIE^ACHSDN(430,3)
 I Y=1,'$$DIE^ACHSDN(431)
 E  K DIR G LOOK
EDIT ;
 K DIR
 S DIR(0)="Y",DIR("A")="DO YOU WANT TO EDIT THE DENIAL STATUS",DIR("B")="NO"
 S DIR("?")="This will change the denial status only. The appeal status must be changed at the ""Do you want to edit the APPEAL STATUS PROMPT"" that follows. If you know the denial status is reversed you must edit the appeal status."
 W !!
 D ^DIR
 I Y K DIR G WHICH Q
 I 'Y G APPEAL
 Q
