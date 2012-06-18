AMQQEM2O ; IHS/CMI/THL - FORMAT FLAT FILE SUBROUTINE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ; This routine was extracted from AMQQEM2 to reducd the routine
 ; size to satisfy SAC requirements.  BRJ/IHS 6/4/93
 ; AMQQEM2 was changed at line L1+9 to D OTHER^AMQQEM2O 
 ; OTHER^AMQQEM2O - This is the only known call to the
 ; label OTHER in the AMQQ routine set
 ;-----
OTHER ; ENTRY POINT - FROM L1+9^AMQQEM2
 W !!!,"Only single valued demographic attributes allowed =>",!
 S DIC("A")="Attribute: "
 S DIC="^AMQQ(5,"
 S DIC(0)="AEQS"
 S DIC("S")="I $P(^(0),U,2)=AMQQCCLS,$P(^(0),U,5),'$P(^AMQQ(1,$P(^(0),U,5),0),U,7),Y'=265,Y'=112"
 S D="C"
 D IX^DIC
 K DIC
 I Y=-1,X="^^" S AMQQQUIT="" Q
 I Y=-1 S AMQQEMNO="" Q
 I $G(AMQQEMP)[(U_$P(Y,U,2)_U) W "  <= ALREADY ON THE MENU",*7 Q
 X "I 0"
 F %=0:0 S %=$O(^UTILITY("AMQQ",$J,"FLAT",%)) Q:'%  I +^(%,0)=+Y Q
 I  W !!,"This field has already been entered...Try again!",*7 H 2 S AMQQEMNO="" Q
 S C=C+1
 S %=$P(^AMQQ(5,+Y,0),U,5)
 S %=$P(^AMQQ(1,%,0),U,5)
 S @G@(C,0)=+Y_"^1^"_$E($P(Y,U,2),1,AMQQEM("HLEN"))_U_$S(%=7:"D",%=9:"N",1:"F")_"^^"_$E($P(Y,U,2),1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN")))
 S @G@(C,2)=""
 S %=$G(^AMQQ(1,$P(^AMQQ(5,+Y,0),U,5),4,1,1))
 I %'="" S @G@(C,2)="I X'="""" "_%
 S A=$P(^AMQQ(1,$P(^AMQQ(5,+Y,0),U,5),0),U,3),B=$P(^(0),U,4)
 I B="" K @G@(C) S C=C-1 D  G OTHER
 .W !!,*7,"Sorry, this attribute is a ""multiple"".  This version of Q-Man does not",!,"allow adding multi-valued attributes after search criteria are defined."
 .W !,"To add this attribute, start over and include it in the search criteria."
 .K %,X,Z,A,B S Y=C
 S %=$P(^DD(A,B,0),U,4)
 S Z=^DIC(A,0,"GL")
 S Z=Z_"AMQP("_$S(AMQQCCLS="P":0,AMQQCCLS="V":1,1:5)_"),"""_$P(%,";")_""")"
 S @G@(C,1)="S X=$P($G("_Z_"),U,"_$P(%,";",2)_")"
 K %,X,Z,A,B
 S Y=C
 Q
 ;
