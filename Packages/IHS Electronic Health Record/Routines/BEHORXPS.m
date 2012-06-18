BEHORXPS ;IHS/MSC/PLS - Prescription Print Support ;27-May-2010 07:04;PLS
 ;;1.1;BEH COMPONENTS;**009004**;Mar 20, 2007
 Q
 ; Called by BEHORXPS PSCRIPT
 ; Returns prescription text
 ; Input: ORIFN: IEN to Order File
 ;        RXNUM: Prescription number (external)
 ; Output: Array of text
PSCRIPT(DATA,ORIFN,RXNUM) ;EP
 N RX,RX1,ARAY,BEHOLOC,ORVP,CRXPR
 S DATA=$$TMPGBL^CIAVMRPC
 I '$G(ORIFN)!('$L(RXNUM)) S @DATA@(1)="Insufficient information to generate prescription printout!" Q
 S RX=$G(^OR(100,ORIFN,4))
 S RX1=$O(^PSRX("B",RXNUM,0))
 S ARAY(1)=ORIFN
 S BEHOLOC=+$P($G(^OR(100,ORIFN,0)),U,10)
 S CRXPR=$TR($$GET^XPAR("ALL","BEHORX SCRIPT CUSTOM FORMAT"),"~",U)
 I $L(CRXPR) D
 .D CAPTURE^CIAUHFS(CRXPR,DATA,80)
 E  D
 .D CAPTURE^CIAUHFS("D GUI^BEHORXPS(.ARAY,BEHOLOC,""C"",1,1)",DATA,80)
 Q
GUI(ARAY,DEVICE,FMT,LOC,TASK,ORTIMES) ;Silence of the Prints
 ;ARAY=Name of global storing list of orders or just the local aray
 ;@ARAY@(#)=ORIFN;DA of action       - Array of orders to print
 ;DEVICE=printer (internal ptr value)
 ;FMT=C:Chart copy, L:Labels, R:Requisitions, S:Service copies W:Work copies
 ;LOC=Location (ORL)
 ;TASK=1 to not task, 0 or undefined to task (default)
 ;     this affects the closing of devices in ^ORPR03
 ;ORTIMES=# of copies
 N ORPARAY,VAR
 S ORPARAY=$S($L($G(ARAY))&('$G(ARAY)):ARAY,1:"ARAY"),ARAY=ORPARAY
 Q:'$O(@ORPARAY@(0))  Q:'$D(IO)  Q:'$D(FMT)  Q:FMT=""  Q:"CLRSW"'[FMT
 N ORAL,ORVP,X,ZTRTN
 K ^TMP("ORAL",$J)
 S ORVP=$$PAT^ORPR02(.ARAY),ORAL="^TMP(""ORAL"",$J)"
 I 'ORVP S VAR("ARAY")="" D EN^ORERR("GUI~ORPR02 called with invalid ORVP",,.VAR) Q
 I '$G(LOC) S LOC=$$LOC^ORPR02(.ARAY)
 D ARAY^ORPR02(.ARAY)
 I "WC"'[FMT K ARAY S ARAY=ORAL
 S X=0_"^"_$S(FMT="L":"Labels",FMT="R":"Requisitions",FMT="S":"Service Copies",FMT="C":"Chart Copies",FMT="W":"Work Copies",1:"")
 S ZTRTN="C1^BEHORXPS"
 D @ZTRTN
 Q
C1 ; Chart Copy Print
 N ORIFN,OACTION,ORX,ORHEAD,ORFOOT,OROFMT,ORFMT,ORIOF,ORBOT,ORIOSL,ORXPND,ORFIRST1
 N ORAGE,ORDOB,ORL,ORNP,ORPNM,ORPV,ORSEX,ORSSN,ORTS,ORWARD
 ;S IOSL=56,IOM=80
 U IO
 D PAT^ORPR02(+ORVP)
 S ORHEAD=$$GET^XPAR("ALL","BEHORX SCRIPT HEADER",1,"I")
 S ORFOOT=$$GET^XPAR("ALL","BEHORX SCRIPT FOOTER",1,"I")
 S OROFMT=$$GET^XPAR("ALL","BEHORX SCRIPT FORMAT",1,"I")
 S ORIOSL=IOSL
 I ORFOOT,$D(^ORD(100.23,ORFOOT,0)) S ORBOT=$P(^(0),"^",2),ORIOSL=IOSL-ORBOT
 I ORHEAD D PRINT^ORPR00(ORHEAD,1,0,1)
 S ORIOF=IOF
 S IOF="!!"
 S ORFIRST1=1
 I OROFMT S ORFMT=OROFMT,ORCI=0 F  S ORCI=$O(@ARAY@(ORCI)) Q:ORCI<1  S ORIFN=+@ARAY@(ORCI),OACTION=$P(@ARAY@(ORCI),";",2) D  S ORFIRST1=0 Q:$G(OREND)
 . I '$L($G(^OR(100,ORIFN,0))) D EN^ORERR("PRESCRIPTION PRINT WITH INVALID ORIFN:"_ORIFN) Q
 . D CHT1^ORPR04
 . I 'OACTION D EN^ORERR("NO ACTION DEFINED FOR PRESCRIPTION PRINT ORIFN:"_ORIFN) Q
 . I '$D(^OR(100,ORIFN,8,OACTION)) D EN^ORERR("ACTION NODE ^(8) NOT SET FOR ORIFN:DA:"_ORIFN_":"_OACTION) Q
 . I '$D(ORRACT) S:'$P($G(^OR(100,ORIFN,8,OACTION,7)),"^") $P(^(7),"^",1,4)=1_"^"_$$NOW^XLFDT_"^"_DUZ_"^"_IO ;ORRACT is around if this is a reprint.
 I ORFOOT,'$G(OREND) D
 .S:IOF?1"!"."!" $P(IOF,"!",$S(ORIOSL>200:200,ORIOSL-$Y>1:ORIOSL-$Y,1:2))=""
 .D PRINT^ORPR00(ORFOOT,1)
 S IOF=ORIOF
 W @IOF
 Q
