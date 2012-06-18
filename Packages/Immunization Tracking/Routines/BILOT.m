BILOT ;IHS/CMI/MWR - EDIT LOT NUMBERS.; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  EDIT LOT NUMBER FIELDS.
 ;
 ;
 ;
 ;----------
START ;EP
 ;---> Lookup Vaccines and edit their fields.  vvv83
 D SETVARS^BIUTL5 K ^TMP("BILOT",$J) N BICOLL,BISUBT,BITMP,BIINACT
 S BISUBT="1:Unused Doses;2:Expiration Date;3:Lot Number"
 S BISUBT=BISUBT_";4:Vaccine Name, then by Unused Doses"
 S BISUBT=BISUBT_";5:Vaccine Name, then by Exp Date"
 S BISUBT=BISUBT_";6:Vaccine Name, then by Lot Number"
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
 D EN^VALM("BI LOT TABLE EDIT")
 Q
 ;
 ;
 ;----------
PRINT ;EP
 ;---> Print Vaccine Table.
 ;---> Called by Protocol BI LOT NUMBER TABLE PRINT, which is the
 ;---> Print List Protocol for the List: BI LOT NUMBER TABLE EDIT.
 ;
 D DEVICE(.BIPOP)
 I $G(BIPOP) D RESET Q
 ;
 D HDR(1),INIT^BILOT1
 D PRTLST^BIUTL8("BILOT")
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
 S X="LOT NUMBER TABLE" S:'$G(BIPRT) X="EDIT "_X
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
 .S X="  #  Lot Number            Vaccine     Status  Exp Date  Start Unused  Facility"
 .D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BILOT1
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
 S ZTRTN="DEQUEUE^BILOT"
 D ZSAVES^BIUTL3
 D ZIS^BIUTL2(.BIPOP,1)
 Q
 ;
 ;
 ;----------
DEQUEUE ;EP
 ;---> Print Patient Data screen.
 D HDR(1),INIT^BILOT1
 D PRTLST^BIUTL8("BILOT"),EXIT
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Enter ""A"" to add or edit a Lot Number, enter ""S"" to Select a Lot"
 W !?5,"Number from the left column, enter ""C"" to change the order of the list,"
 W !?5,"enter ""I"" to Inactivate expired Lot Numbers, and enter ""H"" to view"
 W !?5,"the full help text for the lot number list and its parameters."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;----> Explanation of this report.
 N BITEXT D TEXT1(.BITEXT)
 D START^BIHELP("EDIT LOT NUMBERS - HELP",.BITEXT)
 Q
 ;
 ;   vvv83
 ;----------
TEXT1(BITEXT) ;EP
 ;;
 ;;This screen allows you to add and edit the eight fields of Lot Numbers.
 ;;
 ;;NOTE: To show INACTIVE Lot Numbers, select "C Change List Order" and
 ;;answer "YES" to the follow-up Question: "Include INACTIVE in display?"
 ;;
 ;;To Add a new Lot Number, type "A".  If the Lot Number already exists in
 ;;the Table, a message will display, directng you select that Lot Number
 ;;for editing.
 ;;
 ;;To edit an existing Lot Number type "E" and then select the left column
 ;;number that corresponds to the Lot Number you wish to edit.
 ;;
 ;;You may also SEARCH the entire list for any number, name, or combination
 ;;of characters by usinng the "S Search List" action.
 ;;
 ;;You may list the Lots in a variety of manners by using the "C Change List"
 ;;action.  Changing the list will also give you the opportunity include
 ;;INACTIVE Lot Numbers in the listing (as mentioned above).
 ;;
 ;;Lastly, you may automatically inactivate ALL Lot Numbers that either
 ;;have expired or have no expiration date, by typing "I".
 ;;
 ;;The fields for each Lot Number are:
 ;;
 ;;Vaccine - This is the vaccine to which the Lot Number is assigned.
 ;;     A Vaccine is REQUIRED when entering a New Lot Number.
 ;;
 ;;Manufacturer (MVX) - This is the standard CDC/HL7 Manufacturer Code
 ;;     assigned to the company that produced the Lot.  Enter ?? in order
 ;;     to view the entire Manufacturer Code list.
 ;;     A Manufacturer is REQUIRED when entering a New Lot Number.
 ;;
 ;;Status - If a Lot Number is set to "Inactive", users will not be
 ;;     able to select it when entering NEW patient immunizations for this.
 ;;     vaccine.  However, previous immunizations with this Lot Number will
 ;;     continue to show up on the patient histories.
 ;;
 ;;Source - Choice are VFC, Other State, or IHS/Tribal,.
 ;;
 ;;NDC Code - This is the NDC on the box or vial for this lot.  Available
 ;;      NDC's are limited by virtue of the particular vaccine chosen for
 ;;      this lot number.
 ;;
 ;;Expiration Date - This is the date that the Lot expires.
 ;;
 ;;Starting Count - Total number of doses in the starting inventory for
 ;;    the Lot when it was first received.
 ;;
 ;;Doses Unused - Number of doses of a lot remaining or unused.
 ;;    This number will decrease each time an immunization of that Lot Number
 ;;    is entered into RPMS through the Immunization package or data entry.
 ;;    The pharmacist or user can also reset this number if it becomes
 ;;    incorrect, such as might occur with wasted doses, data entry errors,
 ;;    etc.
 ;;
 ;;    NOTE: This number may become NEGATIVE.  A negative number for the
 ;;    Doses Unused would indicate that deletions, data entry errors, or
 ;;    testing have caused the number to become negative by mere subtraction
 ;;    each time it is used in the computer--even if it has not actually
 ;;    been used clinically.  Therefore, it is entirely appropriate for
 ;;    the vaccine manager or pharmacist to correct the Doses Unused
 ;;    in order to have it accurately reflect the number of doses that are
 ;;    still unused in the inventory (in other words, sitting on the shelf).
 ;;
 ;;Doses Used - This is merely a the Doses Unused subtracted from the
 ;;    Starting Count.
 ;;
 ;;Vaccine Source - VFC or non-VFC.  Note: If there are two issues of the
 ;;    same lot, and one issue is VFC and the other is not VFC, it may
 ;;    be helpful the create a new lot for the VFC issue and give it the
 ;;    same lot number but append "-vfc" to the end.  This way, the two
 ;;    issues can be tracked, inventoried, and reported on separately
 ;;    (yet easily identified by the common, original lot number).
 ;;
 ;;Low Supply Alert - During entry of immunizations, if the number of Unused
 ;;    Doses falls below the Low Supply Alert for this Lot Number, an alert
 ;;    will be displayed.
 ;;
 ;;Health Care Facility - Adding a Health Care Facility to a Lot Number will
 ;;    will cause that Lot Number to become unavailable for any user who is
 ;;    NOT logged on to the named Facility.
 ;;
 ;;    In general, there is NO NEED to assign Lot Numbers to specific
 ;;    Facilities.  However, if more than one Facility uses the same
 ;;    computer (dialing in from remote sites), then it may be desirable
 ;;    to assign Lot Numbers to specific Facilities. That way, users from
 ;;    another Facility will be prevented from erroneously using a Lot
 ;;    Number that is not at their Facility.
 ;;
 ;;    In cases where a Lot Number is truly shared by multiple Facilities
 ;;    all using the same computer, it may be desirable to create "sub-Lots"
 ;;    by appending "-a", "-b", "-c", etc. to the Lot Number.  For example,
 ;;    Facility A would get "#1234-a", Facility B would get "#1234-b",
 ;;    Facility C would get "#1234-c", and so on.
 ;;
 ;;    This would enable the manager or pharmacist to assign a Starting Amount
 ;;    for each "sub-Lot" to each Facility and ensure that the inventory at
 ;;    each site individually is accurate.
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
 ;;This option will automatically INACTIVATE ALL Lot Numbers that
 ;;have EXPIRED (an Expiration Date prior to today).
 ;;
 ;;It will also automatically INACTIVATE ALL Lot Numbers that have
 ;;NO Expiration Date (as viewed in the Lot Number Table).
 ;;
 ;;   Note: You can REACTIVATE any Lot Number individually at any time
 ;;   by editing the Lot Number individually from the Edit Lot Numbers
 ;;   Screen (and resetting the Active Field for that Lot Number).
 ;;
 ;;Do you wish to INACTIVATE ALL Lot Numbers that either have EXPIRED
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
 ;;Please confirm that you wish Inactivate all Lot Numbers that
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
 K ^TMP("BILOT",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
