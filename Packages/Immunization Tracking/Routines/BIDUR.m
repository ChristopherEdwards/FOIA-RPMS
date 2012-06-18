BIDUR ;IHS/CMI/MWR - RETRIEVE PATIENTS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  RETRIEVE PATIENTS FOR DUE LISTS & LETTERS.
 ;
 ;
 ;----------
R(BIAG,BIPG,BIFDT,BICC,BICM,BIMMR,BIMMD,BILOT,BIMD,BIORD,BIRDT,BIDED,BIT,BIHCF,BIDPRV,BIERR,BIBEN) ;EP
 ;---> Retrieve patients according to specs.
 ;---> Parameters:
 ;     1 - BIAG   (req) Age Range in months or years.
 ;     2 - BIPG   (req) Patient Group Data; see PGRPOUP1^BIOUTPT4 for details.
 ;     3 - BIFDT  (req) Forecast date.
 ;     4 - BICC   (req) Current Community array.
 ;     5 - BICM   (req) Case Manager array.
 ;     6 - BIMMR  (req) Immunizations Received array.
 ;     7 - BIMMD  (req) Immunizations Due array.
 ;     8 - BILOT  (req) Lot Number array.
 ;     9 - BIMD   (req) Minimum Interval days since last letter.
 ;    10 - BIORD  (req) Order of listing.
 ;    11 - BIRDT  (opt) Date Range for Received Imms (form BEGDATE:ENDDATE).
 ;    12 - BIDED  (opt) Include Deceased Patients (0=no, 1=yes).
 ;    13 - BIT    (ret) BIT=Total number of patients stored.
 ;    14 - BIHCF  (req) Health Care Facility array.
 ;    15 - BIDPRV (req) Designated Provider array.
 ;    16 - BIERR  (ret) Error Code.
 ;    17 - BIBEN  (req) Beneficiary Type array: either BIBEN(1) or BIBEN("ALL").
 ;
 ;     Removed for v8.1: 8 - BIHCF (req) Health Care Facility array.
 ;
 S BIT=0
 K ^TMP("BIDUL",$J)
 ;---> Reset last record edited index so ^BIPDUE global subscript
 ;---> doesn't grow too large with each run of the report.
 S $P(^BIPDUE(0),U,3)=0
 ;
 ;---> Check for required Variables.
 I '$D(BIAG) S BIERR=613 Q
 I '$D(BIPG) S BIERR=620 Q
 I '$G(BIFDT) S BIERR=616 Q
 I '$D(BICC) S BIERR=614 Q
 I '$D(BICM) S BIERR=615 Q
 I '$D(BIDPRV) S BIERR=680 Q
 I '$D(BIMMR) S BIERR=652 Q
 I '$D(BIMMD) S BIERR=638 Q
 I '$D(BIHCF) S BIERR=625 Q
 I '$D(BILOT) S BIERR=630 Q
 I '$D(BIMD) S BIERR=617 Q
 I '$G(BIORD) S BIERR=618 Q
 I '$D(BIBEN) S BIERR=662 Q
 ;
 ;---> Parse out BIPG.  vvv83
 N I F I=1,2,4,5,7,8 N @("BIPG"_I) S @("BIPG"_I)=$P(BIPG,U,I)
 ;
 ;---> If Patient Group is a Search Template, go store it and quit.
 I $P(BIPG1,U)=8 D SEARCH(BIPG8,.BIT,.BIERR) Q
 ;
 ;
 ;---> If list is for DUE, or PAST DUE, or Due for a specific vaccine,
 ;---> or will display forecast in Additional Info, and
 ;---> if forecasting has been disabled, do ERROR and quit.
 I ((BIPG1[1!(BIPG1[2))!($O(BIMMD(0)))!($D(BINFO(13)))),'$$FORECAS^BIUTL2(DUZ(2)) D  Q
 .S BIERR=314 Q
 ;
 ;---> Calculate the date before which Immunizations Past Due
 ;---> will be included.  BIPG1=Past Due Date cutoff, Fileman format.
 D:(BIPG1[2&(BIPG2))
 .N X,X1,X2 S X1=BIFDT,X2=-(BIPG2*30)
 .D C^%DTC S BIPG2=X
 ;
 N BIAGDB,BIAGDE S (BIAGDB,BIAGDE)=""
 D AGEDATE^BIAGE(BIAG,BIFDT,.BIAGDB,.BIAGDE)
 I (BIAGDB<0)!('BIAGDE)!(BIAGDB>BIAGDE) S BIERR=676 Q
 ;
 ;---> Search the BI PATIENT File, ^BIP( for patients who fit the criteria.
 N BIDFN S BIDFN=0
 F  S BIDFN=$O(^BIP(BIDFN)) Q:'BIDFN  D
 .D CHKSET(BIDFN,BIPG1,BIPG2,BIPG4,BIPG5,.BIT)
 Q
 ;
 ;
 ;----------
CHKSET(BIDFN,BIPG1,BIPG2,BIPG4,BIPG5,BIT) ;EP
 ;---> Check if this patient fits criteria; if so, set DFN
 ;---> in ^TMP("BIDUL".
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient DFN.
 ;     2 - BIPG1  (req) Patient Group Number.
 ;     3 - BIPG2  (opt) If BIPG1=2, then BIPG2=Past Due Date cutoff.
 ;     4 - BIPG4  (opt) If BIPG1=4, then BIPG4=Inactive Date Range.
 ;     5 - BIPG5  (opt) If BIPG1=5, then BIPG5=Auto-Activated Date Range.
 ;     6 - BIT    (ret) BIT=Total patients stored.
 ;     NOTE: Other arrays not passed due to length of parameter list.
 ;
 S BIPOP=0 S:'$D(BIT) BIT=0
 ;
 ;---> If NOT including Deceased, quit if patient is deceased.
 I '$G(BIDED) Q:$$DECEASED^BIUTL1(BIDFN)
 ;
 ;---> Quit if Femles Only and this patient is male.
 Q:((BIPG1[7)&($$SEX^BIUTL1(BIDFN)'="F"))
 ;
 ;---> Check if Patient fits withing Age Range.
 N X S X=$$DOB^BIUTL1(BIDFN)
 Q:(('X)!(X<BIAGDB)!(X>BIAGDE))
 ;
 ;---> Quit if patient does not have an Active HRCN at one or more
 ;---> of the Health Care Facilities selected.  Reactivated  vvv83
 Q:$$HRCN^BIEXPRT2(BIDFN,.BIHCF)
 ;
 ;---> Set local variable for ACTIVE (BIINACT=""), INACTIVE (BIINACT>0).
 N BIINACT S BIINACT=$$INACT^BIUTL1(BIDFN)
 ;
 ;---> Quit if looking ONLY for INACTIVE and this patient is ACTIVE.
 I (BIPG1[4)&(BIPG1'[3) Q:'BIINACT
 ;
 ;---> Quit if looking ONLY for INACTIVE, and a Date Made Inactive was
 ;---> specified, and the patient's Date falls outside of the range.
 I (BIPG1[4)&(BIPG1'[3),BIPG4 Q:((BIINACT<$P(BIPG4,":"))!(BIINACT>$P(BIPG4,":",2)))
 ;
 ;---> Quit if looking ONLY for ACTIVE and this patient is INACTIVE.
 I (BIPG1[3)&(BIPG1'[4) Q:BIINACT
 ;
 ;---> Quit if looking ONLY for DUE or PAST DUE, which assumes ACTIVE,
 ;---> and Inactive is not included, and this patient is Inactive.
 I ((BIPG1[1)!(BIPG1[2))&(BIPG1'[4) Q:BIINACT
 ;
 ;---> Quit if looking for AUTOMATICALLY ACTIVATED and Patient was not,
 ;---> or not Auto Activated within the selected date range.
 I BIPG1[5 N BIAUTO S BIAUTO=0 D  Q:'BIAUTO
 .Q:('$$ENTERED^BIUTL1(BIDFN,1))
 .N X S X=$$ENTERED^BIUTL1(BIDFN)
 .Q:((X<$P(BIPG5,":"))!(X>$P(BIPG5,":",2)))
 .S BIAUTO=1
 ;
 ;---> Quit if looking for Patients who had Refusals and there are none.
 I BIPG1[6 N A D CONTRA^BIUTL11(BIDFN,.A,1) Q:'$O(A(0))
 ;
 ;---> Quit if Current Community isn't one of those selected.
 Q:$$CURCOM^BIEXPRT2(BIDFN,.BICC)
 ;
 ;---> Quit if Case Manager isn't one of those selected.
 Q:$$CMGR(BIDFN,.BICM)
 ;
 ;---> Quit if Beneficiary Type doesn't match.
 Q:$$BENT^BIDUR1(BIDFN,.BIBEN)
 ;
 ;---> Quit if Designated Provider isn't one of those selected.
 Q:$$DPRV(BIDFN,.BIDPRV)
 ;
 ;---> Quit if Patient never received any of the Vaccines selected.
 Q:$$IMMR(BIDFN,.BIMMR,$G(BIRDT))
 ;
 ;---> Quit if Patient never received any of the Lot#s selected.
 Q:$$LOT(BIDFN,.BILOT)
 ;
 ;---> Quit if Patient does not have a Chart# at any of
 ;---> the Health Care Facilities selected.  vvv83
 Q:$$HRCN^BIEXPRT2(BIDFN,.BIHCF)
 ;
 ;---> Quit if Minimum Interval (since last letter) not reached.
 N BIQUIT S BIQUIT=0
 I BIMD D  Q:BIQUIT
 .Q:BIPG1=5
 .N X,X1,X2
 .S X1=DT,X2=+$$LASTLET^BIUTL1(BIDFN)
 .I X2  D ^%DTC  S:X<BIMD BIQUIT=1
 ;
 ;---> If list is for DUE, or PAST DUE, or Due for a specific vaccine,
 ;---> or will display forecast in Additional Info, then update
 ;---> the patient's forecast.
 D:((BIPG1[1!(BIPG1[2))!($O(BIMMD(0)))!($D(BINFO(13))))
 .;---> 4th param=1: Don't retrieve Immserve Profile.
 .D UPDATE^BIPATUP(BIDFN,BIFDT,,1)
 ;
 ;---> Quit if Patient is not due for a matching Vaccine.
 Q:$$IMMD(BIDFN,.BIMMD)
 ;
 ;---> Quit if list is for DUE and this patient has no Imms
 ;---> due on this Forecast Date.
 I BIPG1[1 Q:'$D(^BIPDUE("B",BIDFN))
 ;
 ;---> Quit if list is for PAST DUE and this patient has
 ;---> no Immunizations past due as of the Forecast Date.
 I BIPG1[2 Q:'$D(^BIPDUE("E",BIDFN))
 ;
 ;---> Quit if this patient's earlist Immunization PAST DUE date
 ;---> is AFTER the Past Due Date.
 I BIPG1[2 Q:$O(^BIPDUE("E",BIDFN,0))>BIPG2
 ;
 ;---> Quit if Patient is not Past Due for a specific matching Vaccine.
 I BIPG1[2 Q:$$IMMPD(BIDFN,.BIMMD,BIPG2)
 ;
 ;---> OK, this patient is a keeper! Go store this patient
 ;---> in the Order specified, then update Patient Total.
 D STORE^BIDUR1(BIDFN,BIFDT,BIORD,.BIERR)
 Q:$G(BIERR)
 S BIT=$G(BIT)+1
 Q
 ;
 ;
 ;----------
SEARCH(BITIEN,BIT,BIERR) ;EP
 ;---> Gather patients from Patient Search Template.
 ;---> Parameters:
 ;     1 - BITIEN (req) Template IEN.
 ;     2 - BIT    (ret) Total patients stored.
 ;     3 - BIERR  (ret) Error Code.
 ;
 I '$G(BITIEN) S BIERR=653 Q
 I '$D(^DIBT(BITIEN,0)) S BIERR=654 Q
 I '$O(^DIBT(BITIEN,1,0)) S BIERR=655 Q
 ;
 ;********** PATCH 1, APR 4,2006, IHS/CMI/MWR
 ;---> Seed Age Range Dates (needed, but not relevant to Search Template).
 N BIAGDB,BIAGDE S BIAGDB=0,BIAGDE=9999999
 ;**********
 ;
 N BIDFN S BIDFN=0,BIPG="3,4,"
 F  S BIDFN=$O(^DIBT(BITIEN,1,BIDFN)) Q:'BIDFN  D
 .D CHKSET(BIDFN,BIPG,,,,.BIT)
 Q
 ;
 ;
 ;----------
CMGR(BIDFN,BICM) ;EP
 ;---> Case Manager indicator.
 ;---> Return 1 if not selecting all Case Managers and if this
 ;---> patient's Case Manager is not one of the ones selected.
 ;
 Q:'$G(BIDFN) 1
 Q:$D(BICM("ALL")) 0
 N BIMGR S BIMGR=$$CMGR^BIUTL1(BIDFN)
 Q:'BIMGR 1
 Q:'$D(BICM(BIMGR)) 1
 Q 0
 ;
 ;
 ;----------
DPRV(BIDFN,BIDPRV) ;EP
 ;---> Designated Provider indicator.
 ;---> Return 1 if not selecting all Designated Providers and if this
 ;---> patient's Designated Provider is not one of the ones selected.
 ;
 Q:'$G(BIDFN) 1
 Q:$D(BIDPRV("ALL")) 0
 N BIX S BIX=$$DPRV^BIUTL1(BIDFN)
 Q:'BIX 1
 Q:'$D(BIDPRV(BIX)) 1
 Q 0
 ;
 ;
 ;----------
IMMR(BIDFN,BIMMR,BIRDT) ;EP
 ;---> Imm Received indicator.
 ;---> Return 1 if not selecting all Immunizations Received and if
 ;---> this patient NEVER received any of the Vaccines selected.
 ;---> BIHIT=0 includes this patient; BIHIT=1 EXcludes this patient.
 ;
 Q:$G(BIDFN)="" 1
 ;---> If not restricting vaccines or visit dates, then consider this
 ;---> patient a hit--include in the list.
 S:'$G(BIRDT) BIRDT=""
 Q:(($D(BIMMR("ALL")))&('BIRDT)) 0
 ;
 ;---> For this Patient retrieve Imm Hx elements IEN vaccine and Fman date;
 ;---> example: ^I|127|3030821^
 N BIHX,BI31,BIDE S BI31=$C(31)_$C(31),BIDE(30)="",BIDE(56)=""
 D IMMHX^BIRPC(.BIHX,BIDFN,.BIDE,0) S BIHX=$P(BIHX,BI31)
 ;
 N I,BIIEN,BIDATE,BIHIT
 ;---> BIHIT=0 this will include the Patient in the list.
 ;---> So, change BIHIT=0 if a visit meets the criteria.
 S BIHIT=1
 F I=1:1:($L(BIHX,U)-1) D  Q:'BIHIT
 .S BIIEN=$P($P(BIHX,U,I),"|",2),BIDATE=$P($P(BIHX,U,I),"|",3)
 .;---> If no date restriction and there's a matching Imm, it's a hit (0).
 .I 'BIRDT,$D(BIMMR(+BIIEN)) S BIHIT=0 Q
 .;---> If there's a matching Imm, or if not restricting to specific vaccines,
 .;---> check that visit date is within range.
 .I $D(BIMMR(+BIIEN))!$D(BIMMR("ALL")) D
 ..I (BIDATE'<$P(BIRDT,":"))&(BIDATE'>$P(BIRDT,":",2)) S BIHIT=0 Q
 ;
 ;---> Quit, returning result.
 Q BIHIT
 ;
 ;
 ;----------
LOT(BIHX,BILOT) ;EP
 ;---> Lot# indicator.
 ;---> Return 1 if not selecting all Lot Numbers and if this
 ;---> patient NEVER received any of the Lot Numbers selected.
 ;
 Q:$D(BILOT("ALL")) 0
 Q:$G(BIDFN)="" 0
 ;
 N BIHX,BI31,BIDE S BI31=$C(31)_$C(31),BIDE(32)=""
 D IMMHX^BIRPC(.BIHX,BIDFN,.BIDE,0) S BIHX=$P(BIHX,BI31)
 ;
 N I,L S L=""
 F I=1:1:($L(BIHX,U)-1) S L=$P($P(BIHX,U,I),"|",2) Q:$D(BILOT(+L))
 Q:$D(BILOT(+L)) 0
 ;
 ;---> No match.
 Q 1
 ;
 ;
 ;----------
IMMD(BIDFN,BIMMD) ;EP
 ;---> Imm Due indicator.
 ;---> Return 1 if not selecting all Immunizations Due and if this
 ;---> patient is NOT DUE for any of the Vaccines selected.
 ;
 Q:'$G(BIDFN) 1
 Q:$D(BIMMD("ALL")) 0
 ;
 ;---> Look for an Imm Due for any of the selected Vaccines.
 N N,Z S N=0,Z=1
 F  S N=$O(^BIPDUE("B",BIDFN,N)) Q:'N  Q:'Z  D
 .S:$D(BIMMD(+$P($G(^BIPDUE(N,0)),U,2))) Z=0
 ;
 ;---> Z=1: No match.
 Q Z
 ;
 ;
 ;----------
IMMPD(BIDFN,BIMMD,BIPG2) ;EP
 ;---> Imm PAST Due indicator.
 ;---> Return 1 if not selecting all Immunizations Past Due and if this
 ;---> patient is NOT PAST DUE for any of the Vaccines selected.
 ;
 Q:'$G(BIDFN) 1
 Q:$D(BIMMD("ALL")) 0
 ;
 ;---> Look for an Imm PAST Due for any of the selected Vaccines.  ;Q:$O(^BIPDUE("E",BIDFN,0))>BIPG2
 N N,Z S N=0,Z=1
 F  S N=$O(^BIPDUE("E",BIDFN,N)) Q:'N  Q:'Z  D
 .Q:(N>BIPG2)
 .N M S M=0
 .F  S M=$O(^BIPDUE("E",BIDFN,N,M)) Q:'M  D
 ..S:$D(BIMMD(+$P($G(^BIPDUE(M,0)),U,2))) Z=0
 ;
 ;---> Z=1: No match.
 Q Z
 ;
 ;
 ;----------
DPTAGE(BIT) ;EP
 ;*** NOT USED! ***  JUST FOR REFERENCE.
 ;
 ;---> Using an Age Range, search by VA PATIENT File, ^DPT(,
 ;---> using DOB xref.
 ;---> Parameters:
 ;     1 - BIT (ret) BIT=Total patients stored.
 ;
 ;---> Set begin and end dates for search through PATIENT File.
 N BIDFN,BIBEGDT,BIENDDT,N
 D AGEDATE^BIAGE(BIAG,BIFDT,.BIBEGDT,.BIENDDT)
 ;
 ;---> Start 1 day prior to Begin Date and $O into the desired DOB's.
 S N=BIBEGDT-1
 F  S N=$O(^DPT("ADOB",N)) Q:(N>BIENDDT!('N))  D
 .S BIDFN=0
 .F  S BIDFN=$O(^DPT("ADOB",N,BIDFN)) Q:'BIDFN  D
 ..D CHKSET(BIDFN,.BIT)
 Q
