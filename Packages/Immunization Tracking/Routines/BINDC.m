BINDC ;IHS/CMI/MWR - EDIT NDC CODES.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;**9**;OCT 01,2014
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT NDC NUMBER FIELDS.
 ;   PATCH 2: Redisplay Message area (with # of NDCs) in List Template. HELP+5
 ;
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup NDC CODES and edit their fields.  vvv83
 D SETVARS^BIUTL5 K ^TMP("BINDC",$J) N BICOLL,BISUBT,BITMP,BIINACT
 S BISUBT="1:NDC Code;2:Vaccine Name, then by NDC Code"
 ;S BISUBT=BISUBT_";5:Vaccine Name, then by Exp Date"
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
 D EN^VALM("BI NDC TABLE EDIT")
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Print NDC Number Table.
 ;---> Called by Protocol BI NDC NUMBER TABLE PRINT, which is the
 ;---> Print List Protocol for the List: BI NDC NUMBER TABLE EDIT.
 ;
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET Q
 ;
 D HDR(1),INIT^BINDC1
 D PRTLST^BIUTL8("BINDC")
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
 S X="NDC NUMBER TABLE" S:'$G(BIPRT) X="EDIT "_X
 D CENTERT^BIUTL5(.X)
 S:BICRT X=IOINHI_X_IOINORM
 D WH^BIW(.BILINE,X)
 ;
 ;---> Subtitle: indicate order of listing.
 D:($G(BICOLL)&$D(BISUBT))
 .N Y S Y=$P($P(BISUBT,BICOLL_":",2),";") S X=" (Listed by "_Y_")"
 .D CENTERT^BIUTL5(.X) S:BICRT X=IOINHI_X_IOINORM D WH^BIW(.BILINE,X)
 ;
 D:$G(BIPRT)
 .S X=$$SP^BIUTL5(51)_"Printed: "_$$NOW^BIUTL5()
 .D WH^BIW(.BILINE,X,1)
 .S X="  #  NDC Code         Vaccine     CVX  Manufacturer  Product         Status"
 .D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BINDC1
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
 S ZTRTN="DEQUEUE^BINDC"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 D HDR(1),INIT^BINDC1
 D PRTLST^BIUTL8("BINDC"),EXIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""A"" to add or edit an NDC Code, enter ""E"" to select and Edit an"
 W !?5,"NDC Code from the left column, enter ""C"" to change the order of the list,"
 W !?5,"""S"" to Search for a particular NDC Code, ""D"" to include NDC Codes"
 W !?5,"in the display (will appear after all Active Lot Numbers),and enter ""H"""
 W !?5,"to view the full help text for the NDC list and its parameters."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("EDIT NDC CODES - HELP",.BITEXT)
 ;
 ;---> Redisplay Message area (with number of NDCs) in List Template.
 D RESET^BINDC1
 Q
 ;
 ;   vvv83
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;This screen allows you to view and edit the fields of NDC CODES.
 ;;
 ;;NOTE: To show INACTIVE NDC CODES, select "D Display Inactives."
 ;;
 ;;To Add a new NDC Number, type "A".  If the NDC Number already exists in
 ;;the Table, a message will display, directng you select that NDC Number
 ;;for editing.
 ;;
 ;;To edit an existing NDC Number type "E" and then select the left column
 ;;number that corresponds to the NDC Number you wish to edit.
 ;;
 ;;You may also SEARCH the entire list for any number, name, or combination
 ;;of characters by usinng the "S Search List" action.
 ;;
 ;;You may list the NDCs by either NDC Code or Vaccine (alphabetically) using
 ;;the Change List Order action.
 ;;
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
TEXT3 ;EP
 ;;
 ;;This option will automatically INACTIVATE ALL NDC CODES that
 ;;have EXPIRED (an Expiration Date prior to today).
 ;;
 ;;It will also automatically INACTIVATE ALL NDC CODES that have
 ;;NO Expiration Date (as viewed in the NDC Number Table).
 ;;
 ;;   Note: You can REACTIVATE any NDC Number individually at any time
 ;;   by editing the NDC Number individually from the Edit NDC CODES
 ;;   Screen (and resetting the Active Field for that NDC Number).
 ;;
 ;;Do you wish to INACTIVATE ALL NDC CODES that either have EXPIRED
 ;;or have NO Expiration Date?
 ;;
 D PRINTX("TEXT3")
 Q
 ;
 ;
 ;----------
TEXT33 ;EP
 ;;
 ;;Okay.
 ;;Please confirm that you wish Inactivate all NDC CODES that
 ;;either have EXPIRED or have NO Expiration Eate, by typing "YES"
 ;;a second time.  (Enter NO to discontinue this process.)
 ;;
 D PRINTX("TEXT33")
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
 ;---> End of job cleanup.
 D KILLALL^BIUTL8()
 K ^TMP("BINDC",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
NDC(IEN,FORM) ;EP
 ;---> Return NDC Code values from BI TABLE NDC CODES File.
 ;---> Parameters:
 ;     1 - IEN  (req) IEN of NDC Code.
 ;     2 - FORM (opt) FORM of Code to return:
 ;                        1=Actual NDC Code (also default)
 ;                        2=Vaccine Pointer (use for Vaccine Name or CVX)
 ;                        3=Manufacturer Pointer
 ;                        4=Product Name
 ;                        5=Status
 ;
 Q:'$G(IEN) ""
 Q:'$D(^BINDC(IEN,0)) "NO GLOBAL"
 N Y S Y=^BINDC(IEN,0)
 ;
 Q:$G(FORM)=2 $P(Y,U,2)
 Q:$G(FORM)=3 $P(Y,U,3)
 Q:$G(FORM)=4 $P(Y,U,4)
 Q:$G(FORM)=5 $P(Y,U,5)
 Q $P(Y,U)
