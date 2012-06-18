BDMVRL7 ; IHS/CMI/LAB - VIEW PT RECORD CON'T ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;MOVED VARIOUS SUBROUTINES INTO BDMVRL42
 ;
 ;
 ;
TD(P,EDATE) ;EP
 Q $$LASTTD^APCHSMU2(P)  ;cmi/maw 9/21/06, use hmr call for this
 ;
 NEW APCL,X,E,B,%DT,Y,TDD,D,LTD,G,C,Z,T
 K TDD
 S %DT="P",X=EDATE D ^%DT S E=Y  ;set E = ending date in fm format
 S B=$$FMADD^XLFDT(E,-3653)  ;b is 10 years back from end date in fm format
 D LASTTDN ;get td from v imm
 S LTD=$O(TDD(0))
 I LTD]"" S LTD=9999999-LTD
 ;now check cpt codes
 S T=$O(^ATXAX("B","DM AUDIT TD CPTS",0))
 K C I T S C=$$CPT^APCLD312(P,B,E,T,3) D
 .I C="" Q
 .Q:LTD>$P(C,U)
 .S LTD=$P(C,U)
 I LTD]"" Q LTD
 Q ""
 ;
LASTTDN ;
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S Y=$P(^AUPNVIMM(X,0),U) Q:'Y
 .S Y=$P(^AUTTIMM(Y,0),U,3)
 .S D=$P(^AUPNVIMM(X,0),U,3) Q:'D
 .S D=$P($P($G(^AUPNVSIT(D,0)),U),".")
 .I D<B Q  ;too early
 .I D>E Q  ;after time frame
 .I Y=1 S TDD(9999999-D)="" Q
 .I Y=9 S TDD(9999999-D)="" Q
 .I Y=20 S TDD(9999999-D)="" Q
 .I Y=22 S TDD(9999999-D)="" Q
 .I Y=28 S TDD(9999999-D)="" Q
 .I Y=35 S TDD(9999999-D)="" Q
 .I Y=50 S TDD(9999999-D)="" Q
 .I Y=106 S TDD(9999999-D)="" Q
 .I Y=107 S TDD(9999999-D)="" Q
 .I Y=110 S TDD(9999999-D)="" Q
 .I Y=113 S TDD(9999999-D)="" Q
 .I Y=115 S TDD(9999999-D)="" Q
 Q
