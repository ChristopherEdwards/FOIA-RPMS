AMQQATR3 ; IHS/CMI/THL - NON NUMERIC LAB VALUE TRANSLATION FOR SER ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
LTRZ ; ENTRY POINT FROM AMQQATR1
 N %
 S AMQQLTR="S %=$E(R),R=$S(""Nn""[%:0,""Tt""[%:1,%=+%:(%+1),1:"""")"
 S AMQQLTB1=$P(X,":")
 S %=$E($P(X,":",2))
 S AMQQLTR1=$S("Nn"[%:0,"Tt"[%:.5,%=+%:%,1:"")
 S %=$P(X,":",3)
 I %'="" S AMQQLTB2=%,%=$E($P(X,":",4)),AMQQLTR2=$S("Nn"[%:0,"Tt"[5:.5,%=+%:%,1:"") Q
 S AMQQLTB2="<"
 S AMQQLTR2=999999999
 Q
 ;
LTRT ; ENTRY POINT FROM AMQQATR1
 N %
 S AMQQLTR="S R=$S(R="""":"""",""Nn""[$E(R):0,R["":"":$P(R,"":"",2),1:"""")"
 S AMQQLTB1=$P(X,":")
 S AMQQLTR1=+$E($P(X,":",2))
 S %=$P(X,":",3)
 I %'="" S AMQQLTB2=%,AMQQLTR2=+% Q
 S AMQQLTB2="<"
 S AMQQLTR2=999999999
 Q
 ;
LTRQ ; ENTRY POINT FROM AMQQATR1
 S AMQQLTR="S R=$E(R)"
 S AMQQLTB1="="
 S AMQQLTR1=""""_$E($P(X,":",2))_""""
 S AMQQLTB2="'="
 S AMQQLTR2=9
 Q
 ;
LTRS ; CALLED AMQQATR1
 S AMQQLTR="S R=$E(R)"
 S AMQQLTB1=$P(X,":")
 S AMQQLTR1=""""_$P(X,":",2)_""""
 S AMQQLTB2="'"_AMQQLTB1
 S AMQQLTR2=0
 Q
 ;
