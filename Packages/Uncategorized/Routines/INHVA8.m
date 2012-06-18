INHVA8 ;FRW ; 11 Feb 93 12:33; Identify missing interface transactions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
EN ;Main entry point
 ;NEW statements
 N %ZIS,A,COUNT,DATA,EXIT,HDR,LOOP,PAGE,X,ZTDESC,ZTIO,ZTRTN,ZTSAVE
 S U="^"
ENUSE ;User input
 ;ask for prefix
 S INPRE=$$SOC^UTIL("Select message prefix: ","","SAIC^DHCP",0)
 ;goto QUIT if user aborts
 G:INPRE[U!('$L(INPRE)) QUIT
 ;Device handling & Tasking logic
 K IOP S %ZIS("A")="QUEUE ON DEVICE: ",%ZIS("B")="",%ZIS="NQ" D ^%ZIS G:POP QUIT
 S IOP=ION_";"_IOST_";"_IOM_";"_IOSL
 I IO=IO(0) S %ZIS="" D ^%ZIS I POP W *7,!,"Sorry, unable to find device..." G QUIT
 I IO'=IO(0) S ZTDESC="Identify missing interface transactions",ZTIO=IOP,ZTRTN="ENQUE^INHVA8" D  G QUIT
 .F X="U","IO*","D*","INPRE" S ZTSAVE(X)=""
 .D ^%ZTLOAD
 ;
ENQUE ;Taskman entry point
 ;initialize variables
 S PAGE=0,EXIT=0
 D HSET,HEADER
 ;call modules
 S CUR=0,LAST=CUR,MES=INPRE_CUR,COUNT=0,INPREL=$L(INPRE)
 F CMES=1:1 S LAST=CUR,MES=$O(^INTHU("C",MES)) Q:$E(MES,1,INPREL)'=INPRE!(EXIT)  S CUR=$E(MES,INPREL+1,999) I (LAST+1)'=CUR S DATA="LAST,?12,CUR" D WRITE S COUNT=COUNT+1
 ;
 S DATA="!!,""Total Gaps => "",COUNT,!,""Total Messages => "",CMES"
 G QUIT
 ;
HEADER ;output header in local array HDR(x)
 N A
 I ($P(IOST,"-")["C")&('$D(IO("Q")))&(IO=IO(0))&(PAGE>0) R !,"Press <RETURN> to continue ",A:DTIME I A[U S EXIT=1 Q
 S PAGE=PAGE+1 W @IOF
 S A=0 F  S A=$O(HDR(A)) Q:'A  U IO W !,@HDR(A)
 Q
 ;
WRITE ;output a line
 I ($Y>(IOSL-3))&(PAGE>0) D HEADER
 Q:EXIT  W !,@DATA Q
 ;
HSET ;set up header
 K HDR
 D NOW^%DTC S Y=% D DD^%DT S HDR(1)="?(IOM-30),"""_$P(Y,":",1,2)_""",?(IOM-10),""PAGE: "",PAGE"
 S HDR(3)="""Missing Interface Transaction with the prefix: "",INPRE"
 S HDR(3.5)="""Before Gap  After Gap"""
 S HDR(4)="",$P(HDR(4),"-",IOM-1)="",HDR(4)=""""_HDR(4)_""",!"
 Q
 ;
QUIT ;exit module
 D ^%ZISC
 S IOP="",%ZIS="" D ^%ZIS U IO K IO("Q"),IOP,POP
 Q
