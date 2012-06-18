BARED0Z ; IHS/SD/LSL - AR TOP LEVEL FILE STRUCTURE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 D CLEAR^VALM1
EN ;Entry point
 ;
 W #
 S Y=$$SELTRAN^BAREDI01
 Q:Y'>0
 ;
 S DLFL=Y
 ;
 D ENTRY(DLFL)
 Q
 ; *********************************************************************
 ;
ENTRY(DLFL) ;Entry point for the file type
 S FILE=DLFL
 D EN^VALM("BAR ERA Maintenance")
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
 S X="?" D DISP^XQORM1,MSG^AMCOUT("",2,0,0)
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
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR
 Q
 ; *********************************************************************
 ;
GATHER ; -- SUBRTN to set data into array
 ;
 ; List of Routines to be accessed
 ;
 S DL="/"
 S FLST="EDTSEG^BAREDI01/EDTELEM^BAREDI01/EDTTAB^BAREDI01/"
 S FLST=FLST_"EDTCLAIM^BAREDI01/EDTDATA^BAREDI01/VIEWR^XBLM(""PRTVARS^BAREDIUT(FILE)"")"
 S FLD="Add/Edit Segment^Add/Edit Elements^Add/Edit Tables^Add/Edit Claim Level Reason Codes^Add/Edit Data Types^Reports"
 K ^TMP($J,"LVL0")
 K LVL0
 S RECNM=0
 S (LN,COUNT)=1
 ;
 ;Get file details
 S (SFL,LNC)=1
 F I=1:1:6 D
 . S FD=$P(FLD,U,I)
 . S LVL0($J,I)=FD
 . S ^TMP($J,"L0",LNC)=I_U_FD
 . S LNC=LNC+1
 ;
 S RN=""
 F  S RN=$O(LVL0($J,RN)) Q:RN=""  D
 . S (RECORD,DI)=""
 .S FLEN=40
 .S FIELD=$G(LVL0($J,RN))
 .S RECORD=$$PAD(FIELD,FLEN)
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
 N X,Y
 S X=0
 F  S X=$O(VALMY(X)) Q:X=""  D
 . S HDR=$P($G(^TMP($J,"L0",X)),U,2)
 . S FN=$P($G(^TMP($J,"L0",X)),U,1)
 . S OPT=$P(FLST,DL,FN)
 Q
 ; *********************************************************************
 ;
BROWSE ; Get specifc details for SEGMENTS, DATA TYPES etc.
 ;
 D GETITEM I '$D(HDR) Q
 D @OPT
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
