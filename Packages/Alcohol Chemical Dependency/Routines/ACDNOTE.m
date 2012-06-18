ACDNOTE ;IHS/ADC/EDE/KML - INSTALL NOTES;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ;INSTALLATION NOTES FOR CHEMICAL DEPENDENCY MIS
 ;====================================================================
 ;PREFIX:  ACD
 ;CURRENT VERSION:  4.0
 ;====================================================================
 ;
 ;**** NOTE ***** NOTE ***** NOTE ***** NOTE ***** NOTE ***** NOTE ****
 ;*********************************************************************
 ;*READ THE ENTIRE NOTES FILE PRIOR TO ATTEMPTING ANY INSTALLATION    *
 ;*********************************************************************
 ;**** NOTE ***** NOTE ***** NOTE ***** NOTE ***** NOTE ***** NOTE ****
 ;
 ;1.  GENERAL INFORMATION
 ;
 ;    a)  Make a copy of this distribution for off-line storage.
 ;
 ;    b)  Print all notes/readme files (acd_0400.n & acd_0400.i).
 ;
 ;    c)  If you received this distribution on tape media please
 ;        remember to return the tape to the originator.
 ;
 ;    d)  It is recommended that the terminal output during the
 ;        installation be captured using an auxport printer
 ;        attached to the terminal at which you are performing
 ;        the software installation.  This will insure a printed
 ;        audit trail if any problems should arise.
 ;
 ;2.  CONTENTS OF DISTRIBUTION
 ;
 ;    a)  acd_0400.r - Routines
 ;
 ;    b)  acd_0400.n - This file
 ;
 ;    c)  acd_0400.g - Globals
 ;
 ;    d)  acd_0400.i - General information about enhancements
 ;
 ;3.  REQUIREMENTS
 ;
 ;    a)  Kernel v7 or later
 ;
 ;    b)  FileMan v20 or later
 ;
 ;    c)  XB utilities
 ;
 ;    d)  PCC v1.6 or later if the PCC link is to be activated
 ;
 ;4.  INSTALLATION INSTRUCTIONS
 ;
 ;    In all UCI's running the CHEMICAL DEPENDENCY MIS:
 ;
 ;    a)  Disable logins or ensure all users are off, or
 ;        disable ACDMENU.
 ;
 ;    b)  Backup your CDMIS 3 system.  Use ^%RS and save ACD*.
 ;        Use ^%GS and save ^ACD*.
 ;        ***** This install is very destructive so make sure *****
 ;        ***** you can restore your old system if necessary. *****
 ;
 ;    c)  Delete the routines ACD*.
 ;
 ;    d)  Do ^%RR from the file acd_0400.r.
 ;
 ;    e)  Do ^ACDINIT.  Answer all questions YES.  At the end of
 ;        the init you will be told to restore deleted globals.
 ;
 ;    r)  Do ^%GR from the file acd_0400.g.   This will restore
 ;        11 globals.
 ;
 ;    s)  Assign CDMIS specialist all ACDZ* keys.
 ;
 ; Your CDMIS Version 4 system should now be operational.  Make
 ; sure it is working properly at one site before distributing it
 ; to all other sites.
 ;
 ; If you need assistance call Your Help Desk.
