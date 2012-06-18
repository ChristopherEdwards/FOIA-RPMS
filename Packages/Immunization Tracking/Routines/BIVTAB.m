BIVTAB ;IHS/CMI/MWR - VIEW VACCINE TRANSLATION TABLE; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW VACCINE TRANSLATION TABLE THROUGH LISTMANAGER.
 ;
 ;----------
START ;EP
 D SETVARS^BIUTL5 K ^TMP("BIVTAB",$J) N BITMP,DIR
 D EN
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for option BI REPORT VACCINE TRANSLAT.
 D EN^VALM("BI VACCINE TRANS TABLE VIEW")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code
 N BIDASH,BILINE,X,Y S BILINE=0
 D WH^BIW(.BILINE)
 S X=$$REPHDR^BIUTL6(DUZ(2)),BIDASH=$L(X)+2 D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 S X=$$SP^BIUTL5(BIDASH,"-") D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 S X="VACCINE TRANSLATION TABLE" D CENTERT^BIUTL5(.X)
 D WH^BIW(.BILINE,X)
 S X="  OLD"
 D WH^BIW(.BILINE,X)
 S X="  IHS   OLD            NEW HL7      HL7"
 D WH^BIW(.BILINE,X)
 S X="  CODE  SHORT NAME     SHORT NAME   CODE   NEW HL7 LONG NAME"
 D WH^BIW(.BILINE,X)
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 ;
 S VALMSG="Enter ?? for more actions."
 S VALM("TITLE")=" (Immunization v"_$$VER^BILOGO_")"
 ;
 N BIN,I
 ;
 S BIN=0
 F  S BIN=$O(^BITO(BIN)) Q:'BIN  D
 .N BI0,BIY S BI0=^BITO(BIN,0)
 .;---> Old IHS Code.
 .S BI0(1)=$P(BI0,U,3)
 .;---> Old Short Name.
 .S BI0(2)=$P(BI0,U,2)
 .;---> Get pointer to new HL7 Vaccine entry.
 .S BI0(3)=$P(BI0,U,20)
 .;---> New HL7 Short Name.
 .S BI0(4)=$$VNAME^BIUTL2(BI0(3))
 .;---> New HL7 Code.
 .S BI0(5)=$$CODE^BIUTL2(BI0(3))
 .;---> New HL7 Long Name.
 .S BI0(6)=$$VNAME^BIUTL2(BI0(3),1)
 .;
 .;---> Set formatted line in ^TMP for Listman to display.
 .S BIY="   "_BI0(1)_"   "_$$PAD^BIUTL5(BI0(2),15,".")
 .S BIY=BIY_$$PAD^BIUTL5(BI0(4),13,".")_$J(BI0(5),3)
 .S BIY=BIY_"    "_$E(BI0(6),1,36)
 .;
 .S BITMP("BIVTAB",BI0(2))=BIY
 ;
 S BIN=0
 F I=1:1 S BIN=$O(BITMP("BIVTAB",BIN)) Q:BIN=""  D
 .S ^TMP("BIVTAB",$J,I,0)=BITMP("BIVTAB",BIN)
 ;
 S VALMCNT=I-1
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
 D TITLE^BIUTL5("VACCINE TRANSLATION TABLE - HELP")
 D TEXT1,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;With the installation of Immunization v7.0, new vaccines were
 ;;added to the Vaccine Table and several non-standard vaccines were
 ;;translated to new standard names.  More importantly, the old IHS
 ;;Codes for vaccines were translated to their equivalent HL7 Codes.
 ;;
 ;;This list, the Vaccine Translation Table, shows how the old IHS
 ;;Vaccine Table on your computer was converted to the new HL7 Table.
 ;;The list DOES NOT contain all of the new vaccines that are now
 ;;in your Vaccine Table--it only shows how the old Vaccines were
 ;;translated to the new HL7 Vaccine Table.  (The entire new Vaccine
 ;;Table may be viewed/printed under the Manager Menu, MGR-->VAC.)
 ;;
 ;;It may be helpful to print this list, initially, for people who
 ;;were previously using the old IHS Codes for Data Entry.  This will
 ;;show them which HL7 Codes should now be used instead.
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
 ;---> End of job cleanup.
 K ^TMP("BIVTAB",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
