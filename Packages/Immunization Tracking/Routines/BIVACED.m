BIVACED ;IHS/CMI/MWR - EDIT VACCINES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT VACCINE FIELDS: CURRENT LOT, ACTIVE, VIS DATE DEFAULT.
 ;
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup Vaccines and edit their fields.
 D SETVARS^BIUTL5 K ^TMP("BILMVA",$J) N BITMP
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
 D EN^VALM("BI VACCINE TABLE EDIT")
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
 D HDR(1),INIT^BIVACED1
 D PRTLST^BIUTL8("BILMVA")
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
 S X="VACCINE TABLE" S:'$G(BIPRT) X="EDIT "_X D CENTERT^BIUTL5(.X)
 S:BICRT X=IOINHI_X_IOINORM
 D WH^BIW(.BILINE,X)
 ;
 D:$G(BIPRT)
 .S X=$$SP^BIUTL5(51)_"Printed: "_$$NOW^BIUTL5()
 .D WH^BIW(.BILINE,X,1)
 .S X="    #  Vaccine      HL7    Active      Default Lot#"
 .S X=X_"    VIS Default    Forecast"
 .D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BIVACED1
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
 S ZTRTN="DEQUEUE^BIVACED"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 D HDR(1),INIT^BIVACED1
 D PRTLST^BIUTL8("BILMVA"),EXIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""E"" to edit a Vaccine, enter ""C"" to change the order of"
 W !?5,"the list, ""H"" to view the full help text for the vaccine list and"
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
 ;;This screen allows you to edit five fields of each Vaccine.
 ;;To Edit a particular Vaccine, type "E", then select the left
 ;;column number that corresponds to the Vaccine you wish to edit.
 ;;
 ;;* Active/Inactive - If a Vaccine is set to "Inactive", users will
 ;;     not be able to enter NEW patient immunizations for this vaccine.
 ;;     However, previous immunizations with this Vaccine will continue
 ;;     to show up on the patient histories.
 ;;
 ;;* Default Lot# - This is that Lot# that will be automatically
 ;;     entered in the Lot# field for this Vaccine when users are
 ;;     adding new immunizations for patients.  The user will be able
 ;;     to change or delete the default if it is not correct.
 ;;
 ;;* VIS Default - This is the Vaccine Information Statement (VIS)
 ;;     Date (Date of publication--not date given to patient).
 ;;     It gets entered automatically as in the VIS Date field
 ;;     when users are adding new immunizations for this Vaccine.
 ;;
 ;;* Volume Default - This is the default Volume of the injection for the
 ;;     given vaccine.  It gets entered automatically as in the Volume
 ;;     field when users are adding new immunizations for this Vaccine.
 ;;
 ;;* Forecasting - The Forecast column indicates whether a vaccine will
 ;;     be forecast (listed as due for patients) or not.  Each vaccine
 ;;     belongs to a VACCINE GROUP, for example, the HEP A GROUP.
 ;;     Turning OFF forecasting for the HEP A Vaccine Group will block
 ;;     all forecasting of any vaccines that contain Hep A vaccine.
 ;;     To change forecasting for a Vaccine Group, select the "Forecasting"
 ;;     Action at the bottom of the screen.
 ;;     NOTE: Combination vaccines will not be forecast specifically --
 ;;           their component vaccines will be forecast (if the patient
 ;;           is due).  Use of the combination vaccines is an option open
 ;;           to the provider.  Inputting combination vaccines into the
 ;;           patient's history will satisfy the requirements of the
 ;;           component vaccines.
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
 K ^TMP("BILMVA",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
