AMQQATL ; IHS/CMI/THL - ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 I $D(AMQQXX) Q
 S Q=AMQQQ
 I +Q=33,Q[";;;NULL" D STD Q
 I +Q=256 S ^UTILITY("AMQQ",$J,"LIST",200)="W !,?6,""Secondary chart numbers will be displayed if they exist""" Q
 I +Q=454 S ^UTILITY("AMQQ",$J,"LIST",200)="W !,?6,""Only CURRENT Private Insurers will be displayed if they EXIST""" Q
 I $P(Q,U,9)["NULL" S Z=": NONE EXIST" D NULL G EXIT
 I $P(Q,U,9)["EXIST"!($P(Q,U,9)[";ALL") S Z=" EXISTS" D NULL I '$P(Q,U,4) G EXIT
 I $P(Q,U,9)[";ANY" S Z=" ANY VALUE INCLUDING NULL" D NULL Q
 S %=$P(AMQQQ,U,9)
 S %=$P(%,";",4)
 I %[">:-888"!(%["'<:NEG")!(%["|||") S Z=" ALL VALUES" D NULL Q
 I $P(Q,U,4) D SQ G EXIT
 I $P(Q,U,17)'="" D TATT G EXIT
 D LATT
EXIT I $D(^UTILITY("AMQQ",$J,"LIST",AMQQILIN)),$D(AMQQKONG) S %=^(AMQQILIN) I %[",""" S %=$P(%,",""")_",""[OR #"_AMQQKGNO_"] "_$P(%,",""",2,99),^(AMQQILIN)=%
 K AMQQFTYP,AMQQVCL,Q,%,X,Y,Z
 Q
 ;
LATT I $P(Q,U,2)="ALIVE" D ALIVE,L1 Q
 I $P(Q,U,2)="COHORT" D COHORT,L1 Q
 I $P(Q,U,2)="FILE ENTRY" D FILE,L1 Q
 S %="W ?6"
 I $P(Q,U,7)="EQUAL TO" S $P(Q,U,7)="="
 S %=%_","""
 I $P(Q,U,2)'=$E($P(Q,U,7),1,$L($P(Q,U,2))) D
 . S %=%_$P(Q,U,2)
 . I $P(Q,U,3)="S",$P(Q,U,7)="IS" S %=%_": """ Q
 . S %=%_" "
 I $P(Q,U,3)'="S"!($P(Q,U,7)'="IS") S %=%_$P(Q,U,7)_" """
 S AMQQFTYP=$P(Q,U,3)
 S AMQQVCL=$P(Q,U,10)
 I AMQQFTYP="Y" S %="W ?6,""PROVIDER ATTRIBUTES AS SPECIFIED""" G LSER
 I $P(Q,U,3)="B" D BLOOD G LSER
 S X=$P(Q,U,9)
 S Y=$P(X,";")
 D TRANS
 I X[";",$P(X,";")'=$P(X,";",2) S %=%_","" and """,Y=$P(X,";",2) D TRANS
LSER S $P(AMQQQ,U,12)=%
L1 S AMQQILIN=AMQQILIN+1
 S ^UTILITY("AMQQ",$J,"LIST",AMQQILIN)=%
 Q
 ;
TRANS I AMQQFTYP="D" X ^DD("DD") G SETA
 I AMQQFTYP="B" S Y=X
 I AMQQFTYP="F",$P(Q,U,8)="<>" S Y=$S(Y=" ":"FIRST ENTRY",Y="|||||":"LAST ENTRY",1:Y) G SETA
 I AMQQFTYP="L" D LOOK G SETA
 I AMQQFTYP="S" S Z=$P(^DD($P(AMQQVCL,","),$P(AMQQVCL,",",2),0),U,3),Z=";"_Z,Y=$F(Z,(";"_X_":")),Y=$E(Z,Y,99),Y=$P(Y,";")
 I +$G(Q)>764,+$G(Q)<768 S Y=Y-1
SETA S %=%_","""_Y_""""
 I +$G(Q)>764,+$G(Q)<768 S %=%_","""_" days"""
 Q
 ;
LOOK S (Z,DIC)=$P(^AMQQ(1,+Q,0),U,3)
 S DIC(0)="",X="`"_$P(Q,U,9)
 D ^DIC
 K DIC
 S Y=$P(Y,U,2)
 I Y'["," Q
 I Z'=2,Z'=6,Z'=16,Z'=9000001 Q
 S Y=$P(Y,",",2)_" "_$P(Y,",")
 Q
 ;
TATT S %="W ?6,"""_$P(Q,U,2)
 S X=$P(Q,U,9)
 S X=$P(X,";",4)
 S Z=" AS SPECIFIED"
 D ZSET^AMQQATL1
 S %=%_$S($D(AMQQONE):"",X="NULL":" IS 'NULL'",X="EXISTS":" EXISTS",1:Z)
 S %=%_""""
 D TT1
 D L1
 Q
 ;
TT1 S $P(AMQQQ,U,12)=%
 Q
 ;
SQ D SQ^AMQQATSQ
 Q
 ;
SQ1 ; - EP -
 N %,X
 F %=0:0 S %=$O(^UTILITY("AMQQ",$J,"SQL",AMQQLSQF,%)) Q:'%  S AMQQILIN=AMQQILIN+1,X=^(%),^UTILITY("AMQQ",$J,"LIST",AMQQILIN)=X I $D(^UTILITY("AMQQ",$J,"SQXL",AMQQLSQF,%)) S AMQQSQLN=$O(^(%,"")) D SQ2
 Q
 ;
SQ2 N AMQQLSQF
 S AMQQLSQF=AMQQSQLN
 D SQ1
 Q
 ;
NULL I $P(Q,U,4),'$D(AMQQGVF),"GL"[$P(Q,U,3) Q
 S AMQQATNM=$P(Q,U,2)
 S AMQQILIN=AMQQILIN+1,^UTILITY("AMQQ",$J,"LIST",AMQQILIN)="W ?6,"""_AMQQATNM_Z_""""
 S $P(AMQQQ,U,12)="W ?6,"""_AMQQATNM_""""
 Q
 ;
STD S AMQQILIN=AMQQILIN+1,^UTILITY("AMQQ",$J,"LIST",AMQQILIN)="W ?6,""ALIVE TODAY"""
 Q
 ;
ALIVE S Y=$P(Q,U,9)
 X ^DD("DD")
 S %="W ?6,""ALIVE AS OF "_Y_""""
 Q
 ;
COHORT S Y=+$P(Q,U,9)
 S Y=$P(^DIBT(Y,0),U)
 S %="W ?6,"""_$S(((+Q=151)!(+Q=85)):"NOT A MEMBER",((+Q=166)!(+Q=86)):"RANDOM SAMPLE",1:"MEMBER")_" OF '"_Y_"' COHORT"""
 Q
 ;
FILE S %=$P(Q,U,9)
 S Y=$P(%,";")
 S Y=@(U_Y_"0)")
 S Y=$P(Y,U)
 I +Q=176,Y="BW PATIENT" S %="W ?6,""REGISTERED IN THE WOMEN'S HEALTH DATABASE""" Q
 S %="W ?6,"""_$S(+Q=176:"ENTERED",+Q=177:"NOT ENTERED",1:"RANDOM SAMPLE OF PATIENTS")_" IN THE '"_Y_"' FILE"""
 Q
 ;
BLOOD N Y,X
 S Y=$P(Q,U,9)
 S X=$P(Y,";")
 D TRANS^AMQQAVB
 S X(1)=X
 S X=$P(Y,";",2)
 D:X'="" TRANS^AMQQAVB
 S X(2)=X
 S $P(AMQQQ,U,9)=X(1)_";"_X(2)
 S %=%_","""_$P(Y,";")_"""" I $P(Y,";",2)'="" S %=%_","" and "_$P(Y,";",2) S %=%_""""
 Q
