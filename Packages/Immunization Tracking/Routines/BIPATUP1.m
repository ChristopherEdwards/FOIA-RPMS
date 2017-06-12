BIPATUP1 ;IHS/CMI/MWR - UPDATE PATIENT DATA; DEC 15, 2011
 ;;8.5;IMMUNIZATION;**13**;AUG 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  PATCH 8: Extensive changes to accommodate new TCH Forecaster   LDFORC+0
 ;;  PATCH 9: Numerous changes to accomodate new Heb B High Risk  IHSPOST+0
 ;;  PATCH 10: Recognize both TCH incoming 33 PNEUMO-PS or 133 PCV-13. DDUE2+56
 ;;  PATCH 12: If Dose Override is Invalid (1-4) forecast Pneumo.  IHSPOST+30
 ;;  PATCH 13: Do not forecast Flu before local Flu Season Start Date.  DDUE2+46
 ;
 ;----------
LDFORC(BIDFN,BIFORC,BIHX,BIFDT,BIDUZ2,BINF,BIPDSS) ;EP
 ;---> Load Immserve Data (Immunizations Due) into ^BIPDUE(.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIFORC (req) String containing Patient's Imms Due.
 ;     3 - BIHX   (req) String containing Patient's Imm History.
 ;     4 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     5 - BIDUZ2 (opt) User's DUZ(2) indicating site parameters.
 ;     6 - BINF   (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     7 - BIPDSS (ret) Returned string of V IMM IEN's that are
 ;                      Problem Doses, according to ImmServe.
 ;
 Q:'$G(BIDFN)  Q:$G(BIFORC)=""  Q:$G(BIHX)=""
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT S:'$D(BINF) BINF=""
 ;
 ;---> Set Patient Age in months for this Forecast Date.
 N BIAGE S BIAGE=$$AGE^BIUTL1(BIDFN,2,BIFDT)
 ;
 ;---> First clear out any previously set Immunizations Due and
 ;---> any Forecasting Errors for this patient.
 D KILLDUE^BIPATUP2(BIDFN)
 ;
 ;---> If no BIDUZ2, try DUZ(2); otherwise, defaults will be used.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Check for any input doses that TCH identified as problems.
 ;---> Build and return a string of "V IMM IEN_%_CVX" problem doses,
 ;---> as identified in the TCH Input Doses segment.
 ;D DPROBS^BIPATUP2(BIFORC,.BIPDSS,.BIID)
 D DPROBS^BIPATUP2(BIFORC,.BIPDSS)
 ;**********
 ;
 ;---> * * * * * NEXT PATCH REMOVE ALL FLU CODE. * * * * *
 ;---> Parse Doses Due from Forecaster string (BIFORC), perform any
 ;---> necessary translations, and set as due in patient global ^BIPDUE(.
 ;---> If Immserve set Flu due, set BIIMMFL=1.
 N BIIMMFL S BIIMMFL=0
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Check if TCH has already forecast Pneumo, pass in BITCHPN.
 ;---> If TCH set Pneumo due, set BITCHPN=1.
 N BITCHPN S BITCHPN=0
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Check if TCH has already forecast Hep B, pass in BITCHHB.
 N BITCHHB S BITCHHB=0
 ;
 ;D DDUE(BIFORC,BIAGE,BIHX,.BINF,.BIIMMFL,.BIIMMH1,BIDUZ2,.BITCHPN,BIFDT)
 D DDUE(BIFORC,BIAGE,BIHX,.BINF,.BIIMMFL,BIDUZ2,.BITCHPN,BIFDT,.BITCHHB)
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> New parameter BIRISKH to pass High Risk Hep B.
 N BIFLU,BIFFLU,BILIVE,BIRISKI,BIRISKP,BIRISKH
 S BIFLU="",(BIFFLU,BILIVE,BIRISKI,BIRISKP,BIRISKH)=0
 ;
 ;---> After loading (SETDUE) TCH forecast, perform any follow-up forecasting
 ;---> needed for High Risk, "Post-forecast".
 D IHSPOST(BIDFN,BIHX,BIFDT,.BIFLU,.BIFFLU,.BIRISKI,.BIRISKP,.BILIVE,BIDUZ2,.BIRISKH)
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> No longer called, since TCH forecasts Flu for all ages.
 ;---> Forecast Influenza.
 ;D IHSFLU^BIPATUP2(BIDFN,.BIFLU,BIFFLU,BIRISKI,.BINF,BIFDT,BIAGE,BIIMMFL,BIDUZ2)
 ;
 ;---> Forecast Pneumo.
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Only check to forecast Pneumo if TCH has not already done so.
 ;D IHSPNEU(BIDFN,.BIFLU,BIFFLU,BIRISKP,.BINF,BIFDT,BIAGE,BIDUZ2)
 I '$G(BITCHPN) D IHSPNEU(BIDFN,.BIFLU,BIFFLU,BIRISKP,.BINF,BIFDT,BIAGE,BIDUZ2)
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Only check to forecast HepB if TCH has not already done so.
 ;---> Forecast HepB.
 I '$G(BITCHHB) D IHSHEPB(BIDFN,.BIFLU,.BINF,BIFDT,BIAGE,BIDUZ2,BIRISKH)
 ;
 Q
 ;
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Add BITCHPN parameter to pass TCH already forecast Pneumo.
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add BITCHHB parameter to pass TCH already forecast Hep B.
 ;----------
DDUE(BIFORC,BIAGE,BIHX,BINF,BIIMMFL,BIDUZ2,BITCHPN,BIFDT,BITCHHB) ;EP
 ;---> Parse Doses Due from Immserve string (BIFORC), perform any
 ;---> necessary translations, and set as due in patient global ^BIPDUE.
 ;---> Parameters:
 ;     1 - BIFORC  (req) Forecast string coming back from TCH.
 ;     2 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     3 - BIHX    (req) String containing Patient's Imm History.
 ;     4 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     5 - BIIMMFL (opt) BIIMMFL=1 means Immserve already forecast Flu.
 ;     6 - BIDUZ2  (opt) User's DUZ(2) indicating site parameters.
 ;     7 - BITCHPN (opt) BITCHPN=1 means TCH already forecast Pneumo.
 ;     8 - BIFDT   (opt) Forecast Date (date used for forecast).
 ;     9 - BITCHHB (opt) BITCHHB=1 means TCH already forecast Hep B.
 ;
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Changes to accommodate new TCH Forecaster parsing.
 N BIFORC1,BIDOSE,N
 S BIFORC1=$P(BIFORC,"~~~",3)
 ;
 F N=1:1 S BIDOSE=$P(BIFORC1,"|||",N) Q:(BIDOSE="")  D
 .D DDUE2(BIDOSE,BIAGE,BIHX,.BINF,.BIPC,.BIIMMFL,BIDUZ2,.BITCHPN,BIFDT,.BITCHHB)
 Q
 ;
 ;
 ;----------
DDUE2(BIDOSE,BIAGE,BIHX,BINF,BIPC,BIIMMFL,BIDUZ2,BITCHPN,BIFDT,BITCHHB) ;EP
 ;---> Parse Doses Due (see linelabel DDUE above).
 ;---> Parameters: See DDUE immediately above!
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Many changes below to accommodate new TCH Forecaster.
 ;
 ;---> Uncomment next line to see raw Doses Due:
 ;W !!!,BIDOSE R ZZZ
 ;
 N A,BI,D,X S X=BIDOSE
 ;---> A=CVX Code
 S A=$P(X,U,1)
 ;
 ;---> "PAST"=Past Due Indicator
 S BI("PAST")=$P(X,U,3)
 ;
 ;---> Get Fileman formats of due dates.
 ;---> "MIN"=Minimum Date Due
 S BI("MIN")=$$TCHFMDT^BIUTL5($P(X,U,4)) S:('BI("MIN")) BI("MIN")=""
 ;
 ;---> "REC"=Recommended Date Due
 S BI("REC")=$$TCHFMDT^BIUTL5($P(X,U,5)) S:('BI("REC")) BI("REC")=""
 ;
 ;---> "EXC"=Exceeds Date Due
 S BI("EXC")=$$TCHFMDT^BIUTL5($P(X,U,6)) S:('BI("EXC")) BI("EXC")=""
 ;
 ;---> Determine whether to set Recommended Age or Minimum Accepted Age
 ;---> based on Site Parameter.
 S BI("DUE")=BI("REC")
 I $$MINAGE^BIUTL2($G(BIDUZ2))=1 S BI("DUE")=BI("MIN")
 ;
 ;---> If this dose is past due (BI("PAST")=1), D(2) will stuff DATE PAST DUE;
 ;---> Otherwise, D(1) will stuff RECOMMENDED DATE DUE.
 S (D(1),D(2))="" D
 .I BI("PAST") S D(2)=BI("EXC") Q
 .S D(1)=BI("DUE")
 ;
 ;---> *** TRANSLATIONS OF INCOMING IMMSERVE VACCINES:
 ;--->     -------------------------------------------
 Q:A=""
 ;
 ;---> Check to see if Site specified do not forecast this Vaccine Group.
 Q:$D(BINF($$HL7TX^BIUTL2(A,1)))
 ;
 ;
 ;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 ;---> Do not forecast Flu (CVX 88) before local Flu Season Start Date, regardless of
 ;---> Min vs. Rec site parameter #8.
 I A=88,$E($G(BIFDT),4,5)>6 Q:(BIFDT<($E(BIFDT,1,3)_$TR($P($$FLUDATS^BIUTL8(BIDUZ2),"%"),"/")))
 ;**********
 ;
 ;---> Add this Immunization Due.
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(A)_U_U_D(1)_U_D(2))
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> If TCH set Pneumo due, set BITCHPN=1.
 ;
 ;********** PATCH 10, v8.5, MAY 30,2015, IHS/CMI/MWR
 ;---> Check for TCH incoming 33 PNEUMO-PS or 133 PCV-13.
 ;S:(A=33) BITCHPN=1
 S:((A=33)!(A=133)) BITCHPN=1
 ;**********
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> If TCH set Hep B due, set BITCHHB=1.
 S:(A=45) BITCHHB=1
 ;**********
 ;
 Q
 ;
 ;
 ;----------
IHSPOST(BIDFN,BIHX,BIFDT,BIFLU,BIFFLU,BIRISKI,BIRISKP,BILIVE,BIDUZ2,BIRISKH) ;EP
 ;---> Post forecast; after loading  TCH forecast, perform any follow-up forecasting
 ;---> needed for High Risk.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIHX    (req) String containing Patient's Imm History.
 ;     3 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     4 - BIFLU   (ret) Pneumo & Hep B history array: BIFLU(CVX,INVDATE).
 ;     5 - BIFFLU  (ret) Value (0-4) for force Flu/Pneumo regardless of age.
 ;     6 - BIRISKI (ret) 1=Patient has Risk of Influenza; otherwise 0.
 ;     7 - BIRISKP (ret) 1=Patient has Risk of Pneumo; otherwise 0.
 ;     8 - BILIVE  (ret) 1-Patient received a LIVE vaccine <28 days before
 ;                       the forecast date.
 ;     9 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;    10 - BIRISKH (ret) 1=Patient has Risk of Hep B; otherwise 0.
 ;
 ;---> Loop through History string, gathering previous Influenzas and Pneumos.
 ;
 N BIDOSE,BIHX1,I,X,Y
 S BIHX1=$P(BIHX,"~~~",2)
 ;
 ;---> Loop through RPMS Input String History, collecting for prior Pneumo.
 ;---> Store in BIFLU by HL7 Code, inverse date.
 ;F I=1:1:Y D
 F I=1:1  S BIDOSE=$P(BIHX1,"|||",I) Q:BIDOSE=""  D
 .;
 .;---> For this Immunization, set A=CVX Code, D=Date.
 .N A,D S A=$P(BIDOSE,U,2),D=$P(BIDOSE,U,3)
 .;---> Quit if Dose Override is Invalid (1-4).
 .;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 .;---> Reinstated for TCH.
 .I $P(BIDOSE,U,4),$P(BIDOSE,U,4)<9 Q
 .;
 .;---> If this is a Pneumo (33,100,109) or Hep B (8,42,43,44,45,etc.))
 .;---> translate and store it in local array BIFLU(CVX,Inverse Fm date).
 .;
 .;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 .;---> Update Pneumo CVX's.
 .;S:((A=100)!(A=109)) A=33
 .;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 .;---> Leave for now, but next patch Change so that only CVX 33 satisfies High Risk.
 .S:((A=100)!(A=109)!(A=133)!(A=152)) A=33
 .;**********
 .;
 .;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 .;---> Collect Hep B CVX's.
 .S:((A=8)!(A=42)!(A=44)!(A=43)!(A=43)!(A=51)!(A=102)) A=45
 .S:((A=104)!(A=110)!(A=132)!(A=146)) A=45
 .;
 .;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 .;---> Now concerned with Hep B's too.
 .;S:(A=33) BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))=""
 .S:(A=33)!(A=45) BIFLU(A,9999999-$$TCHFMDT^BIUTL5(D))=""
 .;**********
 ;
 ;
 ;---> Old/disregard: Get value for forced Influenza regardless of age.
 ;---> Now only forced Pneumo option (Flu forecast for everyone).
 ;---> NOTE: This value is PATIENT-SPECIFIC (not site param).
 ;---> 0=Normal, 1=Influenza, 2=Pneumococcal, 3=Both, 4=Disregard Risk Factors.
 S BIFFLU=$$INFL^BIUTL11(BIDFN)
 ;---> Quit (don't check Risk Factors) if BIFFLU=4, Disregard Risk Factors.
 Q:BIFFLU=4
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Accommodate new parameter options.
 ;---> Quit if Site Param says NOT to include Risk Factors.
 N BIRSK S BIRSK=$$RISKP^BIUTL2(BIDUZ2)
 Q:'BIRSK
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> Only Pneumo will be checked (Flu now forecast for everyone), by
 ;---> passing 2 in the third parameter.
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> New parameter to return Hep B risk. (No longer include Flu.)
 ;D RISK^BIDX(BIDFN,BIFDT,2,.BIRISKI,.BIRISKP)
 D RISK^BIDX(BIDFN,BIFDT,BIRSK,,.BIRISKP,.BIRISKH)
 ;**********
 Q
 ;
 ;
 ;----------
IHSPNEU(BIDFN,BIFLU,BIFFLU,BIRISKP,BINF,BIFDT,BIAGE,BIDUZ2) ;EP
 ;---> IHS Pneumo Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Influ and Pneumo History array: BIFLU(CVX,INVDATE).
 ;     3 - BIFFLU  (req) Value (0-4) for force Flu/Pneumo regardless of age.
 ;     4 - BIRISKP (req) 1=Patient has Risk of Pneumo; otherwise 0.
 ;     5 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     6 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     7 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     8 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;
 ;---> Quit if Forecasting turned off for Pneumo.
 Q:$D(BINF(11))
 ;
 ;---> Quit if this patient has a contraindication to Pneumo.
 ;********** PATCH 4, v8.5, DEC 01,2012, IHS/CMI/MWR
 N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(33))
 ;**********
 ;
 ;---> Quit if this Pt Age <60 months (5yrs), regardless of risk.
 Q:BIAGE<60
 ;
 N BIPNAGE,BIMRECNT,BIALLAGE
 ;---> BIPNAGE=Site Parameter Age to forecast Pneumo ("Pneumo Age") in months.
 S BIPNAGE=($P($$PNMAGE^BIPATUP2(BIDUZ2),U)*12)
 ;---> BIMRECNT=Fileman Date of most recent Pneumo.
 S BIMRECNT=(9999999-$O(BIFLU(33,0))) S:BIMRECNT=9999999 BIMRECNT=0
 S BIALLAGE=0
 ;
 ;---> Quit if patient is less than Age Appropriate for Pneumo in years
 ;---> and has already had one Pneumo.
 Q:((BIAGE<BIPNAGE)&(BIMRECNT))
 ;
 ;---> If High Risk Pneumo or Forecast for this patient regardless of Age, set BIALLAGE=1.
 I BIRISKP!(23[BIFFLU) S BIALLAGE=1
 ;
 ;---> Quit if Pt Age < Pneumo Age (on Forecast date) and not forecast for
 ;---> all ages.
 Q:((BIAGE<BIPNAGE)&('BIALLAGE))
 ;
 ;---> If patient has reached site Pneumo Age or has Forced Pneumo AND
 ;---> has NO previous pneumo, then forecast Pneumo and quit.
 I ((BIAGE'<BIPNAGE)!BIALLAGE),'BIMRECNT D  Q
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_U_BIFDT)
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> TCH will forecast routine Pneumo after age 65.
 Q
 ;
 ;
 ;********** PATCH 9, v8.5, OCT 01,2014, IHS/CMI/MWR
 ;---> Add parameter for Hep B (BIRISKH). Change BIFFLU to BIRSK.
 ;----------
IHSHEPB(BIDFN,BIFLU,BINF,BIFDT,BIAGE,BIDUZ2,BIRISKH) ;EP
 ;---> IHS Hep B Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Influ and Pneumo History array: BIFLU(CVX,INVDATE).
 ;     3 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     4 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     5 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     6 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;     7 - BIRISKH (req) 1=Patient has Risk of HEP B; otherwise 0.
 ;
 ;---> Quit if Forecasting turned off for Hep B.
 Q:$D(BINF(4))
 ;
 ;---> Quit if this patient has a contraindication to Hep B.
 N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(45))
 ;**********
 ;
 ;---> Quit if this Pt Age < 19 yrs or older than 60 yrs, regardless of risk.
 Q:(BIAGE<228)  Q:(BIAGE>719)
 ;
 ;---> Quit if this patient ever received a Hep B.
 Q:$D(BIFLU(45))
 ;
 ;---> Quit iF patient is NOT High Risk for Hep B.
 Q:('BIRISKH)
 ;
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(45)_U_U_BIFDT)
 Q
