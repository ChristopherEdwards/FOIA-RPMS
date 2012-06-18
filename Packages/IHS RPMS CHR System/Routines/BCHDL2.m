BCHDL2 ; IHS/TUCSON/LAB - DOWNLOAD TABLES [ 06/19/02  7:22 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**14**;OCT 28, 1996
 ;IHS/CMI/LAB - tmp to xtmp
 ;
START ;
 W:$D(IOF) @IOF
 W !!?9,"**** DOWNLOAD STANDARD TABLES FOR REMOTE ****",!!
 W "This routine is to be run whenever a CHR wants to download the standard  ",!,"tables to the remote system.",!
 W !,"The following tables will be downloaded in a format readable by the remote",!,"software:"
 ;W !!,"FILE",?25,"FILE NAME CREATED"
 ;W !,"AREA",?25,"chrarea.txt"
 ;W !,"SERVICE UNIT",?25,"chrsu.txt"
 ;W !,"FACILITY",?25,"chrfac.txt"
 ;W !,"COMMUNITY",?25,"chrcomm.txt"
 W !,"PROGRAM",?25,"chrprog"_DT_".txt"
 ;W !,"TRIBE",?25,"chrtribe.txt"
 W !,"HEALTH PROBLEM CODES",?25,"chrhlthprob"_DT_".txt"
 W !,"SERVICE CODES",?25,"chrsrvcode"_DT_".txt"
 W !,"REFERRAL CODES",?25,"chrrefcode"_DT_".txt"
 W !,"FAMILY PLANNING CODE",?25,"chrfamplancode"_DT_".txt"
 W !,"These file(s) will be placed in the same directory that all export"
 W !,"files are placed.  In most cases, that will be /usr/spool/uucppublic."
 W !,"See your site manager for assistance in finding the files once it has"
 W !,"been created.",!!
 ;
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue tables files",DIR("B")="N" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:'Y XIT
 ;dump each table
AREA ;
 ;K ^TMP($J)
 ;W !!,"Downloading Area table"
 ;S (BCHC,BCHX)=0 F  S BCHX=$O(^AUTTAREA(BCHX)) Q:BCHX'=+BCHX  D
 ;.S R=""
 ;.S X=$P(^AUTTAREA(BCHX,0),U),Y=$P(^AUTTAREA(BCHX,0),U,2),Z=0
 ;.S R=Y_","_X_","_Z
 ;.S BCHC=BCHC+1,^TMP($J,"AREA",BCHC)=R
 ;.Q
 ;S XBGL="TMP("_$J_",""AREA"","
 ;S XBMED="F",XBFN="chrarea"_DT_".txt",XBTLE="SAVE OF AREA FOR CHR DOWNLOAD"
 ;S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 ;D ^XBGSAVE
SU ;
 ;K ^TMP($J)
 ;W !!,"Downloading Service Unit table"
 ;S (BCHC,BCHX)=0 F  S BCHX=$O(^AUTTSU(BCHX)) Q:BCHX'=+BCHX  D
 ;.S R=""
 ;.S X=$P(^AUTTSU(BCHX,0),U),Y=$P(^AUTTSU(BCHX,0),U,4),Z=0
 ;.S R=Y_","_X_","_Z
 ;.S BCHC=BCHC+1,^TMP($J,"SU",BCHC)=R
 ;.Q
 ;S XBGL="TMP("_$J_",""SU"","
 ;S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 ;D ^XBGSAVE
FAC ;
 ;K ^TMP($J)
 ;W !!,"Downloading Facility table"
 ;S (BCHC,BCHX)=0 F  S BCHX=$O(^AUTTLOC(BCHX)) Q:BCHX'=+BCHX  D
 ;.S R=""
 ;.S X=$P(^DIC(4,BCHX,0),U),Y=$P(^AUTTLOC(BCHX,0),U,10),Z=$S($P(^AUTTLOC(BCHX,0),U,21)]"":1,1:0)
 ;.S R=Y_","_X_","_Z
 ;.S BCHC=BCHC+1,^TMP($J,"LOC",BCHC)=R
 ;.Q
 ;S XBMED="F",XBFN="chrfac"_DT_".txt",XBTLE="SAVE OF FAC FOR CHR DOWNLOAD"
 ; S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 ;D ^XBGSAVE
COMM ;
 ;K ^TMP($J)
 ;W !!,"Downloading Community table"
 ;S (BCHC,BCHX)=0 F  S BCHX=$O(^AUTTCOM(BCHX)) Q:BCHX'=+BCHX  D
 ;.S R=""
 ;.S X=$P(^AUTTCOM(BCHX,0),U),Y=$P(^AUTTCOM(BCHX,0),U,8),Z=0
 ;.S R=Y_","_X_","_Z
 ;.S BCHC=BCHC+1,^TMP($J,"COM",BCHC)=R
 ;.Q
 ;S XBGL="TMP("_$J_",""COM"","
 ;S XBMED="F",XBFN="chrcomm"_DT_".txt",XBTLE="SAVE OF COM FOR CHR DOWNLOAD"
 ;S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 ;D ^XBGSAVE
TRIBE ;
 ;K ^TMP($J)
 ;W !!,"Downloading Tribe table"
 ;S (BCHC,BCHX)=0 F  S BCHX=$O(^AUTTTRI(BCHX)) Q:BCHX'=+BCHX  D
 ;.S R=""
 ;.S X=$P(^AUTTTRI(BCHX,0),U),Y=$P(^AUTTTRI(BCHX,0),U,2),Z=$P(^AUTTTRI(BCHX,0),U,4),Z=$S(Z="Y":1,1:0)
 ;.S R=Y_","_X_","_Z
 ;.S BCHC=BCHC+1,^TMP($J,"TRI",BCHC)=R
 ;.Q
 ;S XBGL="TMP("_$J_",""TRI"","
 ;S XBMED="F",XBFN="chrtribe"_DT_".txt",XBTLE="SAVE OF TRI FOR CHR DOWNLOAD"
 ;S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 ;D ^XBGSAVE
PROG ;
 K ^TMP($J)
 W !!,"Downloading Program table"
 S (BCHC,BCHX)=0 F  S BCHX=$O(^BCHTPROG(BCHX)) Q:BCHX'=+BCHX  D
 .S R=""
 .S X=$P(^BCHTPROG(BCHX,0),U),Y=$P(^BCHTPROG(BCHX,0),U,5),Z=0
 .S R=Y_"|"_X_"|"_Z
 .S BCHC=BCHC+1,^TMP($J,"PROG",BCHC)=R
 .Q
 S XBGL="TMP("_$J_",""PROG"","
 S XBMED="F",XBFN="chrprog"_DT_".txt",XBTLE="SAVE OF PROG FOR CHR DOWNLOAD"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
HP ;
 K ^TMP($J)
 W !!,"Downloading Health Problem table"
 S (BCHC,BCHX)=0 F  S BCHX=$O(^BCHTPROB(BCHX)) Q:BCHX'=+BCHX  D
 .S R=""
 .S X=$P(^BCHTPROB(BCHX,0),U,2),Y=$P(^BCHTPROB(BCHX,0),U,1)
 .S R=X_"|"_Y_"|"_$P(^BCHTPROB(BCHX,0),U,6)
 .S BCHC=BCHC+1,^TMP($J,"PROB",BCHC)=R
 .Q
 S XBGL="TMP("_$J_",""PROB"","
 S XBMED="F",XBFN="chrhlthprob"_DT_".txt",XBTLE="SAVE OF PROB FOR CHR DOWNLOAD"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
SVC ;
 K ^TMP($J)
 W !!,"Downloading Service Code table"
 S (BCHC,BCHX)=0 F  S BCHX=$O(^BCHTSERV(BCHX)) Q:BCHX'=+BCHX  D
 .S R=""
 .S X=$P(^BCHTSERV(BCHX,0),U,3),Y=$P(^BCHTSERV(BCHX,0),U,1)_"|"_$P(^BCHTSERV(BCHX,0),U,2)
 .S R=X_"|"_Y
 .S BCHC=BCHC+1,^TMP($J,"SERV",BCHC)=R
 .Q
 S XBGL="TMP("_$J_",""SERV"","
 S XBMED="F",XBFN="chrsrvcode"_DT_".txt",XBTLE="SAVE OF SERV FOR CHR DOWNLOAD"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
REF ;
 K ^TMP($J)
 W !!,"Downloading Referral table"
 S (BCHC,BCHX)=0 F  S BCHX=$O(^BCHTREF(BCHX)) Q:BCHX'=+BCHX  D
 .S R=""
 .S X=$P(^BCHTREF(BCHX,0),U,2),Y=$P(^BCHTREF(BCHX,0),U,1),Z=$P(^BCHTREF(BCHX,0),U,3)
 .S R=Z_"|"_Y_"|"_X
 .S BCHC=BCHC+1,^TMP($J,"REF",BCHC)=R
 .Q
 S XBGL="TMP("_$J_",""REF"","
 S XBMED="F",XBFN="chrrefcode"_DT_".txt",XBTLE="SAVE OF REFERRAL FOR CHR DOWNLOAD"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
FPC ;
 K ^TMP($J)
 W !!,"Downloading FAMILY PLANNING CODES"
 S (BCHC,BCHX)=0 F  S BCHX=$O(^BCHTFPM(BCHX)) Q:BCHX'=+BCHX  D
 .S R=""
 .S X=$P(^BCHTFPM(BCHX,0),U,2),Y=$P(^BCHTFPM(BCHX,0),U,1),Z=$P(^BCHTFPM(BCHX,0),U,3)
 .S R=X_"|"_Y
 .S BCHC=BCHC+1,^TMP($J,"FPM",BCHC)=R
 .Q
 S XBGL="TMP("_$J_",""FPM"","
 S XBMED="F",XBFN="chrfamplancode"_DT_".txt",XBTLE="SAVE OF FPM FOR CHR DOWNLOAD"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 D ^XBGSAVE
XIT ;
 K BCHX,BCHC
 Q
QU(X) ;quote a string
 I X]"" S X=""""_X_""""
 Q X
 ;
