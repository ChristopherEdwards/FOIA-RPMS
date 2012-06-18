BIEXPRT5 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS; OCT 15, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: BUILD IMMSERVE EXPORT.
 ;;  CALLED BY BIEXPRT3.
 ;;  PATCH 1: KINFIX call no longer necessary; Immserve updated.
 ;;  PATCH 2: Translate new Flu CVX Codes 140 & 141 to 15 until Immserve can
 ;;           accommodate.  DOSES+44
 ;
 ;
 ;----------
IMMSERV(BIFDT,BIDUZ2,BINF) ;EP
 ;---> Called by BIEXPRT3.
 ;---> Construct ^BITMP($J,2 nodes for ImmServe exports from the
 ;---> ^BITMP($J,1 nodes (gathered in ^BIEXPRT2).
 ;---> This prepares the string of Patient Data to be sent to
 ;---> Immserve for forecasting.
 ;---> Parameters:
 ;     1 - BIFDT  (opt) Forecast Date (date used to calc Imms due).
 ;     2 - BIDUZ2 (opt) User's DUZ(2) for BISITE parameters,
 ;                      which affect forecasting rules.
 ;     3 - BINF   (opt) Array of Vaccine IEN's that should not be forecast.
 ;
 ;---> If no Forecast Date passed, set it equal to today.
 S:'$G(BIFDT) BIFDT=DT
 ;
 ;---> If no BIDUZ2, try DUZ(2); otherwise, defaults will be used.
 S:'$G(BIDUZ2) BIDUZ2=$G(DUZ(2))
 ;
 N BIDFN S BIDFN=0
 F  S BIDFN=$O(^BITMP($J,1,BIDFN)) Q:'BIDFN  D
 .N BIAGE,BIDOSES,BIMM,BITMP,BITMP1 S BIDOSES=0,BIMM=0,BITMP=""
 .;---> Set Patient Age in Years for this Forecast Date.
 .S BIAGE=$$AGE^BIUTL1(BIDFN,1,BIFDT)
 .F  S BIMM=$O(^BITMP($J,1,BIDFN,BIMM)) Q:'BIMM  D
 ..N BIDATE,Y S BIDATE=0
 ..F  S BIDATE=$O(^BITMP($J,1,BIDFN,BIMM,BIDATE)) Q:'BIDATE  D
 ...N BIVIMM,Y S BIVIMM=0
 ...F  S BIVIMM=$O(^BITMP($J,1,BIDFN,BIMM,BIDATE,BIVIMM)) Q:'BIVIMM  D
 ....;---> Tack on V Imm IEN for matching ImmServe History.
 ....S Y=^BITMP($J,1,BIDFN,BIMM,BIDATE,BIVIMM)_"^"_BIVIMM
 ....D DOSES(Y,BIAGE,.BITMP,.BIDOSES)
 .;
 .;---> Log Errors (Field 1).  1=Do log errors, 0=Do NOT log errors.   vvv83
 .S BITMP1=+$P($G(^BISITE(+BIDUZ2,0)),U,26)
 .;
 .;---> Date used for Forecast (Field 2).
 .S BITMP1=BITMP1_U_$$NOSLDT^BIUTL5(BIFDT)
 .;
 .;---> Fields 3-8 ignored by ImmServe.
 .S BITMP1=BITMP1_"^0^0^0^0^0^0"
 .;
 .;---> Forecasting Mode: Minimum vs. Recommended Age (Field 9).
 .S BITMP1=BITMP1_U_$$MINAGE^BIUTL2(BIDUZ2)
 .;
 .;---> Numbered Dose Processing Flag: Ignore Dose Numbers (Field 10).
 .S BITMP1=BITMP1_U_"I"
 .;
 .;---> Invalid/Valid Dose Forecasting Interval: I-Consider Interval (Field 11).
 .S BITMP1=BITMP1_U_"I"
 .;
 .;---> HEP B Series (Vaccine Group) Activation Flag (Field 12).
 .S BITMP1=BITMP1_U_$S($D(BINF(4)):0,1:1)
 .;
 .;---> DTP Series (Vaccine Group) Activation Flag (Field 13).
 .S BITMP1=BITMP1_U_$S($D(BINF(1)):0,1:1)
 .;
 .;---> Td ADULT/Booster Series (V Group) Activation Flag (Field 14).
 .S BITMP1=BITMP1_U_$S($D(BINF(8)):0,1:1)
 .;
 .;---> HIB Series (Vaccine Group) Activation Flag (Field 15).
 .S BITMP1=BITMP1_U_$S($D(BINF(3)):0,1:1)
 .;
 .;---> POLIO Series (Vaccine Group) Activation Flag (Field 16).
 .S BITMP1=BITMP1_U_$S($D(BINF(2)):0,1:1)
 .;
 .;---> MMR Series (Vaccine Group) Activation Flag (Field 17).
 .S BITMP1=BITMP1_U_$S($D(BINF(6)):0,1:1)
 .;
 .;---> HEP A Series (Vaccine Group) Activation Flag (Field 18).
 .S BITMP1=BITMP1_U_$S($D(BINF(9)):0,1:1)
 .;
 .;---> VARICELLA Series (Vaccine Group) Activation Flag (Field 19).
 .S BITMP1=BITMP1_U_$S($D(BINF(7)):0,1:1)
 .;
 .;---> ROTAVIRUS Series (Vaccine Group) Activation Flag (Field 20).
 .S BITMP1=BITMP1_U_$S($D(BINF(15)):0,1:1)
 .;
 .;---> PNEUMO-CONJ Series (Vaccine Group) Activation Flag (Field 21).
 .S BITMP1=BITMP1_U_$S($D(BINF(11)):0,1:1)
 .;
 .;---> INFLUENZA Series (Vaccine Group) Activation Flag (Field 22).
 .S BITMP1=BITMP1_U_$S($D(BINF(10)):0,1:1)
 .;
 .;---> MENINGOCOCAL Series (Vaccine Group) Activation Flag (Field 23).
 .S BITMP1=BITMP1_U_$S($D(BINF(16)):0,1:1)
 .;
 .;---> HPV Series (Vaccine Group) Activation Flag (Field 24).
 .S BITMP1=BITMP1_U_$S($D(BINF(17)):0,1:1)
 .;
 .;---> H1N1 Series (Vaccine Group) Activation Flag (Field 25).
 .;---> Imm Program has said to disable H1N1 forecasting.
 .S BITMP1=BITMP1_U_0
 .;
 .;---> Version (Field 26).
 .S BITMP1=BITMP1_U_$$RULES^BIUTL2(BIDUZ2)
 .;
 .;---> Forecasting days/month (Field 27).
 .S BITMP1=BITMP1_U_0
 .;
 .;---> Retrospective Analysis days/month (Field 28).
 .S BITMP1=BITMP1_U_0
 .;
 .;---> Personal ID: Patient Name and Chart# (Field 29)
 .S BITMP1=BITMP1_U_$$NAME^BIUTL1(BIDFN)
 .S BITMP1=BITMP1_"  Chart#: "_$$HRCN^BIUTL1(BIDFN)
 .;
 .;---> User Note: DFN  (Field 30)
 .S BITMP1=BITMP1_U_BIDFN
 .;
 .;---> Date of Birth (Field 31).
 .S BITMP1=BITMP1_U_$$NOSLDT^BIUTL5($$DOB^BIUTL1(BIDFN))
 .;
 .;---> Gender (Field 32).
 .S BITMP1=BITMP1_U_$$SEXW^BIUTL1(BIDFN)
 .;
 .;---> Mother HBsAg Status: P,N,U,A  (Field 33).
 .S BITMP1=BITMP1_U_$$MOTHER^BIUTL11(BIDFN)
 .;
 .;---> Build array of contraindicated HL7 Codes for this Patient.
 .N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 .;
 .;---> Pertussis Indication (Field 34).
 .D
 ..;---> If patient has contra to DTP or DTaP, pass contra to pertussis.
 ..N I,J S J=0 F I=1,11,20 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Diphtheria Indication (Field 35).
 .D
 ..;---> If pt has contra to DT-PEDS or TD-Adult, pass contra to Diph.
 ..N I,J S J=0 F I=28,9 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Tetanus Indication (Field 36).
 .D
 ..;---> If pt has contra to TET TOX,
 ..;---> pass contra to Tetanus.
 ..N I,J S J=0 F I=28,9,35 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Hib Indication (Field 37).
 .D
 ..;---> If pt has contra to any HIB, pass contra to HIB.
 ..N I,J S J=0 F I=17,46,47,48,49 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> HBIG Indication (Field 38).
 .S BITMP1=BITMP1_U_$S($D(BICT(30)):1,1:0)
 .;
 .;---> HepB Indication (Field 39).
 .S BITMP1=BITMP1_U_$S($D(BICT(45)):1,1:0)
 .;
 .;---> OPV Indication (Field 40).
 .;---> 2003: ImmServe no longer forecasts OPV.
 .;S BITMP1=BITMP1_U_$S($D(BICT(2)):1,$D(BINF(2)):1,1:0)
 .S BITMP1=BITMP1_U_0
 .;
 .;---> IPV Indication (Field 41).
 .S BITMP1=BITMP1_U_$S($D(BICT(10)):1,1:0)
 .;
 .;---> Measles Indication (Field 42).
 .S BITMP1=BITMP1_U_$S($D(BICT(5)):1,1:0)
 .;
 .;---> Mumps Indication (Field 43).
 .S BITMP1=BITMP1_U_$S($D(BICT(7)):1,1:0)
 .;
 .;---> Rubella Indication (Field 44).
 .S BITMP1=BITMP1_U_$S($D(BICT(6)):1,1:0)
 .;
 .;---> Varicella Indication (Field 45).
 .S BITMP1=BITMP1_U_$S($D(BICT(21)):1,1:0)
 .;
 .;---> HepA Indication (Field 46).
 .S BITMP1=BITMP1_U_$S($D(BICT(85)):1,1:0)
 .;
 .;---> Rotavirus Indication (Field 47).
 .S BITMP1=BITMP1_U_$S($D(BICT(74)):1,1:0)
 .;
 .;---> Pneumococcal Indication (Field 48).
 .S BITMP1=BITMP1_U_$S($D(BICT(100)):1,1:0)
 .;
 .;---> Influenza Indication (Field 49).
 .S BITMP1=BITMP1_U_$S($D(BICT(88)):1,1:0)
 .;
 .;---> Meningococcal Indication (Field 50).
 .S BITMP1=BITMP1_U_$S($D(BICT(32)):1,1:0)
 .;
 .;---> HPV Indication (Field 51).
 .S BITMP1=BITMP1_U_$S($D(BICT(62)):1,1:0)
 .;
 .;---> H1N1 Indication (Field 52).
 .D
 ..;---> If pt has contra to any H1N1, pass contra to H1N1.
 ..N I,J S J=0 F I=125,126,127,128 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Number of Input Doses (Field 53).
 .S BITMP1=BITMP1_U_BIDOSES
 .;
 .;---> Allow for Maximum Global Length to be as small as 255.
 .;---> This gets picked up in +63^BIEXPRT4.
 .S BITMP=BITMP1_BITMP
 .S ^BITMP($J,2,BIDFN,1,1,1)=$E(BITMP,1,250)
 .S:$L(BITMP)>250 ^BITMP($J,2,BIDFN,1,1,1,1)=$E(BITMP,251,500)
 .S:$L(BITMP)>500 ^BITMP($J,2,BIDFN,1,1,1,2)=$E(BITMP,501,750)
 .S:$L(BITMP)>750 ^BITMP($J,2,BIDFN,1,1,1,3)=$E(BITMP,751,1000)
 .S:$L(BITMP)>1000 ^BITMP($J,2,BIDFN,1,1,1,4)=$E(BITMP,1001,1250)
 .S:$L(BITMP)>1250 ^BITMP($J,2,BIDFN,1,1,1,5)=$E(BITMP,1251,1500)
 .S:$L(BITMP)>1500 ^BITMP($J,2,BIDFN,1,1,1,6)=$E(BITMP,1501,1750)
 .S:$L(BITMP)>1750 ^BITMP($J,2,BIDFN,1,1,1,7)=$E(BITMP,1751,2000)
 Q
 ;
 ;----------
DOSES(Y,BIAGE,BITMP,BIDOSES) ;EP
 ;---> Add data (5 Immserve fields) for one dose to BITMP.
 ;---> Parameters:
 ;     1 - Y       (req) Data for one visit, stored in ^BITMP($J,1,BIDFN...
 ;                       Date^HL7 Code^Dose Override^V Imm IEN.
 ;     2 - BIAGE   (req) Patient Age in years (for translating Td).
 ;     3 - BITMP   (ret) Data returned for one "Input Dose" to ImmServe.
 ;                       Dose Note (V Imm IEN)^HL7 Code^Dose Number^Date of Dose
 ;                       ^Dose Override.
 ;     4 - BIDOSES (ret) Total number of doses being collected to
 ;                       pass to ImmServe.
 ;
 Q:$G(Y)=""
 S:$G(BITMP)="" BITMP=""
 S:$G(BIDOSES)="" BIDOSES=0
 ;
 ;---> Quit if no Dose HL7 Code or if NULL.
 Q:"NULL"[$P(Y,U,2)
 ;
 ;************************
 ;---> Temp fix for Kinrix until v8.31.
 ;
 ;********** PATCH 1, v8.3.1, Dec 30,2008, IHS/CMI/MWR
 ;---> Next line commented out; KINFIX call no longer necessary (Immserve updated).
 ;---> But retain this call in case a future vaccine combo needs to be interpreted
 ;---> ahead of an Immserve update.
 ;
 ;I $P(Y,U,2)=130 D KINFIX(Y) Q
 ;
 ;---> Temp fix for Kinrix until v8.31.
 ;************************
 ;
 ;---> Dose Note - ^V Imm IEN (Field 52).
 S BITMP=BITMP_U_$P(Y,U,4)
 ;
 ;---> Dose HL7/CVX Code (Field 53)  * * * ALL OUTGOING TRANSLATIONS HERE * * *
 D
 .;---> If this is an Adult Td Booster and patient age>7, send -10 to ImmServe.
 .I $P(Y,U,2)=9!($P(Y,U,2)=113) I BIAGE>6 S BITMP=BITMP_U_-10 Q
 .;
 .;---> If this is Tdap, send -13 to ImmServe.
 .I $P(Y,U,2)=115 S BITMP=BITMP_U_-13 Q
 .;
 .;
 .;********** PATCH 2, v8.4.2, Oct 15,2010, IHS/CMI/MWR
 .;---> Translate new Flu CVX Codes 140 & 141 to 15 until Immserve can accommodate.
 .;---> If this is a new Flu, send 15.
 .I ($P(Y,U,2)=140)!($P(Y,U,2)=141)  S BITMP=BITMP_U_15 Q
 .;**********
 .;
 .;---> No translation of this dose.
 .S BITMP=BITMP_U_$P(Y,U,2)
 ;
 ;---> Dose Number--or "Series Number" (Field 54).
 ;---> New Version 8.x+ no longer tracks dose numbers (Field 54, 55, 56).
 S BITMP=BITMP_"^0^0^0"
 ;
 ;---> Date of Dose Administration--Visit Date (Field 57).
 S BITMP=BITMP_U_$P(Y,U)
 ;
 ;---> Dose Override: (Field 58).
 ;---> 0=Exclude if violates screening rules
 ;---> 1=Include even if violates screening rules
 ;---> 2=Exclude per user input (invalidated by user, e.g., expired vaccine).
 D
 .;---> Interpret Dose Override for ImmServe.
 .N X S X=(+$P(Y,U,3))
 .D:X
 ..I X=9 S X=1 Q
 ..S X=2
 .S BITMP=BITMP_U_X
 ;
 ;---> Keep count of doses.
 S BIDOSES=BIDOSES+1
 Q
 ;
 ;
KINFIX(Y) ;EP
 ;---> TO ACCOMODATE IMMSERVE NOT RECOGNIZING KINRIX.
 ;---> DELETE THIS SECTION WITH NEW IMMSERVE, IMM V8.31.
 N BIX F BIX=10,20 D
 .;
 .;---> Dose Note - ^V Imm IEN (Field 52).
 .S BITMP=BITMP_U_$P(Y,U,4)
 .;
 .S BITMP=BITMP_U_BIX
 .;
 .;---> Dose Number--or "Series Number" (Field 54).
 .;---> New Version 8.x+ no longer tracks dose numbers (Field 54, 55, 56).
 .S BITMP=BITMP_"^0^0^0"
 .;
 .;---> Date of Dose Administration--Visit Date (Field 57).
 .S BITMP=BITMP_U_$P(Y,U)
 .;
 .;---> Dose Override: (Field 58).
 .;---> 0=Exclude if violates screening rules
 .;---> 1=Include even if violates screening rules
 .;---> 2=Exclude per user input (invalidated by user, e.g., expired vaccine).
 .D
 ..;---> Interpret Dose Override for ImmServe.
 ..N X S X=(+$P(Y,U,3))
 ..D:X
 ...I X=9 S X=1 Q
 ...S X=2
 ..S BITMP=BITMP_U_X
 .;
 .;---> Keep count of doses.
 .S BIDOSES=BIDOSES+1
 Q
