BGP2D38 ; IHS/CMI/LAB - IMMUNIZATIONS ;
 ;;12.0;IHS CLINICAL REPORTING;;JAN 9, 2012;Build 51
 ;
INFLU(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPFLU,C,X,ED,BD,G,V,Y,T,I,R,BGPIMM,BGPNMI
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPFLU
 ;get all immunizations
 S C="15^16^88^111^135^140^141^144"
 D GETIMMS^BGP2D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPFLU(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 S T=$O(^ATXAX("B","BGP CPT FLU",0))
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXCHK(Y,T,1) S BGPFLU(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I $$ICD^ATXCHK(Y,T,1) S BGPFLU(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVPOV("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVPOV(X,0),U,1) Q:'Y  S Z=$P(^ICD9(Y,0),U,1) I $$ICD^ATXCHK(Y,$O(^ATXAX("B","BGP FLU IZ DXS",0)),9) S BGPFLU(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVPRC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVPRC(X,0),U,1) Q:'Y  S Z=$P(^ICD0(Y,0),U,1) I Z="99.52" S BGPFLU(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPFLU(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPFLU(X) Q
 .S Y=X
 ;now count them and see if there are 2 of them
 S BGPFLU=0,X=0 F  S X=$O(BGPFLU(X)) Q:X'=+X  S BGPFLU=BGPFLU+1
 I BGPFLU>1 Q 1_U_"2 Influenza"
 ;
 F BGPZ=15,16,88,111,135,140,141 S X=$$ANEGCONT^BGP2D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra Influenza"
 ;
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=15,16,88,111,135,140,141,144 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Influenza"
 S R=$$CPTREFT^BGP2UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP CPT FLU",0)))
 I R S:$P(R,U,3)="N" BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Influenza"
 ;now check Refusals in imm pkg
 S BGPNMI=""
 F BGPIMM=15,16,88,111,135,140,141,144 S R=$$IMMREF^BGP2D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 I R Q 3_U_$S(BGPNMI:"NMI",1:"Ref")_" Influenza"
 Q ""
HIB3(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHIB,BGPAHIB
 ;get all immunizations
 S C="49^51"
 D GETIMMS^BGP2D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHIB(X)="",BGPAHIB(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90647!(Y=90648) S BGPHIB(9999999-$P(ED,"."))="",BGPAHIB(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90647!(Y=90648) S BGPHIB(9999999-$P(ED,"."))="",BGPAHIB(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 I BGPHIB>2 Q 1_U_"3 3-Dose Hib"
 ;NOW CHECK TO SEE IF THE FIRST 2 ARE 49
 S BGPX=$$ADDONE(P,EDATE)
 I BGPX]"" Q BGPX
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=49,51 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E)&($P(^AUPNPREF(Y,0),U,7)="N") S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" 3-Dose Hib"
 S R=$$CPTREFT^BGP2UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HIB CPT",0)))
 I R S:$P(R,U,3)="N" BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hib"
 ;now check Refusals in imm pkg
 ;F BGPIMM=49,51 S R=$$IMMREF^BGP2D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" 3 DOSE Hib"
 F BGPZ=49,51 S X=$$ANCONT^BGP2D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra 3-Dose Hib"
 Q ""
HIB4(P,EDATE) ;EP
 K BGPC,BGPG,BGPX
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHIB,BGPAHIB
 ;get all immunizations
 S C="17^22^46^47^48^49^50^51^102^120^132^146"
 D GETIMMS^BGP2D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHIB(X)="",BGPAHIB(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90645!(Y=90646)!(Y=90647)!(Y=90648)!(Y=90698)!(Y=90720)!(Y=90721)!(Y=90748)!(Y=90737) S BGPHIB(9999999-$P(ED,"."))="",BGPAHIB(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90645!(Y=90646)!(Y=90647)!(Y=90648)!(Y=90698)!(Y=90720)!(Y=90721)!(Y=90748)!(Y=90737) S BGPHIB(9999999-$P(ED,"."))="",BGPAHIB(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 I BGPHIB>3 Q 1_U_"4 4-Dose Hib"
 ;now get povs
 K BGPHIB M BGPHIB=BGPAHIB
 K BGPG S %=P_"^ALL DX V03.81;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPHIB($P(BGPG(X),U))="",BGPAHIB($P(BGPG(X),U))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 I BGPHIB>3 Q 1_U_"4 4-Dose Hib"
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=22,46,47,48,49,50,51,102,120,132,146 D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E)&($P(^AUPNPREF(Y,0),U,7)="N") S BGPNMI=1 S R=1
 I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" 4-DOSE Hib"
 S R=$$CPTREFT^BGP2UTL1(P,$$DOB^AUPNPAT(P),EDATE,$O(^ATXAX("B","BGP HIB CPT",0)))
 I R S:$P(R,U,3)="N" BGPNMI=1 Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hib"
 ;now check Refusals in imm pkg
 ;F BGPIMM=17,22,46,47,48,49,50,51,102,120,132 S R=$$IMMREF^BGP2D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" Hib"
 F BGPZ=17,22,46,47,48,49,50,51,102,120,132,146 S X=$$ANCONT^BGP2D31(P,BGPZ,EDATE) Q:X]""  ;cmi/maw 12/17/07 missing edate
 I X]"" Q 4_U_"Contra 4-Dose Hib"
 Q ""
ADDONE(P,EDATE) ;
 NEW BGPC,BGPG,BGPX,G,C,BGPHIB,BGPAHIB
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPHIB,BGPAHIB
 ;get all immunizations
 S C="17^22^46^47^48^49^50^51^102^120^132^146"
 D GETIMMS^BGP2D32(P,EDATE,C,.BGPX)
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHIB(X)=$P(^AUTTIMM(BGPX(X),0),U,3),BGPAHIB(X)=$P(^AUTTIMM(BGPX(X),0),U,3)
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90645!(Y=90646)!(Y=90647)!(Y=90648)!(Y=90698)!(Y=90720)!(Y=90721)!(Y=90748)!(Y=90737) S BGPHIB(9999999-$P(ED,"."))=Y,BGPAHIB(9999999-$P(ED,"."))=Y
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90645!(Y=90646)!(Y=90647)!(Y=90648)!(Y=90698)!(Y=90720)!(Y=90721)!(Y=90748)!(Y=90737) S BGPHIB(9999999-$P(ED,"."))=Y,BGPAHIB(9999999-$P(ED,"."))=Y
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 ;S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 ;I BGPHIB>0 Q 1_U_"3 3-DOSE Hib"
 ;now get povs
 K BGPHIB M BGPHIB=BGPAHIB
 K BGPG S %=P_"^ALL DX V03.81;DURING "_$$DOB^AUPNPAT(P)_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)) S X=0 F  S X=$O(BGPG(X)) Q:X'=+X  S BGPHIB($P(BGPG(X),U))="V03.81",BGPAHIB($P(BGPG(X),U))="V03.81"
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHIB(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 ;S BGPHIB=0,X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X  S BGPHIB=BGPHIB+1
 ;I BGPHIB>0 Q 1_U_"3 3-DOSE Hib"
 ;IF FIRST 2 ARE 49 AND HAS A 3RD Q ON 3 DOSE
 S (G,C)=0 S X=0 F  S X=$O(BGPHIB(X)) Q:X'=+X!(C>1)  D
 .I BGPHIB(X)=49 S G=G+1
 .S C=C+1
 I G=2 Q 1_U_"3 3-Dose Hib"
 Q ""
