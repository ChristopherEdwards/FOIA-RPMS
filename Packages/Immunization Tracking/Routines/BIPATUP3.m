BIPATUP3 ;IHS/CMI/MWR - UPDATE PATIENT DATA 2; DEC 15, 2011
 ;;8.5;IMMUNIZATION;**4**;DEC 01,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  IHS FORECAST. UPDATE PATIENT DATA, IMM FORECAST IN ^BIPDUE(.
 ;;  HOLDING RTN IN CASE H1N1 (OR SIMILAR) FORECASTING IS NEEDED IN THE FUTURE.
 ;;  PATCH 1: Clarify Report explanation.  IHSZOS+19
 ;;  PATCH 4, v8.5: Use newer Related Contraindications call to determine
 ;;                 contraindicaton.  IHSZOS+29
 ;
 ;----------
IHSZOS(BIDFN,BIFLU,BIFFLU,BIRISKP,BINF,BIFDT,BIAGE,BIDUZ2) ;EP
 ;---> IHS Zoster Forecast.
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
 ;
 ;---> Quit if this Pt Age <60 months (5yrs), regardless of risk.
 Q:BIAGE<720
 ;
 ;---> Quit if Site Parameter 11 says NO to Zoster forecast.
 ;---> (According to Amy, shutting down Varicella Group should not disable Zoster.)
 ;
 ;********** PATCH 1, v8.5, JAN 03,2012, IHS/CMI/MWR
 ;---> Use passed parameter BIDUZ2 to avoid <UNDEF> of BISITE.
 ;Q:('$$ZOSTER^BIPATUP2(BISITE))
 Q:('$$ZOSTER^BIPATUP2(BIDUZ2))
 ;**********
 ;
 ;---> Quit if patient has a previous Zoster.
 Q:$D(BIFLU(121))
 ;
 ;---> Quit if this patient has a contraindication to Zoster.
 ;********** PATCH 4, v8.5, DEC 01,2012, IHS/CMI/MWR
 ;---> Use newer Related Contraindications call to determine contraindication.
 ;Q:$$CONTR^BIUTL11(BIDFN,227)
 N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 Q:$D(BICT(121))
 ;**********
 ;
 ;---> Forecast Zoster.
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(121)_U_U_BIFDT)
 ;
 Q
 ;
 ;
 ;----------
IHSH1N1(BIDFN,BIFLU,BIFFLU,BIRISKI,BINF,BIFDT,BIAGE,BIIMMH1,BILIVE) ;EP
 ;---> IHS H1N1 Forecast.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient IEN.
 ;     2 - BIFLU   (req) Influ, Pneumo, and H1N1 History array: BIFLU(CVX,INVDATE).
 ;     3 - BIFFLU  (req) * NOT USED FOR NOW! *
 ;                       Value (0-4) for force Flu/Pneumo regardless of age.
 ;     4 - BIRISKI (req) 1=Patient has Risk of Influenza; otherwise 0.
 ;     5 - BINF    (opt) Array of Vaccine Grp IEN'S that should not be forecast.
 ;     6 - BIFDT   (req) Forecast Date (date used for forecast).
 ;     7 - BIAGE   (req) Patient Age in months for this Forecast Date.
 ;     8 - BIIMMH1 (opt) BIIMMFL=1 means Immserve already forecast H1N1.
 ;     9 - BILIVE  (opt) 1-Patient received a LIVE vaccine <28 days before
 ;                       the forecast date.
 ;
 ;---> Quit if Forecasting turned off for H1N1.
 Q:$D(BINF(18))
 ;
 ;---> Quit if Immserve already forecast H1N1.
 Q:$G(BIIMMH1)
 ;
 ;***********************************************************
 ;********** PATCH 4, v8.3, DEC 30,2009, IHS/CMI/MWR
 ;---> PATCH: No longer consider live vaccine factor in H1N1 forecasting.
 ;---> Quit if patient received a LIVE vaccine <28 days before forecast date.
 ;---> Also quit if patient received Flu-nasal CVX 111 on the Forecast Date.
 ;Q:$G(BILIVE)
 ;***********************************************************
 ;
 ;---> Set numeric Year, Month, and MonthDay.
 N BIYEAR,BIMTH,BIMDAY
 S BIYEAR=$E(BIFDT,1,3),BIMTH=$E(BIFDT,4,5),BIMDAY=+$E(BIFDT,4,7)
 ;
 ;---> Quit if the Forecast Date is not between Oct 1 and April 30.
 Q:((BIMDAY<1001)&(BIMDAY>430))
 ;
 ;---> Quit if this patient has a contraindication to H1N1.
 N BICONTR D CONTRA^BIUTL11(BIDFN,.BICONTR)
 Q:$D(BICONTR(125))
 ;
 ;---> Change: Quit if patient is <6 months.
 Q:BIAGE<6
 ;
 ;---> Get value for forced Influenza regardless of age.
 ;S:(31'[BIFFLU) BIFFLU=0
 ;
 ;---> Quit if over 65 yrs old and no previous H1N1 dose (regardless of risk).
 Q:((BIAGE>779)&('$D(BIFLU(125))))
 ;
 ;---> Forecast H1N1 up to 25 yrs old, and over 50 yrs.
 ;---> Quit if not age appropriate and no risk and not forced and no previous H1N1 dose.
 Q:((BIAGE>299)&('BIRISKI)&('BIFFLU)&('$D(BIFLU(125))))
 ;
 ;***********************************************************
 ;********** PATCH 4, v8.3, DEC 30,2009, IHS/CMI/MWR
 ;
 ;---> Quit if patient is 10yrs or older and has a one H1N1 already.
 ;Q:((BIAGE>120)&($D(BIFLU(125))))
 Q:((BIAGE'<120)&($D(BIFLU(125))))
 ;
 ;---> PATCH: Quit if the patient has had 2 doses.
 N M,N S M=0,N=0
 F  S M=$O(BIFLU(125,M)) Q:'M  S N=N+1
 Q:(N>1)
 ;***********************************************************
 ;
 N X,X1,X2
 S X1=BIFDT,X2=9999999-$O(BIFLU(125,0)) S:X2=9999999 X2=0
 D ^%DTC
 ;---> Quit if patient received a H1N1 shot today.
 Q:X=0
 ;---> Quit if patient had a H1N1 vac <28 days prior to Forecast date.
 Q:((X>0)&(X<28))
 ;
 ;---> X must be either null (never had flu shot) or negative (had
 ;---> a shot recently, but AFTER the Forecast Date).
 ;
 ;---> If not Jan, Feb, or March, then due date=Apr 30 of the new year.
 S:BIMDAY>430 BIYEAR=BIYEAR+1
 ;---> Due by April 30.
 N BIDUEDT S BIDUEDT=BIYEAR_0430
 ;---> Set CVX 127 due by April 30.
 D SETDUE^BIPATUP2(BIDFN_U_$$HL7TX^BIUTL2(127)_U_U_BIYEAR_"0430")
 Q
