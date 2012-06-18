BIPATUP2 ;IHS/CMI/MWR - UPDATE PATIENT DATA 2; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**1**;JAN 03,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  IHS FORECAST. UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  PATCH 1, v8.4: Change Flu forecast dates to match Immserve dates:
 ;;                 begin 8/15 and end 3/14.   IHSFLU+24
 ;;  PATCH 2: Forecast cvx 141 instead of CVX 15.  IHSFLU+81
 ;;  PATCH 2: Adjust earliest day that a flu will count for this Flu season. IHSFLU+68
 ;
 ;;  PATCH 1, v8.5: Correct Flu forecast for new year of current season. IHSFLU+86
 ;
 ;
IMMSERR(BIFORC) ; EP
 ;---> Collect any Error Codes for any individual Vaccine Groups
 ;---> from Fields 25,27,29,31,33,35,37,39,41,43,45,47,49,51 in Immserve Forecast.
 ;---> The BIVX string below represents the Vaccine Groups as they appear
 ;---> in the ImmServe forecast, Fields 25-49:    ;ImmString2007.1(v8.2)
 ;---> in the ImmServe forecast, Fields 25-51:    ;ImmString2010.1(v8.4)
 ;---> Parameters:
 ;     1 - BIFORC (req) Forecast string coming back from ImmServe.
 ;
 ;N BIVX S BIVX="HEPB^DTP^TD_B^HIB^POLIO^MMR^HEPA^VAR^ROTA^PNEUMO^FLU^MENING^HPV"
 N BIVX S BIVX="HEPB^DTP^TD_B^HIB^POLIO^MMR^HEPA^VAR^ROTA^PNEUMO^FLU^MENING^HPV^H1N1"
 ;
 ;---> Next line: logic to associate correct Vaccine Group with error.
 ;F I=25:2:47 D    ;ImmString2005.1(v8.1)
 ;F I=25:2:49 D    ;ImmString2007.1(v8.2)
 F I=25:2:51 D    ;ImmString2010.1(v8.4)
 .N M,N,X S X=$P(BIFORC,U,I)
 .Q:(X>(-1))
 .N BIDR,BIERR,BIVGRP
 .S BIVGRP=$P(BIVX,U,(((I-1)/2)-11))
 .;---> Set Error Code.
 .S BIERR=800+(-X)  S:'$D(^BIERR(BIERR,0)) BIERR=999
 .;
 .;---> Ignore Dose# too big for series (per Dr. Rosalyn Singleton).
 .Q:BIERR=805
 .Q:$$DECEASED^BIUTL1(BIDFN)
 .;
 .;---> Add this Error to BI PATIENT FORECAST ERRORS File.
 .S M=^BIPERR(0),N=$P(M,U,3),M=$P(M,U,4) S:'N N=1
 .F  Q:'$D(^BIPERR(N))  S N=N+1
 .S ^BIPERR(N,0)=BIDFN_U_BIERR_U_BIVGRP
 .S ^BIPERR("B",BIDFN,N)=""
 .S $P(^BIPERR(0),U,3,4)=N_U_(M+1)
 .Q
 Q
 ;
 ;
 ;----------
IHSFLU(BIDFN,BIFLU,BIFFLU,BIRISKI,BINF,BIFDT,BIAGE,BIIMMFL,BIDUZ2) ;EP
 ;---> IHS Influenza Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Influ and Pneumo History array: BIFLU(CVX,INVDATE).
 ;     3 - BIFFLU  (req) Value (0-4) for force Flu/Pneumo regardless of age.
 ;     4 - BIRISKI (req) 1=Patient has Risk of Influenza; otherwise 0.
 ;     5 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     6 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     7 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     8 - BIIMMFL (opt) BIIMMFL=1 means Immserve already forecast Flu.
 ;     9 - BIDUZ2  (req) User's DUZ(2) indicating Immserve Forc Rules.
 ;
 ;---> Quit if Forecasting turned off for Influenza.
 Q:$D(BINF(10))
 ;
 ;---> Quit if Immserve already forecast Flu.
 Q:$G(BIIMMFL)
 ;
 ;---> Set numeric Year, Month, and MonthDay.
 N BIYEAR,BIMTH,BIMDAY
 S BIYEAR=$E(BIFDT,1,3),BIMTH=$E(BIFDT,4,5),BIMDAY=+$E(BIFDT,4,7)
 ;
 ;---> Set Forecast year (yr due). If forecast date is not in Jan, Feb, or Mar,
 ;---> then due date will be Mar 31 of the next year.
 N BIFYEAR S BIFYEAR=BIYEAR S:BIMDAY>331 BIFYEAR=BIYEAR+1
 ;
 ;---> Quit if the Forecast Date is not between Aug 1 and March 31.
 Q:((BIMDAY<801)&(BIMDAY>331))
 ;
 ;---> Quit if this patient has a contraindication to Influenza.
 N BICONTR D CONTRA^BIUTL11(BIDFN,.BICONTR)
 Q:$D(BICONTR(88))
 ;
 ;---> Quit if patient is <60 months (5 years).
 ;---> Influenza forecasting for 6-60 done by Immserve.
 ;Q:BIAGE<60
 ;---> Post-Immserve forecasting: Quit if less than 6 months old.
 Q:BIAGE<6
 ;
 ;---> Get value for forced Influenza regardless of age.
 S:(31'[BIFFLU) BIFFLU=0
 ;
 ;---> If not Flu for ALL patients (site parameter#27=1), then forecast
 ;---> Influenza age 6 mths to 18 yrs old (quit on 19th bday), and over 50 yrs.
 ;---> Quit if not age appropriate and no risk and not forced for Influ.
 ;
 I '$$FLUALL($G(BIDUZ2)) Q:((BIAGE>227)&(BIAGE<600)&('BIRISKI)&('BIFFLU))
 ;
 ;---> Set BILF = Fileman Date of last Flu shot.
 N X,X1,X2,BILF
 S X1=BIFDT,(BILF,X2)=9999999-$O(BIFLU(88,0))
 ;---> If patient never had a previous Flu, set BILF=0
 S:X2=9999999 (BILF,X2)=0
 ;---> BILF=Fileman date of last Flu.
 D ^%DTC
 ;---> Quit if patient received a flu shot today.
 Q:X=0
 ;
 ;---> Quit if patient had a Flu vac <28 days prior to Forecast date.
 Q:((X>0)&(X<28))
 ;
 ;---> NOT SURE ABOUT THIS.  CHECK, THINK ABOUT LATER.
 ;---> X must be either null (never had flu shot) or negative (had
 ;---> a shot recently, but AFTER the Forecast Date).
 ;
 N BIBEGS D
 .;---> Set earliest day that a flu will count for this Flu season.
 .I BIMDAY<316 S BIBEGS=($E(BIFDT,1,3)-1)_"0731" Q
 .S BIBEGS=$E(BIFDT,1,3)_"0731"
 ;
 ;---> If patient's last flu shot was this season AND they are 9 yrs old or
 ;---> or older, quit.
 I ((BIAGE>107)&(BILF>BIBEGS)) Q
 ;
 ;---> If this patient has had NO flu shot this season, forecast flu and quit.
 I BILF<(BIBEGS+1) D SETDUE(BIDFN_U_$$HL7TX^BIUTL2(141)_U_U_BIFYEAR_0331) Q
 ;
 ;---> So, this is a kid less than 9 yrs old who has had at least one flu shot
 ;---> this season but not in less than 28 days.
 ;
 ;---> Rewrite Flu history array to make "readable."
 N BIFLUR,M,N S N=0
 F  S N=$O(BIFLU(88,N)) Q:'N  S BIFLUR(9999999-N)=""
 ;
 ;---> Quit if this kid already has 2 or more flu shots this season.
 ;********** PATCH 1, v8.5, JAN 03,2012, IHS/CMI/MWR
 ;---> Correct Flu forecast for new year of current season
 ;S M=0,N=BIYEAR_"0000"
 S M=0,N=BIBEGS
 ;**********
 ;
 F  S N=$O(BIFLUR(N)) Q:'N  S M=M+1
 Q:(M>1)
 ;
 ;---> Okay, so this <9 yr old had one flu shot this season 28 days or more ago.
 ;---> Quit if he had a flu shot last season 8/1/10 to 6/30/11.
 ;---> Set Last year/season.
 N BILYEAR S BILYEAR=$S((BIMDAY<316):BIYEAR-2,1:BIYEAR-1)
 ;---> Set M=number of doses last season.
 S M=0,N=BILYEAR_"0731"
 F  S N=$O(BIFLUR(N)) Q:'N  Q:(N>((BILYEAR+1)_"0630"))  S M=M+1
 ;---> Quit if this kid had 1 or more doses last season.
 Q:M
 ;
 ;---> Kid is <9 yrs, no doses last year, <2 doses this year.
 ;---> Set patient due for FLU-TIV.
 D SETDUE(BIDFN_U_$$HL7TX^BIUTL2(141)_U_U_BIFYEAR_0331)
 ;
 Q
 ;
 ;
 ;----------
DPROBS(BIFORC,BIPDSS,BIID) ;EP
 ;---> Check for any Input Doses that have Dose Problems.
 ;---> If any exist, build the string BIPDSS, concatenating the
 ;---> Visit IEN's with U.
 ;---> Parameters:
 ;     1 - BIFORC (req) Forecast string coming back from ImmServe.
 ;     2 - BIPDSS (ret) Returned string of Visit IEN's that are Problem Doses.
 ;                      according to ImmServe.
 ;     3 - BIID   (ret) Immserve "Number of Input Doses" (Field 109 in 2010).
 ;
 S BIPDSS="" N BIPC,I
 ;
 ;---> The "Number of Input Doses" field tells how many inputted doses to
 ;---> "skip over" in order to get to the forecast.  This will be BIID.
 ;---> The first historical dose should start at the "Dose Note" Field
 ;---> (usu ~p44 of Fred's document).  This will be BIPC.
 ;
 ;S BIID=$P(BIFORC,U,100),BIPC=102  ;ImmString2005.1(v8.1)
 ;S BIID=$P(BIFORC,U,105),BIPC=107  ;ImmString2007.1(v8.2)
 S BIID=$P(BIFORC,U,109),BIPC=111  ;ImmString2010.1(v8.4)
 F I=1:1:BIID D
 .N J,K,L
 .;---> Set K=string of data--27 ^-fields, which are the ImmServe Output
 .;---> Fields 102-128 (echo of input doses) for this dose. ImmString2005.1(v8.1)
 .;---> Fields 107-133 (echo of input doses) for this dose. ImmString2007.1(v8.2)
 .;---> Fields 111-137 (echo of input doses) for this dose. ImmString2010.1(v8.4)
 .S K=$P(BIFORC,U,BIPC,BIPC+26)
 .;
 .;---> If this dose has a problem, add a piece to BIPDSS in the form of
 .;---> Visit IEN_%_HL7 (ImmS Fld 111) of Combo or Component with the problem.
 .;---> Next fields begin at Immserve Output Field 107, i.e.,
 .;---> piece 3 = Field 109 pc 8 = Field 114, etc.  . ;ImmString2007.1(v8.2)
 .;---> piece 3 = Field 113 pc 8 = Field 118, etc.  . ;ImmString2010.1(v8.4)
 .;S L=0 F J=3,8,12,15,18,19,20,23,24,25 D  Q:L  ;Ignore pc 3 & 8 (no dose# sent).
 .S L=0 F J=12,15,18,19,20,23,24,25 D  Q:L
 ..;
 ..;---> Quit if this field has no error.
 ..Q:'$P(K,U,J)
 ..;
 ..;---> Uncomment next line to examine this problem dose as it comes back
 ..;---> from Immserve.
 ..;X ^O
 ..;
 ..S BIPDSS=BIPDSS_$P(K,U)_"%"_$P(K,U,5)_U,L=1
 .;
 .S BIPC=BIPC+27
 Q
 ;
 ;
 ;----------
KILLDUE(BIDFN) ;EP
 ;---> Clear out any previously set Immunizations Due and
 ;---> any Forecasting Errors for this patient.
 ;---> Hardcoded to improve performance during massive reports.
 ;---> Parameters:
 ;     1 - BIDFN (req) Patient IEN.
 ;
 Q:'BIDFN
 ;
 ;---> Clear previous Immunizations Due.
 D:$D(^BIPDUE("B",BIDFN))
 .N N S N=0
 .F  S N=$O(^BIPDUE("B",BIDFN,N)) Q:'N  D
 ..N Y,Z S Y=$G(^BIPDUE(N,0))
 ..K ^BIPDUE(N),^BIPDUE("B",BIDFN,N)
 ..Q:Y=""
 ..S Z=$P(Y,U,4) K:Z ^BIPDUE("D",Z,N)
 ..S Z=$P(Y,U,5) K:Z ^BIPDUE("D",Z,N)
 ..S $P(^BIPDUE(0),U,4)=$P(^BIPDUE(0),U,4)-1
 .K ^BIPDUE("B",BIDFN),^BIPDUE("E",BIDFN)
 ;
 ;---> Clear previous Forecasting Errors.
 D:$D(^BIPERR("B",BIDFN))
 .N N S N=0
 .F  S N=$O(^BIPERR("B",BIDFN,N)) Q:'N  D
 ..K ^BIPERR("B",BIDFN,N),^BIPERR(N)
 ..S $P(^BIPERR(0),U,4)=$P(^BIPERR(0),U,4)-1
 .K ^BIPERR("B",BIDFN)
 Q
 ;
 ;
 ;----------
IMMSDT(DATE) ;EP
 ;---> Convert Immserve Date (format MMDDYYYY) TO FILEMAN
 ;---> Internal format.
 ;---> NOTE: This code is copied from routine ^BIUTL5 for speed.
 ;---> Any changes here should also be made to ^BIUTL5 too.
 Q:'$G(DATE) "NO DATE"
 Q ($E(DATE,5,9)-1700)_$E(DATE,1,2)_$E(DATE,3,4)
 ;
 ;
 ;----------
PNMAGE(BISITE) ;EP - Return Age Appropriate in years for Pneumo at this site.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) "65"
 N Y
 S Y=$P($G(^BISITE(BISITE,0)),U,10) S:'Y Y=65
 Q Y
 ;---> q6-years no longer used.
 ;Q:'$G(BISITE) "65^0"
 ;N Y,Z
 ;S Y=$P($G(^BISITE(BISITE,0)),U,10) S:'Y Y=65
 ;S Z=$P($G(^BISITE(BISITE,0)),U,22) S:'Z Z=0
 ;Q Y_U_Z
 Q
 ;
 ;
 ;----------
FLUALL(BISITE) ;EP - Return 1 to forecast Flu for ALL ages.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) 1
 N Y S Y=$P($G(^BISITE(BISITE,0)),U,27)
 Q:(Y=0) 0
 Q 1
 ;
 ;
 ;----------
ZOSTER(BISITE) ;EP - Return 1 if Zostervax should be forecast.
 ;---> Parameters:
 ;     1 - BISITE (req) User's DUZ(2)
 ;
 Q:'$G(BISITE) 1
 N Y S Y=$P($G(^BISITE(BISITE,0)),U,29)
 Q:(Y=0) 0
 Q 1
 ;
 ;
 ;----------
SETDUE(BIDATA) ;EP
 ;---> Code to add this Immunization Due to BI PATIENT IMM DUE File #9002084.1.
 ;---> Hardcoded to improve performance during massive reports.
 ;---> Parameters:
 ;     1 - BIDATA (req) Data string (5 fields) for 0-node.
 ;                      BIDFN^Vaccine IEN^Dose#^Recommended Date^Date Past Due
 ;
 Q:$G(BIDATA)=""
 N A,B,BIDFN,M,N
 S M=^BIPDUE(0),N=$P(M,U,3),M=$P(M,U,4) S:'N N=1
 F  Q:'$D(^BIPDUE(N))  S N=N+1
 S BIDFN=$P(BIDATA,U) Q:'BIDFN
 S ^BIPDUE(N,0)=BIDATA
 ;
 ;********** PATCH 1, v8.3.1, Dec 30,2008, IHS/CMI/MWR
 ;---> Add 6th pc, Date Forecast Calculated.
 S:$G(DT) $P(^BIPDUE(N,0),U,6)=DT
 ;**********
 ;
 S ^BIPDUE("B",BIDFN,N)=""
 S A=$P(BIDATA,U,4),B=$P(BIDATA,U,5)
 I A S ^BIPDUE("D",A,N)=""
 I B S ^BIPDUE("D",B,N)="",^BIPDUE("E",BIDFN,B,N)=""
 S $P(^BIPDUE(0),U,3,4)=N_U_(M+1)
 Q
 ;
 ;
Q6Y ;EP - NOT USED AS OF 2010.
 ;
 ;*****************************
 ;EARLIER PNEUMO FORECASTING, WITH 6YR PARAMETER.  SAVE FOR A WHILE. (2010)
 ;---> NOT USED:
 ;---> If BI6YR=1 forecast Pneumo every 6yrs; BI6YR=0 forecast one time only.
 ;N BI6YR S BI6YR=$P($$PNMAGE^BIPATUP2(BIDUZ2),U,2)
 ;
 ;*****************************
 ;---> If Pt should be forecast at all ages (High Risk or Forced):
 ;---> If site param says one-time only, then forecast if necessary and quit.
 ;---> If site param says q6y and Pt's last Pneumo was more than 6 years,
 ;---> forecast Pneumo, Quit
 I BIALLAGE D  Q
 .;---> Quit if Pt has had a previous Pneumo and site is not forecasting q6y.
 .;Q:((BIMRECNT)&('BI6YR))
 .Q:BIMRECNT
 .;
 .;---> Quit if most recent plus 6 years is after the forecast date.
 .;Q:((BIMRECNT+60000)>BIFDT)
 .;
 .;---> Pt has either never had a pneumo or more that 6 years before the
 .;---> forecast date; so forecast pneumo.
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_U_BIFDT)
 ;
 ;---> * * * At this point Patient must be past (or at) Pneumo Age. * * *
 ;
 ;---> If PT is past Pneumo Age and has no previous Pneumo,
 ;---> then forecast Pneumo and quit.
 I '$D(BIFLU(33)) D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_U_BIFDT) Q
 ;
 ;---> * * * At this point Patient has had at least one pneumo sometime. * * *
 ;
 ;---> If PT is past Pneumo Age and most recent Pneumo was before Pt reached
 ;---> Pneumo Site Param Age, then add 5 yrs to most recent Pneumo; if that
 ;---> date is not after the Forecast Date, then forecast Pneumo and quit.
 ;
 ;---> BIFPDATE=Date by which Pt should have had first Pneumo.
 N BIDOB,BIFPDATE
 S BIDOB=$$DOB^BIUTL1(BIDFN),BIFPDATE=BIDOB+(BIPNAGE*10000)
 I BIMRECNT<BIFPDATE,((BIMRECNT+50000)'>BIFDT) D  Q
 .D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_U_BIFDT)
 ;
 ;
 ;---> If the Site Param says forecast every 6 years, and the Pt is past
 ;---> Pneumo Age, and most recent Pneumo was NOT before Pt reached
 ;---> Pneumo Site Param Age, then add 6 yrs to most recent Pneumo;
 ;---> if that date is not after Forecast Date, then forecast Pneumo and quit.
 ;I BI6YR,BIMRECNT'<BIFPDATE,((BIMRECNT+60000)'>BIFDT) D  Q
 ;.D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(33)_U_U_BIFDT)
 Q
