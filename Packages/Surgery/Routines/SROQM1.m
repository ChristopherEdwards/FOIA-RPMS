SROQM1 ;B'HAM ISC/ADM - QUARTERLY REPORT (CONTINUED) ; [ 10/23/97  6:42 AM ]
 ;;3.0; Surgery ;**38,62,70**;24 Jun 93
 ;
 ;** NOTICE: This routine is part of an implementation of a nationally
 ;**         controlled procedure.  Local modifications to this routine
 ;**         are prohibited.
 ;
NDEX ; index procedures
 D BLANK S SRBLANK="" F I=1:1:31 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"INDEX PROCEDURES" D LINE S SRLINE=SRBLANK_"----------------" D LINE
 F I=1:1:22 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"CASES WITH" D LINE S SRBLANK="" F I=1:1:29 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"CASES        DEATHS     OCCURRENCES" D LINE
 S SRLINE=SRBLANK_"-----        ------     -----------" D LINE
 F J=1:1:12 D IXUT
CC ; occurrence categories
 D BLANK S SRBLANK="" F I=1:1:21 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"PERIOPERATIVE OCCURRENCE CATEGORIES" D LINE S SRLINE=SRBLANK_"-----------------------------------" D LINE
WC D BLANK S SRLINE=" Wound Occurrences            Total      Urinary Occurrences          Total" D LINE
 S SRLINE=" A. Superficial Infection     "_$J(SRC(1),5)_"      A. Renal Insufficiency       "_$J(SRC(8),5) D LINE
 S SRLINE=" B. Deep Wound Infection      "_$J(SRC(2),5)_"      B. Acute Renal Failure       "_$J(SRC(9),5) D LINE
 S SRLINE=" C. Wound Disruption          "_$J(SRC(22),5)_"      C. Urinary Tract Infection   "_$J(SRC(10),5) D LINE F I=1:1:20 S SRBLANK=SRBLANK_" "
 S SRLINE=SRBLANK_"D. Other                     "_$J(SRC(31),5) D LINE,BLANK
RC S SRLINE=" Respiratory Occurrences      Total      CNS Occurrences              Total" D LINE
 S SRLINE=" A. Pneumonia                 "_$J(SRC(4),5)_"      A. CVA/Stroke                "_$J((SRC(12)+SRC(28)),5) D LINE
 S SRLINE=" B. Unplanned Intubation      "_$J((SRC(7)+SRC(11)),5)_"      B. Coma >24 Hours            "_$J(SRC(13),5) D LINE
 S SRLINE=" C. Pulmonary Embolism        "_$J(SRC(5),5)_"      C. Peripheral Nerve Injury   "_$J(SRC(14),5) D LINE
 S SRLINE=" D. On Ventilator >48 Hours   "_$J(SRC(6),5)_"      D. Other                     "_$J(SRC(30),5) D LINE
 S SRLINE=" E. Other                     "_$J(SRC(29),5) D LINE
CARD D BLANK S SRLINE=" Cardiac Occurrences          Total      Other Occurrences            Total" D LINE
 S SRLINE=" A. Cardiac Arrest Req. CPR   "_$J(SRC(16),5)_"      A. Ileus/Bowel Obstruction   "_$J(SRC(18),5) D LINE
 S SRLINE=" B. Myocardial Infarction     "_$J(SRC(17),5)_"      B. Bleeding/Transfusions     "_$J(SRC(15),5) D LINE
 S SRLINE=" C. Endocarditis              "_$J(SRC(23),5)_"      C. Graft/Prosthesis/Flap" D LINE
 S SRLINE=" D. Low Cardiac Output >6 Hrs."_$J(SRC(24),5)_"                          Failure  "_$J(SRC(19),5) D LINE
 S SRLINE=" E. Mediastinitis             "_$J(SRC(25),5)_"      D. DVT/Thrombophlebitis      "_$J(SRC(20),5) D LINE
 S SRLINE=" F. Repeat Card-Pul Bypass    "_$J(SRC(27),5)_"      E. Systemic Sepsis           "_$J(SRC(3),5) D LINE
 S SRLINE=" G. Other                     "_$J(SRC(32),5)_"      F. Reoperation for Bleeding  "_$J(SRC(26),5) D LINE
 S SRLINE=SRBLANK_"G. Other                     "_$J(SRC(21),5) D LINE,BLANK
 S:'SRWC SRWC=1 S SRLINE=" Clean Wound Infection Rate: "_$J((SRIN/SRWC*100),5,1)_"%" D LINE
 Q
IXUT ; get index procedure data from ^TMP
 F K=1:1:3 S SRP(K)=$P(^TMP("SRPROC",$J,J),"^",K)
 D IXOUT^SROQ0A D
 .I SROP["," D  S SROP=$P(SROP,",",2)
 ..I J=7 S SRLINE="    "_$P(SROP,",") D LINE
 .S SRLINE="    "_SROP S SRBLANK="" F I=1:1:(28-$L(SRLINE)) S SRBLANK=SRBLANK_" "
 S SRLINE=SRLINE_SRBLANK_$J(SRP(1),6)_"       "_$J(SRP(3),6)_"       "_$J(SRP(2),6) D LINE
 Q
BLANK ; blank line
 S ^TMP("SRMSG",$J,SRCNT)="",SRCNT=SRCNT+1
 Q
LINE ; store line in ^TMP
 S ^TMP("SRMSG",$J,SRCNT)=SRLINE,SRCNT=SRCNT+1
 Q
