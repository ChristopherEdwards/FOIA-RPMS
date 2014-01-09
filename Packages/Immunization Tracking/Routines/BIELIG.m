BIELIG ;IHS/CMI/MWR - EDIT ELIGIBILITY CODES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**3**;SEP 10,2012
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT ELIGIBILITY FIELDS: ACTIVE, LOCAL TEXT, REPORT ABBREVIATION.
 ;;  PATCH 3: This entire routine to edit Eligibility Codes is new.
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup Eligibility Codes and edit their fields.
 D SETVARS^BIUTL5 K ^TMP("BIELIG",$J) N BIELIG,BITMP
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 D EN^VALM("BI ELIGIBILITY TABLE EDIT")
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Print Eligibility Table.
 ;---> Called by Protocol BI VACCINE TABLE PRINT, which is the
 ;---> Print List Protocol for the List: BI VACCINE TABLE EDIT.
 ;
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET Q
 ;
 D HDR(1),INIT^BIELIG1
 D PRTLST^BIUTL8("BIELIG")
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
 S X="ELIGIBILITY CODE TABLE" S:'$G(BIPRT) X="EDIT "_X D CENTERT^BIUTL5(.X)
 S:BICRT X=IOINHI_X_IOINORM
 D WH^BIW(.BILINE,X)
 ;
 D:$G(BIPRT)
 .S X=$$SP^BIUTL5(51)_"Printed: "_$$NOW^BIUTL5()
 .D WH^BIW(.BILINE,X,1)
 .S X="    #  Eligibility Code      Label of Cdoe    Status     Local Text     Report Text"
 .D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BIELIG1
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
 S ZTRTN="DEQUEUE^BIELIG"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 D HDR(1),INIT^BIELIG1
 D PRTLST^BIUTL8("BIELIG"),EXIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""E"" to edit a Eligibility Code, enter ""C"" to change the order of"
 W !?5,"the list, ""H"" to view the full help text for the Eligibility list and"
 W !?5,"its parameters, ""F"" to turn on/off the forecasting of vaccines"
 W !?5,"and enter ""P"" to print the list."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("EDIT VACCINE TABLE - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;This screen allows you to edit 3 fields for each Eligibility Code.
 ;;To Edit a particular Code, type "E", then select the left
 ;;column number that corresponds to the Code you wish to edit.
 ;;
 ;;* Active/Inactive - If a Code is set to "Inactive", users will
 ;;     not be able to select this Elligibility Code when entering or
 ;;     editing immunizations. However, previous immunizations with
 ;;     Code will continue to display it.
 ;;
 ;;* Local Text - This is an optional, locally meaningful text that
 ;;     may be entered to help staff recognize Codes.  It may be the
 ;;     proper name of a local or State program, a regional or clinic
 ;;     name, or whatever is helpful.  It may be up to 20 characters
 ;;     in length. It is not exported, nor does it appear anywhere
 ;;     except during the Eligibility Code selection (along side the
 ;;     true Code) when immunizations are entered or edited.
 ;;
 ;;* Report Abbreviation - This is an optional, locally meaningful text
 ;;     that can be entered to help make information in the Eligibility
 ;;     Report more recognizable.  Text entered here will show up in
 ;;     the fourth column of the Vaccine Eligibility Report. (If no Report
 ;;     Abbreviation has been entered, then the standard Eligibility Code
 ;;     will appear in column four of the report.)
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
 K ^TMP("BIELIG",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
ELIGC(IEN,FORM) ;EP
 ;---> Return Eligibility values from BI TABLE ELIGIBILITY CODES File.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of Elig Code.
 ;     2 - FORM (opt) FORM of Code to return:
 ;                        1=Actual Code (also default)
 ;                        2=Label Text of Code
 ;                        3=Active/Inactive Status (1
 ;                        4=Local Text
 ;                        5=Local Report Abbreviation
 ;
 Q:'$G(IEN) ""
 Q:'$D(^BIELIG(IEN,0)) "NO GLOBAL"
 N Y S Y=^BIELIG(IEN,0)
 ;
 Q:$G(FORM)=2 $P(Y,U,2)
 Q:$G(FORM)=3 $P(Y,U,3)
 Q:$G(FORM)=4 $P(Y,U,4)
 Q:$G(FORM)=5 $P(Y,U,5)
 Q:$G(FORM)=6 $S($P(Y,U,5)]"":$P(Y,U,5),1:$P(Y,U))
 Q $P(Y,U)
