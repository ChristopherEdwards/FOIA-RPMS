BTIULO9 ;IHS/CIA/MGH - IHS OBJECTS ADDED IN PATCHES FOR BEHAVIORAL HEALTH;09-Feb-2006 15:15;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1003,1004**;NOV 04, 2004
 ;Patch 1004 added location of home
 ;
WORKPH(DFN) ; EP;--
 ;Get work phone number
 NEW WORK
 Q:'$G(DFN)
 S WORK=$$GET1^DIQ(2,DFN,.132) S:WORK]"" WORK="Work phone: "_WORK
 I WORK="" S WORK="No Phone in record"
 Q WORK
OTHERPH(DFN) ;EP;--
 ;Get entry in the OTHER PHONE field
 NEW OTHER
 Q:'$G(DFN)
 S OTHER=$$GET1^DIQ(9000001,DFN,1801) S:OTHER]"" OTHER="Other phone: "_OTHER
 I OTHER="" S OTHER="No other phone in record"
 Q OTHER
EMPLOYER(DFN) ; EP
 ;Enter the employer name
 N EMP
 Q:'$G(DFN)
 S EMP=$$GET1^DIQ(9000001,DFN,.19) S:EMP]"" EMP="Employer: "_EMP
 I EMP="" S EMP="No employer listed"
 Q EMP
EMPSTAT(DFN) ; EP
 ;Enter the employment status
 N EMPST
 Q:'$G(DFN)
 S EMPST=$$GET1^DIQ(9000001,DFN,.21) S:EMPST]"" EMPST="Employment Status: "_EMPST
 I EMPST="" S EMPST="No employment status listed"
 Q EMPST
LOFHOME(DFN,TARGET) ;EP
 ;Find the location of home from the IHS patient file
 N LOC,CNT,LINE
 S CNT=0
 S LOC=0 F  S LOC=$O(^AUPNPAT(DFN,12,LOC)) Q:LOC=""  D
 .S CNT=$G(CNT)+1
 .I CNT=1 S @TARGET@(1,0)="Location of home: " S CNT=2
 .S LINE=$G(^AUPNPAT(DFN,12,LOC,0))
 .S @TARGET@(CNT,0)=$$SP(5)_LINE
 I '$G(CNT) S @TARGET@(1,0)="No location of home defined"
 Q "~@"_$NA(@TARGET)
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
