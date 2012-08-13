INHRTH ;DP; 9 May 96 15:41;27 Dec 95 10:39;Throughput analyzer report 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
EN ;Main entry point
 N DES,N,I,X,INLOAD,DET,INBEG,INEND,INENDX,INTM,INC,INT,INLN,MS
 N INABEG,INAEND,DAY,FLG,IN,IN1,INLST,INSITE,INTIM1,LOOP,MSGDAT,MSGDT,MSGTM,P,PAG,PAGES,POP,SE,ST,TM,INDESM,%DT,ASTRX,CNT,DIC,DIRCP,DIRI,DIRMAX,DT1,DT2,DT3,I,IEN2,II,INDES,INTMI,STAT,X,X1,X2,X3,X4,Z,ZE
 W @IOF Q:'$$PARM^INHRTH1
 Q:POP
 ;Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ"
 D ^%ZIS G:POP QUIT
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) D  G QUIT
 .S ZTDESC="Throughput analyzer report",ZTIO=IOP,ZTRTN="ENQUE^INHRTH"
 .S ZTSAVE("INLOAD")=INLOAD
 .D ^%ZTLOAD
ENQUE ;Taskman entry point
 K ^UTILITY($J)
 S ST=$P(INLOAD,U),DET=$P(INLOAD,U,2),DES=$P(INLOAD,U,3)
 S INBEG=$P(INLOAD,U,4),INEND=$P(INLOAD,U,5),INTM=$P(INLOAD,U,6)
 S INABEG=$P(INLOAD,U,7),INAEND=$P(INLOAD,U,8)
 ;
 ;  INDES flag for destination list
 ;    1 List
 ;    0 All destinations
 ; INDESM=1 if more than 1 destination is included in report
 ;
 S (INDES,INDESM)=0 I $L(DES)>1 S INDES=1 D
 .F I=1:1:$L(DES,",")-1 S X=$P(DES,",",I),DES(X)=$P(^INRHD(X,0),U)
 .S:I>1 INDESM=1
 ;build array for ALL destinations
 I 'INDES S X=0,INDESM=1 F  S X=$O(^INRHD(X)) Q:'X  S DES(X)=$P(^INRHD(X,0),U)
 S PAG=1,X1=0,DV=1 S:INTM["H" INTM=INTM*60
 D COMP,SUM,DEV,OUTPUT
 I 'POP D
 .F I=$Y:1:(IOSL-1) W !
 .S X="*** End of Report ***" W ?IOM-$L(X)\2,X
 K ^UTILITY($J)
 ;
QUIT ;Exit point
 D ^%ZISC
 Q
 ;
COMP ;Compile statistics
 ;
 ; INC = holder of creation totals
 ; INT = holder of transmission totals
 ;
 S LOOP=$O(^INTHU("B",INBEG,"")),INC="CC",INT="TT"
 ;   get the last internal number for the ending date
 S INENDX=$O(^INTHU("B",INEND,""),-1) D INTER
 I $P(IOST,"-")["C",IO=IO(0) W !,"Compiling data "
 F CNT=1:1  S LOOP=$O(^INTHU(LOOP)) Q:'LOOP!(LOOP>INENDX)  D
 .  I IO=$P W:'(CNT#1000) "."
 .  S ZE=$G(^INTHU(LOOP,0))
 .  ; quit if date is out of range
 .  Q:+ZE>INAEND
 .  ;
 .  ; message creation date and time
 .  ; MSGDT = date
 .  ; MSGTM = time HHMM
 .  S MSGDT=+$P($P(ZE,U),"."),MSGTM=$E($P(ZE,U),9,20)
 .  S MSGDAT=$E($P(ZE,U),1,12)
 .  ; get destination
 .  S DES=$P(ZE,U,2) Q:DES=""
 .  ;quit if destination is not on the selected array.
 .  I INDES Q:'$D(DES(DES))
 .  ;for message that was created befor the begining date make
 .  ;sure to quit if no work was done later.
 .  I +ZE<INABEG  Q:$P(ZE,U,14)<INABEG  D MULT Q
 .  ;
 .  ;Quit if status is not part of the selection string
 .  Q:$F(ST,$P(ZE,U,3))<2
 .  S STAT=$P(ZE,U,3)
 .  S MS=+MSGDAT S:'$D(^UTILITY($J,MS)) MS=$O(^UTILITY($J,MS),-1)
 .  ;following variable does not seem to be used. Verify for 4.6
 .  S MSGTM=$E(MSGTM,1,2)*60+$E(MSGTM,3,4)
 .  ;store details. SUM tag summarizes details
 .  S ^UTILITY($J,MS,DES,STAT,INC)=$G(^UTILITY($J,MS,DES,STAT,INC))+1
 .  D MULT
 Q
MULT ; Look for activity on the multiple level
 N ACT,ACTLOOP,ACTZE,DTTM,DTDT,DAY
 S ACT=0
 F ACTLOOP=0:1 S ACT=$O(^INTHU(LOOP,1,ACT)) Q:'ACT&ACTLOOP  D
 .S ACTZE=""
 .S:ACT ACTZE=$G(^INTHU(LOOP,1,ACT,0))
 .; Get status
 .Q:$F(ST,$P(ACTZE,U,2))<2  S STAT=$P(ACTZE,U,2)
 .; Quit if messages has no date/time.
 .Q:+ACTZE=0  S DTTM=$P(ACTZE,U)
 .Q:DTTM>INAEND
 .S DTDT=$P(DTTM,"."),DTTM=$E(DTTM,1,12)
 .S DAY=+DTTM S:'$D(^UTILITY($J,DTTM)) DAY=$O(^UTILITY($J,DAY),-1)
 .Q:DAY=""  S DTTM=$E(DTTM,1,2)*60+$E(DTTM,3,4)
 .S ^UTILITY($J,DAY,DES,STAT,INT)=$G(^UTILITY($J,DAY,DES,STAT,INT))+1
 Q
INTER ;Initalize intervals for all date/time
 N I,IA,II,III,D,ZZ,OLDTM
 S ZZ=$P(INLOAD,U,3),IA=0
 ;last time bracket
 S INLST=$E($$ADDT^%ZTFDT(INAEND,0,0,-INTM),1,12),OLDTM=0
 F  S X=$E($$ADDT^%ZTFDT(INABEG,0,0,(INTM*IA)),1,12),IA=IA+1 Q:OLDTM'<INLST  D
 .S OLDTM=X
 .S DES=0 F  S DES=$O(DES(DES)) Q:'DES  D
 ..F III=1:1:$L(ST) F IN=INC,INT S ^UTILITY($J,X,DES,$E(ST,III),IN)=0
 Q
 ;
OUTPUT ;Output data
 W ! S (DT1,DAY)=0,ASTRX="",$P(ASTRX,"*",80)="",POP=0
 F  S DAY=$O(^UTILITY($J,DAY)) Q:DAY=""!(DAY="B")!POP  S TM="" D
 .D DT Q:POP
 .S FLG=1 F I=INC,INT S X=$G(^UTILITY($J,DAY,I)) D @I
 .;quit here if this is not a detailed report AND only 1 dest is selected
 .W ! I 'INDESM,'DET Q
 .S FLG=0,DES=""
 .F  S DES=$O(^UTILITY($J,DAY,DES)) Q:DES=""!POP  D
 ..; display destination
 ..I DES'?.N W ! Q
 ..I $Y>(IOSL-2) D HDR Q:POP  D DT
 ..W !?19,$E($P(^INRHD(DES,0),U),1,30)
 ..F I=INC,INT S X=$G(^UTILITY($J,"B",DAY,DES,I)) Q:X=""!POP   D @I
 ..;Quit if not a detailed report
 ..Q:'DET
 ..; display status
 ..W ! S ST="" F  S ST=$O(^UTILITY($J,DAY,DES,ST)) Q:ST=""!POP  D
 ...I ST'?1A W ! Q
 ...I $Y>(IOSL-2) S DT1="" D HDR Q:POP  D DT
 ...W ?46,ST
 ...F I=INC,INT S X=$G(^UTILITY($J,DAY,DES,ST,I)) D @I
 ...W ! I $Y>(IOSL-2) D HDR D:'POP DT
 Q
 ;
CC ;Dsplay details for creation rate
 I $Y>IOSL S DT1="" D HDR Q:POP  D DT
 I X="" W ! Q
 S P=$S(FLG:24,1:54) W ?(P-$L(X)),X
 ; display the astrics line
 S X1=$E(ASTRX,1,$J(X/DV,0,0)) S:'$L(X1) X1="*"
 S:X=0 X1=""
 S:$L(X1)>SE X1=$E(X1,1,(SE-2))_">>" W ?(P+2),X1
 Q
TT ;Display details for transmission rate
 N X0
 I X="" W ! Q
 S X0=X,X=$E(ASTRX,1,$J(X/DV,0,0))
 S:'$L(X) X="*" S:X0=0 X="" S:$L(X)>SE X="<<"_$E(X,1,(SE-2))
 S X=X_$J(X0,7) W ?IOM-1-$L(X),X
 Q
DT ;Print date time
 I $Y>(IOSL-3) S DT1="" D HDR Q:POP
 S DT2=$$CDATASC^%ZTFDT(DAY,2,1)
 W $P(DT2,"@")," ",$P(DT2,"@",2),"-"
 S DT3=$O(^UTILITY($J,DAY)) I 'DT3 W $P($$CDATASC^%ZTFDT(INAEND,2,1),"@",2) Q
 S X=$$ADDT^%ZTFDT(DT3,0,0,-1)
 W $P($$CDATASC^%ZTFDT(X,2,1),"@",2)
 Q
SUM ;Calculate totals for date/time
 N DAY,DDE,SST,X
 S DAY="",DV=1
 F  S DAY=$O(^UTILITY($J,DAY)) Q:DAY=""&(DAY'?.N1".".N)  S DDE="" D
 .Q:DAY="B"  F  S DDE=$O(^UTILITY($J,DAY,DDE)) Q:DDE=""  S SST="" D
 ..F  S SST=$O(^UTILITY($J,DAY,DDE,SST)) Q:SST=""  D
 ...F I=INC,INT D
 ....S X=^UTILITY($J,DAY,DDE,SST,I)
 ....; total for date & time
 ....S ^UTILITY($J,DAY,I)=$G(^UTILITY($J,DAY,I))+X
 ....S:^UTILITY($J,DAY,I)>DV DV=^(I)
 ....; total for date/time & destination
 ....S ^UTILITY($J,"B",DAY,DDE,I)=$G(^UTILITY($J,"B",DAY,DDE,I))+X
 Q
 ;
DEV ;Calculate the devisor
 S SE=16 I 'DET S DV=DV/2,SE=31
 S DV=$S(DV>9000:1000,DV>4500:500,DV>1900:250,DV>900:100,1:25)
 ;
 ; Set header
 S X=$$CDATASC^%ZTFDT($H,1,1),INLN(0)=X_" Page "
 S INLN(1)="Throughput analyzer report"
 I DET S INLN(1)=INLN(1)_" - Detailed"
 S X="From: "_$$CDATASC^%ZTFDT($E(INABEG,1,12),3,1)
 S INLN(2)=X_"      To: "_$$CDATASC^%ZTFDT($E(INAEND,1,12),3,1)
 D ST1^INHRTH1 S INLN(3)="Status: "_INLN(3)
 S INLN(5)="Divisor: (*) "_DV
 S X=INTM S:INTM>60 X=(INTM\60)_"Hr"
 S INTMI="Time interval: "_X S:INTM<60 INTMI=INTMI_"Minutes"
 ;get the site name
 S INSITE=$S($D(^DIC(4,^DD("SITE",1),0)):^(0),1:^DD("SITE"))
 S INSITE=$S($P(INSITE,U,4)]"":$P(INSITE,U,4),1:$P(INSITE,U,1))
 S INLN="",$P(INLN,"-",IOM)=""
 ;
HDR ;Print header
 I $P(IOST,"-")["C",IO=IO(0),$Y>15 S X=$$CR^UTSRD I X S POP=1 Q
 I PAG>1!($P(IOST,"-")["C") W @IOF
 W !,INSITE
 S X=INLN(0)_PAG,PAG=PAG+1,DT1=""
 W ?IOM-$L(X)-2,X,!
 F I=1:1:4 I $G(INLN(I))'="" W !?IOM-$L(INLN(I))\2,INLN(I)
 W !,"Destination:" D
 .I 'INDES W " All",! Q
 .S II="" F  S II=$O(DES(II)) Q:II=""  W !?14,DES(II)
 W !!,INLN(5),!,INTMI,!!,INLN
 W !,"  Date   Time" W:DET ?19,"Destination"
 W:DET ?42,"Status"
 S P=15 S:DET P=40 W !?P,"Creation Rates "
 S X="Transmission Rates" W ?IOM-$L(X)-2,X
 W !,INLN,!
 Q
 ;
