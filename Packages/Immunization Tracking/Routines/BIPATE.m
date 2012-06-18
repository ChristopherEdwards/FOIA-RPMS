BIPATE ;IHS/CMI/MWR - PATIENT CASE DATA EDIT; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT PATIENT CASE DATA.
 ;
 ;
 ;----------
MAIN ;EP
 ;---> Not called from Menus.
 D SETVARS^BIUTL5
 F  D PATIENT Q:BIPOP
 ;
EXIT ;EP
 D KILLALL^BIUTL8(1)
 Q
 ;
 ;
 ;----------
PATIENT ;EP
 D TITLE^BIUTL5("EDIT PATIENT CASE DATA")
 ;
PATIENT1 ;EP
 ;---> To avoid @IOF and title.
 ;---> Select Patient.
 N Y S Y=""
 W !!,"   Select the patient you wish to add or edit."
 D PATLKUP^BIUTL8(.BIDFN,"ADD",DUZ(2),.BIPOP)
 Q:BIPOP
 I BIDFN<0 S BIPOP=1 Q
 S BIDFN=+BIDFN
 ;---> Quit if this patient is Locked (being edited by another user).
 L +^BIP(BIDFN):1 I '$T D ERRCD^BIUTL2(212,.BIERR) Q
 ;---> If called from here, do not do HDR & INIT in ^BIPATVW.
 D SCREEN(BIDFN) S BIPOP=0
 L -^BIP($G(BIDFN))
 Q
 ;
 ;
 ;----------
SCREEN(BIDFN) ;EP
 ;---> Edit Patient Case Data with Screenman.
 ;---> Parameters:
 ;     1 - BIDFN  (req) Patient's IEN in VA PATIENT File #2.
 ;
 ;---> If <STKOV> errors appear here, increase STACK in SYSGEN,
 ;---> System Configuration Parameters.
 ;
 ;---> Quit if BIDFN not provided.
 I '$G(BIDFN) D ERRCD^BIUTL2(206,,1)
 ;
 ;---> Gather Case Data for this Patient to load for Screenman edit.
 N Y S Y=""
 D CASEDAT^BIRPC5(.Y,BIDFN) ;EP
 ;
 ;---> If an error is passed back, display it and quit.
 N BI31,BIRETERR S BI31=$C(31)_$C(31)
 S BIRETERR=$P(Y,BI31,2)
 I BIRETERR]"" D EN^DDIOL("* "_BIRETERR,"","!!?5"),DIRZ^BIUTL3() Q
 S Y=$P(Y,BI31)
 ;
 ;---> Build BI array for Case Data edit via Screenman.
 N BI
 S BI("A")=+BIDFN       ;Patient DFN.
 S BI("B")=$P(Y,U)      ;Case Manager's name, text.
 S BI("C")=$P(Y,U,2)    ;Parent or Guardian, text.
 S BI("D")=$P(Y,U,3)    ;Mother's HBsAG Status (P,N,A,U).
 S BI("E")=$P(Y,U,4)    ;Date Patient became Inactive (DD-Mmm-YYYY).
 S BI("F")=$P(Y,U,5)    ;Reason for Inactive.
 S BI("G")=$P(Y,U,6)    ;Other Info.
 S BI("H")=$P(Y,U,7)    ;Forecast Influenza/Pneumococcal.
 S BI("I")=$P(Y,U,8)    ;Location Moved or Tx Elsewhere.
 S BI("K")=$P(Y,U,9)    ;State Registry Consent, 1=YES, 0/""=NO.
 ;
 N DR S DR="[BI FORM-CASE DATA EDIT]"
 D DDS^BIFMAN(9002084,DR,BIDFN,"","",.BIPOP)
 Q
 ;
 ;
 ;----------
AUTOADD(BIDFN,BISITE,BIERR,BINACT) ;PEP - Automatically add a Patient to the Imm DB.
 ;---> Automatically add a Patient to the Imm Register.
 ;---> If an Inactive Date is passed, Patient will be added as Inactive today.
 ;---> If no Inactive Date is passed and the Patient is under 36 months of age
 ;---> and has a Current Community in the GPRA Set of Communities (defined by
 ;---> Imm Manager under Edit Site Parameters), or if the Patient has NO Current
 ;---> Cummunity set yet, then the Patient will be added as Active.
 ;---> Otherwise the Patient is added as Inactive.
 ;---> Parameters:
 ;     1 - BIDFN  (req)   Patient's IEN in VA PATIENT File #2.
 ;     2 - BISITE (req)   DUZ(2) for default Case Manager.
 ;     3 - BIERR  (ret)   Error text, if any.
 ;     4 - BINACT (opt)   Fileman internal date Patient became Inactive.
 ;
 ;---> Check for valid Patient.
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 I '$D(^AUPNPAT(BIDFN,0)) D ERRCD^BIUTL2(203,.BIERR) Q
 ;---> Check for valid Site.
 S:'$G(BISITE) BISITE=$G(DUZ(2))
 I '$G(BISITE) D ERRCD^BIUTL2(105,.BIERR) Q
 ;
 N BINACTR S BINACTR=""
 D
 .;---> Forced Inactive by passing Inactive Date.
 .I $G(BINACT) S BINACTR="n" Q
 .;---> Under 36 mths and in GPRA, this patient will be Active.
 .;I $$AGE^BIUTL1(BIDFN,2)<36,$$ISGPRA^BIUTL11(BIDFN,BISITE) Q
 .N BIAGE S BIAGE=$$AGE^BIUTL1(BIDFN,2)
 .;---> Request by Amy Groom:
 .;---> If under 36 mths and patient has NO Cur Community, add as Active.
 .I BIAGE<36,'$$CURCOM^BIUTL11(BIDFN) Q
 .I BIAGE<36,$$ISGPRA^BIUTL11(BIDFN,BISITE) Q
 .;---> Older than 36 mths or not in GPRA, this patient will be Inactive
 .;---> as of today with a Reason of "Never Activated."
 .S BINACT=$G(DT),BINACTR="n"
 ;
 D ADDPAT(BIDFN,BISITE,.BIERR,$G(BINACT),BINACTR,1)
 Q
 ;
 ;
 ;----------
ADDPAT(BIDFN,BISITE,BIERR,BINACT,BINACTR,BIAUTO) ;PEP  Add a Patient to Imm DB
 ;---> Add new Patient to Immunization Database (BI PATIENT File).
 ;---> Sets Case Manger to Site Parameter default.
 ;---> Also records User and date first entered.
 ;---> Called by AGZIMM at ANMC to add newborns from RPMS Registration.
 ;---> Parameters:
 ;     1 - BIDFN   (req)   Patient's IEN in VA PATIENT File #2.
 ;     2 - BISITE  (req)   DUZ(2) for default Case Manager.
 ;     3 - BIERR   (ret)   Error text, if any.
 ;     4 - BINACT  (opt)   Fileman internal date Patient became Inactive.
 ;     5 - BINACTR (opt)   Internal code for Inactive Reason:
 ;                            m:Moved Elsewhere, t:Treatment Elsewhere, d:Deceased
 ;                            p:Previously Inactivated, n:Never Activated
 ;     6 - BIAUTO  (opt)   If BIAUTO=1, set Field# .22="Automatically" added.
 ;
 ;     Example: D AUTOADD^BIPATE(BIDFN,1665,.X,DT,"n")
 ;
 ;---> If BIDFN not provided, return error and quit.
 I '$G(BIDFN) D ERRCD^BIUTL2(201,.BIERR) Q
 ;
 ;---> If Patient is already in the Imm Database, return error and quit.
 I $D(^BIP(BIDFN,0)) D ERRCD^BIUTL2(218,.BIERR) Q
 ;
 ;---> If no Site IEN was passed, try to get it from local symbol table.
 S:'$G(BISITE) BISITE=$G(DUZ(2))
 ;---> If BISITE not provided, return error and quit.
 I '$G(BISITE) D ERRCD^BIUTL2(105,.BIERR) Q
 ;
 ;---> If Default Case Manager is INACTIVE, return error and quit.
 N BICMGR S BICMGR=$$CMGRDEF^BIUTL2(BISITE)
 I BICMGR,$$CMGRACT^BIUTL2(BICMGR) D ERRCD^BIUTL2(214,.BIERR) Q
 ;
 ;---> Trim time from BINACT (seed if necessary).
 S BINACT=$P($G(BINACT),".") S:BINACT<2000000 BINACT=""
 ;
 ;---> Check/set Inactive reason.
 S:"mtdpn"'[$E($G(BINACTR)) BINACTR=""
 S:'BINACT BINACTR=""
 ;
 N BIERR,BIFLD,BIIEN
 S BIIEN(1)=BIDFN
 S BIFLD(.01)=BIDFN
 S BIFLD(.08)=BINACT
 S BIFLD(.1)=BICMGR
 S BIFLD(.16)=BINACTR
 S BIFLD(.2)=$G(DUZ)
 S BIFLD(.21)=$G(DT)
 S BIFLD(.22)=$S($G(BIAUTO):1,1:"")
 D UPDATE^BIFMAN(9002084,.BIIEN,.BIFLD,.BIERR)
 I $G(BIERR)]"" W !!?3,BIERR D DIRZ^BIUTL3()
 Q
