ZIBRPI2 ; IHS/ADC/GTH - REMOTE PATCH INSTALLATION (2) ; [ 02/07/97   3:02 PM ]
 ;;3.0;IHS/VA UTILITIES;;FEB 07, 1997
 ;
 W !!,"EXECUTION UNAUTHORIZED.",!
 Q
 ;
GEN ; General description
 ;;This utility creates an entry in the OPTION file which is scheduled
 ;;to run daily thru TaskMan.  Files matching the naming conventions
 ;;for patch files (specified in the 1 Sep 94 SAC, Appendix E), are
 ;;looked for in the directory you indicate.  If the package and
 ;;version the patches are intended for are installed on this machine,
 ;;the routines are restored from the file, an entry is made in the
 ;;VERSION multiple of the PACKAGE file entry, and a report file is
 ;;sent to the systems you indicate.  If an action routine (A9 or B9)
 ;;is detected during the ZLOAD, and you have indicated permission to
 ;;run action routines, the action routine is called after all routines
 ;;have been restored.
 ;;NOTE:  Use the same entry point, OPT^ZIBRPI, to edit any changes you
 ;;       want to make to the parameters.  If you un-schedule the
 ;;       option, you must use the TaskMan options to re-schedule it.
 ;;###
 ;
SYSID ; Select system id's to receive result files.
 ;;Please indicate what system id's you want reports of results sent to.
 ;;Selecting 1 will send the report just to that system.
 ;;Selecting 2 will send the report to (what is intended to be) the
 ;;Area machine.
 ;;Selecting 3 will send the report to both systems.
 ;;It is recommended you just configure the utility to send report files
 ;;to your area machine (option 2).
 ;;NOTE:  root will be notified upon arrival of a uucp'd result file.
 ;;       You must read the file manually.
 ;;###
 ;
DIRECT ;
 ;;Enter the name of the directory into which files containing patches
 ;;are uucp'd or BLAST'd, or otherwise placed.  This is usually the
 ;;/usr/spool/uucppublic directory on unix machines.  You can designate
 ;;any directory that you want, for security purposes, but you should
 ;;ensure that permissions are correctly set to receive the files, and
 ;;to read the files from the MUMPS level.
 ;;THIS DIRECTORY MUST EXIST PRIOR TO COMPLETING THIS SET-UP.
 ;;###
 ;
ACTION ;
 ;;If an action routine is include in the patch file, do you want it
 ;;called after all the routines are restored?  The action routine will
 ;;be named (A/B)9<namespace><patch_number>.  E.g., A9AUM12 will be the
 ;;action routine for patch 12 to the table updates.
 ;;NOTE:  This feature allows you to do any type of unattended activity
 ;;       on any/all of your systems.  There is no checking for verified
 ;;       RPMS applications.  There must simply be an entry in PACKAGE,
 ;;       and the versions must match.
 ;;###
 ;
HELP(L) ;EP - From DIR
 W !
 F %=1:1 W !?4,$P($T(@L+%),";",3) Q:$P($T(@L+%+1),";",3)="###"
 Q
 ;
 ; dpssyg Any ACU2400 FTS-999-999-9999 n:--n:--n: uucpdps word: uucpdps
 ; dpssyg Any x25pad 9600 dpssyg "" \r n:--n:-@-n: uucpdps word: uucpdps
 ;
