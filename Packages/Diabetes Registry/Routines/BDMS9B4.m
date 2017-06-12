BDMS9B4 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ; 27 Jan 2011  6:58 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4,8,9**;JUN 14, 2007;Build 78
 ;
 ;
FRSTDMDX(P,F) ;EP return date of first dm dx
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW X,E,BDMS,Y
 S Y="BDMS("
 S X=P_"^FIRST DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,Y) S Y=$P($G(BDMS(1)),U)
 Q $S(F="E":$$DATE^BDMS9B1(Y),1:Y)
CMSFDX(P,F) ;EP - return date/dx of dm in register
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R  I N["DIAB" D
 .S (G,X)=0,(Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X  I $P(^ACM(44,X,0),U,4)=R D
 ..S D=$P($G(^ACM(44,X,"SV")),U,2) I D]"" S D(D)=""
 S D=$O(D(0)) I D]"" S D=$S(F="E":$$DATE^BDMS9B1(D),1:D)
 Q $G(D)
 ;
CMSFDXR(P,F) ;EP - return date/dx of dm in register
 I $G(F)="" S F="E"
 I '$G(P) Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R  I N["DIAB" D
 .S (G,X)=0,(Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X  I $P(^ACM(44,X,0),U,4)=R D
 ..S D=$P($G(^ACM(44,X,"SV")),U,2) I D]"" S D(D)=N
 S D=$O(D(0)) I D]"" S D=D(D)
 Q $G(D)
PLDMDOO(P,F) ;EP get first dm dx from case management
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^BDMUTL(I,"SURVEILLANCE DIABETES",9) D  Q
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 .I $P($G(^AUPNPROB(X,800)),U,1)]"",$$SNOMED^BDMUTL(2016,"DIABETES DIAGNOSES",$P(^AUPNPROB(X,800),U,1)) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 S D=$O(D(0))
 I D="" Q D
 Q $S(F="E":$$DATE^BDMS9B1(D),1:D)
DNKA(V) ;EP is this a DNKA visit?
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D=".0860" Q 1
 S N=$$PRIMPOV^APCLV(V,"N")
 I $E(D)="V",N["DNKA" Q 1
 I $E(D)="V",N["DID NOT KEEP APPOINTMENT" Q 1
 I $E(D)="V",N["DID NOT KEEP APPT" Q 1
 Q 0
 ;
ACE(P,D) ;EP - return date of last ACE iNHIBITOR
 ;go through all v meds until 9999999-D and find all drugs with class CV800 or CV805
 ;if none found check taxonomy
 I '$G(P) Q ""
 I '$G(D) S D="" ;if don't pass date look at all time
 NEW BDMSMEDS
 K BDMSMEDS
 D GETMEDS^BDMSMU1(P,D,,"DM AUDIT ACE INHIBITORS",,"DM AUDIT ACE INHIB CLASS",,.BDMSMEDS)
 ;GET THE LAST ONE
 NEW BDMSMED,X,%,Z,V,C
 I '$D(BDMSMEDS) Q "No"
 S X=0,C=0 F  S X=$O(BDMSMEDS(X)) Q:X'=+X  S C=X
 S %=+$P(BDMSMEDS(C),U,4)
 S V=$P(BDMSMEDS(C),U,5)  ;last one
 I $P(^AUPNVMED(%,0),U,8)="" S %="Yes  "_$$DATE^BDMS9B1($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q %
 I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued  "_$$DATE^BDMS9B1($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),"."))_" "_$$VAL^XBDIQ1(9000010.14,%,.01) Q %
 Q "No"
 ;
ASPREF(P) ;EP - CHECK FOR ASPIRIN NMI OR REFUSAL
 I '$G(P) Q ""
 NEW X,N,Z,D,IEN,DATE,DRUG
 K X
 S T=$O(^ATXAX("B","DM AUDIT ASPIRIN DRUGS",0))
 I 'T Q ""
 S (D,G)=0 F  S D=$O(^AUPNPREF("AA",P,50,D)) Q:D'=+D!(G)  D
 .Q:'$D(^ATXAX(T,21,"B",D))
 .S X=$O(^AUPNPREF("AA",P,50,D,0))
 .S N=$O(^AUPNPREF("AA",P,50,D,X,0))
 .S G=1,DATE=9999999-X,DRUG=D,IEN=N
 I 'G Q ""
 Q $E($$VAL^XBDIQ1(50,DRUG,.01),1,30)_" "_$$TYPEREF^BDMSMU(IEN)_" on "_$$DATE^BDMS9B1(DATE)
PNEU(P) ;EP
 NEW BDMY,PNEU,X,G,Z,R,Y,%,PNEU1,PNEU2
 S PNEU1=$$LASTPNEU(P,,,"A")
 S PNEU2=$$LASTPNEU(P,,$$FMADD^XLFDT($P(PNEU1,U),-1),"A")
 I PNEU1]"" Q "Yes  "_$$DATE^BDMS9B1($P(PNEU1,U))_"   "_$$DATE^BDMS9B1($P(PNEU2,U))
 S R="",G="" F R=33,109 Q:R=""!(G)  D
 .S G=$$REFUSAL^BDMDD17(P,9999999.14,$O(^AUTTIMM("C",R,0)),$$DOB^AUPNPAT(P),DT,"R")
 I G Q "Refused "_$P(G,U,3)
 ;; BI REFUSALS
 S G="" F Z=33,109 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .S G=1_U_D
 I G Q "Refused "_$$DATE^BDMS9B1($P(G,U,2))
 S G="",Z="" F Z=33,109 Q:Z=""!(G]"")  S G=$$PNEUCONT(P,Z,$$DOB^AUPNPAT(P),DT)
 I G]"" Q G
 Q "No"
PNEUCONT(P,C,BD,ED) ;EP
 NEW X,G,Y,R,D
 S X=0,G="",Y=$O(^AUTTIMM("C",C,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .S D=$P(^BIPC(X,0),U,4)
 .Q:$P(^BIPC(X,0),U,4)>ED
 .I $P(^BICONT(R,0),U,1)="Anaphylaxis" S G="Contraindication: Anaphylaxis "_$$DATE^BDMS9B1(D)
 Q G
PPD(P) ;EP
 NEW BDMY,Y,X,%,E,BDMV
 S BDMV=""
 S %=P_"^LAST SKIN PPD",E=$$START1^APCLDF(%,"BDMY(")
 S E="" I $D(BDMY(1)) S BDMV=$P(BDMY(1),U)_U_$P(^AUPNVSK(+$P(BDMY(1),U,4),0),U,5)_U_$$VAL^XBDIQ1(9000010.12,+$P(BDMY(1),U,4),.04)_U_" PPD"      ;$P(^AUPNVSK(+$P(BDMY(1),U,4),0),U,5)_"     "_$$DATE^BDMS9B1($P(BDMY(1),U))
 K BDMY
 S X=P_"^LAST LAB [DM AUDIT TB LAB TESTS" S E=$$START1^APCLDF(X,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U,1)>$P(BDMV,U,1) S BDMV=$P(BDMY(1),U)_U_U_$P(^AUPNVLAB(+$P(BDMY(1),U,4),0),U,4)_U_$$VAL^XBDIQ1(9000010.09,+$P(BDMY(1),U,4),.01)
 ;K BDMY S X=P_"^LAST DX V74.1" S E=$$START1^APCLDF(X,"BDMY(")
 ;I $D(BDMY(1)),$P(BDMY(1),U,1)>$P(BDMV,U,1) S BDMV=$P(BDMY(1),U,1)_U_U_U_" (by Diagnosis) V74.1"  ; Q $$DATE^BDMS9B1($P(BDMY(1),U))_"  (by Diagnosis)"
 I BDMV]"" Q $P(BDMV,U,4)_"  "_$P(BDMV,U,2)_"  "_$P(BDMV,U,3)_"  "_$$DATE^BDMS9B1($P(BDMV,U,1))
 S G=$$REFUSAL^BDMDD17(P,9999999.28,$O(^AUTTSK("B","PPD",0)),$$DOB^AUPNPAT(P),DT,"R")
 I G Q G
 Q ""
PPDS(P) ;EP
 ;check for tb health factor, problem list, povs if and
 ;indication of pos ppd then return "Known Positive PPD"
 NEW BDMS,E,X
 K BDMS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS) Q "Known Positive PPD or Hx of TB (Health Factor)"
PPDSPL ;CHECK PL
 N T S T="DM AUDIT TUBERCULOSIS DXS"
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^BDMUTL(Y,T,9) S I=1
 I I Q "Known Positive PPD or Hx of TB (Problem List DX)"
 ;check povs
 K BDMS S X=P_"^FIRST DX [DM AUDIT TUBERCULOSIS DXS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS(1)) Q "Known Positive PPD or Hx of TB (POV/DX "_$$DATE^BDMS9B1($P(BDMS(1),U))_")"
 Q ""
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
LASTPNEU(BDMPDFN,BDMBD,BDMED,BDMFORM) ;PEP - date of last PNEUMOVAX
 ; 
 I $G(BDMPDFN)="" Q ""
 I $G(BDMBD)="" S BDMBD=$$DOB^AUPNPAT(BDMPDFN)
 I $G(BDMED)="" S BDMED=DT
 I $G(BDMFORM)="" S BDMFORM="D"
 NEW BDMLAST,BDMVAL,BDMX,R,X,Y,V,E,T,G,BDMY,BDMF
 S BDMLAST=""
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"33","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"100","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"109","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"133","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"152","IMMUNIZATION",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"V03.82","DX",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTCPTT^APCLAPIU(BDMPDFN,$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"BGP PNEUMO IZ CPTS","A")
 D E
 I BDMFORM="D" Q $P(BDMLAST,U)
 Q BDMLAST
 ;
E ;
 I $P(BDMVAL,U,1)>$P(BDMLAST,U,1) S BDMLAST=BDMVAL
 Q
 ;
 ;
MAMREF(P,LMAM) ;EP
 NEW G,BDMY,I,D,X,C,LAST
 S G="",LAST=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,71,I)) Q:I'=+I   D
 .S C=$P($G(^RAMIS(71,I,0)),U,9)
 .Q:C=""
 .Q:'$$ICD^BDMUTL(C,$O(^ATXAX("B","BGP CPT MAMMOGRAM",0)),1)
 .S D=$O(^AUPNPREF("AA",P,71,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Mammogram ("_C_") on "_$$DATE^BDMS9B1(D)
 ;now check cpt refusals
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I'=+I   D
 .S C=I
 .Q:'$$ICD^BDMUTL(C,$O(^ATXAX("B","BGP CPT MAMMOGRAM",0)),1)
 .S D=$O(^AUPNPREF("AA",P,81,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Mammogram ("_C_") on "_$$DATE^BDMS9B1(D)
 ;now check PROC refusals
 S I=0 F  S I=$O(^AUPNPREF("AA",P,80.1,I)) Q:I'=+I   D
 .S C=I
 .S C=$P($G(^ICD0(C,0)),U,1)
 .I C'=87.36,C'=87.37 Q
 .S D=$O(^AUPNPREF("AA",P,80.1,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Mammogram ("_C_") on "_$$DATE^BDMS9B1(D)
 Q $G(LAST)
 ;
PAP(P) ;EP
 Q $$LASTPAP^APCLAPI1(P,,,"A")
