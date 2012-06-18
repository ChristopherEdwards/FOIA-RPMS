AQAOCID ; IHS/ORDC/LJF - CREATE COMPUTED NUMBERS 4 FILES ; [ 09/01/1998  6:37 PM ]
 ;;1.01;QAI MANAGEMENT;**1**;OCT 05, 1995
 ;
 ;This rtn is a PRIVATE ENTRY POINT for computing the case ID
 ;number for an occurrence.  The entry is called using $$OCCID^AQAOCID.
 ;
OCCID() ;PEP;PRIVATE ENTRY POINT for EXTR VAR to create occurrence id number
 ;private published entry point: can only be called by AQAL pkg
 ;REQUIRED INPUT:   AQAOPAT=PATIENT DFN
 ;                  AQAODATE=OCCURRENCE DATE
 ;                  AQAOIND=INDICATOR
 ;
MONTH ; (1) MONTH OF OCCURRENCE (ALPHA A THROUGH L)
 S AQAOCID=$C($E(AQAODATE,4,5)+64)
 ;
DAY ; (2) DAY OF OCCURRENCE (ALPHA A THROUGH Z, 27=1,28=2,29=3,30=4,31=5) 
 S AQAODAY=$E(AQAODATE,6,7)
 S AQAOCID=AQAOCID_$S(AQAODAY>26:AQAODAY-26,1:$C(AQAODAY+64))
 ;
LNAME ; (3) LAST NAME (FIRST LETTER OF LAST NAME)
 S AQAONAM=$P($G(^DPT(AQAOPAT,0)),U) S:AQAONAM="" AQAONAM="Z"
 S AQAOCID=AQAOCID_$E(AQAONAM)
 ;
FUDGE ; (4-7) RANDOM 3-DIGIT NUMBER; THEN CHECK IF UNIQUE
 S X=AQAOCID_$R(9999) I $D(^AQAOC("B",X)) G FUDGE ;PATCH 1 w/ next line
 Q X
 ;
 ;
NEWAP() ;ENTRY POINT for EXTR VAR to create action plan number
 ;
 N %H,Y,X
 ;first get facility's abbreviation
 S AQAOAPN=$P($G(^AUTTLOC(DUZ(2),0)),U,2)_"QI",AQAOAPN=$E(AQAOAPN,1,4)
 ;Begin Y2K patch ;IHS/DIR/JLG 9/1/98
 ;S %H=$H D YMD^%DTC S Y=$E(X,2,3) I $E(X,4,5)>9 S Y=Y+1 ;fiscal year
 S Y=$E($$FISCAL^XBDT($H),3,4)            ;Y2000
 ;End Y2K patch   ;IHS/DIR/JLG
 S (X,Y,AQAOAPN)=AQAOAPN_Y_"1000"
 F  S X=$O(^AQAO(5,"B",X)) Q:X=""  Q:($E(X,5,6)>$E(AQAOAPN,5,6))  S Y=X
 S AQAOAPN=$E(AQAOAPN,1,6)_($E(Y,7,10)+1)
 I $L(AQAOAPN)'=10 S AQAOAPN=""
 Q AQAOAPN
