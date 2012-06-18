BIVGRP ;IHS/CMI/MWR - EDIT VACCINE GROUPS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE GROUPS TO TURN ON/OFF FORECASTING FOR EACH GROUP.
 ;
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup Vaccines and edit their fields.
 D SETVARS^BIUTL5 K ^TMP("BIVGRP",$J) N BITMP
 ;
 ;---> If Vaccine Table is not standard, display Error Text and quit.
 I $D(^BISITE(-1)) D ERRCD^BIUTL2(503,,1) Q
 ;
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 D EN^VALM("BI VACCINE GROUP TABLE EDIT")
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Print Vaccine Table.
 ;---> Called by Protocol BI VACCINE TABLE PRINT, which is the
 ;---> Print List Protocol for the List: BI VACCINE TABLE EDIT.
 ;
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET Q
 ;
 D HDR(1),INIT^BIVGRP1
 D PRTLST^BIUTL8("BIVGRP")
 D RESET
 Q
 ;
 ;
 ;----------
HDR(BIPRT) ;EP
 ;---> Header code for both Listman Screen and Print List.
 ;---> Parameters:
 ;     1 - BIPRT  (opt) If BIPRT=1 array is for print: Change column
 ;                      header line and add Site Header line.
 ;
 N BILINE,X,Y S BILINE=0 K VALMHDR
 N BICRT S BICRT=$S(($E($G(IOST))="C")!(IOST["BROWSER"):1,1:0)
 ;
 D WH^BIW(.BILINE)
 S X=$$REPHDR^BIUTL6(DUZ(2)),BIDASH=$L(X)+2 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 S X=$$SP^BIUTL5(BIDASH,"-") D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 ;
 S X="VACCINE GROUP FORCASTING" S:'$G(BIPRT) X="EDIT "_X D CENTERT^BIUTL5(.X)
 S:BICRT X=IOINHI_X_IOINORM
 D WH^BIW(.BILINE,X)
 ;
 D:$G(BIPRT)
 .S X=$$SP^BIUTL5(51)_"Printed: "_$$NOW^BIUTL5()
 .D WH^BIW(.BILINE,X,1)
 .S X="    #  Vaccine Group      Forecast"
 .D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BIVGRP1
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR() Q
 ;
 ;
 ;----------
DEVICE(BIPOP) ;EP
 ;---> Get Device and possibly queue to Taskman.
 ;---> Parameters:
 ;     1 - BIPOP (ret) If error or Queue, BIPOP=1
 ;
 K %ZIS,IOP S BIPOP=0
 S ZTRTN="DEQUEUE^BIVGRP"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 D HDR(1),INIT^BIVGRP1
 D PRTLST^BIUTL8("BIVGRP"),EXIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"To turn On or Off forecasting for a Vaccine Group, enter ""C"" then enter"
 W !?5,"the left column number of the Vaccine Group you wish to change."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXPL ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("EDIT VACCINE GROUP TABLE - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;This screen allows you to turn on or off forecasting for a particular
 ;;Vaccine Group.
 ;;
 ;;* CHANGE ALL THIS...IF USED.  FOR NOW, NO "EXPLANATION" ON THIS LIST TEMPLATE.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> End of job cleanup.
 D KILLALL^BIUTL8()
 K ^TMP("BIVGRP",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 ;---> Update the Vaccine Edit Screen with any Vaccine Group changes.
 D RESET^BIVACED
 Q
