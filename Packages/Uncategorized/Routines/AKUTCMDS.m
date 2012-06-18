AKUTCMDS ;IHS/MFD  CALL UNIX TC COMMANDS AND APPLICATIONS [ 06/14/89  11:39 AM ]
 ;1.1
 ; This routine contains multiple sub-routines called by AKUT options
 ; in the VA Kernel. This routine can only be used by MSM mumps
 ; version 2.1 or greater
 ;
VPUBLIC ;view uucppublic directory
 W !,"Current files in Public uucp directory....",!
 S X=$$TERMINAL^%HOSTCMD("env; ls -l /usr/spool/uucppublic")
 R !,"< Press RETURN to continue >",Y:DTIME
 K X,Y Q
DISPUBF ;display a uucppublic file
 W !!
 R "Enter name of uucppublic file to view: ",AKUTFILE:DTIME
 G:'$T!(U[AKUTFILE)!(AKUTFILE["?") DISPUB1 S AKUTFILE="more /usr/spool/uucppublic/"_AKUTFILE D ^%AUCLS
 S X=$$TERMINAL^%HOSTCMD(AKUTFILE)
 R !,"< Press RETURN to continue >",Y:DTIME
DISPUB1 K X,Y,AKUTFILE D ^%AUCLS Q
TAILPUB ;tail a uucppublic file
 W !!
 R "View how many lines? (enter number 23-99): ",AKUTLINE:DTIME
 G:'$T!(U[AKUTLINE)!(AKUTLINE["?") TAILPUB1 S AKUTLINE="tail -"_AKUTLINE_" /usr/spool/uucppublic/"
 R !,"Enter file name to view: ",AKUTFILE:DTIME
 G:'$T!(U[AKUTFILE)!(AKUTFILE["?") TAILPUB1 S AKUTFILE=AKUTLINE_AKUTFILE_" | more" D ^%AUCLS
 S X=$$TERMINAL^%HOSTCMD(AKUTFILE)
 H 5
TAILPUB1 K X,AKUTLINE,AKUTFILE Q
UUSTAT ;uustat
 W !!
 R "Enter systemid (default is all): ",AKUTSYS:DTIME
 G:'$T!(AKUTSYS[U)!(AKUTSYS["?") UUSTAT1
 I AKUTSYS="" D ^%AUCLS S X=$$TERMINAL^%HOSTCMD("uustat") G UUSTAT1
 I AKUTSYS]"" S AKUTSYS1="uuname | grep "_AKUTSYS S X=$$JOBWAIT^%HOSTCMD(AKUTSYS1) I X W !,"Systemid unknown- try again",*7 G UUSTAT
 S AKUTSYS="uustat -s"_AKUTSYS D ^%AUCLS S X=$$TERMINAL^%HOSTCMD(AKUTSYS)
UUSTAT1 K X,AKUTSYS,AKUTSYS1 Q
UULOG ;uulog -s
 W !!
 R "Enter systemid (default is all): ",AKUTSYS:DTIME
 G:'$T!(AKUTSYS[U)!(AKUTSYS["?") UUSTAT1
 I AKUTSYS]"" S AKUTSYS1="uuname | grep "_AKUTSYS S X=$$JOBWAIT^%HOSTCMD(AKUTSYS1) I X W !,"Systemid unknown- try again",*7 G UULOG
 S AKUTSYS="uulog -s"_AKUTSYS D ^%AUCLS S X=$$TERMINAL^%HOSTCMD(AKUTSYS)
UULOG1 K X,AKUTSYS,AKUTSYS1 Q
NSAV ;Save Merged data to 9-track
 D ^%AUCLS
 S X=$$TERMINAL^%HOSTCMD("/usr/aom/9savdata")
 K X Q
TCDATA ;schedule uucp request for gathering facility data
 D ^%AUCLS
 S X=$$TERMINAL^%HOSTCMD("/usr/aom/tcfacdata")
 K X Q
MOVTA ;move time and attendance files to backup directory and tape
 W !! S X=$$TERMINAL^%HOSTCMD("/usr/aom/mvatag")
 K X Q
SYNC ;execute 3780 program with option delete of PRINT files upon entry
 W !!
 ;S X=$$TERMINAL^%HOSTCMD("/usr/aom/consoleck") I X G SYNC1
 R "Remove old PRINT* files? (Y or N ): ",AKUT:DTIME
 W ! G:'$T!(AKUT'?1"Y"&(AKUT'?1"N")) SYNC1
 I AKUT="Y" S X=$$TERMINAL^%HOSTCMD("/usr/aom/remprint")
 S X=$$TERMINAL^%HOSTCMD("/usr/bin/3780")
SYNC1 K X,AKUT Q
CALL ;call another computer
 W !!
 R "Enter systemid ('dir' for direct connect) : ",AKUTSYS:DTIME
 W ! G:'$T!(U[AKUTSYS)!(AKUTSYS["?") CALL1
 I AKUTSYS="dir" S X=$$TERMINAL^%HOSTCMD("call dir") G CALL1
 S AKUTSYS1="uuname | grep "_AKUTSYS S X=$$JOBWAIT^%HOSTCMD(AKUTSYS1) I X W !,"Systemid unknown- try again",*7 G CALL
 S AKUTSYS="call "_AKUTSYS S X=$$TERMINAL^%HOSTCMD(AKUTSYS)
CALL1 K X,AKUTSYS,AKUTSYS1 Q
