XBPOST ; IHS/ADC/GTH - XB/ZIB INSTALLATION POSTINIT ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 W !!,$$C^XBFUNC("Beginning XB/ZIB post-init at "_$$FMTE^XLFDT($$HTFM^XLFDT($H))_".")
 ;
 W !!,$$C^XBFUNC("Checking PROTOCOL file for XB entries")
 ;
 F XB="XB DISPLAY","XB NEXT SCREEN","XB PREVIOUS SCREEN","XB QUIT" I '$D(^ORD(101,"B",XB)) W *7,!,"You're missing option '",XB,"' from PROTOCOL." D
 . I $$DIR^XBDIR("Y","Do you want to run XBONIT to add the option","Y","","Routine XBONIT will add the XB options to your PROTOCOL file","^D HELP^XBHELP(""ORD101"",""XBPOST"")","") D ^XBONIT
 .Q
 ;
 ;
 W !,$$C^XBFUNC("Delivering mail message to local programmers")
 ;
 D MAIL^XBMAIL("XUMGR-XUPROGMODE","DESC^XBPOST")
 ;
 I $$DIR^XBDIR("Y","Do you want to <DELETE> un-needed routines","N","","I'll delete the XB init routines, etc. (Except routine XBINIT)") D
 . S X=$$RSEL^ZIBRSEL("XBINI*","^TMP(""XBPOST"",$J,")
 . KILL ^TMP("XBPOST",$J,"XBINIT")
 . I $D(^ORD(101,"B","XB DISPLAY")),$D(^("XB NEXT SCREEN")),$D(^("XB PREVIOUS SCREEN")),$D(^("XB QUIT")) S X=$$RSEL^ZIBRSEL("XBONI*","^TMP(""XBPOST"",$J,")
 . S X=""
 . F  S X=$O(^TMP("XBPOST",$J,X)) Q:X=""  X ^%ZOSF("DEL") W !,X,$E("...........",1,11-$L(X)),"<poof'd>"
 . KILL ^TMP("XBPOST",$J)
 .Q
 ;
 W !!,$$C^XBFUNC("You can print a Technical Manual thru the option")
 W !,$$C^XBFUNC("on the 'MISCELLANEOUS' menu, or with DO ^XBTM.")
 ;
 NEW DIC
 S DIC="^DIC(19,",DIC(0)="",X="ZIB REMOTE PATCH INSTALLATION"
 D ^DIC
 I Y<0 W !!,$$C^XBFUNC("You don't have the Remote Patch Installer (ZIBRPI) installed."),!,$$C^XBFUNC("See instructions/descriptions in routine ZIBRPI2.")
 D HELP^XBHELP("MGR","XBPOST")
 ;
 D EN^XBVK("XB"),EN^XBVK("ZIB")
 W !!,$$C^XBFUNC("XB/ZIB v 3.0 post-init complete at "_$$FMTE^XLFDT($$HTFM^XLFDT($H))_".")
 Q
 ;
ORD101 ;
 ;;You're missing one of the XB options from your PROTOCOL file
 ;;that's needed for the XB interface to the VA's list manager
 ;;(VALM).  If you answer "Y"es, routine ^XBONIT will be called,
 ;;which will add (or overwrite) the following entries:
 ;;"XB DISPLAY", "XB NEXT SCREEN", "XB PREVIOUS SCREEN", "XB QUIT".
 ;;@;!
 ;;If you answer "N"o, you can run the XBONIT routine later.  If
 ;;you don't run ^XBONIT, and are lacking the XB entries in your
 ;;PROTOCOL file, you're XB interface to the list manager will be
 ;;undetermined.
 ;;###
 ;
MGR ;     
 ;;Don't forget to copy, and rename, the following routines to the
 ;;MGR uci:
 ;;             Routine       Rename As
 ;;             --------      --------
 ;;             XBCLS         %XBCLS
 ;;             ZIBGD         %ZIBGD
 ;;             ZIBRD         %ZIBRD
 ;;             ZIBCLU0       %ZIBCLU0
 ;;             ZIBZUCI       %ZUCI
 ;;###
 ;
DESC ;
 ;;XB/ZIB v 3.0, Installation Announcement.
 ;;  
 ;;++++++++++++ XB/ZIB 3.0 Installation Announcement +++++++++++++++
 ;;+     This mail message has been delivered to all local         +
 ;;+ users that hold an XUMGR, XUPROG, or XUPROGMODE security key. +
 ;;+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 ;;  
 ;;Please direct your questions or comments about RPMS software to:
 ;;            OIRM / DSD (Division of Systems Development)
 ;;            5300 Homestead Road NE
 ;;            Albuquerque NM  87110
 ;;            505-837-4189
 ;;  
 ;;-----------------------------------------------------------------
 ;; 
 ;;(1)  XBDIR - DIR INTERFACE.
 ;;The purpose of routine XBDIR is to provide interface methodology
 ;;for a call to ^DIR, to ensure correct handling of variables, and
 ;;to provide for the expressiveness of an extrinsic function. There
 ;;is no requirement to use the interface.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(2)  XBBPI - BUILD PRE-INIT ROUTINE.
 ;;Implementation specific Z commands were replaced with equivalent
 ;;^%ZOSF nodes.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(3)  XBHELP - DISPLAY HELP TEXT TO USER.
 ;;Although this routine was specifically requested to provide the
 ;;flexibility to display text to the user, it can be used at other
 ;;times.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(4)  XBHFMAN - PRINT A MANUAL CONSISTING OF INFO FROM HELP FRAMES.
 ;;This utility creates a "manual" consisting of information from the
 ;;option tree of the selected application, and information contained
 ;;in the option descriptions and help frames.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(5)  XBKTMP - CLEAN ^TMP().
 ;;This routine KILLs nodes in ^TMP( whose first or second subscripts
 ;;are the current $J.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(6)  XBLCALL - LIST CALLABLE ROUTINES.
 ;;The routine has been updated to list published entry points that
 ;;are supported for calls from other applications.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(7)  XBLM - LIST MANAGER INTERFACE.
 ;;Two entry points have been added for support of future GUI
 ;;programming.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(8)  XBON/XBOFF - SET REVERSE VIDEO ON/OFF.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(9)  XBTM - PRINT XB/ZIB TECH MANUAL.
 ;;This routine provides for the printing of a technical manual for
 ;;the XB/ZIB routines.  One or all chapters can be printed.  The
 ;;information comes from existing routines, and other attributes,
 ;;on the local machine, and will reflect all local modifications.
 ;;All entry points and published entry points (PEP) are listed.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(10)  XBVIDEO - SET/WRITE VARIOUS DEVICE ATTRIBUTES.
 ;;Entry point EN provides access to creating, writing, and resetting
 ;;cursor position for various device attributes, both supported by
 ;;%ZISS, and not supported by %ZISS.  See the routine for the
 ;;variables.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(11)  XBVK - KILL LIST OF LOCAL VARIABLES.
 ;;This routine calls an implementation specific routine which
 ;;searches the symbol table and kills local variables within the
 ;;namespace passed in the parameter.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(12)  XBVL - LIST LOCAL VARIABLES.
 ;;This is an interactive utility which will provide programmers with
 ;;the ability to list a subset, based on a selected namespace, of
 ;;local variables.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(13)  ZIBERR - PROVIDE ACCESS TO THE SYSTEM ERROR VARIABLE.
 ;;This provides access to implementation specific system variable to
 ;;return the current error, if any.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(14)  ZIBGCHAR - MODIFY GLOBAL CHARACTERISTICS.
 ;;Several entry points allow modification of implementation
 ;;specific global characteristics.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(15)  ZIBNSSV - NON-STANDARD SYSTEM VARIABLES.
 ;;This routine provides access to common non-standard system
 ;;variables that are implementation specific.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;(16)  ZIBTCP - PRINT TO REMOTE PRINTER THRU TCP.
 ;;  
 ;;-----------------------------------------------------------------
 ;;  
 ;;+++++++++++++ end of 3.0 Installation announcement ++++++++++++++
 ;;###
 ;
