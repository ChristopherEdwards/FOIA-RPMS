BWPOST1 ;IHS/ANMC/MWR - POST-INIT ROUTINE ;11-Feb-2003 12:44;PLS
 ;;2.0;WOMEN'S HEALTH;**8**;MAY 16, 1996
 ;;* MICHAEL REMILLARD, DDS * ALASKA NATIVE MEDICAL CENTER *
 ;;  POSTINIT SUBROUTINE: DISPLAYS TEXT.
 ;
 ;
TEXT3 ;EP
 ;;OPTIONS:
 ;;--------
 ;;
 ;;The main menu option for the Women's Health package is BWMENU.
 ;;At most sites this would be placed on AKMOCORE along with other
 ;;RPMS packages.  For the sake of consistency from site to site,
 ;;it is recommended that the synonym "WH" (Women's Health) be
 ;;given to the main menu option BWMENU, however, this is not a
 ;;requirement.  BWMENU allows access to every other option within
 ;;the package.  (Keys: BWZMENU and BWZ MANAGER, see below.)
 ;;
 ;;The option BW MENU-LAB DATA ENTRY is a submenu that may be assigned
 ;;to Lab personnel for the limited purpose of accessioning PAP Smears
 ;;(and other procedures).  This option may be attached to any other
 ;;Kernel menu and need not be accessed via the main menu, BWMENU.
 ;;(Key: BWZ LAB PCD EDIT, see below.)
 ;;
 S BWTAB=5,BWLINL="TEXT3" D PRINTX
 Q
 ;
TEXT31 ;EP
 ;;OPTIONS (continued):
 ;;--------------------
 ;;
 ;;The option BW PATIENT PROFILE USER is an option for providers and
 ;;other users outside of the Women's Health program to display or print
 ;;the "Patient Profile" of a patient in the Women's Health database.
 ;;This option may be attached to any other Kernel menu and need not
 ;;be accessed via the main menu, BWMENU.  This option does not come
 ;;with a key, nor do users need any particular Fileman Access Code
 ;;in order to use it.
 ;;
 ;;NOTE: Be sure to select the option BW PATIENT PROFILE USER -- the
 ;;"USER" is important, as this option does not permit users to edit
 ;;the data.  Do NOT use the option BW PATIENT PROFILE for this purpose.
 ;;
 S BWTAB=5,BWLINL="TEXT31" D PRINTX
 Q
 ;
TEXT4 ;EP
 ;;SECURITY:
 ;;---------
 ;;
 ;;All users given the BWMENU (or the BW MENU-LAB DATA ENTRY) options
 ;;should be given File Manager Access Codes of "MW".
 ;;
 ;;The security key BWZMENU allows users to access the main menu of
 ;;the RPMS Women's Health package, BWMENU.  All users who are to use
 ;;the software for data entry, patient management, reports, etc.
 ;;should be given this key.
 ;;
 ;;The security key BWZ MANAGER allows managers to access the "Manager's
 ;;Functions" menu (BW MENU-MANAGER'S FUNCTIONS), which is a submenu of
 ;;the main menu (BWMENU).  The Manager's Functions menu provides access
 ;;to many sensitive functions and should only be given to the manager
 ;;of the program.
 ;;
 S BWTAB=5,BWLINL="TEXT4" D PRINTX
 Q
 ;
TEXT41 ;EP
 ;;SECURITY (continued):
 ;;---------------------
 ;;
 ;;The security key BWZ LAB PCD EDIT is for sites where the Lab
 ;;personnel (presumably not the same department as a Women's Health
 ;;Program) are accessioning PAP Smears and other procedures for the
 ;;Women's Health Program.  The Lab staff would receive the limited
 ;;submenu, BW-MENU LAB DATA ENTRY (described above under OPTIONS).
 ;;
 ;;On the LAB DATA ENTRY menu there is a special option that allows one
 ;;to go back and edit the RESULT of a procedure.  In general, this
 ;;option should only be used to enter a result of "ERROR/DISREGARD",
 ;;in order to cancel out procedures entered in error by lab staff.
 ;;Access to this option by the Lab Manager should be negotiated with
 ;;the Women's Health program people.  The key BWZ LAB PCD EDIT gives
 ;;the Lab Manager access to that option under the LAB DATA ENTRY menu.
 ;;
 S BWTAB=5,BWLINL="TEXT41" D PRINTX
 Q
 ;
 ;
TEXT5 ;EP
 ;;DEVICES:
 ;;--------
 ;;
 ;;This package makes extensive use of the VA Screen Manager,
 ;;which requires that several of the cursor and screen handling
 ;;fields of the Terminal Type file be present for any Device
 ;;accessing the package.  It is recommended that any Device
 ;;accessing this package be given a Terminal Type ("Subtype")
 ;;of "C-VT100", since the standard VA Kernel distribution comes
 ;;with all of the necessary codes pre-loaded.  A user whose Terminal
 ;;Type does not contain a complete set of screen handling codes will
 ;;receive a message that Screenman cannot "load the form."
 ;;
 ;;Other Terminal Types may also be chosen, however, the screen
 ;;handling codes for Cursor movements, "PF keys", "Erase Entire
 ;;Page", etc., may need to be entered manually if they are not
 ;;already present for the selected Terminal Type.
 ;;
 S BWTAB=5,BWLINL="TEXT5" D PRINTX
 Q
 ;
TEXT51 ;EP
 ;;DEVICES (continued):
 ;;--------------------
 ;;
 ;;If for some reason it is not practical to define Devices
 ;;accessing the package with a Subtype of C-VT100, users of the
 ;;package may be given a "DEFAULT TERMINAL TYPE FOR LM" in the
 ;;NEW PERSON File #200 of C-VT100. (They will then be given a
 ;;Terminal Type of C-VT100 regardless of which DEVICE they sign
 ;;on through.)  It may also be necessary to set the field "ASK
 ;;DEVICE TYPE AT SIGN-ON" (again in file #200) equal to "ASK" in
 ;;order to get a user's Terminal Type to change to the C-VT100.
 ;;
 ;;Initial difficulties with the screen handling codes for ScreenMan
 ;;are not specific to Women's Health; however, if problems with the
 ;;setup cannot be resolved, please contact Area support staff.
 ;;
 S BWTAB=5,BWLINL="TEXT51" D PRINTX
 Q
 ;
TEXT6 ;EP
 ;;OLD PAP TRACKING OPTIONS:
 ;;-------------------------
 ;;
 ;;In order to avoid confusion, it is advisable to remove any of
 ;;the old PAP Tracking Program options from the Kernel menus.
 ;;These old options appear as "AMCP/C/PAP..." and might be found
 ;;under the AMCHMENU and/or AMCHMAIN options.  Removal of the
 ;;AMCP/C/PAP options is NOT necessary in order to run the new
 ;;RPMS Women's Health software, it is only recommended.
 ;;
 S BWTAB=5,BWLINL="TEXT6" D PRINTX
 Q
 ;
TEXT8 ;EP
 ;;SITE PARAMETERS:
 ;;----------------
 ;;
 ;;As part of the installation of this new version of Women's Health,
 ;;the site parameters must be reviewed.  In particular, be sure to
 ;;look at page 2 and answer the "CDC Export:" and "Import Mammograms"
 ;;questions, and at pages 3-5 relating to Procedure Types.
 ;;
 ;;The Site Parameter screen may be accessed from the programmer prompt
 ;;by entering "D ^BWSITE" (no quotes).  It may also be accessed from
 ;;within the Women's Health menus by selecting Manager's Functions
 ;;from the Main Menu, then File Maintenance from the Manager's
 ;;Functions, and finally Edit Site Parameters from the File Maintenance
 ;;menu.
 ;;
 S BWTAB=5,BWLINL="TEXT8" D PRINTX
 Q
 ;
TEXT9 ;EP
 ;;        * This concludes the Post-Initialization program. *
 ;;
 ;;
 S BWTAB=5,BWLINL="TEXT9" D PRINTX
 Q
 ;
PRINTX ;EP
 N I,T,X S T="" F I=1:1:BWTAB S T=T_" "
 F I=1:1 S X=$T(@BWLINL+I) Q:X'[";;"  W !,T,$P(X,";;",2)
 Q
