BMCFDRS ; IHS/PHXAO/TMJ - DRIVER TO PRINT ROUTING SLIP ;  
 ;;4.0;REFERRED CARE INFO SYSTEM;**3**;JAN 09, 2006
 ;IHS/ITSC/FCJ MOD ADDL DOC SECTION WAS NOT FORMATING CORRECTLY
 ;4.0*3 3.19.2007 IHS/OIT/FCJ REMOVED KILL OF BMCCHSA VAR IN KILL LINE
 ;
 ; This program prints a routing slip that lists the
 ; additional documentation which will accompany a referral.
 ;
START ;EP - ENTRY POINT FROM OPTION LIST
 W:$D(IOF) @IOF
 W "********** ROUTING SLIP PRINT **********",!!
 W "This report will produce a hard copy computer-generated routing slip.",!
 S BMCQUIT=0
GETREF ;
 W !! S BMCREF=""
 S DIC="^BMCREF(",DIC(0)="AEMQ",DIC("A")="Select Referral by Patient Name, Date of Referral or Referral #: " D ^DIC K DA,DIC
 G:Y=-1 XIT
 S BMCREF=+Y
ZIS ;     
 W !! S XBRC="COMP^BMCFDRS",XBRP="PRINT^BMCFDRS",XBNS="BMC",XBRX="XIT^BMCFDRS"
 D ^XBDBQUE
 Q
COMP ;
 Q
XIT ;
 K BMCAR,BMCCAP,BMCCHSR,BMCDA,BMCFILE,BMCFTYPE,BMCIOM,BMCKPDA,BMCNODE,BMCPG,BMCQUIT,BMCR0,BMCREF,BMCRNS,BMCV,BMCX,BMCY,BMCI,BMCDFN,BMCCHSAS,BMCCHSAP
 K A,C,D,D0,D1,DA,DD,DDSFILE,DI,DIADD,DIC,DICR,DIE,DIK,DINUM,DIPGM,DIQ,DIR,DIWF,DIWL,DIWR,DLAYGO,DO,DQ,DR,DTOUT,F,G,I,J,N,P,T,X,Y,Z
 Q
 ;
 ;
 ;-------------------------------------------------------
PRINT ;EP - PRINT ROUTING SLIP
 S BMCR0=^BMCREF(BMCREF,0),BMCPG=0,BMCDFN=$P(BMCR0,U,3)
 D @("HEAD"_(2-($E(IOST,1,2)="C-")))
 S BMCQUIT=0
 S X="Routing Slip for Contract Health",C=1,N=1,T=0 D W Q:BMCQUIT
 D S
 Q:BMCQUIT
DEMO ;Demographic Data
 S X="Patient Name:  "_$$VAL^XBDIQ1(90001,BMCREF,.03),C=0,N=1,T=3 D W Q:BMCQUIT
 S X="ID Number:  "_$$HRN^AUPNPAT($P(BMCR0,U,3),DUZ(2),2),C=0,N=0,T=55 D W Q:BMCQUIT
 S X="Referral Number:  "_$$VAL^XBDIQ1(90001,BMCREF,.02)_" "_$P($G(^BMCREF(BMCREF,1)),U),C=0,N=1,T=0 D W Q:BMCQUIT
 S X="Date Initiated:  "_$$VAL^XBDIQ1(90001,BMCREF,.01),C=0,N=0,T=50 D W
 ;
DATE ;
 S X="Appointment Date:  "_$$AVDOS^BMCRLU(BMCREF),C=0,N=1,T=48 D W Q:BMCQUIT
 ;
 W !
REFTO ;
 D @$$VALI^XBDIQ1(90001,BMCREF,.04) Q:BMCQUIT
 D L Q:BMCQUIT
 ;
 ; get listed documents here...
 F BMCY=401:1:412 D  Q:BMCQUIT
 .I $Y>(IOSL-3) D HEAD Q:BMCQUIT
 .W !!,"____"_$S($$VALI^XBDIQ1(90001,BMCREF,BMCY)="Y":"X",1:"_")_"______   ",$P($T(DOCLIST+(BMCY-400)),";",3),?60,"__________"
 .Q
 ;
ADDLDOC ; get any additional documents
 K BMCAR D ENP^XBDIQ1(90001,BMCREF,501,"BMCAR(","E")
 W !!,"Additional Documentation:"
 S BMCY="" F  S BMCY=$O(BMCAR(501,BMCY)) Q:BMCY=""!(BMCQUIT)  D
 .I $Y>(IOSL-3) D HEAD Q:BMCQUIT
 .W !,BMCAR(501,BMCY)
PRTDISP ; bottom of routing slip - include space to write in disposition
 N IX W !!,"Disposition: " F IX=1:1:57 W "_"
 W !!,"             " F IX=1:1:57 W "_"
 W !!,"             " F IX=1:1:57 W "_"
 K IX
 Q
 ;---------------------------------------------------------------
W ;
 Q:X=""
 NEW %
 S %=$L(X)
 I $Y>(IOSL-4) D HEAD Q:BMCQUIT
 I N F I=1:1:N W !
 I $G(C) W ?(IOM-$L(X)/2),X Q
 S %=$S($G(T):T,1:0) W ?%,X
 Q
C ;
 S BMCV=$P(BMCR0,U,7)
 Q:'BMCV
 S X="Referred to:  "_$$VAL^XBDIQ1(90001,BMCREF,.07)_$S($$VAL^XBDIQ1(9999999.11,BMCV,1109)]"":"  ("_$$VAL^XBDIQ1(9999999.11,BMCV,1109)_")",1:"") S N=1,C=0,T=3 D W Q:BMCQUIT
 I $P(BMCR0,U,9) S X="("_$$VAL^XBDIQ1(90001,BMCREF,.09)_")" S N=1,C=0,T=17 D W Q:BMCQUIT
 I $$VAL^XBDIQ1(9999999.11,BMCV,1301)]"" S X=$$VAL^XBDIQ1(9999999.11,BMCV,1301)_$S($$VAL^XBDIQ1(9999999.11,BMCV,1310)]"":",  "_$$VAL^XBDIQ1(9999999.11,BMCV,1310),1:"") S N=1,C=0,T=17 D W Q:BMCQUIT
 I $$VAL^XBDIQ1(9999999.11,BMCV,1302)]"" S X=$$VAL^XBDIQ1(9999999.11,BMCV,1302)_",  "_$$VAL^XBDIQ1(9999999.11,BMCV,1303)_"   "_$$VAL^XBDIQ1(9999999.11,BMCV,1304),N=1,C=0,T=17 D W Q:BMCQUIT
 Q
I ;
 S BMCV=$P(BMCR0,U,8)
 Q:'BMCV
 S X="Referred to:  "_$$VAL^XBDIQ1(90001,BMCREF,.08)_$S($$VAL^XBDIQ1(9999999.06,BMCV,.13)]"":"  ("_$$VAL^XBDIQ1(9999999.06,BMCV,.13)_")",1:"") S N=1,C=0,T=3 D W Q:BMCQUIT
 I $P(BMCR0,U,9) S X="("_$$VAL^XBDIQ1(90001,BMCREF,.09)_")" S N=1,C=0,T=17 D W Q:BMCQUIT
 I $$VAL^XBDIQ1(9999999.06,BMCV,.14)]"" S X=$$VAL^XBDIQ1(9999999.06,BMCV,.14) S N=1,C=0,T=17 D W Q:BMCQUIT
 I $$VAL^XBDIQ1(9999999.06,BMCV,.15)]"" S X=$$VAL^XBDIQ1(9999999.06,BMCV,.15)_",  "_$$VAL^XBDIQ1(9999999.06,BMCV,.16)_"   "_$$VAL^XBDIQ1(9999999.06,BMCV,.17),N=1,C=0,T=17 D W Q:BMCQUIT
 Q
N ;
 S X="IN HOUSE REFERRAL",N=1,C=0,T=0 D W Q:BMCQUIT
 S X="Referred to:  "_$$VAL^XBDIQ1(90001,BMCREF,.23)_" clinic",N=1,C=0,T=3 D W Q:BMCQUIT
 Q
O ;
 S BMCV=$P(BMCR0,U,7)
 I BMCV D  I 1
 .S X="Referred to:  "_$$VAL^XBDIQ1(90001,BMCREF,.07)_$S($$VAL^XBDIQ1(9999999.11,BMCV,1109)]"":"  ("_$$VAL^XBDIQ1(9999999.11,BMCV,1109)_")",1:"") S N=1,C=0,T=3 D W Q:BMCQUIT
 .I $P(BMCR0,U,9) S X="("_$$VAL^XBDIQ1(90001,BMCREF,.09)_")" S N=1,C=0,T=17 D W Q:BMCQUIT
 .I $$VAL^XBDIQ1(9999999.11,BMCV,1301)]"" S X=$$VAL^XBDIQ1(9999999.11,BMCV,1301)_$S($$VAL^XBDIQ1(9999999.11,BMCV,1310)]"":",  "_$$VAL^XBDIQ1(9999999.11,BMCV,1310),1:"") S N=1,C=0,T=17 D W Q:BMCQUIT
 .I $$VAL^XBDIQ1(9999999.11,BMCV,1302)]"" S X=$$VAL^XBDIQ1(9999999.11,BMCV,1302)_",  "_$$VAL^XBDIQ1(9999999.11,BMCV,1303)_"   "_$$VAL^XBDIQ1(9999999.11,BMCV,1304),N=1,C=0,T=17 D W Q:BMCQUIT
 E  S X="Referred to:  "_$$VAL^XBDIQ1(90001,BMCREF,.09),N=1,C=0,T=0 D W Q:BMCQUIT
 Q
L ;
 S T=0,X=$TR($J(" ",IOM)," ","_") S N=1,C=0 D W Q:BMCQUIT
 Q
D ;
 S T=0,X=$TR($J(" ",IOM)," ","-") S N=1,C=0 D W Q:BMCQUIT
 Q
S ;
 S T=0,X=$TR($J(" ",IOM)," ","*") S N=1,C=0 D W Q:BMCQUIT
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
DOCLIST ;
 ;;PCC Visit Form
 ;;Specialty Clinic Notes
 ;;Prenatal Record(s)
 ;;Signed Tubal Consent
 ;;Face Sheet
 ;;Health Summary
 ;;Most Recent EKG
 ;;History and Physical
 ;;X-Ray / Report
 ;;X-Ray Film
 ;;Consultation Report
 ;;Most Recent Lab Report
 Q
