INHOU3 ;DP; 27 Jan 98 15:10;List Queued Tansactions. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
QTSK ;Display currently queued entries
 K ^UTILITY($J)
 N DA,DIC,DIE,DIK
 N DDSFILE,DR,DDSPAGE,DDSPARM,DDSSAVE
 I $O(^INLHSCH(""))'?1.N,$O(^INLHDEST(""))'?1.N D  Q
 .W !!,"There are no entries queued for processing." Q
 S X=$J_"_"_DUZ_"_"_$P($H,",",2),DIC=4001.1,DIC(0)="L",DLAYGO=4001.1
 D ^DIC S INDA=+Y
 I +Y<0 D ERR^INHMS2("Unable to create file ") Q
 S DA=INDA,DWN="INH QUEUE LIST",DIE=4001.1
 ;Check for IHS
 I $$SC^INHUTIL1 D  Q:'$D(DWFILE)
 .S DWASK="" D ^DWC
 I '$$SC^INHUTIL1 D  Q:'$G(DDSSAVE)
 .N INDIC S INDIC=DIC N DIC S DIC=INDIC
 .S DDSFILE=DIE,DR="["_DWN_"]",DDSPAGE=1,DDSPARM="SC"
 .D ^DDS
 K IOP S %ZIS="N" D ^%ZIS Q:POP
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 N DIZ M DIZ(4001.1,INDA)=^DIZ(4001.1,INDA)
 S ZTIO=IOP I IO'=IO(0) D  Q
 .S ZTRTN="QZTSK^INHOU3"
 .S ZTDESC="List of Queued Interface Transactions"
 .;N DIZ M DIZ(4001.1,INDA)=^DIZ(4001.1,INDA) S ZTSAVE("DIZ(")=""
 .S ZTSAVE("DIZ(")=""
 .S ZTSAVE("INDA")=INDA D ^%ZTLOAD
 S DA=INDA,DIK=DIC D ^DIK
 S %ZIS="" D ^%ZIS
 I POP W *7,!,"Unable to find device" D ^%ZISC Q
 ;
QZTSK ;TaskMan entry point
 N DIOUT,DUOUT,INH,INLOOP,D0,INDX,X,Y,%
 N INDET,QUE,PRIO,PRI,DIRC,DEST,INBEG,INEND,INSEL,INQUE,DA,DES,DETL,PAG,PC,INBEG1,INE,INEND1,INH1,INLN,QUE1,COUNT
 ;Initialize variables
 ;Details
 S INDET=+$P($G(DIZ(4001.1,INDA,20)),U,3)
 ;Queue
 S QUE=$G(DIZ(4001.1,INDA,8))
 ;Priority
 S PRIO=$P($G(DIZ(4001.1,INDA,20)),U,11)
 ;Direction
 S DIRC=$G(DIZ(4001.1,INDA,6))
 ;Destination
 S DEST=$G(DIZ(4001.1,INDA,2))
 ;Start date
 S INBEG=$G(DIZ(4001.1,INDA,1))
 S:INBEG="" INBEG=$O(^INTHU("B",""))
 S:INBEG'["." INBEG=INBEG_".0"
 ;End date
 S INEND=$G(DIZ(4001.1,INDA,1.1))
 S:'$L(INEND) INEND=DT S:INEND'["." INEND=INEND_".24"
 S POP=0 D SHDR
 ;Cnvert date to $h format
 S INBEG1=$$CDATF2H^%ZTFDT(INBEG)
 S INEND1=$$CDATF2H^%ZTFDT(INEND)
 I QUE'?1N D  D CLOSE Q
 .F INQUE=0,1 D @INQUE,DIPA
 I QUE=0!QUE=1 D @QUE,DIPA
CLOSE ;Close device
 I POP D ^%ZISC Q
 F I=1:1:IOSL-$Y-3 W !
 S X="End of Report" W ?IOM-$L(X)\2,X
 D ^%ZISC
 Q
0 ;^INLHSCH QUEUE
 S PRI="",(POP,CNT,QUE1)=0 D HDR
 F  S PRI=$O(^INLHSCH(PRI)) Q:PRI=""!POP  D
 .I PRIO'="" Q:PRI>PRIO
 .S INH=INBEG1_","_($P(INBEG1,",",2)-1),D0=0
 .F  S INH=$O(^INLHSCH(PRI,INH))  Q:'$L(INH)!POP!($$DTCHK(INBEG1,INEND1,INH)=2)  D
 ..Q:INH<INBEG1
 ..F  S D0=$O(^INLHSCH(PRI,INH,D0)) Q:'D0!POP  D
 ...S DETL=$G(^INTHU(D0,0)) Q:DETL=""
 ...I DIRC'="" Q:$P(DETL,U,10)'=DIRC
 ...I DEST'="" Q:$P(DETL,U,2)'=DEST
 ...S CNT=CNT+1 D DIPA
 I 'CNT S X="No entries in queue INLHSCH" W ?IOM-$L(X)\2,X,!
 I CNT S X="End of queue INLHSCH" W ?IOM-$L(X)\2,X,!
 D CR
 Q
1 ;^INLHDEST QUEUE
 Q:POP  Q:DIRC="I"
 S DES="",(POP,CNT)=0,QUE1=1 D HDR
 F  S DES=$O(^INLHDEST(DES)) Q:DES=""!POP  D
 .D:$Y>(IOSL-3) HDR Q:POP
 .I DEST'="" Q:DEST'=DES
 .W !,"DESTINATION: ",$P($G(^INRHD(DES,0)),U),!
 .S PRI="" F  S PRI=$O(^INLHDEST(DES,PRI)) Q:PRI=""!POP  D
 ..I PRIO'="" Q:PRI>PRIO
 ..S INH=INBEG1_","_($P(INBEG1,",",2)-1),D0=0
 ..F  S INH=$O(^INLHDEST(DES,PRI,INH))  Q:'$L(INH)!POP!($$DTCHK(INBEG1,INEND1,INH)=2)  D
 ...Q:INH<INBEG1
 ...F  S D0=$O(^INLHDEST(DES,PRI,INH,D0)) Q:'D0!POP  S CNT=CNT+1 D DIPA
 I 'CNT S X="No entries in queue INLDEST" W ?IOM-$L(X)\2,X,!
 I CNT S X="End of queue INLHDEST" W ?IOM-$L(X)\2,X,!
 D CR  ;added by DGH for IHS port
 Q
DIPA ;
 Q:'$G(D0)  S INE=D0
 Q:'$D(^INTHU(INE,0))
 S DETL=^INTHU(INE,0)
 I 'INDET D  Q
 .S INH1=$P(DETL,U)
 .W $$DATEFMT^UTDT(INH1,"MM/DD@HH:II")
 .W ?14,$E($P(DETL,U,16),1,4)
 .W ?19,$P(DETL,U,5)
 .S PC=$P(DETL,U,2),PC=$S(PC="":PC,$D(^INRHD(PC,0))#2:$P(^(0),U),1:" "_PC)
 .W ?40,$E(PC,1,35),!
 .D:$Y>(IOSL-3) HDR
 W $$DATEFMT^UTDT($P(DETL,U),"MM/DD@HH:II") K DIP
 ;PRIORITY
 W ?14,$E($P(DETL,U,16),1,4)
 ;Status
 N PC S PC=$P(DETL,U,3)
 W ?19,$S(PC="":PC,$D(INDX(PC)):INDX(PC),1:PC)
 ;ID
 W ?24,$E($P(DETL,U,5),1,18)
 ;Destination
 S PC=$P(DETL,U,2)
 S PC=$S(PC="":PC,$D(^INRHD(PC,0))#2:$P(^(0),U),1:" "_PC)
 W ?35,$E(PC,1,35)
 ;Source
 W !?35,$P(^INRHT($P(DETL,U,11),0),U)
 I $Y>(IOSL-3) D HDR Q
 W !
 Q
 ;
SHDR ;set header
 K INLN S X=$$CDATASC^%ZTFDT($H,1,1),INLN(0)=X_" Page ",PAG=1
 S INLN(1)="List Queued Transaction Report"
 S X="From: "_$$CDATASC^%ZTFDT($E(INBEG,1,10),3,1)
 I INEND'="" D
 .S X=X_"      To: "_$$CDATASC^%ZTFDT($E(INEND,1,10),3,1)
 S INLN(2)=X
 ;get the site name
 S INLN(6)=$S($D(^DIC(4,^DD("SITE",1),0)):^(0),1:^DD("SITE"))
 S INLN(6)=$S($P(INLN(6),U,4)]"":$P(INLN(6),U,4),1:$P(INLN(6),U,1))
 S INLN="",$P(INLN,"-",IOM+1)=""
 S INLN(7)=" Date/Time  Prio Status    ID     Destination / Tran. Type"
 I 'INDET S INLN(7)=" Date/Time  Prio    ID                 Destination"
 D TEXT Q
 ;
HDR ;Print header
 ;S POP=0 I $P=IO I $Y>(IOSL-4) D CR
 S POP=0 I $P(IOST,"-")["C",IO=IO(0),$Y>(IOSL-4) D CR Q:POP
 I PAG>1!($P(IOST,"-")["C") W @IOF
 W !,INLN(6)
 S X=INLN(0)_PAG,PAG=PAG+1
 W ?IOM-$L(X)-1,X,!
 F I=1,2 W !?IOM-$L(INLN(I))\2,INLN(I)
 ;S X="Queue: "_$S(QUE=0:"INLHSCH",QUE=1:"INLHDEST",1:"ALL QUEUES")
 ;S X="Queue: "_$S($G(INQUE)=0:"INLHSCH",1:"INLHDEST")
 S X="Queue: "_$S(QUE1=0:"INLHSCH",1:"INLHDEST")
 W !?IOM-$L(X)\2,X D:'$D(INSEL) SEL
 W !,INLN(7),!,INLN,!
 Q
CR ;
 I IO'=IO(0)!($E(IOST)="P") Q
 W !,"Press <RETURN> to continue. " R X:DTIME S:X[U POP=1
 Q
SEL ;Display selection criteria
 W !,"Selection Criteria: "
 W !,"Queue:            ",$S(QUE=0:"INLHSCH",QUE=1:"INLHDEST",1:"All")
 W !,"Cut Off Priority: ",$S(PRIO?1.N:PRIO,1:"All")
 W !,"Direction:        ",$S(DIRC="I":"In",DIRC="O":"Out",1:"All")
 W !,"Destination:      ",$S(DEST="":"All",$D(^INRHD(DEST,0))#2:$P(^(0),U),1:" "_DEST)
 W !,"Detailed:         ",$S(INDET=0:"No",1:"Yes"),!
 S INSEL=1
 Q
TEXT ;Set up status array
 S INDX("A")="ACCEPT A"
 S INDX("C")="COMPLETE"
 S INDX("E")="ERROR"
 S INDX("K")="NEGATIVE"
 S INDX("N")="NEW"
 S INDX("P")="PENDING"
 S INDX("S")="SENT (Aw"
 Q
QUE ;Select que
 I X[U!(X="^") S POP=1 Q
 N QUE1,INX S INX=X
 S X=$$UPCASE^%ZTF(X)
 S X=$S('$L(X):"",X=1:1,X=0:0,X["INLHSCH":0,X["INLHDEST":1,X="ALL":"ALL",1:2)
 I X=2 K X Q
 S QUE1=$S('$L(X):"ALL",X=0:"^INLHSCH",X=1:"^INLHDEST",1:"ALL")
 I $L(INX)=1,QUE1'=INX W " ",QUE1
 I $O(@QUE1@(""))'?.N D MESS^DWD(4) W ?10,QUE1_" is empty",!,?10,"Press <RETURN> to continue. " R X:DTIME K X
 Q
HELP ;
 W !,"Select Queue: 0=INLHSCH"
 W !,"              1=INLHDEST"
 W !!,"Press 'Enter' to select all queues"
 Q
HELP1 ;Help text for IHS
 N INMSG
 S INMSG="Select Queue: 0=INLHSCH or 1=INLHDEST"
 D HLP^DDSUTL(.INMSG)
 Q
 ;
DTCHK(INBEG1,INEND1,INH) ;check queue entry to see if it's in time range
 ;INBEG1=Selected start time
 ;INEND1=Selected end date/time
 ;INH=Date/time of entry in queue
 ;RETURNS -- 0 if TIME is between START and STOP
 ;        -- 1 if TIME is before START
 ;        -- 2 if TIME is after STOP
 Q:INH<INBEG1 1  Q:INH>INEND1 2
 Q:$P(INH,",",2)<$P(INBEG1,",",2) 1
 Q:$P(INH,",",2)>$P(INEND1,",",2) 2
 Q 0
 ;
