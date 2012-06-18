BDP ; IHS/CMI/TMJ - DESG SPECIALTY PROVIDER MGT SYSTEM ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 I '$D(ZTQUEUED) W !!,*7,"NO ENTRY FROM THE TOP OF ^BDP.",!
 S BDPQ=1
 Q
 ;----------
LZERO(V,L) ;left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
 ;----------
ASF() ;EP - Return ASUFAC number for current DUZ(2).
 Q:'$G(DUZ(2)) ""
 Q $P($G(^AUTTLOC(DUZ(2),0)),U,10)
 ;----------
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
DIC(DIC) ;EP - File lookup.
 S:'$D(DIC(0)) DIC(0)="AMQN"
 D DIC^BDPFMC
 Q +Y
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
HDR ;EP - Screen header 
 Q:$G(XQY0)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2)
 S:X="Designated Specialty Provider Management System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 ;I X="Designated Specialty Provider Management System" S X="MAIN MENU"
 W @IOF,!,$$CTR("DESIGNATED SPECIALTY PROVIDER MANAGEMENT SYSTEM"),!,$$CTR($$LOC()),!,$$CTR(X),!!
 Q
 ;----------
LOCK(DA) ;EP - Lock the selected Record.
 LOCK +^BDPRECN(DA):20
 E  W:'$D(ZTQUEUED) *7,!!,"  This Document Is Currently Being Processed (Document LOCKED).",!! D EOP I 0
 Q
 ;----------
UNLOCK(DA)         ;EP - Unlock the selected record.
 LOCK -^BDPRECN(DA):20
 E  W:'$D(ZTQUEUED) *7,!!,"  UNABLE TO UNLOCK RECORD.  NOTIFY PROGRAMMER.",!! D EOP I 0
 Q
 ;----------
LOGO ;EP - Print logo of main menu.
 NEW A,D,I,L,N,R,V
 S L=18,R=61,D=R-L+1,N=R-L-1
 S I=$O(^DIC(9.4,"C","BDP",0)),V=^DIC(9.4,I,"VERSION"),A=$O(^DIC(9.4,I,22,"B",V,0)),Y=$$FMTE^XLFDT($P(^DIC(9.4,I,22,A,0),U,2))
 W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!?L,"*",$$CTR("INDIAN HEALTH SERVICE",N),?R,"*",!?L,"*",$$CTR("DESIGNATED SPECIALTY PROVIDER MGT SYSTEM",N),?R,"*",!?L,"*",$$CTR("VERSION "_V_", "_Y,N),?R,"*",!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W $$CTR($$LOC())
 ;Sub Menu Displays
 Q:$G(XQY0)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2)
 S:X="Designated Specialty Provider Management System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 W !,$$CTR(X),!
 Q
 ;----------
DEV ; EP - SELECT OUTPUT DEVICE
 S BDPQ=0
 S %ZIS="PQ" D ^%ZIS
 S:POP BDPQ=1
 Q
 ;----------
PAUSE ; EP - PAUSE FOR USER
 W !
 S DIR(0)="EO",DIR("A")="Press return to continue...." D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 W !
 Q
 ;----------
CONF ; EP - CONFIDENTIAL CLIENT DATA HEADER
 W !,$$CTR("*** CONFIDENTIAL PATIENT INFORMATION ***"),!
 Q
 ;----------
 Q Y
