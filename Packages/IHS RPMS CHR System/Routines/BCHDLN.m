BCHDLN ; IHS/TUCSON/LAB - DOWNLOAD PATIENT DATA TO REMOTE ;  [ 06/17/02  7:27 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**16**;OCT 28, 1996
 ;
 ;Routine to create a file of records containing patient 
 ;demographic information to be downloaded to a remote computer.
 ;See START sub-routine for explanation.
 ;
START ;EP
 W:$D(IOF) @IOF
 W !!?9,"**** DOWNLOAD PATIENT DEMOGRAPHIC DATA TO REMOTE ****",!!
 W "This routine is to be run the very FIRST time a CHR wants to download patient",!,"demographic data to their remote device.  The set of patients that is"
 W !,"downloaded can be selected based on items such as community of"
 W !,"residence or where the patient is registered.",!
 W !,"These file(s) will be placed in the same directory that all export"
 W !,"files are placed.  In most cases, that will be /usr/spool/uucppublic."
 W !,"See your site manager for assistance in finding the file once it has"
 W !,"been created.",!!
 ;
CONT ;
 K DIR S DIR(0)="Y",DIR("A")="Do you wish to continue and create a download patient file",DIR("B")="N" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:'Y XIT
ADD ;
 D ADD1^BCHRL01
 I $D(BCHQUIT) G XIT
 D SCREEN
 I $D(BCHQUIT) D DEL^BCHRL G XIT
CONFIRM ;
 W !!,"The file(s) created will be placed in the ",$S($P(^AUTTSITE(1,0),U,21)=1:"/usr/spool/uucppublic",1:"C:\EXPORT")," directory."
 W !,"The file will be called:  ",BCHFILE,!
 W !!,"It may be several hours (or overnight) before your flat file is finished.",!
 W !,"As a reminder, the records that are generated and placed in the file(s)"
 W !,"are in a standard, pre-defined record format.  For a definition of the format",!,"please see your user manual.",!
 K DIR S DIR(0)="Y",DIR("A")="Is everything ok?  Do you want to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!(Y'=1) S BCHQUIT=1 G XIT
 S DA=BCHRPT,DR=".12///"_BCHFILE,DIE="^BCHTRPT(" D ^DIE
 K DIE,DA,DR
ZIS ;call to xbdbque
 D XIT
QUEUE ;EP
 K ZTSK
 S DIR(0)="Y",DIR("A")="Do you want to QUEUE this to run at a later time",DIR("B")="Y" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I Y=1 D QUEUE1,XIT,XIT1 Q
 I $D(DIRUT) W !,"Okay .. you '^'ed or timed out ..Goodbye" D XIT,XIT1 Q
 D WAIT^DICD,^BCHDLN1,XIT,XIT1
 Q
QUEUE1 ;
 S XBRC="^BCHDLN1",XBRX="XIT^BCHDLN",XBNS="BCH;IO*",XBIOP="HOME",XBFQ=1
 D ^XBDBQUE
 D XIT,XIT1
 Q
SCREEN ;EP
 S X2=$E(DT,1,3)_"0101",X1=DT D ^%DTC S BCHJD=X+1
 S BCHPTVS="P",BCHTYPE="P",BCHFILE="bchpts"_$TR($$NOW^XLFDT,".","")_".txt"
 D SMENU
 S DIR(0)="LO^1:"_BCHHIGH,DIR("A")="Select Patients based on which of the above" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 G:Y="" XIT
 I $D(DIRUT) G XIT
 ;process all items in Y
 D SELECT^BCHRL0
 D SHOW^BCHRLS
 W !! S DIR(0)="Y",DIR("A")="      Would you like to select additional "_$S(BCHPTVS="P":"PATIENT",1:"CHR RECORD")_" criteria",DIR("B")="NO" D ^DIR K DIR
 S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) S BCHQUIT=1 Q
 Q:Y=0
 G SCREEN
 ;
SMENU ;EP
 K BCHDISP,BCHSEL,BCHHIGH
 I $Y>(IOSL-8) W:$D(IOF) @IOF
 W !!,"The Patients downloaded can be selected based on any of the following criteria:",!
 S BCHHIGH=0,X=0 F  S X=$O(^BCHSORT("AD",1,X)) Q:X'=+X  S BCHHIGH=BCHHIGH+1,BCHSEL(BCHHIGH)=X
 S BCHCUT=((BCHHIGH/2)+.5)\1
 S I=0,J=1 F  S I=$O(BCHSEL(I)) Q:I'=+I!($D(BCHDISP(I)))  D
  .W !?5,I,") ",$E($P(^BCHSORT(BCHSEL(I),0),U),1,30) S BCHDISP(I)=""
 .S J=I+BCHCUT I $D(BCHSEL(J)),'$D(BCHDISP(J)) W ?40,J,") ",$E($P(^BCHSORT(BCHSEL(J),0),U),1,30) S BCHDISP(J)=""
 W !!?9,"<Enter a list or a range.  E.g. 1-4,5,20 or 10,12,20,30>"
 W !?9,"<<HIT RETURN to conclude selections or bypass screens>>"
 Q
XIT ;clean up and exit
 K BCHSEL,BCHHIGH,BCHDISP,BCHQUIT,BCHANS,BCHCRIT,BCHCUT,BCHGBD,BCHGDE,BCHGDS,BCHI,BCHRAR,BCHTEXT,BCHY,BCHCNT
 K AMQQTAX
 K BCHFOUN,BCHJD,BCHPCNT,BCHPROC,BCHR,BCHSKIP,BCHX
 K D,D0,DIC,DFN,DI,DQ,J,XBFLG,Y
 Q
XIT1 ;
 K BCHRPT,BCHPTVS,BCHTYPE,BCHCHR,BCHFILE
 Q
