XMZDOM0 ;(WASH ISC)/CAP - CONVERT MAILMAN HOST #'S TO IDCU ;5/22/90  13:24
 ;;7.1;Mailman;**1003**;OCT 27, 1998
 ;;1.0;
 ;;ALL;
 ;FROM GO^XMZDOM
 S XMA=0,XMA(0)=0 H 3
A S XMA=XMA+1 G:'$D(^UTILITY($J,"#",XMA)) A:$O(^(XMA)),Q S X=^(XMA),XMB=$P(X,";",3),XMC=$P(X,";",4),XMD(0)=$P(X,";",5),XMA(0)=XMA(0)+1
 K XMS I XMB="",XMB?1"END".E G Q
 I XMB'?1.E1".VA.GOV",":COM:EDU:MIL:"'[(":"_$P(XMB,U,$L(XMB,U))) S XMB=XMB_".VA.GOV"
 S ^UTILITY($J,"!",XMB)="",XME=$O(^DIC(4.2,"B",XMB,0)),XME=$S(XME:XME,1:"ZILCH"),XMF=$S($D(^DIC(4.2,XME,0)):^(0),1:"") I XMF="" S XMS(99)="??? NO DOMAIN ON FILE"
 I XMF0'="VADATS" S XMD=$P(XMF,U,12) I $L(XMD)<5,XMD'=XMD(0),XME'="ZILCH" S XMS(1)="VADATS ("_$s($L(XMD):XMD,1:"No Entry in")_" file / "_XMD(0)_" Sent)"
 S %=$S(XMC:$D(^UTILITY($J,XMC)),1:0) I % S %0=^(XMC)
 I XMC S ^UTILITY($J,XMC)=XMB
 I % S XMS(2)="DUPLICATE IDCU # "_$P(%0,".")
 D HD:$Y>IOSL!'XMPG W !,XMB,?28,$J(XMD(0),6),?36,$S(XMC:XMC,1:"***UNKNOWN***   ")
 G G:":VADATS:IDCU:"'[(":"_XMF0_":")
 S $P(XMF,U,12)=$S(XMF0="IDCU"&XMC:XMC,XMF0="VADATS"&XMD(0):XMD(0),1:"") S ^DIC(4.2,XME,0)=XMF
G S X=$O(XMS(0)) G A:X=""
B W ?48,XMS(X) S X=$O(XMS(X)) G A:X="" W ! G B
Q W !!!,XMA(0)," DOMAINS PROCESSED" G QQ:$E(XMF0)="P",XX:XMF0="VADATS"
 W !!,"<<< Looking for domains that were not updated >>>",!
 S (%,Y,X)=0 F I=0:0 S %=$O(^DIC(4.2,%)) Q:+%'=%  S Y=Y+1,I=$S($D(^(%,0)):^(0),1:"") W:Y#10=0 "." I $P(I,U,12),$P(I,U,12)'?8N,'$D(^UTILITY($J,"!",$P(I,U))) W !,$P(I,U) S X=X+1
 W !,$S(X:X_" Domains found that were not updated",1:"All domains updated"),!!,"<<< DONE >>>",!!!
XX I XMF0'="IDCU" G QQ:XMF0'="VADATS"
 I  W !!,*7,"You have completed your conversion back to VADATS MailMan Host numbers.",!,"I am updating the TRANSMISSION SCRIPT file now." S XME="OLDMINI^MINIENGINE" D BCK S XME="OLDAUSTIN^AUSTIN" D BCK G QQ
 ;
CONT W !!,*7,"Updating TRANSMISSION SCRIPTS !!"
 W !!,"OLDMINI created as a copy of MINIENGINE",!
 S XME="MINIENGINE^OLDMINI" D TEST Q:'X
 W !,"OLDAUSTIN created as a copy of AUSTIN",!
 S XME="AUSTIN^OLDAUSTIN" D TEST Q:'X
 ;CHANGE OLD TO NEW
 S X="MINIENGINE" D TEXT S X="AUSTIN" D TEXT
 W !!,"!!!!!! END OF CONVERSION !!!!!!",!!!!!,"Please test some of your scripts -- especially FOC-AUSTIN.",!!!!!!!!!!
QQ X ^%ZIS("C") S IO="HOME" D HOME^%ZIS
 G KILL^XMZDOM
HD S XMPG=XMPG+1 W @IOF I XMF0="IDCU" W ?36,"IDCU CONVERSION"
 I XMF0="VADATS" W ?35,"VADATS CONVERSION"
 I $E(XMF0)="P" W ?32,"PRE-CONVERSION CHECK"
 W !,?31,XMDT,?70,"PAGE: ",XMPG,!!
 W !,?29,"VADATS    IDCU",!,"DOMAIN",?29,"NUMBER    NUMBER",?50,"NOTES",!!
 Q
TEST S X=$O(^XMB(4.6,"B",$P(XME,U),0))
 I 'X W !!,*7,"I can not find a "_$P(XME,U)_" script (I checked the B x-ref of file 4.6).",!,"Please fix and restart 'DO CONT^XMZDOM0'."
 S %=$S($D(^XMB(4.6,0)):^(0),1:"TRANSMISSION SCRIPT^4.6^"),XMT=$P(%,U,3)+1,^(0)=$P(%,U,1,2)_"^"_XMT_"^"_($P(%,U,4)+1),%=XMT,%Y="^XMB(4.6,"_%_",",%X="^XMB(4.6,"_X_","
 D T S %=XMT D SET Q
SET S $P(^XMB(4.6,%,0),U)=$P(XME,U,2),^XMB(4.6,"B",$P(XME,U,2),%)="" Q
BCK S DA=$O(^XMB(4.6,"B",$P(XME,U,2),0))
 I DA S DIK="^XMB(4.6," D ^DIK
 K DIK,DA S %=$O(^XMB(4.6,"B",$P(XME,U),0)) K ^(%) G SET
T N %,Y D %XY^%RCR Q
TEXT W !!,"initializing your "_X_" script." S:'$D(XMP) XMP="" S:'$D(XMU) XMU=""
 I '$L(XMP)!'$L(XMU) W *7,!!,"NO UserID or Password entered.  Edit "_X_" script in the 4.6 file later",!,"or your network mail will not function !",!
 S XME=$O(^XMB(4.6,"B",X,0)) K ^XMB(4.6,XME,1) S ^(1,0)="^^9^9^"_$E(DT,1,7)
 F X=1:1 S Y=$P("W 6^L USER ID?^S"_$S($L(XMU):" "_XMU,1:"UserID")_"^L PASSWORD?^S"_$S($L(XMP):" "_XMP,1:"Password")_"^L DESTINATION^X W XMHOST^S^L CONNECTED",U,X) Q:Y=""  S ^XMB(4.6,XME,1,X,0)=Y
 K ^XMB(4.6,XME,2) S ^(2,0)="^^1^1^"_$E(DT,1,7),^(1,0)="This is the script for the Miniengine of the IDCU."
 Q
