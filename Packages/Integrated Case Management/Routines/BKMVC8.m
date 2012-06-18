BKMVC8 ;PRXM/HC/JGH - Patient Record Reminders; 24-JAN-2005 ; 01 Aug 2005  2:34 PM
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
EN ; EP - Main entry point for BKMV Record Reminder
 K ^TMP("BKMVC8",$J)
 D EN^VALM("BKMV RECORD REMINDER")
 D CLEAN
 QUIT
 ;
HDR ; -- header code
 D HDR^BKMVA51
 QUIT
 ;
INIT ; -- init variables and list array
 NEW LIST,REM,IREM,IND,TEXT,LINE,REMTXT,LASTTXT
 ;
 ; PRX/DLS 3/30/06 Commented out reminder call when entering Patient
 ; Reminder area. No need to re-calculate here.
 ; K REMLIST
 ; W !,"Calculating Reminders.. This may take a moment."
 ; D REMIND^BKMVF3(DFN,DT,.REMLIST)
 S VALMCNT=0,VALMAR="^TMP(""BKMVC8"","_$J_")",VALM0=""
 S REM=""
 F IREM=1:1 S REM=$O(REMLIST(REM)) Q:REM=""  D
 . S IND=""
 . F  S IND=$O(REMLIST(REM,IND)) Q:IND=""  D
 . . S LAST=$G(REMLIST(REM,IND,"LAST"))
 . . S DUE=$G(REMLIST(REM,IND,"DUE"))
 . . S LASTTXT=$G(REMLIST(REM,IND,"LASTTXT"))
 . . Q:LAST=""&(DUE="")
 . . S REMTXT=" "_$G(REMLIST(REM,IND,0))
 . . I LAST'="" S LAST=$P($$FMTE^XLFDT(+LAST,"5Z"),"@",1) I LASTTXT]"" S LAST=LAST_LASTTXT
 . . S OVERDUE=0
 . . I DUE'="" S:DUE<DT OVERDUE=1 S DUE=$P($$FMTE^XLFDT(+DUE,"5Z"),"@",1)
 . . I OVERDUE=0,LAST="" S DUE="("_DUE_")"
 . . I OVERDUE=1 S DUE="May Be Due Now (Was due "_DUE_")"
 . . S TEXT=$$PAD^BKMIXX4(REMTXT,">"," ",24)_$$PAD^BKMIXX4(LAST,">"," ",20)_$$PAD^BKMIXX4(DUE,">"," ",40)
 . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,TEXT)
 . . ; Add spacing to list
 . . I REMTXT["Viral Load"!(REMTXT["Trichomoniasis Test")!(REMTXT["Tetanus IZ")!(REMTXT["Dental Exam") D
 . . . S VALMCNT=$G(VALMCNT)+1 D SET^VALM10(VALMCNT,"")
 QUIT
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !
 QUIT
 ;
EXIT ; -- exit code
 QUIT
 ;
EXPND ; -- expand code
 QUIT
 ;
CLEAN ;
 ;PRX/DLS 3/30/06 Removed REMLIST kill to keep REMLIST around if you need it.
 K DA,DUE,IENS,LAST,OVERDUE,RCRDHDR,SITE,X
 ;K ^TMP("BKMVC8",$J)
 Q
