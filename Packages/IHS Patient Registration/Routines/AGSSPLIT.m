AGSSPLIT ; IHS/ADC/CRG - Split Unix Area File into site files. ; [ 11/05/97  10:07 AM ]
 ;;6.0;IHS PATIENT REGISTRATION;**2**;MAR 20, 1995
 ;;Y2K/OK - IHS/ADC/ESJ 11-05-97
S ;
S1 ;Load Master tape
 D DT^DICRW S IOP="HOME" D ^%ZIS G:POP EXIT
 K ^AGSSFTMP ;kill of temp glo
 W !,"This will process multiple tapes into seperate",!,"facility files.",!
 K DIR S DIR(0)="N^0:10",DIR("A")="How many tapes/files do you have to load ?" D ^DIR K DIR
 I X'>0 G EXIT
 S AGSS("TAPES")=X
 W !,"This will take some space .. ",!,"The number of BYTES  necessary is estimated at : >>>  ",$FN(AGSS("TAPES")*12000000,","),!!
 S AGSS("CMD")="df -t" D CALL
PATH ;
 W !,"Please indicate the complete directory path you want to use.",!,?10," example:  /usr2 ",!,?10,"or ^ to exit",!
 K DIR S DIR(0)="F^0:30" S DIR("A")="Path ?  ",DIR("B")="/usr/mumps" D ^DIR K DIR
 I Y["",Y'["^"
 E  Q  ;--->
 S:Y="/" Y=""
 S AGSS("PATH")=Y_"/"
 W !,"Files will be created as: ",!,?10,AGSS("PATH"),"xxxxx.ssn",!
 K DIR S DIR(0)="Y",DIR("A")="Is this acceptable ",DIR("B")="Yes" D ^DIR K DIR
 I Y=0 G PATH ;---^
 W !,"This will display any files already present.",!
 S AGSS("CMD")="ls -l "_AGSS("PATH")_"*.ss*" D CALL
 K DIR S DIR(0)="Y",DIR("A")="Is this acceptable ",DIR("B")="Yes" D ^DIR K DIR
 I Y=0 G PATH ;---^
 D READTAPE,PROCESS
 Q
 ;-----------------
READTAPE ; read tapes
 K DIR S DIR(0)="Y",DIR("A")="Are you loading the files from nine track tape ?" D ^DIR K DIR
 I Y=0 W !,"Since you answered no  ...",!," be sure the *.ssa files are present in the previous listing.",!,"prior to processing !!.",!! Q  ;---^
 F AGSSNUM=1:1:AGSS("TAPES") D TAPE
 Q
 ;----
TAPE ; process each individual tape
 W !,"You can skip the loading of a tape with an ""^"" .",!!
 W !,"Please Load tape number : ",AGSSNUM,!,"Tape must be loaded and on-line",*7
 K DIR S DIR(0)="E" D ^DIR I $G(DUOUT) S AGSS("DUOUT")=1 Q
 W ! S AGSS("CMD")="rm "_AGSS("PATH")_"ssa_area"_AGSSNUM_".ssa" D CALL
 W !,"Reading into file "_AGSS("PATH")_"ssa_area"_AGSSNUM_".ssa",!,"Starting : " D T^AG
 S AGSS("CMD")="dd if=/dev/rmt0 of="_AGSS("PATH")_"ssa_area"_AGSSNUM_".ssa bs=68" D CALL
 W !,"Unix file "_AGSS("PATH")_"ssa_area"_AGSSNUM_".ssa loaded ..."
 D T^AG
 Q
 ;
PROCESS ;
 W !!,"This application requires two host file devices for file(s) IO",!!
 S AGSSHFC=0
 F AGSSI=51:1:54 S IOP=AGSSI D ^%ZIS I 'POP S AGSSHFC=AGSSHFC+1 S AGSSHF(AGSSHFC)=AGSSI Q:AGSSHFC=2
 I AGSSHFC<2 D  G EXIT
 .W *7,!!,"<< Sorry ... There are not 2 Host file devices available.",!,"stopping the software.",!!
 .I AGSSHFC=1 S IO=AGSSHF(AGSSHFC) D ^%ZISC D HOME^%ZIS
 K DIR S DIR(0)="Y",DIR("A")="Do you want to process ?" D ^DIR K DIR I Y=0 S DUOUT=1 Q  ;----^
 S XBIOP="0;P-DEC;80;55",XBRP="PROCESS1^AGSSPLIT",XBRX="EXIT^AGSSPLIT",XBNS="AGS" D ^XBDBQUE
 Q
 ;-----
PROCESS1 F AGSSNUM=1:1:AGSS("TAPES") D AREA
 D FINISH
 Q
 ;----
AREA ;open ssa_area file and process individual facilities
 S IOP=AGSSHF(2),%ZIS("IOPAR")="("""_AGSS("PATH")_"ssa_area"_AGSSNUM_".ssa"":""R"")"
 D ^%ZIS Q:POP
 U IO(0) W !!,"Starting Area ",AGSSNUM,!!
 D DT^DICRW
 S AGSS("LFILE")="",AGSS("RCOUNT")=0,AGSS("TCOUNT")=0
 S AGSS("CMD")="echo Start: `date` >> "_AGSS("PATH")_"ssa_stats.ssn" D CALL
 F  U AGSSHF(2) R AGX:1 Q:AGX=""  D
 .S AGSS("NFILE")=$E(AGX,1,6) I AGSS("NFILE")'=AGSS("LFILE") D
 ..I AGSS("LFILE")'="" D CLOSE ;log counts
 ..S AGSS("SFILE")=AGSS("PATH")_AGSS("NFILE")_".ssn",AGSS("FACNM")="" ;set SFILE
 ..I $D(^AUTTLOC("C",AGSS("NFILE"))) S AGSS("FACNM")=$O(^AUTTLOC("C",AGSS("NFILE"),0)) I +AGSS("FACNM"),$D(^DIC(4,AGSS("FACNM"))) S AGSS("FACNM")=$P(^DIC(4,AGSS("FACNM"),0),"^") ;set FACNM
 ..U IO(0) W !!,"Starting file : ",AGSS("SFILE"),?40,AGSS("FACNM")
 ..S AGSSIO=IO S IO=AGSSHF(1) D ^%ZISC S IO=AGSSIO K AGSSIO
 ..S %ZIS("IOPAR")="("""_AGSS("SFILE")_""":""A"")",IOP=AGSSHF(1) D ^%ZIS I POP U IO(0) W !,"NO OPEN ON AGSSHF(1)",! G:POP EXIT ;---> ;open new unix file or exit
 ..S AGSS("RCOUNT")=0
 .S AGSS("RCOUNT")=AGSS("RCOUNT")+1,AGSS("TCOUNT")=AGSS("TCOUNT")+1
 .I '(AGSS("RCOUNT")#5000) U IO(0) W !,?10,AGSS("RCOUNT"),?30,AGSS("TCOUNT"),?40 D T^AG
 .U AGSSHF(1) W AGX,! ;put AGX to unix file
 .S AGSS("LFILE")=AGSS("NFILE")
 D CLOSE
 U IO(0) W !!,"total records",?15,AGSS("TCOUNT"),?40 D T^AG W !
 S AGSS("CMD")="echo Completed : `date` >> "_AGSS("PATH")_"ssa_stats.ssn" D CALL
 Q
 ;
CLOSE ;
 S IO=AGSSHF(1) D ^%ZISC
 U IO(0) W !,AGSS("FACNM"),?30,"Finish : ",?40,AGSS("RCOUNT"),?50,AGSS("TCOUNT"),!
 S ^AGSSFTMP(AGSS("LFILE"),"RCOUNT")=$G(^AGSSFTMP(AGSS("LFILE"),"RCOUNT"))+AGSS("RCOUNT")
 S ^AGSSFTMP(AGSS("LFILE"),"NM")=AGSS("FACNM")
 I '$G(AGSS("TAPES")) K DIR S DIR(0)="N^1:9" D ^DIR K DIR Q:X'>1  S AGSS("TAPES")=X
 S AGSS("CMD")="echo '"_AGSS("SFILE")_"\t"_AGSS("RCOUNT")_"\t"_AGSS("TCOUNT")_"\t"_AGSS("FACNM")_"' >> "_AGSS("PATH")_"ssa_stats.ssn" D CALL
 Q
 ;
FINISH ;set up final files and report
 D ^AGSSPLI1
 Q
EXIT ;
 K AGSS,AGSSFAC,AGSSNUM,AGY,^AGSSFTMP,AGSSI,AGSSHFC,AGSSHF ;kill of temporary global
 Q
 ;
CALL ;
 I $G(AGSS("TRACE")) U IO(0) W !,?10,AGSS("CMD")
 S AGY="S X=$$TERMINAL^%HOSTCMD("""_AGSS("CMD")_""")" X AGY
 Q
RESTART S AGSS("CMD")="rm "_AGSS("PATH")_"*.ssn" D CALL
 Q
