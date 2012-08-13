CIMSNCIL  ;CMI/TUCSON/LAB - LOAD NCI STUDY PATIENTS  [ 06/12/98  2:39 PM ]
 ;;1.0;NCI STUDY EXTRACT 1.0;;MAY 14, 1998
 ;
 ;
 ;
START ;start processing
 I '$G(DUZ) W !,"Log into Kernel first" Q
 W:$D(IOF) @IOF
 W !!,"This option should be used to upload patient chart numbers into the","NCI STUDY FILE.  You will be asked to enter the directory path and the ",!,"file name from which to upload the chart numbers.",!
 W !!,"When entering the directory path, enter a full path name with the ending '/'",!,"for example, /usr/spool/uucppublic/ or /usr/mumps/.  When entering the ",!,"filename enter the extension as well, for example, NCIDATA.TXTT.",!!
 S CIMSQUIT=0 D FILE
 I $G(CIMSQUIT) W !!,"Bye.  File not accessed.",! D XIT Q
 S CIMSCNT=0,CIMSLOAD=0
 S CIMSR=0 F  S CIMSR=$O(^TMP("CIMSNCIL",$J,CIMSR)) Q:CIMSR'=+CIMSR  S CIMSX=^TMP("CIMSNCIL",$J,CIMSR,0) D LOAD
 W !!,"All Done."
 W !,"Read ",CIMSCNT," records.   Loaded ",CIMSLOAD," patients.",!
 D XIT
 Q
XIT ;
 K AUPNLK
 K ^TMP("CIMSNCIL",$J)
 D EN^XBVK("CIMS")
 D ^XBFMK
 Q
LOAD ;
 S AUPNLK("ALL")="",AUPNLK("INAC")=""
 Q:CIMSX=""
 S CIMSCNT=CIMSCNT+1 ;total number of records read
 S CIMSFACN=$E(CIMSX,1,6),CIMSHRN=$E(CIMSX,7,12),CIMSHRN=+CIMSHRN
 S CIMSFAC=$O(^AUTTLOC("C",CIMSFACN,0))
 S CIMSNCI=$E(CIMSX,13,19)
 S X=$E(CIMSX,20,25),X=$E(X,3,4)_"/"_$E(X,5,6)_"/"_$E(X,1,2) K %DT S %DT="P" D ^%DT S CIMSDX=Y
 S CIMSPAT="" D GETPAT ;find patient with available data
 Q:'CIMSPAT
 ;add to file
 I $D(^CIMSCPAT(CIMSPAT)) W !!,"already have that patient "_CIMSPAT_" HRN: "_CIMSHRN H 2 Q
 K DIC,DLAYGO,DA,DD,D0,DO S X="`"_CIMSPAT,DIC(0)="L",DIC="^CIMSCPAT(",DLAYGO=19259.02,DIC("DR")=".02///^S X=DT;.03///"_CIMSNCI_";.04///"_$$FMTE^XLFDT(CIMSDX) K DD,DO,D0 D ^DIC K DIC,DLAYGO,DA,DD,D0
 I Y=-1 W !,"Error adding patient ",CIMSHRN," to file." H 2 Q
 S CIMSLOAD=CIMSLOAD+1
 Q
GETPAT ;
 S X=0 F  S X=$O(^AUPNPAT("D",CIMSHRN,X)) Q:X'=+X  I $D(^AUPNPAT("D",CIMSHRN,X,CIMSFAC)) S CIMSPAT=X
 I 'CIMSPAT W !,"Couldn't find patient with chart number ",CIMSHRN," at facility ",CIMSFACN H 2
 Q
FILE ;upload global
DIR ;
 S CIMSDIR=""
 S DIR(0)="F^3:30",DIR("A")="Enter directory path (i.e. /usr/spool/uucppublic/)" K DA D ^DIR K DIR
 I $D(DIRUT) W !!,"Directory not entered!!  Bye." S CIMSQUIT=1 Q
 S CIMSDIR=Y
 S CIMSFILE=""
 S DIR(0)="F^2:30",DIR("A")="Enter filename w /ext (i.e. NCIDATA.TXT)" K DA D ^DIR K DIR
 G:$D(DIRUT) DIR
 S CIMSFILE=Y
 W !,"Directory=",CIMSDIR,"  ","File=",CIMSFILE,"  reading file into ^TMP...",!
READF ;read file
 NEW Y,X,I,CIMSC
 S CIMSC=1
 S Y=$$OPEN^%ZISH(CIMSDIR,CIMSFILE,"R")
 I Y W !,*7,"CANNOT OPEN (OR ACCESS) FILE '",CIMSDIR,CIMSFILE,"'." S CIMSQUIT=1 Q
 KILL ^TMP("CIMSNCIL",$J)
 F I=1:1 U IO R X:DTIME S X=$$STRIP(X) S ^TMP("CIMSNCIL",$J,CIMSC,0)=X,CIMSC=CIMSC+1 Q:$$STATUS^%ZISH=-1
 D ^%ZISC
 W !!,"All done reading file",!
 Q
STRIP(Z) ;REMOVE CONTROL CHARACTERS
 NEW I
 F I=1:1:$L(Z) I (32>$A($E(Z,I))) S Z=$E(Z,1,I-1)_" "_$E(Z,I+1,999)
 Q Z
DELETE ;EP - delete all entries in study file
 W !!,"I am about to delete all entries in the NCI Cancer Study Patient file!!",$C(7),$C(7),!!
 S DIR(0)="Y",DIR("A")="Are you sure you want to continue",DIR("B")="N" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) Q
 I 'Y Q
 W !!,"Deleting entries..."
 S CIMSX=0 F  S CIMSX=$O(^CIMSCPAT(CIMSX)) Q:CIMSX'=+CIMSX  S DA=CIMSX,DIK="^CIMSCPAT(" D ^DIK W "."
 W !,"All Done",!
 K CIMSX
 S DIR(0)="E",DIR("A")="Press return" K DA D ^DIR K DIR,DA
 Q
 ;
 ;
