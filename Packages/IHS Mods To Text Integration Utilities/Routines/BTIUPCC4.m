BTIUPCC4 ; IHS/CIA/MGH - IHS PCC INPT OBJECTS ;07-Jun-2010 14:23;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1004,1005,1006**;NOV 04, 2004
 ;Patch 1005 added measurment list object
 ;==================================================================
LSTMEAS(DFN,TIUMSR,VAIN) ; -- returns most current measurement (internal values)
 ;Designed to return most recent vital signs for inpatients
 NEW MSR,VDT,IEN,X,TIU,LINE,ARR,DATE,STOP,ISINP
 S MSR=$O(^AUTTMSR("B",TIUMSR,0)) I MSR="" Q ""
 ;
 ;Check whether patient is an inpatient or not
 I $G(VAIN(1)) D
 .S STOP=(9999999-$P(VAIN(7),U,1)\1)+1
 I 'STOP Q "Patient is not an inpatient"         ;none to be found
 S VDT=0
 F  S VDT=$O(^AUPNVMSR("AE",DFN,MSR,VDT)) Q:'VDT!(VDT>STOP)  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVMSR("AE",DFN,MSR,VDT,IEN)) Q:'IEN  D
 .. K TIU D ENP^XBDIQ1(9000010.01,IEN,".03;.04;1201;2","TIU(","I")
 .. ; value ^ visit ien ^ event date internal format
 .. Q:TIU(2,"I")=1    ;Quit if entered in error
 .. S LINE=$G(TIU(.04))_U_$G(TIU(.03,"I"))_U_$G(TIU(1201,"I"))
 .. S DATE=$S($G(TIU(1201,"I"))]"":TIU(1201,"I"),1:(9999999-$P(VDT,"."))_"."_$P(VDT,".",2))
 .. S ARR(DATE,IEN)=LINE
 ;
 I '$D(ARR)!($D(ARR)=0) S LINE="Not done while inpatient" Q LINE
 S DATE=$O(ARR(""),-1),IEN=$O(ARR(DATE,""),-1),LINE=ARR(DATE,IEN)
 K VAIN
 Q $G(LINE)
 ;
LSTDATE(DATE1,DATE2,YES) ;EP -- returns event date or visit date;PATCH 1002 fixed typo
 I 'YES Q ""  ;no date asked for
 ;
 ;IHS/ITSC/LJF 02/24/2005 PATCH 1002 add parens around dates
 ;I $G(DATE2) Q "  "_$$FMTE^XLFDT(DATE2)  ;event date
 ;Q "  "_$$GET1^DIQ(9000010,+DATE1,.01)  ;visit date from visit ien
 I $G(DATE2) Q "  ("_$$FMTE^XLFDT(DATE2)_")"  ;event date
 I 'DATE1 Q " "
 Q "  ("_$$GET1^DIQ(9000010,+DATE1,.01)_")"  ;visit date from visit ien
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
MEASLST(DFN,TARGET) ;EP Get last of each type of vital
 ;Use the system list from the BEHOENVM VITAL LIST parameter
 N ARRAY,MEAS,MITEM,MTYPE,CNT,TIUMSR
 S CNT=0
 D GETLST^XPAR(.ARRAY,"SYS","BEHOVM VITAL LIST","I")
 S MEAS="" F  S MEAS=$O(ARRAY(MEAS)) Q:MEAS=""  D
 .S MITEM=$G(ARRAY(MEAS))
 .Q:MITEM=""
 .S MTYPE=$P($G(^AUTTMSR(MITEM,0)),U,1)
 .I MTYPE'="" D
 ..S TIUMSR=$$LASTMSR^BTIUPCC1(DFN,MTYPE,1,1)
 ..I TIUMSR'="" D
 ...S CNT=CNT+1
 ...S @TARGET@(CNT,0)=TIUMSR
 I CNT=0 S @TARGET@(1,0)="No measurement data on file"
 Q "~@"_$NA(@TARGET)
