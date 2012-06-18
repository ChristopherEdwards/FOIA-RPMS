BAREDL02 ; IHS/SD/LSL - AR DOWNLOAD FILE LIST ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;
 ;;
 D CLEAR^VALM1
EN ;EP -- main entry point list template
 D EN^VALM("BAR DWLD FILE LIST")
 Q
 ; *********************************************************************
 ;
HDR ;EP -- header code
 S VALMSG=$$VALMSG^AMCOUT
 S VALMHDR(1)=$P($G(^BAREDI("1T",FLNUM,0)),"^")
 Q
 ; *********************************************************************
 ;
INIT ;EP -- init variables and list array
 S VALMCNT=40
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
 Q
 ; *********************************************************************
 ;
EXPND ;EP -- expand code
 Q
 ; *********************************************************************
 ;
RESET ;EP; -- code to rebuild array after action
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0
 S VALMBCK="R"
 D INIT,HDR
 Q
 ; *********************************************************************
 ;
GATHER(SUBF) ; -- SUBRTN to set data into array
 ;
 ; FILE - file (eg.Med 835)
 ; SUBF - sub file (eg.Payor Information)
 ;
 S FLST=".01;.02;.03;.04;.05;.06;.07"
 S FL06="90056.0106"
 S FL02="90056.0102"
 S FL=$S(FLNUM="90056.0101":FL02,FLNUM="90056.0105":FL06,1:"")
 I FL="" D NODATA Q
 S PAD(.01)=9
 S PAD(.02)=33
 S PAD(.03)=5
 S PAD(.04)=8
 S PAD(.05)=4
 S PAD(.06)=4
 S PAD(.07)=12
 S LN=0
 S D2=0
 S RECN=""
 S SPACE=" "
 S BAREDL("A")="FILE,SUBF,D2"
 K ^TMP($J,"RD"),LINE
 S LAB="RD"
 ;
 ; Get record details for file
 D ENPM^XBDIQ1(FL,BAREDL("A"),FLST,"^TMP($J,LAB,")
 I '$D(^TMP($J,"RD")) D NODATA Q
 ;
 ; Create output array
 F  S RECN=$O(^TMP($J,"RD",RECN)) Q:RECN=""  D
 .S (LINE(RECN),FLDNM)=""
 .F  S FLDNM=$O(^TMP($J,"RD",RECN,FLDNM)) Q:FLDNM=""  D
 ..S DATA=^TMP($J,"RD",RECN,FLDNM)
 ..I FLDNM=".01" S DATA=SPACE_DATA
 ..S LINE(RECN)=LINE(RECN)_$$PAD(DATA,PAD(FLDNM))
 ..S ^TMP($J,"LVL2",1,SUBF,RECN)=LINE(RECN)
 ..S ^TMP($J,"LVL2","IDX",1,SUBF,RECN)=LINE(RECN)
 ..Q
 ; 
 K LINE
 Q
 ; *********************************************************************
 ;
NODATA ; No data to be reported
 ;
 S ^TMP($J,"LVL2",1,SUBF,1)="No data available"
 S ^TMP($J,"LVL2","IDX",1,SUBF,1)="No data available"
 Q
 ; *********************************************************************
 ;
GETITEM ; -- select item from list
 K BARDR,^TMP($J,"LVL2")
 S VALMLST=""
 S VALMLST=$O(^TMP($J,"LVL1","IDX",VALMLST),-1)
 D EN^VALM2(XQORNOD(0),"O")
 I '$D(VALMY) Q
 NEW SF,Z
 S SF=0
 F  S SF=$O(VALMY(SF)) Q:SF=""  D
 . D GATHER(SF)
 . S Z=""
 . F  S Z=$O(^TMP($J,"LVL2","IDX",1,SF,Z)) Q:Z=""  D
 .. Q:$G(^TMP($J,"LVL2","IDX",1,SF,Z))=""
 .. S BARDR(Z)=^TMP($J,"LVL2","IDX",1,SF,Z)
 .. S ^TMP($J,"FL",Z,0)=BARDR(Z)
 .. S HDR=$G(^TMP($J,"FD",SF))
 Q
 ; *********************************************************************
 ;
BROWSE(FILE) ;EP; -- called to browse help on screen
 ; Called by AMCO HELP BROWSE (Browse Help Text) protocol
 K ^TMP($J,"LVL2"),^TMP($J,"FL")
 D GETITEM I '$D(BARDR) Q
 ; Segment element details
 I FL="90056.0102" D
 . S LSTFILE="BAR Segment Element Details"
 . D EN^BAREDL03(HDR,LSTFILE)
 I FL="90056.0106" D
 . S LSTFILE="BAR Table ID Details"
 . D EN^BAREDL03(HDR,LSTFILE)
 K BARDR
 Q
 ; *********************************************************************
 ;
EDIT ;EP; -- called to edit document
 ; called by AMCO HELP EDIT (Add/Edit Help Text) protocol
 ; called by AMCO DEV HELP EDIT (Add/Edit Help Text) protocol
 NEW AMCON,AMCODR,DIE,DR,DA,DIC,DLAYGO
 S Y=$$READ^AMCOUT("SBO^ADD:ADD New Document;EDIT:EDIT Existing Document","Select Action")
 I Y="ADD" D  Q
 . S (DIC,DLAYGO)=9002090.45
 . S DIC(0)="AEMLQZ"
 . D ^DIC
 . Q:Y<1
 . S DIE="^AMCODOC("
 . S DA=+Y
 . S DR=".01:999"
 . D ^DIE
 ;
 D GETITEM
 I '$D(AMCODR) Q
 S AMCON=0
 F  S AMCON=$O(AMCODR(AMCON)) Q:'AMCON  D
 . S DIE="^AMCODOC("
 . S DA=AMCODR(AMCON)
 . S DR=".01:999"
 . D ^DIE
 Q
 ; *********************************************************************
 ;
PRINT ;EP; call to print help documents on paper
 ; Called by AMCO HELP PRINT (Print Help Text) protocol
 NEW AMCODR,%ZIS,POP
 D GETITEM
 I '$D(AMCODR) Q
 S %ZIS="QP"
 D ^%ZIS
 Q:POP
 I $D(IO("Q")) D  Q
 . S ZTRTN="PRINT^AMCOHL1"
 . S ZTDESC="OB HELP GUIDE"
 . S ZTSAVE("AMCODR(")=""
 . K IO("Q")
 . D ^%ZTLOAD
 . K ZTSK
 . D HOME^%ZIS
 D CLEAR^VALM1,PRINT^AMCOHL1,RESET
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
