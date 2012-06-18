BCHPRDL ; IHS/TUCSON/LAB - DOWNLOAD PROVIDER DATA TO REMOTE ;  [ 08/21/02  11:14 AM ]
 ;;1.0;IHS RPMS CHR SYSTEM;**14**;OCT 28, 1996
 ;
 ;Routine to create a file of records containing providers 
 ;demographic information to be downloaded to a remote computer.
 ;See START sub-routine for explanation.
 ;
START ;EP
 W:$D(IOF) @IOF
 W !!?9,"**** DOWNLOAD PROVIDER DATA TO REMOTE ****",!!
 W "This routine is to be run whenever a CHR wants to download the list of",!,"CHR's to a laptop.",!
 W !,"A file of records will be created called 'chrprov.txt'."
 W !,"This file will be placed in the same directory that all export"
 W !,"files are placed.  In most cases, that will be /usr/spool/uucppublic."
 W !,"See your site manager for assistance in finding the file once it has"
 W !,"been created.",!!
 ;
CONT ;
 S DIR(0)="Y",DIR("A")="Do you wish to continue and create a download providers file",DIR("B")="N" K DA D ^DIR K DIR
 G:$D(DIRUT) XIT
 G:'Y XIT
ZIS ;call to xbdbque
 D XIT
QUEUE ;EP
 D WAIT^DICD,PROC,XIT,XIT1
 Q
PROC ;
 S BCHC=0
 K ^CHRTMP($J,"CHR PROVIDERS")
 S BCHX=0 F  S BCHX=$O(^VA(200,BCHX)) Q:BCHX'=+BCHX  D
 .S X=$$VALI^XBDIQ1(200,BCHX,53.5)
 .Q:'X
 .Q:$P($G(^DIC(7,X,9999999)),U)'=53
 .D TX
 .Q
 D WRITEF
 Q
 ;
TX ;
 S BCHY="",BCHC=BCHC+1
 S $P(BCHY,"|",1)=BCHX
 S $P(BCHY,"|",2)=$P($G(^VA(200,BCHX,9999999)),U,9)
 S $P(BCHY,"|",3)=$P(^AUTTLOC(DUZ(2),0),U,10)
 S $P(BCHY,"|",4)=DUZ(2)
 S $P(BCHY,"|",5)=""
 S $P(BCHY,"|",6)=""
 S $P(BCHY,"|",7)=""
 S X=$P(^VA(200,BCHX,0),U)
 S $P(BCHY,"|",10)=$P(X,",",1)
 S $P(BCHY,"|",9)=$P($P(X,",",2)," ",2)
 S $P(BCHY,"|",8)=$P($P(X,",",2)," ",1)
 S $P(BCHY,"|",11)=$$VAL^XBDIQ1(200,BCHX,.111)
 S $P(BCHY,"|",12)=$$VAL^XBDIQ1(200,BCHX,.112)
 S $P(BCHY,"|",13)=$$VAL^XBDIQ1(200,BCHX,.114)
 S $P(BCHY,"|",14)=$$VAL^XBDIQ1(200,BCHX,.115)
 S $P(BCHY,"|",15)=$$VAL^XBDIQ1(200,BCHX,.116)
 S $P(BCHY,"|",16)=""
 S $P(BCHY,"|",17)=$$VAL^XBDIQ1(200,BCHX,.131)
 S $P(BCHY,"|",18)=$$VAL^XBDIQ1(200,BCHX,.134)
 S ^CHRTMP($J,"CHR PROVIDERS",BCHC)=BCHY
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
WRITEF ;EP - write out flat file
 S XBGL="CHRTMP("_$J_",""CHR PROVIDERS"","
 S XBMED="F",XBFN="chrprov.txt",XBTLE="SAVE OF PROVIDERS FOR CHR DOWNLOAD"
 S XBF=0,XBQ="N",XBFLT=1,XBE=$J
 W:'$D(ZTQUEUED) !!
 D ^XBGSAVE
 ;
WRITEFX ;
 W !!,$C(7),$C(7),"A TOTAL of *** ",BCHC," *** providers were downloaded.",!!
 K ^CHRTMP($J,"CHR PROVIDERS")
 Q
