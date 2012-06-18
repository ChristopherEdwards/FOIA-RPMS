BWGRVLU2 ; IHS/CMI/LAB - GEN RETR UTILITIES - CON'T ;03-Sep-2003 20:09;PLS
 ;;2.0;WOMEN'S HEALTH;**9**;SEP 02, 2003
 ; Print Notifications Types that contain the TXT value in their name
 ; VIEN = Represents either Patient or Procedure IEN dependent upon report context
 ; TXT = Notification Type must contain this text if present
 ; PRM = 0= just time, 1=time and date, 2=time, date, and type
NOTIFP(VIEN,TXT,PRM) ;
 N NIEN,XRF,LP
 S TXT=$G(TXT,""),PRM=$G(PRM,0)
 I BWGRPTVS="P" D
 .; Process patient
 .S XRF="B"
 .S LP=VIEN
 E  D
 .; Process procedure
 .S XRF="C"
 .S LP=$$GET1^DIQ(9002086.1,VIEN,.01,"I")
 S NIEN=0 F  S NIEN=$O(^BWNOT(XRF,LP,NIEN)) Q:NIEN=""  D
 .D ADDNOTIF(NIEN,TXT,PRM)
 Q
ADDNOTIF(NIEN,TXT,PRM) ; Add notification to array
 N NTYP,VAL
 S NTYP=$$GET1^DIQ(9002086.4,NIEN,.03,"E")
 ; Check to see if notification types have been restricted
 Q:($L(TXT)&(NTYP'[TXT))
 S VAL=$$GET1^DIQ(9002086.4,NIEN,.15,"I")
 S:PRM>0 VAL=VAL_"  "_$$FMTE^XLFDT($$GET1^DIQ(9002086.4,NIEN,.02,"I"),"5ZD")
 S:PRM>1 VAL=VAL_"  "_NTYP
 S BWGRPCNT=$G(BWGRPCNT)+1,BWGRPRNM(BWGRPCNT)=VAL
 Q
 ; Time Required Notification Screen
 ; VIEN = Represents either Patient or Procedure IEN dependent upon report context
 ; TXT = Notification Type must contain this text if present
 ;
NOTIFS(VIEN,TXT) ;
 N NIEN,XRF,LP,TM,RVAL1,RVAL2
 S TXT=$G(TXT,"")
 I BWGRPTVS="P" D
 .; Process patient
 .S XRF="B"
 .S LP=VIEN
 E  D
 .; Process procedure
 .S XRF="C"
 .S LP=$$GET1^DIQ(9002086.1,VIEN,.01,"I")
 S NIEN=0 F  S NIEN=$O(^BWNOT(XRF,LP,NIEN)) Q:NIEN=""  D
 .S RVAL1=$P(^BWGRTRPT(BWGRRPT,11,BWGRI,11,1,0),U),RVAL2=$P(^(0),U,2)
 .S TM=$$GET1^DIQ(9002086.4,NIEN,.15,"I")
 .Q:RVAL1>TM!(X>RVAL2)
 .S X(RVAL1)=""
 Q
 ; Notification Screen
 ; Populate X array with Notifications matching selected screen type
 ; Input: SCNTYP = Screen Type
 ;                   "P"= Purpose
 ;                   "T"= Type
 ;                   "S"= Status
 ;                   "N" = Notification IEN array
NOTIFSCN(SCNTYP) ;
 N BWNIEN,BWNTYP,BWNDT,BWNPURP,BWNOUT,BWNBDT,BWNEDT,BWNSTAT,NODE0
 Q:$L($G(SCNTYP))<1
 S BWNBDT=$G(BWGRBD,0)
 S BWNEDT=$G(BWGRED,9999999)
 S BWNIEN=0
 F  S BWNIEN=$O(^BWNOT("B",DFN,BWNIEN)) Q:'BWNIEN  D
 .S NODE0=^BWNOT(BWNIEN,0)
 .S BWNTYP=$P(NODE0,U,3)
 .S BWNDT=$P(NODE0,U,2)
 .S BWNPURP=$P(NODE0,U,4)
 .S BWNOUT=$P(NODE0,U,5)
 .S BWNSTAT=$P(NODE0,U,14)
 .; Compare notification date with date range
 .Q:BWNDT<BWNBDT!(BWNDT>BWNEDT)
 .I SCNTYP="T" D
 ..S:BWNTYP X(BWNTYP)=""
 .E  I SCNTYP="P" D
 ..S:BWNPURP X(BWNPURP)=""
 .E  I SCNTYP="O" D
 ..S:BWNOUT X(BWNOUT)=""
 .E  I SCNTYP="S" D
 ..S:$L(BWNSTAT) X(BWNSTAT)=""
 .E  I SCNTYP="N" D
 ..S X(BWNIEN)=""
 Q
 ; Build Print array for Notification Types/Purposes
NOTIFPTP(SCNTYP) ;
 N X,BWNIEN,VAL,BWNDTE,FLD
 S SCNTYP=$G(SCNTYP)
 S FLD=$S(SCNTYP="P":.04,SCNTYP="T":.03,SCNTYP="O":.05,SCNTYP="S":.14,1:"")
 Q:'FLD
 D NOTIFSCN("N")
 S BWNIEN=0 F  S BWNIEN=$O(X(BWNIEN)) Q:'BWNIEN  D
 .S BWNDTE=$$FMTE^XLFDT($$GET1^DIQ(9002086.4,BWNIEN,.02,"I"),"5Z")
 .S VAL=$E($$GET1^DIQ(9002086.4,BWNIEN,FLD),1,20)
 .S:SCNTYP'="S" VAL=$S('$L(VAL):"??",1:VAL)_" on "_BWNDTE
 .S BWGRPCNT=$G(BWGRPCNT)+1,BWGRPRNM(BWGRPCNT)=VAL
 Q
