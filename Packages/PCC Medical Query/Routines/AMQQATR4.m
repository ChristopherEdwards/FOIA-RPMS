AMQQATR4 ; IHS/CMI/THL - PIECE OF AMQQATR1 TO MEET PORT STANDARDS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
EN ; - EP - FROM RUN+8^AMQQATR1
BP N A,B,C,E,X,Y,Z,T
 I '$D(AMQQHIDE) W !,"Computing Search Efficiency Rating...."
 S X=$P(%,";",4)
 S Z=$P(X,"~")
 S A=$P(Z,":")
 S B=$P(Z,":",2)
 S C=$P(Z,":",3)
 S E=$P(Z,":",4)
 S T="I +R"_A_B
 I C'="" S T=T_",+R"_C_E
 S T=T_$P(X,"~",3)_"($P(R,""/"",2)"
 S Z=$P(X,"~",2)
 S A=$P(Z,":")
 S B=$P(Z,":",2)
 S C=$P(Z,":",3)
 S E=$P(Z,":",4)
 S T=T_A_B
 I C'="" S T=T_"&$P(R,""/"",2)"_C_E
 S AMQQRTXT=T_")"
 S AMQQY=$P(^AMQQ(1,+AMQQQ,0),U,10)_";"_$P(^(0),U,11)_";"_$P(^(0),U,12)
 Q
 ;
