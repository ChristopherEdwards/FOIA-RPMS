BISITE ;IHS/CMI/MWR - EDIT SITE PARAMETERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT SITE PARAMETERS VIA LISTMAN.
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup and edit a Site.
 D SETVARS^BIUTL5
 N A,B
 D TITLE^BIUTL5("EDIT SITE PARAMETERS") W !
 S BIPRMPT="   Select SITE/FACILITY: ",BIDFLT=""
 S:$D(DUZ(2)) BIDFLT=$$INSTTX^BIUTL6(DUZ(2))
 D DIC^BIFMAN(9002084.02,"QEMAL",.Y,BIPRMPT,BIDFLT)
 Q:Y<0
 K BIPRMPT,BIDFLT
 S BISITE=+Y
 L +^BISITE(BISITE):2 I '$T D LOCKED^BIUTL3 Q
 D EN(BISITE)
 L -^BISITE(BISITE) L -^BISITE(BISITE)
 Q
 ;
 ;
 ;----------
EN(BISITE) ;EP
 ;---> Main entry point for BI SITE PARAMETERS EDIT.
 ;---> If BISITE not supplied, set Error Code and quit.
 I '$G(BISITE) D ERRCD^BIUTL2(109,,1) Q
 I '$D(^BISITE(BISITE,0)) D ERRCD^BIUTL2(110,,1) Q
 D EN^VALM("BI SITE PARAMETERS EDIT")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 N X S X="     Edit Site Parameters for: "
 S X=X_IOINHI_$$INSTTX^BIUTL6(BISITE)_IOINORM
 S VALMHDR(1)=""
 S VALMHDR(2)=X
 ;
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BISITE1
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 S VALMSG="Scroll down to view more Parameters."
 D INIT,HDR Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 D TITLE^BIUTL5("SITE PARAMETER SCREEN - HELP")
 D TEXT1
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 S VALMSG="Scroll down to view more Parameters."
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;This is the screen for editing Site Parameters.
 ;;
 ;;To edit a parameter, enter its left column number.  Helpful
 ;;information is presented with each parameter when it is selected.
 ;;
 ;;The Site that these parameters applies to is displayed at the top
 ;;of the screen.  This Site is determined when you log on to RPMS.
 ;;If you are running more than one Site on the same computer and
 ;;wish to edit parameters for another site, you must log off and
 ;;log back on under the Site you wish to edit.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
PRINTX(BILINL,BITAB) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> EOJ cleanup.
 D KILLALL^BIUTL8(1)
 K ^TMP("BISITE",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
