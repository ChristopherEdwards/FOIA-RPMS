BIKEY2 ;IHS/CMI/MWR - VIEW BIZ KEYS EXPLANATION.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW IMMUNIZATION PACKAGE BIZ KEYS EXPLANATION IN LISTMAN.
 ;
 ;----------
START ;EP
 ;---> View explanation of Keys.
 D SETVARS^BIUTL5 K ^TMP("BIKEY2",$J) N BITMP,DIR
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 D EN^VALM("BI KEYS EXPLANATION VIEW")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code.
 N BIDASH,BILINE,X,Y S BILINE=0
 D WH^BIW(.BILINE)
 S X="SECURITY KEYS FOR IMMUNIZATION, Version "_$$VER^BILOGO
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
 F  S N=$O(^BINFO(2,1,N)) Q:'N  D
 .D WL^BIW(.BILINE,"BIKEY2",$G(^BINFO(2,1,N,0)))
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
 W !!?5,"Use arrow keys to scroll up and down.  "
 W "Enter ?? for more actions."
 D DIRZ^BIUTL3()
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 K ^TMP("BIKEY2",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
