%ZISPL ; cmi/flag/maw - MVB,GFT,RMG 30 Dec 94 12:51 UTILITIES FOR SPOOLING IN VAX DSM ; [ 05/22/2002  2:53 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUL 01, 2001
 ;CHCS TLS_4602; GEN 2; 12-NOV-1998
 ;COPYRIGHT 1988, 1989, 1990 SAIC
ZSPLDEL ;
A K DIC S DIC("A")="Delete which SPOOL DOCUMENT: ",DIC=3.51,DIC(0)="AEQMZ"
 D DICS,^DIC K DIC Q:Y<0
 W !?8,"...Ok to Delete" Q:'$$YN^%ZTF(0,1)
DEL S DR=".01///@",DIE=3.51,DA=+Y,DOC=$P($G(^(1)),U,1) K DIC D ^DIE Q:$D(DA)  ;naked on ^XUSPLDSM(+Y,1)
 Q
ZTSKDEL ;Entry point for auto delete of documents - works off expiration date
 S ZISDA=0 F  S ZISDA=$O(^XUSPLDSM(ZISDA)) Q:'ZISDA  S X=$G(^(ZISDA,0)) I $L(X),$P(X,U,8),$P(X,U,8)<DT S Y=ZISDA D DEL
 Q
 ;
DELFFN ; external extry point for cross-ref on .01 field of spool document file
 ; to delete VMS spool file upon deletion of an entry in spool doc file.
 S DOC=$P($G(^XUSPLDSM(DA,1)),U),$ZT="PROERR^%ZISPL"
 ;I $L(DOC),$ZC(%PARSE,DOC,,,"DIRECTORY")'="" O DOC C DOC:DELETE S DOC="",$ZT=""
 W !,"  ...VMS Spool File Deleted!!",*7,!
 Q
PROERR I $ZE["-E-PRV"!($ZE["-NOPRIV") W:'$D(ZTSK) !,"Insufficient privilege to delete VMS Spool File.",! Q
 ZQ
PERR ;Print selection error - file has been deleted or not created yet (queued)
 W !,"A file does not yet exist or has been deleted for this document"
ZSPLPRIN ;
P K DIC S DIC=3.51,DIC(0)="AQMEZ"
 D DICS,^DIC K DIC,IOP,%ZIS,%IS Q:Y<0
 S ZISDOC=$G(^(1)),ZISDA=+Y ;naked on ^XUSPLDSM(+Y,)
 I '$L(ZISDOC) W !,"The file containing document ",$P($G(^XUSPLDSM(ZISDA,0)),U,1)," does not exist",*7 K ZISDOC,ZISDA Q
 S $ZT="PERR^%ZISPL",X=1 O ZISDOC:READ:3 S $ZT="" D:'$T  C:X ZISDOC I 'X,"Yy"'[$E(X) G P
 .W !!!,*7,"This document is currently in use and if this print is not queued your crt"
 .W !,"will hang until the document is free"
 .R !,"Do you wish to continue ? No// ",X:$S($G(DTIME):DTIME,1:60) S:'$L(X) X="N"
T R !,"Number of Copies: 1// ",ZISCOPY:$S($G(DTIME):DTIME,1:300) G:ZISCOPY=U CLOSE S:'ZISCOPY ZISCOPY=1 I ZISCOPY'?.N W *7," ??" G T
 S %ZIS("A")="Output to: ",%ZIS="Q" D ^%ZIS Q:POP
 G:'$G(IO("Q")) TCONT
 S ZTRTN="ENTSK^%ZISPL",ZTIO=ION_";"_IOST_";"_IOM_";"_IOSL,ZTSAVE("DESC")="Print a Spooled document"
 F %="ZISCOPY","ZISDA","ZISDOC" S ZTSAVE(%)=@%
 D ^%ZISC S ZTDTH=$H D ^%ZTLOAD K ZTSK G KILL
 ;
ENTSK ;Entry point from taskman or application print
 ;variables needed: ZISDOC=VMS spool doc name (optional),
 ; ZISCOPY=# of copies (optional),
 ; ZISDA=internal number of spool doc (file 3.51) -REQUIRED
 Q:'$G(ZISDA)  S:'$D(ZISDOC) ZISDOC=$G(^XUSPLDSM(ZISDA,1)) S:'$D(ZISCOPY) ZISCOPY=1
 D:$L(ZISDOC) TCONT K ZISCOPY,ZISDA,ZISDOC K:$G(ZTSK) ^%ZTSK(ZTSK),ZTSK Q
 ;
TCONT D 1^DICRW S $ZT="NODOC^%ZISPL" O ZISDOC:READ S $ZT="" F ZISCOPY=ZISCOPY:-1:1 D OUT
 C ZISDOC S $P(^XUSPLDSM(ZISDA,0),U,7)=$$NOW^%ZTFDT
CLOSE D ^%ZISC
KILL K %,DIC,ZISDOC,ZISCOPY,ZISDA Q
 ;
NODOC ;Error message if VMS file has been deleted
 U IO W !,"The file containing document ",$P($G(^XUSPLDSM(ZISDA,0)),U,1)," does not exist",*7
 S $ZT="" D CLOSE Q
OUT S $ZT="OUTERR" U IO:PACK W @IOF F  U ZISDOC R X U IO W X,!
OUTERR I $ZE["-ENDOFILE" U ZISDOC:DISCONNECT Q
 ZQ
 ;
DICS ;Build screen for filemanager access - also called from %ZIS2
 S DIC("S")="I '$L($P(^(0),U,3))!(DUZ(0)=""@"")!(DUZ(0)[""#"")!($L(DUZ(0))'=$L($TR(DUZ(0),$P(^(0),U,3))))"
 Q
 ;
ZSPLIST ;
L ;
 K DIC S D="B",DIC="^XUSPLDSM(",DIC(0)="E"
 D DICS,DQ^DICQ K DIC,DO
 Q
EDIT ;Edit check of file 3.51 name field
 I $L(X)>80!($L(X)<3) W !,"Name too ",$S($L(X<3):"short",1:"long") K X Q
 N % F %=1:1:$L(X) I $E(X,%)'?1AN&("-  _"'[$E(X,%)) W !,"Sorry, '",$E(X,%),"' is not allowed in spool document name" K X Q
 Q
XM ;
 S DIC=3.9,DIC(0)="AEQM",DIC("S")="I $P(^(0),U,2)=DUZ",DIC("A")="Select a MAILMAN MESSAGE you have sent: "
 S DIC("W")="W ?70 S %=$P(^(0),U,3) W $E(%,4,5)_""/""_$E(%,6,7)_""/""_$E(%,2,3)"
 D ^DIC K DIC Q:Y<0  S ZXM=+Y
 S DIC=3.51,DIC(0)="AEZMQ" S:DUZ(0)'="@" DIC("S")="I $TR(DUZ(0),$P(^(0),U,3))'=DUZ(0)!'$L($P(^(0),U,3))"
 D ^DIC K DIC Q:Y<0  S Z=^(1) F I=1:1 Q:'$D(^XMB9(ZXM,2,I))  ;naked on ^XUSPLDSM(+Y,)
 W !,"Are you ready to insert this document,",!?8,"starting as line #"_I_" of the message" Q:'$$YN^%ZTF(1,1)
 S $ZT="ERRXM" O Z:READ U Z F I=I:1 R X S ^XMB9(ZXM,2,I,0)=X I I#10 W "."
ERRXM ;EOF CHECK
 I $ZE["-ENDOFILE," C Z U 0 S I=I-1,$P(^XMB9(ZXM,2,0),U,3,5)=I_U_I_DT W !!,"..DONE!",!! K %,ZXM,X,Y,Z,I Q
 ZQ
