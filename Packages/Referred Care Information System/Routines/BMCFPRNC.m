BMCFPRNC ; IHS/OIT/FCJ - PRINT REFERRAL CALL IN FORM ;       [ 09/26/2006  4:18 PM ]
 ;;4.0;REFERRED CARE INFO SYSTEM;**2,4**;JAN 09, 2006
 ;BMC*4.0*2 IHS/OIT/FCJ ADDED CONSULT PRINT TEST
 ;4.0*3 9.15.08 IHS.OIT.FCJ FX FOR UNDEF VAR WHEN QUEUED
 ;
PRINT ;Ref Form: Heading,pat demo, ref to, apt date, purpose, pert med
 S BMCFTYP="CI"
 D PRINT^BMCFUTL
 Q:BMCQUIT
REFFROM ;
 D REFFROM^BMCFUTL ;BMC*4.0*2 9/21/06 IHS/OIT/FCJ CALL TO WRONG UTL RTN
 Q:BMCQUIT
TEXT ;
 D TEXT^BMCFUTL
 Q:BMCQUIT
LINE ;CHS No Sig
 G:$P(BMCR0,U,4)'="C" ROUT
 W !!!!!!
ROUT ;Prt Rt slp
 I BMCPROUT=1 W # D PRINT^BMCFDRS
CONSULT ;PRNT CONSULT LETTER ;BMC*4.0*2 IHS/OIT/FCJ
 I $G(BMCPCON)=1 W # D PRINT^BMCFDRP ;BMC*4.0*4 IHS/OIT/FCJ ADDED $G
 Q
W ;
 Q:X=""
 NEW %
 S %=$L(X)
 I $Y>(IOSL-4) D HEAD Q:BMCQUIT
 I N F I=1:1:N W !
 I $G(C) W ?(IOM-$L(X)/2),X Q
 S %=$S($G(T):T,1:0) W ?%,X
 Q
C ; CHS REFERRAL
 D C^BMCFUTL
 Q
I ; IHS REFERRAL
 D I^BMCFUTL
 Q
N ; IN-HOUSE REFERRAL
 D N^BMCFUTL
 Q
O ; OTHER REFERRAL
 D O^BMCFUTL
 Q
L ;
 S T=0,X=$TR($J(" ",IOM)," ","_"),N=1,C=0 D W Q:BMCQUIT
 Q
D ;
 S T=0,X=$TR($J(" ",IOM)," ","-"),N=1,C=0 D W Q:BMCQUIT
 Q
S ;
 S T=0,X=$TR($J(" ",IOM)," ","*"),N=1,C=0 D W Q:BMCQUIT
 Q
WPTXT ;
 ; site-specific txt
 D WPTXT^BMCFUTL
 Q
WP ;
 D WP^BMCFDR
 Q
HEAD ;
 NEW N,T,C,X,Y
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S BMCQUIT=1 Q
HEAD1 ;
 W:$D(IOF) @IOF
HEAD2 ;
 I 'BMCPG S BMCPG=BMCPG+1 Q
 S BMCPG=BMCPG+1 W:$D(IOF) @IOF W !,?(IOM-20),"Page ",BMCPG
 Q