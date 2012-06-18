AMQQCMP6 ; IHS/CMI/THL - COMPILES SUBQUERIES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
VAR N Q,AMQQSBSC,AMQQCSC
RUN F AMQQUQQN=0:0 S AMQQUQQN=$O(^UTILITY("AMQQ",$J,"QQ",AMQQUQQN)) Q:'AMQQUQQN  S Q=^(AMQQUQQN) D SET,TSET,SUBSET
EXIT K Q,AMQQUQQN
 Q
 ;
SET S AMQQSBSC=2
 I $P(Q,U,9)[";NULL",$D(^AMQQ(1,+Q,5)) S AMQQSBSC=5
 I $P(Q,U,9)[";ANY",$D(^AMQQ(1,+Q,7)) S AMQQSBSC=7
 I $P(Q,U,9)[";INVERSE",$D(^AMQQ(1,+Q,8)) S AMQQSBSC=8
 Q
 ;
TSET S Y=$P(Q,U,15)
 S T=^AMQQ(1,+Q,AMQQSBSC)
 S %=$P(Q,U,9)
 S Z="|13|;|14|"
 I $P(%,";",5)="NULL",T[Z S T=$P(T,Z)_$P(Y,";",4)_"~~"_$P(Y,";",4)_";NULL"_$P(T,Z,2,99) G TSET1
 S %=$P(%,";",4)
 I %'="",";SAVE;NULL;EXISTS;ANY;"[(";"_%),T[Z S T=$P(T,Z)_$P(Y,";",4)_"~~"_$P(Y,";",5)_";"_%_$P(T,Z,2,99)
 I T'["~~",T[Z,$P($P(AMQQQ,U,9),";",6)="NULL" S T=$P(T,Z)_$P(Y,";",4)_"~~"_$P(Y,";",5)_";NULL"_$P(T,Z,2,99)
TSET1 F I=1:1:10 S Z=$P(Y,";",I) Q:$P(Y,";",I,99)=""  S %="|"_(I+9)_"|" F  Q:T'[%  S T=$P(T,%,1)_Z_$P(T,%,2,99)
 I Q["INVERSE" S %="|12|" I T[% S T=$P(T,%)_"INVERSE"_$P(T,%,2)
 S %="|12|"
 I T[% S T=$P(T,%)_$P(T,%,2)
 S %="|23|"
 S A=$P(Q,U,8)
 S B=(A'="'="&(A'="'><"))
 F  Q:T'[%  S T=$P(T,%)_$S(B:"*",1:"+")_$P(T,%,2,99)
 S T=$P(T,"|30|")_"I 'AMQT("_AMQQUQQN_")"
 S %="|7|"
 S Z=$P(Q,U,14)
 S:Z="" Z=1
 F  Q:T'[%  S T=$P(T,%)_Z_$P(T,%,2,99)
 S %="|20|"
 F  Q:T'[%  S T=$P(T,%)_AMQQUQQN_$P(T,%,2,99)
 S %=T
 S A="|6|"
 S B="|5|"
 F I=1:1 Q:%'[A  D CKER
 S AMQV("QQ",AMQQUQQN,1)=%
 K A,B,C,D,E,%,T,Z,Y,F,I
 Q
 ;
SUBSET N A,X,Y,Z,%
 S A=$O(^UTILITY("AMQQ",$J,"SQXX",AMQQUQQN,""))
 I 'A Q
 S %=AMQV("QQ",AMQQUQQN,1)
 S X=$P(%,"AMQQX=")
 S Y=$P(%,"AMQQX=",2)
 S Z=$P(Y,""" D ^AMQQ",2)
 S Y=$P(Y,""" D ^AMQQ")
 S $P(Y,";",19)=A
 S AMQV("QQ",AMQQUQQN,1)=X_"AMQQX="_Y_""" D ^AMQQ"_Z
 Q
 ;
CKER S C=$P(%,A)
 S D=$P(%,A,2)
 S E=$E(%,4+$L(C)+$L(D),255)
 F  Q:D'[B  S D=$P(D,B)_(AMQQVAR+I)_$P(D,B,2,99)
 S %=C_(AMQQVAR+I)_D_E
 Q
 ;
