ASDF ; IHS/ADC/PDW/ENM - IHS FILE ROOM LIST CALLS ;  [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 ; IHS/HQW/KML 2/19/97  replace ^UTILITY with ^TMP per SAC 2.3.2.5
 ; -- select date
 S %DT="AXE",%DT("A")="LIST APPOINTMENTS FOR WHAT DATE: "
 D ^%DT K %DT("A") G QUIT:Y<0 S SDDT=Y
 ;
A ; -- select clinic
 S DIV=""
 D ASK2^SDDIV G:Y<0 QUIT S VAUTNI=1 D CLINIC^VAUTOMA G:Y<0 QUIT
 ;
 ; -- sort by
 W ! K DIR S DIR(0)="SA^T:TERMINAL DIGIT;N:NAME;H:HRCN;P:PRIN CLINIC"
 S DIR("A",1)="ENTER 'N' TO PRINT BY PATIENT NAME ORDER"
 S DIR("A",2)="ENTER 'H' TO PRINT BY HRCN ORDER"
 S DIR("A",3)="ENTER 'P' TO PRINT BY PRINCIPLE CLINIC ORDER"
 S DIR("A")="FILE ROOM LIST ORDER:  ",DIR("B")="TERMINAL DIGIT"
 D ^DIR K DIR G QUIT:$D(DIRUT)
 S ANS=Y
 ;
 ; -- select device
 S DGVAR="VAUTD#^VAUTC#^DIV^ANS^SDDT",PGM="START^SDF"
 D ZIS^DGUTQ G QUIT:POP
 I '$D(IO("Q")) D START^SDF I IOST["C-" D PRTOPT^ASDVAR
 Q
 ;
CLIN ;EP; called by SDF for selected clinics
 S A=0 F  S A=$O(VAUTC(A)) Q:A=""  D
 . S C=VAUTC(A)
 . I $D(^SC(C,0)),$S('$D(^SC(C,"I")):1,+^("I")=0:1,+^("I")>SDDT:1,+$P(^("I"),"^",2)'>SDDT&(+$P(^("I"),"^",2)'=0):1,1:0) D AHEAD^SDF
 G LST^SDF
 ;
 ;
C ;EP; called by SDF for IHS version of subrtn
 ; to handle additional types of sorts
 NEW ASDP
 S DA=$S(ANS="N":$P(^DPT(+X,0),U),ANS="H":$$HR(+X),1:$$TD(+X))
 S X=$P(X_"^^^^^",U,1,5)
 S ASDP=$S(ANS="P":$$P,1:$P(^SC(C,0),U))
 I $D(^DPT(+X,"S",D,0)) D
 . S SDAPTT=$P(^DPT(+X,"S",D,0),U,16)
 . I $P(^DPT(+X,"S",D,0),U,2)["C"!($P(^SC(C,SC,D,1,P,0),U,9)="C") S X=X_"^***CANCELLED!***"
 S ^TMP($J,ASDP," "_DA,+X,D)=C_U_X
 S $P(^TMP($J,ASDP," "_DA,+X,D),U,8)=$S($D(^DPT(+X,.1)):^(.1),1:"")
 I $D(^DPT(+X,.36)),$D(^DIC(8,+^DPT(+X,.36),0)),$P(^(0),U,9)=13 D  Q
 . S $P(^TMP($J,ASDP," "_DA,+X,D),U,9)="** COLLATERAL **"
 I SC="S",$P(^SC(C,SC,D,1,P,0),U,10)]"" D
 . S V=$P(^SC(C,SC,D,1,P,0),U,10),V=$S($D(^DIC(8,+V,0)):$P(^(0),U,9)=13,1:0)
 . I V S $P(^TMP($J,ASD," "_DA,+X,D),U,9)="** COLLATERAL **"
 S $P(^TMP($J,ASDP," "_DA,+X,D),U,10)=$S('$D(SDAPTT):"",$D(^SD(409.1,+SDAPTT,0)):$P(^(0),U,4),1:"")
 K V Q
 ;
O ;EP; called by SDF for IHS version of subrtn
 D:SDHED!($Y+2>IOSL) WHED S Y=^TMP($J,SC,DA,X,C) N DFN S DFN=X
 W !?3,$$HRCN^ASDUT,?12,$E($P(D,U,1),1,23),?37,$$DOB($P(D,U,3))
 I ANS="P" W ?57,$P($G(^SC(+Y,0)),U,2) ;indiv clinic
 W ?62,"at " S T=$P(C,".",2)_"000" I T W $E(T,1,2),":",$E(T,3,4),!
 I $P(Y,U,8)]"" W ?48,"** WARD: ",$P(Y,U,8)," **"
 I $P(Y,U,7)]"" W !,?4,$P(Y,U,7)
 I $P(Y,U,9)]"" W !,?4,$P(Y,U,9)
 Q
 ;
WHED S SDHED=0 W !,@IOF,!?16,$$CONF^ASDUT
 W !?9,"FILE ROOM LIST FOR APPOINTMENTS "
 S Y=SDDT D DT^DIQ W !,?30-($L(SC)\2),SC,?55,"PRINTED: "
 S Y=DT D DT^DIQ W !!
 Q
 ;
QUIT ;
 K VAUTC,VAUTD,DGJ,%,%DT,A,AA,ALL,ANS,C,CC,D,DA,DIV,DTOUT,I,P,PGM
 K POP,SC,SDAPTT,SDDT,SDHED,SDSCN,T,VAL,VAR,X,Y,Z,^TMP($J)
 Q
 ;
P() ; -- principle clinic
 Q $S($P($G(^SC(+C,"SL")),U,5):$P(^SC(+$P($G(^SC(+C,"SL")),U,5),0),U),1:$P(^SC(C,0),U))
 ;
DOB(Y) ; -- date of birth
 Q "DOB: "_$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3)
 ;
HR(DFN) ; -- health record number
 Q $$HRCN^ASDUT
 ;
TD(X,Y) ; -- terminal digit
 S Y=$$HRN^ASDUT(+X) Q $P(Y,"-",3)_$P(Y,"-",2)
