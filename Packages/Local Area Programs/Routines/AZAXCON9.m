AZAXCON9 ;IHS/PHXAO/AEF - CONVERT ROUTINE FILE FROM CACHE TO MSM [ 08/05/2004  3:07 PM ]
 ;;1.0;ANNE'S SPECIAL ROUTINES;;AUG 05, 2004
 ;
DESC ;----- ROUTINE DESCRIPTION
 ;;
 ;; This routine will convert a CACHE routine %RO file into an
 ;; MSM compatible file.
 ;;
 ;;$$END
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 D ^XBKVAR
 D HOME^%ZIS
 D PROC
 D KILL
 Q
PROC ;----- PROCESS DATA
 ;
 N FILEF,FILET,OUT,PATH
 ;
 S OUT=0
 ;
 D TXT
 ;
 D SELP(.PATH,.OUT)
 Q:OUT
 ;
 D SELF(.FILEF,.FILET,.OUT)
 Q:OUT
 ;
 D READ(PATH,FILEF,.OUT)
 Q:OUT
 ;
 D CONV(FILEF,PATH,.OUT)
 Q:OUT
 ;
 D PUT(PATH,FILET,.OUT)
 Q:OUT
 ;
 H 2
 W !,"File '"_PATH_FILET_"' created!"
 Q
SELP(PATH,OUT)     ;
 ;----- SELECT DIRECTORY OR PATH WHERE FILE RESIDES
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 ;
 S PATH=""
 S DIR(0)="FA"
 S DIR("A")="Select PATH: "
 S DIR("B")=$$PWD^%ZISH
 S DIR("?")="The PATH where the file to be converted resides"
 D ^DIR
 I Y']""!($D(DIRUT))!($D(DUOUT))!($D(DTOUT)) S OUT=1
 Q:OUT
 S X=Y
 D DF^%ZISH(.X)
 S PATH=X
 Q
SELF(FILEF,FILET,OUT)        ;
 ;----- SELECT FILES TO BE CONVERTED
 ;
 N DIR,DIRUT,DTOUT,DUOUT,X,Y
 ;
 S (FILEF,FILET)=""
 S DIR(0)="FA"
 S DIR("A")="Select file to be CONVERTED: "
 S DIR("?")="Enter the FILE containing the data to be converted"
 D ^DIR
 I Y']""!($D(DIRUT))!($D(DUOUT))!($D(DTOUT)) S OUT=1
 Q:OUT
 S FILEF=Y
 ;
 S DIR("A")="Select NEW file name: "
 D ^DIR
 I Y']""!($D(DIRUT))!($D(DUOUT))!($D(DTOUT)) S OUT=1
 Q:OUT
 S FILET=Y
 Q
READ(PATH,FILE,OUT)          ;
 ;----- READS CONTENTS OF FILE
 ;
 ;      RETURNS CONTENTS OF FILE IN ^TMP("AZAX",$J,"FILE",IEN,0)
 ;
 ;      PATH = DIRECTORY CONTAINING FILE
 ;             EXAMPLES:  /usr/spool/uucppublic/
 ;                        c:\inetpub\ftproot\pub\
 ;      FILE = ROUTINE FILE CONTAINING DATA TO BE READ
 ;             EXAMPLE:  AZAXVL.ROU
 ;      HFS  = HOST FILE SERVER
 ;      EOF  = END OF FILE
 ;      OUT  = QUIT CONTROLLER
 ;
 N EOF,I,J,X
 ;
 D ^XBKVAR
 K ^TMP("AZAX",$J,"FILE")
 S EOF=0
 ;
 D OPEN^%ZISH("FILE",PATH,FILE,"R")
 I POP D
 . W !,"UNABLE TO OPEN FILE '"_PATH_FILE_"'"
 . S OUT=1
 Q:OUT
 ;
 U IO
 F I=1:1 D  Q:EOF
 . R X:DTIME
 . I $$STATUS^%ZISH S EOF=1 Q
 . F J="":1:31 S X=$TR(X,$C(J))    ; REMOVE ALL CONTROL CHARACTERS
 . S ^TMP("AZAX",$J,"FILE",I,0)=X
 . S ^TMP("AZAX",$J,"FILE",0)=$G(^TMP("AZAX",$J,"FILE",0))+1
 ;
 D CLOSE^%ZISH("FILE")
 Q
CONV(FILE,PATH,OUT)          ;
 ;----- CONVERT DATA FROM CACHE TO MSM FORMAT
 ;
 N I,X,Y
 ;
 I '$D(^TMP("AZAX",$J,"FILE")) S OUT=1
 Q:OUT
 ;
 F I=1:1:3 S X(I)=$G(^TMP("AZAX",$J,"FILE",I,0))
 ;
 I X(1)'["Format=Cache"&($E(X(2),1,3)'="%RO") D
 . W !,"'"_FILE_"' does not appear to be a Cache routine file"
 . S OUT=1
 Q:OUT
 ;
 S Y=X(2)
 S Y(1)=$P(Y,"  ",2)_" "_$P(Y," ",3)_"-"_$P(Y," ",4)_"-"_$E($P(Y," ",5),3,4)
 S Y=X(1)
 S Y(2)=$P(X(1),U,3)
 S Y=X(3)
 S Y(3)=$P(X(3),U)
 ;
 F I=1:1:3 S ^TMP("AZAX",$J,"FILE",I,0)=Y(I)
 Q
PUT(PATH,FILE,OUT) ;
 ;----- PUT DATA INTO NEW FILE
 ;
 N POP,X,Y
 ;
 Q:'$D(^TMP("AZAX",$J,"FILE"))
 D OPEN^%ZISH("FILE",PATH,FILE,"W")
 I POP D  Q
 . W !,"UNABLE TO OPEN FILE '"_PATH_FILE_"'"
 . S OUT=1
 U IO
 S X=0
 F  S X=$O(^TMP("AZAX",$J,"FILE",X)) Q:'X  D
 . W $G(^TMP("AZAX",$J,"FILE",X,0))
 . I $O(^TMP("AZAX",$J,"FILE",X)) W !
 ;
 D CLOSE^%ZISH("FILE")
 Q
TXT ;----- PRINT OPTION DESCRIPTION
 ;
 N I,X
 F I=1:1 S X=$P($T(DESC+I),";",3) Q:X["$$END"  W !,X
 Q
KILL ;----- HOUSEKEEPING
 ;
 K ^TMP("AZAX",$J,"FILE")
 Q
