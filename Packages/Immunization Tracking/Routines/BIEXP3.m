BIEXP3 ;IHS/CMI/MWR - EXPORT IMMUNIZATION RECORDS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EXPORT IMMUNIZATION RECORDS: EXPORT ROUTINE
 ;
 ;
 ;----------
START(BIRTN) ;EP
 ;---> Export Data.
 ;---> Parameters:
 ;     1 - BIRTN (req) Calling routine for reset.
 ;
 I $G(BIRTN)="" D ERRCD^BIUTL2(621,,1) Q
 ;
 ;---> Variables:
 ;     1 - BISVDT (req) Survey Date
 ;     2 - BIPG   (req) Group of patients (9=Individual)
 ;     3 - BIPAT  (opt) Patient DFN's (array) if BIPG=9
 ;     4 - BIAG   (req) Age Range (=0 if not limited by age)
 ;     5 - BIHCF  (req) Facility (array)
 ;     6 - BICC   (req) Current Community (array)
 ;     7 - BIMMR  (req) Immunization (array)
 ;     8 - BIDE   (req) Data Elements to be passed (array)
 ;     9 - BIFMT  (req) Format: 1=ASCII,2=HL7,3=ImmServe
 ;    10 - BIOUT  (req) Export: 0=screen, 1=host file
 ;    11 - BIFLNM (opt) File name
 ;    12 - BIPATH (opt) Path name for File
 ;
 ;
 ;---> Check for required variables.
 N BIERR S BIERR=""
 D
 .I '$D(BISVDT) S BIERR=640 Q
 .I '$D(BIPG) S BIERR=641 Q
 .I BIPG=9&('$O(BIPAT(0))) S BIERR=650 Q
 .I '$D(BIAG) S BIERR=642 Q
 .I '$D(BIHCF) S BIERR=643 Q
 .I '$D(BICC) S BIERR=644 Q
 .I '$D(BIMMR) S BIERR=645 Q
 .I '$D(BIDE)&(BIFMT=1) S BIERR=646 Q
 .I '$D(BIFMT) S BIERR=647 Q
 .I '$D(BIOUT) S BIERR=648 Q
 .I BIOUT,$G(BIFLNM)="" S BIERR=649 Q
 .I BIOUT,$G(BIPATH)="" S BIERR=651 Q
 ;
 ;---> If an error exists, report it and return to first screen.
 I BIERR D  Q
 .D ERRCD^BIUTL2(BIERR,,1),@("RESET^"_BIRTN)
 ;
 ;
 D INIT N BIPOP
 ;
 ;---> If exporting all Data Elements, set them now.
 D:$D(BIDE("ALL")) BIDE(.BIDE)
 ;
 ;---> If format is ImmServe, set Data Elements necessary for ImmServe.
 I BIFMT=3 D BIDE^BIPATUP(.BIDE)
 ;
 ;---> Get okay to proceed.
 D FULL^VALM1
 D TITLE^BIUTL5("EXPORT IMMUNIZATION RECORDS")
 D OKAY^BIEXPRT8(.BIPOP)
 I BIPOP D @("RESET^"_BIRTN) Q
 ;
 ;---> If export is to Host File, open Host File and test access,
 ;---> and LEAVE OPEN for export.
 D
 .I BIOUT D HFS^BIEXPRT8(BIFLNM,.BIPATH,1,.BIPOP) Q
 .S IOP=0 D ^%ZIS
 I BIPOP D @("RESET^"_BIRTN) Q
 ;
 ;---> Patients.
 D
 .;---> If individuals in local array, store in ^BITMP.
 .I BIPG=9 D  Q
 ..N DFN S DFN=0 F  S DFN=$O(BIPAT(DFN)) Q:'DFN  S ^BITMP($J,1,DFN)=""
 .;
 .;---> Gather patients by group and store in ^BITMP.
 .D PATIENT^BIEXPRT2(BIPG,BIAG,BISVDT,.BIHCF,.BICC)
 ;
 ;---> Gather Immunization History for each patient stored.
 ;---> (If not all vaccines, gather only ones selected--BIMMR.)
 ;---> If ImmServe export, get vaccines that should not be forecast.
 I BIFMT=3 D NOFORC^BIPATUP(.BINF)
 D HISTORY^BIEXPRT3(BIFMT,.BIDE,.BIMMR,,,,.BINF)
 ;
 ;---> Export data.
 D WRITE^BIEXPRT4(BIOUT,BIFMT,$G(BIFLNM),$G(BIPATH),,1)
 ;
 ;---> If Data Element array was built for ImmServe, kill it.
 K:BIFMT=3 BIDE
 ;
 ;---> Return to calling routine.
 D @("RESET^"_BIRTN)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialization.
 K ^BITMP($J)
 D SETVARS^BIUTL5
 Q
 ;
 ;
 ;----------
BIDE(BIDE) ;EP
 ;---> Build local array of ALL Data Elements (for cases when
 ;---> user selects all data elements).
 ;
 N N S N=0
 F  S N=$O(^BIEXPDD(N)) Q:'N  S BIDE(N)=""
 Q
