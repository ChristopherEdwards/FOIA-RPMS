AMQQCMP4 ; IHS/CMI/THL - COMPILES CODE FOR GENERIC VISIT AND PATIENT CHECKS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
RUN S X="G"
 S G="AMQV"
 F %=0:0 S %=$O(^UTILITY("AMQQ",$J,X,%)) Q:'%  S Y=^(%) D VP S AMQV(X,%)=Z
EXIT K X,A,%,B,C,G,J,N,Z,Y
 Q
 ;
VP S AMQQVPV=$P(Y,";")
 S AMQQVPT=$P(Y,";",2)
 S AMQQVPS=$P(Y,";",3)
 S AMQQVPV1=$P(Y,";",4)
 S AMQQVPV2=$P(Y,";",5)
 S N=$O(@G@(X,%))
 I 'N S N=%+1,@G@(X,N)="I 1 Q"
 S J=""
 I G["(" S J=AMQQLINO_","
 S J=J_$S(X=+X:X,1:(""""_X_""""))
 S A="AMQT("_J_","_%_")"
 S B=" AMQV("_J_","_N_")"
 S C=AMQQVPT
 D @("C"_$S(C="L":"T",C="G":"T",C="S":"S",1:"N"))
 Q
 ;
CT S Z="S %="_AMQQVPV_","_A_"=$S((%=""""):0,1:($D(^UTILITY(""AMQQ TAX"",$J,"_AMQQVPV1_",%))+$D(^(""*"")))) X:"_A_B
 Q
 ;
CS S Z="S %="_AMQQVPV_","_A_"=(%"_AMQQVPS_""""_AMQQVPV1_""") X:"_A_B
 Q
 ;
CN I AMQQVPS'["><" S Z="S %="_AMQQVPV_","_A_"=(%"_AMQQVPS_AMQQVPV1_") X:"_A_B Q
 I AMQQVPV1="" S AMQQVPV1=-99999999999
 I AMQQVPV2="" S AMQQVPV2=99999999999
 I AMQQVPS="><" S Z="S %="_AMQQVPV_","_A_"=((%'<"_AMQQVPV1_")&(%'>"_AMQQVPV2_")) X:"_A_B Q
 I AMQQVPS="'><" S Z="S %="_AMQQVPV_","_A_"=((%>"_AMQQVPV2_")!(%<"_AMQQVPV1_")) X:"_A_B Q
 Q
 ;
