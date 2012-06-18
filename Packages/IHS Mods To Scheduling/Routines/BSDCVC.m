BSDCVC ; IHS/ANMC/LJF - LIST VISIT CREATION STATUS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
 NEW VAUTC,VAUTD
 D CLINIC^BSDU(2) Q:$D(BSDQ)
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQ","EN^BSDCVC","LIST VISIT CREATE STATUS","")
 Q
 ;
EN ;EP; -- main entry point for BSDRM CREATE VISIT STATUS
 I $E(IOST,1,2)="P-" NEW BSDPRT S BSDPRT=1 D INIT,PRINT Q  ;prnt 2 paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CREATE VISIT STATUS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X S X="Sorted by Status & Principal Clinic"
 S VALMHDR(1)=$$SP(79-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW CLN,STAT,PC,LINE
 S VALMCNT=0
 K ^TMP("BSDCVC",$J),^TMP("BSDCVC1",$J)
 S ARRAY=$S(VAUTC:"^SC",1:"VAUTC")
 ;
 ; loop thru clinics and sort by visit creation status & princpl clinic
 S CLN=0 F  S CLN=$O(@ARRAY@(CLN)) Q:'CLN  D
 . Q:'$$ACTV^BSDU(CLN,DT)                  ;check if active clinic
 . Q:$D(^SC("AIHSPC",CLN))                 ;quit if prin clinic
 . S STAT=$$GET1^DIQ(9009017.2,CLN,.09)    ;create visit?
 . S:STAT="" STAT="NO"
 . S ^TMP("BSDCVC1",$J,STAT,$$PRIN^BSDU(CLN),CLN)=""
 ;
 ; now loop thru sort list and put into display array
 S STAT=0 F  S STAT=$O(^TMP("BSDCVC1",$J,STAT)) Q:STAT=""  D
 . ;
 . S LINE="CLINICS WITH 'CREATE VISIT AT CHECKIN' TURNED "
 . S LINE=LINE_$S(STAT="NO":"OFF",1:"ON")
 . S LINE=$$SP(79-$L(LINE)\2)_$G(IORVON)_LINE_$G(IORVOFF)
 . I $G(BSDPRT),STAT="YES" D SET("*****",.VALMCNT)   ;form feed marker
 . D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 . ;
 . S PC=0 F  S PC=$O(^TMP("BSDCVC1",$J,STAT,PC)) Q:PC=""  D
 .. ;
 .. D SET("",.VALMCNT),SET($G(IOUON)_PC_$G(IOUOFF),.VALMCNT)
 .. ;
 .. S CLN=0 F  S CLN=$O(^TMP("BSDCVC1",$J,STAT,PC,CLN)) Q:'CLN  D
 ... ;
 ... S LINE=$$SP(3)_$$GET1^DIQ(44,CLN,.01)                ;clinic name
 ... S LINE=$$PAD(LINE,35)_$P($$CLNCODE^BSDU(CLN),"-")    ;clinic code
 ... S LINE=$$PAD(LINE,41)_$$GET1^DIQ(9009017.2,CLN,.13)  ;other codes?
 ... S LINE=$$PAD(LINE,49)_$$GET1^DIQ(9009017.2,CLN,.12,"I")  ;ser cat
 ... S X=$$PRV^BSDU(CLN),X=$S('X:"",1:$P(X,U,2))
 ... S LINE=$$PAD(LINE,55)_$E(X,1,18)                  ;clinic provider
 ... S LINE=$$PAD(LINE,75)_$$GET1^DIQ(9009017.2,CLN,.14)  ;prov req?
 ... D SET(LINE,.VALMCNT)
 ;
 I $D(^TMP("BSDCVC",$J)) D LEGEND
 I '$D(^TMP("BSDCVC",$J)) S VALMCNT=1,^TMP("BSDCVC",$J,1,0)="NO DATA FOUND"
 ;
 K ^TMP("BSDCVC1",$J)
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BSDCVC",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDCVC",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
LEGEND ; explain column headings
 D SET("",.VALMCNT),SET("LEGEND:",.VALMCNT)
 D SET($$SP(3)_"Code=Clinic Code; Mult=Multiple Codes Used?",.VALMCNT)
 D SET($$SP(3)_"Vst Cat=Visit Service Category, optional",.VALMCNT)
 D SET($$SP(3)_"Req?=Is Visit Provider Required?",.VALMCNT)
 Q
 ;
PRINT ; print array to paper
 NEW BSDLN,BSDN,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S BSDLN=0 F  S BSDLN=$O(^TMP("BSDCVC",$J,BSDLN)) Q:'BSDLN  D
 . S BSDN=^TMP("BSDCVC",$J,BSDLN,0)
 . I BSDN="*****" D HDG Q
 . I $Y>(IOSL-4) D HDG
 . W !,BSDN
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading when printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGTIME,?22,"List 'Create Visit at Checkin' Status",?76,BDGUSR
 W !,BDGDATE,?23,"Sorted by Status & Principal Clinic"
 W ?71,"Page: ",BDGPG
 W !,$$REPEAT^XLFSTR("-",80)
 W !?3,"Clinic Name",?35,"Code",?41,"Mult",?46,"Vst Cat"
 W ?55,"Clinic Provider",?75,"Req?"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
