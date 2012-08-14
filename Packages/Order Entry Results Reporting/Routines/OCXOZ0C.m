OCXOZ0C ;SLC/RJS,CLA - Order Check Scan ;JUN 15,2011 at 12:58
 ;;3.0;ORDER ENTRY/RESULTS REPORTING;**32**;Dec 17,1997
 ;;  ;;ORDER CHECK EXPERT version 1.01 released OCT 29,1998
 ;
 ; ***************************************************************
 ; ** Warning: This routine is automatically generated by the   **
 ; ** Rule Compiler (^OCXOCMP) and ANY changes to this routine  **
 ; ** will be lost the next time the rule compiler executes.    **
 ; ***************************************************************
 ;
 Q
 ;
CHK354 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK350+13^OCXOZ0B.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK354 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(145) --> Data Field: CLOZAPINE WBC 3.0-3.5 TEXT (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,114, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE ANC < 1.5)
 ; MSGTEXT( ---------> MESSAGE TEXT
 ;
 S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXDF(145)=$$MSGTEXT("CLOZWBC30_35"),OCXOERR=$$FILE(DFN,114,"130,145") Q:OCXOERR 
 Q
 ;
CHK360 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK350+14^OCXOZ0B.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK360 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(145) --> Data Field: CLOZAPINE WBC 3.0-3.5 TEXT (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,115, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE ANC >= 1.5)
 ; MSGTEXT( ---------> MESSAGE TEXT
 ;
 S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXDF(145)=$$MSGTEXT("CLOZWBC30_35"),OCXOERR=$$FILE(DFN,115,"130,145") Q:OCXOERR 
 Q
 ;
CHK363 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK198+9^OCXOZ09.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK363 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(43) ---> Data Field: OI NATIONAL ID (FREE TEXT)
 ; OCXDF(74) ---> Data Field: VA DRUG CLASS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(132) --> Data Field: CLOZAPINE MED (BOOLEAN)
 ;
 ;      Local Extrinsic Functions
 ;
 S OCXDF(131)=$P($P($G(OCXPSD),"|",3),"^",4) I $L(OCXDF(131)) S OCXDF(37)=$G(DFN) I $L(OCXDF(37)) S OCXDF(132)=$P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",1) D CHK368
 S OCXDF(43)=$P($P($G(OCXPSD),"|",3),"^",1) I $L(OCXDF(43)) S OCXDF(74)=$P($$ENVAC^PSJORUT2(OCXDF(43)),"^",2) I $L(OCXDF(74)) D CHK506^OCXOZ0F
 Q
 ;
CHK368 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK363+14.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK368 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(132) --> Data Field: CLOZAPINE MED (BOOLEAN)
 ; OCXDF(145) --> Data Field: CLOZAPINE WBC 3.0-3.5 TEXT (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,116, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE DRUG SELECTED)
 ; MSGTEXT( ---------> MESSAGE TEXT
 ;
 I $L(OCXDF(132)),(OCXDF(132)) S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXDF(145)=$$MSGTEXT("CLOZWBC30_35"),OCXOERR=$$FILE(DFN,116,"130,145") Q:OCXOERR 
 Q
 ;
CHK375 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK348+16^OCXOZ0B.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK375 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(145) --> Data Field: CLOZAPINE WBC 3.0-3.5 TEXT (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,117, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE NO ANC W/IN 7 DAYS)
 ; MSGTEXT( ---------> MESSAGE TEXT
 ;
 S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXDF(145)=$$MSGTEXT("CLOZWBC30_35"),OCXOERR=$$FILE(DFN,117,"130,145") Q:OCXOERR 
 Q
 ;
CHK380 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK348+17^OCXOZ0B.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK380 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(145) --> Data Field: CLOZAPINE WBC 3.0-3.5 TEXT (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,118, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE NO WBC W/IN 7 DAYS)
 ; MSGTEXT( ---------> MESSAGE TEXT
 ;
 S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXDF(145)=$$MSGTEXT("CLOZWBC30_35"),OCXOERR=$$FILE(DFN,118,"130,145") Q:OCXOERR 
 Q
 ;
CHK384 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK348+18^OCXOZ0B.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK384 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(139) --> Data Field: CLOZAPINE WBC W/IN 7 FLAG (BOOLEAN)
 ; OCXDF(140) --> Data Field: CLOZAPINE WBC W/IN 7 RESULT (NUMERIC)
 ;
 ;      Local Extrinsic Functions
 ;
 I (OCXDF(140)<"3.0") S OCXDF(139)=$P($P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",2),";",1) I $L(OCXDF(139)),(OCXDF(139)) D CHK388
 I (OCXDF(140)>2.999),(OCXDF(140)<3.5) S OCXDF(139)=$P($P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",2),";",1) I $L(OCXDF(139)),(OCXDF(139)) D CHK395^OCXOZ0D
 I (OCXDF(140)>3.499) S OCXDF(139)=$P($P($$CLOZLABS^ORKLR(OCXDF(37),7,OCXDF(131)),"^",2),";",1) I $L(OCXDF(139)),(OCXDF(139)) D CHK401^OCXOZ0D
 Q
 ;
CHK388 ; Look through the current environment for valid Event/Elements for this patient.
 ;  Called from CHK384+13.
 ;
 Q:$G(OCXOERR)
 ;
 ;    Local CHK388 Variables
 ; OCXDF(37) ---> Data Field: PATIENT IEN (NUMERIC)
 ; OCXDF(130) --> Data Field: CLOZAPINE LAB RESULTS (FREE TEXT)
 ; OCXDF(131) --> Data Field: PHARMACY LOCAL ID (FREE TEXT)
 ; OCXDF(145) --> Data Field: CLOZAPINE WBC 3.0-3.5 TEXT (FREE TEXT)
 ;
 ;      Local Extrinsic Functions
 ; FILE(DFN,119, ----> FILE DATA IN PATIENT ACTIVE DATA FILE  (Event/Element: CLOZAPINE WBC < 3.0)
 ; MSGTEXT( ---------> MESSAGE TEXT
 ;
 S OCXDF(130)=$P($$CLOZLABS^ORKLR(OCXDF(37),"",OCXDF(131)),"^",4),OCXDF(145)=$$MSGTEXT("CLOZWBC30_35"),OCXOERR=$$FILE(DFN,119,"130,145") Q:OCXOERR 
 Q
 ;
FILE(DFN,OCXELE,OCXDFL) ;     This Local Extrinsic Function logs a validated event/element.
 ;
 N OCXTIMN,OCXTIML,OCXTIMT1,OCXTIMT2,OCXDATA,OCXPC,OCXPC,OCXVAL,OCXSUB,OCXDFI
 S DFN=+$G(DFN),OCXELE=+$G(OCXELE)
 ;
 Q:'DFN 1 Q:'OCXELE 1 K OCXDATA
 ;
 S OCXDATA(DFN,OCXELE)=1
 F OCXPC=1:1:$L(OCXDFL,",") S OCXDFI=$P(OCXDFL,",",OCXPC) I OCXDFI D
 .S OCXVAL=$G(OCXDF(+OCXDFI)),OCXDATA(DFN,OCXELE,+OCXDFI)=OCXVAL
 ;
 M ^TMP("OCXCHK",$J,DFN)=OCXDATA(DFN)
 ;
 Q 0
 ;
MSGTEXT(ID)    ;  Compiler Function: MESSAGE TEXT
 ;
 N MSG
 S MSG=""
 ;
 I ID="AMITRIPTYLINE" D
 .S MSG="Amitriptyline can cause cognitive impairment and loss of"
 .S MSG=MSG_" balance in older patients. Consider other antidepressant"
 .S MSG=MSG_" medications on formulary."
 ;
 I ID="CHLORPROPAMIDE" D
 .S MSG="Older patients may experience hypoglycemia with"
 .S MSG=MSG_" Chlorpropamide due to its long duration and variable"
 .S MSG=MSG_" renal secretion. They may also be at increased risk for"
 .S MSG=MSG_" Chlorpropamide-induced SIADH."
 ;
 I ID="DIPYRIDAMOLE" D
 .S MSG="Older patients can experience adverse reactions at high doses"
 .S MSG=MSG_" of Dipyridamole (e.g., headache, dizziness, syncope, GI"
 .S MSG=MSG_" intolerance.) There is also questionable efficacy at"
 .S MSG=MSG_" lower doses."
 ;
 I ID="CLOZWBC30_35" D
 .S MSG="WBC between 3.0 and 3.5 with no ANC - pharmacy cannot fill"
 .S MSG=MSG_" clozapine order. Please order CBC/Diff with WBC and ANC"
 .S MSG=MSG_" immediately."
 ;
 Q MSG
 ;