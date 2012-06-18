ACHSDNC ; IHS/ITSC/PMF - CANCEL DENIAL ;   [ 10/31/2003  11:43 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**6**;JUNE 11, 2001
 ;ACHS*3.1*3  allow reversal as well as cancel  WHOLE ROUTINE IS NEW
 ;ACHS*3.1*6 IHS/SET/JVK Added section to add office notes
 ;
 D VIDEO^ACHS
LOOK ; --- Select the Denial
 W !!
 ;
 K DFN S ACHDOCT="denial"
 D ^ACHSDLK
 I $D(ACHDLKER) D RTRN^ACHS Q
 S DA=ACHSA
 ;
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="Y" W !!,*7,*7,IORVON,"THIS DENIAL HAS ALREADY BEEN CANCELLED",IORVOFF,!! G LOOK
 ;
 I $P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U,8)="R" W !!,*7,*7,IORVON,"THIS DENIAL HAS ALREADY BEEN REVERSED",IORVOFF,!! G LOOK
 ;
WHICH ;
 W !!,"Cancel or Reverse this denial? (C/R):  "
 D READ^ACHSFU
 ;
 I $G(ACHSQUIT)=1 K ACHSQUIT Q
 ;
 N STATUS
 S STATUS=Y I STATUS="C" S STATUS="Y"
 ;
SURE ;
 N MSG S MSG="Are You Sure You Want To "_$S(STATUS="Y":"Cancel",1:"Reverse")_" This Denial?"
 W !!,*7,*7,IORVON,MSG,!!,"Once This Happens It Can Never Be Applied Again",IORVOFF,!!
 S %=$$DIR^ACHS("Y",MSG_" (Y/N)","NO","Once This Happens It Can Never Be Applied Again","",2)
 ;
 I ('%)!$D(DUOUT) W !!,*7,*7,"DENIAL LEFT UNCHANGED",!! Q
 ;
 I $D(DTOUT) D RTRN^ACHS Q
 ;
SET ;
 W !!,IORVON,"Now ",$S(STATUS="Y":"Cancelling",1:"Reversing")," Denial Number ",$P($G(^ACHSDEN(DUZ(2),"D",DA,0)),U),IORVOFF
 I '$$DIE^ACHSDN("8///"_STATUS) K ACHSA,DIC,DFN Q
 W !!,"Completed",!!
 ;IHS/SET/JVK ACHS*3.1*6 ADD NEXT TWO LINES
 W !,"Enter Notes",!
 I '$$DIE^ACHSDN(900,2) Q
 Q
