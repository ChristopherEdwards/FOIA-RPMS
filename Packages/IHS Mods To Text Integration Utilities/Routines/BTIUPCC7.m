BTIUPCC7 ; IHS/MSC/MGH - IHS PCC PERSONAL HEALTH OBJECTS ;13-Sep-2011 13:55;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1008,1009**;NOV 04, 2004;Build 22
 ;This routine creates objects for the personal health
 ;data entered
 ;==============================================================
CVD(DFN,TARGET) ;EP
 N ARRAY,CNT,I,J
 S CNT=1
 D PAT^BQITRPHS(DFN,.ARRAY)
 I $P(ARRAY(0),U,1)=1 S @TARGET@(CNT,0)=$P(ARRAY(0),U,2)
 E  S @TARGET@(CNT,0)="Patient does not have an iCare Diagnostic Tag of CVD"
 S I=0 F  S I=$O(ARRAY(I)) Q:I=""  D
 .S CNT=CNT+1 S @TARGET@(CNT,0)=""
 .S J=0 F  S J=$O(ARRAY(I,J)) Q:J=""  D
 ..S CNT=CNT+1
 ..S @TARGET@(CNT,0)=$G(ARRAY(I,J,0))
 Q "~@"_$NA(@TARGET)
LABRES(DFN,TIUTST,TIUCNT) ;EP; -- returns last # of current lab result for single
 ; TIUTST = lab test name;  TIUCNT = # of test results to return
 ;IHS/CIA/MGH Modified to only display the test name and results
 NEW LAB,CAPTION,VDT,DATE,IEN,X,TIU,LINE,CNT,DATA,LGTH,DATE,Y,ARR
 K ^TMP("BTIULOX",$J)
 S LAB=$O(^LAB(60,"B",TIUTST,0)) I LAB="" Q ""
 S CAPTION=$E(TIUTST,1,30)_":"
 S (VDT,CNT)=0
 F  S VDT=$O(^AUPNVLAB("AA",DFN,LAB,VDT)) Q:('VDT)!(CNT=TIUCNT)  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) Q:'IEN!(CNT=TIUCNT)  D
 .. K TIU D ENP^XBDIQ1(9000010.09,IEN,".03:.05;1109;1201","TIU(")
 .. Q:TIU(.04)=""                       ;skip if not resulted
 .. S CNT=CNT+1                         ;increment counter
 .. S DATE=$S(TIU(1201)]"":TIU(1201),1:TIU(.03))
 .. S ARR(DATE,IEN)=$J(TIU(.04),8)_" "_TIU(.05),CNT=CNT+1
 S CNT=0,DATE=""
 F  S DATE=$O(ARR(DATE),-1) Q:DATE=""!(CNT>=TIUCNT)  D
 . S IEN="" F  S IEN=$O(ARR(DATE,IEN),-1)  Q:'IEN!(CNT>=TIUCNT)  D
 . . S LINE=$G(ARR(DATE,IEN)),CNT=CNT+1
 . . S Y=$S(CNT=1:CAPTION,1:$$SP($L(CAPTION)))
 . . S ^TMP("BTIULOX",$J,CNT,0)=Y_LINE
 I '$D(^TMP("BTIULOX",$J)) S ^TMP("BTIULOX",$J,1,0)="No Results Found"
 Q "~@^TMP(""BTIULOX"",$J)"
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
PHISTORY(DFN,TARGET) ;Return personal history data
 N DATA,BTIU,IEN,FNUM,CNT,RESULT,DATE,LINE,NUM,ONSET,ENTRY
 S FNUM=9000013,CNT=0,ENTRY="",ONSET=""
 S IEN=0 F  S IEN=$O(^AUPNPH("AC",DFN,IEN)) Q:'IEN  D
 .S CNT=$G(CNT)+1,NUM=$G(NUM)+1
 .K BTIU D ENP^XBDIQ1(9000013,IEN,".01;.02:.07;","BTIU(","I")
 .S LINE=$J(NUM,2)_") "_$G(BTIU(.04))_" Noted: "_$G(BTIU(.03))
 .I $G(BTIU(.05))'="" S LINE=LINE_" Onset: "_$G(BTIU(.05))
 .S @TARGET@(CNT,0)=LINE
 I CNT=0 S @TARGET@(1,0)="No personal history on file"
 Q "~@"_$NA(@TARGET)
