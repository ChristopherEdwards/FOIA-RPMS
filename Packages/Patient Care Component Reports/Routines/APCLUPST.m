APCLUPST  ;CMI/TUCSON/LAB - LOAD NCI STUDY PATIENTS  
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
START ;start processing
 I '$G(DUZ) W !,"Log into Kernel first" Q
 W:$D(IOF) @IOF
 W !!,"This option should be used to upload patients from a file that is in the ",!,"format ASUFAC^HRN^DOB and store those patients in a search template."
 W !,"You will be asked to provide the directory path and filename where the",!,"file resides.  You will also be asked to enter the name of the search",!,"template that will be created.",!
 W !,"When entering the directory path, enter a full path name with the ending '/'",!,"for example, /usr/spool/uucppublic/ or /usr/mumps/.  When entering the ",!,"filename enter the extension as well, for example, MYFILE.TXT.",!
TEMPLATE ;If Template was selected
 W !,"You must first enter the name of the search template to be created."
 K APCLSTMP,APCLSNAM
 D ^APCLSTMP
 I $G(APCLSTMP)="" D XIT Q
 ;
UPL ;
 S APCLQUIT=0 D FILE
 I $G(APCLQUIT) W !!,"Bye.  File not accessed.",! D XIT Q
 W !!,APCLC," records were read from the file.",!
 W !!,"Now enter the device to which the results of the upload, including any errors",!,"will be printed.",!
ZIS ;call to XBDBQUE
 S XBRP="PRINT^APCLUPST",XBRC="PROC^APCLUPST",XBRX="XIT^APCLUPST",XBNS="APCL"
 D ^XBDBQUE
 D XIT
 Q
 ;
PRINT ;EP - called from xbdbque
 S APCL80S="*****************************************************************************"
 S APCLPG=0 K APCLQUIT
 D HEAD
 W !,"Read ",APCLCNT," records.   Loaded ",APCLLOAD," patients.",!
 W !!,"The following errors occurred: "
 S APCLX=0 F  S APCLX=$O(^XTMP("APCLUPST",APCLJ,APCLH,"ERRORS",APCLX)) Q:APCLX'=+APCLX  D
 .I $Y>(IOSL-4) D HEAD Q:$D(APCLQUIT)
 .W !,^XTMP("APCLUPST",APCLJ,APCLH,"ERRORS",APCLX)
 .Q
 K ^XTMP("APCLUPST",APCLJ,APCLH)
 D XIT
 Q
E ;
 S APCLE=APCLE+1
 S ^XTMP("APCLUPST",APCLJ,APCLH,"ERRORS",APCLE)=X
 Q
PROC ;EP - called from xbdbque
 S APCLE=0
 S APCLCNT=0,APCLLOAD=0
 S APCLR=0 F  S APCLR=$O(^XTMP("APCLUPST",APCLJ,APCLH,"PATIENTS",APCLR)) Q:APCLR'=+APCLR  S APCLX=^XTMP("APCLUPST",APCLJ,APCLH,"PATIENTS",APCLR,0) D LOAD
 Q
XIT ;
 K AUPNLK
 D EN^XBVK("APCL")
 D ^XBFMK
 Q
LOAD ;
 S AUPNLK("ALL")="",AUPNLK("INAC")=""
 Q:APCLX=""
 S APCLCNT=APCLCNT+1 ;total number of records read
 S APCLFACN=$P(APCLX,U),APCLHRN=$P(APCLX,U,2) S:$E(APCLHRN?1N) APCLHRN=+APCLHRN S APCLDOB=$P(APCLX,U,3)
 S APCLFAC=$O(^AUTTLOC("C",APCLFACN,0))
 I 'APCLFAC D
 .S X="Record "_APCLCNT_" COULD NOT FIND LOCATION "_APCLFACN_" IN THE LOCATION TABLE" D E
 K %DT I APCLDOB]"" S X=APCLDOB,%DT="P" D ^%DT S APCLDOB=Y
 S APCLPAT="" D GETPAT ;find patient with available data
 Q:'APCLPAT
 S ^DIBT(APCLSTMP,1,APCLPAT)=""
 S APCLLOAD=APCLLOAD+1
 Q
GETPAT ;
 S X=0 F  S X=$O(^AUPNPAT("D",APCLHRN,X)) Q:X'=+X  I $D(^AUPNPAT("D",APCLHRN,X,APCLFAC)) S APCLPAT=X
 I 'APCLPAT S X="Record: "_APCLCNT_" Couldn't find patient with chart number "_APCLHRN_" at facility "_APCLFACN D E Q
 I APCLDOB'=$P(^DPT(APCLPAT,0),U,3) S X="Record: "_APCLCNT_" DOB does not match patient found." S APCLPAT="" D E
 Q
FILE ;upload global
 S APCLJ=$J,APCLH=$H
 D XTMP^APCLOSUT("APCLUPST","PCC - UPLOAD INTO SEARCH TEMPLATE")
DIR ;
 W !,"Now enter the directory path and filename where the data can be found.",!
 S APCLDIR=""
 S DIR(0)="F^3:30",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." S APCLQUIT=1 Q
 S APCLDIR=Y
 S APCLFILE=""
 S DIR(0)="F^2:30",DIR("A")="Enter filename w /ext (i.e. NCIDATA.TXT)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 S APCLFILE=Y
 W !,"Directory=",APCLDIR,"  ","File=",APCLFILE,"  reading file Hold on...",!
READF ;read file
 NEW Y,X,I
 S APCLC=1
 S Y=$$OPEN^%ZISH(APCLDIR,APCLFILE,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",APCLDIR,APCLFILE,"'." S APCLQUIT=1 Q
 KILL ^XTMP("APCLUPST",APCLJ,APCLH)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^XTMP("APCLUPST",APCLJ,APCLH,"PATIENTS",APCLC,0)=X,APCLC=APCLC+1 Q:$$STATUS^%ZISH=-1!(X="")
 D ^%ZISC
 W !!,"All done reading file",!
 Q
STRIP(Z) ;REMOVE CONTROL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
 ;
HEAD I 'APCLPG G HEAD1
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W APCL80S,!
 W "*",?3,$P(^DIC(4,DUZ(2),0),U),?58,$$FMTE^XLFDT(DT),?72,"Page ",APCLPG,?78,"*",!
 W "*",?78,"*",!
 W "RESULTS OF UPLOADING PATIENTS INTO A SEARCH TEMPLATE",!
 W !,"SEARCH TEMPLATE CREATED: ",$P(^DIBT(APCLSTMP,0),U),!
 W APCL80S,!
 Q
 ;
