BAREDL03 ; IHS/SD/LSL - AR TOP LEVEL FILE STRUCTURE ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;;;OCT 15, 1999
 ;
 D CLEAR^VALM1
 D MSG^AMCOUT("",2,0,0)
 ;
EN(HDR,LSTFILE) ;EP -- main entry point for DEVELOPER'S HELP EDIT MENU
 D EN^VALM(LSTFILE)
 Q
 ; *********************************************************************
 ;
HDR ;EP -- header code
 S VALMSG=$$VALMSG^AMCOUT
 S VALMHDR(1)=$P($G(^BAREDI("1T",FILE,0)),"^")
 S VALMHDR(2)=HDR
 Q
 ; *********************************************************************
 ;
INIT ;EP -- init variables and list array
 S VALMCNT=45
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
 K ^TMP($J,"LVL2")
 Q
 ; *********************************************************************
 ;
EXPND ;EP -- expand code
 Q
 ;
 ; *********************************************************************
RESET ;EP; -- rebuilds array after action
 D TERM^VALM0
 S VALMBCK="R"
 D INIT,HDR
 Q
