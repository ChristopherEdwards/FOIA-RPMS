BSDWLL ; IHS/ITSC/LJF, WAR - WAITING LIST LT CODE ;  [ 08/20/2004  11:59 AM ]
 ;;5.3;PIMS;**1001,1004,1007**;MAY 28, 2004
 ;IHS/ITSC/WAR 04/27/2004 PATCH 1001 ending date missing in loop
 ;IHS/OIT/LJF  07/20/2005 PATCH 1004 added comments, subtotals & total to list display
 ;                                   added ability to print sort categories on separate pages
 ;cmi/anch/maw 01/15/2007 PATCH 1007 added screen of print by if defined item 1007.28
 ;
EN ;EP -- main entry point for BSDRM WAITING LIST
 I $E(IOST,1,2)'="C-" D INIT,PRINT Q    ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM WAITING LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X="Waiting List for "_$$GET1^DIQ(9009017.1,BSDWLN,.01)
 S VALMHDR(2)=$$SP(70-$L(X)\2)_X
 S X="Sorted by "_$$FIELD(9009017.11,$P(BSDSRT,U,2))
 S X=X_"; for "_$P(BSDATE,U,2)
 S VALMHDR(3)=$$SP(70-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 S VALMCNT=0 K ^TMP("BSDWL",$J),^TMP("BSDWL1",$J)
 ;
 ; search by date range and sort
 NEW BSDSUB,BSDT,BSDN,BSDTPRI,BSDTPROV,BSDTREA,BSDTRES  ;cmi/maw added variables for PATCH 1007 item 1007.28
 S BSDSUB=$S(+BSDATE=".03":"AC",+BSDATE=".05":"AD",1:"AE")
 S BSDT=BSDBD-.0001
 F  S BSDT=$O(^BSDWL(BSDSUB,BSDT)) Q:'BSDT!(BSDT'<(BSDED+.9999))  D
 . S BSDN=0 F  S BSDN=$O(^BSDWL(BSDSUB,BSDT,BSDWLN,BSDN)) Q:'BSDN  D
 .. ;cmi/anch/maw 1/15/2007 added below lines to filter on print by
 .. I $G(BSDPRTYN),$G(BSDPRTB)=2 S BSDTPRI=$P($G(^BSDWL(BSDWLN,1,BSDN,0)),U,2) Q:'$D(BSDPRI(BSDTPRI))
 .. I $G(BSDPRTYN),$G(BSDPRTB)=3 S BSDTPROV=$P($G(^BSDWL(BSDWLN,1,BSDN,0)),U,6) Q:'$D(BSDPROV(BSDTPROV))
 .. I $G(BSDPRTYN),$G(BSDPRTB)=4 S BSDTREA=$P($G(^BSDWL(BSDWLN,1,BSDN,0)),U,9) Q:'$D(BSDREA(BSDTREA))
 .. I $G(BSDPRTYN),$G(BSDPRTB)=5 S BSDTRES=$P($G(^BSDWL(BSDWLN,1,BSDN,0)),U,8) Q:'$D(BSDRES(BSDTRES))
 .. ;cmi/anch/maw 1/15/2007 end of mods
 .. I BSDREM=0,$P($G(^BSDWL(BSDWLN,1,BSDN,0)),U,7)]"" Q  ;removed
 .. S ^TMP("BSDWL1",$J,$$SORT(BSDWLN,BSDN),BSDT,BSDN)=""
 ;
 ; take sorted list and put into display array
 NEW A,B,C,LINE,DFN,BSDCNT,FIRST,X
 NEW BSDATA,IENS,FILE,SUBCNT,TOTAL   ;IHS/OIT/LJF 7/21/2005 PATCH 1004 new variables
 S FIRST=1
 S A=0 F  S A=$O(^TMP("BSDWL1",$J,A)) Q:A=""  D
 . ;
 . ; display sort heading
 . ;IHS/OIT/LJF 7/21/2005 PATCH 1004 add ability to print each sort on separate page
 . ;I 'FIRST D SET("","",+$G(BSDCNT),.VALMCNT)
 . I 'FIRST D
 . . I $G(BSDPAG) D SET("NEW PAGE HERE","",+$G(BSDCNT),.VALMCNT) Q
 . . D SET("","",+$G(BSDCNT),.VALMCNT)
 . ;end of PATCH 1004 changes
 . ;
 . S FIRST=0
 . S X=$S(+BSDSRT=1:$$FMTE^XLFDT(A),1:A)   ;printable sort
 . S LINE=$$SP(10)_"** "_$$FIELD(9009017.11,$P(BSDSRT,U,2))_": "_X_" **"
 . D SET(LINE,"",+$G(BSDCNT),.VALMCNT)
 . ;
 . ; loop through date and ien
 . S B=0 F  S B=$O(^TMP("BSDWL1",$J,A,B)) Q:'B  D
 .. S C=0 F  S C=$O(^TMP("BSDWL1",$J,A,B,C)) Q:'C  D
 ... ;
 ... ; create display line
 ... S DFN=+^BSDWL(BSDWLN,1,C,0)                                ;patient ien
 ... S BSDCNT=$G(BSDCNT)+1,LINE=$J(BSDCNT,3)_". "_$$FMTE^XLFDT(B)
 ... S LINE=$$PAD(LINE,20)_$E($$GET1^DIQ(2,DFN,.01),1,20)       ;patient name
 ... S LINE=$$PAD(LINE,42)_$J($$HRCN^BDGF2(DFN,+$G(DUZ(2))),6)  ;hrcn
 ... S LINE=$$PAD(LINE,52)_$J($$GET1^DIQ(2,DFN,.033),3)         ;age
 ... S LINE=$$PAD(LINE,60)_$$GET1^DIQ(2,DFN,.02,"I")            ;sex
 ... ;S LINE=$$PAD(LINE,66)_$$GET1^DIQ(2,DFN,.131)   ;home phone
 ... S LINE=$$PAD(LINE,64)_$$GET1^DIQ(2,DFN,.131)    ;IHS/OIT/LJF 7/21/2005 PATCH 1004 improved spacing
 ... ;
 ... ; and set into display array
 ... D SET(LINE,C,BSDCNT,.VALMCNT)
 ... ;
 ... ;IHS/OIT/LJF 7/21/2005 PATCH 1004 added comments to listing & subcounts
 ... K BSDATA S IENS=C_","_BSDWLN_",",FILE=9009017.11
 ... D GETS^DIQ(FILE,IENS,"1","R","BSDATA")
 ... S X=0 F  S X=$O(BSDATA(FILE,IENS,"COMMENTS",X)) Q:'X  D
 .... D SET($$SP(6)_BSDATA(FILE,IENS,"COMMENTS",X),C,BSDCNT,.VALMCNT)
 ... D SET(" ",C,BSDCNT,.VALMCNT)
 ... ;
 ... S SUBCNT(A)=$G(SUBCNT(A))+1,TOTAL=$G(TOTAL)+1    ;increment counts
 . ; add subcount to display
 . D SET("Subtotal for "_$S(+BSDSRT=1:$$FMTE^XLFDT(A),1:A)_":  "_$G(SUBCNT(A)),C,BSDCNT,.VALMCNT)
 ;
 I $G(TOTAL) D SET("Total on list:  "_TOTAL,"",BSDCNT,.VALMCNT)
 ;end of PATCH 1004 additions
 ;
 I VALMCNT=0 D SET($$SP(20)_"No Data Found","",0,.VALMCNT)
 K ^TMP("BSDWL1",$J)
 Q
 ;
SORT(CLN,IEN) ; set sort value for ^tmp
 NEW X
 S X=$$GET1^DIQ(9009017.11,IEN_","_CLN,$P(BSDSRT,U,2))
 I +BSDSRT=1 S X=$$GET1^DIQ(9009017.11,IEN_","_CLN,$P(BSDSRT,U,2),"I")
 Q $S(X="":"UNKNOWN",1:X)
 ;
SET(DATA,IEN,COUNT,NUM) ; puts data line into display array
 S NUM=NUM+1 S:COUNT=0 COUNT=1
 S ^TMP("BSDWL",$J,NUM,0)=DATA
 S ^TMP("BSDWL",$J,"IDX",NUM,COUNT)=IEN
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW LINE
 S LINE=0 F  S LINE=$O(^TMP("BSDWL",$J,LINE)) Q:'LINE  D
 . I ^TMP("BSDWL",$J,LINE,0)="NEW PAGE HERE" D HDG Q  ;IHS/OIT/LJF 7/21/2005 PATCH 1004
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDWL",$J,LINE,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF
 NEW I F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("-",80)
 ;
 ;IHS/OIT/LJF 7/21/2005 PATCH 1004 improved column heading spacing
 ;W !?6,"Date Selected",?21,"Patient Name",?42,"Chart #",?53,"Age"
 ;W ?60,"Sex",?65,"Home Phone"
 W !?5,"Date Selected",?20,"Patient Name",?42,"Chart #",?52,"Age"
 W ?59,"Sex",?64,"Home Phone"
 ;
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDWL",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
GETONE ; -- select entry from listing
 NEW X,Y,Z
 D FULL^VALM1
 S BSDN=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("BSDWL",$J,"IDX",Y)) Q:Y=""  Q:BSDN]""  D
 . S Z=$O(^TMP("BSDWL",$J,"IDX",Y,0))
 . Q:^TMP("BSDWL",$J,"IDX",Y,Z)=""
 . I Z=X S BSDN=^TMP("BSDWL",$J,"IDX",Y,Z)
 Q
 ;
VIEW ;EP; called by BSDRM WAIT LIST VIEW protocol
 NEW BSDN,DFN
 D GETONE I BSDN="" D RETURN Q
 S DFN=+$$GET1^DIQ(9009017.11,BSDN_","_BSDWLN,.01,"I")  ;line added
 D EN^BSDWLV,RETURN
 Q
 ;
RETURN ; -- reset variables for return to lt
 D TERM^VALM0 S VALMBCK="R" Q
 ;
FIELD(F,N) ; find field's name
 Q $P($G(^DD(F,N,0)),U)
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
