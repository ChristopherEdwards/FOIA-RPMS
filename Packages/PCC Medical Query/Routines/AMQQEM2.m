AMQQEM2 ; IHS/CMI/THL - FORMAT FLAT FILE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 S %=""
 S $P(%,"*",79)=""
 W !!,%,!!
 W "So far, so good.  Now I need to know exactly how the ASCII file should look.",!
 I AMQQCCLS="P" D ACCN^AMQQEM22 I $D(AMQQQUIT) Q
 W !!,"Enter the field (variable) names on the header line of the flat file =>"
 D VAR
RUN D @$S(AMQQCCLS="P":"PT",AMQQCCLS="V":"VISIT^AMQQEM22",1:"ERROR")
 I $D(AMQQQUIT) Q
EXIT Q
 ;
VAR K H,AMQQEM("DATE TRANS")
 S C=0
 S G="^UTILITY(""AMQQ"",$J,""FLAT"")"
 S T=0
 S AMQQEMFS=""
 K @G
 S %="^^PATIENT^F;1^1^DOB^D;7^1^AGE^N;39^1^SSN^F;^^RECORD #^F;2^1^SEX^F"
 S A="$P(^DPT(AMQP(0),0),U);$P(^DPT(AMQP(0),0),U,3);(DT-$P(^DPT(AMQP(0),0),U,3))\10000;$P(^DPT(AMQP(0),0),U,9);$P($G(^AUPNPAT(AMQP(0),41,DUZ(2),0)),U,2);$P(^DPT(AMQP(0),0),U,2)"
 S B=";S Y=X X ^DD(""DD"") S X=Y;;;;S X=$S(X=""F"":""FEMALE"",X=""M"":""MALE"",1:"""")"
 F C=1:1:6 S @G@(C,0)=$P(%,";",C),$P(^(0),U,6)=$E($P(^(0),U,3),1,+$G(AMQQEM("HLEN"))),$P(^(0),U,7)="",@G@(C,1)="S X="_$P(A,";",C),@G@(C,2)=$P(B,";",C)
 K %,A,B
 Q
 ;
PT N %,A,B,X,Y,Z
 D VAR
 S (P,AMQQEMP)="^PATIENT NAME^DOB^AGE^SSN^CHART NUMBER^SEX^"
 S Z="1:PATIENT NAME;2:DOB;3:AGE;4:SSN;5:LOCAL RECORD NUMBER;6:SEX;"
 F %=9:0 S %=$O(^UTILITY("AMQQ",$J,"VAR NAME",%)) Q:'%  S X=^(%) D
 .S Y=$P(^AMQQ(1,+X,4,$P(X,U,2),0),U)
 .I P[(U_Y_U) Q
 .S C=C+1,Z=Z_C_":"_Y_";"
 .S @G@(C,0)=+X_U_$P(X,U,2)_U_$E(Y,1,AMQQEM("HLEN"))_U_$S($P(X,U,2)>2:"F",$P(X,U,2)=2:"D",$P(^AMQQ(1,+X,0),U,5)=7:"D",$P(^(0),U,5)=9:"N",1:"F")_U_%_U_$E(Y,1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN")))
 .S @G@(C,1)="S X=AMQP("_%_")"
 .I $G(^AMQQ(1,+X,4,$P(X,U,2),1))'="" S @G@(C,2)="I X'="""" "_^(1)
 .Q
 S Z=Z_(C+1)_":"_"OTHER DEMOGRAPHIC ATTRIBUTE;"
 S C("OTHER")=C+1
 S Z=Z_(C+2)_":EDIT A PREVIOUSLY SELECTED FIELD;"
 S C("EDIT")=C+2
 S AMQQEMZ="SO^"_Z
 K A,B,Z
 I AMQQEM("ACCN")="YES" S C=C+1,@G@(C,0)="^^"_$E("ENTRY #",1,AMQQEM("HLEN"))_"^N^^"_$E("ENTRY #",1,AMQQEM("HLEN"))_U_($G(AMQQEM("FIX"))+$G(AMQQEM("MLEN"))),@G@(C,1)="S X=AMQQTOT",AMQQEMFS=C_U
LOOP ; EP FROM AMQQEM22
 S (I,N)=0,J=1
 W !
 F  D  I $D(AMQQQUIT)!$D(AMQQEMNO) Q
L1 .S DIR("A")="     Your choice",DIR(0)=AMQQEMZ
 .D ^DIR
 .I X=U W !!,"You may not back up here.",!,"Type '^^' if you want to terminate this session.",! G L1
 .I X="",$G(AMQQEMFS)="" W !!,"You have not entered a field yet.",!,"Type '^^' if you want to terminate this session.",! G L1
 .I X="" S AMQQEMNO="" Q
 .I Y?2."^" S AMQQQUIT="" D  Q
 ..I '$D(AMQQEX("TDFN")) Q
 ..S DIK="^AMQQ(3.1,",DA=AMQQEX("TDFN") D ^DIK K DIK,DA
 .I Y=C("OTHER") D OTHER^AMQQEM2O G:'$D(AMQQEMNO) L2 D OOPS Q
 .I Y=C("EDIT") D EDIT D:$D(AMQQEMNO) OOPS Q
L2 .I (U_AMQQEMFS)[(U_Y_U) W !!,"You have already entered this field...Try again!",*7,!! H 2 D OOPS Q
 .I Y=1,AMQQCCLS="P" S AMQQEMN=1 D PATIENT^AMQQEM21 D:'$D(AMQQEMNO)&'$D(AMQQQUIT) ^AMQQEM3 Q
 .I Y=3,AMQQCCLS="V" S AMQQEMN=3 D PATIENT^AMQQEM21 S Y=3 D:'$D(AMQQEMNO)&'$D(AMQQQUIT) ^AMQQEM3 Q
 .S AMQQEMFS=AMQQEMFS_Y_U
 .D ^AMQQEM3
 .I $G(AMQQEMFN)>98 S AMQQEMNO="" Q
 K AMQQEMNO,DIRUT,DTOUT,DUOUT,DIROUT,AMQQEMFN
 Q
 ;
EDIT N %,X,Y,Z,I,J,AMQQFEDT
 S AMQQFEDT=""
 W !!
 I $L(AMQQEMFS,U)=2 S Y=+AMQQEMFS D ^AMQQEM3 Q
 I AMQQEMFS="" W "  ??",*7 Q
 S J=0
 F I=1:1 S X=$P(AMQQEMFS,U,I) Q:X=""  I X S J=J+1
 I J=1,$P(^UTILITY("AMQQ",$J,"FLAT",+AMQQEMFS,0),U,3)="ENTRY #" W "  ??",*7 Q
 S AMQQEMAX=J
 I J=1,X="A" G E1
EQ S DIR(0)="FO^:"
 S DIR("A")="Edit which segment (A-"_$C(64+J)_")"
 S DIR("?")="Enter a segment letter from the display line."
 D ^DIR
 K DIR
 S:$D(DUOUT) DIRUT=1
 I X=U S AMQQEMNO="" Q
 I X="^^" S AMQQQUIT="" Q
E1 I X?1U,$A(X)-64'>AMQQEMAX S Y=$P(AMQQEMFS,U,$A(X)-64) D ^AMQQEM3 Q
 W "  ??",*7 G EQ
 Q
 ;
ERROR Q
 ;
OOPS N AMQQEM3
 S AMQQEM3=5
 K AMQQEMNO
 D LIST^AMQQEM3
 Q
 ;
