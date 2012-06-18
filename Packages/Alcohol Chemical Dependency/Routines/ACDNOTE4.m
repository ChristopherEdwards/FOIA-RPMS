ACDNOTE4 ;IHS/ADC/EDE/KML - INSTALL NOTES;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;;
 ;Backup your CDMIS 3 system. This includes saving out all routines
 ;including inits, all patches, and all CDMIS globals which are data
 ;globals and table globals. Basically, put yourself in a position
 ;to put your system back like it was before Version 4 was installed.
 ;if you have to.  Use ^%RS and save ACD*.  Use ^%GS and save ^ACD*.
 ;
 ;Turn on control print screen or open a log file to capture as much
 ;of the installation procedure as possible. No need to try to guess
 ;what may go wrong...get it in writing!!
 ;
 ;Delete all CDMIS (ACD*) routines from your UCI:VOL so when you
 ;load version 4 in the same UCI:VOL you will have a clean account.
 ;Utility to delete is ^%RDEL
 ;
 ;Load the unix file (convert to dos first) acd_0400.r into
 ;the UCI:VOL that they will run in.
 ;Utility to load is ^%RR
 ;
 ;Install Version 4 by running the routine ACDINIT. Answer yes to
 ;all questions asked by the init process except the one question
 ;about overwriting file security codes. The reply to this question is
 ;your choice.
 ;Cdmis file security is listed on an attachment.
 ;
 ;Let the inits run through completely and this will be the case
 ;when you are back at the program prompt >
 ;
 ;Load the unix file (convert to dos first) acd_0400.g into
 ;the UCI:VOL that CDMIS 4 will run in.
 ;Utility to load is ^%GR
 ;
 ;Areas, assign your CDMIS specialist all CDMIS security keys that
 ;begin with ACDZ*.  The CDMIS specialist will then have full access
 ;to the CDMIS system.
 ;
 ;Version 4 of CDMIS should now be functional.
 ;
 ;The area cdmis specialist should become familiar with the system
 ;for 2 or 3 days before installing on facility machines. The area
 ;Specialist should enter two questions mark when at the main menu
 ;and the security keys listed here must be assigned to facility
 ;users. The supervisor menu text tells you where the option may
 ;run and facilities should be given the keys to run the options
 ;that pertain to them. Again, two question marks at the supervisor
 ;menu will list the keys to assign for the options
 ;
 ;The Cdmis 4 inits may be run over a system already running cdmis 4
 ;with out problem (i.e., you may re-install by following the same
 ;procedures listed here)
 ;
 ;Please note that data from cdmis 3 may not be imported to cdmis 4.
 ;                 data from cdmis 4 may not be imported to cdmis 3
 ;                 data from cdmis 4  'MUST' be imported to cdmis 4
 ;
 ;Please call for assistance when needed
 ;
 ;Note: init difrom was with fm20
