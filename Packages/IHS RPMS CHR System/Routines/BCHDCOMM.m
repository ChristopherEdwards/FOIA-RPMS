BCHDCOMM ; IHS/TUCSON/LAB - COMMUNITY DOWNLOAD ROUTINE ;  [ 06/03/99  8:56 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**7**;OCT 28, 1996
 ;
 ;Generates COMMUNITY file for uploading onto the remote
 ;computer systems.
 ;
EP ;
 W:$D(IOF) @IOF
 W !!,"This utility routine is used to download, by Area, all communities in the",!,"COMMUNITY file to the remote computer."
 W !!,"You will be asked to enter your Area.  A unix file will be created",!,"called communit.imp.  It must be then put in the C:\CHR directory on the ",!,"remote and uploaded into that machine.",!!
 ;
 S C=0
 K ^XTMP("BCH COMMUNITIES",$J)
 S ^XTMP("BCH COMMUNITIES",0)=$$FMADD^XLFDT(DT,14)_U_DT_"CHR DOWNLOAD"
 D AREA
 Q:'BCHQ
 D COMM
 D WRITEF
 D XIT
 Q
 ;
 ;---------------------------------------------
AREA ;select desired area
 S BCHQ=1
 S DIC="^AUTTAREA(",DIC(0)="AEMQ" D ^DIC
 I Y=-1 W:'$D(^XTMP("BCH COMMUNITIES")) !!,"NO AREA SELECTED." S BCHQ=0 Q
 S BCHAREA=+Y
 Q
COMM ;get communities and set in ^XTMP
 S BCHIEN=0 F  S BCHIEN=$O(^AUTTCOM(BCHIEN)) Q:BCHIEN'=+BCHIEN  D
 .  Q:$P(^AUTTCOM(BCHIEN,0),U,6)'=BCHAREA
 .  S C=C+1
 .  S ^XTMP("BCH COMMUNITIES",$J,C)=""""_$P(^AUTTCOM(BCHIEN,0),U,8)_""""_","_""""_$P(^AUTTCOM(BCHIEN,0),U)_""""
 .  Q
 Q
 ;
WRITEF ;EP - write out flat file
 I '$D(^XTMP("BCH COMMUNITIES")) W !!,"NO COMMUNITIES SELECTED." G XIT
 W !,"You have selected ",C," communites to be downloaded.  Here they are: " H 2 S X=0 F  S X=$O(^XTMP("BCH COMMUNITIES",$J,X)) Q:X'=+X  W !,^XTMP("BCH COMMUNITIES",$J,X)
 W !
 S DIR(0)="Y",DIR("A")="Do you wish to continue",DIR("B")="Y" K DA D ^DIR K DIR
 I $D(DIRUT)!('Y) W !!,"BYE",! G XIT
 S XBGL="TMP("_"""BCH COMMUNITIES"""_","_$J_","
 S XBMED="F",XBFN="communit.imp",XBTLE="SAVE OF COMMUNITIES"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
 Q
XIT ;
 K ^XTMP("BCH COMMUNITIES",$J)
 K BCHQ,C,X
 Q
