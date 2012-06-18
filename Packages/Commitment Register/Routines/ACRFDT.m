ACRFDT ;IHS/OIRM/DSD/THL,AEF - ARMS VENDOR DISCOUNT TERMS;  [ 05/11/2005  10:23 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**16,17**;MAY 15, 2001
 ;;
 ;UTILITY TO EDIT VENDOR DISCOUNT TERMS
 D VENDOR
 Q:'$G(ACRVDA)
DT ;EP;DISCOUNT TERMS
 N J,X,Y,Z,ACRTYPE,ACRQUIT
 F  D DT1 Q:$D(ACRQUIT)!$D(ACROUT)
 K ACRQUIT
 Q
DT1 I '$O(^ACRDT("B",ACRVDA,0)) D  Q:$D(ACRQUIT)!$D(ACROUT)
 .W !!,"There are no DISCOUNT TERMS on record for ",$P($G(^AUTTVNDR(+$G(ACRVDA),0)),U)
 .W !,"Enter applicable DISCOUNT TERMS below."
 .D DTADD
 D DTH
 ;S DIR(0)="SO^1:Edit Discount Terms;2:Add Discount Terms;3:Delete Discount Terms"  ;ACR*2.1*16.06 IM15505
 ;S:'$G(ACRDOCDA) DIR(0)=DIR(0)_";4:Select Discount Terms for this Payment"  ;ACR*2.1*16.06 IM15505
 S DIR(0)="SO^1:Edit Discount Terms"                          ;ACR*2.1*16.06 IM15505
 S DIR(0)=DIR(0)_";2:Add Discount Terms"                      ;ACR*2.1*16.06 IM15505
 S DIR(0)=DIR(0)_";3:Delete Discount Terms"                   ;ACR*2.1*16.06 IM15505
 S DIR(0)=DIR(0)_";4:Select Discount Terms for this Payment"  ;ACR*2.1*16.06 IM15505
 S DIR("A")="Which one"
 D DIR^ACRFDIC
 I Y=1 D DTEDIT Q
 I Y=2 D DTADD Q
 I Y=3 D DTDEL Q
 I Y=4 D DTSEL1 Q
 Q
DTH W @IOF
DTH1 ;EP;
 K X,J
 W !?10,"Discount Terms for"
 W !?10,@ACRON,$P(^AUTTVNDR(ACRVDA,0),U),@ACROF
 W !!?10,"NO.",?15,"DAYS",?21,"PERCENT"
 W !?10,"---",?15,"----",?21,"-------"
 D DTH2
 S (J,X)=0
 F  S X=$O(J(X)) Q:'X  D
 .S J=J+1
 .S X(J)=J(X)
 .S Y=$P(J(X),U,2)
 .W !?10,J,?15,X,?21,Y
 W !?10,"---",?15,"----",?21,"-------"
 Q
DTH2 ;EP;SET ARRAY OF VENDOR'S DISCOUNT TERMS
 S J=0
 F  S J=$O(^ACRDT("B",ACRVDA,J)) Q:'J  D
 .S Y=^ACRDT(J,"DT")
 .Q:'+Y
 .S J(+Y)=J_U_$P(Y,U,2)
 S (J,X)=0
 F  S X=$O(J(X)) Q:'X  D
 .S J=J+1
 .S X(J)=J(X)
 Q
DTSEL ;EP;SELECT TERMS APPLICABLE TO THIS PAYMENT
 Q:'$O(^ACRDT("B",ACRVDA,0))
 D DTH1
DTSEL1 ;EP;
 N ACRTMP        ;ACR*2.1*16.06 IM15505
 S:'$D(ACRTYPE) ACRTYPE="SELECT"
 S DIR(0)="NO^1:"_J
 S DIR("A",1)="Which discount term do you want"
 W !
 D DIR^ACRFDIC
 Q:$D(ACROUT)                                ;ACR*2.1*16.06 IM15505
 I '$G(X(+Y)) S ACRQUIT="" Q
 S ACRDTDA=+X(Y)
 S ACRDTDA=$G(^ACRDT(ACRDTDA,"DT"))          ;ACR*2.1*16.06 IM15505
 S ACRT=1                                    ;ACR*2.1*16.06 IM15505
 W !!?10,"Discount has been calculated "     ;ACR*2.1*16.06 IM15505
 D PAUSE^ACRFWARN                            ;ACR*2.1*16.06 IM15505
 Q
DTEDIT ;EDIT DISCOUNT TERMS
 S DIR("A")="to EDIT"
 S ACRTYPE="EDIT"
 D DTSEL1
 I '$G(ACRDTDA) K ACRQUIT Q
 ;S DA=ACRDTDA                                ;ACR*2.1*17.08 IM17313
 S DA=+ACRDTDA                                ;ACR*2.1*17.08 IM17313
 S DIE="^ACRDT("
 S DR="1T;2T"
 W !
 D DIE^ACRFDIC
 Q
DTADD ;ADD DISCOUNT TERMS
 S DIR(0)="NOA^1:99"
 S DIR("A")="Number of days for discount: "
 W !
 D DIR^ACRFDIC
 I Y<1 K ACRQUIT Q
 S ACRDAYS=Y
 I $D(^ACRDT("AC",ACRVDA,ACRDAYS)) S ACRJ=$O(^(ACRDAYS,0)) I ACRJ D DTEDIT Q
 S DIR(0)="NOA^1:99"
 S DIR("A")="Percent of discount........: "
 D DIR^ACRFDIC
 Q:Y<1
 S ACRPCNT=Y
 S X=ACRVDA
 S DIC="^ACRDT("
 S DIC(0)="L"
 S DIC("DR")="1////"_ACRDAYS_";2////"_ACRPCNT
 W !
 D FILE^ACRFDIC
 K ACRDAYS,ACRPCNT
 Q
DTDEL ;DELETE DISCOUNT TERMS
 S DIR("A")="to DELETE"
 S ACRTYPE="EDIT"
 D DTSEL1
 I '$G(ACRDTDA) K ACRQUIT Q
 S DA=+ACRDTDA
 S DIK="^ACRDT("
 W !
 D DIK^ACRFDIC
DTEND Q
VENDOR ;SELECT VENDOR
 S DIC="^AUTTVNDR("
 S DIC(0)="AEMQZ"
 S DIC("A")="Select VENDOR/CONTRACTOR: "
 W !
 D DIC^ACRFDIC
 I +Y<1 S ACRQUIT="" Q
 S ACRVDA=+Y
 Q
