ABSPOSCC ; IHS/FCS/DRS - Set up ABSP() ;      [ 05/09/2003  9:37 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**1,4,6,9,11,15,16,17,19,20,21,29,37,40,42,46**;JUN 01, 2001
 ;---
 ; IHS/SD/lwj 03/12/02  some insurers are requiring the entire
 ; untranslated value as the cardholder id - new array budget
 ; added to hold the "raw" value for transmission
 ; New entry in ABSP("Insurer","Full Policy #")=$$INSPOL
 ;---
 ; IHS/SD/lwj 11/25/02 Medicaid date of birth change
 ; Pam Schweitzer requested that for all the Medicaid formats we use
 ; the Medicaid DOB rather than the Patient DOB currently in use.
 ; A new variable ABSP("Patient","Caid DOB") was added to this routine.
 ;---
 ; IHS/SD/lwj 5/5/03  Changes needed for Idaho Medicaid 5.1.
 ; Idaho Medicaid went live and forgot to tell us that the Cardholder
 ; first and last names are now required.  We tested with them without
 ; problems, but go-live things failed.  Added logic from ABSPOSFC
 ; to retrieve the cardholder first and last names.
 ;---
 ;IHS/SD/lwj 12/04/03
 ; New 5.1 formats are now requiring the patient's address info
 ; be included on the claim.  (Foundation Health Generic 5.1 for
 ; Blackhawk was the first.)  Subroutine added to retrieve the 
 ; information from the ^DPT file and populate the array for use
 ; in fields 322, 323, 324 and 325.
 ;---
 ;IHS/SD/lwj 4/30/04 patch 11
 ; Cannot assume state value is populated - $G added to
 ; GETAINFO.  Problem seen at Santa Fe.
 ;---
 ;IHS/SD/RLT - 01/24/06 - Patch 15
 ;    Access new MPD elig data.
 ;---
 ;IHS/SD/RLT - 02/13/06 - Patch 16
 ;    Access Group # in MPD elig data.
 ;---
 ;IHS/SD/RLT - 04/10/06 - Patch 17
 ;    Access DOB in MPD elig data.
 ;---
 ;IHS/SD/RLT - 04/25/06 - Patch 17
 ;    Access RR D elig data.
 ;---
 ;IHS/SD/RLT - 1/16/07 - Patch 19
 ;    Elig beg and end dates for Medi-Cal format.
 ;    Issue date needs to be appended to cardholder ID.
 ;---
 ;IHS/SD/RLT - 3/15/07 - Patch 20
 ;    NPI
 ;---
 ;IHS/SD/RLT - 5/10/07 - Patch 21
 ;    Added Medicare to Person Code
 ;---
 ;IHS/SD/RLT - 5/14/07 - Patch 21
 ;    Updated NPI
 ;---
 ;IHS/OIT/RCS - 8/12/13 - Patch 46
 ;    Added 'ABSP("Patient","Location")' variable
 Q
 ; Called from ABSPOSCA from ABSPOSQG from ABSPOSQ2
 ; Sets up the ABSP(*) nodes
 ; GETINFO gets the patient/visit-level stuff
 ;
GETINFO(DIALOUT,PATIEN,VSTIEN,PINS,INSIEN) ;EP
 ;Manage local variables
 N XDATA,NRECIEN
 ; PINSDA = pointer into insurance elig file,
 ; PINSDA1 = pointer into multiple of ^AUPNPRVT where appropriate
 N PINSDA,PINSDA1,PINSTYPE S PINSDA=$P(PINS,",",2),PINSTYPE=$P(PINS,",")
 I PINSTYPE="PRVT" S PINSDA1=$P(PINS,",",3) ; else PINSDA1 undef
 S ABSP("VisitIEN")=VSTIEN
 ;
 ;Medicare D
 N MDFLG,MDIEN
 S (MDFLG,MDIEN)=""
 I PINSTYPE="CARE" D
 . S MDFLG=$$MDFLG^ABSPOSCG()
 . S:MDFLG MDIEN=$P(PINS,",",3)
 ;
 ;Railroad D
 N RRDFLG,RRDIEN
 S (RRDFLG,RRDIEN)=""
 I PINSTYPE="RR" D
 . S RRDFLG=$$RRDFLG^ABSPOSCG()
 . S:RRDFLG RRDIEN=$P(PINS,",",3)
 ;
 ;"Site" nodes
 S ABSP("Site","IEN")=DIALOUT
 S ABSP("Site","Switch Type")=$$SWTYPE(DIALOUT)
 N PHARMACY
 D
 . N ABSBRXI S ABSBRXI=$O(RXILIST(""))
 . S PHARMACY=$P(^ABSPT(ABSBRXI,1),U,7)
 . S XDATA=^ABSP(9002313.56,PHARMACY,0)
 . S ABSP("Site","NABP #")=$P(XDATA,U,2)
 . S ABSP("Site","Default DEA #")=$P(XDATA,U,3)
 . S ABSP("Envoy Terminal ID")=$P(XDATA,U,6)
 . S XDATA=$G(^ABSP(9002313.56,PHARMACY,"CAID"))
 . S ABSP("Site","Medicaid Pharmacy #")=$P(XDATA,U)
 . S ABSP("Site","Default CAID #")=$P(XDATA,U,2)
 . S XDATA=$G(^ABSP(9002313.56,PHARMACY,"NDC"))
 . S ABSP("Site","NDC ID")=$P(XDATA,U)
 . ;Get OP Site to find Institution - NPI
 . S ABSP("Outpatient Site")=$P($G(^ABSPT(ABSBRXI,1)),U,4)
 . S ABSP("Institution")=""
 . I ABSP("Outpatient Site")'="" D
 .. S ABSP("Institution")=$P($G(^PS(59,ABSP("Outpatient Site"),"INI")),U,2)
 ;
 ;Get Institution NPI #
 S ABSP("Site","NPI #")=-1
 I ABSP("Institution")'="" D
 . S ABSP("Site","NPI #")=$P($$NPI^XUSNPI("Organization_ID",ABSP("Institution")),U)
 ;
 ;Get Global NPI Flag
 S ABSP("Global NPI Flag")=$P($G(^ABSP(9002313.99,1,"NPI")),U)
 ;
 ;"Patient" nodes
 S XDATA=^DPT(PATIEN,0)
 S ABSP("Patient","IEN")=PATIEN
 D  ; Patient,Name
 . N % I PINSTYPE="CAID" D
 . . S %=$$CAIDNAME^ABSPOSCH
 . E  I PINSTYPE="CARE" D
 . . S %=$$CARENAME^ABSPOSCH
 . E  I PINSTYPE="RR" D
 . . S %=$$RRNAME^ABSPOSCG
 . E  S %=""
 . I %="" S %=$P(XDATA,U)
 . S ABSP("Patient","Name")=%
 S ABSP("Patient","Sex")=$P(XDATA,U,2)
 S ABSP("Patient","DOB")=$P(XDATA,U,3)
 S ABSP("Patient","SSN")=$P(XDATA,U,9)
 S ABSP("Patient","EMAIL")=$P($G(^AUPNPAT(PATIEN,18)),U,2) ;Patch 42
 S ABSP("Patient","Location")="01" ;Patch 46, Default value
 ;
 ;IHS/SD/lwj 12/04/03  patch 9 get address info
 D GETAINFO^ABSPOSCH
 ;
 ;IHS/SD/lwj 11/25/02 get Medicaid DOB
 S ABSP("Patient","Medicaid DOB")=$$CAIDDOB^ABSPOSCH
 ;
 S ABSP("Patient","Medicare DOB")=""
 S:PINSTYPE="CARE" ABSP("Patient","Medicare DOB")=$$CAREDOB^ABSPOSCH
 ;
 S ABSP("Patient","Railroad DOB")=""
 ;S:PINSTYPE="RR" ABSP("Patient","Railroad DOB")=$$RRDOB^ABSPOSCG
 S:PINSTYPE="RR" ABSP("Patient","Medicare DOB")=$$RRDOB^ABSPOSCG
 ;
 ;"RX" mode containing date filled
 ; (All of the prescriptions are the same date filled
 ;  because they're all for the same visit.  We assume.)
 ;IHS/OIT/CNI/RAN patch 40 This is NOT the fill date should be set up at Prescription level in ABSPOSCD
 ;S ABSP("RX","Date Filled")=$P($G(^AUPNVSIT(VSTIEN,0)),U,1)
 ;
 ;"Insurer" nodes
 S (INSIEN,ABSP("Insurer","IEN"))=INSIEN ;$$INSIEN
 ;
 ;Get Insurer NPI Flag
 S ABSP("Insurer NPI Flag")=$P($G(^ABSPEI(+INSIEN,100)),U,14)
 ;
 ;Set Send NPI
 ;S ABSP("Send NPI")=""
 ;S:ABSP("Global NPI Flag")=1!(ABSP("Insurer NPI Flag")=1) ABSP("Send NPI")=1
 ;I ((ABSP("Global NPI Flag")=1)&(ABSP("Insurer NPI Flag")'=0))!((ABSP("Global NPI Flag")'=1)&(ABSP("Insurer NPI Flag")=1)) D
 ;. S ABSP("Send NPI")=1
 S ABSP("Send Pharmacy NPI")=""
 S ABSP("Send Prescriber NPI")=""
 I (ABSP("Insurer NPI Flag")=""&(ABSP("Global NPI Flag")=1))!(ABSP("Insurer NPI Flag")="1") D
 . S ABSP("Send Pharmacy NPI")=1       ;both
 . S ABSP("Send Prescriber NPI")=1
 I ABSP("Insurer NPI Flag")="P" D
 . S ABSP("Send Pharmacy NPI")=1       ;pharmacy only
 I ABSP("Insurer NPI Flag")="D" D
 . S ABSP("Send Prescriber NPI")=1     ;send prescriber only
 ;
 ;IHS/SD/lwj  5/5/03 added cardholder info for Idaho Medicaid
 S ABSP("Cardholder","Last Name")=$$INSDNAME(2)
 S ABSP("Cardholder","First Name")=$$INSDNAME(1)
 ;
 S ABSP("Insurer","Relationship")=$$INSREL
 S ABSP("Insurer","Person Code")=$$PERSON
 ;S ABSP("Eligibility Clarification code")=$$ELGCLAR
 S ABSP("Insurer","Group #")=$$INSGRP
 ; Try to strip blanks, punctuation ; ABSP*1.0T7*3
 ;S ABSP("Insurer","Policy #")=$$INSPOL ; ABSP*1.0T7*3
 S ABSP("Insurer","Policy #")=$TR($$INSPOL,"- /.","") ; ABSP*1.0T7*3
 ;
 ;IHS/OIT/SCR 01/15/09 patch 29
 S ABSP("Insurer","Member #")=$$INSMBRNM
 ;
 ; IHS/SD/lwj 03/12/02  some insurers require entire, untranslated
 ; value
 S ABSP("Insurer","Full Policy #")=$$INSPOL ;IHS/SD/lwj 03/12/02
 ;
 ;Issue (begin elig) date needed to append to Medi-Cal cardholder ID
 S ABSP("Insurer","Elig Dates")=$$CAIDELDT^ABSPOSCH
 S ABSP("Insurer","Elig Beg Dt")=$P(ABSP("Insurer","Elig Dates"),U)
 S ABSP("Insurer","Elig End Dt")=$P(ABSP("Insurer","Elig Dates"),U,2)
 ;
 ; Pharmacy number:  usually NABP #, but sometimes the insurer demands
 ; their own insurer-assigned pharmacy number.  Especially with Medicaid
 S ABSP("Site","Pharmacy #")=ABSP("Site","NABP #")
 I $D(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #","B",INSIEN)) D
 . N X S X=$O(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #","B",INSIEN,0))
 . S ABSP("Site","Pharmacy #")=$P(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #",X,0),U,2)
 . ;IHS/OIT/SCR 02/12/09 - Collect "Site", "Pharmacy - MED-CAL ID" 'INFO
 . S ABSP("Site","MED-CAL Subscriber #")=$P(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #",X,0),U,3)
 . ;IHS/OIT/RAN 03/01/10 - Patch 37 Collect "Site", "Pharmacy - CA FAMILY PACT ID" 'INFO
 . S ABSP("Site","CA FAMILY PACT ID")=$P(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #",X,0),U,4)
 ; Anachronism:  Medicaid Pharmacy # is a special field,
 ; properly, it belongs in the INSURER-ASSIGNED #
 ; But that Medicaid Pharmacy # will overwrite the in INS.-ASSIGNED #
 I PINSTYPE="CAID" D
 . I ABSP("Site","Medicaid Pharmacy #")'="" D
 .. S ABSP("Site","Pharmacy #")=ABSP("Site","Medicaid Pharmacy #")
 . I ABSP("Site","Medicaid Pharmacy #")=""&(ABSP("Site","Default CAID #")'="") D
 .. S ABSP("Site","Pharmacy #")=ABSP("Site","Default CAID #")     ;RLT - Patch 20
 ;
 ;Set fields 202 and 201
 S ABSP("Header","Service Prov ID Qual")="07"           ;default for 202
 ;I ABSP("Send NPI")=1&(ABSP("Site","NPI #")>0) D
 I ABSP("Send Pharmacy NPI")=1&(ABSP("Site","NPI #")>0) D
 . S ABSP("Header","Service Prov ID Qual")="01"
 . S ABSP("Site","Pharmacy #")=ABSP("Site","NPI #")
 ;
 ;"NCPDP" nodes
 ;S NRECIEN=$P($G(^ABSPEI(INSIEN,100)),U,1)
 ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 -New code for D.0 - START
 ;D:NRECIEN'=""
 ;. S ABSP("NCPDP","IEN")=NRECIEN
 ;The Conversion has been run....no longer need formats
 I $G(^ABSP(9002313.99,1,"ABSPICNV"))=1 D
 . Q:'$D(^ABSPEI(INSIEN))
 . N INSARRAY
 . D GETS^DIQ(9002313.4,INSIEN_",","100.15;100.16;100.19;100.2","","INSARRAY")
 . S ABSP("NCPDP","Version")=INSARRAY(9002313.4,INSIEN_",",100.15) ;NEW PLACE TO STORE NCPDP VERSION
 . S ABSP("NCPDP","BIN Number")=INSARRAY(9002313.4,INSIEN_",",100.16)
 . S ABSP("NCPDP","# Meds/Claim")=INSARRAY(9002313.4,INSIEN_",",100.19)
 . S ABSP("NCPDP","Add Disp. Fee to Ingr. Cost")=INSARRAY(9002313.4,INSIEN_",",100.2)
 . S ABSP("NCPDP","Add Disp. Fee to Ingr. Cost")=$S(ABSP("NCPDP","Add Disp. Fee to Ingr. Cost")="NO":0,1:1)
 . S ABSP("NCPDP","IEN")=1
 ELSE  D
 . ;This is the old code that gets info from format.
 . S NRECIEN=$P($G(^ABSPEI(INSIEN,100)),U,1)
 . S ABSP("NCPDP","IEN")=NRECIEN
 . Q:'NRECIEN
 . S XDATA=$G(^ABSPF(9002313.92,NRECIEN,1))
 . S ABSP("NCPDP","BIN Number")=$P(XDATA,U,1)
 . S ABSP("NCPDP","Version")=$P(XDATA,U,2)
 . S ABSP("NCPDP","# Meds/Claim")=$P(XDATA,U,3)
 . S ABSP("NCPDP","Envoy Plan Number")=$P(XDATA,U,4)
 . I $P(XDATA,U,8)="" S $P(XDATA,U,8)=1
 . S ABSP("NCPDP","Add Disp. Fee to Ingr. Cost")=$P(XDATA,U,8)
 ;IHS/OIT/CASSEVERN/RAN - 02/09/2011 - Patch 42 -New code for D.0 - STOP
 Q
 ;
 ; $$INSxxx functions - given PINSTYPE, PINSDA, PINSDA1
INSIEN() ; get pointer to ^AUTNINS
 ; (But shouldn't we directly get this from the IEN59?)
 I PINSTYPE="CAID" Q $P($G(^AUPNMCD(PINSDA,0)),U,2)
 I PINSTYPE="PRVT" Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U)
 I PINSTYPE="CARE" Q $P($G(^AUPNMCR(PINSDA,0)),U,2)
 I PINSTYPE="RR" Q $P($G(^AUPNRRE(PINSDA,0)),U,2)
 I PINSTYPE="SELF" Q ""
 D IMPOSS^ABSPOSUE("P","TI","Bad PINSTYPE="_PINSTYPE,,"INSIEN",$T(+0))
 Q
INSREL() ; a single digit, 1, 2, 3, 4 = self,spouse,child,other
 N X S X=+$$AUTTRLSH Q:'X 4 ; X points to ^AUTTRLSH(
 ; Translate it using our own file, 9002313.81
 S X=$P($G(^AUTTRLSH(X,0)),U) Q:X="" 4 ; translate to name
 S X=$O(^ABSPF(9002313.81,"B",X,0)) Q:'X 4 ; point into 9002313.81
 S X=$P(^ABSPF(9002313.81,X,0),U,2)
 Q $S(X:X,1:4)
AUTTRLSH()         ; relationship - pointer to ^AUTTRLSH
 I PINSTYPE="PRVT" Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,5)
 N X S X=$O(^AUTTRLSH("B","SELF",0)) I 'X D IMPOSS^ABSPOSUE("DB","TI","RELATIONSHIP file is missing SELF entry",,"AUTTRLSH",$T(+0))
 Q X
ELGCLAR()          ; Eligibility clarification code
 ; From Paid Presc. documentation:
 ; 3=Full-time student; 4=Disabled dependent; 5=Dependent parent
 ; 6=Significant other.  Required if relationship code=3 or 4 and
 ; patient is age 18 or over.
 Q ""
PERSON() ; Person Code
 ; Check the new location just recently mispatched into registration.
 ; Something's goofy, FILEMAN, P^DI, 8, 1, GLOBAL doesn't show this
 ;  field, but it is in ^DD(9000006.11,.12,...)
 N X
 ;I PINSTYPE="PRVT" S X=$P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,12) ; 
 ;E  S X=""
 S X=""        ;RLT 21
 I PINSTYPE="PRVT" S X=$P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,12)
 I PINSTYPE="CARE"&(MDFLG&(MDIEN)) S X=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,7)
 ; otherwise, a simple translation from relationship code:
 ; 1->"01", 2->"02", etc.
 I X="" S X="0"_$$INSREL
 Q X
INSGRP() ; Insurer Grp #
 N GRPIEN
 S GRPIEN=""
 ;RLT 21
 ;S:PINSTYPE="CARE"&(MDIEN) GRPIEN=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,11)
 S:PINSTYPE="CARE"&(MDFLG&(MDIEN)) GRPIEN=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,11)
 Q:GRPIEN $P($G(^AUTNEGRP(GRPIEN,0)),U,2)
 S:PINSTYPE="RR"&(RRDFLG&(RRDIEN)) GRPIEN=$P($G(^AUPNRRE(PINSDA,11,RRDIEN,0)),U,11)
 Q:GRPIEN $P($G(^AUTNEGRP(GRPIEN,0)),U,2)
 I PINSTYPE'="PRVT" Q ""
 N X S X=$$INS3PPH Q:'X ""
 N Y S Y=$P($G(^AUPN3PPH(X,0)),U,6) Q:'Y ""
 N Z S Z=$P($G(^AUTNEGRP(Y,11,111,0)),U,2) ; OP group #
 I Z="" S Z=$P($G(^AUTNEGRP(Y,0)),U,2) ; else general
 Q Z
 ;
 ; V1.0  Patch 6
 ; IHS/SD/lwj 5/5/03 for Idaho Medicaid to get cardholder first and last name.
 ; Taken directly from ABSPOSFC routine.
 ;
INSDNAME(N) ; Insured's name
 N X
 I PINSTYPE="CAID" S X=$$CAIDNAME^ABSPOSCH
 E  I PINSTYPE="CARE" S X=$$CARENAME^ABSPOSCH
 E  I PINSTYPE="RR" S X=$$RRNAME^ABSPOSCG
 E  I PINSTYPE="SELF" S X=$G(ABSP("Patient","Name"))
 E  I PINSTYPE="PRVT" D
 . N T S T=$$INS3PPH
 . I 'T S X="" Q  ; no 3PPH?
 . S X=$P(^AUPN3PPH(T,0),U) ; Policy holder
 E  D IMPOSS^ABSPOSUE("P","TI","Bad PINSTYPE="_PINSTYPE,,"INSDNAME",$T(+0))
 I X="" S X=ABSP("Patient","Name")
 I N=1 Q $P(X,",",2) ; first name
 E  I N=2 Q $P(X,",",1) ; last name
 E  Q X ; entire name
 ;
 Q ""
 ;
INS3PPH()           Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,8)
INSPOL() I PINSTYPE="CAID" Q $P($G(^AUPNMCD(PINSDA,0)),U,3)
 ;I PINSTYPE="CARE" Q $P($G(^AUPNMCR(PINSDA,0)),U,3) ; no suffix?
 I PINSTYPE="CARE" Q $$GETMDPOL^ABSPOSCG
 ;I PINSTYPE="RR" Q $P($G(^AUPNRRE(PINSDA,0)),U,4) ; no prefix?
 I PINSTYPE="RR" Q $$GETRRDPL^ABSPOSCG
 I PINSTYPE="SELF" Q ""
 I PINSTYPE'="PRVT" D IMPOSS^ABSPOSUE("P","TI","Bad PINSTYPE="_PINSTYPE,,"INSPOL",$T(+0))
 N X S X=$$INS3PPH
 I X N Y S Y=$P($G(^AUPN3PPH(X,0)),U,4) I Y]"" Q Y ; 3PPH first
 Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,2) ; else PRVT
INSMBRNM()  ; Member #
 ;IHS/OIT/SCR 01/15/09 - Patch 29
 N ABSPMNUM
 S ABSPMNUM=""
 S:PINSTYPE="PRVT" ABSPMNUM=$G(^AUPNPRVT(PINSDA,11,PINSDA1,2))
 Q ABSPMNUM
SWTYPE(D)          ;EP - from ABSPOSC4 - given pointer to dial-out
 ; Is it NDC or ENVOY?
 N X S X=^ABSP(9002313.55,D,0)
 I $P(X,U,3)]"" Q $P(X,U,3)
 I $P(X,U)["NDC" Q "NDC"
 I $P(X,U)["ENVOY" Q "ENVOY"
 D IMPOSS^ABSPOSUE("P","TI","Bad switch type for dialout "_D,,"SWTYPE",$T(+0))
 Q "" ; should never happen
