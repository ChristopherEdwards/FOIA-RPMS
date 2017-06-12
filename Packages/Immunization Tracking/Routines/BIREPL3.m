BIREPL3 ;IHS/CMI/MWR - REPORT, ADULT IMM; OCT 15, 2010
 ;;8.5;IMMUNIZATION;**12**;MAY 01,2016
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  GATHER DATA FOR ADULT IMMUNIZATION REPORT.
 ;;  PATCH 1:  Commented out for ref to ICPT for Code Set versioning. LASTFLU+25
 ;;  PATCH 2: Filter for Active Clinical, using new standard $$ACTCLIN^BIUTL6 call.
 ;;           GETSTATS+60
 ;;  PATCH 3: Set HPV upper limit for males to 21 years of age. GETSTATS+119
 ;;  PATCH 12: Include CVX 133 in Pneumo stats.  PNEU+15
 ;;            Add new Composite Measures.  GETSTATS+32
 ;
 ;
 ;----------
GETSTATS(BIQDT,BICC,BIHCF,BIBEN,BICPTI,BIUP,BITOTS) ;EP
 ;---> Produce array for ADULT Immunization Report.
 ;---> Parameters:
 ;     1 - BIQDT  (req) Quarter Ending Date.
 ;     2 - BICC   (req) Current Community array.
 ;     3 - BIHCF  (req) Health Care Facility array.
 ;     4 - BIBEN  (req) Beneficiary Type array.
 ;     5 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT (default).
 ;     6 - BIUP   (req) User Population/Group (Registered, Imm, User, Active).
 ;     7 - BITOTS (ret) Totals delimited by "^":
 ;                      Pc   Variable
 ;                       1 - BI19=Total over 19
 ;                       2 - BIT19 = Number over 19 w/Tetanus past 10 years.
 ;                       3 - BITDAP = Number over 19 w/Tdap past 10 years.
 ;
 ;                       4 - BIHPVF  = Total number of Females age 19-26
 ;                       5 - BIHPVF1 = Number Females 19-26 w/HPV-1
 ;                       6 - BIHPVF2 = Number Females 19-26 w/HPV-2
 ;                       7 - BIHPVF3 = Number Females 19-26 w/HPV-3
 ;                       8 - BIHPVF  = Total number of Males age 19-26
 ;                       9 - BIHPVM1 = Number Males 19-21 w/HPV-1
 ;                      10 - BIHPVM2 = Number Males 19-21 w/HPV-2
 ;                      11 - BIHPVM3 = Number Males 19-21 w/HPV-3
 ;
 ;                      12 - BI60=Total over 60
 ;                      13 - BIZ60 = Number over 60 w/Zoster ever.
 ;                      14 - BI65=Total over 65
 ;                      15 - BIT65 = Number over 65 w/Tetanus past 10 years.
 ;                      16 - BIP65 = Number over 65 w/Pneumo at or after age 65.
 ;                      17 - BIP65E = Number over 65 w/Pneumo EVER.
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> New Composite Measure Variables.
 ;                      18 - BIC19=Total >19 <60
 ;                      19 - BIC191=Tdap ever
 ;                      20 - BIC192=(Td or Tdap) <10 yrs
 ;                      21 - BIC193=(Tdap ever) AND ((Tdap or Td) <10 yrs)
 ;
 ;                      22 - BIC60=Total >60 <65
 ;                      23 - BIC601=Tdap ever
 ;                      24 - BIC602=(Td or Tdap) <10 yrs
 ;                      25 - BIC603=Zoster
 ;                      26 - BIC604=(Tdap ever) AND ((Tdap or Td) <10 yrs) AND Zoster
 ;
 ;                      27 - BIC65=Total >65
 ;                      28 - BIC651=Tdap ever
 ;                      29 - BIC652=(Td or Tdap) <10 yrs
 ;                      30 - BIC653=Zoster
 ;                      31 - BIC654=Pneumo >65 yrs
 ;                      32 - BIC655=(Tdap ever) AND ((Tdap or Td) <10 yrs) AND Zoster AND Pneumo
 ;                      33 - BICUTDD=Overall UTD Denominator
 ;                      34 - BICUTDN-Overall UTD Numerator
 ;
 N BIC19,BIC191,BIC192,BIC193,BIC60,BIC601,BIC602,BIC603,BIC604
 S (BIC19,BIC191,BIC192,BIC193,BIC60,BIC601,BIC602,BIC603,BIC604)=0
 N BIC65,BIC651,BIC652,BIC653,BIC654,BIC655,BICAGE,BICUTDD,BICUTDN
 S (BIC65,BIC651,BIC652,BIC653,BIC654,BIC655,BICUTDD,BICUTDN)=0
 ;**********
 ;
 N BIADOB,BIADOBE,BI19,BIT19,BITDAP
 N BIHPVF,BIHPVF1,BIHPVF2,BIHPVF3,BIHPVM,BIHPVM1,BIHPVM2,BIHPVM3
 N BI60,BIZ60
 N BI65,BIT65,BIP65,BIP65E
 ;
 S (BI19,BIHPVF,BIHPVM,BI60,BI65,BIP65,BI65E)=0
 S:('$D(BICPTI)) BICPTI=0
 S:('$G(BIQDT)) BIQDT=$G(DT)
 ;
 ;---> Loop through Patient global looking for visits and immunizations.
 ;---> DOB must be at least 19 years before Quarter Ending Date.
 S BIADOB=0,BIADOBE=BIQDT-190000
 F  S BIADOB=$O(^DPT("ADOB",BIADOB)) Q:(BIADOB>BIADOBE)  D
 .N BIDFN S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",BIADOB,BIDFN)) Q:'BIDFN  D
 ..;
 ..;---> Filter for standard Patient Population parameter.
 ..Q:'$$PPFILTR^BIREP(BIDFN,.BIHCF,BIQDT,BIUP)
 ..;
 ..;---> Get Age in Years for Stats.
 ..N BIAGE S BIAGE=$$AGE^BIUTL1(BIDFN,1,BIQDT)
 ..;---> Quit if under age 19 on the Quarter Ending Date.
 ..Q:BIAGE<19
 ..;
 ..;---> Quit if Beneficiary Type doesn't match.
 ..Q:$$BENT^BIDUR1(BIDFN,.BIBEN)
 ..;
 ..;---> Quit if Current Community doesn't match.
 ..Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ..;
 ..;---> Set patient as Not Due, BIVAL=2
 ..;---> If patient is due (change below), set BIVAL=1.
 ..S BIVAL=2
 ..;
 ..;---> Set Composite Flags.
 ..N BIFTD10,BIFTDAP,BIFZO,BIFPNE
 ..S (BIFTD10,BIFTDAP,BIFZO,BIFPNE)=0
 ..;
 ..;---> Set Age totals.
 ..S BI19=BI19+1 S:BIAGE>59 BI60=BI60+1 S:BIAGE>64 BI65=BI65+1
 ..;**********
 ..D
 ...;---> Set BICAGE=19,60,or 65 for Age categories.
 ...I BIAGE<60 S BICAGE=19,BIC19=BIC19+1 Q
 ...I (BIAGE>59)&(BIAGE<65) S BICAGE=60,BIC60=BIC60+1 Q
 ...I BIAGE>64 S BICAGE=65,BIC65=BIC65+1
 ...;**********
 ..;
 ..;
 ..;---> TETANUS STATS ******************************
 ..;---> Check Td/Tdap <10 yrs.
 ..D
 ...I $$TD(BIDFN,BICPTI,BIQDT) D  Q
 ....S BIT19=$G(BIT19)+1 S:BIAGE>64 BIT65=$G(BIT65)+1
 ....;**********
 ....S BIFTD10=1 D
 .....I BICAGE=19 S BIC192=BIC192+1 Q
 .....I BICAGE=60 S BIC602=BIC602+1 Q
 .....I BICAGE=65 S BIC652=BIC652+1
 ....;**********
 ...;---> Patient NO Td/Tdap <10 yrs, is/was due for Tetanus.
 ...S BIVAL=1
 ..;
 ..;
 ..;---> Tdap Stats.
 ..;---> If Tdap <10 yrs.
 ..I $$TD(BIDFN,BICPTI,BIQDT,1) S BITDAP=$G(BITDAP)+1
 ..;**********
 ..;---> If Tdap EVER.
 ..I $$TD(BIDFN,BICPTI,BIQDT,2) D
 ...S BIFTDAP=1
 ...I BICAGE=19 S BIC191=BIC191+1 Q
 ...I BICAGE=60 S BIC601=BIC601+1 Q
 ...I BICAGE=65 S BIC651=BIC651+1
 ..;**********
 ..;---> FLU STATS - *** PREVIOUS CODE SAVED IN ^BIZFLU.
 ..;
 ..;
 ..;---> PNEUMO STATS *******************************^
 ..D
 ...N BIPNE65 S BIPNE65=$$PNEU(BIDFN,BIAGE,BICPTI,BIQDT)
 ...;---> Patient received Pneumo EVER.
 ...I $P(BIPNE65,U,2) S BIP65E=$G(BIP65E)+1
 ...;**********
 ...;---> If patient received Pneumo at or after age 65 *OR* < 5yrs, set flag.
 ...I ($P(BIPNE65,U))!($P(BIPNE65,U,3)) I BICAGE=65 S BIC654=BIC654+1,BIFPNE=1
 ...;**********
 ...;---> If patient received Pneumo at or after age 65, quit: no longer due.
 ...I $P(BIPNE65,U) S BIP65=$G(BIP65)+1 Q
 ...;---> If >64 yrs and didn't receive pneumo, patient is due.
 ...I BIAGE>64 S BIVAL=1
 ..;
 ..;
 ..;---> ZOSTER STATS *********************************
 ..D
 ...I $$OZSTER(BIDFN,BICPTI,BIQDT) D  Q
 ....S:BIAGE>59 BIZ60=$G(BIZ60)+1
 ....;
 ....;**********
 ....S BIFZO=1
 ....I BICAGE=60 S BIC603=BIC603+1 Q
 ....I BICAGE=65 S BIC653=BIC653+1
 ...;
 ...;---> Patient is/was due for Zostervax if 60+ years on QDT.
 ...;********** v8.5, MAY 15,2011, IHS/CMI/MWR
 ...;---> Do NOT include patient in Not Current group for zoster.
 ...;S:BIAGE>59 BIVAL=1
 ..;
 ..;
 ..;---> GPRA COMPOSITE MEASURES ************************
 ..;
 ..;---> CompOsite for 19-59yrs:
 ..;---> if Tdap EVER *AND* Td/Tdap <10yrs, set flag.
 ..I BICAGE=19,BIFTD10,BIFTDAP S BIC193=BIC193+1
 ..;
 ..;---> Composite for 60-64yrs:
 ..;---> if Tdap EVER *AND* Td/Tdap <10yrs *AND* Zoster, set flag.
 ..I BICAGE=60,BIFTD10,BIFTDAP,BIFZO S BIC604=BIC604+1
 ..;
 ..;---> Compisite for >64yrs:
 ..;---> if Tdap EVER *AND* Td/Tdap <10yrs *AND* Zoster *and* Pneumo, set flag.
 ..I BICAGE=65,BIFTD10,BIFTDAP,BIFZO,BIFPNE S BIC655=BIC655+1
 ..;
 ..;
 ..;
 ..;---> HPV STATS **************************************
 ..;********** PATCH 3, v8.5, SEP 10,2012, IHS/CMI/MWR
 ..;---> Change HPV limit to 21 yrs for males.
 ..;---> HPV Stats (ages 19-26 for females, 19-21 for males).
 ..N BISECS S BISEX=$$SEX^BIUTL1(BIDFN)
 ..;I (BIAGE>18)&(BIAGE<27) D
 ..I (BIAGE>18)&(BIAGE<$S(BISEX="F":27,1:22)) D
 ...;N BIHPVD,BISEX S BISEX=$$SEX^BIUTL1(BIDFN)
 ...;S BIHPVD=$$HPV(BIDFN,BICPTI,BIQDT)
 ...;**********
 ...;
 ...N BIHPVD S BIHPVD=$$HPV(BIDFN,BICPTI,BIQDT)
 ...I BISEX="F" D  Q
 ....S BIHPVF=$G(BIHPVF)+1
 ....S:BIHPVD>0 BIHPVF1=$G(BIHPVF1)+1
 ....S:BIHPVD>1 BIHPVF2=$G(BIHPVF2)+1
 ....S:BIHPVD>2 BIHPVF3=$G(BIHPVF3)+1
 ...I BISEX="M" D  Q
 ....S BIHPVM=$G(BIHPVM)+1
 ....S:BIHPVD>0 BIHPVM1=$G(BIHPVM1)+1
 ....S:BIHPVD>1 BIHPVM2=$G(BIHPVM2)+1
 ....S:BIHPVD>2 BIHPVM3=$G(BIHPVM3)+1
 ..;
 ..;---> Will Set ^TMP("BIDUL",$J,CURCOM,1,HRCN,BIDFN)=$G(BIVAL)
 ..D STORE^BIDUR1(BIDFN,DT,9,,$G(BIVAL))
 ..;
 ..;---> Add refusals, if any.
 ..N Z D CONTRA^BIUTL11(BIDFN,.Z,1) I $O(Z(0)) S BITMP("REFUSALS",BIDFN)=""
 ;
 ;---> Now piece together the totals.
 S BITOTS=$G(BI19)_U_$G(BIT19)_U_$G(BITDAP)
 S BITOTS=BITOTS_U_$G(BIHPVF)_U_$G(BIHPVF1)_U_$G(BIHPVF2)_U_$G(BIHPVF3)
 S BITOTS=BITOTS_U_$G(BIHPVM)_U_$G(BIHPVM1)_U_$G(BIHPVM2)_U_$G(BIHPVM3)
 S BITOTS=BITOTS_U_$G(BI60)_U_$G(BIZ60)_U_$G(BI65)_U_$G(BIT65)_U_$G(BIP65)_U_$G(BIP65E)
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> Calculate Overall UTD
 S BICUTDD=BIC19+BIC60+BIC65
 S BICUTDN=BIC193+BIC604+BIC655
 ;---> Add new Composite Measure Variables.
 S BITOTS=BITOTS_U_$G(BIC19)_U_$G(BIC191)_U_$G(BIC192)_U_$G(BIC193)
 S BITOTS=BITOTS_U_$G(BIC60)_U_$G(BIC601)_U_$G(BIC602)_U_$G(BIC603)_U_$G(BIC604)
 S BITOTS=BITOTS_U_$G(BIC65)_U_$G(BIC651)_U_$G(BIC652)_U_$G(BIC653)_U_$G(BIC654)
 S BITOTS=BITOTS_U_$G(BIC655)_U_$G(BICUTDD)_U_$G(BICUTDN)
 Q
 ;
 ;
 ;----------
TD(BIDFN,BICPTI,BIQDT,BITDAP) ;EP
 ;---> Return 1 if patient received TD during 10 years prior to QDT.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;     4 - BITDAP (opt) 1=Tdap ONLY during 10 years prior to QDT.
 ;                      2=Tdap ONLY and EVER (no prior date restriction).
 ;
 ;---> Check V Imms for TD's.
 N BICVXS,BIDATE
 S BIDATE=0 S:('$G(BIQDT)) BIQDT=$G(DT)
 S BITDAP=+$G(BITDAP)
 S BICVXS="1,9,20,22,28,50,106,107,110,113,115"
 S:BITDAP BICVXS=115
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT)
 ;
 ;---> So, BIDATE is the latest TD in V Imm (but not after the QDT).
 ;
 ;---> Check (if requested) V CPTs for TD's.
 D:$G(BICPTI)
 .N BICPTS,Y
 .S BICPTS="90701,90718,90700,90720,90702,90703,90721,90723"
 .S:BITDAP BICPTS=90715
 .S Y=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT)
 .S:Y>$G(BIDATE) BIDATE=Y
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> If BITDAP=2, return 1 if Tdap EVER.
 I BITDAP=2 Q $S(BIDATE:1,1:0)
 ;**********
 ;
 ;---> Return 0 if last Td was MORE than 10 yrs prior to QDT (or never);
 ;---> otherwise return 1.
 Q $S((BIDATE+100000)<BIQDT:0,1:1)
 ;
 ;
 ;----------
PNEU(BIDFN,BIAGE,BICPTI,BIQDT) ;EP
 ;---> Return date if patient received Pneumo, concat ^1 if received after 65;
 ;---> concat a second ^1 if received within the last 5 years.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BIAGE  (req) Patient age in years.
 ;     3 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     4 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date)
 ;
 ;---> Return 0 if patient is less than 65 yrs old.
 Q:(BIAGE<65) 0
 ;
 ;---> Check V Imms for PNEU's.
 N BICVXS,BIDATE
 S BIDATE=0 S:('$G(BIQDT)) BIQDT=$G(DT)
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> Include CVX 133 in Pneumo stats.
 ;S BICVXS="33,100,109"
 S BICVXS="33,100,109,133"
 ;**********
 ;
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT)
 ;
 ;---> So, BIDATE is the latest PNEU in V Imm (but not after the QDT).
 ;
 ;---> Check (if requested) V CPTs for FLU's.
 D:$G(BICPTI)
 .N BICPTS,Y
 .S BICPTS="90732,90669"
 .S Y=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT)
 .S:Y>$G(BIDATE) BIDATE=Y
 ;
 ;---> Patient never received pneumo.
 I +BIDATE=0 Q "0^0^0"
 ;
 ;---> If patient received pneumo at or after age 65, set BI65=1 (otherwise 0).
 N BI65 S BI65=1
 I ($$DOB^BIUTL1(BIDFN)+650000)>BIDATE S BI65=0
 ;
 ;********** PATCH 12, v8.5, MAY 01,2016, IHS/CMI/MWR
 ;---> Return 3rd pc: If received within 5 yrs, return 1 (1= <5ys; 0= >5yrs).
 N BI5Y S BI5Y=0
 I (BIQDT-BIDATE)<50001 S BI5Y=1
 ;
 ;---> Return After 65 indicator_^_Date of last Pneumo_^_<5yr indicator.
 Q BI65_U_+BIDATE_U_BI5Y
 ;**********
 ;
 ;
 ;----------
OZSTER(BIDFN,BICPTI,BIQDT) ;EP
 ;---> NOTE: "O" and "Z" reversed to avoid SACC trigger of $Z violation.
 ;---> Return 1 if patient ever received Zostavax prior to the QDT.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;
 ;---> Check V Imms for Zostavax's.
 N BICVXS,BIDATE
 S BIDATE=0 S:('$G(BIQDT)) BIQDT=$G(DT)
 S BICVXS="121"
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT)
 ;
 ;---> So, BIDATE is the latest Zostavax in V Imm (but not after the QDT).
 ;
 ;---> Check (if requested) V CPTs for Zostavax's.
 D:$G(BICPTI)
 .N BICPTS,Y
 .S BICPTS="90736"
 .S Y=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT)
 .S:Y>$G(BIDATE) BIDATE=Y
 ;
 ;---> Return 0 if patient Never received Zostavax prior to QDT otherwise DATE.
 Q +BIDATE
 ;
 ;
 ;----------
HPV(BIDFN,BICPTI,BIQDT) ;EP
 ;---> Return number of HPV's patient received, concat
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;
 ;---> Check V Imms for FLU's.
 N BICVXS,BIDATE,BIDOSES,I,J
 S BIDATE=0,BIDOSES=0,J=0
 S:('$G(BIQDT)) BIQDT=$G(DT)
 S BICVXS="62,118,137"
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT,1)
 ;
 F I=1:1:3 I $P(BIDATE,",",I) S J=J+1
 S BIDOSES=J
 ;
 ;---> Check (if requested) V CPTs for HPV's.
 D:$G(BICPTI)
 .N BICPTS,J S J=0
 .S BICPTS="90649,90650"
 .S BIDATE=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT,1)
 .F I=1:1:3 I $P(BIDATE,",",I) S J=J+1
 .S BIDOSES=BIDOSES+J
 ;
 Q BIDOSES
