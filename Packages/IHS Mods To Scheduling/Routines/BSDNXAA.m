BSDNXAA ; IHS/ANMC/LJF - # DAYS TIL NEXT APPT ; 
 ;;5.3;PIMS;**1010,1011**;APR 26, 2002
 ;
 ;
 ;cmi/anch/maw 11/17/2008 PATCH 1010 put fix in NA per Walt Reisch for find of cancelled appointments
 ;
ASK ; -- ask user for clinics and device
 NEW VAUTC,VAUTD,BSD3RD,POP
 S BSD3RD=$$READ^BDGF("YO","Search for Next 3rd Available Appt.","","^D HELP1^BSDNXAA")
 Q:BSD3RD=U  Q:BSD3RD=""
 D CLINIC^BSDU(2) Q:$D(BSDQ)
 S Y=$$BROWSE^BDGF Q:"PB"'[Y  I Y="B" D EN Q  ;browse in list mgr mode
 D ZIS^BDGF("PQ","START^BSDNXAA","NEXT AVAIL APPT","VAUTC*;VAUTD*;BSD3RD")
 Q
 ;
START ;EP; -- re-entry for printing to paper
 D INIT,PRINT Q
 ;
EN ;EP; -- main entry point for BSDRM NEXT AVAIL APPT
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM NEXT AVAIL APPT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 NEW ARRAY,CLINIC,PC,NAME
 S VALMCNT=0 K ^TMP("BSDNXAA",$J),^TMP("BSDNXAA1",$J)
 S ARRAY=$S(VAUTC:"^SC",1:"VAUTC")
 S CLINIC=0
 F  S CLINIC=$O(@ARRAY@(CLINIC)) Q:'CLINIC  D
 . Q:'$$OKAY(CLINIC)                   ;quit if inactive clinic
 . I $D(^SC("AIHSPC",CLINIC)) Q        ;quit if principal clinic
 . S PC=$$PRIN^BSDU(CLINIC)            ;get princ clinic name
 . S NAME=$$GET1^DIQ(44,CLINIC,.01)    ;clinic's name
 . ;
 . ; put in principal clinic order, then by clinic name
 . S ^TMP("BSDNXAA1",$J,PC,NAME,CLINIC)=""
 ;
 I '$D(^TMP("BSDNXAA1",$J)) D SET("NONE FOUND",.VALMCNT) Q
 ;
 ; pull in sorted order and get display data
 S PC=0 F  S PC=$O(^TMP("BSDNXAA1",$J,PC)) Q:PC=""  D
 . D SET(PC,.VALMCNT)       ;principal clinic subheading
 . S NAME=0 F  S NAME=$O(^TMP("BSDNXAA1",$J,PC,NAME)) Q:NAME=""  D
 .. S CLINIC=0
 .. F  S CLINIC=$O(^TMP("BSDNXAA1",$J,PC,NAME,CLINIC)) Q:'CLINIC  D
 ... D SET($$DAY(CLINIC,NAME),.VALMCNT)  ;put into display global
 ;
 K ^TMP("BSDNXAA1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDNXAA",$J),VALMCNT,POP
 Q
 ;
EXPND ; -- expand code
 Q
 ;
 ;
DAY(CLN,NAME) ; -- loop visit days / clinic and print next appt
 NEW BSDAY,LINE,BSD3CT
 S LINE=$$PAD($$SP(26)_NAME,57)
 S BSDAY=DT-.0001,BSD3CT=0
 ; find next available appt
 F  S BSDAY=$O(^SC(CLN,"ST",BSDAY)) Q:'BSDAY  Q:$$NA
 ;
 I 'BSDAY Q LINE_"none"   ;if none found, say so
 ;
 ; if found set line with date and # of days
 Q $$PAD(LINE_$$FMTE^XLFDT(BSDAY),71)_$J($$D(BSDAY),2)_" days"
 Q
 ;
NA() ; -- next appointment
 NEW X,Y,Z,J
 S Y=$O(^SC(CLN,"ST",BSDAY,0)) Q:'Y 0
 I $D(^SC(CLN,"ST",BSDAY,"CAN")) Q 0  ;cmi/maw 11/17/2008 PATCH 1010 added per walt reisch find at PIMC dont count if cancelled
 ;S X="#@!$* XXWVUTSRQPONMLKJIHGFEDCBA0123456789jklmnopqrstuvwxyz"  ;cmi/11/2/2009 PATCH 1011 orig line
 S X="#@!$* ZYXXWVUTSRQPONMLKJIHGFEDCBAzyxwvutsrqponmlkjihgfedcba0123456789"  ;cmi/11/2/2009 PATCH 1011 add remaining letters to lower case
 S Z=$E(^SC(CLN,"ST",BSDAY,Y),6,$L(^SC(CLN,"ST",BSDAY,Y)))
 I BSD3RD F J=1:1:$L(Z) D
 . I $E(X,$F(X,"0"),$L(X))[$E(Z,J) S:BSD3RD BSD3CT=BSD3CT+1
 I 'BSD3RD F J=1:1:$L(Z) D
 . I $E(X,$F(X,"0"),$L(X))[$E(Z,J) S J=999
 Q $S(J=999:1,BSD3CT>2:1,1:0)
 ;
D(X1,X2,X) ; -- number of days from today
 S X2=DT D ^%DTC Q X
 ;
 ;
SET(DATA,NUM) ; -- set display data into global
 S NUM=NUM+1
 S ^TMP("BSDNXAA",$J,NUM,0)=DATA
 Q
 ;
PRINT ; -- print display global to paper
 U IO D HD
 NEW X
 S X=0 F  S X=$O(^TMP("BSDNXAA",$J,X)) Q:'X  D
 . I $Y>(IOSL-4) D HD
 . W !,^TMP("BSDNXAA",$J,X,0)
 D ^%ZISC,EXIT,HOME^%ZIS
 Q
 ;
HD ; -- heading
 W @IOF,!!,?2,"Next Available Appointment by Principle Clinic"
 W ?50,"Printed at ",$$FMTE^XLFDT($$NOW^XLFDT),!
 Q
 ;
OKAY(C) ; -- active clinic? (yes=true)
 NEW X
 S X=$G(^SC(C,"I")) Q:'$D(^SC(C,"ST")) 0 Q:'$O(^("ST",DT)) 0
 Q $S($P(^SC(C,0),U,3)'="C":0,'X:1,(DT>(X-1))&('$P(X,U,2)):0,1:1)
 ;
HELP1 ;EP; help for 3rd appt question
 D MSG^BDGF("Answer YES to use the 3rd next available appointment",2,0)
 D MSG^BDGF("in your calculations.  Some research has shown that",1,0)
 D MSG^BDGF("using the 3rd next available appointment instead of",1,0)
 D MSG^BDGF("the very next one, gives a clearer picture of the",1,0)
 D MSG^BDGF("clinic schedule.",1,0)
 D MSG^BDGF("Answer NO to use next available appointment.",2,1)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
