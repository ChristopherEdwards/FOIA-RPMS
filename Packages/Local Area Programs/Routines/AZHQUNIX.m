AZHQUNIX ;IHS/OIRM/AEF - READ UNIX FILE [ 12/17/2001  9:58 AM ]
 ;;1.0t1;AEF UTILITY ROUTINES
 ;;
 ;;
 ;;THIS ROUTINE CONTAINS ENTRY POINTS TO READ UNIX FILE CONTENTS
 ;;
 ;;****THIS ROUTINE IS UNDER CONSTRUCTION****
 ;;
READ(PATH,FILE)    ;EP
 ;----- READS CONTENTS OF UNIX FILE
 ;
 ;      RETURNS CONTENTS OF UNIX FILE IN ^TMP("AZHQ",$J,"UNIX",IEN,0)
 ;
 ;      PATH = DIRECTORY CONTAINING UNIX FILE
 ;             EXAMPLE:  /usr3/dsd/afugatt/
 ;      FILE = UNIX FILE
 ;             EXAMPLE:  dhr4.dat
 ;      HFS  = HOST FILE SERVER
 ;      OUT  = QUIT CONTROLLER
 ;      AZHQERR = ARRAY CONTAINING FAILURE MESSAGES
 ;
 ;N OUT,HFS,I,X
 D ^XBKVAR
 K ^TMP("AZHQ",$J,"UNIX")
 S OUT=0
 D OPEN^%ZISH("FILE",PATH,FILE,"R")
 I POP D  Q
 . W "UNABLE TO OPEN FILE '"_FILE_"'"
 U IO
 F I=1:1 D  Q:OUT
 . R X:DTIME
 . I $$STATUS^%ZISH S OUT=1 Q
 . F J="":1:31 S X=$TR(X,$C(J))    ; REMOVE ALL CONTROL CHARACTERS
 . S ^TMP("AZHQ",$J,"UNIX",I,0)=X
 . S ^TMP("AZHQ",$J,"UNIX",0)=$G(^TMP("AZHQ",$J,"UNIX",0))+1
 D CLOSE^%ZISH("FILE")
 Q
SELD ;EP -- SELECT UNIX PATH OR DIRECTORY
 ;
 ;      RETURNS AZHQPATH = UNIX DIRECTORY
 ;                   OUT = 1 IF UNSUCCESSFUL
 ;
 N DIR,OUT,X,Y
 D ^XBKVAR
 S AZHQPATH="",OUT=0
 S DIR(0)="FA",DIR("A")="Select UNIX Directory: "
 S DIR("?")="Enter the PATH or DIRECTORY where the UNIX file resides, e.g., /usr3/dsd/afugatt/"
 F  D  Q:OUT
 . D ^DIR
 . I $D(DIRUT)!($D(DUOUT))!($D(DTOUT)) S OUT=1 Q
 . I $E(Y)'="/" W !,"Directory must begin with '/'" Q
 . I $$CHKPATH^AZHQUNIX(Y) W !,"No such directory '"_Y_"'" Q
 . S AZHQPATH=Y,OUT=1
 Q:AZHQPATH']""
 S AZHQPATH=$TR(AZHQPATH,"\""""'* ","")
 I $E(AZHQPATH,$L(AZHQPATH))'="/" S AZHQPATH=AZHQPATH_"/"
 Q
SELF(PATH)         ;EP
 ;----- SELECT UNIX FILE
 ;
 ;      RETURNS AZHQFILE = UNIX FILE
 ;                   OUT = 1 IF UNSUCCESSFUL
 ;
 ;      PATH = PATH OR DIRECTORY CONTAINING THE FILE
 ;
 N DIR,OUT,X,Y
 D ^XBKVAR
 I PATH']"" W !,"No UNIX directory has been specified" Q
 I $$CHKPATH^AZHQUNIX(PATH) W !,"No such directory '"_PATH_"'" Q
 S AZHQFILE="",OUT=0
 S DIR(0)="FA",DIR("A")="Select UNIX File: "
 S DIR("?")="^D HELP1^AZHQUNIX(PATH)"
 F  D  Q:OUT
 . D ^DIR
 . I $D(DIRUT)!($D(DUOUT))!($D(DTOUT)) S OUT=1 Q
 . I $E(Y)="/" S Y=$P(Y,"/",2)
 . S X=$$OPEN^%ZISH(PATH,Y,"R")
 . I 'X S AZHQFILE=Y,OUT=1 Q
 . W !,"Unable to open file ",Y
 Q
HELP1(PATH)         ;
 ;----- HELP FOR UNIX FILE SELECTION
 ;
 ;      PATH = UNIX DIRECTORY WHERE THE FILE RESIDES
 ;
 N X
 I PATH']"" W !,"No directory has been specified" Q
 I $$CHKPATH^AZHQUNIX(PATH) W !,"No such directory '"_PATH_"'" Q
 W !,"DIRECTORY: ",PATH,!
 S X=$$JOBWAIT^%HOSTCMD("cd "_PATH)
 S X=$$TERMINAL^%HOSTCMD("ls -p -l | grep -v ""/""")
 Q
CHKPATH(PATH)      ;
 ;----- CHECKS FOR VALID UNIX PATH
 ;
 ;      RETURNS 0 IF VALID, 1 IF NOT VALID
 ;      PATH = UNIX DIRECTORY
 ;
 N X
 S X=$$JOBWAIT^%HOSTCMD("cd "_PATH)
 Q X
 
