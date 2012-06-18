AMQQAVR ; IHS/CMI/THL - RELATIVE DATE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
TYPE W !,"Relative to what date =>",!!
 S %="DATE OF BIRTH^DATE OF DEATH^A PARTICULAR AGE"
 F I=1:1 S Y=$P(%,U,I) Q:Y=""  W ?3,I,") ",Y,!
RT W !,"Your choice (1-",I-1,"): 1// "
 R X:DTIME E  S X=U
 I X="" S X=1 W "  (1)"
 I X?1."?" W !!!,"Results are screened by comparing the date of result with the ""relative"" date",!! G RT
 I $E(X)=U S AMQQQUIT="" G EXIT
 I X?1N,X<I D @("R"_X) G EXIT
 W "  ??",*7
 G RT
 ;
EXIT I $D(AMQQQUIT) S AMQQCOMP=""
 I AMQQCOMP'="" S AMQQSQCV=AMQQCOMP
 K X,Y,%,C,F,I,Z
 Q
 ;
R1 ; BIRTHDAY
 S AMQQCOMP="0^0^CDOB"
 W !
R1RS W !,"Time window begins how long after patient's birth: "
 S Z="1^R1RS^R1RE"
 D RG
 G @AMQQDEST
R1RE W !,"The window ends how long after birth: "
 S Z="2^R1RE^R1CK"
 D RG
 G @AMQQDEST
R1CK I +AMQQCOMP'<$P(AMQQCOMP,U,2) W "  ??",*7 G R1
 D SET
 Q
 ;
R2 ; DEATHDAY
 S AMQQCOMP="0^0^CDOD" W !
R2RS W !,"The window of time begins how long before each patient's death: "
 S Z="1^R2RS^R2RE"
 D RG
 G @AMQQDEST
R2RE W !,"The window ends how long before death: "
 S Z="2^R1RE^R2CK"
 D RG
 G @AMQQDEST
R2CK I $P(AMQQCOMP,U,2)'<+AMQQCOMP W "  ??",*7 G R2
 D SET
 Q
 ;
R3 ; AGE
 W ! S AMQQCOMP="0^0^CAGE"
 W !,"Enter the baseline age: "
 R X:DTIME E  S X=U
 I U[$E(X) S AMQQQUIT="" Q
 I X?1."?" D HELPA G R3
 I X="" S AMQQCOMP="" Q
 I X?1.N S X=X_"Y" I $G(AMQQCOMP)'["CDOB" W "   (years)"
 S F=""
 D DATE
 I Y=-1 G R3
 S $P(AMQQCOMP,U,4)=Y
R3RS W !,"Enter beginning of time window relative to each patient's age: "
 S Z="1^R3RS^R3RE^1"
 D RG
 G @AMQQDEST
R3RE W !,"Enter the end of the time window relative to the baseline age: "
 S Z="2^R3RE^R3CK^1"
 D RG
 G @AMQQDEST
R3CK I +AMQQCOMP'<$P(AMQQCOMP,U,2) W "  ??",*7 G R3
 D SET
 Q
 ;
RG R X:DTIME E  S X=U
 I X="" S X=$S(+Z=1:"0D",1:"999999D")
 I X=U S AMQQQUIT="" S AMQQDEST="EXIT" Q
 I X?1."?" D @("HELPD"_$P(Z,U,4)) S AMQQDEST=$P(Z,U,2) Q
 I X?.1P1.N S X=X_"Y" I $G(AMQQCOMP)'["CDOB" W "  (years)"
 S F=""
 D @("DATE"_$P(Z,U,4))
 I Y=-1 S AMQQDEST=$P(Z,U,2) Q
 S $P(AMQQCOMP,U,+Z)=Y
 S AMQQDEST=$P(Z,U,3)
 Q
 ;
DATE1 S F="+"
 I $E(X)="+"!($E(X)="-") S F=$E(X),X=$E(X,2,99)
DATE I $E(X)'?1N G D1
 I X?1.N W !!,"You must also specify time units; e.g. 6 MONTHS or 30 YEARS",!!,*7 S Y=-1 Q
 F  Q:X'[" "  S X=$P(X," ")_$P(X," ",2,99)
 S C=+X,X=$P(X,+X,2)
 I $E(X)="Y",$G(AMQQCOMP)["CDOB" W " (",C,$S(C=1:"st",C=2:"nd",C=3:"rd",1:"th")," BIRTHDAY)"
 I $L(X),"DWMY"[$E(X) S %=$E(X),Y=C*$S(%="D":1,%="W":7,%="M":30.44,1:365.25),Y=Y\1,Y=F_Y Q
D1 W "  ??",*7
 S Y=-1
 Q
 ;
SET S AMQQFROU=$P(AMQQCOMP,U,3)_"^AMQQF1"
 S AMQQCOMP=$P(AMQQCOMP,U)_";"_$P(AMQQCOMP,U,2)_";"_$P(AMQQCOMP,U,4)
 Q
 ;
HELPD W !!,"Enter a time period like ""6 MONTHS"" or ""30 DAYS"" or ""2 YEARS""",!!
 Q
 ;
HELPA W !!,"Enter a baseline age like ""3 YEARS"" or ""18 MONTHS""",!!
 Q
 ;
HELPD1 W !!,"Enter a time period relative to the ",$S($D(AMQQSQRD):"visit",1:"baseline age"),".",!
 W "For example, ""+3 YEARS"" includes a time period 3 years beyond the ",$S($D(AMQQSQRD):"visit",1:"baseline age"),".",!
 W "Similarly, ""-18 MONTHS"" includes the 18 month period before the ",$S($D(AMQQSQRD):"visit",1:"baseline age"),".",!!
 Q
 ;
EN1 ; ENTRY POINT FOR VISITS
 W !!,"You can specify a time window relative to the visit date.",!!
R4RS W "Enter the start of the time window relative to the visit: "
 S Z="1^R4RS^R4RE^1"
 D RG
 G @AMQQDEST
R4RE W !,"Enter the end of the time window relative to the visit: "
 S Z="2^R4RE^R3CK^1"
 D RG
 G @AMQQDEST
R4CK I +AMQQCOMP'<$P(AMQQCOMP,U,2) W "  ??",*7 G R4RS
 D SET
 Q
 ;
