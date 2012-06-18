BVPTIU ; IHS/ITSC/LJF - CALLS TO TIU ;
 ;;1.0;VIEW PATIENT RECORD;;NOV 17, 2004
 ;
EN ;EP; generic action to enter TIU package
 NEW VALMY,Y
 D FULL^VALM1
 ;
 I '$D(^XUSEC("TIUZCWAD",DUZ)) D VIEW Q   ;go to view, if user can't access CWAD
 ;
 D MSG^BVPU($$SP(20)_"CLINICAL NOTES",2,0,0)
 S Y=$$READ^BVPU("SO^1:View/Edit Documents;2:CWAD Display","Choose Action")
 I Y=1 D VIEW Q
 I Y=2 D CWAD^TIULX Q
 Q
 ;
VIEW ; -- view and edit documents
 I '$D(^XUSEC("TIUZCLIN",DUZ)) D  ;if user not have access to TIU
 . NEW ORVP,TIUCHVW
 . S ORVP=DFN,TIUCHVW=1
 . D EN^VALM("TIU REVIEW SCREEN READ ONLY")
 E  S TIUZIHS=DFN D MAIN^BTIURPT
 K ^TMP("TIUR",$J),^TMP("TIURIDX",$J)
 K TIUF,TIUPRM0,TIUPRM1
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
