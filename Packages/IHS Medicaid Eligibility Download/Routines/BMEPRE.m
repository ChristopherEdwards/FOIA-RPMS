BMEPRE ; IHS/PHXAO/TMJ - MEDICAID ELIGIBILITY DOWNLOAD PREINIT, CHK RQMNTS, ETC., DELETE DICS ;    [ 06/25/03  9:59 AM ]
 ;;1.0T1;MEDICAID ELIGIBLITITY DOWNLOAD;;JUNE 25, 2003
 NEW BMENAME
 I '$G(DUZ) K DIFQ W $C(7),!,"DUZ UNDEFINED OR 0." S XPDQUIT=1 Q
 S IOM=IO ;IOM Variable doesn't appear to be around
 I '$L($G(DUZ(0))) K DIFQ W $C(7),!,"DUZ(0) UNDEFINED OR NULL." S XPDQUIT=1 Q
 S X=$P(^VA(200,DUZ,0),U),BMENAME=$P($T(BMEPRE+1),";",4)
 W !!,"Hello - Checking system requirements...."
 I $G(^DD("VERSION"))<22 K DIFQ W $C(7),!,"I NEED AT LEAST FILEMAN 22." S XPDQUIT=1 Q
 W !,"FileMan OK.."
 I $S('$O(^DIC(9.4,"C","XU",0)):1,$G(^DIC(9.4,$O(^DIC(9.4,"C","XU",0)),"VERSION"))<8.0:1,1:0) K DIFQ W !,"I NEED AT LEAST KERNEL 8.0" S XPDQUIT=1 Q
 W !,"Kernel OK..."
 S %="STATUS"
 S X="BME",Y="BMB"
 I '$D(^DIC(9.4,"C","BME")),'$D(^DIC(19,"C",X)),'($E($O(^DIC(19,"B",Y)),1,4)=X),'($E($O(^DIC(19.1,"B",Y)),1,4)=X) W !!,"NEW INSTALL",! S ^TMP($J,"BME","NEW INSTALL")=1 Q
 ;
 NEW DIC
V1 ;
 W !!,"Checking PACKAGE File For Duplicate "_BMENAME_" Entries"
 S X="BME",DIC="^DIC(9.4,",DIC(0)="",D="C" D IX^DIC
 I Y<0 D  S XPDQUIT=1 Q
 .K DIFQ
 .W !!,$C(7),$C(7),"You Have More Than One Entry For The "_BMENAME_" In Your Package File."
 .W !,"One entry needs to be deleted."
 .W !,"Please Contact Computer Support Personnel Before Proceeding.",!!,$C(7),$C(7),$C(7)
 .;D EOP^BME
 .Q
 W !,"PACKAGE file OK..."
 ;
 ;D ^BMEPREI
 Q
