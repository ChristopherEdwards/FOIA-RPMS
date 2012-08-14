SROQM0 ;B'HAM ISC/ADM - QUARTERLY REPORT (CONTINUED) ; [ 08/07/00  11:47 AM ]
 ;;3.0; Surgery ;**38,62,50,95**;24 Jun 93
 ;
 ;** NOTICE: This routine is part of an implementation of a nationally
 ;**         controlled procedure.  Local modifications to this routine
 ;**         are prohibited.
 ;
TOT D BLANK S SRBLANK="" F I=1:1:34 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"Total Cases         % of Total" D LINE
 S SRLINE=SRBLANK_"-----------         ----------" D LINE
 S SRLINE="    Surgical Cases" F I=1:1:18 S SRLINE=SRLINE_" "
 S SRBLANK="" F I=1:1:15 S SRBLANK=SRBLANK_" "
SC S SRLINE=SRLINE_$J(SRCASES,6) S:SRCASES SRLINE=SRLINE_SRBLANK_"100.0" D LINE S SRALL=SRCASES I 'SRALL S SRALL=1
 S SRLINE="    Major Procedures" F I=1:1:16 S SRLINE=SRLINE_" "
MP S SRLINE=SRLINE_$J(SRMAJOR,6)_SRBLANK_$J(((SRMAJOR/SRALL)*100),5,1) S SRMAJ=SRMAJOR S:'SRMAJOR SRMAJ=1 D LINE
ASA F I=1:1:6 S SRLINE="        ASA Class ("_I_")               "_$J(SRASA(I),6)_SRBLANK_$J(((SRASA(I)/SRMAJ)*100),5,1) D LINE
 I SRASA(7) S SRLINE="        ASA Class (Not Entered)     "_$J(SRASA(7),6)_SRBLANK_$J(((SRASA(7)/SRMAJ)*100),5,1) D LINE
POD S SRLINE="    Postoperative Deaths            "_$J(SRMORT,6)_SRBLANK_$J(((SRMORT/SRALL)*100),5,1) D LINE
 S SRLINE="        Ambulatory: "_SROPD D LINE
POC S SRLINE="    Postoperative Occurrences       "_$J(SRCOMP,6)_SRBLANK_$J(((SRCOMP/SRALL)*100),5,1) D LINE
AP S SRLINE="    Ambulatory Procedures           "_$J((SRCASES-SRINPAT),6)_SRBLANK_$J((((SRCASES-SRINPAT)/SRALL)*100),5,1) D LINE
 S SRLINE="        Admitted Within 14 Days: "_SRADMT D LINE
 S SRLINE="        Invasive Diagnostic: "_SRINV("O") D LINE
IP S SRLINE="    Inpatient Procedures            "_$J(SRINPAT,6)_SRBLANK_$J(((SRINPAT/SRALL)*100),5,1) D LINE
EP S SRLINE="    Emergency Procedures            "_$J(SREMERG,6)_SRBLANK_$J(((SREMERG/SRALL)*100),5,1) D LINE
A60 S SRLINE="    Age>60 Years                    "_$J(SR60,6)_SRBLANK_$J(((SR60/SRALL)*100),5,1) D LINE
SP D BLANK S SRBLANK="" F I=1:1:29 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"SPECIALTY PROCEDURES" D LINE S SRLINE=SRBLANK_"--------------------" D LINE
 S SRLINE=SRBLANK_SRBLANK_"       ---DEATHS---" D LINE S SRBLANK="" F I=1:1:26 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"PATIENTS   CASES    MAJOR    MINOR     TOTAL    %" D LINE
 S SRLINE=SRBLANK_"--------   -----    -----    -----     -----   ----" D LINE
SRSS S SRPTF=50,SRSP="GENERAL" D SPOUT
 S SRPTF=51,SRSP="GYNECOLOGY" D SPOUT
 S SRPTF=52,SRSP="NEUROSURGERY" D SPOUT
 S SRPTF=53,SRSP="OPHTHALMOLOGY" D SPOUT
 S SRPTF=54,SRSP="ORTHOPEDICS" D SPOUT
 S SRPTF=55,SRSP="OTORHINOLARYNGOLOGY" D SPOUT
 S SRPTF=56,SRSP="PLASTIC SURGERY" D SPOUT
 S SRPTF=57,SRSP="PROCTOLOGY" D SPOUT
 S SRPTF=58,SRSP="THORACIC SURGERY" D SPOUT
 S SRPTF=59,SRSP="UROLOGY" D SPOUT
 S SRPTF=60,SRSP="ORAL SURGERY" D SPOUT
 S SRPTF=61,SRSP="PODIATRY" D SPOUT
 S SRPTF=62,SRSP="PERIPHERAL VASCULAR" D SPOUT
 S SRPTF=500,SRSP="CARDIAC SURGERY" D SPOUT
 S SRPTF=501,SRSP="TRANSPLANTATION" D SPOUT
 S SRPTF=502,SRSP="ANESTHESIOLOGY" D SPOUT
 I +^TMP("SRSS",$J,"ZZ") S SRPTF="ZZ",SRSP="NO SPECIALTY ENTERED" D SPOUT
RES ; resident supervision
 D BLANK S SRBLANK="" F I=1:1:23 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"LEVEL OF RESIDENT SUPERVISION (%)" D LINE
 S SRLINE=SRBLANK_"---------------------------------" D LINE
 S SRLINE=SRBLANK_"                  MAJOR     MINOR" D LINE
 S SRIX=SRCASES-SRMAJOR,SRMAJ=SRMAJOR S:'SRIX SRIX=1 S:'SRMAJ SRMAJ=1 F J=0:1:3 S SRLINE=SRBLANK_"Level "_J_"           "_$J(((SRATT("J",J)/SRMAJ)*100),5,1)_"     "_$J(((SRATT("N",J)/SRIX)*100),5,1) D LINE
 I SRATT("J",4)!SRATT("N",4) S SRLINE=SRBLANK_"Level Not Entered "_$J(((SRATT("J",4)/SRMAJ)*100),5,1)_"     "_$J(((SRATT("N",4)/SRIX)*100),5,1) D LINE
 F I=1:1 D BLANK Q:SRCNT>65
 Q
SPOUT ; get specialty data from ^TMP
 F K=1:1:5 S SRP(K)=$P(^TMP("SRSS",$J,SRPTF),"^",K)
 S:SRPTF="ZZ" SRPTF="" S SRLINE=$J(SRPTF,3)_"   "_SRSP,SRBLANK="" F I=1:1:(26-$L(SRLINE)) S SRBLANK=SRBLANK_" "
 S SRLINE=SRLINE_SRBLANK_$J(SRP(1),6)_"    "_$J(SRP(2),6)_"   "_$J(SRP(3),6)_"   "_$J(SRP(4),6)_"   "_$J(SRP(5),6)_"   "_$J(((SRP(5)/$S(SRP(2):SRP(2),1:1))*100),5,1) D LINE
 Q
BLANK ; blank line
 S ^TMP("SRMSG",$J,SRCNT)="",SRCNT=SRCNT+1
 Q
LINE ; store line in ^TMP
 S ^TMP("SRMSG",$J,SRCNT)=SRLINE,SRCNT=SRCNT+1
 Q