XBDHDF1 ; IHS/ADC/GTH - CHECKS JUMP SYNTAX ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
STRIP ;
 KILL XBDHTC
 I $E(Y,$L(Y))=":" S Y=$E(Y,1,$L(Y)-1),XBDHTC=""
 S X=$L(Y,":"),Z=$S(X>1:$P(Y,":",X),1:Y),A=""
 I $D(XBDHTC) D CKF I Y'=-1 G EXIT
 D CKPT
 I Y'=-1 G EXIT
 I $D(XBDHTC) W "  ??",*7,*7,*13,$J("",IOM),*13
EXIT ;
 KILL XBDHTC,Z
 Q
 ;
CKF ;
 S X=Z,DIC(0)="",DIC="^DD(XBDHDFN,"
 D ^DIC
 KILL DIC
 I Y=-1 Q
 S X=^DD(XBDHDFN,+Y,0),X=$P(X,U,2)
 I X'["P" S Y=-1 Q
 S X=+$P(X,"P",2),DIC="^DIC(",DIC(0)=""
 D ^DIC
 KILL DIC
 I Y=-1 Q
 D J1
 Q
 ;
CKPT ;
 S DIC="^DIC(",DIC(0)="",X=Z
 D ^DIC
 KILL DIC
 I Y=-1 Q
 F X=0:0 S A="",X=$O(^DD(XBDHDFN,0,"PT",+Y,X)) Q:X=""  D JUMPQ I "Y^"[A Q
 I X="" S Y=-1 Q
 I A="^" Q
 D J1
 Q
 ; 
J1 ;
 S XBDHDPTH=XBDHDPTH_XBDHXX_$S($D(XBDHTC):"",1:":")_";"
 S XBDHLIFO=XBDHLIFO+1,^TMP("XBDH",$J,"STACK",XBDHLIFO)=+Y_U_$P(Y,U,2)_U_U_XBDHDPTH
 Q
 ;
JUMPQ ;
 I '$D(^DD(+Y,"IX",X)) Q
 W !,"   By '",Z,"' do you mean the ",$P(Y,U,2)," File",!?7,"pointing via its '",$P(^DD(+Y,X,0),U),"' Field?  YES// "
 R A:DTIME
 S:'$T A="^"
 S A=$E(A)
 Q
 ;
