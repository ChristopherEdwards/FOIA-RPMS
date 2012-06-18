BDMS9B4 ; IHS/CMI/LAB - DIABETIC CARE SUMMARY SUPPLEMENT ; 27 Jan 2011  6:58 AM
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**3,4**;JUN 14, 2007
 ;
 ;cmi/anch/maw 8/27/2007 code set versioning in HYSTER, EYE
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
 ;NEW R S R=$O(^ACM(41.1,"B","IHS DIABETES",0)) I 'R Q ""
 NEW R,N,D,D1,Y,X,G S R=0,N="",D="" F  S N=$O(^ACM(41.1,"B",N)) Q:N=""!(D]"")  S R=0 F  S R=$O(^ACM(41.1,"B",N,R)) Q:R'=+R!(D]"")  I N["DIAB" D
 .S (G,X)=0,(D,Y)="" F  S X=$O(^ACM(44,"C",P,X)) Q:X'=+X!(D]"")  I $P(^ACM(44,X,0),U,4)=R D
 ..S D=$P($G(^ACM(44,X,"SV")),U,2) I D]"" S D1=D,D=$S(F="E":$$DATE^BDMS9B1(D),1:D)
 Q $G(D)
 ;
PLDMDOO(P,F) ;EP get first dm dx from case management
 I '$G(P) Q ""
 I $G(F)="" S F="E"
 NEW T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 NEW D,X,I S D="",X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .S I=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(I,T,9) D
 ..I $P(^AUPNPROB(X,0),U,13)]"" S D($P(^AUPNPROB(X,0),U,13))=""
 ..Q
 .Q
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
REFR(V) ;
 I '$G(V) Q ""
 NEW D,N S D=$$PRIMPOV^APCLV(V,"C")
 I D="367.89"!(D="367.9") Q 1
 Q 0
PAP(P,BDMSED) ;EP
 I $$SEX^AUPNPAT(P)'="F" Q "N/A"
 S LPAP=$$LASTPAP^APCLAPI1(P,,,"A")
 S G=$$PAPREF(P,$P($G(LPAP),U,1))
 I G]"" Q $P($G(LPAP),U,1)_"^"_G_"^"_$P(LPAP,U,2)
 Q $P($G(LPAP),U,1)_U_U_$P($G(LPAP),U,2)
 ;
PAPREF(P,LMAM) ;EP
 NEW G,BDMY,I,D,X,C,LAST,T
 S G="",LAST=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,60,I)) Q:I'=+I   D
 .S C=$P($G(LAB(60,I,0)),U,1)
 .I C="PAP SMEAR" S G=1
 .S T=0,T=$O(^ATXLAB("B","BGP PAP SMEAR TAX",0))
 .I T,$D(^ATXLAB(T,21,"B",I)) S G=1
 .Q:'G
 .S D=$O(^AUPNPREF("AA",P,60,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Pap Smear on "_$$DATE^BDMS9B1(D)
 ;now check PROC refusals
 S I=0 F  S I=$O(^AUPNPREF("AA",P,80.1,I)) Q:I'=+I   D
 .S C=I
 .S C=$P($G(^ICD0(C,0)),U,1)
 .I C'=91.46 Q
 .S D=$O(^AUPNPREF("AA",P,80.1,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Pap Smear (91.46) on "_$$DATE^BDMS9B1(D)
 ;now check cpt refusals
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I'=+I   D
 .S C=I
 .Q:'$$ICD^ATXCHK(C,$O(^ATXAX("B","BGP CPT PAP",0)),1)
 .S D=$O(^AUPNPREF("AA",P,81,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Pap Smear ("_$P(^ICPT(C,0),U)_") on "_$$DATE^BDMS9B1(D)
 Q $G(LAST)
 ;
MAMREF(P,LMAM) ;EP
 NEW G,BDMY,I,D,X,C,LAST
 S G="",LAST=""
 S I=0 F  S I=$O(^AUPNPREF("AA",P,71,I)) Q:I'=+I   D
 .S C=$P($G(^RAMIS(71,I,0)),U,9)
 .Q:C=""
 .Q:'$$ICD^ATXCHK(C,$O(^ATXAX("B","BGP CPT MAMMOGRAM",0)),1)
 .S D=$O(^AUPNPREF("AA",P,71,I,0))  ;last date
 .S D=9999999-D
 .I D>$P(LAST,U,1) S LAST=D_U_"Patient Refused a Mammogram ("_C_") on "_$$DATE^BDMS9B1(D)
 ;now check cpt refusals
 S I=0 F  S I=$O(^AUPNPREF("AA",P,81,I)) Q:I'=+I   D
 .S C=I
 .Q:'$$ICD^ATXCHK(C,$O(^ATXAX("B","BGP CPT MAMMOGRAM",0)),1)
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
 I $P(^AUPNVMED(%,0),U,8)="" S %="Yes - "_$$DATE^BDMS9B1($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q %
 I $P(^AUPNVMED(%,0),U,8)]"" S %="Discontinued - "_$$DATE^BDMS9B1($P($P(^AUPNVSIT($P(^AUPNVMED(%,0),U,3),0),U),".")) Q %
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
 NEW BDMY,PNEU,X,G,Z,R,Y,%
 S PNEU1=$$LASTPNEU(P,,,"A")
 S PNEU2=$$LASTPNEU(P,,$$FMADD^XLFDT($P(PNEU1,U),-1),"A")
 I PNEU1]"" Q "Yes  "_$$DATE^BDMS9B1($P(PNEU1,U))_"   "_$$DATE^BDMS9B1($P(PNEU2,U))
 S G=$$REFDF^BDMS9B3(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:33,1:19),0)),$P(PNEU1,U),"PNEUMOVAX (CVX 33)")
 I G]"" Q G
 S G=$$REFDF^BDMS9B3(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:109,1:19),0)),$P(PNEU1,U),"PNEUMOVAX (CVX 109)")
 I G]"" Q G
 S G=$$REFDF^BDMS9B3(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:100,1:19),0)),$P(PNEU1,U),"PNEUMOVAX (CVX 100)")
 I G]"" Q G
 S G=$$REFDF^BDMS9B3(BDMSPAT,9999999.14,$O(^AUTTIMM("C",$S($$BI:133,1:19),0)),$P(PNEU1,U),"PNEUMOVAX (CVX 133)")
 I G]"" Q G
 ;LORI BI REFUSALS
 S G="" F Z=33,100,109,133 Q:G  S X=0,Y=$O(^AUTTIMM("C",Z,0)) I Y F  S X=$O(^BIPC("AC",P,Y,X)) Q:X'=+X!(G)  D
 .S R=$P(^BIPC(X,0),U,3)
 .Q:R=""
 .Q:'$D(^BICONT(R,0))
 .Q:$P(^BICONT(R,0),U,1)'["Refusal"
 .S D=$P(^BIPC(X,0),U,4)
 .Q:D=""
 .;Q:$P(^BIPC(X,0),U,4)<EDATE
 .S G=1_U_D
 I G Q "Refused "_$$DATE^BDMS9B1($P(D,U,2))_"CVX "_Z_" Immunization package"
 Q "No"
PPD(P) ;EP
 NEW BDMY,Y,X,%,E,BDMV
 S BDMV=""
 S %=P_"^LAST SKIN PPD",E=$$START1^APCLDF(%,"BDMY(")
 S E="" I $D(BDMY(1)) S BDMV=$P(BDMY(1),U)_U_$P(^AUPNVSK(+$P(BDMY(1),U,4),0),U,5)_U_$$VAL^XBDIQ1(9000010.12,+$P(BDMY(1),U,4),.04)_U_" PPD"      ;$P(^AUPNVSK(+$P(BDMY(1),U,4),0),U,5)_"     "_$$DATE^BDMS9B1($P(BDMY(1),U))
 K BDMY
 S X=P_"^LAST LAB [DM AUDIT TB LAB TESTS" S E=$$START1^APCLDF(X,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U,1)>$P(BDMV,U,1) S BDMV=$P(BDMY(1),U)_U_U_$P(^AUPNVLAB(+$P(BDMY(1),U,4),0),U,4)_U_$$VAL^XBDIQ1(9000010.09,+$P(BDMY(1),U,4),.01)
 K BDMY S X=P_"^LAST DX V74.1" S E=$$START1^APCLDF(X,"BDMY(")
 I $D(BDMY(1)),$P(BDMY(1),U,1)>$P(BDMV,U,1) S BDMV=$P(BDMY(1),U,1)_U_U_U_" (by Diagnosis) V74.1"  ; Q $$DATE^BDMS9B1($P(BDMY(1),U))_"  (by Diagnosis)"
 I BDMV]"" Q $P(BDMV,U,4)_"  "_$P(BDMV,U,2)_"  "_$P(BDMV,U,3)_"  "_$$DATE^BDMS9B1($P(BDMV,U,1))
 S G=$$REFDF^BDMS9B3(P,9999999.28,$O(^AUTTSK("B","PPD",0)))
 I G]"" Q G
 Q ""
PPDS(P) ;EP
 ;check for tb health factor, problem list, povs if and
 ;indication of pos ppd then return "Known Positive PPD"
 NEW BDMS,E,X
 K BDMS
 S X=P_"^LAST HEALTH [DM AUDIT TB HEALTH FACTORS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS) Q "Known Positive PPD or Hx of TB (Health Factor recorded)"
PPDSPL ;CHECK PL
 N T S T=$O(^ATXAX("B","SURVEILLANCE TUBERCULOSIS",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)) S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXCHK(Y,T,9) S I=1
 I I Q "Known Positive PPD or Hx of TB (Problem List DX)"
 ;check povs
 K BDMS S X=P_"^FIRST DX [SURVEILLANCE TUBERCULOSIS" S E=$$START1^APCLDF(X,"BDMS(")
 I $D(BDMS(1)) Q "Known Positive PPD or Hx of TB (POV/DX "_$$DATE^BDMS9B1($P(BDMS(1),U))_")"
 Q ""
BI() ;EP- check to see if using new imm package or not 1/5/1999 IHS/CMI/LAB
 Q $S($O(^AUTTIMM(0))<100:0,1:1)
LASTPNEU(BDMPDFN,BDMBD,BDMED,BDMFORM) ;PEP - date of last PNEUMOVAX
 ;  Return the last recorded PNEUMOVAX:
 ;   - V Immunization: 33, 100, 109
 ;   - V POV V06.6, V03.82
 ;   - V PROCEDURE 99.55
 ;   - V CPT [BGP PNEUMO IZ CPTS]
 ;
 ;  Input:
 ;   BDMPDFN - Patient DFN
 ;   BDMBD - beginning date to begin search for value - if blank, default is DOB
 ;   BDMED - ending date of search - if blank, default is DT
 ;   BDMFORM -  BDMFORM returned:  D - return date only - example 3070801
 ;                                 A - return value:
 ;                       date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
 ;             Default if blank is D
 ;  Output:
 ;   If BDMFORM is blank or BDMFORM is D returns internal fileman date if one found otherwise returns null
 ;   If BDMFORM is A returns the string:
 ;     date^text of item found^value if appropriate^visit ien^File found in^ien of file found in
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
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"V06.6","DX",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"V03.82","DX",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
 D E
 S BDMVAL=$$LASTITEM^APCLAPIU(BDMPDFN,"99.55","PROCEDURE",$S($P(BDMLAST,U)]"":$P(BDMLAST,U),1:BDMBD),BDMED,"A")
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
