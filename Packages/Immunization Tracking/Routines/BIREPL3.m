BIREPL3 ;IHS/CMI/MWR - REPORT, ADULT IMM; OCT 15, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  GATHER DATA FOR ADULT IMMUNIZATION REPORT.
 ;;  PATCH 1:  Commented out for ref to ICPT for Code Set versioning. LASTFLU+25
 ;;  PATCH 2: Filter for Active Clinical, using new standard $$ACTCLIN^BIUTL6 call.
 ;;           GETSTATS+60
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
 ;                       9 - BIHPVM1 = Number Males 19-26 w/HPV-1
 ;                      10 - BIHPVM2 = Number Males 19-26 w/HPV-2
 ;                      11 - BIHPVM3 = Number Males 19-26 w/HPV-3
 ;
 ;                      12 - BI60=Total over 60
 ;                      13 - BIZ60 = Number over 60 w/Zoster ever.
 ;                      14 - BI65=Total over 65
 ;                      15 - BIT65 = Number over 65 w/Tetanus past 10 years.
 ;                      16 - BIP65 = Number over 65 w/Pneumo at or after age 65.
 ;                      17 - BIP65E = Number over 65 w/Pneumo EVER.
 ;
 N BIADOB,BIADOBE,BI19,BIT19,BITDAP
 N BIHPVF,BIHPVF1,BIHPVF2,BIHPVF3,BIHPVM,BIHPVM1,BIHPVM2,BIHPVM3
 N BI60,BIZ60
 N BI65,BIT65,BIP65,BIP65E
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
 ..;---> Set totals.
 ..S BI19=BI19+1 S:BIAGE>59 BI60=BI60+1 S:BIAGE>64 BI65=BI65+1
 ..;
 ..;---> Tetanus Stats.
 ..D
 ...I $$TD(BIDFN,BICPTI,BIQDT) D  Q
 ....S BIT19=$G(BIT19)+1 S:BIAGE>64 BIT65=$G(BIT65)+1
 ...;---> Patient is/was due for Tetanus.
 ...S BIVAL=1
 ..;
 ..;---> Tdap Stats.
 ..I $$TD(BIDFN,BICPTI,BIQDT,1) S BITDAP=$G(BITDAP)+1
 ..;
 ..;---> Flu Stats.
 ..;D
 ..;.I $$FLU(BIDFN,BICPTI,BIQDT) D  Q
 ..;..S BIF19=$G(BIF19)+1 S:BIAGE>64 BIF65=$G(BIF65)+1
 ..;..;
 ..;.;---> Patient is due for Influenza.
 ..;.S BIVAL=1
 ..;
 ..;---> Pneumo Stats.
 ..D
 ...N BIPNE65 S BIPNE65=$$PNEU(BIDFN,BIAGE,BICPTI,BIQDT)
 ...;---> Patient received Pneumo sometime.
 ...I $P(BIPNE65,U,2) S BIP65E=$G(BIP65E)+1
 ...;---> If patient received Pneumo at or after age 65, quit: no longer due.
 ...I $P(BIPNE65,U) S BIP65=$G(BIP65)+1 Q
 ...;---> If >64 yrs and didn't receive pneumo, patient is due.
 ...I BIAGE>64 S BIVAL=1
 ..;
 ..;*** NOT USED ANYMORE ***
 ..;---> If pc22=1, forecast Pneumo every 6 years.
 ..;D
 ..;.;---> If Y=1, forecast Pneumo every 6 years.
 ..;.;N Y S Y=$P($G(^BISITE(+$G(DUZ(2)),0)),U,22)
 ..;.;---> If "forc q6y" and <6y, quit.
 ..;.;I Y&($P(BIPNEU,U,2)) Q
 ..;.;---> If "do not forc q6y" and pt has had one, then quit.
 ..;.;I 'Y&($P(BIPNEU,U,1)) Q
 ..;.;---> Patient is due for Pneumo.
 ..;.;S BIVAL=1
 ..;
 ..;
 ..;---> Zostavax Stats.
 ..D
 ...I $$OZSTER(BIDFN,BICPTI,BIQDT) D  Q
 ....S:BIAGE>59 BIZ60=$G(BIZ60)+1
 ...;
 ...;---> Patient is/was due for Zostervax if 60+ years on QDT.
 ...;********** v8.5, MAY 15,2011, IHS/CMI/MWR
 ...;---> Do NOT include patient in Not Current group for zoster (not in
 ...;---> widespread use.
 ...;S:BIAGE>59 BIVAL=1
 ..;
 ..;
 ..;---> HPV Stats (ages 19-26).
 ..I (BIAGE>18)&(BIAGE<27) D
 ...N BIHPVD,BISEX S BISEX=$$SEX^BIUTL1(BIDFN)
 ...S BIHPVD=$$HPV(BIDFN,BICPTI,BIQDT)
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
 ;     4 - BIDTAP (opt) 1=Tdap ONLY and EVER (no prior date restriction).
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
 ;---> Return 0 if last Td was MORE than 10 yrs prior to QDT (or never);
 ;---> otherwise return 1.
 Q $S((BIDATE+100000)<BIQDT:0,1:1)
 ;
 ;
 ;----------
FLU(BIDFN,BICPTI,BIQDT) ;EP
 ;****** NOT USED FOR NOW *******
 ;
 ;---> Return 1 if patient received Flu within one year prior to the QDT.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN
 ;     2 - BICPTI (opt) 1=Include CPT Coded Visits, 0=Ignore CPT.
 ;     3 - BIQDT  (opt) Quarter Ending Date (ignore Visits after this date).
 ;
 ;---> Check V Imms for FLU's.
 N BICVXS,BIDATE
 S BIDATE=0 S:('$G(BIQDT)) BIQDT=$G(DT)
 ;********** v8.5, MAY 15,2011, IHS/CMI/MWR  Add 140 & 141.
 S BICVXS="15,16,88,111,135,140,141"
 S BIDATE=$$LASTIMM^BIUTL11(BIDFN,BICVXS,BIQDT)
 ;
 ;---> So, BIDATE is the latest FLU in V Imm (but not after the QDT).
 ;
 ;---> Check (if requested) V CPTs for FLU's.
 D:$G(BICPTI)
 .N BICPTS,Y
 .S BICPTS="90655,90657,90658,90659,90660,90661,90662,90724"
 .S Y=$$LASTCPT^BIUTL11(BIDFN,BICPTS,BIQDT)
 .S:Y>$G(BIDATE) BIDATE=Y
 ;
 ;---> Return 0 if last Flu was MORE than 1 year prior to QDT or never;
 ;---> otherwise 1.
 Q $S((BIDATE+10000)<BIQDT:0,1:1)
 ;
 ;
 ;----------
PNEU(BIDFN,BIAGE,BICPTI,BIQDT) ;EP
 ;---> Return date if patient received Pneumo, concat ^1 if received after 65.
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
 S BICVXS="33,100,109"
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
 I +BIDATE=0 Q "0^0"
 ;
 ;---> If patient received pneumo at or after age 65, set BI65=1 (otherwise 0).
 N BI65 S BI65=1
 I ($$DOB^BIUTL1(BIDFN)+650000)>BIDATE S BI65=0
 ;
 ;---> Return After 65 indicator_^_Date of last Pneumo.
 Q BI65_U_+BIDATE
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
 ;---> Return 0 if patient Never received Zostavax prior to QDT otherwise 0.
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
