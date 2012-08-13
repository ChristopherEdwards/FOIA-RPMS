INHOU4 ;DP; 25 Jun 97 10:42;Mark transaction complete. 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
MC ;Mark as complete (need INH MESSAGE EDIT key to do this)
 N DIC,INTT,UIF,DWFILE,Y,DES,INHERR,SUBDELIM,CU,DIOUT,DIPA,DIRCP,DIRI,DLAYGO,DIRMAX,HDR,I,INDA,INFO,INH,INQUIT,INREQLST,INZ,J,K,OK,PRIO,POP,QUE,OD,INMID,INPARM2,INL,%ZIS
 D CLEAR^DW
 S INPARM2("LIST","HOT",1)="PROCESS^H1"
 S INPARM2("LIST","HOT",1,"ACTION")="D LOOP^INHOU4(.DWLMK,DWLRF),DISP^INHOU4(.DWLMK,DWLRF)"
EN2 S X="** Mark Transaction Complete **" W !?80-$L(X)/2,X,!! K X
 D ^UTSRD("Select Transaction to Mark Complete: ;;;;;","Search Queue:/, or a Valid Message ID")
 ; handle the different error/exit conditions
 G:X="" EXIT1
 I X="/" S POP=0 D  I POP D CLEAR^DW G EXIT1
 .S INQUIT=$$TIEN^INHUTC(.INPARM2,"INREQLST")
 .S:'$D(INREQLST) POP=1
 I X="^"!(X="") Q
 ; let DIC handle all other input checks for single message reque
 I '$D(INREQLST) D  Q:'$D(INREQLST)
 .S DIC="^INTHU(",DIC(0)="M" D ^DIC
 .I Y<0 W *7,"No such transaction on file!." D CONT Q
 .S INREQLST(1)=1,INL(1)="",INL(1,0)=+Y
 D LOOP(.INREQLST,"INL")
 G EN2
 ;
EXIT1 D:$D(INDA) INKINDA^INHMS(INDA) Q
 ;
LOOP(INREQLST,DWLRF) ;Loop to process transactions selected by user
 N INQUIT
 S CU="",HDR="*** Mark Transaction Complete ***"
 S INQUIT=0 F  S CU=$O(INREQLST(CU)) Q:CU=""!INQUIT  D
 .S UIF=$G(@DWLRF@(CU,0)) Q:'UIF
 .S INFO=$G(^INTHU(UIF,0)),PRIO=+$P(INFO,U,16),INH=$P(INFO,U,19),DES=$P(INFO,U,2),INMID=$P(INFO,U,5) S:'$L(INH) INH=0
 .D
 ..;Find what queue it is really on
 ..I $D(^INLHSCH(PRIO,INH,UIF)) S QUE=0 Q
 ..I $D(^INLHDEST(DES,PRIO,INH,UIF)) S QUE=1 Q
 ..;Otherwise it is not on any queue
 ..S QUE=""
 .;If its on a queue, prompt
 .I $L(QUE) D
 ..W @IOF,?80-$L(HDR)/2,HDR,!!
 ..W ?52,"Que: ",$S(QUE=1:"^INLHDEST",QUE=0:"^INLHSCH",1:"Not queued"),!
 ..K DIPA S D0=UIF
 ..S SUBDELIM="\",DIPA(D0)=INH D ^INXHR01
 .I QUE="" D COMP S $P(INREQLST(CU),U,2)=INMID_": Not queued, marked complete" Q
 .S OD="OK to delete from queue"
 .W ! S OK=$$YN^UTSRD(OD_" ?: ;Y") S:OK["^" INQUIT=1 I 'OK D  Q
 ..S $P(INREQLST(CU),U,2)=INMID_": Not marked complete"
 .K ^INLHSCH(PRIO,INH,UIF),^INLHDEST(DES,PRIO,INH,UIF) D COMP
 .S $P(INREQLST(CU),U,2)=INMID_": Removed from queue, marked complete"
 Q
 ;
EXIT Q
 ;
COMP ;Successful processing
 D ULOG^INHU(UIF,"C","Marked complete by user "_$P(^DIC(3,DUZ,0),U))
 Q
 ;
DISP(INLIST1,INLIST2) ; Display results of all items selected
 ;Loop through selection list and display items.
 ; INPUT
 ; INLIST1 = The array of user selected items with piece 2 = action
 ; INLIST2 = The full array from the list processor
 N INNODE
 S %ZIS="" D CLEAR^DW,^%ZIS U IO I IO=$P W @IOF
 S POP=0
 S INNODE="" F  S INNODE=$O(INLIST1(INNODE)) Q:'INNODE!POP  D
 .;if second piece is null, user enter "^". Take no action
 .Q:'$L($P(INLIST1(INNODE),U,2))
 .I $Y>(IOSL-4) D CONT Q:POP
 .W !,$P(INLIST1(INNODE),U,2)
 .K INLIST1(INNODE),@INLIST2@(INNODE)
 K INLIST1
 D CONT
 D ^%ZISC S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP
 Q
 ;
CONT I IO=IO(0),$E(IOST)'="P" W ! S X=$$CR^UTSRD I X S POP=1 Q
 W @IOF
 Q
