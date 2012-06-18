BDMD11T ; IHS/CMI/LAB - 2011 DIABETES AUDIT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**4**;JUN 14, 2007
 ;
 ;
TOBACCO(P,BDATE,EDATE) ;EP
 I '$G(P) Q ""
 NEW BDMTOB,BDMSDX,BDMXPND,BDM1320,BDMSCPT,BDMALL,D,%,F,BDMTOBS,BDMTOBC,BDMSBD
 D TOBACCOS  ;get last hf in BDMTOBS, BDMTOBC
 ;now get date of latest health factor and check for any of these next things after the HF
 S BDMSBD=$P(BDMTOBS,U,3)
 S BDMSDX=$$DX(P,$S(BDMSBD:BDMSBD,1:BDATE),EDATE)  ;get last dx in format code^date and compare to bdmdob
 I BDMSDX]"" S BDMTOBS=BDMSDX
 S BDMSBD=$P(BDMTOBS,U,3)
 S BDMXPND=$$PED(P,BDMSBD,EDATE)
 I BDMXPND]"" S BDMTOBS=BDMXPND
 S BDMSBD=$P(BDMTOBS,U,3)
 S BDM1320=$$DENT(P,BDMSBD,EDATE)
 I BDM1320]"" S BDMTOBS=BDM1320
 S BDMSBD=$P(BDMTOBS,U,3)
 S BDMSCPT=$$CPTSM(P,BDATE,EDATE)
 I BDMSCPT]"" S BDMTOBS=BDMSCPT
 Q BDMTOBS
 ;
DX(P,BDATE,EDATE) ;EP
 NEW BDMG,T,X,G,Y,F,I,Z
 S BDMG=$$LASTDXT^BDMAPIU(P,BDATE,EDATE,"BGP GPRA SMOKING DXS","E")
 I BDMG]"" D  Q G
 .S G=""
 .S I=$P(BDMG,U,4)
 .S F=$P(BDMG,U,5)
 .S Z=$$VAL^XBDIQ1(F,I,.01)
 .I Z=305.13!(Z="V15.82") S G="2^2  Not a Current User "_$P(BDMG,U,2)_" "_$P(BDMG,U,3)_" "_$$FMTE^XLFDT($P(BDMG,U,1))_U_$P(BDMG,U,1) Q
 .S G="1^1  Current User "_$P(BDMG,U,2)_" "_$P(BDMG,U,3)_" "_$$FMTE^XLFDT($P(BDMG,U,1))_U_$P(BDMG,U,1) Q
 S T=$O(^ATXAX("B","BGP GPRA SMOKING DXS",0))
 S X=0,G="" F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .Q:$P(^AUPNPROB(X,0),U,3)>EDATE
 .Q:$P(^AUPNPROB(X,0),U,3)<BDATE
 .S Y=$P(^AUPNPROB(X,0),U)
 .Q:'$$ICD^ATXCHK(Y,T,9)
 .S Z=$P(^ICD9(Y,0),U,1)
 .I Z="305.13"!(Z="V15.82") S G="2^2  Not a Current User "_$P($$ICDDX^ICDCODE(Y),U,2)_" PROBLEM LIST "_" "_$$FMTE^XLFDT($P(^AUPNPROB(X,0),U,3))_U_$P(^AUPNPROB(X,0),U,3)
 .S G="1^1  Current User "_$P($$ICDDX^ICDCODE(Y),U,2)_" PROBLEM LIST "_" "_$$FMTE^XLFDT($P(^AUPNPROB(X,0),U,3))_U_$P(^AUPNPROB(X,0),U,3)
 .Q
 Q G
TOBACCOS ;EP
 K BDM
 S BDMTOBS="",BDMTOBC=""
 S BDMTOBS=$$LASTHF(P,"TOBACCO (SMOKING)",BDATE,EDATE) K O,D,H
 S BDMTOBC=$$LASTHF(P,"TOBACCO (SMOKELESS - CHEWING/DIP)",BDATE,EDATE) K O,D,H
 I '$O(^AUTTHF("B","TOBACCO (SMOKING)",0)) S BDMTOBS=$$LASTHF(P,"TOBACCO",BDATE,EDATE) K O,D,H
 ;if have both then take the one that indicates tobacco use
 I $P(BDMTOBS,U)=1 Q
 I $P(BDMTOBC,U)=1 S BDMTOBS=BDMTOBC Q
 I BDMTOBS=2 Q
 I BDMTOBC=2 S BDMTOBS=BDMTOBC Q
 Q
 ;
LASTHF(P,C,BDATE,EDATE) ;EP - get last factor in category C for patient P
 S C=$O(^AUTTHF("B",C,0)) ;ien of category passed
 I '$G(C) Q ""
 NEW H,D,O,F,Z
 S (H,D)=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .Q:'$D(^AUPNVHF("AA",P,H))
 .S D="" F  S D=$O(^AUPNVHF("AA",P,H,D)) Q:D'=+D  D
 ..Q:(9999999-D)>EDATE  ;after time frame
 ..Q:(9999999-D)<BDATE  ;before time frame
 ..S Z=$O(^AUPNVHF("AA",P,H,D,0))
 ..S F=$$VAL^XBDIQ1(9000010.23,Z,.01)
 ..I F="SMOKER IN HOME"!(F="SMOKE FREE HOME")!(F["CEREMONIAL")!(F["EXPOSURE TO") Q
 ..S O(D)=$O(^AUPNVHF("AA",P,H,D,""))
 .Q
 S D=$O(O(0))
 ;I D="" Q D
 I D]"" D  Q Z
 .S Z=$$TUHF($$VAL^XBDIQ1(9000010.23,O(D),.01))
 .S Z=Z_U_$S(Z=1:"1  Current User ",1:"2  Not a Current User ")_$$VAL^XBDIQ1(9000010.23,O(D),.01)_"  "_$$FMTE^XLFDT(9999999-D)_"^"_(9999999-D)
 S (H,D)=0 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .Q:'$D(^AUPNVHF("AA",P,H))
 .S D="" F  S D=$O(^AUPNVHF("AA",P,H,D)) Q:D'=+D  D
 ..Q:(9999999-D)>EDATE  ;after time frame
 ..Q:(9999999-D)<BDATE  ;before time frame
 ..S Z=$O(^AUPNVHF("AA",P,H,D,0))
 ..S F=$$VAL^XBDIQ1(9000010.23,Z,.01)
 ..I F="SMOKER IN HOME"!(F="SMOKE FREE HOME")!(F["CEREMONIAL")!(F["EXPOSURE TO") S O(D)=$O(^AUPNVHF("AA",P,H,D,""))
 .Q
 S D=$O(O(0))
 I D Q 2_"^2  Not a Current User "_$$VAL^XBDIQ1(9000010.23,O(D),.01)_"  "_$$FMTE^XLFDT(9999999-D)_"^"_(9999999-D)
 Q "3^3  Not Documented"
 ;
TUHF(V) ;
 I V="" Q 3
 I V["CURRENT" Q 1
 I V["CESSATION" Q 1
 I V="SMOKELESS TOBACCO, STATUS UNKNOWN" Q 3
 I V["STATUS UNKNOWN" Q 3
 Q 2
PED(P,BDATE,EDATE) ;EP
 NEW BDMG,X,Y,T,D,%
 S Y="BDMG("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 I '$D(BGPG) Q ""
 S (X,D)=0,%="",T="" F  S X=$O(BDMG(X)) Q:X'=+X!(%]"")  D
 .S T=$P(^AUPNVPED(+$P(BDMG(X),U,4),0),U)
 .Q:'T
 .Q:'$D(^AUTTEDT(T,0))
 .S T=$P(^AUTTEDT(T,0),U,2)
 .I $P(T,"-")="TO" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-",2)="TO" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-",2)="SHS" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="305.1" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="305.10" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="305.11" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="305.12" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="305.13" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="649.00" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="649.01" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="649.02" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="649.03" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="649.04" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 .I $P(T,"-")="V15.82" S %="1^1  Current User "_T_" "_$$FMTE^XLFDT($P(BDMG(X),U))_U_$P(BDMG(X),U) Q
 Q %
 ;
DENT(P,BDATE,EDATE) ;EP
 K ^TMP($J,"A")
 NEW A,B,E,X,G,Z
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S Z=0 F  S Z=$O(^AUPNVDEN("AD",V,Z)) Q:Z'=+Z!(G)  S B=$P($G(^AUPNVDEN(Z,0)),U) I B S B=$P($G(^AUTTADA(B,0)),U) I B=1320 S G=1_U_$P($P(^AUPNVSIT(V,0),U),".")
 .Q
 K ^TMP($J,"A")
 I G=0 Q ""
 Q "1^1  Current User ADA 1320"_U_$$FMTE^XLFDT($P(G,U,2))_U_$P(G,U,2)
 ;
CPTSM(P,BDATE,EDATE) ;EP - did pat have smoking cpt?
 NEW X,G,Z
 S G=""
 S X=$$LASTCPTT^BDMAPIU(P,BDATE,EDATE,$O(^ATXAX("B","BGP SMOKING CPTS",0)),"E")
 I X="" Q ""
 S Z=$$VAL^XBDIQ1(9000010.18,$P(Z,U,6),.01)
 I Z="1036F" Q "2^2  Not a Current User "_$P(X,U,2)_" "_$$FMTE^XLFDT($P(X,U,1))_U_$P(X,U,1)
 Q "1^1  Current User "_$P(X,U,2)_" "_$$FMTE^XLFDT($P(X,U,1))_U_$P(X,U,1)
