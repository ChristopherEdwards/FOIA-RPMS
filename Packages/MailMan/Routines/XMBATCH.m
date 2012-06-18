XMBATCH ;DG/TPA/IHS - INTERFACE TO DETERMINE TAPE OR HFS (GET NAME) [ 09/16/93  11:22 AM ]
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;7.0;Kernel;*IHS ROUTINE FROM;;3.18;;3.27
 ; ACC/IHS - fixed to use 51 for HFS-IN, 52 for HFS-OUT
 ;
 I '$D(XMODE) G ERR
 S XM=""
 S DIR("A")="Enter Name Of Device",DIR(0)="S^C:Cartridge Tape;T:9-Track Tape;H:Host File Server" D ^DIR K DIR G:$D(DIRUT) ERR
 S IOP=$S(Y="C":47,Y="T":48,1:$S(XMODE="IN":51,1:52)) ;ACC/IHS
 S XMCHAN=$P($T(@Y),";;",2)_"-"_XMODE
 I $P(XMCHAN,"-")="HFS" S DIR("A")="Enter File Name: ",DIR(0)="F^1:30" D ^DIR K DIR G:$D(DIRUT) ERR S %ZIS("IOPAR")="("""_Y_""":"""_$S(XMODE="OUT":"W",1:"R")_""")"
 ;I $P(XMCHAN,"-")="TAPE" S %ZIS("IOPAR")="("""_$S(XMODE="OUT":"W",1:"R")_""")"
 K XMODE
 Q
 ;
ERR ;
 K IOP,XMODE,XMCHAN
 Q
 ;
C ;;TAPE
T ;;TAPE
H ;;HFS
