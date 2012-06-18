BIVISIT ;IHS/CMI/MWR - ADD/EDIT IMM/SKIN VISITS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  CODE TO ADD V IMMUNIZATION AND V SKIN TEST VISITS.
 ;;  CALLED BY BIRPC3.
 ;
 ;
 ;----------
PARSE(Y,Z) ;EP
 ;---> Parse out passed Visit and V File data into local variables.
 ;---> Parameters:
 ;     1 - Y (req) String of data for the Visit to be added.
 ;     2 - Z (opt) If Z=1 do NOT set BIVSIT (call from VFILE below must
 ;                 preserve new Visit IEN sent to it).
 ;
 ;---> Pieces of Y delimited by "|":
 ;     -----------------------------
 ;     1 - BIVTYPE (req) "I"=Immunization Visit, "S"=Skin Text Visit.
 ;     2 - BIDFN   (req) DFN of patient.
 ;     3 - BIPTR   (req) Vaccine or Skin Test .01 pointer.
 ;     4 - BIDOSE  (opt) Dose# number for this Immunization.
 ;     5 - BILOT   (opt) Lot Number IEN for this Immunization.
 ;     6 - BIDATE  (req) Date.Time of Visit.
 ;     7 - BILOC   (req) Location of encounter IEN.
 ;     8 - BIOLOC  (opt) Other Location of encounter.
 ;     9 - BICAT   (req) Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;    10 - BIVSIT  (opt) Visit IEN.
 ;    11 - BIOIEN  (opt) Old V File IEN (for edits).
 ;    12 - BIRES   (req) Skin Test Result: P,N,D,O.
 ;    13 - BIREA   (req) Skin Test Reading: 0-40.
 ;    14 - BIDTR   (req) Skin Test Date Read.
 ;    15 - BIREC   (opt) Vaccine Reaction.
 ;    16 - BIVFC   (opt) VFC Eligibility.  vvv83
 ;    17 - BIVISD  (opt) Release/Revision Date of VIS (YYYMMDD).
 ;    18 - BIPROV  (opt) IEN of Provider of Immunization/Skin Test.
 ;    19 - BIOVRD  (opt) Dose Override.
 ;    20 - BIINJS  (opt) Injection Site.
 ;    21 - BIVOL   (opt) Volume.
 ;    22 - BIREDR  (opt) IEN of Reader of Skin Test.
 ;    23 - BISITE  (opt) Passed DUZ(2) for Site Parameters.
 ;    24 - BICCPT  (opt) If created from CPT ^DD BICCPT=1 or IEN; otherwise=""
 ;                       (called from BIRPC6
 ;    25 - BIMPRT  (opt) If =1 it was imported.
 ;    26 - BINDC   (opt) NDC Code IEN pointer to file #9002084.95.
 ;
 N V S V="|"
 ;
 S BIVTYPE=$P(Y,V,1)
 S BIDFN=$P(Y,V,2)
 S BIPTR=$P(Y,V,3)
 S BIDOSE=$P(Y,V,4)
 S BILOT=$P(Y,V,5)
 S BIDATE=$P(Y,V,6) S:$P(BIDATE,".",2)="" BIDATE=BIDATE_".12"
 S BILOC=$P(Y,V,7)
 S BIOLOC=$P(Y,V,8)
 S BICAT=$P(Y,V,9)
 S:'$G(Z) BIVSIT=$P(Y,V,10)
 S BIOIEN=$P(Y,V,11)
 S BIRES=$P(Y,V,12)
 S BIREA=$P(Y,V,13)
 S BIDTR=$P(Y,V,14) S:BIDTR<1 BIDTR=""
 S BIREC=$P(Y,V,15)
 S BIVFC=$P(Y,V,16)  ;vvv83
 S BIVISD=$P(Y,V,17)
 S BIPROV=$P(Y,V,18)
 S BIOVRD=$P(Y,V,19)
 S BIINJS=$P(Y,V,20)
 S BIVOL=$P(Y,V,21)
 S BIREDR=$P(Y,V,22)
 S BISITE=$P(Y,V,23)
 S BICCPT=$P(Y,V,24)
 S BIMPRT=$P(Y,V,25)
 S BINDC=$P(Y,V,26)
 Q
 ;
 ;
 ;----------
ADDV(BIERR,BIDATA,BIOIEN) ;EP
 ;---> Add a Visit (if necessary) and V FILE entry for this patient.
 ;---> Called exclusively by ^BIRPC3.
 ;---> Parameters:
 ;     1 - BIERR  (ret) 1^Text of Error Code if any, otherwise null.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE (above).
 ;     3 - BIOIEN (opt) IEN of V IMM or V SKIN being edited (if
 ;                      not new).
 ;
 I BIDATA="" D ERRCD^BIUTL2(437,.BIERR) S BIERR="1^"_BIERR Q
 ;
 N BIVTYPE,BIDFN,BIPTR,BIDOSE,BILOT,BIDATE,BILOC,BIOLOC,BICAT,BIVSIT
 N BIOIEN,BIRES,BIREA,BIDTR,BIREC,BIVISD,BIPROV,BIOVRD,BIINJS,BIVOL
 N BIREDR,BISITE,BICCPT,BIMPRT
 ;
 ;---> See BIDATA definition at linelabel PARSE.
 D PARSE(BIDATA)
 ;
 N APCDALVR,APCDANE,AUPNTALK,BITEST,DLAYGO,X
 S BIERR=0
 ;
 ;---> Set BITEST=1 To display VISIT and V IMM pointers after sets.
 ;---> NOTE: This will write directly to IO.  Should be turned OFF
 ;---> (BITEST=0) when not testing in M Programmer mode.
 S BITEST=0
 ;
 ;---> If this is an edit, check or set BIVSIT=IEN of Parent Visit.
 D:$G(BIOIEN)
 .I (BIVTYPE'="I"&(BIVTYPE'="S")) D  Q
 ..D ERRCD^BIUTL2(410,.BIERR) S BIERR="1^"_BIERR
 .;
 .;---> Quit if valid Visit IEN passed.
 .Q:$G(^AUPNVSIT(+$G(BIVSIT),0))
 .;
 .;---> Get Visit IEN from V File entry (and set in BIDATA).
 .N BIGBL S BIGBL=$S(BIVTYPE="I":"^AUPNVIMM(",1:"^AUPNVSK(")
 .S BIGBL=BIGBL_BIOIEN_",0)"
 .;---> Get IEN of VISIT.
 .S BIVSIT=$P($G(@BIGBL),U,3)
 Q:BIERR
 ;
 ;---> Create or edit Visit if necessary.
 ;---> NOTE: BIVSIT, even if sent, might come backed changed (due to
 ;---> change in Date, Category, etc.)
 D VISIT^BIVISIT1(BIDFN,BIDATE,BICAT,BILOC,BIOLOC,BISITE,.BIVSIT,.BIERR)
 Q:BIERR
 ;
 ;---> Create V FILE entry.
 D VFILE($G(BIVSIT),BIDATA,.BIERR)
 Q:BIERR
 ;
 ;---> If this was a mod to an existing Visit, update VISIT Field .13.
 D:($G(BIOIEN)&($G(BIVSIT)))
 .N AUPNVSIT,DA,DIE,DLAYGO
 .S AUPNVSIT=BIVSIT,DLAYGO=9000010
 .D MOD^AUPNVSIT
 ;
 Q
 ;
 ;
 ;----------
VFILE(BIVSIT,BIDATA,BIERR) ;EP
 ;---> Add (create) V IMMUNIZATION or V SKIN TEST entry for this Visit.
 ;---> Parameters:
 ;     1 - BIVSIT (req) IEN of Parent Visit.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE.
 ;     3 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 ;
 I BIDATA="" D ERRCD^BIUTL2(437,.BIERR) S BIERR="1^"_BIERR Q
 ;
 N BIVTYPE,BIDFN,BIPTR,BIDOSE,BILOT,BIDATE,BILOC,BIOLOC,BICAT
 N BIOIEN,BIRES,BIREA,BIDTR,BIREC,BIVISD,BIPROV,BIOVRD,BIINJS,BIVOL
 N BIREDR,BISITE,BICCPT,BIMPRT
 ;
 ;---> See BIDATA definition at linelabel PARSE (above).
 D PARSE(BIDATA,1)
 ;
 ;---> Fields in V IMMUNIZATION File are as follows:
 ;
 ;       .01 APCDTIMM  Pointer to IMMUNIZATION File (Vaccine)
 ;       .02 APCDPAT   Patient
 ;       .03 APCDVSIT  IEN of Visit
 ;       .04 APCDTSER  Dose# (Series#)
 ;       .05 APCDTLOT  Lot# IEN, Pointer to IMMUNIZATION LOT File
 ;       .06 APCDTREC  Reaction
 ;
 ;       This will no longer be used:
 ;       .07 APCDTCON  Contraindication (Stored in ^BIP.)
 ;
 ;       .12 APCDTVSD  VIS Date (Lori will put in a future template.)
 ;      1204 APCDTEPR  Immunization Provider
 ;
 ;---> Fields in V SKIN TEST File are as follows:
 ;
 ;       .01 APCDTSK   Pointer to IMMUNIZATION File
 ;       .02 APCDPAT   Patient
 ;       .03 APCDVSIT  IEN of Visit
 ;       .04 APCDTRES  Result
 ;       .05 APCDTREA  Reading
 ;       .06 APCDTDR   Date read
 ;      1204 APCDTEPR  Skin Test Provider
 ;
 ;---> Check that a Parent VISIT exists.
 I '$D(^AUPNVSIT(+$G(BIVSIT),0)) D  Q
 .D ERRCD^BIUTL2(432,.BIERR) S BIERR="1^"_BIERR
 ;
 N APCDALVR
 ;
 ;---> Set Visit pointer.
 S APCDALVR("APCDVSIT")=BIVSIT
 ;
 ;---> Set Patient.
 S APCDALVR("APCDPAT")=BIDFN
 ;
 ;
 ;
 ;---> * * * If this is an IMMUNIZATION, set APCD array for Immunizations. * * *
 ;
 I BIVTYPE="I" D
 .;
 .;---> Set permission override for this file.
 .S DLAYGO=9000010.11
 .;
 .;---> Immunization/vaccine name.
 .S APCDALVR("APCDTIMM")="`"_BIPTR
 .;
 .;---> Dose# for this immunization.
 .;S:'$G(BIDOSE) BIDOSE=""
 .;S APCDALVR("APCDTSER")=BIDOSE
 .;
 .;---> Lot Number IEN for this immunization.
 .S:'$G(BILOT) BILOT=""
 .;---> Lot Number passed to PCC more reliably if prepend "`". ;MWRZZZ 10/30/06
 .;---> Imm v8.5: Handle Lot Number below
 .;S:BILOT BILOT="`"_BILOT
 .;S APCDALVR("APCDTLOT")=BILOT
 .;
 .;---> Reaction to this vaccine on this Visit.
 .S:'$G(BIREC) BIREC=""
 .S APCDALVR("APCDTREC")=BIREC
 .;
 .;---> VIS Date.
 .;---> *** NOT USE FOR NOW -- wait until Lori Butcher gets it into
 .;---> the Input Template.  Instead use DIE below.  ;MWRZZZ
 .;NOTE!!! BIVISD MUST BE EXTERNAL FORM; IT WILL BE ///  ;MWRZZZ
 .;S APCDALVR("APCDTVS")=BIVISD
 .;
 .;---> Immunization Provider ("Shot giver").
 .S:$G(BIPROV) APCDALVR("APCDTEPR")="`"_BIPROV
 .;
 .;---> User who last edited this Immunization.  ;MWR New for v8.2.
 .S:$G(DUZ) APCDALVR("APCDTULU")="`"_DUZ
 .;
 .;---> Template to add encounter to V IMMUNIZATION File.
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.11 (ADD)]"
 ;
 ;
 ;
 ;---> * * * If this is a SKIN TEST, set APCD array for Skin Tests.  * * *
 ;
 I BIVTYPE="S" D
 .;
 .;---> Set permission override for this file.
 .S DLAYGO=9000010.12
 .;
 .;---> Skin Test name.
 .S APCDALVR("APCDTSK")="`"_BIPTR
 .;
 .;---> Skin Test Result.
 .S APCDALVR("APCDTRES")=BIRES
 .;
 .;---> Skin Test Reading (mm).
 .S APCDALVR("APCDTREA")=BIREA
 .;
 .;---> Skin Test Date Read.
 .S APCDALVR("APCDTDR")=BIDTR
 .;
 .;---> Skin Test Provider (Person who administered the test).
 .S:$G(BIPROV) APCDALVR("APCDTEPR")="`"_BIPROV
 .;
 .;---> Template to add encounter to V SKIN TEST File.
 .S APCDALVR("APCDATMP")="[APCDALVR 9000010.12 (ADD)]"
 ;
 ;---> Set Category in case needed for Screen on .01 of V Immunization.
 ;---> If Category="E" (Historical Event) then allow save, even if vaccine
 ;---> is Inactive.
 ;---> *** NO LONGER NEEDED IN v8.1 (screen removed from .01 of V Imm).
 ;S APCDALVR("APCDCAT")=$G(BICAT)
 ;
 ;
 ;---> * * *  CALL TO APCDALVR.  * * *
 D EN^APCDALVR
 D:$G(BITEST) DISPLAY2^BIPCC
 ;
 ;---> Quit if a V File entry was not created.
 I '$G(APCDALVR("APCDADFN"))!($D(APCDALVR("APCDAFLG"))) D  Q
 .I BIVTYPE="I" D ERRCD^BIUTL2(402,.BIERR) S BIERR="1^"_BIERR Q
 .I BIVTYPE="S" D ERRCD^BIUTL2(413,.BIERR) S BIERR="1^"_BIERR
 ;
 ;Returns:  APCDADFN - IEN of V IMMUNIZATION File entry.
 ;          APCDAFLG - =2 If FAILED to create a V FILE entry.
 ;
 ;
 ;---> Save IEN of V IMMUNIZATION just created.
 N BIADFN S BIADFN=APCDALVR("APCDADFN")
 ;
 ;
 ;---> ADD OTHER V SKIN TEST FIELDS:
 ;---> If this is a Skin Test, add Skin Test Reader and Quit.
 I BIVTYPE="S" D  Q
 .;---> Store Additional data.
 .N BIFLD
 .S BIFLD(.08)=BIREDR,BIFLD(.09)=BIINJS,BIFLD(.11)=BIVOL
 .D FDIE^BIFMAN(9000010.12,BIADFN,.BIFLD,.BIERR)
 .I BIERR=1 D ERRCD^BIUTL2(421,.BIERR) S BIERR="1^"_BIERR
 .;
 .;---> If Skin Test is a PPD and result is Positive, add Contraindication
 .;---> to further TST-PPD tests.
 .I $$SKNAME^BIUTL6($G(BIPTR))="PPD",$E($G(BIRES))="P" D
 ..;---> Set date equal to either Date Read, or Date of Visit, or Today.
 ..N BIDTC S BIDTC=$S($G(BIDTR):BIDTR,$G(BIDATE):$P(BIDATE,"."),1:$G(DT))
 ..S BIDATA=BIDFN_"|"_203_"|"_17_"|"_BIDTC
 ..D ADDCONT^BIRPC4(,BIDATA)
 ;
 ;
 ;---> ADD OTHER V IMMUNIZATION FIELDS:
 ;---> Quit if this is not an Immunization.
 Q:BIVTYPE'="I"
 ;
 ;---> Add VIS, Dose Override, Injection Site and Volume data.
 ;---> Build DR string.
 S:BIVISD="" BIVISD="@" S:BIOVRD="" BIOVRD="@"
 S:BIINJS="" BIINJS="@" S:BIVOL="" BIVOL="@"
 S:BILOT="" BIILOT="@" S:BINDC="" BINDC="@"
 ;
 ;---> Store Additional data.
 N BIFLD
 ;---> Imm v8.5: Move add/edit of Lot Number here, so it doesn't mess up APDC call.
 S BIFLD(.05)=BILOT
 S BIFLD(.08)=BIOVRD,BIFLD(.09)=BIINJS
 S BIFLD(.11)=BIVOL,BIFLD(.12)=BIVISD,BIFLD(.13)=BICCPT
 S BIFLD(.14)=BIVFC
 S BIFLD(.15)=$S(BIMPRT>0:2,1:"")
 S BIFLD(.16)=BINDC
 D FDIE^BIFMAN(9000010.11,BIADFN,.BIFLD,.BIERR)
 I BIERR=1 D  Q
 .D ERRCD^BIUTL2(421,.BIERR) S BIERR="1^"_BIERR
 ;
 ;
 ;---> If there was an anaphylactic reaction to this vaccine,
 ;---> add it as a contraindication for this patient.
 D:BIREC=9
 .Q:'$G(BIDFN)  Q:'$G(BIPTR)  Q:'$G(BIDATE)
 .N BIREAS S BIREAS=$O(^BICONT("B","Anaphylaxis",0))
 .Q:'BIREAS
 .;
 .N BIADD,N,V S N=0,BIADD=1,V="|"
 .;---> Loop through patient's existing contraindications.
 .F  S N=$O(^BIPC("B",BIDFN,N)) Q:'N  Q:'BIADD  D
 ..N X S X=$G(^BIPC(N,0))
 ..Q:'X
 ..;---> Quit (BIADD=0) if this contra/reason/date already exists.
 ..I $P(X,U,2)=BIPTR&($P(X,U,3)=BIREAS)&($P(X,U,4)=BIDATE) S BIADD=0
 .Q:'BIADD
 .;
 .D ADDCONT^BIRPC4(.BIERR,BIDFN_V_BIPTR_V_BIREAS_V_BIDATE)
 .I $G(BIERR)]"" S BIERR="1^"_BIERR
 ;
 ;---> Now trigger New Immunization Trigger Event.
 D TRIGADD
 Q
 ;
 ;
 ;----------
TRIGADD ;EP
 ;---> Immunization Added Trigger Event call to Protocol File.
 ;---> Called at the end/bottom of BIVISIT, after new V IMM created.
 ;---> (Note: Trigger Event for DELETE Immunization is in rtn BIVISIT2.)
 ;---> Local variables available when Event is triggered:
 ;
 ;     BIADFN -  IEN of V IMMUNIZATION just created.
 ;     BICAT  -  Category: A (Ambul), I (Inpat), E (Event/Hist)
 ;     BIDATE -  Date of Visit (Fileman format).
 ;     BIDFN  -  DFN of patient.
 ;     BILOC  -  Location of encounter (IEN).
 ;     BILOT  -  Lot Number IEN for this Immunization (text).
 ;     BIOLOC -  Other Location of encounter (text).
 ;     BIPTR  -  Vaccine (IEN in IMMUNIZATION File).
 ;     BIREC  -  Vaccine Reaction (text).
 ;     BITYPE -  Type of Visit (PCC Master Control File I,C,6).
 ;     BIVHL7 -  Vaccine HL7 Code.
 ;     BIVNAM -  Vaccine Name, short form.
 ;     BIVSIT -  IEN of Visit.
 ;
 ;
 N BIVNAM,BIVHL7,BISAVE
 S BIVNAM=$$VNAME^BIUTL2(BIPTR)
 S BIVHL7=$$CODE^BIUTL2(BIPTR,1)
 S BIREC=$$REACTXT^BIUTL6(BIREC)
 S BILOT=$$LOTTX^BIUTL6(BILOT)
 ;
 S BISAVE="BIADFN;BICAT;BIDATE;BIDFN;BILOC;BILOT;BIOLOC;BIPTR"
 S BISAVE=BISAVE_";BIREC;BITYPE;BIVHL7;BIVNAM;BIVSIT;DIC;X;XQORS"
 D
 .S DIC=101,X="BI IMMUNIZATION ADDED"
 .D EN^XBNEW("EN^XQOR",BISAVE)
 ;
 Q
 ;
 ;
 ;----------
VFILE1 ;EP
 ;---> Add (create) V IMMUNIZATION from ^DD of V CPT.
 ;---> Called from EN^XBNEW, from CPTIMM^BIRPC6
 ;---> Local Variables:
 ;     1 - BIVSIT (req) IEN of Parent Visit.
 ;     2 - BIDATA (req) String of data for the Visit to be added.
 ;                      See BIDATA definition at linelabel PARSE.
 ;
 Q:'$G(BIVSIT)  Q:'$D(BIDATA)
 D VFILE(BIVSIT,BIDATA)
 Q
 ;
 ;
 ;----------
IMPORT(APCDALVR) ;PEP - Code to flag V Imm as "Imported."
 ;---> Code for Tom Love to flag entry as Imported From Outside Registry.
 ;---> Parameters:
 ;     1 - APCDALVR (req) Array returned from call to EN^APCDALVR.
 ;                   APCDALVR("APCDADFN") - IEN of V IMMUNIZATION File entry.
 ;                   APCDALVR("APCDAFLG") - =2 If FAILED to create a V FILE entry.
 ;
 Q:($G(APCDALVR("APCDAFLG")))
 Q:('$G(APCDALVR("APCDADFN")))
 N BIADFN S BIADFN=APCDALVR("APCDADFN")
 ;
 ;---> Add Import From Outside.
 N BIFLD S BIFLD(.15)=1
 D FDIE^BIFMAN(9000010.11,BIADFN,.BIFLD,.BIERR)
 Q
