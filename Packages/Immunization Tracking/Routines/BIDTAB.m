BIDTAB ;IHS/CMI/MWR - VIEW DATA ELEMENTS; MAY 10, 2010
 ;;8.5;IMMUNIZATION;;SEP 01,2011
 ;;* MICHAEL REMILLARD, DDS * CIMARRON MEDICAL INFORMATICS, FOR IHS *
 ;;  VIEW DATA ELEMENTS, NOT CALLED BY MENUS, PROGRAMMER ONLY.
 ;
 ;
 ;---> Select Data Elements, if ASCII.
 N BIIT S BIIT="Data Element"
 N BICOL S BICOL="    #  Data Element                       IEN"
 ;N BIID S BIID="3;S X=X_""   IEN: ""_BIIEN;40"
 N BIID S BIID="1;S X=BIIEN;40"
 D SEL^BISELECT(9002084.91,"BIDE",BIIT,,,,BIID,BICOL,.BIPOP,1)
 Q
 ;
 ;
 ;**** CODE BELOW SHOULD BE USED TO CREATE PROPER LIST TEMPLATE.
 ;**** For now, at least, it displays all Error Codes in a List.
 ;----------
START ;EP
 ;---> Display Error Code table.
 ;
 D SETVARS^BIUTL5
 D EN
 Q
 ;
 ;
 ;----------
EN ;EP
 ;---> Main entry point for option BI VACCINE TRANSLATION TABLE VIEW.
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
 D:BIX'="??" DIRZ^BIUTL3("","     Press ENTER/RETURN to continue"),RE^VALM4
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
 S DR=".01;.02"
 D DIE^BIFMAN(9002084.33,DR,+Y)
 D RESET
 Q
