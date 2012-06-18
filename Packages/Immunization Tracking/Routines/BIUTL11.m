BIUTL11 ;IHS/CMI/MWR - UTIL: PATIENT INFO; AUG 10,2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UTILITY: PATIENT FUNCTIONS: CONTRAS, INPATIENT, HIDOSE.
 ;;  PATCH 1: Correct typo "Q", so that unmatched CVX returns 0 (zero),
 ;;           not "Q".  LASTIMM+17
 ;
 ;
 ;----------
CONTRA(BIDFN,A,BIREF,BIDATE) ;EP
 ;---> Return an array of a patient's ImmServe Contraindications.
 ;---> Called by IMMSERV^BIEXPRT5.
 ;---> Parameters:
 ;     1 - BIDFN (req)  Patient's IEN in VA PATIENT File #2.
 ;     2 - A     (ret)  Array with subscripts=HL7 CVX Codes of vaccines
 ;                      contraindicated for this patient.
 ;                      Each node A(CVX)=IEN of the Reason in ^BICONT(
 ;     3 - BIREF (opt)  If BIREF=1, return only Vaccines contraindicated
 ;                      because they were refused, i.e., Refusals.
 ;                      If BIREF=2, return only Vaccines contraindicated
 ;                      because of Hx of Chicken Pox.
 ;     4 - BIDATE (opt) If BIDATE=1, append Date of contra to Refusals.
 ;
 Q:'$G(BIDFN)
 ;---> Quit if there are no contraindications for this patient.
 Q:'$D(^BIPC("B",BIDFN))
 ;
 N N,U S N=0,U="^"
 F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  D
 .;---> If bad xref, kill it and quit.
 .I '$D(^BIPC(N,0)) K ^BIPC("B",BIDFN,N) Q
 .N BIPC,X,Y
 .;---> BIPC=zero node of a Patient's Contraindication.
 .S BIPC=^BIPC(N,0)
 .;
 .;---> Set X=Reason pointer (to ^BICONT), Y=Date of Contraindication.
 .S X=$P(BIPC,U,3),Y=$P(BIPC,U,4)
 .;
 .;---> If the call is to return an array of Refusals, do so and quit.
 .I $G(BIREF)=1 D  Q
 ..;---> 11 & 16 are IENs of BI TABLE CONTRA REASONS ^BICONT( that are REFUSALS.
 ..I (X=11)!(X=16) D  Q
 ...;---> Set array node A(CVX)=IEN of Refusal Contra Reason.
 ...N Z S Z=$P(BIPC,U,2) I Z S Z=$G(^AUTTIMM(Z,0)),Z=$P(Z,U,3)
 ...I Z S A(Z)=X S:$G(BIDATE) A(Z)=A(Z)_U_Y
 .;
 .;
 .;---> If the call is to return an array of Hx of Chicken Pox, do so and quit.
 .I $G(BIREF)=2 D  Q
 ..;---> 12 is the IEN of BI TABLE CONTRA REASONS that is Hx of Chicken Pox.
 ..I X=12 D  Q
 ...;---> Set array node A(CVX)=IEN of Hx of Chicken Pox Reason.
 ...N Z S Z=$P(BIPC,U,2) I Z S Z=$G(^AUTTIMM(Z,0)),Z=$P(Z,U,3) S:Z A(Z)=X
 .;
 .;---> Continue in order to return an array of contra'd vaccines by CVX Code.
 .;
 .;---> Quit if the Reason for this contraindication is one that
 .;---> still allows forecasting of the vaccine.  For example,
 .;---> if the reason is "Patient Refusal", then the vaccine should
 .;---> still be forecast as due.
 .I X Q:$P($G(^BICONT(X,0)),U,2)
 .;
 .;---> For this Vaccine IEN contraindication, get Related Contraindcated CVX Codes.
 .;---> (Call below also sets A(CVX) of THIS Vaccine IEN in the A(CVX) array.)
 .D CONTRHL7($P(BIPC,U,2),.A)
 Q
 ;
 ;
 ;----------
CONTRHL7(BIVAC,A) ;EP
 ;---> Return an array of Related Contraindcated HL7 Codes for
 ;---> this vaccine.
 ;---> Parameters:
 ;     1 - BIVAC (req) IEN of Vaccine.
 ;     2 - A     (ret) Array with subscripts=HL7 Codes of vaccines
 ;                     contraindicated that relate to this vaccine.
 ;
 Q:'$G(BIVAC)  Q:'$D(^AUTTIMM(BIVAC,0))
 ;
 ;---> Set X=data for this vaccine.
 N X S X=^AUTTIMM(BIVAC,0)
 ;
 ;---> Set HL7 Code for this contraindicated vaccine in A() array
 ;---> as a subscript.
 Q:'$P(X,U,3)
 S A($P(X,U,3))=""
 ;
 ;---> Set X=string of Related Contraindicated HL7 Codes for this
 ;---> vaccine.
 S X=$P(X,U,12)
 ;
 ;---> Now piece out Contraindicated HL7 Codes (comma delimited)
 ;---> and set in A() array as subscripts.
 N I,Y F I=1:1 S Y=$P(X,",",I) Q:'Y  S A(Y)=""
 Q
 ;
 ;
 ;----------
CONTR(BIDFN,BIVAC) ;EP
 ;---> Return 1 if Patient has a Contraindication to the passed
 ;---> Vaccine; return 0 if not.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIVAC (req) Vaccine IEN.
 ;
 Q:'$G(BIDFN) 0  Q:'$G(BIVAC) 0  Q:'$D(^AUTTIMM(BIVAC,0)) 0
 ;
 ;---> Quit if this Patient does not have a contra for this vaccine.
 Q:'$D(^BIPC("AC",BIDFN,BIVAC)) 0
 ;
 ;---> Quit if the Reason for this contraindication is one that
 ;---> still allows forecasting of the vaccine.  For example,
 ;---> if the reason is "Patient Refusal", then the vaccine should
 ;---> still be forecast as due.
 ;
 N N S N=$O(^BIPC("AC",BIDFN,BIVAC,0))
 Q:'N 0
 S N=$P($G(^BIPC(N,0)),U,3)
 ;---> If no Reason given, then return 1 (as valid Contraindication).
 Q:'N 1
 Q:$P($G(^BICONT(N,0)),U,2) 0
 ;
 ;---> Valid Contraindication (do not forecast).
 Q 1
 ;
 ;
 ;----------
INPT(BIDFN,BIDATE) ;EP
 ;---> Return 1 if patient was an inpatient on BIDATE.
 ;---> Called by +84^BIVISIT to correct Category.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIDATE (req) Date to check if patient was inpatient.
 ;
 Q:'$G(BIDFN) 0  Q:'$G(BIDATE) 0
 ;
 ;---> Get last discharge previous to BIDATE.
 N X,Y S BIDATE=9999999.9999999-BIDATE
 S X=$O(^AUPNVINP("AA",BIDFN,BIDATE))
 ;
 ;---> Now check to see if patient has been admitted since
 ;---> that discharge date.
 ;---> Next line, v8.1 correction "DFN" to "BIDFN".
 S X=$O(^AUPNVSIT("AAH",BIDFN,X),-1)
 ;
 ;---> If patient not admitted since last discharge, quit 0.
 Q:'X 0
 ;
 ;---> If Visit is for Contract Care, quit 0 (not an inpatient).
 ;---> Next line v8.1 fix: Use X (inv date) to get Y (IEN).
 S Y=+$O(^AUPNVSIT("AAH",BIDFN,X,0))
 Q:$P($G(^AUPNVSIT(Y,0)),U,3)="C" 0
 ;
 ;---> If last admission was after BIDATE (inverse), quit 0.
 Q:X<BIDATE 0
 ;
 ;---> Patient was an inpatient on BIDATE, quit 1.
 Q 1
 ;
 ;
 ;----------
INFL(BIDFN,TEXT) ;EP
 ;---> Return value of Patient's Forecast Influ/Pneumo field.
 ;---> 0=Normal, 1=Influenza, 2=Pneumococcal, 3=Both, 4=Disregard Risk Factors.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (BIDFN).
 ;     2 - TEXT (opt) If TEXT=1, return text of the field.
 ;
 Q:'$G(BIDFN) 0
 Q:'$D(^BIP(BIDFN,0)) 0
 N X S X=+$P(^BIP(BIDFN,0),U,15)
 Q:'$G(TEXT) X
 Q:X=4 "Disregard Risk Factors"
 Q:X=3 "Influenza and Pneumo"
 Q:X=2 "Pneumococcal"
 Q:X=1 "Influenza"
 Q "Normal"
 ;
 ;
 ;----------
MOTHER(BIDFN,BITEXT) ;EP
 ;---> Return mother's HBsAg Status Code.
 ;---> Parameters:
 ;     1 - BIDFN    (req) Patient's IEN (BIDFN).
 ;     2 - BITEXT (opt) If BITEXT=1 return full text.
 N X
 D
 .I '$G(BIDFN) S X="U" Q
 .I '$D(^BIP(BIDFN,0)) S X="U" Q
 .S X=$P(^BIP(BIDFN,0),U,11)
 S:X="" X="U"
 Q:'$G(BITEXT) X
 Q $S(X="P":"POSITIVE",X="N":"NEGATIVE",1:"UNKNOWN")
 ;
 ;
 ;----------
BENTYP(BIDFN,TEXT) ;EP
 ;---> Return IEN of Patient's Beneficiary Type.
 ;---> This is the CLASSIFICATION/BENEFICIARY Code (Item 2 on page 2
 ;---> of Registration).
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient's IEN (DFN).
 ;---> CodeChange for v7.1 - IHS/CMI/MWR 12/01/2000:
 ;---> Text parameter added.
 ;     2 - TEXT  (opt) If TEXT=1, return text of Beneficiary Type.
 ;                     If text=2, return Code of Beneficiary Type.  vvv83
 ;
 N Y
 Q:'$G(BIDFN) 0
 S Y=+$P($G(^AUPNPAT(BIDFN,11)),U,11)
 Q:'$G(TEXT) Y
 Q:$G(TEXT)=2 $P($G(^AUTTBEN(Y,0)),U,2)  ;vvv83
 Q $P($G(^AUTTBEN(Y,0)),U)
 ;
 ;
 ;----------
OTHERIN(BIDFN) ;EP
 ;---> Return Patient's Other Info.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (BIDFN).
 ;
 Q:'$G(BIDFN) ""
 Q $P($G(^BIP(BIDFN,0)),U,13)
 ;
 ;
 ;----------
MAYEDIT() ;EP
 ;---> Return 1 if User has Immunization Edit Patients Key; 0 if not.
 Q:'$D(DUZ) 0
 Q:$D(^XUSEC("BIZ EDIT PATIENTS",DUZ)) 1
 Q:$D(^XUSEC("BIZ MANAGER",DUZ)) 1
 Q 0
 ;
 ;
 ;----------
MAYMANAG() ;EP
 ;---> Return 1 if User has Immunization Manager Key; 0 if not.
 Q:'$D(DUZ) 0
 Q:$D(^XUSEC("BIZ MANAGER",DUZ)) 1
 Q 0
 ;
 ;
 ;----------
CURCOM(BIDFN,TEXT) ;EP
 ;---> Return patient's Current Community IEN or Text.
 ;---> (Item 6 on page 1 of Registration).
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (BIDFN).
 ;     2 - TEXT (opt) If TEXT=1, return text of Current Community.
 ;
 Q:'$G(BIDFN) "No Patient"
 Q:'$D(^AUPNPAT(BIDFN,11)) "Unknown1"
 ;
 N X,Y,Z
 S X=^AUPNPAT(BIDFN,11)
 ;---> Set Y=Pointer (IEN in ^AUTTCOM, piece 17), Z=Text (piece 18).
 S Y=$P(X,U,17),Z=$P(X,U,18)
 ;---> If both Pointer and Text are null, return "Unknown2".
 Q:('Y&(Z="")) "Unknown2"
 ;
 ;---> If Y is null or a bad pointer, set Y="".
 I Y<1!('$D(^AUTTCOM(+Y,0))) S Y=""
 ;
 ;---> If no valid pointer and if Text (pc 18) exists in the
 ;---> Community file, then set Y=IEN in ^AUTTCOM(, and fix it.
 I Y<1,$D(^AUTTCOM("B",Z)) S Y=$O(^AUTTCOM("B",Z,0)) D
 .N BIFLD S BIFLD(1117)=Y D FDIE^BIFMAN(9000001,BIDFN,.BIFLD)
 ;
 Q:'$D(^AUTTCOM(+Y,0)) "Unknown3"
 ;
 N BITEXT S BITEXT=$P(^AUTTCOM(Y,0),U)
 ;---> If text field is off, fix it.
 I Z'=BITEXT D
 .N BIFLD S BIFLD(1118)=BITEXT D FDIE^BIFMAN(9000001,BIDFN,.BIFLD)
 Q:'$G(TEXT) Y
 Q $P(^AUTTCOM(Y,0),U)
 ;
 ;
 ;----------
ISGPRA(BIDFN,BISITE,BINOCOM,BIERR) ;PEP - Return 1 if Pt's Current Community is in Imm GPRA Set.
 ;---> Return 1 if Patient's Current Community is in the Immunization GPRA Set
 ;---> of Communities as defined in the BI Site Parameters File.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient's IEN (BIDFN).
 ;     2 - BISITE  (req) IEN of Site (often the user's DUZ(2)).
 ;
 N BIPCC,BIGPRA,BIERR S BIERR=""
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q 0
 S:'$G(BISITE) BISITE=$G(DUZ(2))
 I '$G(BISITE) D ERRCD^BIUTL2(109,.BIERR) Q 0
 S BIPCC=+$$CURCOM(BIDFN)
 Q:'BIPCC 0
 D GETGPRA^BISITE4(.BIGPRA,BISITE,.BIERR)
 I BIERR]"" Q 0
 Q:$D(BIGPRA(BIPCC)) 1
 Q 0
 ;
 ;
 ;----------
NEXTAPPT(BIDFN) ;EP
 ;---> Return patient's next appointment from Scheduling Package.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN (BIDFN).
 ;
 Q:'$G(BIDFN) ""
 Q:'$D(^DPT(BIDFN)) ""
 ;
 N BIAPPT,BIDT,BIYES
 S BIDT=DT+.2400,BIYES=0
 F  S BIDT=$O(^DPT(BIDFN,"S",BIDT)) Q:'BIDT!(BIYES)  D
 .N BIDATA,BIOI,X
 .S BIDATA=$G(^DPT(BIDFN,"S",BIDT,0))
 .Q:BIDATA=""
 .;
 .;---> Quit if appointment is cancelled.
 .Q:$P(BIDATA,U,2)["C"
 .;
 .S X=0 F  S X=$O(^SC(+BIDATA,"S",BIDT,1,X)) Q:'X  D
 ..Q:+$G(^SC(+BIDATA,"S",BIDT,1,X,0))'=BIDFN
 ..;
 ..;---> Retrieve Other Information.
 ..;S BIOI="  "_$P($G(^SC(+BIDATA,"S",BIDT,1,X,0)),U,4)  ;other info
 ..;
 ..;S BIYES=BIDT_U_+BIDATA_U_BIOI
 ..S BIYES=BIDT_U_+BIDATA
 ;
 Q:'BIYES "None"
 ;
 S BIAPPT=$$FMTE^XLFDT(+BIYES,"1P")_" with "
 S BIAPPT=BIAPPT_$P($G(^SC($P(BIYES,U,2),0)),U)
 Q BIAPPT
 ;
 ;
 ;----------
LASTIMM(BIDFN,BICVXS,BIQDT,BIALL) ;PEP - Return latest date patient received CVX vaccine(s).
 ;---> Return the latest Fileman date on which any one of the CVX's in the
 ;---> string BICVXS was received.  Return 0 (zero) if none received.
 ;---> Parameters:
 ;     1 - BIDFN  (req) IEN of Patient in ^DPT.
 ;     2 - BICVXS (req) String of CVX Codes to check, delimited by comma.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;     4 - BIALL  (opt) If BIALL=1 return string of dates (comma delim) before BIQDT.
 ;     5 - BIVG   (opt) *NOT USED* Vaccine Group (if BIVG=IEN of Vaccine Group, check that way).
 ;
 Q:'$G(BIDFN) 0
 Q:'$G(BICVXS) 0
 N BICVX,BIDATE,I S BIDATE=0
 ;
 F I=1:1 S BICVX=$P(BICVXS,",",I) Q:BICVX=""  D
 .S BIIEN=$$HL7TX^BIUTL2(BICVX)
 .;---> Quit if CVX Code does not exist in Vaccine Table (or=OTHER).
 .Q:('BIIEN!(BIIEN=137)) 0
 .N N S N=0
 .F  S N=$O(^AUPNVIMM("AC",BIDFN,N)) Q:'N  D
 ..N X,Y S X=$G(^AUPNVIMM(N,0))
 ..;---> Quit if this visit doesn't match the desired CVX Code.
 ..Q:(+X'=BIIEN)
 ..;
 ..;---> Get pointer to Visit (to get date of visit).
 ..S Y=$P(X,U,3)
 ..Q:'Y
 ..S Y=$P(+$G(^AUPNVSIT(Y,0)),".")
 ..Q:'Y
 ..;---> Quit if this Visit was after the Quarter Ending Date.
 ..I $G(BIQDT) Q:(Y>BIQDT)
 ..;
 ..;---> If returning all dates, concat string and quit.
 ..I $G(BIALL) D  Q
 ...I BIDATE S BIDATE=BIDATE_","_Y Q
 ...S BIDATE=Y
 ..;
 ..;---> If only returning last date, reset BIDATE if this is later than any prior BIDATE.
 ..S:(Y>BIDATE) BIDATE=Y
 ;
 ;---> Return the latest Visit Date for this set of CVX Codes.
 Q BIDATE
 ;
 ;
 ;----------
LASTCPT(BIDFN,BICPTS,BIQDT,BIALL) ;EP
 ;---> Return the latest Fileman date on which any one of the CPT's in the
 ;---> string BICPTS was received.  Return 0 (zero) if none received.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTS (req) String of CPT Codes to check, delimited by comma.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;     4 - BIALL  (opt) If BIALL=1 return string of dates (comma delim) before BIQDT.
 ;
 Q:'$G(BIDFN) 0
 Q:'$G(BICPTS) 0
 N BICPT,BIDATE,I S BIDATE=0
 F I=1:1 S BICPT=$P(BICPTS,",",I) Q:BICPT=""  D
 .N N S N=0
 .F  S N=$O(^AUPNVCPT("AA",BIDFN,BICPT,N)) Q:'N  D
 ..N BIDATE1 S BIDATE1=9999999-N
 ..I $G(BIQDT) Q:(BIDATE1>BIQDT)
 ..;
 ..;---> If returning all dates, concat string and quit.
 ..I $G(BIALL) D  Q
 ...I BIDATE S BIDATE=BIDATE_","_BIDATE1 Q
 ...S BIDATE=BIDATE1
 ..;
 ..;---> If only returning last date, reset BIDATE if this is later than any prior BIDATE.
 ..S:(BIDATE1>BIDATE) BIDATE=BIDATE1
 ;
 ;---> Return the latest Visit Date for this set of CPT Codes.
 Q BIDATE
 ;
 ;
 ;----------
MOTHMAID(DFN) ;EP
 ;---> CodeChange for v7.1 - IHS/CMI/MWR 12/01/2000:
 ;---> This is a new call added.
 ;---> Return patient's mother's maiden name.
 ;---> Parameters:
 ;     1 - DFN  (req) Patient's IEN (DFN).
 ;
 Q:'$G(DFN) "No DFN"
 Q $P($G(^DPT(DFN,.24)),U,3)
 ;
 ;
 ;----------
HIDOSE(BIDFN,BIVIEN,BIHX) ;EP
 ;---> NO LONGER USED (v8.0 and on).
 ;---> Return Patient's highest previous Dose# for a given Vaccine.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;     2 - BIVIEN (req) IEN of Vaccine.
 ;     3 - BIHX   (req) Patient's Imm History String.
 ;                      Assumes default pieces listed in IMMHX^BIRPC:
 ;                      Pc1="I"/"S", Pc3=Dose#-VacName, Pc6=Vaccine Grp.
 ;
 Q:'$G(BIDFN) 0
 Q:'$G(BIVIEN) 0  Q:'$D(^AUTTIMM(BIVIEN,0)) 0
 Q:$G(BIHX)="" 0
 ;
 ;---> Set previous Dose#=0 and Vaccine Group for this Vaccine.
 N BIPREV,BIVGRP,I,V,X,Y
 S BIPREV=0,BIVGRP=$$IMMVG^BIUTL2(BIVIEN,1),V="|"
 ;
 ;---> Loop through "^"-pieces of Imm History, looking for the
 ;---> highest previous Dose# in this Vaccine Group.
 F I=1:1 S Y=$P(BIHX,U,I) Q:Y=""  D
 .;
 .;---> Quit if this is not an Immunization.
 .Q:$P(Y,V)'="I"
 .;
 .;---> Quit if this is not the same Vaccine Group as the
 .;---> selected Vaccine.
 .Q:$P(Y,V,6)'=BIVGRP
 .;
 .;---> If this Dose# is higher than any previous,
 .;---> set BIPREV equatl to it.
 .S X=$P($P(Y,V,3),"-") S:X>BIPREV BIPREV=X
 ;
 Q BIPREV
