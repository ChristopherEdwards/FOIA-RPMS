XB1 ; IHS/ADC/GTH - XB MENUS AND DOCUMENTATION ; [ 12/29/2004  11:11 AM ]
 ;;3.0;IHS/VA UTILITIES;**8,9,10**;FEB 07, 1997
 ; XB*3*9 IHS/SET/GTH XB*3*9 10/29/2002 Cache' mods.
 ;
 ; Each label represents a menu.  The label must begin with
 ; "M" and be followed by 1 or more 1 digit numbers 1-9.
 ; Each digit represents the link # of the parent option.
 ; E.G. 'M1' is the label for submenu options for the main
 ; menu option with a link # of 1.  'M11' would be the label
 ; for subsubmenu options for the option in 'M1' with a link
 ; # of 1.  Within a menu options are listed and selected
 ; positionally.  The only purpose of the link # is to link
 ; options to their parent menu.  Example:
 ;
 ; M1  ;;FILES/DICTIONARIES
 ;     ;;Submenu example one;;1
 ;     ;;Submenu example two;;2
 ; M11 ;;SUBMENU ONE
 ;     ;;Submenu option;;^ROUTINEX
 ; M12 ;;SUBMENU TWO
 ;     ;;Submenu option;;^ROUTINEY
 ;
 ; This label naming technique allows the menu tree to go
 ; to seven levels.  No more than nine options on one menu
 ; may also be menus.
 ;
 ; For menu options the 2nd ";;" piece is the title, the 3rd
 ; ";;" piece must be a number if the option is a submenu, a
 ; valid routine or label^routine or executable code if the
 ; 3rd piece begins with a !.  The code following the ! will
 ; be placed in a variable and the variable will be executed.
 ; A P in the 4th ";;" piece indicates pause after execution.
 ;
M ;;MAIN XB UTILITY MENU
 ;;Files/dictionaries;;1
 ;;Globals;;2
 ;;Routines;;3
 ;;Miscellaneous;;4
 ;;Developers;;5
 ;;Check ^XB options and patch level;;CHECK^XB;;P;;IHS/SET/GTH XB*3*9 10/29/2002
M1 ;;FILES/DICTIONARIES
 ;;List fields;;^XBFLD
 ;;List 0th nodes;;^XBLZRO;;P
 ;;Check regular xrefs;;^XBCFXREF;;P
 ;;Selective RE-INDEX;;^XBRXREF
 ;;Compare dictionary in two UCIs/Namespaces;;^XBFCMP;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Search for routines executed from dictionary;;^XBRSRCH
 ;;Fix 0th nodes;;^XBCFIX;;P
 ;;Count entries in file;;^XBCOUNT
 ;;FileMan;;P^DI
 ;;Delete dictionaries;;^XBKD
 ;;Clean dictionaries [caution];;^XBCDIC
 ;;List file attributes in various ways;;1;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Files Marked For Deletion;;!N L,DIC,BY,FLDS S L=0,DIC=1,(BY,FLDS)="[XB - FILES MARKED FOR DELETION]" D EN1^DIP;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Fields Marked For Deletion;;^XBLFMD;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Print File IDs, Specifiers, and Conditionals;;^XBSIC;;P;;IHS/SET/GTH XB*3*9 10/29/2002
M11 ;;LIST FILE ATTRIBUTES IN VARIOUS WAYS;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;List Files, inc. Number, Name, Global, opt Desc.;;^XBLFD;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;List Fields for RIM Modeling;;^XBLFAM;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;List Fields for CodeSets (RTM) Modeling;;^XBLFSETS;;P;;IHS/SET/GTH XB*3*9 10/29/2002
M2 ;;GLOBALS
 ;;List global;;!D LG^ZIBVSS
 ;;Directory of selected globals;;^ZIBGD;;P
 ;;Count unique values;;^XBCNODE
 ;;List high entry number;;^XBGLDFN;;P
 ;;Copy to another global in same UCI/Namespace;;^XBGC;;;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Copy global to another UCI/Namespace;;!D CG^ZIBVSS;;;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Search global for value;;!D GSE^ZIBVSS
 ;;Global edit;;!D GE^ZIBVSS
 ;;Change global value;;!D GCH^ZIBVSS
 ;;Global size/efficiency;;!D GSZE^ZIBVSS;;P
 ;;Global characteristics;;!D GCHR^ZIBVSS
 ;;Global delete;;!D GDEL^ZIBVSS
 ;;Global restore;;!D GR^ZIBVSS
 ;;Global save;;!D GS^ZIBVSS
 ;;Find control chrs in globals;;^ZIBGCHR
 ;;Compare Two Globals;;^XBGCMP
M3 ;;ROUTINES
 ;;List routines in various ways;;1
 ;;Compare routines in two UCIs/Namespaces;;!D RCMP^ZIBVSS;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Restore routines;;!D RR^ZIBVSS
 ;;Save routines;;!D RS^ZIBVSS
 ;;Routine size;;^XBRSIZ;;P
 ;;Delete routines;;!D RDEL^ZIBVSS;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Search routines for values (OR);;!D RSE^ZIBVSS;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Search routines for values (AND);;!D RSAND^ZIBVSS
 ;;Find routines by edit date;;!D NEWED^ZIBVSS;;P
 ;;Full screen editor;;!D REDIT^ZIBVSS
 ;;Routine change;;!D RCHANGE^ZIBVSS
 ;;Routine copy;;!D RCOPY^ZIBVSS
 ;;Directory of selected routines;;^ZIBRD;;P
 ;;Scan UCIs/Namespaces for routine;;^ZIBFR;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Run routine;;!R "  Enter routine name: ",Y:30 Q:'$T  S:Y'["^" Y="^"_Y S X=$P(Y,"^",2),X=$P(X,"(",1) X ^%ZOSF("TEST") W:'$T "  huh? ",*7 I $T D @Y
M31 ;;LIST ROUTINES
 ;;List first one/two lines;;^%ZTP1;;P
 ;;List to first label;;^XBRPTL;;P
 ;;List routines;;!D RPRT^ZIBVSS;;P
 ;;List routines by edit date;;^XBRPRTBD
 ;;VA routine lister;;^%ZTPP;;P
 ;;List one routine with character counts;;^XBRLL;;P
 ;;%INDEX;;^%INDEX
 ;;Flow chart from entry point;;^XTFCE
 ;;Flow chart entire routine;;^XTFCR
 ;;List routines by patch number;;^XBPATSE;;P
M4 ;;MISCELLANEOUS
 ;;Error report;;!D ER^ZIBVSS;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;List ^UTILITY nodes for current job;;^XBLUTL;;P
 ;;Kill ^UTILITY nodes for current job;;^%ZIBCLU0
 ;;Cleanup utility globals in all UCIs;;EN^ZIBCLU
 ;;Cleanup utility globals in current UCI;;EN^%ZIBCLU0
 ;;Fix 'PT' nodes in all files;;^XBFIXPT
 ;;Convert non-DINUM data global to DINUM;;^XBDINUM
 ;;Check UCI routines against package file;;^ZIBCKPKG;;P
 ;;Display FileMan installation data;;^ZIBFMD;;P
 ;;Renamespace routines;;^ZIBRNSPC;;P
 ;;Number base changer;;^XTBASE
 ;;Print a Help Frame manual;;^XBHFMAN
 ;;List Local Variables, by Namespace;;MESSAGE^XBVL;;P
 ;;Print XB/ZIB Technical Manual;;^XBTM
 ;;Check Patient Globals;;^XBPATC;;P
M5 ;;DEVELOPERS
 ;;Generate ^DIR call;;^XBDR;;P
 ;;Standardize line 1 of routines;;^XBFIXL1
 ;;Set version line;;^XBVLINE
 ;;Set dictionary version numbers;;^XBDICV;;P
 ;;Set no delete;;^XBNODEL;;P
 ;;Set audit;;^XBSAUD;;P
 ;;Set authorities;;^XBSAUTH;;P
 ;;Analyze file for specifiers;;^XBCSPC
 ;;Delete namespaced OPTIONS, KEYS, etc.;;RUN^XBPKDEL;;P
 ;;List namespaced OPTIONS, KEYS, etc.;;LIST^XBPKDEL;;P
 ;;Build pre-init routine;;^XBBPI
 ;;Build integ routine;;^XBSUMBLD
 ;;List callable subroutines;;^XBLCALL;;P
 ;;Reset file data globals *** DANGER ***;;^XBFRESET
 ;;Edit FM print template headers;;^XBDH
 ;;List retired/replaced packages;;LIST^XBPKDEL1;;P;;XB*3*8
 ;;Delete retired/replaced packages;;DECERT^XBPKDEL1;;P;;XB*3*8
 ;;Edit File attribute for selected File(s);;^XBDDEDIT;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Move files into PACKAGE file FILE multiple;;^XBPKG;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Set dd audit;;^XBSDDAUD;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;dd Field Numbering Conventions;;^XBFNC;;P;;IHS/SET/GTH XB*3*9 10/29/2002
 ;;Options and Security Keys;;^XBSECK;;P;;IHS/SET/GTH XB*3*9 10/29/2002
