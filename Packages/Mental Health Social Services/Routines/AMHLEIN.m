AMHLEIN ; IHS/CMI/LAB - INITIALIZE AND SET UP PARAMETERS ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;ss/mh narratives
 ;
 ;
START ;EP - called from AMHLE
 I '$D(IOF) D HOME^%ZIS
 S AMHDASH="-------------------------------------------------------------------------------"
 S APCDOVRR="" ;FOR PROVIDER NARRATIVE LOOKUP
 S AMHLEIN="" ;variable to let system know we're in BH DE
 S AMHBEEP=$C(7)_$C(7)
 I '$G(DUZ(2)) W !!,AMHBEEP,AMHBEEP,"Site not set in DUZ(2) - please login to Kernel first!!" S AMHQUIT=1 Q
 I $G(^AMHSITE(DUZ(2),0))="" W !!,AMHBEEP,AMHBEEP,"Site Parameter file not established for this Location ",$P(^DIC(4,DUZ(2),0),U),".",!,"NOTIFY S MANAGER.  CANNOT CONTINUE." S AMHQUIT=1 Q
PCCCHECK ;check to see if link to pcc active, set AMHLPCC IF SO
 K AMHLPCC
 S (AMHLPCC,AMHLPCCT)=$P(^AMHSITE(DUZ(2),0),U,12) I AMHLPCC S AMHLPCC=AMHLPCC-1
 I AMHLPCC="" W !,AMHBEEP,AMHBEEP,"PCC Link Type NOT defined in BH Site Parameter file.",!,"No PCC LINK will OCCUR!!  NOTIFY SYSTEM ADMINISTRATOR",! S AMHLPCC=0
 Q:'AMHLPCC
 I $D(^AUTTSITE(1,0)),$P(^(0),U,8)="Y",'$D(^APCCCTRL(DUZ(2),0))#2 W !,$C(7),"ENTRY MUST BE MADE IN THE PCC MASTER CONTROL FILE FOR THIS LOCATION",!,"PLEASE NOTIFY YOUR S MANAGER ... NO LINKAGE TO PCC IS OCCURRING !" H 5 S AMHLPCC=0
 S AMHPKG=$O(^DIC(9.4,"C","AMH",""))
 I '$D(^APCCCTRL(DUZ(2),11,AMHPKG,0))#2 W !,$C(7),"ENTRY MUST BE MADE IN THE PCC MASTER CONTROL FILE FOR THIS PACKAGE !",!,"PLEASE NOTIFY YOUR S MANAGER ... NO LINKAGE TO PCC IS OCCURRING !"  S AMHLPCC=0 H 4
 I $D(^AUTTSITE(1,0)),$P(^(0),U,8)="Y",$D(^APCCCTRL(DUZ(2),0))#2,$D(^APCCCTRL(DUZ(2),11,AMHPKG,0))#2,$P(^(0),U,2) S AMHLPCC=AMHLPCC
 E  S AMHLPCC=0
 K AMHPKG
 Q
CALLDIE ;EP
 Q:'$D(DA)
 Q:'$D(DIE)
 K DIV,DIU,DIY,DIW,DIG,DIH
 NEW AMHG S AMHG=DIE_DA_")" L +(@AMHG):10 E  W !!,"Can't lock global",! Q
 Q:'$D(DR)
 D ^DIE
 L -(@AMHG):10
 K DIE,DIC,DR,DA,D0,D,D1,DO,%X,%Y,X,A,Z,DIU,DIV,DIY,DIW,DIADD,DLAYGO,%,%E,%D,%W,DI,DIFLD,DIG,DIH,DK,DL,DISYS,AMHG
 Q
PAUSE ;EP
 Q:$E(IOST)'="C"!(IO'=IO(0))
 W ! S DIR(0)="EO",DIR("A")="Press enter to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
DONE ;ENTRY POINT - END OF REPORT TIME DISPLAY
 I $D(AMHET) S AMHTS=(86400*($P(AMHET,",")-$P(AMHBT,",")))+($P(AMHET,",",2)-$P(AMHBT,",",2)),AMHH=$P(AMHTS/3600,".") S:AMHH="" AMHH=0 D
 .S AMHTS=AMHTS-(AMHH*3600),AMHM=$P(AMHTS/60,".") S:AMHM="" AMHM=0 S AMHTS=AMHTS-(AMHM*60),AMHS=AMHTS W !!,"RUN TIME (H.M.S): ",AMHH,".",AMHM,".",AMHS
 I $E(IOST)="C",IO=IO(0) S DIR(0)="EO",DIR("A")="End of report.  PRESS ENTER" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W:$D(IOF) @IOF
 K AMHTS,AMHS,AMHH,AMHM,AMHET
 D ^AMHEKL
 Q
GETCOMM(S,P,F) ;EP  - return default community
 NEW AMHX
 I $G(F)="" S F="I"
 S AMHX="" I "MSCO"'[P Q AMHX
 I '$D(^AMHSITE(S,0)) Q AMHX
 S AMHX=$S(P="M":$P(^AMHSITE(S,0),U,6),P="C":$P(^AMHSITE(S,0),U,29),P="S":$P(^AMHSITE(S,0),U,21),1:$P($G(^AMHSITE(S,18)),U,2))
 I F="I"!(AMHX="") Q AMHX
 ;I F="E" S AMHX=$P(^AUTTCOM(AMHX,0),U)
 I F="E" S AMHX="`"_AMHX
 Q AMHX
GETTOC(S,F) ;EP - return default type of visit
 I $G(F)="" S F="I"
 I '$D(^AMHSITE(S,0)) Q ""
 Q $S(F="I":$P(^AMHSITE(S,0),U,9),1:$$VAL^XBDIQ1(9002013,S,.09))
GETAWI(S,F) ;EP - return default appt/wi
 I $G(F)="" S F="I"
 I '$D(^AMHSITE(S,0)) Q ""
 Q $S(F="I":$P(^AMHSITE(S,0),U,24),1:$$VAL^XBDIQ1(9002013,S,.24))
GETLOC(S,P,F) ;EP - return default location
 NEW AMHX
 S AMHX="" I "MSCO"'[P Q AMHX
 I $G(F)="" S F="I"
 I '$D(^AMHSITE(S,0)) Q AMHX
 S AMHX=$S(P="M":$P(^AMHSITE(S,0),U,5),P="C":$P(^AMHSITE(S,0),U,28),P="S":$P(^AMHSITE(S,0),U,19),1:$P($G(^AMHSITE(S,18)),U,1))
 I F="I" Q AMHX
 I AMHX="" Q AMHX
 I F="E" S AMHX=$P(^DIC(4,AMHX,0),U)
 Q AMHX
ASKINT(S) ;EP return 1 if should ask interpretor
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(S,0)) Q AMHX
 S AMHX=$P(^AMHSITE(S,0),U,11)
 Q AMHX
UNIVSITE(AMHSITE) ;EP return U or S
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,0)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,0),U,15)
 Q AMHX
ASKCC(AMHSITE) ;EP return 1 or 0 if should ask chief complaint
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,0)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,0),U,16)
 Q AMHX
GETCLN(S,P,F) ;EP return default clinic
 NEW AMHX
 S AMHX=""
 I $G(P)="" Q AMHX
 I $G(F)="" S F="I"
 S AMHX="" I "MSCO"'[P Q AMHX
 I '$D(^AMHSITE(S,0)) Q AMHX
 S AMHX=$S(P="M":$P(^AMHSITE(S,0),U,17),P="C":$P(^AMHSITE(S,0),U,31),P="S":$P(^AMHSITE(S,0),U,22),1:$P($G(^AMHSITE(S,18)),U,3))
 I AMHX="" Q AMHX
 I F="I" Q AMHX
 S AMHX=$P(^DIC(40.7,AMHX,0),U)
 Q AMHX
ASKPCC(AMHSITE) ;EP ask about pcc problem list?
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,0)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,0),U,18)
 Q AMHX
MHNARR(AMHSITE) ;EP get mh default narrative
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,0)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,0),U,14)
 Q AMHX
CDNARR(AMHSITE) ;EP
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,12)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,12),U,2)
 Q AMHX
OTNARR(AMHSITE) ;EP
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,12)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,12),U,3)
 Q AMHX
SSNARR(AMHSITE) ;EP get mh default narrative
 NEW AMHX
 S AMHX=""
 I '$D(^AMHSITE(AMHSITE,12)) Q AMHX
 S AMHX=$P(^AMHSITE(AMHSITE,12),U)
 Q AMHX
 ;ss/mh narratives
C(X,X2,X3) ;EP
 D COMMA^%DTC
 Q $$STRIP^XLFSTR(X," ")
 ;
D(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR("A")="End of report.  Press Enter",DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
