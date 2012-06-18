BAREDLA1 ; IHS/SD/LSL - AR TOP LEVEL FILE STRUCTURE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 D CLEAR^VALM1
 ;
EN(DLFL) ;EP -- for the file type
 ;Called from BAREDLA1
 S FILE=DLFL
 D EN^VALM("BAR TOP LEVEL FILES")
 Q
 ; *********************************************************************
 ;
HDR ;EP -- header code
 S VALMSG=$$VALMSG^AMCOUT
 S VALMHDR(1)=$P($G(^BAREDI("1T",FILE,0)),"^")
 Q
 ; *********************************************************************
 ;
INIT ;EP -- init variables and list array
 D GATHER
 S VALMCNT=20
 Q
 ; *********************************************************************
 ;
HELP ;EP -- help code
 S X="?"
 D DISP^XQORM1
 D MSG^AMCOUT("",2,0,0)
 Q
 ; *********************************************************************
 ;
EXIT ;EP -- exit code
 D CLEAR^VALM1
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
GATHER ; -- SUBRTN to set data into array
 ;
 ;Created in BAREDLA1, specific to each FILE#
 ;S LST=$G(^TMP($J,"FILE"))
 ;
 ; List of Files to be accessed
 ;
 S FLST="0101^0103^0105^0107"
 S FLD="Segment^Data Types^Tables^Claim Level Reason Codes"
 K ^TMP($J,"LVL0")
 K LVL0
 S RECNM=0
 S (LN,COUNT)=1
 ;
 ;Get file details
 S (SFL,LNC)=1
 F  S SFL=$O(^BAREDI("1T",FILE,SFL)) Q:SFL=""  D
 . S CURRENT=0
 . S FLN=$P($G(^BAREDI("1T",FILE,SFL,0)),U,2)
 . F I=1:1:4 I FLN[($P(FLST,U,I)) S FD=$P(FLD,U,I),CURRENT=1
 . Q:'CURRENT
 . S LVL0($J,SFL,I)=FD
 . S ^TMP($J,"L0",LNC)=FLN_U_FD
 . S LNC=LNC+1
 ;
 S RN=""
 F  S RN=$O(LVL0($J,RN)) Q:RN=""  D
 . S (RECORD,DI)=""
 . F  S DI=$O(LVL0($J,RN,DI)) Q:DI=""  D
 ..S FLEN=40
 ..S FIELD=$G(LVL0($J,RN,DI))
 ..S RECORD=RECORD_$$PAD(FIELD,FLEN)
 .S ^TMP($J,"LVL0",LN,0)=$$PAD(LN,3)_RECORD
 .S ^TMP($J,"LVL0","IDX",LN,LN)=""
 .S LN=LN+1,COUNT=COUNT+1
 Q
 ; *********************************************************************
 ;
GETITEM ;
 ;
 K HDR
 S VALMLST=""
 S VALMLST=$O(^TMP($J,"LVL0","IDX",VALMLST),-1)
 D EN^VALM2(XQORNOD(0),"O")
 I '$D(VALMY) Q
 NEW X,Y
 S X=0
 F  S X=$O(VALMY(X)) Q:X=""  D
 . S HDR=$E($P($G(^TMP($J,"L0",X)),U),1,10)
 . S FD=$P($G(^TMP($J,"L0",X)),U,2)
 Q
 ; *********************************************************************
 ;
BROWSE ; Get specifc details for SEGMENTS, DATA TYPES etc.
 ;
 D GETITEM I '$D(HDR) Q
 D EN^BAREDL01(HDR,FD)
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
