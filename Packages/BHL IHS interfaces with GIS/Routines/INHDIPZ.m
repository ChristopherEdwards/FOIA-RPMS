INHDIPZ(DIPZ,DNM,DMAX) ;GFT,JSH; 11 Feb 93 12:17;Script compiler - compile print template 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ;Paramaters:    DIPZ= template entry #
 ;               DNM = base routine name
 ;               DMAX= max routine size
 ;
 S IOM=258
 N DIC,DCL,R,M,DE,DI,DPP,DHD,DIWL,DIWR,DK,DP,DNP,DCL,DITTO,H,L,N,S,Q,CP,DIPZTYPE,IOM
 ;
ENZ S (R,DCL,DPP)=0 F  S R=$O(^DIPT(DIPZ,"DCL",R)) Q:R=""  F %=1:1 Q:%>$L(^(R))  S Z=$E(^(R),%) I Z?1P S DCL(R)=$G(DCL(R))_Z
ENDIP ;
 K ^UTILITY($J),^UTILITY("DIL",$J),^UTILITY("DIPZ",$J),DNP,DIPNCH,DIPZLR,DRN,DIPZL,DX,DXS
 S DIPZTYPE="A"
 S DRD=0,DP=$P(^DIPT(DIPZ,0),U,4),DHD="@" S:$D(^("DNP")) DNP=1 G K^INHDIPZ2:'$D(^DIC(DP,0,"GL")) S DK=^("GL"),DRN=0,R="",L=0
AF D INIT^DIP5 S X=-1 F  S X=$O(^DIPT("AF",X)) Q:X=""  F %=0:0 S %=$O(^DIPT("AF",X,%)) Q:%'>0  K:$D(^(%,DIPZ)) ^(DIPZ)
 F C=1:1 Q:'$D(^DIPT(DIPZ,"DXS",C,9.2))&'$D(^(9))  S DXS(C)=""
 S IOSL=9999,DL=1,DIPZL=0,DHT=-1,C=",",Q="""",^UTILITY($J,1)=""
 F DIP=-1:0 S DIP=$O(^DIPT(DIPZ,"F",DIP)) Q:DIP=""  S R=^(DIP) D ^DIL
 D UNSTACK^DIL:DM,A^DIL,T^DIL2 K ^DIPT(DIPZ,"T") F R=-1:0 S R=$O(^UTILITY($J,"T",R)) Q:R=""  S ^DIPT(DIPZ,"T",R)=^(R)
 S DX=DX+999,Y=$P(" D ^DIWWA",1,''$D(DIWR))_" K Y" I DIWL S Y=Y_",DIWF" S:DIWL=1 ^UTILITY("DIPZ",$J,.5)=" S DIWF=""W"""
 D PX^DIPZ1 G ^INHDIPZ2
 ;
