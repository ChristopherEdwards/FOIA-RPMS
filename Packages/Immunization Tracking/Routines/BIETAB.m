BIETAB ;IHS/CMI/MWR - VIEW ERROR CODE TABLE; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW BI TABLE ERROR CODE THROUGH LISTMANAGER.
 ;;  NOT CALLED FROM MENUS, PROGRAMMER USE.
 ;
 ;----------
START ;EP
 ;---> Display Error Code table.
 ;
 D SETVARS^BIUTL5
 D EN
 D EXIT
 Q
 ;
 ;
 ;----------
EN ;EP
 D EN^VALM("BI TABLE ERROR CODE VIEW")
 Q
 ;
 ;
 ;----------
INIT ;EP
 ;---> Initialize variables and list array.
 N N,I
 S N=0
 F I=1:1 S N=$O(^BIERR(N)) Q:'N  D
 .S ^TMP("BIETAB",$J,I,0)="  "_N_"  "_$P(^BIERR(N,0),U,2)
 S VALMCNT=I-1
 Q
 ;
 ;
 ;----------
RESET ;EP
 ;---> Update partition for return to Listmanager.
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 D INIT Q
 ;
 ;
 ;----------
HELP ;EP
 ;---> Help code.
 N BIX S BIX=X
 D FULL^VALM1
 W !!?5,"Use arrow keys to scroll up and down through the list, or"
 W !?5,"enter ""A"", then an Error Code Number in order  to Add, Edit"
 W !?5,"or Delete an Error Code, or"
 W !?5,"type ""??"" for more actions, such as Search and Print List."
 D DIRZ^BIUTL3("","     Press ENTER/RETURN to continue")
 D:BIX'="??" RE^VALM4
 Q
 ;
 ;
 ;----------
EXIT ;EP
 ;---> Cleanup, EOJ.
 D KILLALL^BIUTL8()
 K ^TMP("BIETAB",$J)
 D CLEAR^VALM1
 D FULL^VALM1
 Q
 ;
 ;
 ;----------
ADDEDEL ;EP
 ;---> Add/Edit/Delete Error Codes.
 ;
 D FULL^VALM1
 D TITLE^BIUTL5("ADD/EDIT/DELETE ERROR CODES")
 W !!?3,"This is your big chance to add/edit/delete Error Codes!",!!
 N Y
 D DIC^BIFMAN(9002084.33,"QEMAL",.Y,"   Select ERROR CODE: ")
 I Y<1 D RESET Q
 S DR=".01;.02;.03"
 D DIE^BIFMAN(9002084.33,DR,+Y)
 D RESET
 Q
