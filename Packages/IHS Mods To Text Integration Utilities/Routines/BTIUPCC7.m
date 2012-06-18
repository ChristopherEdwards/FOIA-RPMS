BTIUPCC7 ; IHS/CIA/MGH - IHS PCC PERSONAL HEALTH OBJECTS ;28-Jan-2011 15:53;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1008**;NOV 04, 2004;Build 15
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
 ..S @TARGET@(CNT,0)=$G(ARRAY(I,J))
 Q "~@"_$NA(@TARGET)
LABRES(DFN,TIUTST,TIUCNT) ;EP; -- returns last # of current lab result for single
 ; TIUTST = lab test name;  TIUCNT = # of test results to return
 ;IHS/CIA/MGH Modified to only display the test name and results
 NEW LAB,CAPTION,VDT,IEN,X,TIU,LINE,CNT,DATA,LGTH,DATE,Y
 K ^TMP("BTIULO",$J)
 S LAB=$O(^LAB(60,"B",TIUTST,0)) I LAB="" Q ""
 S CAPTION=$E(TIUTST,1,30)_":"
 S (VDT,CNT)=0
 F  S VDT=$O(^AUPNVLAB("AA",DFN,LAB,VDT)) Q:('VDT)!(CNT=TIUCNT)  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) Q:'IEN!(CNT=TIUCNT)  D
 .. K TIU D ENP^XBDIQ1(9000010.09,IEN,".03:.05;1109;1201","TIU(")
 .. Q:TIU(.04)=""                       ;skip if not resulted
 .. S CNT=CNT+1                         ;increment counter
 .. S Y=$S(CNT=1:CAPTION,1:$$SP($L(CAPTION)))    ;either caption if first
 .. S LGTH=$L(TIU(.05)) ;PATCH 1003
 .. S ^TMP("BTIULO",$J,CNT,0)=Y_$J(TIU(.04),8)_" "_TIU(.05)
 ;
 I '$D(^TMP("BTIULO",$J)) S ^TMP("BTIULO",$J,1,0)=CAPTION_"No Results Found"
 Q "~@^TMP(""BTIULO"",$J)"
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
