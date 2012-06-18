ZISPL ;SF/RWF - UTILITIES FOR SPOOLING ;04/07/98  16:16 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**23,69**;Jul 10, 1995
 ;This is the general code for managment of the spooler file.
DELETE ;delete a document from the file.
A S DIC("A")="Delete which SPOOL DOCUMENT: " D GETDOC G:Y<0 EXIT
 I '$P(ZISPL0,U,7) W !,*7,"This Document hasn't been printed.  Are you sure??"
 S DIR(0)="S^n:NO;y:YES;c:CLEAR",DIR("A")="...OK TO DELETE",DIR("B")="NO" D ^DIR K DIR G:$D(DIRUT)!("yc"'[Y) EXIT
 S ZISY=Y D DSD($P(ZISPL0,U,10)) ;delete data
 I ZISY["c" S X=^XMB(3.51,ZISDA,0),^(0)=$P(X,"^",1)_"^^^^"_DUZ_"^^^"_$P(X,"^",8) K ^XMB(3.51,ZISDA,2) W " ... DOCUMENT CLEARED!!" G EXIT
 ;
 D DSDOC(ZISDA) ;Delete entry
 W "  ...DOCUMENT DELETED!!",*7,!
 G EXIT
DEL ;Called from mailman to delete the document.
 Q  ;Obsolete
GETDOC ;Get a spool document to work on.
 S Y=-1 Q:$D(DUZ)[0  S ZISPLU=$S($D(^VA(200,DUZ,"SPL")):^("SPL"),1:"") I $P(ZISPLU,"^",1)'["y" W !,?5,*7,"You must be authorized by IRM to use spooling" Q
 S DIC=3.51,DIC(0)="AEMQZ" D ^DIC Q:Y<0  I $P(Y(0),U,2)]"" W !,?5,*7,"This spool is still active and can't be worked on." G GETDOC
 S ZISDA=+Y,ZISPL0=Y(0) K DIC Q
 ;
PRINT ;
 N %,DIC,DIE,DR,DA,X,Y,ZISPL0,ZISPG,ZISDA,ZISDA2,ZISPLC,ZISFDA,ZISIEN,ZISIOP,ZISMSG
P S DIC("A")="Print which SPOOL DOCUMENT: " D GETDOC K IOP,%ZIS,%IS Q:Y<0
 S ZISPG=$P(ZISPL0,U,8) I $P(ZISPL0,U,3)="m" W !,"Sorry, this spool document has been converted into a mail message",!,"and you are unable to print it" G EXIT
 I $P(ZISPL0,U,10)'>0 W !,"Sorry there isn't anything to print." G EXIT
 I $P(ZISPL0,U,11) D MSG2 S %=2 D YN^DICN G EXIT:%'=1
IO ;
 S DIR(0)="N^1:99",DIR("A")="Copies to Print" D ^DIR S ZISPLC=+$G(Y) I $D(DIRUT) G EXIT
 U IO(0) S %IS="MQ" D ^%ZIS G:POP EXIT S ZISIOP=ION_";"_IOST_";"_IOM_";"_IOSL
 U IO(0) S ZISDA2=$$FIND1^DIC(3.5121,","_ZISDA_",","O",ION)
 I ZISDA2>0,$P(^XMB(3.51,ZISDA,2,ZISDA2,0),"^",3) S ZISMSG="This device is currently printing a copy of this document" G CIO
 I +ZISPG>IOM!($P(ZISPG,";",2)>IOSL) S ZISMSG="Current page is "_IOM_" by "_IOSL_$C(13,10)_" Page must be at least "_(+ZISPG)_" by "_$P(ZISPG,";",2) G CIO
 S %=$S(ZISDA2>0:ZISDA2_",",1:"?+1,")_ZISDA_","
 S ZISFDA(3.5121,%,.01)=ION,ZISFDA(3.5121,%,1)=ZISPLC D UPDATE^DIE("","ZISFDA","ZISIEN")
 S:ZISDA2'>0 ZISDA2=ZISIEN(1)
 W ! I '$D(IO("Q")) S %ZIS="",IOP=ZISIOP D ^%ZIS G:'POP DQP^ZISPL2
 S ZTRTN="DQP^ZISPL2",ZTDESC="Print spool document",ZTIO=ZISIOP,ZTSAVE("ZISDA")="",ZTSAVE("ZISDA2")="",ZTSAVE("ZISPLC")=""
 K IO("Q") D ^%ZTLOAD,^%ZISC K ZTSK G EXIT:$P(ZISPLU,"^",2)'["y" W !!,"Also send to" G IO
 ;
CIO ;Close device and go to IO
 D ^%ZISC U IO D:$D(ZISMSG)  G IO
 . W !,ZISMSG K ZISMSG
CEXIT ;Close device and Exit
 D ^%ZISC
EXIT D KILL^XUSCLEAN S ZTREQ="@" Q
 ;
KERMIT ;Use Kermit to send a spooler file
 D GETDOC Q:Y'>0  S ZISDA=$P(ZISPL0,U,10) G EXIT:ZISDA'>0 S XTKDIC="^XMBS(3.519,"_ZISDA_",2,",XTKFILE=$P(ZISPL0,U)
 D MODE^XTKERMIT G EXIT:$D(DIRUT) D SEND^XTKERMIT G EXIT
 ;
BROWSE ;Use FM Browser to look at document
 D GETDOC Q:Y'>0  S ZISDA=$P(ZISPL0,U,10) G EXIT:ZISDA'>0
 D BROWSE^DDBR($NA(^XMBS(3.519,ZISDA,2)),"NR",$P(ZISPL0,U)) G EXIT
 ;
MAIL ;Make into a mail message
 S ZISPLU=$S($D(^VA(200,DUZ,"SPL")):^("SPL"),1:"") I $P(ZISPLU,U,3)["n" W !,"You are not authorized to convert Spool Documents into Mail Messages." G EXIT
 S Y=-1 D GETDOC G:Y'>0 EXIT S XS=$P(ZISPL0,"^",10) I 'XS D MSG1 G EXIT
 S DIR(0)="Y",DIR("A")="Convert spool doc: "_$P(ZISPL0,U)_" into a mail message",DIR("B")="YES" D ^DIR G EXIT:$D(DIRUT),EXIT:Y'=1
 ;The following code will move the text from file #3.519 into file #3.9,
 S %=$P(ZISPL0,U,9) I '+% D MSG1 G EXIT
 G DQMAIL:%<500 W !,"You have "_%_" lines of text to convert into a mail message.",!,"Do you wish to queue this conversion process" S %=1 D YN^DICN G EXIT:$D(DIRUT),DQMAIL:%=2
 ;
 S ZTIO="",ZTRTN="DQMAIL^ZISPL",ZTDESC="Convert spool document into mail message",ZTSAVE("ZISDA")="" D ^%ZTLOAD G EXIT
 ;
DQMAIL W:'$D(ZTQUEUED) !,"Moving it..."
 S ZISPL0=$G(^XMB(3.51,ZISDA,0)),XS=$P(ZISPL0,"^",10),XMY(DUZ)="",XMTEXT="^XMBS(3.519,"_XS_",2,",XMSUB="Spool document: "_$P(ZISPL0,"^")
 D:XS>0 ^XMD ;to make new I $D(XMZ) S XMDUZ=DUZ D NNEW^XMA
 D DSDOC(ZISDA),DSD(XS) W:'$D(ZTQUEUED) !,"  Now a normal mail message.."
 G EXIT
 ;
DSD(DA) ;Delete an entry in the spool data file.
 Q:DA'>0  N DIK K ^XMB(3.51,"AM",DA) S DIK="^XMBS(3.519," D ^DIK
 Q
DSDOC(DA) ;Delete an entry in the spool doc file.
 Q:DA'>0  N DIK S DIK="^XMB(3.51," D ^DIK
 Q
 ;
MSG1 W !,"This spool document doesn't have any text." Q
MSG2 W !,"You have exceeded the total spool document line limit allowed."
 W !,"Therefore, this spool document is incomplete."
 W !!,"Do you still wish to print this document" Q
 ;
