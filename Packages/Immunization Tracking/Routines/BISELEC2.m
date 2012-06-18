BISELEC2 ;IHS/CMI/MWR - GENERIC SELECTION UTILITY; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  ADD AND DELETE ITEMS IN THE SELECTION ARRAY.
 ;
 ;
 ;----------
ADDITEM ;EP
 ;---> Add an Item to the Selection Array via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI GEN SELECT ADD, an action on the List Manager
 ;               menu protocol: BI MENU GEN SELECT.
 ;
 ;            2) This code calls ^DIC for the user to lookup and
 ;               and select Items in the file/global @BIGBL.
 ;
 ;            3) The IEN of the selected Item is then stored as
 ;               as a subscript in the Selection Array, @BIARR1.
 ;
 Q:$$CHECK^BISELECT()
 ;
 ;---> Call to select Item from File.
 N BIART S BIART=$S("AEIOU"[$E(BIITEM):"an ",1:"a ")
 D FULL^VALM1,TITLE^BIUTL5("Select "_BIART_BIITEM)
 ;
 ;---> Checks.
 I '$G(BIFILE) D ERRCD^BIUTL2(607,,1) Q
 I '$D(^DD(BIFILE)) D ERRCD^BIUTL2(608,,1) Q
 I '$D(@(BIGBL_"0)")) D ERRCD^BIUTL2(601,,1) Q
 ;
 N Y
 D
 .;---> If this is a Set of Codes, make selection and quit.
 .I $G(BIFLD) D  Q
 ..N BISET S BISET=$P(^DD(BIFILE,BIFLD,0),U,3)
 ..D DIR^BIFMAN("SOM"_U_BISET,.Y)  ;,"   Select "_BIITEM_": ")
 ..;---> Set selected Item IEN into Selection Array.
 ..S:((Y'="")&(Y'="^")) @(BIARR1_"(Y)")=""
 .;
 .;---> Select from a File.
 .D DIC^BIFMAN(BIGBL,"QEMA",.Y,"   Select "_BIITEM_": ",,BISCRN)
 .;---> Set selected Item IEN into Selection Array.
 .S:+Y>0 @(BIARR1_"(+Y)")=""
 ;
 D RESET^BISELEC1
 Q
 ;
 ;
 ;----------
ENTIRE ;EP
 ;---> Add Entire File of Items or Set of Codes to the Selection Array.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI GEN SELECT ENTIRE, an action on the List Manager
 ;               menu protocol: BI MENU GEN SELECT.
 ;
 ;            2) If BIFIELD (a Field#) exists, load the entire Set of Codes.
 ;               If the selection is from a File, this code evaluates the size
 ;               of the entire global and determines if it is >300 entries.
 ;               If so, then it returns @BIARR1("ALL") and quits Listmanager.
 ;
 ;            3) If the entire global is <300 entries, this code
 ;               loops through the file global, evaluating entries
 ;               against the screen, if there is a screen.
 ;
 ;            4) The IEN of each Item is then stored as
 ;               as a subscript in the Selection Array, @BIARR1.
 ;
 Q:$$CHECK^BISELECT()
 K @(BIARR1)
 S @(BIARR1_"(""ALL"")")=""
 ;
 D
 .;---> If this is a Set of Codes, set all Codes in Selection Array and quit.
 .I $G(BIFLD) D  Q
 ..N BISET S BISET=$P(^DD(BIFILE,BIFLD,0),U,3)
 ..N I,X
 ..F I=1:1 S X=$P(BISET,";",I) Q:X=""  D
 ...N Y S Y=$P(X,":") S:Y]"" @(BIARR1_"(Y)")=""
 .;
 .;---> This is a selection from a File.
 .;---> If entire file is too large for local partition,
 .;---> do ENTIRE1 and quit.
 .I $P(@(BIGBL_"0)"),U,4)>300 D ENTIRE1 Q
 .;
 .;---> Entire file is small enough to store and display locally.
 .;---> Load each entry into Selection Array for review.
 .;---> Screen, if there is one, applies.
 .;
 .;
 .N BIIEN,I S BIIEN=0
 .F I=1:1 S BIIEN=$O(@(BIGBL_"BIIEN)")) Q:'BIIEN  Q:I>300  D
 ..;---> Check screen.
 ..I BISCRN]"" N Y S Y=BIIEN X BISCRN Q:'$T
 ..;
 ..;---> Set Item IEN into Selection Array.
 ..S @(BIARR1_"(BIIEN)")=""
 .;
 .;---> Global had more than 300 entries.
 .I I>300 D ENTIRE1 Q
 ;
 D RESET^BISELEC1
 Q
 ;
 ;
 ;----------
ENTIRE1 ;EP
 ;---> Entire file of Items is too large to load and display
 ;---> in local partition.
 ;---> Set BIARR1("ALL"), inform user, tell Listman to quit.
 ;---> NOTE: A Screen will not apply here.  See documentation
 ;--->       top of ^BISELECT.
 ;
 ;
 D FULL^VALM1,TITLE^BIUTL5("Select Entire File of "_BIITEMS)
 W !!!?8,"NOTE: This file is too large to load for screen selection."
 W !?14,"Instead, the entire file (ALL Items) have been selected"
 W !?14,"automatically.",!!
 D DIRZ^BIUTL3()
 K @(BIARR1)
 S @(BIARR1_"(""ALL"")")=""
 S VALMBCK="Q"
 S VALMQUIT=""
 Q
 ;
 ;
 ;----------
DELITEM ;EP
 ;---> Delete an Item from the Selection Array via List Manager.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI GEN SELECT DELETE, an action on the List Manager
 ;               menu protocol: BI MENU GEN SELECT.
 ;
 ;            2) This code gets an Item from Listmanager and
 ;               deletes the Item from the Selection Array and the
 ;               ^TMP global.
 ;
 Q:$$CHECK^BISELECT()
 ;
 ;---> Call the Listmanager Generic Selector of Items displayed.
 N VALMY
 D EN^VALM2(XQORNOD(0),"OS")
 ;
 ;---> Check that a Listman Item was passed.
 I '$D(VALMY) D ERRCD^BIUTL2(406,,1) D RESET^BISELEC1 Q
 N Y S Y=$O(VALMY(0))
 I '$G(Y) D ERRCD^BIUTL2(406,,1) D RESET^BISELEC1 Q
 ;
 ;---> Now set Y=IEN of the Item to delete in the BIARR1 local array.
 S Y=$P($G(^TMP("BILMGS2",$J,Y)),U)
 I Y="" D ERRCD^BIUTL2(604,,1) D RESET^BISELEC1 Q
 ;
 ;---> If ALL/ENTIRE was previously selected, it is no longer valid,
 ;---> so kill it.
 K @(BIARR1_"(""ALL"")")
 ;---> Delete the Item from the Selection Array.
 K @(BIARR1_"(Y)")
 S BIPOP=""
 ;
 D RESET^BISELEC1
 Q
 ;
 ;
 ;----------
CLEARALL ;EP
 ;---> Clear/Delete ALL Items from the Selection Array.
 ;---> Steps:
 ;            1) This entry point is called by the Protocol:
 ;               BI GEN SELECT CLEAR ALL, an action on the List Manager
 ;               menu protocol: BI MENU GEN SELECT.
 ;
 ;            2) This code deletes ALL Items from Listmanager and
 ;               from the Selection Array and ^TMP global.
 ;
 Q:$$CHECK^BISELECT()
 ;
 ;---> Delete the Item from the Selection Array.
 K @(BIARR1)
 K ^TMP("BILMGS",$J),^TMP("BILMGS1",$J),^TMP("BILMGS2",$J)
 ;
 D RESET^BISELEC1
 Q
