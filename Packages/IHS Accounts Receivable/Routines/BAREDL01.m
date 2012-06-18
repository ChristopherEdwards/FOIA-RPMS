BAREDL01 ; IHS/SD/LSL - AR TOP LEVEL FILE STRUCTURE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 D CLEAR^VALM1
 ;
EN(FLNM,FD) ;EP
 ; -- for the file type
 ;Called from BAREDLA1
 K ^TMP($J,"LVL1")
 S FLNUM=FLNM
 D EN^VALM("BAR "_FD)
 Q
 ; *********************************************************************
 ;
HDR ;EP -- header code
 S VALMSG=$$VALMSG^AMCOUT
 S VALMHDR(1)=$P($G(^BAREDI("1T",FILE,0)),"^")
 S VALMHDR(2)=FD
 Q
 ; *********************************************************************
 ;
INIT ;EP -- init variables and list array
 D GATHER(FLNUM)
 S VALMCNT=35
 Q
 ; *********************************************************************
 ;
HELP ;EP -- help code
 S X="?"
 D DISP^XQORM1,MSG^AMCOUT("",2,0,0)
 Q
 ; *********************************************************************
 ;
EXIT ;EP -- exit code
 D CLEAR^VALM1
 K ^TMP($J,"LVL1")
 Q
 ; *********************************************************************
 ;
EXPND ;EP -- expand code
 Q
 ; *********************************************************************
 ;
RESET ;EP; -- rebuilds array after action
 D TERM^VALM0
 S VALMBCK="R"
 D INIT,HDR
 Q
 ; *********************************************************************
 ;
GATHER(FLNUM) ; -- SUBRTN to set data into array
 ;
 ;Created in BAREDLA1, specific to each FILE#
 ;For testing
 S LST=".01;.03"
 ;
 K ^TMP($J,"FD"),^TMP($J,"FL")
 K ^TMP($J,"LVL1"),^TMP($J,"LVL2")
 K SEG
 S ARSUB="1,1,0"
 S RECNM=0
 S (LN,COUNT)=1
 ;
 ;
 ;Get file details
 D ENPM^XBDIQ1(FLNUM,ARSUB,LST,"SEG($J,")
 ;
 S RN=""
 F  S RN=$O(SEG($J,RN)) Q:RN=""  D
 . S (RECORD,DI)=""
 . F  S DI=$O(SEG($J,RN,DI)) Q:DI=""  D
 ..S FLEN=25
 . .S FIELD=$G(SEG($J,RN,DI))
 ..I $L(FIELD)<15 S FLEN=15
 .. S RECORD=RECORD_$$PAD(FIELD,FLEN)
 .S ^TMP($J,"FD",LN)=RECORD
 .S ^TMP($J,"LVL1",LN,0)=$$PAD(LN,3)_RECORD
 .S ^TMP($J,"LVL1","IDX",LN,LN)=""
 .S LN=LN+1,COUNT=COUNT+1
 Q
 ; *********************************************************************
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ; *********************************************************************
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
