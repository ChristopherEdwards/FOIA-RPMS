LRACKL1 ;DALOI/FHS/JMC/RLM-CONTINUES CHUTES & LADDERS ;03/24/92 18:40 [ 04/24/2003  7:03 AM ]
 ;;5.2T9;LR;*1018*;Nov 17, 2004
 ;;5.2;LAB SERVICE;**272**;Sep 27, 1994
 ; Reference to ^DIC( supported by IA #2374
 ; Reference to ^SC( supported by IA # 908
 ; Changes made to test printing of multiple (alternate) file rooms for sites having multiple divisions.
DIC ;Formerly apart of LRACKL
 I '$G(LRLLIN) D ^LRAC14
 I $G(LRLLIN),$D(^LAB(64.5,1,5,"B",LRLLIN)) D  Q
 . N X,Y S Y=""
 . S X=$O(^LAB(64.5,1,5,"B",LRLLIN,0)) ; Get pointer IEN of separate location.
 . I X S Y=$P($G(^LAB(64.5,1,5,X,0)),U,2) ; Get name of alternate file room.
 . I $L(Y) D  Q  ; Alternate file room.
 . . S SSN=$S($L(SSN):"A"_$E(SSN,8,9)_$E(SSN,6,7)_$E(SSN,1,3)_$E(SSN,4,5)_$E(SSN,10,11),1:LRPPT)
 . .; BEGIN IHS MODIFICATIONS LR*5.2*1018
 . .S HRCNT=HRCN+10000000,HRCNT=$E(HRCNT,7,8)_$E(HRCNT,5,6)_$E(HRCNT,3,4)_$E(HRCNT,2)  ;IHS/ANMC/CLS 11/1/95
 . .;S ^TMP($J,"N","FILE ROOM_"_Y_$S($E(SSN,2)<5:1,1:2),SSN,LRDFN)=U_PNM
 . . S ^TMP($J,"N","FILE ROOM_"_Y,HRCN,LRDFN)=U_PNM  ;IHS/ANMC/CLS 11/1/95
 . S LRSLOC=$S($L($P(^SC(LRLLIN,0),U,2)):$P(^(0),U,2),1:$P(^(0),U,1))
 . S ^TMP($J,"N",LRSLOC,LRPPT,LRDFN)="" ; Put in separate location.
 . K LRLLIN
 I +LRDPF=2 D  Q  ; Put in "FILE ROOM" list.
 .;----- BEGIN IHS MODIFICATIONS LR*5.2*1018
 . ;S SSN=$S($L(SSN):"A"_$E(SSN,8,9)_$E(SSN,6,7)_$E(SSN,1,3)_$E(SSN,4,5)_$E(SSN,10,11),1:LRPPT)
 .S HRCNT=HRCN+10000000,HRCNT=$E(HRCNT,7,8)_$E(HRCNT,5,6)_$E(HRCNT,3,4)_$E(HRCNT,2)  ;IHS/ANMC/CLS 11/1/95
 . S HRCN=$S($L(HRCN):"A"_HRCNT,1:LRPPT)  ;IHS/ANMC/CLS 11/1/95
 . ;S ^TMP($J,"N",$S($E(SSN,2)<5:"FILE ROOM1",1:"FILE ROOM2"),SSN,LRDFN)=U_PNM ; Put in "FILE ROOM" location.
 .S ^TMP($J,"N","FILE ROOM",HRCN,LRDFN)=U_PNM ; Put in "FILE ROOM" location.
 ;----- END MODIFICATIONS
 S X=$S($D(^DIC(+LRDPF,0)):$P(^(0),U,1),1:"")
 I $L(X) S ^TMP($J,"N",X,LRPPT,LRDFN)="" Q  ; Use parent file name as location.
 Q
