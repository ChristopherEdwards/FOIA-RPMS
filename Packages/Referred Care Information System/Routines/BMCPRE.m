BMCPRE ; IHS/PHXAO/TMJ - PREINIT, CHK RQMNTS, ETC., DELETE DICS ;   
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
 ;Patch #1 - Includes running this same Pre-Init Routine
 NEW BMCNAME
 I '$G(DUZ) K DIFQ W $C(7),!,"DUZ UNDEFINED OR 0." S XPDQUIT=1 Q
 S IOM=IO ;IOM Variable doesn't appear to be around
 I '$L($G(DUZ(0))) K DIFQ W $C(7),!,"DUZ(0) UNDEFINED OR NULL." S XPDQUIT=1 Q
 S X=$P(^VA(200,DUZ,0),U),BMCNAME=$P($T(BMCPRE+1),";",4)
 W !!,"Hello - Checking system requirements...."
 I $G(^DD("VERSION"))<21 K DIFQ W $C(7),!,"I NEED AT LEAST FILEMAN 21." S XPDQUIT=1 Q
 W !,"FileMan OK.."
 I $S('$O(^DIC(9.4,"C","XU",0)):1,$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))<7.1:1,1:0) K DIFQ W !,"I NEED AT LEAST KERNEL 7.1" S XPDQUIT=1 Q
 W !,"Kernel OK..."
 S %="STATUS"
 S X="BMC",Y="BMB"
 I '$D(^DIC(9.4,"C","BMC")),'$D(^DIC(19,"C",X)),'($E($O(^DIC(19,"B",Y)),1,4)=X),'($E($O(^DIC(19.1,"B",Y)),1,4)=X) W !!,"NEW INSTALL",! S ^TMP($J,"BMC","NEW INSTALL")=1 Q
 ;
 NEW DIC
V1 ;
 W !!,"Checking PACKAGE File For Duplicate "_BMCNAME_" Entries"
 S X="BMC",DIC="^DIC(9.4,",DIC(0)="",D="C" D IX^DIC
 I Y<0 D  S XPDQUIT=1 Q
 .K DIFQ
 .W !!,$C(7),$C(7),"You Have More Than One Entry For The "_BMCNAME_" In Your Package File."
 .W !,"One entry needs to be deleted."
 .W !,"Please Contact Computer Support Personnel Before Proceeding.",!!,$C(7),$C(7),$C(7)
 .D EOP^BMC
 .Q
 W !,"PACKAGE file OK..."
 ;
 ;D ^BMCPREI
 Q
