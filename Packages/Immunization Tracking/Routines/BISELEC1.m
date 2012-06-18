BISELEC1 ;IHS/CMI/MWR - GENERIC SELETION UTILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  LISTMANAGER DRIVER ROUTINE FOR GENERIC SELECTION UTILITY.
 ;
 ;
 ;----------
START(BIARR1,BIGBL,BIITEMS,BITITEMS,BIPIECE,BISCRN,BIID,BICOL,BIFLD,BIPOP) ;EP
 ;---> Call Listmanager to select a list of Items.
 ;---> Parameters:
 ;     1 - BIARR1  (req) Selection Array (local).
 ;     2 - BIGBL   (req) Lookup global.
 ;     3 - BIITEMS (req) Catagoric name of Items being selected.
 ;     4 - BITITEMS (req) Title name of selected Items.
 ;     5 - BIPIECE (req) Piece of zero node to display as ItemName.
 ;     6 - BISCRN  (opt) Screen used in selection lookup.
 ;     7 - BIID    (opt) Identifier and code.
 ;     8 - BICOL   (opt) Column header text.
 ;     9 - BIFLD   (opt) Field# in BIFILE with Set of Codes to select.
 ;    10 - BIPOP   (ret) BIPOP, =1 if quit or error.
 ;
 ;
 ;---> New VALMQUIT so that quit from "ENTIRE1^BISELEC2" will work but
 ;---> will not cause the calling/parent instance of Listman to quit also.
 D SETVARS^BIUTL5 N VALMQUIT
 S BIPOP=0
 D EN^VALM("BI GENERIC SELECTION")
 D FULL^VALM1
 D EXIT
 Q
 ;
 ;
 ;----------
HDR ;EP
 ;---> Header code.
 N X,Y
 S VALMHDR(1)=""
 S X="   Select one or more "_BITITEMS_":"
 S VALMHDR(2)=X
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 K ^TMP("BILMGS",$J),^TMP("BILMGS1",$J),^TMP("BILMGS2",$J)
 ;
 ;---> Check for necessary variables present.
 I $$CHECK^BISELECT() S BIPOP=1,VALMQUIT="" Q
 ;
 ;---> *** SET OF CODES
 ;---> If this is a Set of Codes, go to INIT1, then QUIT.
 I +$G(BIFLD) D INIT1 Q
 ;
 ;---> Continue with selection from a file.
 I '$O(@(BIARR1_"(0)")) S VALMCNT=0 Q
 ;
 ;---> Set Lower Frame Bar and Screen Title.
 S VALMSG="Type ?? for more actions."
 ;S VALM("TITLE")="Select "_BIITEMS
 ;
 ;---> Set Column Header line.
 D:$G(BICOL)]""
 .S VALMCAP=$$PAD^BIUTL5(BICOL,80)
 ;
 ;---> Convert IEN-sorted array to ItemName-sorted array.
 ;---> This will present Items in a numbered list, 1,2,3...,
 ;---> with the Item names in alphabetical order, so the user
 ;---> can search the list of Items in order.
 ;
 ;---> First, build array sorted by ItemName.
 N BIIEN S BIIEN=0
 F  S BIIEN=$O(@(BIARR1_"(BIIEN)")) Q:'BIIEN  D
 .;
 .;---> If IEN passed does not really exist in the File,
 .;---> remove it from the Selection Array.
 .I '$D(@(BIGBL_"BIIEN,0)")) K @(BIARR1_"(BIIEN)") Q
 .;
 .;---> If (previously stored) IEN does not pass the screen,
 .;---> then remove it from the Selection Array.
 .I BISCRN]"" N Y S Y=BIIEN X BISCRN I '$T K @(BIARR1_"(BIIEN)") Q
 .;
 .N BI0,BINAME,BIIDTX
 .S BI0=@(BIGBL_"BIIEN,0)")
 .S BINAME=$P(BI0,U,BIPIECE)
 .Q:BINAME=""
 .;
 .;---> Set Identifer if passed.
 .D:BIID]""
 ..;---> BIID Identifier: Three pieces delimited by ";".
 ..;                      1st piece = the "^" piece of 0 node to get X.
 ..;                      2nd piece = Code to set X=text of identifier.
 ..;                      3rd piece = Tab for identfier in Listman.
 ..;
 ..;---> Get piece (BIPC) of zero node that holds Identifier data.
 ..N BIPC,X S BIPC=$P(BIID,";")
 ..Q:'BIPC
 ..;---> Get Identifier data.
 ..S X=$P(BI0,U,BIPC)
 ..Q:X=""
 ..;---> Xecute code to process X (return ID text in X).
 ..;---> If there is no code, then value of X is displayed unchanged.
 ..X $P(BIID,";",2)
 ..S BIIDTX=X
 ..Q:BIIDTX=""
 ..;---> Tab out to specified column.
 ..N BITAB S BITAB=$P(BIID,";",3)
 ..N BIADD S BIADD=BITAB-($L(BINAME)+5)
 ..;---> Minimum of 2 spaces between Name and Identifier.
 ..S:BIADD<1 BIADD=2
 ..S BIIDTX=$$SP^BIUTL5(BIADD)_BIIDTX
 .;
 .;---> Each node=IEN of Item_^_ItemName.
 .;---> The array will be sorted alphabetically by ItemName.
 .;---> Append IEN to ItemName to include legitimate duplicate names.
 .S ^TMP("BILMGS1",$J,BINAME_BIIEN)=BIIEN_U_BINAME_$G(BIIDTX)
 ;
 ;
 ;---> Now, convert ItemName-sorted array to Item-numbered array.
 N I,N S N=0
 F I=1:1 S N=$O(^TMP("BILMGS1",$J,N)) Q:N=""  D
 .S ^TMP("BILMGS2",$J,I)=^TMP("BILMGS1",$J,N)
 ;
 ;---> Insert blank line at the top of the List Region.
 S ^TMP("BILMGS",$J,1,0)=""
 S ^TMP("BILMGS",$J,"IDX",1,1)=""
 ;
 ;---> Set each Item (or previously) selected into the array.
 N N S N=0
 F  S N=$O(^TMP("BILMGS2",$J,N)) Q:'N  D
 .;---> Build display line for this Item.
 .N X
 .S X="  "_$J(N,3)_"  "_$P(^TMP("BILMGS2",$J,N),U,2)
 .;
 .;---> Set formatted Item line and index in ^TMP.
 .S ^TMP("BILMGS",$J,N+1,0)=X
 .S ^TMP("BILMGS",$J,"IDX",N+1,N)=""
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=I
 I VALMCNT>13 D
 .S VALMSG="Scroll down to view more.  Type ?? for more actions."
 Q
 ;
 ;
 ;----------
INIT1 ;EP
 ;
 I $O(@(BIARR1_"(0)"))="" S VALMCNT=0 Q
 ;
 ;---> Set Lower Frame Bar and Screen Title.
 S VALMSG="Type ?? for more actions."
 ;S VALM("TITLE")="Select "_BIITEMS
 ;
 ;---> Set Column Header line.
 D:$G(BICOL)]""
 .S VALMCAP=$$PAD^BIUTL5(BICOL,80)
 ;
 ;---> Convert CODE-sorted array to CodeName-sorted array.
 ;---> This will present Items in a numbered list, 1,2,3...,
 ;---> with the Item names in alphabetical order, so the user
 ;---> can search the list of Items in order.
 ;
 Q:'$D(^DD(BIFILE,BIFLD,0))
 N BISET S BISET=$P(^DD(BIFILE,BIFLD,0),U,3)
 ;
 ;---> First, build array sorted by Code.
 N BICODE S BICODE=0
 F  S BICODE=$O(@(BIARR1_"(BICODE)")) Q:BICODE=""  D
 .;
 .;---> If the Code does not really exist in the Set of Codes,
 .;---> remove it from the Selection Array.
 .I BISET'[BICODE_":" K @(BIARR1_"(BICODE)") Q
 .;
 .N BICODNM
 .S BICODNM=$P($P(BISET,BICODE_":",2),";")
 .;
 .;---> The array will be sorted alphabetically by CodeName.
 .;---> Append Code to CodeName to include legitimate duplicate names.
 .S ^TMP("BILMGS1",$J,BICODNM_BICODE)=BICODE_U_BICODNM
 ;
 ;---> Now, convert ItemName-sorted array to Item-numbered array.
 N I,N S N=0
 F I=1:1 S N=$O(^TMP("BILMGS1",$J,N)) Q:N=""  D
 .S ^TMP("BILMGS2",$J,I)=^TMP("BILMGS1",$J,N)
 ;
 ;---> Insert blank line at the top of the List Region.
 S ^TMP("BILMGS",$J,1,0)=""
 S ^TMP("BILMGS",$J,"IDX",1,1)=""
 ;
 ;---> Set each Item (or previously) selected into the array.
 N N S N=0
 F  S N=$O(^TMP("BILMGS2",$J,N)) Q:'N  D
 .;---> Build display line for this Item.
 .N X,Y
 .S Y=^TMP("BILMGS2",$J,N)
 .S X="  "_$J(N,3)_"  "_$$PAD^BIUTL5($P(Y,U,2),32)_$P(Y,U)
 .;
 .;---> Set formatted Item line and index in ^TMP.  Also, save
 .;---> "Left Column Number" and its corresponding Code, for deletions.
 .S ^TMP("BILMGS",$J,N+1,0)=X
 .S ^TMP("BILMGS",$J,"IDX",N+1,N)=""
 ;
 ;---> Finish up Listmanager List Count.
 S VALMCNT=I
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
 D INIT,HDR
 Q
 ;
 ;
 ;----------
HELP ;EP
 ;----> Help text display when "?" is entered.
 N BIXX S BIXX=$S($G(BIITEMS)="":"Items",1:BIITEMS)
 D EN^XBNEW("HELP1^BISELEC1","VALM*;IO*;BIXX")
 D RESET
 Q
 ;
 ;
 ;----------
HELP1 ;EP
 ;---> Display Help Text in Listmanager.
 ;
 ;---> Set Help Text into local array.
 N BITEXT D TEXT1(.BITEXT)
 ;---> Insert the passed Item Name into the Help Text array.
 N N S N=0
 F  S N=$O(BITEXT(N)) Q:'N  D
 .Q:BITEXT(N)'[" BIXX"
 .N X S X=$P(BITEXT(N),"BIXX")_BIXX_$P(BITEXT(N),"BIXX",2),BITEXT(N)=X
 ;
 D START^BIHELP("LIST SELECTION UTILITY - HELP",.BITEXT)
 Q
 ;
 ;
 ;----------
TEXT1(BITEXT) ;EP
 ;;This allows you to select and build a list of BIXX
 ;;for your report.  The following four actions are available:
 ;;
 ;;ADD...: Use this to select BIXX from the file of
 ;;        BIXX and add them to your list.
 ;;
 ;;DELETE: Use this to remove items from your list.
 ;;
 ;;ENTIRE: Use this to add ALL items from the file to your list.
 ;;        This may be useful if you want to select MOST of the items
 ;;        in the file by adding all and then deleting the few items
 ;;        you do not want.  This will only work for up to 300 items.
 ;;        If the file contains more than 300 items, it will simply add
 ;;        ALL items and quit.
 ;;
 ;;CLEAR.: Use this to remove all items from your list (and start over).
 ;;
 ;;Your personal list of BIXX will be saved each time
 ;;you build it.  Whenever you return to this list, the previous
 ;;list of BIXX you built will be presented as a
 ;;default list.
 ;;
 D LOADTX("TEXT1",,.BITEXT)
 Q
 ;
 ;
 ;----------
EXIT ;EP
 K ^TMP("BILMGS",$J),^TMP("BILMGS1",$J),^TMP("BILMGS2",$J),^TMP("BILMGS3",$J)
 D CLEAR^VALM1
 Q
 ;
 ;
 ;----------
LOADTX(BILINL,BITAB,BITEXT) ;EP
 Q:$G(BILINL)=""
 N I,T,X S T="" S:'$D(BITAB) BITAB=5 F I=1:1:BITAB S T=T_" "
 F I=1:1 S X=$T(@BILINL+I) Q:X'[";;"  S BITEXT(I)=T_$P(X,";;",2)
 Q
