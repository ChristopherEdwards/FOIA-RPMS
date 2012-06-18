AUPNVDXT ; IHS/CMI/LAB - WASH ISC/GIS TJK OUTPUT TRANSFORMS FOR V DIAGNOSTIC PROCEDURE RESULT FILE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ; WHEN THE NEW PERSON FILE IS INSTALLED CHANGE LINE TL+1 TO I B=6 S B=200
RUN N %,A,B
 I $G(Y)=""!('$D(DA)) Q
 S %=+$G(^AUPNVDXP(DA,0)) I '% Q
 S %=$G(^AUTTDXPR(%,0)) I %="" Q
 S A=$P(%,U,2),B=$P(%,U,3)
 I A'?1U Q
 I "LGDS"'[A Q
 D @("T"_A)
 Q
 ;
TL I B=6 S B=16
 S %=$G(^DIC(B,0,"GL")) I %="" Q
 S %="I $G("_%_"Y,0))'="""" S Y=$P("_%_"Y,0),U)"
 X %
 Q
 ;
TG ;
TS I B'[":" Q
 S B=";"_B
 I B'[(";"_Y_":") Q
 S B=$P(B,(";"_Y_":"),2),B=$P(B,";")
 I B="" Q
 S Y=B
 Q
 ;
TD X ^DD("DD")
 Q
 ;
