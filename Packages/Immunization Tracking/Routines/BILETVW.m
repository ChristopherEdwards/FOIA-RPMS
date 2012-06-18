BILETVW ;IHS/CMI/MWR - VIEW/EDIT FORM LETTERS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW/EDIT FORM LETTERS.
 ;
 ;----------
START ;EP
 ;---> Lookup and edit Form Letters in the file BI LETTER.
 D SETVARS^BIUTL5 N BIY
 F  D  Q:$G(BIY)<1
 .D TITLE^BIUTL5("VIEW/EDIT FORM LETTERS"),TEXT3
 .N BIIEN
 .D DIC^BIFMAN(9002084.4,"QEMAL",.BIY,"     Select Form Letter: ")
 .Q:$G(BIY)<1
 .S BIIEN=+BIY
 .;---> If this is a new letter, select and copy  Sample Form Letter.
 .D:$P(BIY,U,3) ADDNEW^BILETVW2(.BIIEN)
 .;---> Quit if Sample Form Letter not selected (new IEN deleted).
 .Q:'$G(BIIEN)
 .D EN(+BIIEN)
 D EXIT
 Q
 ;
 ;
 ;----------
HAVELET(BIIEN) ;EP
 ;---> NOT CALLED AT THIS TIME?  8/9/99
 ;---> Entry point when letter is already known.
 D SETVARS^BIUTL5
 K ^TMP("BILMLT",$J)
 D EN(BIIEN),EXIT
 Q
 ;
 ;
 ;----------
EN(BIIEN) ;EP
 ;---> Main entry point for BI LETTER VIEW/EDIT.
 ;---> If BIIEN not supplied, set Error Code and quit.
 I '$G(BIIEN) D ERRCD^BIUTL2(609,,1) Q
 D EN^VALM("BI LETTER FORM")
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code.
 N X S X="Form Letter: "_$P(^BILET(BIIEN,0),U)
 D CENTERT^BIUTL5(.X)
 S VALMHDR(1)=""
 S VALMHDR(2)=X
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 D INIT^BILETVW1
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
RESET2 ;EP
 ;---> Update partition without recreating display array.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1 N BIPOP
 D TITLE^BIUTL5("FORM LETTER EDIT - HELP, page 1 of 2")
 D TEXT1,DIRZ^BIUTL3(.BIPOP)
 I $G(BIPOP) D RE^VALM4 Q
 D TITLE^BIUTL5("FORM LETTER EDIT - HELP, page 2 of 2")
 D TEXT2,DIRZ^BIUTL3()
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
TEXT1 ;EP
 ;;The Form Letter Edit Screen allows you to customize Form Letters.
 ;;
 ;;The TOP section of the screen displays the name of the Form Letter.
 ;;
 ;;The MIDDLE section of the letter displays the body of the letter
 ;;in a scrollable region.  Use the up and down arrow keys to view
 ;;all parts of the letter.
 ;;
 ;;The BOTTOM section of the screen lists actions you can take to
 ;;edit secions of the letter or to print or delete the letter.
 ;;
 ;;Fields in the letter are signified by uppercase text within vertical
 ;;bars, such as |PATIENT NAME|.  These Fields may be moved within the
 ;;letter or they may be deleted.   However, the text within the
 ;;vertical bars must NOT be altered.
 ;;
 D PRINTX("TEXT1")
 Q
 ;
 ;
 ;----------
TEXT2 ;EP
 ;;A Form Letter may contain up to 7 Sections.  Each section is
 ;;represented by an Action at the bottom of the screen: Top, History,
 ;;Middle, Forecast, Bottom, Date/Loc, and Closing.
 ;;
 ;;When selected, some Sections take you to the word processor in order
 ;;to allow you to edit the section. (Your Preferred Editor should be
 ;;"Full Screen" for this; if not, contact your Site Manager.)
 ;;
 ;;Other Sections provide helpful information when they are selected.
 ;;
 ;;In order to add a NEW Form Letter, simply enter a name for the
 ;;new letter at the very first prompt, "Select Form Letter: ".
 ;;A generic sample letter will then appear under the newly named Form
 ;;Letter, which you can then edit to suit the intended purposes.
 ;;
 D PRINTX("TEXT2")
 Q
 ;
 ;
 ;----------
TEXT3 ;EP
 ;;This screen will allow you to add and edit Form Letters.
 ;;
 ;;Please select a Form Letter, or enter the name of a new Form Letter
 ;;you wish to add.  (Enter "?" to see a list of existing Form Letters.)
 ;;
 D PRINTX("TEXT3")
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
 D KILLALL^BIUTL8(1)
 K ^TMP("BILMLT",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
