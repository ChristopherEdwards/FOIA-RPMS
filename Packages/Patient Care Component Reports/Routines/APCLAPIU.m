APCLAPIU ; IHS/CMI/LAB - visit data ; 
 ;;2.0;IHS PCC SUITE;**2,6**;MAY 14, 2009;Build 11
 ;
 ;
LASTITEM(P,APCLV,APCLT,BD,ED,APCLF) ;PEP - return last item APCLV OF TYPE APCLT DURING BD TO ED IN FORM APCLF
 I $G(APCLF)="" S APCLF="D"
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 NEW APCLR,%,E,Y K APCLR S %=P_"^LAST "_APCLT_" "_APCLV_";DURING "_BD_"-"_ED,E=$$START1^APCLDF(%,"APCLR(")
 I '$D(APCLR(1)) Q ""
 I APCLF="D" Q $P(APCLR(1),U)
 Q $$V(APCLR(1),APCLT)
 ;
V(Y,T) ;EP
 Q $P(Y,U,1)_"^"_$$T(T)_$P(Y,U,3)_"^"_$S($$F(T)]""&($$VF(T)]""):$$VAL^XBDIQ1($$F(T),+$P(Y,U,4),$$VF(T)),1:"")_"^"_$P(Y,U,5)_"^"_$$F(T)_"^"_+$P(Y,U,4)
 ;
T(T) ;EP
 NEW X,Y
 S X=$O(^APCLCNTL("B","TERMS/FILE NUMBER",0))
 I X="" Q ""
 S Y=$O(^APCLCNTL(X,11,"B",T,0))
 I 'Y Q ""
 Q $P($G(^APCLCNTL(X,11,Y,0)),U,3)
 ;
F(T) ;EP
 NEW X,Y
 S X=$O(^APCLCNTL("B","TERMS/FILE NUMBER",0))
 I X="" Q ""
 S Y=$O(^APCLCNTL(X,11,"B",T,0))
 I 'Y Q ""
 Q $P($G(^APCLCNTL(X,11,Y,0)),U,2)
 ;
VF(T) ;EP
 NEW X,Y
 S X=$O(^APCLCNTL("B","TERMS/FILE NUMBER",0))
 I X="" Q ""
 S Y=$O(^APCLCNTL(X,11,"B",T,0))
 I 'Y Q ""
 Q $P($G(^APCLCNTL(X,11,Y,0)),U,4)
 ;
LASTHF(P,C,BD,ED,F) ;PEP - get last factor in category C for patient P between BD and ED
 I '$G(P) Q ""
 I $G(C)="" Q ""
 I $G(F)="" S F=""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 S C=$O(^AUTTHF("B",C,0)) ;ien of category passed
 I '$G(C) Q ""
 S BD=9999999-BD,ED=9999999-ED
 NEW H,D,O S H=0,D=ED-1
 K O
 F  S H=$O(^AUTTHF("AC",C,H))  Q:'+H  D
 .  Q:'$D(^AUPNVHF("AA",P,H))
 .  F  S D=$O(^AUPNVHF("AA",P,H,D)) Q:D'=+D  D
 .. Q:D>BD
 .. S V=$O(^AUPNVHF("AA",P,H,D,0))
 .. S O(D)=(9999999-D)_"^HF: "_$$VAL^XBDIQ1(9000010.23,V,.01)_"^"_$$VAL^XBDIQ1(9000010.23,V,.06)_"^"_$P(^AUPNVHF(V,0),U,3)_"^9000010.23^"_V
 .. Q
 .  Q
 S D=$O(O(0))
 I D="" Q D
 I F="D" Q (9999999-D)
 Q O(D)
 ;
LASTBHDX(P,BD,ED,C,F) ;EP - find date of last BH dx of C, return date in fileman format
 NEW G,Y,V,D,E,X
 I $G(F)="" S F="D"
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(C)="" Q ""
 S G=""
 S E=9999999-BD,D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(G]"")  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(G]"")  D
 .Q:'$D(^AMHREC(V,0))
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(G]"")  S Y=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'Y
 ..S Y=$P($G(^AMHPROB(Y,0)),U)
 ..I Y=C S G=$P($P(^AMHREC(V,0),U),".")_"^BH DX: "_Y_"^"_$$VAL^XBDIQ1(9002011.01,X,.04)_"^^9002011.01^"_X
 I F="D" Q $P(G,U)
 Q G
 ;
LASTBHDT(P,BD,ED,T,F) ;EP - find date of last BH dx of TAXONOMY T
 I $G(P)="" Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW TIEN,G,Y,V,E,X,I
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S G=""
 S E=9999999-BD,D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(G]"")  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(G]"")  D
 .Q:'$D(^AMHREC(V,0))
 .S X=0 F  S X=$O(^AMHRPRO("AD",V,X)) Q:X'=+X!(G]"")  S Y=$P($G(^AMHRPRO(X,0)),U) D
 ..Q:'Y
 ..S Y=$P($G(^AMHPROB(Y,0)),U)
 ..S I=$O(^ICD9("B",Y,0))
 ..Q:'$$ICD^ATXCHK(I,TIEN,9)
 ..S G=$P($P(^AMHREC(V,0),U),".")_"^BH DX: "_Y_"^"_$$VAL^XBDIQ1(9002011.01,X,.04)_"^^9002011.01^"_X
 I F="D" Q $P(G,U)
 Q G
 ;
LASTBHED(P,BD,ED,C,F) ;EP - find date of last BH EDUC of C, return date in fileman format
 NEW G,Y,V,D,E,X
 S G=""
 S E=9999999-BD,D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(G]"")  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(G]"")  D
 .Q:'$D(^AMHREC(V,0))
 .S X=0 F  S X=$O(^AMHREDU("AD",V,X)) Q:X'=+X!(G]"")  S Y=$P($G(^AMHREDU(X,0)),U) D
 ..Q:'Y
 ..S Y=$P($G(^AUTTEDT(Y,0)),U,2)
 ..I Y=C S G=$P($P(^AMHREC(V,0),U),".")_"^BH: "_Y_"^"_$$VAL^XBDIQ1(9002011.05,X,.08)_"^^9002011.05^"_X
 I F="D" Q $P(G,U)
 Q G
 ;
LASTDXT(P,BD,ED,T,F) ;EP
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW A,B,C,D,E,TIEN,R,I
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S R=""  ;return value
 S B=9999999-BD,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1 F  S D=$O(^AUPNVPOV("AA",P,D)) Q:D=""!(D>B)!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVPOV("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S C=$P($G(^AUPNVPOV(I,0)),U)
 ..Q:C=""  ;bad xref
 ..Q:'$D(^ICD9(C))
 ..I TIEN Q:'$$ICD^ATXCHK(C,TIEN,9)
 ..S R=(9999999-D)_"^DX: "_$P($$ICDDX^ICDCODE(C,(9999999-D)),U,2)_"^"_$$VAL^XBDIQ1(9000010.07,I,.04)_"^"_$P(^AUPNVPOV(I,0),U,3)_"^9000010.07^"_I
 ..Q
 .Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
 ;
LASTPRCT(P,BD,ED,T,F) ;EP
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW A,B,C,D,E,TIEN,R,I
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S R=""  ;return value
 S B=9999999-BD,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1 F  S D=$O(^AUPNVPRC("AA",P,D)) Q:D=""!(D>B)!(R]"")  D
 .S I=0 F  S I=$O(^AUPNVPRC("AA",P,D,I)) Q:I'=+I!(R]"")  D
 ..S C=$P($G(^AUPNVPRC(I,0)),U)
 ..Q:C=""  ;bad xref
 ..Q:'$D(^ICD0(C))
 ..I TIEN Q:'$$ICD^ATXCHK(C,TIEN,0)
 ..S R=(9999999-D)_"^DX: "_$P($$ICDOP^ICDCODE(C,(9999999-D)),U,2)_"^"_$$VAL^XBDIQ1(9000010.08,I,.04)_"^"_$P(^AUPNVPRC(I,0),U,3)_"^9000010.08^"_I
 ..Q
 .Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
 ;
LASTCPTT(P,BD,ED,T,F) ;EP
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW A,B,C,D,E,TIEN,R,I,V
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S R=""  ;return value
 S B=9999999-BD,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=(E-1)_.9999 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!($P(D,".")>B)!(R]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))  ;no cpts
 ..S I=0 F  S I=$O(^AUPNVCPT("AD",V,I)) Q:I'=+I!(R]"")  D
 ...S C=$P($G(^AUPNVCPT(I,0)),U)
 ...Q:C=""  ;bad xref
 ...Q:'$D(^ICPT(C))
 ...I TIEN Q:'$$ICD^ATXCHK(C,TIEN,1)
 ...S R=(9999999-$P(D,"."))_"^CPT: "_$P($$CPT^ICPTCOD(C,(9999999-$P(D,"."))),U,2)_"^"_$P($$CPT^ICPTCOD(C,(9999999-$P(D,"."))),U,3)_"^"_$P(^AUPNVCPT(I,0),U,3)_"^9000010.18^"_I
 ..Q
 .Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
 ;
LASTCPTI(P,BD,ED,T,F) ;EP
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW A,B,C,D,E,TIEN,R,I
 I T="" Q ""
 F A=1:1 S B=$P(T,";",A) Q:B=""  S C=$P($$CPT^ICPTCOD(B),U,1) I C'=-1,C S TIEN(C)=""
 I '$D(TIEN) Q ""
 S R=""  ;return value
 S B=9999999-BD,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=(E-1)_".9999" F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!($P(D,".")>B)!(R]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVCPT("AD",V))  ;no cpts
 ..S I=0 F  S I=$O(^AUPNVCPT("AD",V,I)) Q:I'=+I!(R]"")  D
 ...S C=$P($G(^AUPNVCPT(I,0)),U)
 ...Q:C=""  ;bad xref
 ...Q:'$D(^ICPT(C))
 ...Q:'$D(TIEN(C))
 ...S R=(9999999-$P(D,"."))_"^CPT: "_$P($$CPT^ICPTCOD(C,(9999999-$P(D,"."))),U,2)_"^"_$P($$CPT^ICPTCOD(C,(9999999-$P(D,"."))),U,3)_"^"_$P(^AUPNVCPT(I,0),U,3)_"^9000010.18^"_I
 ..Q
 .Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
 ;
LASTBHME(P,BD,ED,C,F) ;EP - find date of last BH MEASUREMENT of C, return date in fileman format
 NEW G,Y,V,D,E,X
 S G=""
 S E=9999999-BD,D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(G]"")  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(G]"")  D
 .Q:'$D(^AMHREC(V,0))
 .S X=0 F  S X=$O(^AMHRMSR("AD",V,X)) Q:X'=+X!(G]"")  S Y=$P($G(^AMHRMSR(X,0)),U) D
 ..Q:'Y
 ..S Y=$P($G(^AUTTMSR(Y,0)),U,1)
 ..I Y=C S G=$P($P(^AMHREC(V,0),U),".")_"^BH: "_Y_"^"_$$VAL^XBDIQ1(9002011.12,X,.04)_"^^9002011.12^"_X
 I F="D" Q $P(G,U)
 Q G
 ;
LASTLAB(P,BD,ED,I,T,LO,LT,F,LTN) ;EP P is patient, I is ien of lab test, T is IEN of lab taxonomy, LO is ien of loinc code,  LT is ien o f loinc taxonmy
 ;now get all loinc/taxonomy tests
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 S I=$G(I)
 S LO=$G(LO)
 S LT=$G(LT)
 S LTN=$G(LTN)
 NEW R,D,L,X,B,E,J
 S R="",B=9999999-BD,E=9999999-ED
 S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!($P(D,".")>B)!(R]"")  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L!(R]"")  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X!(R]"")  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I $G(I),L=I S R=$$LABR(X,D) Q
 ...I $G(T),$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(T,21,"B",$P(^AUPNVLAB(X,0),U))) S R=$$LABR(X,D) Q
 ...I LTN]"",$P(^LAB(60,$P(^AUPNVLAB(X,0),U),0),U)=LTN S R=$$LABR(X,D) Q
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,$G(LT),$G(LO))
 ...S R=$$LABR(X,D)
 ...Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
 ;
LABR(X,D) ;
 Q (9999999-D)_"^LAB: "_$$VAL^XBDIQ1(9000010.09,X,.01)_"^"_$P(^AUPNVLAB(X,0),U,4)_"^"_$P(^AUPNVLAB(X,0),U,3)_"^9000010.09^"_X
 ;
LOINC(A,LT,LI) ;
 I '$G(LT),'$G(LI) Q ""  ;no ien or taxonomy
 S LI=$G(LI)
 I A,LI,A=LI Q 1
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",LT,$D(^ATXAX(LT,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(LT,21,"B",%)) Q 1
 Q ""
 ;
LASTRADT(P,BD,ED,T,F) ;EP
 I '$G(P) Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW A,B,C,D,E,TIEN,R,I,J,K
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S R=""  ;return value
 S B=9999999-BD,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1 F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!($P(D,".")>B)!(R]"")  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V!(R]"")  D
 ..Q:'$D(^AUPNVSIT(V,0))
 ..Q:'$D(^AUPNVRAD("AD",V))  ;no cpts
 ..S I=0 F  S I=$O(^AUPNVRAD("AD",V,I)) Q:I'=+I!(R]"")  D
 ...S C=$P($G(^AUPNVRAD(I,0)),U),J=$P($G(^RAMIS(71,+C,0)),U,9)
 ...Q:C=""  ;bad xref
 ...Q:J=""  ;no cpt code
 ...Q:'$D(^ICPT(J))
 ...I TIEN Q:'$$ICD^ATXCHK(J,TIEN,1)
 ...S R=(9999999-$P(D,"."))_"^RADIOLOGY: "_$P(^RAMIS(71,C,0),U)_" - "_$P($$CPT^ICPTCOD(J,(9999999-$P(D,"."))),U,2)_"^^"_$P(^AUPNVRAD(I,0),U,3)_"^9000010.22^"_I
 ..Q
 .Q
 I R="" Q ""
 I F="D" Q $P(R,U)
 Q R
 ;
LASTBHCT(P,BD,ED,T,F) ;EP - find date of last BH CPT of TAXONOMY T
 I $G(P)="" Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(F)="" S F="D"
 S T=$G(T)
 NEW TIEN,G,Y,V,E,X,I
 S TIEN="" I T]"" S TIEN=$O(^ATXAX("B",T,0))  ;get taxonomy ien
 I TIEN="" Q ""
 S G=""
 S E=9999999-BD,D=9999999-ED-1_".99" F  S D=$O(^AMHREC("AE",P,D)) Q:D'=+D!($P(D,".")>E)!(G]"")  S V=0 F  S V=$O(^AMHREC("AE",P,D,V)) Q:V'=+V!(G]"")  D
 .Q:'$D(^AMHREC(V,0))
 .S X=0 F  S X=$O(^AMHRPROC("AD",V,X)) Q:X'=+X!(G]"")  S Y=$P($G(^AMHRPROC(X,0)),U) D
 ..Q:'Y
 ..Q:'$$ICD^ATXCHK(Y,TIEN,1)
 ..S G=$P($P(^AMHREC(V,0),U),".")_"^BH CPT: "_$P(^ICPT(Y,0),U)_"^"_$$VAL^XBDIQ1(9002011.04,X,.04)_"^^9002011.04^"_X
 I F="D" Q $P(G,U)
 Q G
 ;
ALLV(P,BD,ED,A,SC,CL) ;EP
 I '$G(P) Q
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(A)="" Q
 S SC=$G(SC)
 S CL=$G(CL)
 NEW B,C,D,V,E
 S B=9999999-BD,C=0,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1,D=D_".9999" F  S D=$O(^AUPNVSIT("AA",P,D)) Q:D=""!($P(D,".")>B)  D
 .S V=0 F  S V=$O(^AUPNVSIT("AA",P,D,V)) Q:V'=+V  D
 ..I SC]"",$P(^AUPNVSIT(V,0),U,7)'=SC Q
 ..I CL,$P(^AUPNVSIT(V,0),U,8)'=CL Q
 ..S C=C+1
 ..S @A@(C)=(9999999-$P(D,"."))_"^^VISIT^^"_V
 ..Q
 .Q
 Q
ALLLAB(P,BD,ED,T,LT,LN,A) ;EP
 ;P - patient
 ;BD - beginning date
 ;ED - ending date
 ;T - lab taxonomy
 ;LT - loinc taxonomy
 ;LN - lab test name
 ;return all lab tests that match in array A
 ;FORMAT:  DATE^TEST NAME^RESULT^V LAB IEN^VISIT IEN
 I '$G(LT) S LT=""
 S LN=$G(LN)
 S T=$G(T)
 NEW D,V,G,X,J,B,E,C
 S B=9999999-BD,C=0,E=9999999-ED  ;get inverse date and begin at edate-1 and end when greater than begin date
 S D=E-1,D=D_".9999" S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!($P(D,".")>B)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y  D
 ...I 'T,'LT,LN="" D SETLAB Q
 ...I T,$D(^ATXLAB(T,21,"B",X)) D SETLAB Q
 ...I LN]"",$$VAL^XBDIQ1(9000010.09,Y,.01)=LN D SETLAB Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...D SETLAB Q
 ...Q
 ..Q
 .Q
 Q
SETLAB ;
 S C=C+1
 S @A@(C)=(9999999-$P(D,"."))_"^"_$$VAL^XBDIQ1(9000010.09,Y,.01)_"^"_$$VAL^XBDIQ1(9000010.09,Y,.04)_"^"_Y_"^"_$P(^AUPNVLAB(Y,0),U,3)
 Q
