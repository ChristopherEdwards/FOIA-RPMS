BDGPI1 ; IHS/ANMC/LJF - PI EXPANDED DEMOGRAPHICS ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG PI - DEMOGRAPHICS
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG PI - DEMOGRAPHICS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(10)_"** "_$$CONF^BDGF_" **"
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BDGPI1",$J)
 S VALMCNT=0
 D BASIC,PCP,INSUR,EC,NOK
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGPI1",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
BASIC ; -- set up demographic data for display
 ; very similar code to SECTION1^BDGPI
 NEW LINE,BDGR
 ; name, cwad display, chart # and date of birth
 S LINE=$$GET1^DIQ(2,DFN,.01)_" "_$TR($$CWAD^BDGF2(DFN)," ","")
 S LINE=$$PAD(LINE,32)_"HRCN: "_$$HRCN^BDGF2(DFN,DUZ(2))
 S LINE=$$PAD(LINE,54)_"DOB: "_$$GET1^DIQ(2,DFN,.03)
 D SET(LINE,.VALMCNT)
 ;
 ; street address, home phone and primary care provider
 S LINE=$$PAD($$GET1^DIQ(2,DFN,.111),32)
 S LINE=LINE_"HOME: "_$$GET1^DIQ(2,DFN,.131)
 S LINE=$$PAD(LINE,54)_"SEX: "_$$GET1^DIQ(2,DFN,.02)
 D SET(LINE,.VALMCNT)
 ;
 ; city, state, eligibility, office phone
 S LINE=$$GET1^DIQ(2,DFN,.114)_", "_$$STATE^BDGPI(DFN)
 S LINE=$$PAD(LINE,30)_"OFFICE: "_$$GET1^DIQ(2,DFN,.132)
 S LINE=$$PAD(LINE,53)_"ELIG: "_$$GET1^DIQ(9000001,DFN,1112)
 D SET(LINE,.VALMCNT)
 ;
 ; service unit based on community of residence
 S LINE=$$GET1^DIQ(9999999.05,+$$GET1^DIQ(9000001,DFN,1117),.05)
 I LINE]"" D SET("("_LINE_" Service Unit)",.VALMCNT)
 Q
 ;
PCP ; set up primary care provider info for display
 NEW BDGX
 S BDGX="BDGX" D PCP^BSDU1(DFN,.BDGX)
 S LINE="Primary Care Provider/Team: "
 S LINE=LINE_$P($G(BDGX(1)),"/")_" / "_$P($G(BDGX(1)),"/",2)
 D SET("",.VALMCNT),SET(LINE,.VALMCNT)
 ;
 I $P($G(BDGX(2)),"/")]"" D
 . S LINE=$$SP(3)_"Women's Health PCP/Team: "
 . S LINE=LINE_$P($G(BDGX(2)),"/")_" / "_$P($G(BDGX(2)),"/",2)
 . D SET(LINE,.VALMCNT)
 ;
 I $P($G(BDGX(3)),"/")]"" D
 . S LINE=$$SP(3)_"Mental Health Providers/Team: "
 . S LINE=LINE_$P($G(BDGX(3)),"/")_" / "_$P($G(BDGX(3)),"/",5)
 . S LINE=LINE_" / "_$P($G(BDGX(3)),"/",2)
 . D SET(LINE,.VALMCNT)
 ;
 Q
 ;
INSUR ; set up insurance info for display
 ; -- insurance (from health summary)
 Q:$T(^APCHS5)=""
 NEW APCHSPAT,APCHSCKP,APCHSNPG,APCHSCVD,APCHSBRK,APCHSQ,X
 K ^TMP("BDGPI1A",$J)
 S APCHSPAT=DFN,APCHSCKP="",APCHSNPG=0,APCHSBRK=""
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$E(Y,6,7)_""/""_$E(Y,2,3)"
 D GUIR^XBLM("^APCHS5","^TMP(""BDGPI1A"",$J,")
 D SET("",.VALMCNT)
 S X=0 F  S X=$O(^TMP("BDGPI1A",$J,X)) Q:'X  D
 . D SET(^TMP("BDGPI1A",$J,X),.VALMCNT)
 K ^TMP("BDGPI1A",$J)
 Q
 ;
EC ; set up emergency contact info for display
 D SET("",.VALMCNT)
 K BDGX D ENP^XBDIQ1(2,DFN,".331:.339","BDGX(")
 ;
 S LINE="Emergency Contact: "
 I BDGX(.331)="" D SET(LINE_"None on file",.VALMCNT) Q
 S LINE=LINE_BDGX(.331)_" ("_BDGX(.332)_")"
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$PAD($$SP(19)_BDGX(.333),50)_"EC Phone: "_BDGX(.339)
 D SET(LINE,.VALMCNT)
 S LINE=$$SP(19)_BDGX(.336)_", "_BDGX(.337)_"  "_BDGX(.338)
 D SET(LINE,.VALMCNT)
 K BDGX
 Q
 ;
NOK ; set up next of kin info for display
 D SET("",.VALMCNT)
 K BDGX D ENP^XBDIQ1(2,DFN,".211:.219","BDGX(")
 ;
 S LINE="Next of Kin: "
 I BDGX(.211)="" D SET(LINE_"None on file",.VALMCNT) Q
 S LINE=LINE_BDGX(.211)_" ("_BDGX(.212)_")"
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$PAD($$SP(13)_BDGX(.213),50)_"NOK Phone: "_BDGX(.219)
 D SET(LINE,.VALMCNT)
 S LINE=$$SP(13)_BDGX(.216)_", "_BDGX(.217)_"  "_BDGX(.218)
 D SET(LINE,.VALMCNT)
 K BDGX
 Q
 ;
SET(LINE,NUM) ; puts display line into array
 S NUM=NUM+1
 S ^TMP("BDGPI1",$J,NUM,0)=LINE
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
