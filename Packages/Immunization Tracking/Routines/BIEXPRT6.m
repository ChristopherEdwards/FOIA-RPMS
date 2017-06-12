BIEXPRT6 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**13**;AUG 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: BUILD PATIENT HISTORY EXPORT FOR FORECASTING.
 ;;  CALLED BY BIEXPRT3.
 ;;  PATCH 8: New routine to accommodate new TCH Forecaster   TCHHIST+0
 ;;  PATCH 13: Pass Flu Season Start & End Dates to TCH.  TCHHIST+128
 ;
 ;
 ;
 ;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 ;---> New Entry Point called from HISTORY+99^BIEXPRT3.
 ;----------
TCHHIST(BIFDT,BIDUZ2,BINF) ;EP
 ;---> Called by BIEXPRT3.
 ;---> Construct ^BITMP($J,2 nodes for Forecast exports from the
 ;---> ^BITMP($J,1 nodes (gathered in ^BIEXPRT2).
 ;---> This prepares the string of Patient Data to be sent to
 ;---> TCH for forecasting.
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
 .N BIAGE,BIDOSES,BITMP1 S BIDOSES=0
 .;---> Set Patient Age in Years for this Forecast Date.
 .S BIAGE=$$AGE^BIUTL1(BIDFN,1,BIFDT)
 .;
 .;---> Date used for Forecast (Field 1).
 .S BITMP1=$$FMTCHDT^BIUTL5(BIFDT)
 .;
 .;---> Forecasting Mode: Minimum vs. Recommended Age (Field 2).
 .S BITMP1=BITMP1_U_$$MINAGE^BIUTL2(BIDUZ2)
 .;
 .;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 .;---> Transmit Grace Period option instead of version.
 .;---> Version (Field 3).
 .;S BITMP1=BITMP1_U_$$RULES^BIUTL2(BIDUZ2)
 .;---> Grace Period (Field 3).
 .S BITMP1=BITMP1_U_$P($G(^BISITE(BIDUZ2,0)),U,21)
 .;
 .;---> Reserved for future use (Field 4).
 .S BITMP1=BITMP1_U_0
 .;
 .;---> Reserved for future use (Field 5).
 .S BITMP1=BITMP1_U_0
 .;
 .;---> Personal ID: Patient Name and Chart# (Field 6)
 .S BITMP1=BITMP1_U_$$NAME^BIUTL1(BIDFN)
 .S BITMP1=BITMP1_"  Chart#: "_$$HRCN^BIUTL1(BIDFN)
 .;
 .;---> User Note: DFN  (Field 7)
 .S BITMP1=BITMP1_U_BIDFN
 .;
 .;---> Date of Birth (Field 8).
 .S BITMP1=BITMP1_U_$$FMTCHDT^BIUTL5($$DOB^BIUTL1(BIDFN))
 .;
 .;---> Gender (Field 9).
 .S BITMP1=BITMP1_U_$$SEXW^BIUTL1(BIDFN)
 .;
 .;---> Mother HBsAg Status: P,N,U,A  (Field 10).
 .S BITMP1=BITMP1_U_$$MOTHER^BIUTL11(BIDFN)
 .;
 .;---> Build array of contraindicated HL7 Codes for this Patient.
 .N BICT D CONTRA^BIUTL11(BIDFN,.BICT)
 .;
 .;---> Pertussis Indication (Field 11).
 .D
 ..;---> If patient has contra to DTP or DTaP, pass contra to pertussis.
 ..N I,J S J=0 F I=1,11,20 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Diphtheria Indication (Field 12).
 .D
 ..;---> If pt has contra to DT-PEDS or TD-Adult, pass contra to Diph.
 ..N I,J S J=0 F I=28,9 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Tetanus Indication (Field 13).
 .D
 ..;---> If pt has contra to TET TOX,
 ..;---> pass contra to Tetanus.
 ..N I,J S J=0 F I=28,9,35 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Hib Indication (Field 14).
 .D
 ..;---> If pt has contra to any HIB, pass contra to HIB.
 ..N I,J S J=0 F I=17,46,47,48,49 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> HBIG Indication (Field 15).
 .S BITMP1=BITMP1_U_$S($D(BICT(30)):1,1:0)
 .;
 .;---> HepB Indication (Field 16).
 .S BITMP1=BITMP1_U_$S($D(BICT(45)):1,1:0)
 .;
 .;---> OPV Indication (Field 17).
 .;---> 2003: ImmServe no longer forecasts OPV.
 .;S BITMP1=BITMP1_U_$S($D(BICT(2)):1,$D(BINF(2)):1,1:0)
 .S BITMP1=BITMP1_U_0
 .;
 .;---> IPV Indication (Field 18).
 .S BITMP1=BITMP1_U_$S($D(BICT(10)):1,1:0)
 .;
 .;---> Measles Indication (Field 19).
 .S BITMP1=BITMP1_U_$S($D(BICT(5)):1,1:0)
 .;
 .;---> Mumps Indication (Field 20).
 .S BITMP1=BITMP1_U_$S($D(BICT(7)):1,1:0)
 .;
 .;---> Rubella Indication (Field 21).
 .S BITMP1=BITMP1_U_$S($D(BICT(6)):1,1:0)
 .;
 .;---> Varicella Indication (Field 22).
 .S BITMP1=BITMP1_U_$S($D(BICT(21)):1,1:0)
 .;
 .;---> HepA Indication (Field 23).
 .S BITMP1=BITMP1_U_$S($D(BICT(85)):1,1:0)
 .;
 .;---> Rotavirus Indication (Field 24).
 .S BITMP1=BITMP1_U_$S($D(BICT(74)):1,1:0)
 .;
 .;---> Pneumococcal Indication (Field 25).
 .;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 .;---> Add ALL Pneumos.
 .D
 ..;---> If pt has contra to any Pneumo, pass contra to Pneumo.
 ..N I,J S J=0 F I=33,100,109,133 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;---> Influenza Indication (Field 26).
 .;********** PATCH 13, v8.5, AUG 01,2016, IHS/CMI/MWR
 .;---> Pass Flu Season Start & End Dates to TCH.
 .;S BITMP1=BITMP1_U_$S($D(BICT(88)):1,1:0)
 .D
 ..;---> If Flu contraindicated, concat 1 and quit.
 ..I $D(BICT(88)) S BITMP1=BITMP1_U_1 Q
 ..;---> Pass Site's Flu season dates.
 ..S BITMP1=BITMP1_U_$$FLUDATS^BIUTL8(BIDUZ2)
 .;**********
 .;
 .;---> Meningococcal Indication (Field 27).
 .S BITMP1=BITMP1_U_$S($D(BICT(32)):1,1:0)
 .;
 .;---> HPV Indication (Field 28).
 .S BITMP1=BITMP1_U_$S($D(BICT(62)):1,1:0)
 .;
 .;---> H1N1 Indication (Field 29).
 .D
 ..;---> If pt has contra to any H1N1, pass contra to H1N1.
 ..N I,J S J=0 F I=125,126,127,128 I $D(BICT(I)) S J=1 Q
 ..S BITMP1=BITMP1_U_J
 .;
 .;********** PATCH 8, v8.5, MAR 15,2014, IHS/CMI/MWR
 .;---> Add Zoster Contraindication field.
 .;---> Zoster Indication (Field 30).
 .S BITMP1=BITMP1_U_$S($D(BICT(121)):1,1:0)
 .;
 .;---> Delimiter between Patient Case Data and Imm History Doses.
 .S BITMP1=BITMP1_U_"~~~"
 .;**********
 .;
 .;
 .N BIMM,BITMP S BIMM=0,BITMP=""
 .F  S BIMM=$O(^BITMP($J,1,BIDFN,BIMM)) Q:'BIMM  D
 ..N BIDATE,Y S BIDATE=0
 ..F  S BIDATE=$O(^BITMP($J,1,BIDFN,BIMM,BIDATE)) Q:'BIDATE  D
 ...N BIVIMM,Y S BIVIMM=0
 ...F  S BIVIMM=$O(^BITMP($J,1,BIDFN,BIMM,BIDATE,BIVIMM)) Q:'BIVIMM  D
 ....;---> Tack on V Imm IEN for matching ImmServe History.
 ....N BIDOSE S Y=^BITMP($J,1,BIDFN,BIMM,BIDATE,BIVIMM)_"^"_BIVIMM
 ....D DOSES(Y,BIAGE,.BIDOSE,.BIDOSES)
 ....S BITMP=BITMP_BIDOSE
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
DOSES(Y,BIAGE,BIDOSE,BIDOSES) ;EP
 ;---> Add data (4 TCH fields) for one dose to BITMP.
 ;---> Parameters:
 ;     1 - Y       (req) Data for one visit, stored in ^BITMP($J,1,BIDFN...
 ;                       CVX Code^Dose Override^TCH Date^V Imm IEN.
 ;     2 - BIAGE   (req) Patient Age in years (for translating Td).
 ;     3 - BIDOSE  (ret) Data returned for one "Input Dose":
 ;                       Dose Note(V Imm IEN)^CVX Code^Date of Dose
 ;                       ^Dose Override^Reserved^Reserved
 ;     4 - BIDOSES (ret) Total number of doses collected (not used for now).
 ;
 Q:$G(Y)=""
 S:$G(BIDOSE)="" BIDOSE=""
 S:$G(BIDOSES)="" BIDOSES=0
 ;
 ;---> Quit if no Dose CVX Code or if NULL.
 Q:"NULL"[$P(Y,U,1)
 ;
 ;---> Dose Note - ^V Imm IEN (Field 1).
 S BIDOSE=$P(Y,U,4)
 ;
 ;---> Dose HL7/CVX Code (Field 2)  * * * ALL OUTGOING TRANSLATIONS HERE * * *
 ;***** TRANSLATIONS NECESSARY??? ****
 D
 .;---> If this is an Adult Td Booster and patient age>7, send -10 to ImmServe.
 .;I $P(Y,U,1)=9!($P(Y,U,1)=113) I BIAGE>6 S BIDOSE=BIDOSE_U_-10 Q
 .;
 .;---> If this is Tdap, send -13 to ImmServe.
 .;
 .;********** PATCH 2, v8.5, MAY 15,2012, IHS/CMI/MWR
 .;---> Include CVX 20 (DTaP) in translation to -13, so that DTaP satisfies Tdap.
 .;---> During Beta Test decision was made to abandon this for now, due to
 .;---> complications.  However, Tdap CVX 115 translated to -13 on 7yrs and older.
 .;I $P(Y,U,1)=115 I BIAGE>6 S BIDOSE=BIDOSE_U_-13 Q
 .;I $P(Y,U,2)=115!($P(Y,U,2)=20) I BIAGE>6 S BIDOSE=BIDOSE_U_-13 Q
 .;**********
 .;
 .;********** PATCH 2, v8.4.2, Oct 15,2010, IHS/CMI/MWR
 .;---> Translate new Flu CVX Codes 140 & 141 to 15 until Immserve can accommodate.
 .;---> If this is a new Flu, send 15.
 .;
 .;********** PATCH 5, v8.5, JUL 01,2013, IHS/CMI/MWR
 .;---> Recognize new Flu Codes.
 .;I ($P(Y,U,2)=140)!($P(Y,U,2)=141)  S BIDOSE=BIDOSE_U_15 Q
 .;N Z S Z=($P(Y,U,1))
 .;I (Z=149)!(Z=150)!(Z=151)!(Z=153)!(Z=155)!(Z=158)  S BIDOSE=BIDOSE_U_15 Q
 .;**********
 .;
 .;---> No translation of this dose.
 .S BIDOSE=BIDOSE_U_$P(Y,U,1)
 ;
 ;
 ;---> Date of Dose Administration--Visit Date (Field 3).
 S BIDOSE=BIDOSE_U_$P(Y,U,3)
 ;
 ;---> Dose Override: (Field 4).
 ;---> 0=Exclude if violates screening rules
 ;---> 1=Include even if violates screening rules
 ;---> 2=Exclude per user input (invalidated by user, e.g., expired vaccine).
 D
 .;---> Interpret Dose Override for ImmServe.
 .N X S X=(+$P(Y,U,2))
 .D:X
 ..I X=9 S X=1 Q
 ..S X=2
 .S BIDOSE=BIDOSE_U_X
 ;
 ;---> Reserved for future use (Field 5).
 S BIDOSE=BIDOSE_"^0"
 ;
 ;---> Reserved for future use (Field 6).
 S BIDOSE=BIDOSE_"^0"
 ;
 ;---> End of Dose Delimiter.
 S BIDOSE=BIDOSE_"|||"
 ;
 ;---> Keep count of doses.
 S BIDOSES=BIDOSES+1
 Q
