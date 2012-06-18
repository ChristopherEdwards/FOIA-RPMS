BTIULO11 ;IHS/ITSC/LJF - IHS OBJECTS ADDED IN PATCHES;25-Sep-2009 10:40;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006**;NOV 04, 2004
 ;IHS/MSC/MGH line up number of labs and only display test name
 ;
NLAB(DFN,TIUTST,TIUCNT) ;EP; -- returns last # of current lab result for single test;PATCH 1001
 ; TIUTST = lab test name;  TIUCNT = # of test results to return
 ;IHS/CIA/MGH Modified to only display the test name
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
 .. S DATE=$S(TIU(1201)]"":TIU(1201),1:TIU(.03))
 .. S CNT=CNT+1                         ;increment counter
 .. S Y=$S(CNT=1:CAPTION,1:$$SP($L(CAPTION)))    ;either caption if first one or spaces to line up under first one
 .. S LGTH=$L(TIU(.05)) ;PATCH 1003
 .. S DATA="   "_DATE
 .. S ^TMP("BTIULO",$J,CNT,0)=Y_DATA
 ;
 I '$D(^TMP("BTIULO",$J)) S ^TMP("BTIULO",$J,1,0)=CAPTION_"No Results Found"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
ABORH(DFN) ; EP Get the blood type of patient
 N ABO,RH,LRDFN,DATA
 S LRDFN=$P($G(^DPT(DFN,"LR")),U,1)
 I LRDFN="" S DATA="No lab data on file"
 I LRDFN'="" D
 .S ABO=$P($G(^LR(LRDFN,0)),U,5)
 .S RH=$P($G(^LR(LRDFN,0)),U,6)
 .I ABO=""&(RH="") S DATA="No blood type on file"
 .E  S DATA="Blood Type: "_ABO_" "_RH
 Q DATA
