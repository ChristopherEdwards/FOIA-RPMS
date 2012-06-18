%ZIS4 ;SF/GFT,RWF,MVB - DEVICE HANDLER SPOOL SPECIFIC CODE(MSM) ;02/11/97  11:02 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1001,1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**23,36,49,59**;JUL 03, 1995
 ;THIS ROUTINE CONTAINS AN IHS MODIFICATION BY IHS/HQW/JLB 2/16/99
 ;
OPEN G OPN2:$D(IO(1,IO))
 S POP=0 D OP1 S:'POP IO(1,IO)="" G NOPEN:'$D(IO(1,IO))
OPN2 I $D(%ZISHP),'$D(IOP) W !,*7," Routing to device "_$P(^%ZIS(1,%E,0),"^",1)_$S($D(^(1)):" "_$P(^(1),"^",1)_" ",1:"")
 Q
NOPEN I %IS'["D",$D(%ZISHP)!(%ZISHG]"") S POP=1 Q
 I '$D(IOP) W *7,"  [BUSY]" W "  ...  RETRY" S %=2,U="^" D YN^%ZIS1 G OPEN:%=1
 S POP=1 Q
 Q
OP1 N X S X="OPNERR^%ZIS4",@^%ZOSF("TRAP")
 L:$D(%ZISLOCK) +@%ZISLOCK:60
 O IO::%ZISTO S:'$T POP=1 L:$D(%ZISLOCK) -@%ZISLOCK Q
OPNERR S POP=1,IO("ERROR")=$ZE,IO("LASTERR")=$ZE Q
 ;
O I $P($ZV,"Version ",2)'<3 D:%IS["L" ZIO
 ;D:$D(%ZISIOS) ZISLPC^%ZIS Q:'%ZISB  ;No longer called in Kernel v8.
OPRTPORT I $D(IO("S")),$D(^%ZIS(2,IO("S"),10)),^(10)]"" U IO(0) D X10^ZISX
OPAR I $D(IOP),%ZTYPE="HFS",$D(%IS("HFSIO")),$D(%IS("IOPAR")),%IS("HFSIO")]"" S IO=%IS("HFSIO"),%ZISOPAR=%IS("IOPAR")
 S %A=$S(%ZISOPAR]"":%ZISOPAR,%ZTYPE["TRM":+%Z91,1:"")
 S %A=%A_$S(%A["):":"",%ZTYPE["OTH"&($P(%ZTIME,"^",3)="n"):"",1:":"_%ZISTO),%A=""""_IO_""""_$E(":",%A]"")_%A
 D O1 I POP W:'$D(IOP) !,?5,*7,"[DEVICE IS BUSY]" Q
 S IO(1,IO)=""
 I %ZTYPE="HFS" D  Q:POP
 .N % S %=$I
 .U IO S:$ZA<0 POP=1
 .U:'$D(ZTQUEUED) % I POP C:IO]"" IO K:IO]"" IO(1,IO)
 .I POP,'$D(IOP),'$D(ZTQUEUED) W !,?5,*7,"[FILE NOT FOUND]" Q
 N DX,DY S (DX,DY)=0
 U IO X:$D(^%ZOSF("XY"))&'(IO=IO(0)&'$D(ZTQUEUED)&'$D(IO("S"))) ^("XY")
 I %ZISUPAR]"" S %A1=""""_IO_""":"_%ZISUPAR U @%A1
 U:%IS'[0 IO(0)
 G OXECUTE^%ZIS6
 ;
O1 N X S X="OPNERR^%ZIS4",@^%ZOSF("TRAP")
 L:$D(%ZISLOCK) +@%ZISLOCK:60
 O @%A S:'$T&(%A?.E1":".N) POP=1 L:$D(%ZISLOCK) -@%ZISLOCK
 S IO("ERROR")="" Q
 ;
ZIO N % S (IO("ZIO"),%)=$ZDEV($I),%=$S(%?1.3N1P.E:$TR(%,"~",":"),1:%)
 S:(%?1.3N1P1.3N1P.E)&'$D(IO("IP")) IO("IP")=$TR(%,"~",":") S:(%?1A.ANP1"~"1.4N)&'$D(IO("CLNM")) IO("CLNM")=$TR($$LOW^%ZIS1(%),"~",":")
 Q
 ;
SPOOL ;%ZDA=pointer to ^XMB(3.51, %ZFN=spool file name.
 I $D(ZISDA) W:'$D(IOP) !?5,*7,"You may not Spool the printing of a Spool document" G N
 I $D(DUZ)[0 W:'$D(IOP) !,"Must be a valid user." G N
 S ZOSFV=($P($ZV,"Version ",2)'<2)
R S %ZY=-1 D NEWDOC^ZISPL1 G N:%ZY'>0 S %ZDA=+%ZY,%ZFN=$P(%ZY(0),U,2),IO("DOC")=$P(%ZY(0),U,1) I '%ZISB!$D(IO("Q")) S:'ZOSFV IO=51 G OK
 I '$P(%ZY,"^",3),%ZFN D SPL3 G N:'%ZFN,DOC
 S %ZFN=-1 D SPL2 G:%ZFN<0 N S $P(^XMB(3.51,%ZDA,0),U,2)=%ZFN,^XMB(3.51,"C",%ZFN,%ZDA)=""
DOC S IO("SPOOL")=%ZDA,^XUTL("XQ",$J,"SPOOL")=%ZDA,IOF="#"
 I $D(^%ZIS(1,%ZISIOS,1)),$P(^(1),"^",8),$O(^("SPL",0)) S ^XUTL("XQ",$J,"ADSPL")=%ZISIOS,ZISPLAD=%ZISIOS
OK K %ZDA,%ZFN Q
N K %ZDA,%ZFN,IO("DOC") S POP=1 Q
 ;
SPL2 O 2:1 G SPL5:$ZA<0,SPL5:$ZC S %ZFN=$ZA#256 S IO(1,2)="",IO(1,2,"%ZFN")=%ZFN Q
 ;
SPL3 Q:$D(IO(1,2))#2  O 2:%ZFN+256 G:$ZA<0 SPL5:$ZA<0,SPL5:$ZC S IO(1,2)="",IO(1,2,"%ZFN")=%ZFN Q
SPL4 E  G SPL5
 ;U IO S %ZA=$ZA U:%IS'[0 IO(0) I %ZA<0 G SPL5
 Q
SPL5 W:'$D(IOP)&'$D(ZTQUEUED) !?5,*7,"Couldn't open the spool file." S %ZFN=-1 Q
 ;
CLOSE N %Z1 S ZOSFV=($P($ZV,"Version ",2)'<2)
 C 2 K IO(1,2)
 D FILE^ZISPL1 I %ZDA'>0 K ZISPLAD Q
 S %Z1=+$G(^XTV(8989.3,1,"SPL"))
 S IO=2,%ZFN=$P(%ZS,"^",2) D SPL3 Q:%ZFN'>0  U IO S %ZCR=$C(13),%Y=""
 G V2CL1^%ZOSV
 Q  ;Send error up
CL2 I %Z1<(%+1) S %=%+1,^XMBS(3.519,XS,2,%,0)="*** INCOMPLETE REPORT  -- SPOOL DOCUMENT LINE LIMIT EXCEEDED ***",$P(^XMB(3.51,%ZDA,0),"^",11)=1 Q
 I %2[$C(12) S %=%+1,^XMBS(3.519,XMZ,2,%,0)="|TOP|"
 S %=%+1,^XMBS(3.519,XMZ,2,%,0)=%2 Q
 ;
HFS G HFS^%ZISF
REWMT(IO,IOPAR) ;Rewind Magtape
 S X="REWERR^%ZIS4",@^%ZOSF("TRAP")
 U IO W *5
 Q 1
REWSDP(IO,IOPAR) ;Rewind Sequential Block Processor
 S X="REWERR^%ZIS4",@^%ZOSF("TRAP")
 U IO:IOPAR
 Q 1
REWHFS(IO,IOPAR) ;Rewind Host File.
REW1 S X="REWERR^%ZIS4",@^%ZOSF("TRAP")
 ; IHS/HQW/JLB 2/16/99  As of MSM 4.4 the original line from VA works
 ;N FILENAME  ;IHS/ANMC/FBD-2/19/97-ADDED LINE-SUPPORT FOR ADDITION 2 LINES BELOW  IHS/HQW/JLB 2/16/99 uncomment for MSM 4.3 and below                                                                      
 U IO:(::0)  ;IHS/ANMC/FBD-2/19/97-ORIGINAL LINE-COMMENTED OUT  IHS/HQW/JLB 2/16/99 comment out for MSM 4.3 and below        
 ;U IO I $$^%FINDFN(.FILENAME) C IO O IO:(FILENAME:"M")  ;IHS/ANMC/FBD-2/ LINE-WORKAROUND TO MSM NO-REWIND PROBLEM  IHS/HQW/JLB uncomment for MSM 4.3 and below 
 Q 1
REWERR ;Error encountered.
 Q 0
