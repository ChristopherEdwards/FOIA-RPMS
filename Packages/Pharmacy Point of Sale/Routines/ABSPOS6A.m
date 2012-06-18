ABSPOS6A ; IHS/FCS/DRS - Data Entry & Status Disp ;
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 ;
 ; ALL writes of screen lines should be done as follows:
 ;  IF $$VISIBLE(line) DO WRITE^VALM10(line)
 ; When appropriate, set NODISPLY=true and $$VISIBLE will return false
 Q
ERROR D FULL^VALM1 Q  ; how to do ZQUIT acceptably? ; ZQUIT
DISPHIST(MSG,HANG) ; DEBUGGING - to record history and pause
 Q:'$P($G(^ABSP(9002313.99,1,"ABSPOS6*")),U)
 D DISPHIST^ABSPOS6H(MSG,HANG)
 Q
EN(USER,TIME) ;EP - from ABSPOS in prog mode ; option ABSP USER SCREEN
 ;S $ZT="ERROR^"_$T(+0) ; you lose the stack printout when you do this!
 N DISMISS,DISP,DISPHIST,DISPLINE,DISPIDX,CHGCOUNT,NODISPLY,INFO,ONEPAT
 D MYPARAMS^ABSPOS6C
 K @DISP,@DISPLINE,@DISPIDX,@DISPHIST,@DISMISS S (@DISPLINE,@DISPHIST)=0
 D EN^VALM("ABSP USER SCREEN")
 Q
HDR G HDR^ABSPOS6C ; -- header code
INIT ; -- init variables and list array
 N DISMISS,DISP,DISPHIST,DISPLINE,DISPIDX,CHGCOUNT,NODISPLY
 D MYPARAMS^ABSPOS6C
 D CLEAN^VALM10
 ;INIT1    ; to bypass setting of MYPARAMS
 S VALMCNT=0 ; 0 lines so far
 D HDR
 D UPD
 Q
UPD ;EP - protocol ABSP P1 UPDATE ; update the screen, once
 ; called from ABSPOS6C,ABSPOS6D,ABSPOS6J,ABSPOSI
 D UPDATE^ABSPOS6I(1)
 S VALMBCK="",XQORM("B")="UD" Q
CONTUPD ; protocol ABSP P1 CONTINUOUS ; continuous update of the display
 W !!!!! D UPDATE^ABSPOS6I(-1) S VALMBCK=""
 ; returned from Continuous Update - what's next?
 I $P($G(^ABSP(9002313.99,1,"INPUT")),U,3) D
 . ; input method is via RX calling POS or by background monitor
 . S XQORM("B")="CU" ; default is to go back into continuous update
 E  D  ; input method is manual input
 . S XQORM("B")="NEW" ; default is to do more data entry
 Q
HELP ; -- help code
 N X S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D FULL^VALM1
 Q
 ;
EXPND ; -- expand code
 Q
 ;
