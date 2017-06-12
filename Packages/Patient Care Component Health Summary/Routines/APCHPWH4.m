APCHPWH4 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;
 ;;2.0;IHS PCC SUITE;**3,6,7,11**;MAY 14, 2009;Build 58
 ;
 ;EO MEASURES IN PWH
EO ;EP - EO measures
 Q  ;;PLEASE NOTE THIS COMPONENT IS BEING DISABLE, I DIDN'T DELETE IT SINCE IT MAY BE
 ;;POINTED TO BUT NOTHING WILL DISPLAY
 I '$O(^APCHPWHT(APCHPWHT,1,APCHSORD,11,0)) Q  ;no measures defined
 NEW APCHSTO,APCHSTM,APCHSTCE
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("QUALITY OF CARE TRANSPARENCY REPORT CARD - This report looks at")
 D S^APCHPWH1("6 quality measures.  This report card enables you to compare your")
 D S^APCHPWH1("personal results to those on the IHS Quality of Care website at:")
 D S^APCHPWH1("http://www.ihs.gov/NonMedicalPrograms/quality/.  Your personal ")
 D S^APCHPWH1("information is listed below.")
 ;
 ;go through each one
 S APCHSTO=0 F  S APCHSTO=$O(^APCHPWHT(APCHPWHT,1,APCHSORD,11,APCHSTO)) Q:APCHSTO'=+APCHSTO  D
 .S APCHSTM=$P($G(^APCHPWHT(APCHPWHT,1,APCHSORD,11,APCHSTO,0)),U,2)
 .Q:'APCHSTM
 .Q:'$D(^APCHPWHE(APCHSTM,0))
 .S APCHSTCE=$G(^APCHPWHE(APCHSTM,1))
 .I APCHSTCE="" Q
 .X APCHSTCE
 .Q
 Q
 ;
DGC ;EP - diabetes and glycemic control
 NEW APCHX
 Q:$$AGE^AUPNPAT(APCHSDFN,DT)<18
 D S^APCHPWH1("Diabetes and Glycemic (A1c) Control",1)
 I '$$DMDX^APCHPWH2(APCHSDFN) D  Q
 .D S^APCHPWH1("This section only reports on people who have diabetes.  You do not")
 .D S^APCHPWH1("have diabetes, so you are not included in this report.")
 .Q
 S APCHX=$$HGBA1C(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT)  ;365 days ago
 I APCHX="" D  K APCHX Q
 .D S^APCHPWH1("Your A1c was not checked in the past year.  We recommend that you have ")
 .D S^APCHPWH1("your A1c checked at least twice a year.")
 .Q
 I $P(APCHX,U,2)="" D  Q
 .D S^APCHPWH1("Your A1c was checked on "_$P(APCHX,U)_" but there is no result on file. We")
 .D S^APCHPWH1("recommend that you ask your provider about your A1c value.")
 D S^APCHPWH1("Your A1c value on "_$P(APCHX,U)_" was "_$P(APCHX,U,2)_".  An A1c")
 D S^APCHPWH1("less than 7% means good blood sugar control.  An A1c of more than 9% means")
 D S^APCHPWH1("that you may need better blood sugar control.")
 Q
HGBA1C(P,BDATE,EDATE,APCHRR) ;EP - get result of HGBA1c in past year.  If no result pass null
 ;pass back date_u_result
 S APCHRR=$G(APCHRR)
 I $G(BDATE)="" S BDATE=$$DOB^AUPNPAT(P)
 I $G(EDATE)="" S EDATE=DT
 NEW APCHG,APCHT,APCHC,E,%,L,T,APCHLT,D,X,J,C,G
 S APCHC=0
 I 'APCHRR S G=$$LASTCPTT^APCLAPIU(P,BDATE,EDATE,"BGP HGBA1C CPTS","A") I G]"" S APCHC=APCHC+1,APCHT((9999999-$P(G,U,1)),APCHC)=U_$P(G,U,2)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP HGBA1C LOINC CODES",0))
 S APCHLT=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I APCHRR,$P(^AUPNVLAB(X,0),U,4)="" Q
 ...I APCHRR,$$UP^XLFSTR($P(^AUPNVLAB(X,0),U,4))="COMMENT" Q
 ...I APCHLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHLT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHC=APCHC+1,APCHT(D,APCHC)=$P(^AUPNVLAB(X,0),U,4)_U_"LAB: "_$$VAL^XBDIQ1(9000010.09,X,.01) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S APCHC=APCHC+1,APCHT(D,APCHC)=$P(^AUPNVLAB(X,0),U,4)_U_"LAB LOINC: "_$$VAL^XBDIQ1(9000010.09,X,.01)_" "_$P(^AUPNVLAB(X,11),U,13)
 ...Q
 I '$D(APCHT) Q ""  ;no tests
 ; now get rid of all on same day where 1 has a result and the other doesn't
 S D=0,APCHC=0 F  S D=$O(APCHT(D)) Q:D'=+D  S C=0,G=0 F  S C=$O(APCHT(D,C)) Q:C'=+C  D
 .I $P(APCHT(D,C),U,1)]"" S APCHC=APCHC+1
 .I APCHC>0,$P(APCHT(D,C),U,1)="" K APCHT(D,C)
 S D=0,G=""
 S D=$O(APCHT(D))
 S C=0,C=$O(APCHT(D,C))
 S X=$P(APCHT(D,C),U,1)
 I X="",$G(APCHRR) Q ""
 I X="" D  Q G
 .S G=""
 .I $P(APCHT(D,C),U,2)="CPT: 3046F" S G=$$FMTE^XLFDT(9999999-D)_U_">9.0%"_U_(9999999-D) Q
 .I $P(APCHT(D,C),U,2)="CPT: 3047F" S G=$$FMTE^XLFDT(9999999-D)_U_"<= 9.0%"_U_(9999999-D) Q
 .I $P(APCHT(D,C),U,2)="CPT: 3044F" S G=$$FMTE^XLFDT(9999999-D)_U_"< 7.0%"_U_(9999999-D) Q
 .I $P(APCHT(D,C),U,2)="CPT: 3045F" S G=$$FMTE^XLFDT(9999999-D)_U_"7.0-9.0%"_U_(9999999-D) Q
 .Q
 Q $$FMTE^XLFDT((9999999-D))_U_X_U_(9999999-D)
 ;
DLDL ;EP - LDL
 NEW APCHX
 Q:$$AGE^AUPNPAT(APCHSDFN,DT)<18
 D S^APCHPWH1("Diabetes and LDL Control",1)
 I '$$DMDX^APCHPWH2(APCHSDFN) D  Q
 .D S^APCHPWH1("This section only reports on people who have diabetes.  You do not")
 .D S^APCHPWH1("have diabetes, so you are not included in this report.")
 .Q
 S APCHX=$$LDL(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT,1)  ;365 days ago
 I APCHX="" D  K APCHX Q
 .D S^APCHPWH1("Your LDL was not checked in the past year.  We recommend that you have ")
 .D S^APCHPWH1("your LDL checked at least once a year.")
 .Q
 D S^APCHPWH1("Your LDL value on "_$$FMTE^XLFDT($P(APCHX,U))_" was "_$P(APCHX,U,2)_$S($P(APCHX,U,3)]"":" "_$P(APCHX,U,3),1:"")_".  An LDL less than 100 mg/dl")
 D S^APCHPWH1("is good.  Sometimes it is better to have a lower LDL value.  Talk to your")
 D S^APCHPWH1("health care provider about an LDL value that is good for you.")
 Q
 ;
LDL(P,BDATE,EDATE,NORES) ;EP
 NEW APCHG,APCHT,APCHC,APCHLT,T,B,E,D,L,X,R,G,C,%
 K APCHG,APCHT,APCHC
 S APCHC=0
 S NORES=$G(NORES)
 ;now get all loinc/taxonomy tests
 S T=$O(^ATXAX("B","BGP LDL LOINC CODES",0))
 S APCHLT=$O(^ATXLAB("B","DM AUDIT LDL CHOLESTEROL TAX",0))
 S B=9999999-BDATE,E=9999999-EDATE S D=E-1 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(D>B)  D
 .S L=0 F  S L=$O(^AUPNVLAB("AE",P,D,L)) Q:L'=+L  D
 ..S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,L,X)) Q:X'=+X  D
 ...Q:'$D(^AUPNVLAB(X,0))
 ...I $G(NORES) Q:$P(^AUPNVLAB(X,0),U,4)=""
 ...S R=$P(^AUPNVLAB(X,0),U,4)
 ...I $G(NORES),'R Q
 ...I $G(NORES),$$UP^XLFSTR(X)["COMMENT" Q
 ...I APCHLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHLT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHC=APCHC+1,APCHT(D,APCHC)=$P(^AUPNVLAB(X,0),U,4)_U_$P($G(^AUPNVLAB(X,11)),U,1) Q
 ...Q:'T
 ...S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,T)
 ...S R=$P(^AUPNVLAB(X,0),U,4)
 ...S APCHC=APCHC+1,APCHT(D,APCHC)=R_U_$P($G(^AUPNVLAB(X,11)),U,1)
 ...Q
 ; now got though and set return value of done 1 or 0^VALUE^date
 S D=0,G="" F  S D=$O(APCHT(D)) Q:D'=+D!(G]"")  D
 .S C=0 F  S C=$O(APCHT(D,C)) Q:C'=+C!(G]"")  D
 ..S X=$P(APCHT(D,C),U)
 ..S G=(9999999-D)_U_X_U_$P(APCHT(D,C),U,2)
 ..Q
 Q G
 ;
LOINC(A,B) ;EP
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
DBP ;EP
 Q:$$AGE^AUPNPAT(APCHSDFN,DT)<18
 NEW APCHX
 D S^APCHPWH1("Diabetes and BP Control",1)
 I '$$DMDX^APCHPWH2(APCHSDFN) D  Q
 .D S^APCHPWH1("This section only reports on people who have diabetes.  You do not")
 .D S^APCHPWH1("have diabetes, so you are not included in this report.")
 .Q
 S APCHX=$$LASTITEM^APCLAPIU(APCHSDFN,"BP","MEASUREMENT",$$FMADD^XLFDT(DT,-365),DT,"A")
 I APCHX="" D  K APCHX Q
 .D S^APCHPWH1("Your Blood Pressure was not checked in the past year.  We recommend that")
 .D S^APCHPWH1("you have your Blood Pressure checked at least three times a year.")
 .Q
 D S^APCHPWH1("Your Blood Pressure on "_$$FMTE^XLFDT($P(APCHX,U))_" was "_$P(APCHX,U,3)_".  A blood pressure that is")
 D S^APCHPWH1("less than or equal to 140/90 is good for some people.  If you have diabetes")
 D S^APCHPWH1("or kidney problems, you may want your blood pressure to be less than 130/80.")
 D S^APCHPWH1("Talk to your health care provider about a blood pressure that is good for you.")
 Q
 ;
FLU ;EP - FLU
 NEW APCHX
 D S^APCHPWH1("Flu Shot (Influenza) Vaccine",1)
 I $$AGE^AUPNPAT(APCHSDFN,DT)<50 D  Q
 .D S^APCHPWH1("This section only reports on people who are 50 years of age or older.")
 .D S^APCHPWH1("You are younger than 50, so you are not included in this report.")
 .Q
 S APCHX=$$LASTFLU^APCLAPI4(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT,"A")
 I APCHX="" D  K APCHX Q
 .D S^APCHPWH1("You did not have a flu shot this year.  We recommend that you have a flu shot")
 .D S^APCHPWH1("every year.")
 .Q
 D S^APCHPWH1("You had your flu shot on "_$$FMTE^XLFDT($P(APCHX,U))_".  We recommend that you have a ")
 D S^APCHPWH1("flu shot every year.")
 Q
 ;
O2 ;EP - OXYGEN ASSESSMENT
 NEW APCHX,X,Y
 I $$AGE^AUPNPAT(APCHSDFN,DT)<18 D  Q
 .D S^APCHPWH1("")
 D S^APCHPWH1("Assessment of Oxygen Status",1)
 D PNEUOX(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT,.APCHX)
 ;
 I 'APCHX("DENOM")!($$AGE^AUPNPAT(APCHSDFN,DT)<18) D  Q
 .D S^APCHPWH1("This section only reports on people who came to the clinic or emergency")
 .D S^APCHPWH1("room with pneumonia.  You did not come to the clinic this year with")
 .D S^APCHPWH1("pneumonia so you are not included in this report.")
 .Q
 S X=0 F  S X=$O(APCHX(X)) Q:X'=+X  D
 .S Y=$$FMTE^XLFDT($P(APCHX(X),U,3))
 .D S^APCHPWH1("You came to the hospital with pneumonia on "_Y_".  The goal is to have",1)
 .D S^APCHPWH1("your oxygen level checked within 24 hours of your hospital visit.  Your")
 .D S^APCHPWH1("oxygen level was "_$S($P(APCHX(X),U,2)["NOT MET":"not ",1:"")_"checked within 24 hours of your hospital visit.")
 Q
 ;
PNEUOX(P,BDATE,EDATE,APCHR) ;EP
 NEW A,B,C,D,E,F,G,APCHG,APCHX,APCHD,APCHV,APCHC
 K APCHG,APCHR
 S APCHR="",APCHR(0)=""
 S X=P_"^ALL DX [BGP CMS PNEUMONIA;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,"APCHG(")
 I '$D(APCHG(1)) S APCHR("DENOM")=0 Q
 ;now go through and get rid of CHS or service category not A, O, S
 S A=0 F  S A=$O(APCHG(A)) Q:A'=+A  D
 .S V=$P(APCHG(A),U,5)
 .I '$D(^AUPNVSIT(V,0)) K APCHG(A)
 .I $P(^AUPNVSIT(V,0),U,3)="C" K APCHG(A)
 .I "AOS"'[$P(^AUPNVSIT(V,0),U,7) K APCHG(A)
 I '$D(APCHG) S APCHR("DENOM")=0 Q  ;got rid of them all
 ;reorder the diagnoses by visit date
 S A=0 F  S A=$O(APCHG(A)) Q:A'=+A  S V=$P(APCHG(A),U,5),D=$P($P($G(^AUPNVSIT(V,0)),U),"."),APCHX(D,V)=APCHG(A)
 ;now get the first one
 S APCHD=0,APCHC=0 F  S APCHD=$O(APCHX(APCHD)) Q:APCHD'=+APCHD  D
 .S APCHV=0 F  S APCHV=$O(APCHX(APCHD,APCHV)) Q:APCHV'=+APCHV  D
 ..S APCHC=APCHC+1,APCHR(APCHC)=APCHC_") "_$$FMTE^XLFDT(APCHD)_" "_$P(APCHX(APCHD,APCHV),U,2) ;set denominator
 ..S G=$$OXSAT(APCHV)  ; any o2 saturation on this visit?
 ..S $P(APCHR(APCHC),U,2)=APCHC_") "_$P(G,U,1)  ;set numerator column
 ..S $P(APCHR(APCHC),U,3)=APCHD
 ..S $P(APCHR(0),U,$P(G,U,2))=$P(APCHR(0),U,$P(G,U,2))+1
 ..;now delete out all visits that are <46 days difference and all other visits on the same day
 ..S V=APCHV F  S V=$O(APCHX(APCHD,V)) Q:V'=+V  K APCHX(APCHD,V)
 ..S D=APCHD,V=APCHV F  S D=$O(APCHX(D)) Q:D'=+D  D
 ...S V=0 F  S V=$O(APCHX(D,V)) Q:V'=+V  I $$FMDIFF^XLFDT(D,APCHD)<46 K APCHX(D,V)
 S APCHR("DENOM")=APCHC
 Q
 ;
OXSAT(V) ;was there ox sat at the visit
 ;get all O2 measurements on or after admission date
 NEW APCHD,X,N,E,Y,T,D,C,APCHLT,L,J,APCHG,M,M1
 S APCHG=""
 S APCHD=$P($P(^AUPNVSIT(V,0),U),".")
 ;K APCHG S Y="APCHG(",X=P_"^ALL MEAS O2;DURING "_$$FMTE^XLFDT(BD)_"-"_$$FMTE^XLFDT(ED) S E=$$START1^APCLDF(X,Y)
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X!(APCHG]"")  I $$VAL^XBDIQ1(9000010.01,X,.01)="O2",'$P($G(^AUPNVMSR(X,2)),U,1) S APCHG=$$FMTE^XLFDT(APCHD)_" MET O2 SAT^1"
 I APCHG]"" Q APCHG
 ;now check for cpts
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVCPT("AD",V,X)) Q:X'=+X!(APCHG]"")  D
 .Q:'$D(^AUPNVCPT(X,0))
 .S C=$P(^AUPNVCPT(X,0),U)
 .Q:'$$ICD^ATXAPI(C,T,1)
 .S M=$$VAL^XBDIQ1(9000010.18,X,.08)
 .S M1=$$VAL^XBDIQ1(9000010.18,X,.09)
 .I $P(^ICPT(C,0),U)="3028F",(M="1P"!(M="2P")!(M="3P")!(M="4P")!(M="8P")) Q  ;3028f and has modifier
 .I $P(^ICPT(C,0),U)="3028F",(M1="1P"!(M="2P")!(M="3P")!(M="4P")!(M="8P")) Q  ;3028f and has modifier
 .S APCHG=$$FMTE^XLFDT(APCHD)_" MET CPT ["_$P($$CPT^ICPTCOD(C),U,2)_"]^1"
 .Q
 I APCHG]"" Q APCHG
 ;now check v tran
 S T=$O(^ATXAX("B","BGP CMS ABG CPTS",0))
 S X=0 F  S X=$O(^AUPNVTC("AD",V,X)) Q:X'=+X!(APCHG]"")  D
 .Q:'$D(^AUPNVTC(X,0))
 .S C=$P(^AUPNVTC(X,0),U,7)
 .Q:C=""
 .Q:'$$ICD^ATXAPI(C,T,1)
 .S APCHG=$$FMTE^XLFDT(APCHD)_" MET CPT/TRAN ["_$P($$CPT^ICPTCOD(C),U,2)_"]^1"
 .Q
 I APCHG]"" Q APCHG
 ;now check for lab tests
 S T=$O(^ATXAX("B","BGP CMS ABG LOINC",0))
 S APCHLT=$O(^ATXLAB("B","BGP CMS ABG TESTS",0))
 S X=0 F  S X=$O(^AUPNVLAB("AD",V,X)) Q:X'=+X!(APCHG]"")  D
 .Q:'$D(^AUPNVLAB(X,0))
 .I APCHLT,$P(^AUPNVLAB(X,0),U),$D(^ATXLAB(APCHLT,21,"B",$P(^AUPNVLAB(X,0),U))) S APCHG=$$FMTE^XLFDT(APCHD)_" MET "_$$VAL^XBDIQ1(9000010.09,X,.01)_"^1" Q
 .Q:'T
 .S J=$P($G(^AUPNVLAB(X,11)),U,13) Q:J=""
 .Q:'$$LOINC(J,T)
 .S APCHG=$$FMTE^XLFDT(APCHD)_" MET "_$$VAL^XBDIQ1(9000010.09,X,.01)_"^1" Q
 I APCHG]"" Q APCHG
 ;now go get refusals of any of the above
 ;
 S G=$$REFUSAL^APCHSMU(P,9999999.07,$O(^AUTTMSR("B","O2",0)),APCHD,APCHD)
 I G Q $$FMTE^XLFDT(APCHD)_" NOT MET DECLINED O2 SAT^2"
 ;refusal of lab tests
 S T=$O(^ATXLAB("B","BGP CMS ABG TESTS",0))
 S L=0 F  S L=$O(^ATXLAB(T,21,"B",L)) Q:L'=+L!(APCHG]"")  D
 .S G=$$REFUSAL^APCHSMU(P,60,L,APCHD,APCHD)
 .I G S APCHG=$$FMTE^XLFDT(APCHD)_" NOT MET DECLINED LAB^2"
 I APCHG]"" Q APCHG
 S G=$$CPTREFT^APCHSMU(P,APCHD,APCHD,$O(^ATXAX("B","BGP CMS ABG CPTS",0)))
 I G Q $$FMTE^XLFDT(APCHD)_" NOT MET DECLINED CPT^2"
 Q $$FMTE^XLFDT(APCHD)_" NOT MET; NO ASSMT^3"
 ;
