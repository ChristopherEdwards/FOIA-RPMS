BGP6D36 ; IHS/CMI/LAB - measure C 06 Nov 2009 2:03 PM 28 May 2015 4:23 PM ;
 ;;16.1;IHS CLINICAL REPORTING;;MAR 22, 2016;Build 170
 ;
MEN(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPMENI,C,ED,BD,V,X,Y,BGPZ,B,BGPIMM,R,G
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 K BGPMENI
 ;get all immunizations
 S C="32^108^114^136^147"
 D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 I $O(BGPX(0)) Q 1_U_"Meningococcal"
 ;now get cpts
 S ED=9999999-EDATE-1,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U),Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90733!(Y=90734) S BGPMENI(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Y=$P($$CPT^ICPTCOD(Y),U,2) I Y=90733!(Y=90734) S BGPMENI(9999999-$P(ED,"."))=""
 I $D(BGPMENI) Q 1_U_"Meningococcal"
 ;check for Evidence of desease and Contraindications and if yes, then quit
 F BGPZ=32,108,114,136,147 S X=$$ANCONT^BGP6D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"Contra Meningococcal"
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=32,108,114,136,147  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I BGPNMI Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI Meningococcal",1:"Ref Meningococcal")
 F BGPIMM=90733,90734 D
 .S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I BGPNMI Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI Meningococcal",1:"Ref Meningococcal")
 ;now check Refusals in imm pkg
 ;F BGPIMM=32,108,114,136,147 S R=$$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q 3_U_"Ref imm pkg Meningococcal"
 Q ""
 ;
HPV(P,EDATE) ;EP
 NEW BGPC,BGPG,BGPX,BGPHPV,C,X,ED,BD,V,G,R,BGPIMM,Y,Z,B,BGPNMI
 ;gather up all immunizations, cpts, povs and check for 3 each ten days apart
 ;get all immunizations
 S C="62^118^137^165"
 D GETIMMS^BGP6D32(P,EDATE,C,.BGPX)
 ;go through and set into array if 10 days apart
 S X=0 F  S X=$O(BGPX(X)) Q:X'=+X  S BGPHPV(X)=""
 ;now get cpts
 S ED=9999999-EDATE,BD=9999999-$$DOB^AUPNPAT(P),G=0
 F  S ED=$O(^AUPNVSIT("AA",P,ED)) Q:ED=""!($P(ED,".")>BD)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,ED,V)) Q:V'=+V  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVCPT(X,0),U) S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90649!(Z=90650)!(Z=90651) S BGPHPV(9999999-$P(ED,"."))=""
 ..S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X  D
 ...S Y=$P(^AUPNVTC(X,0),U,7) Q:'Y  S Z=$P($$CPT^ICPTCOD(Y),U,2) I Z=90649!(Z=90650)!(Z=90651) S BGPHPV(9999999-$P(ED,"."))=""
 ;now check to see if they are all spaced 10 days apart, if not, kill off the odd ones
 S X="",Y="",C=0 F  S X=$O(BGPHPV(X)) Q:X'=+X  S C=C+1 D
 .I C=1 S Y=X Q
 .I $$FMDIFF^XLFDT(X,Y)<11 K BGPHPV(X) Q
 .S Y=X
 ;now count them and see if there are 4 of them
 S BGPHPV=0,X=0 F  S X=$O(BGPHPV(X)) Q:X'=+X  S BGPHPV=BGPHPV+1
 I BGPHPV>2 Q 1_U_"3 HPV"
 ;check for Evidence of desease and Contraindications and if yes, then quit
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=62,118,137,165  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I BGPNMI Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" HPV"
 F BGPIMM=90649,90650,90651 D
 .S I=+$$CODEN^ICPTCOD(BGPIMM) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,81,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,81,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) S:$P(^AUPNPREF(Y,0),U,7)="N" BGPNMI=1 S R=1
 I BGPNMI Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI HPV",1:"Ref HPV")
 ;now check Refusals in imm pkg
 ;F BGPIMM=62,118 S R=$$IMMREF^BGP6D32(P,BGPIMM,$$DOB^AUPNPAT(P),EDATE)+R
 ;I R Q $S(BGPNMI:4,1:3)_U_$S(BGPNMI:"NMI",1:"Ref")_" HPV"
 F BGPZ=62,118,137,165 S X=$$ANCONT^BGP6D31(P,BGPZ,EDATE) Q:X]""
 I X]"" Q 4_U_"Contra HPV"
 Q ""
AGE(P,BGPZ,BGPDT) ;EP
 ;---> Return Patient's Age.
 ;---> Parameters:
 ;     1 - DFN  (req) IEN in PATIENT File.
 ;     2 - BGPZ  (opt) APCLZ=1,2,3  1=years, 2=months, 3=days.
 ;                               2 will be assumed if not passed.
 ;     3 - APCLDT (opt) Date on which Age should be calculated.
 ;
 N BGPDOB,X,X1,X2  S:$G(BGPZ)="" BGPZ=2
 Q:'$G(P) ""
 I '$D(^DPT(P,0)) Q ""
 S BGPDOB=$P(^DPT(P,0),U,3)
 Q:'BGPDOB ""
 S:'$G(DT) DT=$$DT^XLFDT
 S:'$G(BGPDT) BGPDT=DT
 Q:BGPDT<BGPDOB ""
 ;
 ;---> Age in Years.
 N BGPAGEY,BGPAGEM,BGPD1,BGPD2,BGPM1,BGPM2,BGPY1,BGPY2
 S BGPM1=$E(BGPDOB,4,7),BGPM2=$E(BGPDT,4,7)
 S BGPY1=$E(BGPDOB,1,3),BGPY2=$E(BGPDT,1,3)
 S BGPAGEY=BGPY2-BGPY1 S:BGPM2<BGPM1 BGPAGEY=BGPAGEY-1
 S:BGPAGEY<1 BGPAGEY="<1"
 Q:BGPZ=1 BGPAGEY
 ;
 ;---> Age in Months.
 S BGPD1=$E(BGPM1,3,4),BGPM1=$E(BGPM1,1,2)
 S BGPD2=$E(BGPM2,3,4),BGPM2=$E(BGPM2,1,2)
 S BGPAGEM=12*BGPAGEY
 I BGPM2=BGPM1&(BGPD2<BGPD1) S BGPAGEM=BGPAGEM+12
 I BGPM2>BGPM1 S BGPAGEM=BGPAGEM+BGPM2-BGPM1
 I BGPM2<BGPM1 S BGPAGEM=BGPAGEM+BGPM2+(12-BGPM1)
 S:BGPD2<BGPD1 BGPAGEM=BGPAGEM-1
 Q:BGPZ=2 BGPAGEM
 ;
 ;---> Age in Days.
 S X1=BGPDT,X2=BGPDOB
 D ^%DTC
 Q X
 ;
 ;
