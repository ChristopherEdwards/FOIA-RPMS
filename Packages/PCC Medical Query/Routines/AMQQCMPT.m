AMQQCMPT ; IHS/CMI/THL - COMPILES TURBO CODE FOR "AQ" XREF ;
 ;;2.0;IHS PCC SUITE;**4**;MAY 14, 2009
 ;-----
TURB3 ; ENTRY POINT FROM AMQQCMP1
TURB1 ; ENTRY POINT FROM AMQQCMP1
 S %=$P(^AMQQ(1,+Q,0),U,15)
 S C=$P(Q,U,15)
 S A=$P(C,";",4)
 S B=$P(C,";",5)
 S:A=B A=A-.000001
 S A=$E("00000",1,3-$L(A\1))_A,B=$E("00000",1,3-$L(B\1))_B
 S AMQV(1)="S AMQP(.1)="""_%_A_""",AMQP(.11)="""_%_B_""" X AMQV(2)" D TSET
 S AMQV(2)="F  S %=$O(^AUPNVMSR(""AQ"",AMQP(.1))) S:((%="""")!(%]AMQP(.11))) %=""ZZ999"" K:"""_%_"""'=$E(%,1,"_$L(%)_") ^UTILITY(""AMQQ TEMP"",$J) Q:"""_%_"""'=$E(%,1,"_$L(%)_")  S AMQP(.1)=% X AMQV(3)"
 ;IHS/CMI/LAB - modified line below to skip measurements entered in error.
 ;S AMQV(3)="F AMQP(.2)=0:0 Q:"""_%_"""'=$E(AMQP(.1),1,"_$L(%)_")  S AMQP(.2)=$O(^AUPNVMSR(""AQ"",AMQP(.1),AMQP(.2))) Q:'AMQP(.2)  S %=$P(^AUPNVMSR(AMQP(.2),0),U,2) I '$D(^UTILITY(""AMQQ TEMP"",$J,%)) S ^(%)="""",AMQP(0)=% X AMQV(4)"
 S AMQV(3)="F AMQP(.2)=0:0 Q:"""_%_"""'=$E(AMQP(.1),1,"_$L(%)_")  S AMQP(.2)=$O(^AUPNVMSR(""AQ"",AMQP(.1),AMQP(.2))) Q:'AMQP(.2)  "
 S AMQV(3)=AMQV(3)_"I '$P($G(^AUPNVMSR(AMQP(.2),2)),U) S %=$P(^AUPNVMSR(AMQP(.2),0),U,2) I '$D(^UTILITY(""AMQQ TEMP"",$J,%)) S ^(%)="""",AMQP(0)=% X AMQV(4)"
 S AMQQLINO=4
 S AMQQTFLG=""
 D KILL
 Q
 ;
TURB2 ; ENTRY POINT FROM AMQQCMP1
 S AMQV(1)="F AMQP(2)=|10|:0 S AMQP(2)=$O(^AUPNVSIT(""B"",AMQP(2))) K:'AMQP(2)!(AMQP(2)>|11|) ^UTILITY(""AMQQ TEMP"",$J) Q:'AMQP(2)!(AMQP(2)>|11|)  X AMQV(2)" D TSET
 S AMQV(2)="F AMQP(1)=0:0 S AMQP(1)=$O(^AUPNVSIT(""B"",AMQP(2),AMQP(1))) Q:'AMQP(1)  I '$P(^AUPNVSIT(AMQP(1),0),U,11) S %=$P(^(0),U,5) I %,'$D(^UTILITY(""AMQQ TEMP"",$J,%)) S ^(%)="""",AMQP(0)=% I $D(^DPT(%,0)) X AMQV(3)"
 S AMQQLINO=3
 D KILL
 Q
 ;
TURB4 ; ENTRY POINT FROM AMQQCMP1
 I +Q=168 S X="BPS",Y="BPD"
 I +Q=170 S X="VCR",Y="VCL"
 I +Q=171 S X="VUR",Y="VUL"
 S AMQV(1)="S AMQP(.11)="""_X_"|13|"",AMQP(.12)="""_X_"|14|"",AMQP(.13)="""_Y_"|18|"",AMQP(.14)="""_Y_"|19|"",AMQP(0)=0,AMQP(.1)=AMQP(.11),AMQP(.3)=""^UTILITY(""""AMQQ TEMP"""",$J)"" X AMQV(2)" D TSET
 S AMQV(2)="F  K:AMQP(0)=99999999999 @AMQP(.3) Q:AMQP(0)=99999999999  S AMQP(.1)=$O(^AUPNVMSR(""AQ"",AMQP(.1))) X AMQV(3)"
 S AMQV(3)="S:AMQP(.1)]AMQP(.12) AMQP(.1)="""" S:AMQP(.1)=""""&(AMQP(.12)["""_X_""") AMQP(.1)=AMQP(.13),AMQP(.12)=AMQP(.14) S:AMQP(.1)="""" AMQP(0)=99999999999 X:AMQP(.1)'="""" AMQV(4)"
 S AMQV(4)="F AMQP(.2)=0:0 Q:AMQP(0)=99999999999  S AMQP(.2)=$O(^AUPNVMSR(""AQ"",AMQP(.1),AMQP(.2))) Q:'AMQP(.2)  X AMQV(5)"
 ;IHS/CMI/LAB - modified line below to skip measurements entered in error
 ;S AMQV(5)="I $D(^AUPNVMSR(AMQP(.2),0)) S AMQP(0)=$P(^(0),U,2) I AMQP(0),'$D(@AMQP(.3)@(AMQP(0))) S ^(AMQP(0))="""" I $D(^DPT(AMQP(0))) X AMQV(6)"
 S AMQV(5)="I $D(^AUPNVMSR(AMQP(.2),0)),'$P($G(^AUPNVMSR(AMQP(.2),2)),U,1) S AMQP(0)=$P(^(0),U,2) I AMQP(0),'$D(@AMQP(.3)@(AMQP(0))) S ^(AMQP(0))="""" I $D(^DPT(AMQP(0))) X AMQV(6)"
 S AMQQLINO=6
 D KILL
 Q
 ;
TSET N % S Y=$P(Q,U,15)
 F I=1,2,4,5,9,10 S Z=$P(Y,";",I) S:Z<0 Z=0 S:I>2 Z=$E("000",1,3-$L($P(Z,".")))_Z Q:$P(Y,";",I,99)=""  S %="|"_(I+9)_"|" F  Q:AMQV(1)'[%  S AMQV(1)=$P(AMQV(1),%,1)_Z_$P(AMQV(1),%,2,99)
 Q
 ;
AQ1 ; ENTRY POINT FROM AMQQCMPP
AQ2 ; ENTRY POINT FROM AMQQCMPP
 S %=$P(Q,U,15)
 S X=$P(%,";",2)
 S %=+%
 S X=X+1
 S %=%+1
 I '% S %=.5
 S AMQQLINO=3
 S AMQV(1)="S AMQP(0)=0,AMQP(""V1"")="_%_" F  Q:AMQP(0)=99999999999  S AMQP(""V1"")=$O(^AUPNPAT("""_AMQQTURB_""",AMQP(""V1""))) Q:AMQP(""V1"")=""""  Q:AMQP(""V1"")>"_X_"  X AMQV(2)"
 S AMQV(2)="F AMQP(""V2"")=0:0 Q:AMQP(0)=99999999999  S (%,AMQP(""V2""))=$O(^AUPNPAT("""_AMQQTURB_""",AMQP(""V1""),AMQP(""V2""))) Q:'AMQP(""V2"")  I '$D(^UTILITY(""AMQQ TEMP"",$J,%)) S ^(%)="""",AMQP(0)=% X AMQV(3)"
 D KILL
 Q
 ;
KILL K %,A,B,C,I,Q,X,Y,Z
 Q
 ;
