INHRSE ; FRW,DP ; 16 May 96 11:15; Interface message size report
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
EN ;main entry point
 N INLOAD,INDES,INBEG,INEND,FLG,INDEST,INLN,GTOT,GTOTL,L,MSG,MSGDTTM,NONE,PAG,PCOUNT,PGTOT,PERF,SIZE,SUB,TM,TOT,TT,TT1,X,X1,X2,X3,X4,%DT,ACTZE,AVGCON,AVGMSG,BEG,CNT,CON,COUNT,D,DES,DIC,LOOP,LOOP1,DTTM,ZE
 W @IOF Q:'$$PARM
 ; Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ"
 W ! D ^%ZIS G:POP QUIT
 S:IOM<132 IOM=132 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) S ZTDESC="Interface message size report",ZTIO=IOP,ZTRTN="ENQUE^INHRSE" D  G QUIT
 .S ZTSAVE("INLOAD")=INLOAD D ^%ZTLOAD
ENQUE ;Taskman entry point
 K PERF,CREPERF S PERF="PERF",INDEST=0,FLG=0
 S INBEG=$P(INLOAD,U),INEND=$P(INLOAD,U,2),INDES=$P(INLOAD,U,3)
 I $L(INDES)>1 S INDEST=1 F I=1:1:$L(INDES,",")-1 S DES($P(INDES,",",I))=""
 D COMP(.PERF,.CREPERF)
 D SUM(.PERF)
 D OUTPUT(.PERF)
 ;
QUIT ;Exit point
 D ^%ZISC
 Q
 ;
PARM() ;Get parameters
 S DIC=4005,DIC(0)="AEMNQZ"
 D DES Q:'Y  Q:POP 0
 S INBEG=0,INEND=0
 Q:'$$GETRNG(.INBEG,.INEND,.INABEG,.INAEND) 0
 S INLOAD=INBEG_U_INEND_U_INDES_U_INABEG_U_INAEND
 Q 1
 ;
COMP(PERF,CREPERF) ;Compile statistics
 ;
 ;;   PERF      - message array.
 ;;   CREPERF   - control array.
 ;
 S BEG=INBEG-.000001
 I $P(IOST,"-")["C",IO=IO(0) W !,"Compiling data "
 F CNT=0:1  S BEG=$O(^INTHU("B",BEG)) Q:BEG=""!(BEG>INEND)  D
 .I $P(IOST,"-")["C",IO=IO(0) W:'(CNT#1000) "."
 .S LOOP="" F  S LOOP=$O(^INTHU("B",BEG,LOOP)) Q:LOOP=""  D
 ..  ;Check destination
 ..  S ZE=$G(^INTHU(LOOP,0))
 ..  S DES=$P(ZE,U,2) S:DES="" DES="NULL"
 ..  ;Determine transaction type
 ..  I INDEST Q:'$D(DES(DES))
 ..  S TT=$P(ZE,U,11)
 ..  S TT1=$P($G(^INRHT(+TT,0)),U) S:TT1="" TT1="NULL"
 ..  S:'TT TT=DES_U_"D" I 'TT S TT="NULL"
 ..  I TT["D",+DES S TT1=$P($G(^INRHD(DES,0)),U)
 ..  S MSGDTTM=+$E($P(ZE,U,1),1,10)
 ..  S SIZE=$$SIZE(LOOP)
 ..  ;check for empty messages
 ..  S:'SIZE PERF(TT1,TT,2)=$G(PERF(TT1,TT,2))+1
 ..  S PERF(TT1,TT)=$G(PERF(TT1,TT))+1
 ..  S PERF(TT1,TT,1)=$G(PERF(TT1,TT,1))+SIZE
 ..  S PERF(TT1,TT,3)=$G(PERF(TT1,TT,3))+$P(SIZE,U,2)
 Q
 ;
SIZE(LOOP) ;Get size of message
 Q:'$G(LOOP) 0 N ACT,SZ,MSGSZ,DA
 S ACT="^INTHU("_LOOP_")",MSGSZ=0,SZ=0
 F  S ACT=$Q(@ACT) Q:$$QS^INHUTIL(ACT,1)'=LOOP  D
 .   S SUB=$$QS^INHUTIL(ACT,2),DA=$G(@ACT),ACTZE=$L(DA)
 .   I SUB=3 S SZ=SZ+ACTZE Q
 .   S MSGSZ=MSGSZ+ACTZE
 Q SZ_U_MSGSZ
 ;
SUM(BREF,LEVEL) ;summarize array data
 K TOT S LOOP=""
 F X=0:1:3 S TOT(X)=0
 F  S LOOP=$O(PERF(LOOP)) Q:LOOP=""  S LOOP1="" D
 .F  S LOOP1=$O(PERF(LOOP,LOOP1)) Q:LOOP1=""  D
 ..  S TOT(0)=$G(PERF(LOOP,LOOP1))+TOT(0)
 ..  F I=1:1:3 S TOT(I)=$G(PERF(LOOP,LOOP1,I))+TOT(I)
 Q
 ;
OUTPUT(BREF) ;Output data
 ;INRHD - .02 - 4005 TT pointer
 ;MSGSZ & CTLRSZ SHOW PERCENT OF TOTAL
 S U1="%",PAG=1,TM=$$CDATASC^%ZTFDT($H,3,1) D SHDR
 S DTTM="",GTOTL=(TOT(1)+TOT(3))/1000,POP=0
 ; set tabs
 S L(1)=49,L(2)=57,L(3)=65,L(4)=71,L(5)=81,L(6)=88,L(7)=95
 F  S DTTM=$O(@BREF@(DTTM)) Q:DTTM=""!POP  S TT="" D
 .  F  S TT=$O(@BREF@(DTTM,TT)) Q:TT=""!POP  D
 ..  S CON=$G(@BREF@(DTTM,TT,3)),MSG=$G(@BREF@(DTTM,TT,1))
 ..  S NONE=$G(@BREF@(DTTM,TT,2)),COUNT=$G(@BREF@(DTTM,TT))
 ..  S:'COUNT COUNT=.000001
 ..  S (AVGCON,AVGMSG)="*"
 ..  I COUNT>0 S AVGCON=$J((CON+MSG)/COUNT,0,0),AVGMSG=$J(MSG/COUNT,0,0)
 ..  W !!,$E(DTTM,1,40)
 ..  W ?L(1)-$L(AVGCON),AVGCON,?L(2)-$L(AVGMSG),AVGMSG
 ..  W ?L(3)-$L($J(CON/COUNT,0,0)),$J(CON/COUNT,0,0)
 ..  W ?L(4)-$L(COUNT),COUNT
 ..  S GTOT=CON+MSG,CON=$J(CON/1000,0,0),MSG=$J(MSG/1000,0,0)
 ..  S GTOT=$J(GTOT/1000,0,0)
 ..  ;
 ..  ; calculate percentage ot total count
 ..  S (PCOUNT,PGTOT)="*"
 ..  I TOT(0)>0 S PCOUNT=$J(COUNT/TOT(0)*100,0,0)
 ..  I GTOTL>0 S PGTOT=$J(GTOT/GTOTL*100,0,0)
 ..  W ?L(5)-$L(GTOT),GTOT,?L(6)-$L(MSG),MSG,?L(7)-$L(CON),CON
 ..  W !?L(4)-$L(PCOUNT),PCOUNT,U1,?L(5)-$L(PGTOT),PGTOT,U1
 ..  S X="*" I GTOT>0 S X=$J(MSG/GTOT*100,0,0)
 ..  W ?L(6)-$L(X),X,U1
 ..  S X="*" I GTOT>0 S X=$J(CON/GTOT*100,0,0)
 ..  W ?L(7)-$L(X),X,U1
 ..  I $Y>(IOSL-6),$P(IOST,"-")["P" D HDR Q
 ..  D:$Y>(IOSL-2) HDR
 ;
 ; display totals
 Q:POP
 N X S X="--------------------"
 I TOT(0)<1 D END Q
 I TOT(0)>0 D
 .S X(1)=$J((TOT(1)+TOT(3))/TOT(0),0,0)
 .S X(2)=$J(TOT(1)/TOT(0),0,0)
 .S X(3)=$J(TOT(3)/TOT(0),0,0)
 S X(4)=TOT(0)
 S X(5)=$J((TOT(1)+TOT(3))/1000,0,0)
 S X(6)=$J(TOT(1)/1000,0,0)
 S X(7)=$J(TOT(3)/1000,0,0)
 W ! F I=1:1:7 W ?L(I)-$L(X(I)),$E(X,1,$L(X(I)))
 W !,"TOTAL" F I=1:1:7 W ?L(I)-$L(X(I)),X(I)
P ; print text
 S FLG=1 D:$Y+17>IOSL HDR Q:POP
 W !!!! F I=1:1:13 S X=$P($T(TEXT+I),";;",2) D
 .I $L(X)<IOM W !,X Q
 .S X1=X F A=$L(X," "):-1 S X=$P(X1," ",1,A) I $L(X)<IOM S X1=$P(X1," ",A+1,99) Q
 .W !,X,!?13,X1
END ;I IO=$P,'POP S X=$$CR^UTSRD
 I IO=IO(0),$E(IOST)'="P" S X=$$CR^UTSRD
 W !! S X="*** End of Report ***" W !?IOM-$L(X)\2,X
 W @IOF
 Q
 ;
GETRNG(START,STOP,INABEG,INAEND) ;
 ;get starting and ending dates
 ;
 N X,Y S START=1,STOP=999999999,INABEG=0
 W ! Q:'$$IEN(.START,"Starting Date: ") 0
 S INBEG=Y W !
 S Y=$O(^INTHU("B",Y),-1) S:Y INABEG=$O(^INTHU("B",Y,""))
 Q:'$$IEN(.STOP,"Ending Date: ") 0
 S INEND=Y,X=$O(^INTHU("B",INEND,""))
 S:INEND'["." INEND=INEND_".24"
 ;calculate the approximate number of record to be proccesed
 S Y=INEND+.000001
 S Y=$O(^INTHU("B",Y),-1)
 S INAEND=$O(^INTHU("B",Y,999999999999),-1)
 W !!,"Approximately ",INAEND-INABEG," Records will be processed"
 Q 1
 ;
IEN(IEN,ASK) ;
 ;
 S %DT="TAEX",%DT("A")=$G(ASK) D ^%DT Q:Y<1 0
 S IEN=$Q(^INTHU("B",Y,0))
 I $$QS^INHUTIL(IEN,1)'="B" S IEN="^INTHU(""B"",3000101,9999999999999)"
 S IEN=$$QS^INHUTIL(IEN,2)
 Q IEN
 ;
DES ;Get multiple destinations
 N I S POP=0,INDES=""
 F I=1:1 D  Q:POP  W:Y=-1&(INDES="") "ALL" Q:Y=-1
 .D ^DIC S:X[U POP=1 Q:POP  Q:(+Y)<1
 .S INDES=INDES_(+Y)_","
 Q
TEXT ;
 ;;Count - Total number of Tansaction within a Tansaction type. 
 ;;Average (Bytes) - All averages are calculated in Bytes (characters).
 ;;   TotSize - Total message size + Total control size / count.
 ;;   MsgSize - Total Bytes in a message / count
 ;;   CtlSize - Total Bytes in the control / count.
 ;;Totals (KBytes) - Totals are represented in KBytes (Byte/1000).
 ;;   TotSize - Total number of KBytes in a transaction type.
 ;;   MsgSz   - Total number of KBytes in a message section.
 ;;   CtlSz   - Total number of KBytes in a control section.
 ;;   %ofTot  - Percentage of the transaction type count of the total report count (Count / Total Count).
 ;;   %GTot   - Percentage of total transaction type size out of total report (TotSize / Grand TotSize).
 ;;   %TotM   - Percentage of the total message size out of TotSize (Totm/Gtot).
 ;;   %TotC   - Percentage of total control size out of TotSize (TotC/Gtot).
 Q
SHDR ;set header
 S X=$$CDATASC^%ZTFDT($H,1,1),INLN(0)=X_" Page "
 S INLN(1)="Interface message size report"
 S X="From: "_$$CDATASC^%ZTFDT($E(INBEG,1,10),3,1)
 S INLN(2)=X_"      To: "_$$CDATASC^%ZTFDT($E(INEND,1,10),3,1)
 ;get the site name
 S INLN(6)=$S($D(^DIC(4,^DD("SITE",1),0)):^(0),1:^DD("SITE"))
 S INLN(6)=$S($P(INLN(6),U,4)]"":$P(INLN(6),U,4),1:$P(INLN(6),U,1))
 S INLN="",$P(INLN,"-",IOM+1)=""
 ;
HDR ;Print header
 I $P(IOST,"-")["C",IO=IO(0) S X=$$CR^UTSRD I X S POP=1 Q
 I PAG>1!($P(IOST,"-")["C") W @IOF
 W !,INLN(6)
 S X=INLN(0)_PAG,PAG=PAG+1
 W ?IOM-$L(X)-1,X,!
 F I=1,2 W !?IOM-$L(INLN(I))\2,INLN(I)
 Q:FLG  W !!,"Destination: " D
 .I 'INDES W "All" Q
 .S D="" F  S D=$O(DES(D)) Q:D=""  W ?14,$P(^INRHD(D,0),U),!
 W !,INLN,!?42,"----Average(Bytes)----",?75,"---Totals (KBytes)---"
 W !,"Transaction Type"
 W ?42,"TotSize MsgSize CtlSize  Count"
 W ?75,"TotSize  MsgSz  CtlSz"
 W !?67,"%ofTot   %GTot   %TotM  %TotC",!,INLN
 Q
