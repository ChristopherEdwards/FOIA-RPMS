BIEXPRT2 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: GATHER PATIENTS ACCORDING TO
 ;;  CRITERIA AND STORE IN ^BITMP(1,.
 ;
 ;
 ;----------
PATIENT(BIPG,BIAG,BISVDT,BIHCF,BICC) ;EP
 ;---> Gather patients according to selection criteria and
 ;---> store in ^BITMP(.
 ;---> Parameters:
 ;     1 - BIPG  (req) Patient Group
 ;     2 - BIAG  (req) Age Range (=0 if not limited by age)
 ;     3 - BISVDT  (req) Survey Date
 ;     4 - BIHCF   (req) Facility array
 ;     5 - BICC    (req) Current Community array
 ;
 S BIPOP=0 K ^BITMP($J)
 ;
 ;---> If there's an Age Range *or* if the Group is not limited to
 ;---> the Immunization Register, then scan ^DPT(.
 I BIAG]""!(BIPG=3) D  Q
 .;
 .;---> Set begin and end dates for search through PATIENT File.
 .D AGEDATE^BIAGE(BIAG,BISVDT,.BIBEGDT,.BIENDDT)
 .;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 .S N=BIBEGDT-1
 .F  S N=$O(^DPT("ADOB",N)) Q:(N>BIENDDT!('N))  D
 ..S BIDFN=0
 ..F  S BIDFN=$O(^DPT("ADOB",N,BIDFN)) Q:'BIDFN  D
 ...D STORE(BIDFN,BISVDT,BIPG,.BIHCF,.BICC,1)
 ;
 ;---> If there is NO Age Range *and* the Group is limited to the
 ;---> Immunization Register, then scan ^BIP(.
 S BIDFN=0
 F  S BIDFN=$O(^BIP(BIDFN)) Q:'BIDFN  D
 .D STORE(BIDFN,BISVDT,BIPG,.BIHCF,.BICC,0)
 Q
 ;
 ;
 ;----------
STORE(BIDFN,BISVDT,BIPG,BIHCF,BICC,BIDPT) ;EP
 ;---> Store patients in ^BITMP if they pass all criteria.
 ;---> Parameters:
 ;     1 - BIDFN   (req) Patient Group
 ;     2 - BISVDT  (req) Survey Date
 ;     3 - BIPG    (req) Patient Group
 ;     4 - BIHCF   (req) Facility array
 ;     5 - BICC    (req) Current Community array
 ;     6 - BIDPT   (opt) =1 if searching ^DPT, =0 if searching ^BIP.
 ;
 ;---> If Group is ACTIVE and patient was not ACTIVE<BISVDT, Quit.
 I BIPG=1 Q:$$ACTIVE(BIDFN,BISVDT)
 ;
 ;---> If Group is ACTIVE & INACTIVE and patient was not in the
 ;---> Register, Quit.
 I $G(BIDPT),BIPG=2 Q:'$D(^BIP(BIDFN))
 ;
 ;---> If patient has had NO IMMUNIZATIONS or has had none at
 ;---> the selected Health Care Facilities, Quit.
 Q:$$VIMM(BIDFN,.BIHCF)
 ;
 ;---> If patient does not have one of the selected Current
 ;---> Communities, Quit.
 Q:$$CURCOM(BIDFN,.BICC)
 ;
 ;---> Store this patient for data retrieval.
 S ^BITMP($J,1,BIDFN)=""
 Q
 ;
 ;
 ;----------
ACTIVE(BIDFN,BISVDT) ;EP
 ;---> Return Active indicator: 0=Active, 1=Inactive.
 ;---> Called if looking for Active Only.
 ;---> Parameters:
 ;     1 - BIDFN   (req) IEN of Patient in ^DPT.
 ;     2 - BISVDT  (opt) Survey Date.
 ;
 ;
 N X S X=$$INACT^BIUTL1(BIDFN)
 ;---> If this patient is not in the Register, return 1.
 Q:X]"A" 1
 ;---> If this patient is Active, return 0.
 Q:X="" 0
 ;---> If this patient was Inactive PRIOR TO the Survey Date return 1.
 Q:X<$G(BISVDT) 1
 ;---> This patient became Inactive AFTER the Survey Date return 0.
 Q 0
 ;
 ;
 ;----------
CURCOM(BIDFN,BICC) ;EP
 ;---> Return Current Community indicator.
 ;---> Return 1 if not selecting all CURRENT COMMUNITIES and if this
 ;---> patient's CURRENT COMMUNITY is not one of the ones selected.
 ;---> Parameters:
 ;     1 - BIDFN  (req) IEN of Patient in ^DPT.
 ;     2 - BICC   (req) Current Community array.
 ;
 Q:$D(BICC("ALL")) 0
 N BICUR S BICUR=$$CURCOM^BIUTL11(BIDFN)
 Q:'BICUR 1
 Q:'$D(BICC(BICUR)) 1
 Q 0
 ;
 ;
 ;----------
VIMM(BIDFN,BIHCF) ;EP
 ;---> Return Immunization Visit indicator: 1=None, 0=Yes.
 ;---> Parameters:
 ;     1 - BIDFN  (req) IEN of Patient in ^DPT.
 ;     2 - BIHCF  (req) Current Community array.
 ;
 ;---> Return 1 if patient has no V IMMUNIZATIONS at all.
 Q:'$D(^AUPNVIMM("AC",BIDFN)) 1
 ;---> Return 0 if patient has a V IMMUNIZATION and "ALL" are selected.
 Q:$D(BIHCF("ALL")) 0
 ;---> Return 1 if patient does not have an Immunization Visit at the
 ;---> selected Facilities.
 N BIFLAG,N,X
 S N=0,BIFLAG=1
 F  S N=$O(^AUPNVIMM("AC",BIDFN,N)) Q:'N  Q:'BIFLAG  D
 .Q:'$D(^AUPNVIMM(N,0))
 .S Y=$P(^AUPNVIMM(N,0),U,3) Q:'Y
 .Q:'$D(^AUPNVSIT(Y,0))
 .S X=$P(^AUPNVSIT(Y,0),U,6)
 .S:$D(BIHCF(X)) BIFLAG=0
 Q BIFLAG
 ;
 ;
 ;----------
VISIT(BIDFN,BIHCF) ;EP
 ;---> Return Visit indicator.
 ;**** NOT USED FOR NOW.  Might be used if some report/list wants
 ;     all patients who have had any type of Visit at a Facility.
 ;
 ;---> Return 1 if patient has no VISITS at all.
 Q:'$D(^AUPNVSIT("AC",BIDFN)) 1
 ;---> Return 0 if patient has a VISIT and "ALL" are selected.
 Q:$D(BIHCF("ALL")) 0
 ;---> Return 1 if patient does not have a VISIT at the selected
 ;---> Facilities.
 N BIFLAG,N,X
 S N=0,BIFLAG=1
 F  S N=$O(^AUPNVSIT("AC",BIDFN,N)) Q:'N  Q:'BIFLAG  D
 .Q:'$D(^AUPNVSIT(N,0))
 .S X=$P(^AUPNVSIT(N,0),U,6)
 .S:$D(BIHCF(X)) BIFLAG=0
 Q BIFLAG
 ;
 ;
 ;----------
HRCN(BIDFN,BIHCF,BIACT) ;EP
 ;---> Return Health Record Number Indicator.
 ;---> Return 1 if this patient DOES NOT HAVE an Active HRCN/Chart# at any
 ;---> of the facilities in the BIHCF array; otherwise, return 0.
 ;---> Also return 1 if patient has NO Chart# ANYWHERE.
 ;---> Parameters:
 ;     1 - BIDFN  (req) IEN of Patient in ^DPT.
 ;     2 - BIHCF  (req) Health Care Facility array. Can be BIHCF("ALL").
 ;     3 - BIACT  (opt) If BIACT=1 INCLUDE Patients whose Chart#'s are
 ;                      INACTIVE.  In other words, return 0 for patients
 ;                      that have Chart#'s even if they are INACTIVE.
 ;
 Q:'$G(BIDFN) 1
 ;
 ;---> Quit if patient has no Chart# anywhere.
 Q:'$O(^AUPNPAT(BIDFN,41,0)) 1
 ;
 ;---> Build local array of patient's Chart#'s.
 N BIHRCN,BIMATCH,M,N
 S N=0
 F  S N=$O(^AUPNPAT(BIDFN,41,N)) Q:'N  S BIHRCN(N)=^(N,0)
 ;
 ;---> Check for match between array of Chart# Sites and array of HCF's.
 S BIMATCH=1,M=0
 F  S M=$O(BIHRCN(M)) Q:'M  D  Q:'BIMATCH
 .;
 .;---> If there's a match or if accepting ALL, then check for Inactive.
 .D:($D(BIHCF(M))!($D(BIHCF("ALL"))))
 ..;
 ..;---> Quit if the Chart# is Inactive and the flag to include
 ..;---> Inactive is not set to 1.
 ..Q:($P(BIHRCN(M),U,3)&('$G(BIACT)))
 ..;
 ..;---> Got a match.
 ..S BIMATCH=0
 ;
 Q BIMATCH
