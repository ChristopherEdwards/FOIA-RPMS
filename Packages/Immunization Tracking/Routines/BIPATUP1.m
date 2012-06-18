BIPATUP1 ;IHS/CMI/MWR - UPDATE PATIENT DATA; DEC 15, 2011
 ;;8.5;IMMUNIZATION;**1**;JAN 03,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;   PATCH 1: Include FLU-DERMAL CVX=144.  IHSPREL+55
 ;
 ;----------
LDFORC(BIDFN,BIFORC,BIHX,BIFDT,BIDUZ2,BINF,BIPDSS) ;EP
 ;---> Load Immserve Data (Immunizations Due) into ^BIPDUE(.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient IEN.
 ;     2 - BIFORC (req) String containing Patient's Imms Due.
 ;     3 - BIHX   (req) String containing Patient's Imm History.
 ;     4 - BIFDT  (opt) Forecast Date (date used for forecast).
 ;     5 - BIDUZ2 (opt) User's DUZ(2) indicating Immserve Forc Rules.
 ;     6 - BINF   (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     7 - BIPDSS (ret) Returned string of Visit IEN's that are
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
 N BIID
 ;---> Check for any input doses that Immserve identified as problems.
 D DPROBS^BIPATUP2(BIFORC,.BIPDSS,.BIID)
 ;
 ;---> Parse Doses Due from Immserve string (BIFORC), perform any
 ;---> necessary translations, and set as due in patient global ^BIPDUE(.
 ;---> If Immserve set Flu due, set BIIMMFL=1.  Same for H1N1.
 N BIIMMFL,BIIMMH1 S BIIMMFL=0,BIIMMH1=0
 D DDUE(BIFORC,BIAGE,BIHX,.BINF,BIID,.BIIMMFL,.BIIMMH1)
 ;
 ;---> Collect any Error Codes for any individual Vaccine Groups in
 ;---> the Immserve Forecast and set them in ^BIPERR(
 D IMMSERR^BIPATUP2(BIFORC)
 ;
 N BIFLU,BIFFLU,BILIVE,BIRISKI,BIRISKP
 S BIFLU="",(BIFFLU,BILIVE,BIRISKI,BIRISKP)=0
 ;
 ;---> Pre-IHS Forecast Preload.
 D IHSPREL(BIDFN,BIHX,BIFDT,.BIFLU,.BIFFLU,.BIRISKI,.BIRISKP,.BILIVE,BIDUZ2)
 ;
 ;---> Forecast Influenza.
 D IHSFLU^BIPATUP2(BIDFN,.BIFLU,BIFFLU,BIRISKI,.BINF,BIFDT,BIAGE,BIIMMFL,BIDUZ2)
 ;
 ;---> Forecast Pneumo.
 D IHSPNEU(BIDFN,.BIFLU,BIFFLU,BIRISKP,.BINF,BIFDT,BIAGE,BIDUZ2)
 ;
 ;---> Forecast Zostervax.
 D IHSZOS^BIPATUP3(BIDFN,.BIFLU,BIFFLU,BIRISKP,.BINF,BIFDT,BIAGE,BIDUZ2)
 ;
 ;---> Forecast H1N1. v8.33
 ;---> Disable for v8.4.
 ;D IHSH1N1^BIPATUP2(BIDFN,.BIFLU,BIFFLU,BIRISKI,.BINF,BIFDT,BIAGE,BIIMMH1,BILIVE)
 ;
 Q
 ;
 ;
 ;----------
DDUE(BIFORC,BIAGE,BIHX,BINF,BIID,BIIMMFL,BIIMMH1) ;EP
 ;---> Parse Doses Due from Immserve string (BIFORC), perform any
 ;---> necessary translations, and set as due in patient global ^BIPDUE.
 ;---> Parameters:
 ;     1 - BIFORC  (req) Forecast string coming back from ImmServe.
 ;     2 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     3 - BIHX    (req) String containing Patient's Imm History.
 ;     4 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     5 - BIID    (req) Immserve "Number of Input Doses" (Field 109 in 2010).
 ;     6 - BIIMMFL (opt) BIIMMFL=1 means Immserve already forecast Flu.
 ;     7 - BIIMMH1 (opt) BIIMMH1=1 means Immserve already forecast H1N1.
 ;
 ;---> Set BIPC=Piece number that contains "Number of Doses Due."
 ;---> BIID=Number of Input Doses that have to be "skipped over"
 ;---> to get to Doses Due data (and each Input Dose has 27 fields).
 N BIPC,BIDD
 ;S BIPC=102+(BIID*27)  ;ImmString2005.1(v8.1)
 ;S BIPC=107+(BIID*27)  ;ImmString2007.1(v8.2)
 S BIPC=111+(BIID*27)  ;ImmString2010.1(v8.4)
 ;
 ;---> Set BIDD="Number of Doses Due" (stored in piece BIPC).
 ;---> BIPC becomes a Piece Place Marker in the ImmServe Forecast string.
 S BIDD=$P(BIFORC,U,BIPC),BIPC=BIPC+1
 ;
 F I=1:1:BIDD D DDUE2(BIFORC,BIAGE,BIHX,.BINF,.BIPC,.BIIMMFL,.BIIMMH1)
 Q
 ;
 ;
 ;----------
DDUE2(BIFORC,BIAGE,BIHX,BINF,BIPC,BIIMMFL,BIIMMH1) ;EP
 ;---> Parse Doses Due (see linelabel DDUE above).
 ;---> Parameters: See DDUE immediately above!
 ;
 N BIDR,A,C,D,X
 S X=$P(BIFORC,U,BIPC,BIPC+11)
 ;---> A=CVX Code, C=Past Due, D=Date For this "Dose Due."
 ;
 ;---> Uncomment next line to see raw ImmServe Doses Due:
 ;W !!!,X R ZZZ
 ;
 S A=$P(X,U,2),C=$P(X,U,5),D=$P(X,U,11)
 ;---> Set Piece Place Marker to next dose.
 S BIPC=BIPC+12  ;ImmString2007.1(v8.2); no change for ImmString2010.1(v8.4).
 ;---> Get date.
 S D=$$IMMSDT^BIPATUP2(D)
 Q:'D
 ;---> If this dose is past due (C=1), D(2) will stuff DATE PAST DUE;
 ;---> Otherwise, D(1) will stuff RECOMMENDED DATE DUE.
 S (D(1),D(2))="" D
 .I C S D(2)=D Q
 .S D(1)=D
 ;
 ;---> *** TRANSLATIONS OF INCOMING IMMSERVE VACCINES:
 ;--->     -------------------------------------------
 ;
 ;---> * * * PNEUMO * * *
 ;---> If incoming Dose is Pneumo (HL7 33 or 109) and the patient is
 ;---> 5 yrs or older, then ignore it; we forecast pneumo below.
 ;---> 100 is for kids; do not intercept.
 I BIAGE>59 Q:A=33  Q:A=109
 ;
 ;---> * * * TETANUS * * *
 ;---> If A(HL7)=-10 this is a Td Adult booster, so translate.
 S:A=-10 A=9
 ;---> If A(HL7)=-13 this is a Tdap booster, so translate.
 S:A=-13 A=115
 ;
 ;---> * * * HEP A * * *
 ;---> If Pt age > 18 yrs, translate any PED Hep A to HEP A, ADULT (52).
 I BIAGE'<216 S:((A=31)!(A=83)!(A=84)!(A=85)) A=52
 ;---> If Immserve sent CVX 31, tranlate to 83.
 S:A=31 A=83
 ;
 ;********** PATCH 2, v8.4, OCT 15,2010, IHS/CMI/MWR
 ;---> Translate forecasted CVX 15 to CVX 141 from now on.
 I A=15 S A=141
 ;**********
 ;
 ;---> * * * HEP B * * *
 ;---> If A(HL7)=8 (HEP B PEDS), and the Pt age is >19, and if the Pt has
 ;---> already had a form of ADULT HEP B, then translate to 43 (HEP B ADLT).
 I A=8 D
 .Q:(BIAGE<240)
 .;---> Loop through History string BIHX.
 .N B,I,X,Y S B=""
 .;---> NOTE!! X and Y may change if ImmServe Field Definitions change!
 .;---> Set Y=Number of Input Doses, X=Dose Note of first Input dose.
 .;S Y=$P(BIHX,U,48),X=49  ;ImmString2005.1(v8.1)
 .;S Y=$P(BIHX,U,51),X=52  ;ImmString2007.1(v8.2)
 .S Y=$P(BIHX,U,53),X=54  ;ImmString2010.1(v8.4)
 .F I=1:1:Y D  Q:(B=43)
 ..;---> For this Immunization, set A=HL7 Code, D=Date.
 ..N A,D S A=$P(BIHX,U,X+1),D=$P(BIHX,U,X+5)
 ..;---> Quit if Dose Override (ImmServe Input Field 51)=Invalid Dose=2.
 ..Q:$P(BIHX,U,X+6)
 ..;---> If this is a Hep B (8,42,43,44,45,51,104) Set A=43.
 ..S:((A=8)!(A=42)!(A=43)!(A=44)!(A=45)!(A=51)!(A=104)) B=43
 ..S X=X+7
 .I B=43 S A=43 Q
 .;---> If this adult patient has never had a Hep B, don't forecast it.
 .S A=""
 Q:A=""
 ;
 ;---> Check to see if Site specified do not forecast this Vaccine Group.
 Q:$D(BINF($$HL7TX^BIUTL2(A,1)))
 ;
 ;---> Add this Immunization Due.
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(A)_U_U_D(1)_U_D(2))
 ;
 ;---> If Immserve set Flu due, set BIIMMFL=1.
 ;********** PATCH 2, v8.4, OCT 15,2010, IHS/CMI/MWR
 ;---> Include CVX 140 & 141 when checking for Immserve.
 ;S:((A=15)!(A=16)!(A=88)!(A=111)!(A=123)) BIIMMFL=1
 S:((A=15)!(A=16)!(A=88)!(A=111)!(A=123)!(A=140)!(A=141)) BIIMMFL=1
 ;
 ;---> If Immserve set H1N1 due, set BIIMMH1=1.
 S:((A=125)!(A=126)!(A=127)!(A=128)) BIIMMH1=1
 ;
 Q
 ;
 ;
 ;----------
IHSPREL(BIDFN,BIHX,BIFDT,BIFLU,BIFFLU,BIRISKI,BIRISKP,BILIVE,BIDUZ2) ;EP
 ;---> IHS Forecast Preload.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIHX    (req) String containing Patient's Imm History.
 ;     3 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     4 - BIFLU   (ret) Influ, Pneumo, & H1N1 History array: BIFLU(CVX,INVDATE).
 ;     5 - BIFFLU  (ret) Value (0-4) for force Flu/Pneumo regardless of age.
 ;     6 - BIRISKI (ret) 1=Patient has Risk of Influenza; otherwise 0.
 ;     7 - BIRISKP (ret) 1=Patient has Risk of Pneumo; otherwise 0.
 ;     8 - BILIVE  (ret) 1-Patient received a LIVE vaccine <28 days before
 ;                       the forecast date.
 ;     9 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;
 ;---> Loop through History string, gathering previous Influenzas and Pneumos.
 ;
 N I,X,Y
 ;---> Set Y="Number of Input Doses" (stored in piece X).
 ;---> Set X=Piece number that contains "Dose Note" of the first Imm of the Hx.
 ;---> NOTE!! X and Y may change if ImmServe Field Definitions change!
 ;---> Next line may need to be incremented for new versions of ImmServe.
 ;S Y=$P(BIHX,U,48),X=49  ;ImmString2005.1(v8.1)
 ;S Y=$P(BIHX,U,51),X=52  ;ImmString2007.1(v8.2)
 S Y=$P(BIHX,U,53),X=54  ;ImmString2010.1(v8.4)
 ;
 ;---> Loop through History, collecting for prior Influ and Pneumo.
 ;---> Store in BIFLU by HL7 Code, inverse date.
 F I=1:1:Y D
 .;---> For this Immunization, set A=HL7 Code, D=Date.
 .N A,D S A=$P(BIHX,U,X+1),D=$P(BIHX,U,X+5)
 .;---> Quit if Dose Override (ImmServe Input Field 51)=Invalid Dose=2.
 .I $P(BIHX,U,X+6),$P(BIHX,U,X+6)<9 S X=X+7 Q
 .;
 .;---> If patient received Flu-nasal CVX 111 on the Forecast Date,
 .;---> then set BILIVE=1 (cannot receive 111 and 125 on the same day).
 .I ((A=111)&(BIFDT=$$IMMSDT^BIPATUP2(D))) S BILIVE=1
 .;
 .;---> If this was a live vaccine given less than 28 days prior to the
 .;---> forecast data, then set BILIVE=1.
 .I ((A=3)!(A=4)!(A=7)!(A=21)!(A=94)!(A=111)!(A=121)!(A=125)) D
 ..;---> Calculate #days between Forecast date and date of this live vaccine.
 ..N X,X1,X2 S X1=BIFDT,X2=$$IMMSDT^BIPATUP2(D)
 ..D ^%DTC
 ..;
 ..;---> Set BILIVE=1 if patient received this LIVE vaccine <28 days prior
 ..;---> to the Forecast date.
 ..S:((X>0)&(X<28)) BILIVE=1
 .;
 .;---> If this is a Pneumo (33,100,109) or Influ (15,16,88,111; but not 123)
 .;---> store it in local array BIFLU(CVX,Inverse Fileman date).
 .S:((A=100)!(A=109)) A=33
 .;
 .;********** PATCH 1, v8.5, JAN 03,2012, IHS/CMI/MWR
 .;---> Include FLU-DERMAL CVX=144.
 .;S:((A=15)!(A=16)!(A=111)!(A=135)) A=88
 .S:((A=15)!(A=16)!(A=111)!(A=135)!(A=144)) A=88
 .;**********
 .S:((A=126)!(A=127)!(A=128)) A=125
 .S:(A=33!(A=88)!(A=125)) BIFLU(A,9999999-$$IMMSDT^BIPATUP2(D))=""
 .;---> Add Zoster.  Imm v8.5
 .S:(A=33!(A=88)!(A=125)!(A=121)) BIFLU(A,9999999-$$IMMSDT^BIPATUP2(D))=""
 .S X=X+7
 ;
 ;
 ;---> Get value for forced Influenza regardless of age.
 ;---> 0=Normal, 1=Influenza, 2=Pneumococcal, 3=Both, 4=Disregard Risk Factors.
 S BIFFLU=$$INFL^BIUTL11(BIDFN)
 ;---> Quit (don't check Risk Factors) if BIFFLU=4, Disregard Risk Factors.
 Q:BIFFLU=4
 ;
 ;---> Quit if Site Param says NOT to include Risk Factors.
 Q:'$$RISKP^BIUTL2(BIDUZ2)
 ;
 ;---> Check for Influenza and Pneumo Risk Factors.
 ;---> If BIRISKI, BIRISKP =0, then either site param is turned off
 ;---> or patient is NOT High Risk.  Both cases exclude it from forecast.
 D RISK^BIDX(BIDFN,BIFDT,0,.BIRISKI,.BIRISKP)
 Q
 ;
 ;
 ;----------
IHSPNEU(BIDFN,BIFLU,BIFFLU,BIRISKP,BINF,BIFDT,BIAGE,BIDUZ2) ;EP
 ;---> IHS Pneumo Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Influ and Pneumo History array: BIBLU(CVX,INVDATE).
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
 Q:$$CONTR^BIUTL11(BIDFN,119)
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
 ;---> If High Risk Pneumo or Forecast Regardless of Age, set BIALLAGE=1.
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
 ;---> Quit if patient is <65yrs. (Only patients >65 can get 2nd pneumo.)
 Q:(BIAGE<780)
 ;
 ;---> If patient received most recent Pneumo <65yrs age, and if he received
 ;---> it 5 years before the forecast date, then forecast Pneumo.
 N BIDOB S BIDOB=$$DOB^BIUTL1(BIDFN)
 I BIMRECNT<(BIDOB+650000),((BIMRECNT+50000)'>BIFDT) D  Q
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_U_BIFDT)
 ;
 ;---> Patient is >65 yrs but had a Pneumo <5 yrs before forecast date,
 ;---> so do not forecast Pneumo yet.
 ;---> OR, patient had most recent Pneumo after age 65 and therefore no
 ;---> longer needs one.  Whew!
 Q
 ;---> If they request to bring back q6y pneumo forecasting, see Q6Y^BIPATUP2.
 Q
