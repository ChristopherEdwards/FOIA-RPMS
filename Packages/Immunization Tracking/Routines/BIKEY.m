BIKEY ;IHS/CMI/MWR - UTIL: VIEW/ALLOCATE BI KEYS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW HOLDERS OF BI KEYS AND ALLOCATE/DEALLOCATE KEYS.
 ;
 ;
 ;----------
START ;EP
 ;---> Main entry point for option BI KEYS ALLOCATE.
 D SETVARS^BIUTL5 K ^TMP("BIKEYS",$J) N BITMP,DIR
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 D EN^VALM("BI KEY HOLDERS VIEW/EDIT")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 N BIDASH,BILINE,X,Y S BILINE=0
 D WH^BIW(.BILINE)
 S X="HOLDERS OF IMMUNIZATION KEYS AT "_$$INSTTX^BIUTL6($G(DUZ(2)))
 S BIDASH=$L(X)+2 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 S X=$$SP^BIUTL5(BIDASH,"-") D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X,1)
 S X=" HOLDER                 BIZMENU   BIZ EDIT PATIENTS"
 S X=X_"   BIZ MANAGER   BIZ LOT ONLY"
 D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Enter ?? for more actions."
 S VALM("TITLE")=$$LMVER^BILOGO()
 ;
 K ^TMP("BIHOLD",$J),^TMP("BIKEYS",$J)
 N BIKEY S BIKEY="BIZ"
 ;F  S BIKEY=$O(^DIC(19.1,"B",BIKEY)) Q:BIKEY=""  Q:BIKEY]"BIZZ"  D
 F BIKEY="BIZMENU","BIZ EDIT PATIENTS","BIZ MANAGER","BIZ LOT ONLY" D
 .N BIKIEN
 .S BIKIEN=$O(^DIC(19.1,"B",BIKEY,0))
 .Q:'BIKIEN
 .;
 .N BIDUZ S BIDUZ=0
 .F  S BIDUZ=$O(^XUSEC(BIKEY,BIDUZ)) Q:BIDUZ=""  D
 ..S ^TMP("BIHOLD",$J,$$PERSON^BIUTL1(BIDUZ),BIKEY)=""
 ;
 ;
 N BIHLDRS,BINAME S BIHLDRS=0,BINAME=0
 F  S BINAME=$O(^TMP("BIHOLD",$J,BINAME)) Q:BINAME=""  D
 .N BIY
 .S BIY=" "_$E(BINAME,1,20)
 .;
 .I $D(^TMP("BIHOLD",$J,BINAME,"BIZMENU")) D
 ..S BIY=$$PAD^BIUTL5(BIY,24,"."),BIY=BIY_"YES"
 .;
 .I $D(^TMP("BIHOLD",$J,BINAME,"BIZ EDIT PATIENTS")) D
 ..S BIY=$$PAD^BIUTL5(BIY,34,"."),BIY=BIY_"YES"
 .;
 .I $D(^TMP("BIHOLD",$J,BINAME,"BIZ MANAGER")) D
 ..S BIY=$$PAD^BIUTL5(BIY,54,"."),BIY=BIY_"YES"
 .;
 .;  vvv83
 .I $D(^TMP("BIHOLD",$J,BINAME,"BIZ LOT ONLY")) D
 ..S BIY=$$PAD^BIUTL5(BIY,68,"."),BIY=BIY_"YES"
 .;
 .S BIHLDRS=BIHLDRS+1
 .S ^TMP("BIKEYS",$J,BIHLDRS,0)=BIY
 ;
 S VALMCNT=BIHLDRS
 I VALMCNT>13 D
 .S VALMSG="Scroll down to view more.  Type ?? for more actions."
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
 D TITLE^BIUTL5("HOLDERS OF IMMUNIZATION KEYS - HELP")
 D TEXT1,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;This screen displays all users who hold any of the four Keys to
 ;;the Immunization Package.  The Keys, which begin with BIZ, are
 ;;listed as column headers at the top of the screen.
 ;;
 ;;A "YES" in the column under a Key name indicates that the user
 ;;listed on that line holds the Key in the column header.
 ;;
 ;;There are two Actions presented at the bottom of the screen:
 ;;
 ;;1 - "Add/Edit a Holder" allows you to allocate or deallocate the
 ;;    Immunization Keys to users.
 ;;
 ;;2 - "Help" presents a detailed explanation of the privileges each Key
 ;;    bestows upon holders of the Key.
 ;;
 ;;
 ;
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
 K ^TMP("BIHOLD",$J),^TMP("BIKEYS",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
