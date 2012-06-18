BIHELP ;IHS/CMI/MWR - DISPLAY HELP TEXT; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW OR PRINT HELP TEXT.
 ;
 ;----------
START(BIHEADER,BITEXT) ;EP
 ;---> Display in Listman the passed array of Help Text.
 ;---> Parameters:
 ;     1 - BIHEADER (opt) Header.
 ;     2 - BITEXT   (req) Array of Text to be displayed.
 ;
 I '$O(BITEXT(0)) D
 .N X D ERRCD^BIUTL2(666,.X) S BITEXT(1)=" ",BITEXT(2)="     "_X
 ;
 ;*** DO NOT NEW VALM* GOING INTO A LIST TEMPLATE FROM ANOTHER ONE
 ;*** --WILL CAUSE ERRORS!
 N VALMCNT
 D SETVARS^BIUTL5 K ^TMP("BIHELP",$J)
 D EN
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for List Template BI REPORT QUARTERLY IMM1.
 D EN^VALM("BI GENERIC HELP VIEW")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 ;D HEAD^BIREPA2(BIBEGDT,BIENDDT,.BICC,.BIHCF,.BICM,.BIBEN,BIHIST,.BIVT)
 ;
 ;---> Header code.
 N BIDASH,BILINE,X,Y S BILINE=0
 D WH^BIW(.BILINE)
 S:$G(BIHEADER)="" BIHEADER="HELP SCREEN"
 S X=BIHEADER
 S BIDASH=$L(X)+2
 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 S VALM("TITLE")=" (Immunization v"_$$VER^BILOGO_")"
 ;
 ;---> Gather text from ^BINFO( Word Processing global.
 N BILINE,N
 S BILINE=0,N=0
 F  S N=$O(BITEXT(N)) Q:'N  D
 .D WL^BIW(.BILINE,"BIHELP",BITEXT(N))
 S VALMCNT=BILINE
 I VALMCNT>15 D
 .S VALMSG="Scroll down to view more. Type ?? for more actions."
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Use arrow keys to scroll up and down through the text, or"
 W !?5,"type ""??"" for more actions, such as Search and Print."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup, EOJ.
 K ^TMP("BIHELP",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 ;S ZTRTN="DEQUEUE^BIHELP"
 ;D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Prepare and print Quarterly Report.
 ;K VALMHDR,^TMP("BIHELP",$J)
 ;D HDR
 ;D INIT?
 ;I $G(BIPOP) D EXIT Q
 ;D PRTLST^BIUTL8("BIREPA1"),EXIT
 Q
 ;
 ;
 ;----------
ERROR(BIERR) ;EP
 ;---> Report error, either to screen or print.
 ;---> Parameters:
 ;     1 - BIERR  (ret) Text of Error Code if any, otherwise null.
 ;
 D ERRCD^BIUTL2($G(BIERR),,1) S BIPOP=1
 Q
