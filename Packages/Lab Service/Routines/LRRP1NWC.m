LRRP1 ;SLC/RWF/BA-PRINT THE DATA FOR INTERIM REPORTS ;11/9/88  17:31 [ 04/28/2003  2:47 PM ]
 ;;5.2;LR;**1004,1013,1016,1018,1019**;MAR 25, 2004
 ;;5.2;LAB SERVICE;**153,221,283**;Sep 27, 1994
 ;from LRRP, LRRP2, LRRP3
PRINT S:'$L($G(SEX)) SEX="M" S:'$L($G(DOB)) DOB="UNKNOWN"
 S LRAAO=0 F  S LRAAO=$O(^TMP("LR",$J,"TP",LRAAO)) Q:LRAAO<1  D ORDER Q:LRSTOP
 K ^TMP("LR",$J,"TP")
 Q
ORDER N LRCAN
 S LRCDT=0
 F  S LRCDT=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT)) Q:LRCDT<1  D
 . S LRCAN=0
 . I LRSS="CH" D
 . . S LRIDT=9999999-LRCDT
 . . F  S LRCAN=+$O(^LR(LRDFN,"CH",LRIDT,1,LRCAN)) Q:LRCAN<1  Q:$E($G(^(LRCAN,0)))="*"
 . D TEST Q:LRSTOP
 Q
TEST S LRIDT=9999999-LRCDT,LRSS=$P(^TMP("LR",$J,"TP",LRAAO),U,2)
 S LR0=$S($D(^(LRAAO,LRCDT))#2:^(LRCDT),1:""),LRTC=$P(LR0,U,12)
 I LRSS="MI" S LRH=1 D:LRFOOT FOOT Q:LRSTOP  D EN1^LRMIPC S LRHF=1,LRFOOT=0 K A,Z,LRH S:LREND LREND=0,LRSTOP=1 Q
 Q:'$G(LRCAN)&('$P(LR0,U,3))  D @$S(LRHF:"HDR",1:"CHECK") Q:LRSTOP
 ;----- BEGIN IHS MODIFICATION LR*5.2*1016
 ;The following lines added per appendix A of RPMS Lab E-sig enhancement V5.2 Technical Manual IHS/HQW/SCR - 8/23/01
 ;Set lab audit
 ;I $P(XQY0,U)="LRRS"!($P(XQY0,U)="BLR LRRD BY MD") D
 I $P(XQY0,U)="LRRS"!($P(XQY0,U)="BLR LRRD BY MD")!($P(XQY0,U)="LRRS BY LOC")!($P(XQY0,U)="LRRD")!($P(XQY0,U)="LRRP2") D
 .I $$ADDON^BLRUTIL("LR*5.2*1013","BLRALAF",DUZ(2)) D ^BLRALAU
 ;----- END IHS MODIFICATION
 S LRSPEC=+$P(LR0,U,5),X=$P(LR0,U,10) D DOC^LRX
 W !!,?7,"Provider: ",LRDOC
 ;----- BEGIN IHS MODIFATIONS
 ;CHECK IF E-SIG TURNED ON AND ORDERING PROVIDER IS PARTICIPATING IN E-SIG
 D:'$G(BLRGUI) ESIGINFO^BLRUTIL
 ;----- END IHS MODIFICATIONS
 ;W !,?7,"Specimen: ",$P(^LAB(61,LRSPEC,0),U)
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1016 IHS TESTING CHANGE
 W !,?7,"Specimen: ",$P(^LAB(61,LRSPEC,0),U)
 ;----- END IHS MODIFICATIONS
 D ORU
 S Y=LRCDT D DD^LRX W !!,?30,"Specimen Collection Date: ",Y
 W !?5,"Test name",?30,"Result    units",?51,"Ref.   range",?66,"Site Code"
 S LRPO=0 F  S LRPO=$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO)) Q:LRPO'>0  S LRDATA=^(LRPO) D DATA Q:LRSTOP
 Q:LRSTOP
 I $D(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C")) W !,"Comment: " S LRCMNT=0 F I=0:0 S LRCMNT=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) Q:LRCMNT<1  W ^(LRCMNT) D
 . D CONT Q:LRSTOP
 . W:$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,"C",LRCMNT)) !?9
 Q:LRSTOP  D EQUALS^LRX
 W !?7,"KEY: ""L""=Abnormal low, ""H""=Abnormal high, ""*""=Critical value"
 S LRFOOT=1
 Q
DATA S LRTSTS=+LRDATA,LRPC=$P(LRDATA,U,5),LRSUB=$P(LRDATA,U,6)
 S X=$P(LRDATA,U,7),LRFFLG=$P(LRDATA,U,8),LRPLS=$P(LRDATA,U,9)
 S:$G(LRPLS) LRPLS(LRPLS)=LRPLS Q:X=""
 W !?5,$S($L($P(LRDATA,U,2))>20:$P(LRDATA,U,3),1:$P(LRDATA,U,2))
 W ?27,@$S(LRPC="":"$J(X,LRCW)",1:LRPC)," ",LRFFLG
 S X=$S($D(^LAB(60,LRTSTS,1,LRSPEC,0)):^(0),1:"")
 Q:'$L(X)
 S LRTHER=$S($L($P(X,U,11,12))>1:1,1:0)
 S LRLO=$S(LRTHER:$P(X,U,11),1:$P(X,U,2))
 S LRHI=$S(LRTHER:$P(X,U,12),1:$P(X,U,3))
 S @("LRLO="_$S($L(LRLO):LRLO,1:""""""))
 S @("LRHI="_$S($L(LRHI):LRHI,1:""""""))
 W ?38,"  ",$P(X,U,7),?51,$J(LRLO,4),$S($L(LRHI):" - "_$J(LRHI,4),1:"")
 W ?63,$S(LRTHER:"(Ther. range)",1:"")
 I LRPLS'="" W ?68,"[",LRPLS,"]"
 D CONT Q:LRSTOP
 I $O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,0))>0 S LRINTP=0 F I=0:0 S LRINTP=+$O(^TMP("LR",$J,"TP",LRAAO,LRCDT,LRPO,LRINTP)) Q:LRINTP<1  W !?7,"Eval: ",^(LRINTP) D CONT Q:LRSTOP
 Q
CHECK I LRTC+11>(IOSL-$Y) D FOOT Q:LRSTOP  D HDR
 Q
CONT I $Y+5>IOSL D FOOT Q:LRSTOP  D HDR W !?20,">> CONTINUATION OF ",$P(LR0,U,6)," <<",!
 Q
FOOT ;from LRRP, LRRP2, LRRP3
 Q:LRSTOP  F I=$Y:1:IOSL-4 W !
 ;----- BEGIN IHS MODIFICATION LR*5.2*1016
 ;I $E(IOST,1,2)'="C-" W !,PNM,?40,"  ",SSN,"  ",$$FMTE^XLFDT($$NOW^XLFDT,"5FMPZ"),! Q
 ;----- BEGIN IHS MODIFICATION LR*5.2*1019 -- Do not print WORK COPY
 ; I $E(IOST,1,2)'="C-" W !,"WORK COPY - DO NOT FILE  ",PNM,?40,"  ",HRCN,"         ",LRDT0,! Q  ;IHS/ANMC/CLS 08/18/96
 I $E(IOST,1,2)'="C-" W !,"                         ",PNM,?40,"  ",HRCN,"         ",LRDT0,! Q  ;IHS/ANMC/CLS 08/18/96
 ;----- END IHS MODIFICATION LR*5.2*1019 -- Do not print WORK COPY
 ; I $E(IOST,1,2)'="C-" W !,"                         ",PNM,?40,"  ",HRCN,"         ",LRDT0,! Q  ;IHS/ANMC/CLS 08/18/96
 ;W !,PNM,?25,"  ",SSN,"  ",$$FMTE^XLFDT($$NOW^XLFDT,"5FMPZ"),?59," PRESS '^' TO STOP "
 W !,PNM,?25,"  ",HRCN,"  ",LRDT0,?59," PRESS '^' TO STOP "  ;IHS/ANMC/CLS 08/18/96
 ;----- END IHS MODIFICATION
 R X:DTIME S:X="" X=1 S:(".^"[X)!('$T) LRSTOP=1
 Q
HDR ;Add Printed at, page #, change age to dob 7/2002 cka
 W:($G(LRJ02))!($G(LRJ0))!($E(IOST,1,2)="C-") @IOF
 S LRHF=0,LRJ02=1
 I '$D(LRPG) S LRPG=0
 S LRPG=LRPG+1
 I $E(IOST,1)="P" D
 .W !!!!
 .S X="CLINICAL LABORATORY REPORT"
 .W ?(80-$L(X)\2),X,!
 I $D(DUZ("AG")),$L(DUZ("AG")),"ARMYAFN"[DUZ("AG") D ^LRAIPRIV W !
 W "Printed at: ",?65,"page ",LRPG
 ;W !,$$NAME^XUAF4(DUZ(2))," (",DUZ(2),")"
 ;S X=$$PADD^XUAF4(DUZ(2))
 ;W " ",$P(X,U)," ",$P(X,U,2),", ",$P(X,U,3)," ",$P(X,U,4)
 ;----- BEGIN IHS MODIFICATIONS LR*5.2*1017
 I $T(NAME^XUAF4)]"",($T(PADD^XUAF4)]"") D
 .W !,$$NAME^XUAF4(DUZ(2))," (",DUZ(2),")"
 .S X=$$PADD^XUAF4(DUZ(2))
 .W " ",$P(X,U)," ",$P(X,U,2),", ",$P(X,U,3)," ",$P(X,U,4)
 ;----- END IHS MODIFICATIONS
 W !
 W !,PNM,?45,"Report date: ",$$FMTE^XLFDT($$NOW^XLFDT,"5FMPZ")
 ;W !?5,"SSN: ",SSN,"    SEX: ",SEX,"    DOB: ",$$FMTE^XLFDT(DOB),"    LOC: ",LROC
 ;----- BEGIN IHS MODIFICATION LR*5.2*1016
 W !?5,"HRCN: ",HRCN,"    SEX: ",SEX,"    AGE: ",AGE,"    LOC: ",LROC  ;IHS/ANMC/CLS 08/18/96
 ;----- END IHS MODIFICATION
 Q
 ;
ORU ; Display remote ordering info if available
 N LRX
 S LRX=$G(^LR(LRDFN,"CH",LRIDT,"ORU"))
 D EN^DDIOL("Accession [UID]: "_$P(LR0,"^",6)_" ["_$P(LRX,"^")_"]","","!")
 I $P(LRX,"^",2) D
 . D EN^DDIOL("Ordering Site: "_$$EXTERNAL^DILFD(63.04,.32,"",$P(LRX,"^",2)),"","!?2")
 . D EN^DDIOL(" Ordering Site UID: "_$P(LRX,"^",5),"","?43")
 I $P(LRX,"^",3) D EN^DDIOL("Collecting Site: "_$$EXTERNAL^DILFD(63.04,.33,"",$P(LRX,"^",3)),"","!")
 Q
