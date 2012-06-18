ABSPOSFC ; IHS/FCS/DRS - Set up ABSP() ;    [ 09/12/2002  10:09 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3,15,16,40**;JUN 21, 2001
 ;----------------------------------------------------------------------
 ;----------------------------------------------------------------------
 Q
 ; This is a copy of routine ABSPOSCC, made on 03/20/2001.
 ; It has some minor changes for printing NCPDP forms.
 ; Try to keep the two versions in synch.
 ;
 ; Called by ABSPOSFB from ABSPOSFA.
 ; GETINFO gets the patient/visit-level stuff
 ;
 ;----------------------------------------------------------------------
 ;IHS/SD/RLT - 01/24/06 - Patch 15
 ;    Added new code to access new Medicare D eligibility data.
 ;----------------------------------------------------------------------
 ;IHS/SD/RLT - 02/13/06 - Patch 16
 ;    Added new code to access Group # in Medicare D eligibility data.
 ;----------------------------------------------------------------------
 ;
GETINFO(DIALOUT,PATIEN,VSTIEN,PINS,INSIEN) ;EP
 N XDATA,NRECIEN
 ; PINSDA = pointer into insurance eligible file,
 ; PINSDA = pointer into multiple of ^AUPNPRVT where appropriate
 N PINSDA,PINSDA1,PINSTYPE S PINSDA=$P(PINS,",",2),PINSTYPE=$P(PINS,",")
 I PINSTYPE="PRVT" S PINSDA1=$P(PINS,",",3) ; else PINSDA1 undef
 S ABSP("VisitIEN")=VSTIEN
 ;
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - begin
 ;New Medicare D eligibiiltiy lookup.
 ;Set IEN to be used in policy# and name lookup.
 N MDIEN
 S MDIEN=""
 S:PINSTYPE="CARE" MDIEN=$$GETMDIEN
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - end
 ;
 ;"Site" nodes
 ;S ABSP("Site","IEN")=DIALOUT
 ;S ABSP("Site","Switch Type")=$$SWTYPE(DIALOUT)
 N PHARMACY
 D
 . N IEN57 S IEN57=$O(TRANSACT(""))
 . S PHARMACY=$P(^ABSPTL(IEN57,1),U,7)
 . S XDATA=^ABSP(9002313.56,PHARMACY,0)
 . S ABSP("Site","NABP #")=$P(XDATA,U,2)
 . S ABSP("Site","Default DEA #")=$P(XDATA,U,3)
 . S ABSP("Envoy Terminal ID")=$P(XDATA,U,6)
 . S ABSP("Site","Name")=$P(XDATA,U)_" PHARMACY"
 . S ABSP("Site","Tax ID #")=$P(XDATA,U,5)
 . S XDATA=$G(^ABSP(9002313.56,PHARMACY,"CAID"))
 . S ABSP("Site","Medicaid Pharmacy #")=$P(XDATA,U)
 . S ABSP("Site","Default CAID #")=$P(XDATA,U,2)
 . S XDATA=$G(^ABSP(9002313.56,PHARMACY,"NDC"))
 . S ABSP("Site","NDC ID")=$P(XDATA,U)
 . ; These additional nodes for paper forms only:
 . N ADDR S ADDR=$G(^ABSP(9002313.56,PHARMACY,"ADDR"))
 . S ABSP("Site","Addr")=$P(ADDR,U) I $P(ADDR,U,2)]"" D
 . . S ABSP("Site","Addr")=ABSP("Site","Addr")_"/"_$P(ADDR,U,2)
 . S ABSP("Site","City")=$P(ADDR,U,3)
 . S ABSP("Site","State")=$P(ADDR,U,4)
 . S ABSP("Site","Zip")=$P(ADDR,U,5)
 . S ABSP("Site","Phone")=$P(ADDR,U,6)
 . S ABSP("Site","Fax")=$P(ADDR,U,7)
 . S ABSP("Site","Contact")="" ; contact name
 . ; May have special list of contact names and phone #s
 . ; (the old NCPDP form had a line for Contact name as well as phone #)
 . N X S X=$G(^ABSP(9002313.56,PHARMACY,"REP"))
 . Q:$P(X,U,2)=""
 . N N S N=$L($P(X,U,2),",") ; how many contact names/phone #s
 . S N=$R(N)+1 ; pick one at random
 . S ABSP("Site","Phone")=$P($P(X,U,2),",",N)
 . S ABSP("Site","Contact")=$P($P(X,U),",",N)
 ;
 S XDATA=^DPT(PATIEN,0)
 S ABSP("Patient","IEN")=PATIEN
 D  ; Patient,Name
 . N % I PINSTYPE="CAID" D
 . . S %=$$CAIDNAME
 . E  I PINSTYPE="CARE" D
 . . S %=$$CARENAME
 . E  S %=""
 . I %="" S %=$P(XDATA,U)
 . S ABSP("Patient","Name")=%
 S ABSP("Patient","Sex")=$P(XDATA,U,2)
 S ABSP("Patient","DOB")=$P(XDATA,U,3)
 S ABSP("Patient","SSN")=$P(XDATA,U,9)
 ;
 ;"RX" mode containing date filled
 ; (All of the prescriptions are the same date filled
 ;  because they're all for the same visit.  We assume.)
 ;IHS/OIT/CNI/RAN Patch 40 This is not the correct date
 ;S ABSP("RX","Date Filled")=$P($G(^AUPNVSIT(VSTIEN,0)),U,1)
 ;
 ;"Insurer" nodes
 S (INSIEN,ABSP("Insurer","IEN"))=INSIEN ;$$INSIEN
 S ABSP("Cardholder","Last Name")=$$INSDNAME(2)
 S ABSP("Cardholder","First Name")=$$INSDNAME(1)
 S ABSP("Insurer","Relationship")=$$INSREL
 S ABSP("Insurer","Person Code")=$$PERSON
 ;ABSP("Eligibility Clarification code")=$$ELGCLAR
 S ABSP("Insurer","Group #")=$$INSGRP
 S ABSP("Insurer","Policy #")=$$INSPOL
 ;IHS/OIT/SCR 01/15/09 patch 29
 S ABSP("Insurer","Member #")=$$INSMBRNM
 ;
 ; Pharmacy number:  usually NABP #, but sometimes the insurer demands
 ; their own insurer-assigned pharmacy number.  Especially with Medicaid
 S ABSP("Site","Pharmacy #")=ABSP("Site","NABP #")
 I $D(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #","B",INSIEN)) D
 . N X S X=$O(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #","B",INSIEN,0))
 . S ABSP("Site","Pharmacy #")=$P(^ABSP(9002313.56,PHARMACY,"INSURER-ASSIGNED #",X,0),U,2)
 ; Anachronism:  Medicaid Pharmacy # is a special field,
 ; properly, it belongs in the INSURER-ASSIGNED #
 ; But that Medicaid Pharmacy # will overwrite the in INS.-ASSIGNED #
 I PINSTYPE="CAID",ABSP("Site","Medicaid Pharmacy #")]"" D
 . S ABSP("Site","Pharmacy #")=ABSP("Site","Medicaid Pharmacy #")
 ;"NCPDP" nodes
 S NRECIEN=$P($G(^ABSPEI(INSIEN,100)),U,1)
 D  ; most of this is electronic only but retained anyhow
 .S ABSP("NCPDP","IEN")=NRECIEN
 .I NRECIEN S XDATA=$G(^ABSPF(9002313.92,NRECIEN,1))
 .E  S XDATA="" ; 
 .S $P(XDATA,U,8)=0 ; do not add disp fee to ingr cost on paper forms
 .S ABSP("NCPDP","BIN Number")=$P(XDATA,U,1)
 .S ABSP("NCPDP","Version")=$P(XDATA,U,2)
 .S ABSP("NCPDP","# Meds/Claim")=$P(XDATA,U,3)
 .S ABSP("NCPDP","Envoy Plan Number")=$P(XDATA,U,4)
 .I $P(XDATA,U,8)="" S $P(XDATA,U,8)=1
 .S ABSP("NCPDP","Add Disp. Fee to Ingr. Cost")=$P(XDATA,U,8)
 I $$WORKREL D  ; extra info for workers comp claims
 . D INSWORK
 . S ABSP("Date of Injury")=$P(^AUPNVPOV($$WORKREL,0),U,8)
 ;IHS/OIT/SCR 01/15/09 - added 'SPECIAL' node info
 ;"SPECIAL" node
 S ABSP("SPECIAL","SUBSCRIBER ID")=$P($G(^ABSP(9002313.99,1,"SPECIAL")),U,4)
 Q
WORKREL() ;  this is copied from ABSPOS26+/- ; changed ABSBVISI to VSTIEN
 ; is VSTIEN a worker's comp visit?
 ; If so, return value is true = pointer to ^AUPNVPOV which has
 ;  the CAUSE OF DX listed as EMPLOYMENT RELATED
 N A,RET S (A,RET)=0
 F  S A=$O(^AUPNVPOV("AD",VSTIEN,A)) Q:'A  D  Q:RET
 . I $P($G(^AUPNVPOV(A,0)),U,7)=4 D
 . . S RET=A
 Q RET
 ; $$INSxxx functions - given PINSTYPE, PINSDA, PINSDA1
INSIEN() ; get pointer to ^AUTNINS
 ; (But shouldn't we directly get this from the IEN59?)
 I PINSTYPE="CAID" Q $P($G(^AUPNMCD(PINSDA,0)),U,2)
 I PINSTYPE="PRVT" Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U)
 I PINSTYPE="CARE" Q $P($G(^AUPNMCR(PINSDA,0)),U,2)
 I PINSTYPE="RR" Q $P($G(^AUPNRRE(PINSDA,0)),U,2)
 I PINSTYPE="SELF" Q ""
 D IMPOSS^ABSPOSUE("P","TI","bad PINSTYPE="_PINSTYPE,,"INSIEN",$T(+0))
 Q ""
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
ELGCLAR()          ; Eligibility clarification code
 ; From Paid Presc. documentation:
 ; 3=Full-time student; 4=Disabled dependent; 5=Dependent parent
 ; 6=Significant other.  Required if relationship code=3 or 4 and
 ; patient is age 18 or over.
 Q ""
PERSON() ; Person Code
 ; For now, it's a simple translation from relationship code:
 ; 1->"01", 2->"02", etc.
 Q "0"_$$INSREL
INSGRP() ; Insurer Group #
 ;RLT - 2/13/06 - Patch 16
 ;Get Medicare D group #
 N GRPIEN
 S GRPIEN=""
 S:PINSTYPE="CARE"&(MDIEN) GRPIEN=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,11)
 Q:GRPIEN $P($G(^AUTNEGRP(GRPIEN,0)),U,2)
 ;RLT - 2/13/06 - Patch 16
 I PINSTYPE'="PRVT" Q ""
 N X S X=$$INS3PPH Q:'X ""
 N Y S Y=$P($G(^AUPN3PPH(X,0)),U,6) Q:'Y ""
 N Z S Z=$P($G(^AUTNEGRP(Y,11,111,0)),U,2) ; OUTPATIENT group # if poss
 I Z="" S Z=$P($G(^AUTNEGRP(Y,0)),U,2) ; else take the general one
 Q Z
INSDNAME(N) ; Insured's name
 N X
 I PINSTYPE="CAID" S X=$$CAIDNAME
 E  I PINSTYPE="CARE" S X=$$CARENAME
 E  I PINSTYPE="SELF"!(PINSTYPE="RR") S X=ABSP("Patient","Name")
 E  I PINSTYPE="PRVT" D
 . N T S T=$$INS3PPH
 . I 'T S X="" Q  ; no 3PPH?
 . S X=$P(^AUPN3PPH(T,0),U) ; Policy holder
 E  D IMPOSS^ABSPOSUE("P","TI","Bad PINSTYPE="_PINSTYPE,,"INSDNAME",$T(+0))
 I X="" S X=ABSP("Patient","Name")
 I N=1 Q $P(X,",",2) ; first name
 E  I N=2 Q $P(X,",",1) ; last name
 E  Q X ; entire name
INSWORK ; get worker's comp-related info
 Q:PINSTYPE'="PRVT"
 N P S P=$$INS3PPH Q:'P
 N X S X=$P($G(^AUPN3PPH(P,0)),U,16) Q:'X
 S X=$G(^AUTNEMPL(X,0)) Q:X=""
 S ABSP("Employer","Name")=$P(X,U)
 S ABSP("Employer","Address")=$P(X,U,2)
 S ABSP("Employer","City")=$P(X,U,3)
 D
 . N ST
 . S ABSP("Employer","State")=$P(^DIC(5,ST,0),U,2)
 S ABSP("Employer","Zip Code")=$P(X,U,5)
 S ABSP("Employer","Phone")=$P(X,U,6)
 Q
INS3PPH()           Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,8)
INSPOL() I PINSTYPE="CAID" Q $P($G(^AUPNMCD(PINSDA,0)),U,3)
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - begin
 ;I PINSTYPE="CARE" Q $P($G(^AUPNMCR(PINSDA,0)),U,3) ; no suffix?
 I PINSTYPE="CARE" Q $$GETMDPOL
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - end
 I PINSTYPE="RR" Q $P($G(^AUPNRRE(PINSDA,0)),U,4) ; no prefix?
 I PINSTYPE="SELF" Q ""
 I PINSTYPE'="PRVT" D IMPOSS^ABSPOSUE("P","TI","Bad PINSTYPE="_PINSTYPE,,"INSPOL",$T(+0))
 N X S X=$$INS3PPH
 I X N Y S Y=$P($G(^AUPN3PPH(X,0)),U,4) I Y]"" Q Y ; 3PPH version first
 Q $P($G(^AUPNPRVT(PINSDA,11,PINSDA1,0)),U,2)  ; else PRVT version
INSMBRNM()  ; Member #
 ;IHS/OIT/SCR 01/15/09 - Patch 29
 N ABSPMNUM
 S ABSPMNUM=""
 S:PINSTYPE="PRVT" ABSPMNUM=$G(^AUPNPRVT(PINSDA,11,PINSDA1,2))
 Q ABSPMNUM
GETMDPOL()  ;Updated policy number lookup for Medicare D elig.
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - begin
 N POL,MDPOL
 S POL=$P($G(^AUPNMCR(PINSDA,0)),U,3)         ;original Medicare policy#
 S MDPOL=""
 S:MDIEN'="" MDPOL=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,6)
 S:MDPOL'="" POL=MDPOL             ;use Medicare D policy# if elig found
 Q POL
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - end
CAIDNAME()         Q $P($G(^AUPNMCD(PINSDA,21)),U)
CARENAME()         ;Q $P($G(^AUPNMCR(PINSDA,21)),U)
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - begin
 ;Updated name lookup for new Medicare D elig.
 N NAME,MDNAME
 S NAME=$P($G(^AUPNMCR(PINSDA,21)),U)           ;original Medicare name
 S MDNAME=""
 S:MDIEN'="" MDNAME=$P($G(^AUPNMCR(PINSDA,11,MDIEN,0)),U,5)
 S NAME=MDNAME                       ;use Medicare D name if elig found
 Q NAME
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - end
GETMDIEN()  ;Get IEN for Medicare D elig record lookup.
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - begin
 ;New Medicare D eligibiiltiy lookup.
 N MDFND,D1
 S MDFND=""
 S D1="A"
 F  S D1=$O(^AUPNMCR(PINSDA,11,D1),-1) Q:'D1!(MDFND)  D
 . Q:$P($G(^AUPNMCR(PINSDA,11,D1,0)),U,3)'="D"         ;coverage type
 . S MDFND=1
 . S MDIEN=D1
 Q:'MDFND ""
 Q MDIEN
 ;IHS/SD/RLT - 01/24/06 - Patch 15 - end
