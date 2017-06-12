BTIULO11 ;IHS/ITSC/LJF - IHS OBJECTS ADDED IN PATCHES;26-Mar-2014 17:11;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006,1012,1013**;NOV 04, 2004;Build 33
 ;IHS/MSC/MGH line up number of labs and only display test name
 ;
NLAB(DFN,TIUTST,TIUCNT) ;EP; -- returns last # of current lab result for single test;PATCH 1001
 ; TIUTST = lab test name;  TIUCNT = # of test results to return
 ;IHS/CIA/MGH Modified to only display the test name
 NEW LAB,ARR,CAPTION,VDT,IEN,X,TIU,LINE,CNT,DATA,LGTH,DATE,Y
 K ^TMP("BTIULO",$J)
 S LAB=$O(^LAB(60,"B",TIUTST,0)) I LAB="" Q ""
 S CAPTION=$E(TIUTST,1,30)_":"
 S (VDT,CNT)=0
 F  S VDT=$O(^AUPNVLAB("AA",DFN,LAB,VDT)) Q:('VDT)!(CNT>100)  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) Q:'IEN!(CNT>100)  D
 .. K TIU D ENP^XBDIQ1(9000010.09,IEN,".03:.05;1109;1201","TIU(")
 .. Q:TIU(.04)=""                       ;skip if not resulted
 .. S DATE=$S(TIU(1201)]"":TIU(1201),1:TIU(.03))
 .. S CNT=CNT+1                         ;increment counter
 .. S DATA="   "_DATE
 .. S ARR(DATE,IEN)=$J(TIU(.04),8)_"  "_TIU(.05)
 S CNT=0,DATE=""
 ;IHS/MSC/MGH patch 1006 change to check for CNT inside a date
 F  S DATE=$O(ARR(DATE),-1) Q:DATE=""!(CNT=TIUCNT)  D
 .S IEN="" F  S IEN=$O(ARR(DATE,IEN),-1)  Q:'IEN!(CNT=TIUCNT)  D
 .. S LINE=$G(ARR(DATE,IEN)),CNT=CNT+1
 .. S Y=$S(CNT=1:CAPTION,1:$$SP($L(CAPTION)))
 .. S ^TMP("BTIULO",$J,CNT,0)=Y_LINE ;
 I '$D(^TMP("BTIULO",$J)) S ^TMP("BTIULO",$J,1,0)="No Results Found"
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
CLIA(DFN,TIUTST,TIUCNT) ;EP; -- returns last # of current lab result for single test
 ; TIUTST = lab test name;  TIUCNT = # of test results to return
 ; Returns CLIA data for each lab
 NEW LAB,CAPTION,VDT,IEN,X,TIU,LINE,CNT,DATA,LGTH,ARR,DATE,DATE2,LCNT,ERR,UNIT
 N LO,HI,SPEC,PRV,VDATE,RESDT,RES,IEN2,COMM,COMM2,COMM3
 K ^TMP("BTIULO",$J)
 S TIUCNT=$G(TIUCNT)
 S LAB=$O(^LAB(60,"B",TIUTST,0)) I LAB="" Q ""
 S CAPTION="Last "_TIUCNT_" "_$E(TIUTST,1,30)_": "
 S (VDT,CNT)=0
 F  S VDT=$O(^AUPNVLAB("AA",DFN,LAB,VDT)) Q:('VDT)!(CNT=TIUCNT)  D
 . S IEN=0
 . F  S IEN=$O(^AUPNVLAB("AA",DFN,LAB,VDT,IEN)) Q:'IEN!(CNT=TIUCNT)  D
 .. K TIU    ;D ENP^XBDIQ1(9000010.09,IEN,".03:.05;1109;1201","TIU(")
 .. D GETS^DIQ(9000010.09,IEN_",","**","IE","TIU(","ERR")
 .. S IEN2=IEN_","
 .. S RES=$G(TIU(9000010.09,IEN2,.04,"E"))
 .. Q:RES=""                       ;skip if not resulted
 .. S DATE=TIU(9000010.09,IEN2,1201,"I")
 .. S VDATE=TIU(9000010.09,IEN2,.03,"I")
 .. S DATE2=$S(DATE]"":TIU(9000010.09,IEN2,1201,"E"),1:TIU(900010.09,IEN2,.03,"E"))
 .. S ABN=$G(TIU(9000010.09,IEN2,.05,"E"))
 .. S UNIT=$G(TIU(9000010.09,IEN2,1101,"E"))
 .. S LO=$G(TIU(9000010.09,IEN2,1104,"E"))
 .. S HI=$G(TIU(9000010.09,IEN2,1105,"E"))
 .. S SPEC=$G(TIU(9000010.09,IEN2,1103,"E"))
 .. S PRV=$G(TIU(9000010.09,IEN2,1202,"E"))
 .. S RESDT=$G(TIU(9000010.09,IEN2,1212,"E"))
 .. S COMM=$G(TIU(9000010.09,IEN2,1301,"E"))
 .. S COMM2=$G(TIU(9000010.09,IEN2,1302,"E"))
 .. S COMM3=$G(TIU(9000010.09,IEN2,1303,"E"))
 .. S CNT=CNT+1                         ;increment counter
 .. S LGTH=$L($G(TIU(9000010.09,IEN2,.05))) ;PATCH 1003
 .. S ARR(DATE,IEN)=RES_" "_UNIT_" "_ABN_U_DATE2_U_LO_U_HI_U_SPEC_U_RESDT_U_COMM_U_COMM2_U_COMM3_U_PRV
 S CNT=0,LCNT=0,DATE=""
 ;IHS/MSC/MGH patch 1006 and 1010 change to check for CNT inside a date
 N VFILENUM,ARRAY,ABN,PATIENT
 S PATIENT=$$GET1^DIQ(2,DFN,.01)
 F  S DATE=$O(ARR(DATE),-1) Q:DATE=""!(CNT>=TIUCNT)  D
 . S IEN="" F  S IEN=$O(ARR(DATE,IEN))  Q:'IEN!(CNT>=TIUCNT)  D
 .. S LINE=$G(ARR(DATE,IEN)),CNT=CNT+1,LCNT=LCNT+1
 .. S Y=$S(CNT=1:CAPTION,1:$$SP($L(CAPTION)))
 .. S ^TMP("BTIULO",$J,LCNT,0)=Y_"Result: "_$P(LINE,U,1)
 .. I $P(LINE,U,3)'=""!($P(LINE,U,4)'=1)  D
 ... S LCNT=LCNT+1
 ... S ^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Ref Range LO: "_$P(LINE,U,3)_" HI: "_$P(LINE,U,4)
 .. I $P(LINE,U,5)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Specimen: "_$P(LINE,U,5)
 .. I $P(LINE,U,2)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Collection Date: "_$P(LINE,U,2)
 .. I $P(LINE,U,6)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Result Date: "_$P(LINE,U,6)
 .. S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Patient: "_PATIENT
 .. I $P(LINE,U,10)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Orderer: "_$P(LINE,U,10)
 .. I $P(LINE,U,7)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_($P(LINE,U,7))
 .. I $P(LINE,U,8)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_$P(LINE,U,8)
 .. I $P(LINE,U,9)'="" S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_$P(LINE,U,9)
 .. ;Do new comments 1013
 ..I $D(^AUPNVLAB(IEN,21))>1 D
 ..S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"COMMENTS:"
 .. S X=0 F  S X=$O(^AUPNVLAB(IEN,21,X)) Q:'+X  D
 ...S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_$G(^AUPNVLAB(IEN,21,X,0))
 .. S X="BLRREFLA" X ^%ZOSF("TEST") I $T D
 ... S VFILENUM=9000010.09
 ... D PCCRLADR^BLRREFLA(VFILENUM,IEN,.ARRAY)
 ... S LCNT=LCNT+1
 ... S ^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Source: "_ARRAY("NAME")
 ... S LCNT=LCNT+1
 ... S ^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_"Addr: "_ARRAY("ST1")
 ... S LCNT=LCNT+1
 ... S ^TMP("BTIULO",$J,LCNT,0)=$$SP($L(CAPTION))_ARRAY("CITY")_", "_ARRAY("STATE")_" "_ARRAY("ZIP")
 ..S LCNT=LCNT+1,^TMP("BTIULO",$J,LCNT,0)=""
 I '$D(^TMP("BTIULO",$J)) S ^TMP("BTIULO",$J,1,0)=CAPTION_"No Results Found"
 Q "~@^TMP(""BTIULO"",$J)"
 ;
