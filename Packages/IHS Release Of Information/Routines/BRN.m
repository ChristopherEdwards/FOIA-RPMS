BRN ; IHS/PHXAO/TMJ - DISCLOSURE SYSTEM ;  
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF 01/24/2008 PATCH 1 Added patch # to logo & removed a line feed
 ;
 ;
 I '$D(ZTQUEUED) W !!,*7,"NO ENTRY FROM THE TOP OF ^BRN.",!
 S BRNQ=1
 Q
 ;----------
 ;----------
GETR() ;EP - Return Disclosure # from ROI DISCLOSURE record
 I '$G(BRNRIEN) Q ""
 Q $P($G(^BRNREC(BRNRIEN,0)),U,2)
 ;----------
REFN() ;EP - Return the next Disclosure number and update control file
 LOCK +^BRNPARM(DUZ(2)):20 E  W:'$D(ZTQUEUED) *7,!!,"  Unable to lock the ROI SITE PARAMETER entry for ",$$LOC,".",!! D EOP Q 0
 S BRNPARM=$G(^BRNPARM(DUZ(2),0))
 S X=$$ASF
 S X=X_$P(BRNPARM,U,2)
 S Y=$P(BRNPARM,U,7)+1
 S X=X_$$LZERO(Y,5)
 S BRNX=X
 S DIE="^BRNPARM(",DA=DUZ(2),DR=".07////"_Y D DIE^BRNFMC
 LOCK -^BRNPARM(DUZ(2)):20
 Q BRNX
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
 D DIC^BRNFMC
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
HDR ;EP - Screen header DON'S USE ANY LONGER.
 Q:$G(XQY0)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2)
 S:X="FOIA Disclosure System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 ;I X="FOIA Disclosure System" S X="MAIN MENU"
 W @IOF,!,$$CTR("FOIA DISCLOSURE SYSTEM"),!,$$CTR($$LOC()),!,$$CTR(X),!!
 Q
 ;----------
LOCK(DA) ;EP - Lock the selected Disclosure.
 LOCK +^BRNREC(DA):20
 E  W:'$D(ZTQUEUED) *7,!!,"  This Document Is Currently Being Processed (Document LOCKED).",!! D EOP I 0
 Q
 ;----------
UNLOCK(DA)         ;EP - Unlock the selected Disclosure.
 LOCK -^BRNREC(DA):20
 E  W:'$D(ZTQUEUED) *7,!!,"  UNABLE TO UNLOCK DISCLOSURE.  NOTIFY PROGRAMMER.",!! D EOP I 0
 Q
 ;----------
LOGO ;EP - Print logo of main menu.
 NEW A,D,I,L,N,R,V
 S L=18,R=61,D=R-L+1,N=R-L-1
 S I=$O(^DIC(9.4,"C","BRN",0)),V=^DIC(9.4,I,"VERSION"),A=$O(^DIC(9.4,I,22,"B",V,0)),Y=$$FMTE^XLFDT($P(^DIC(9.4,I,22,A,0),U,2))
 ;
 ;IHS/OIT/LJF 01/24/2008 PATCH 1
 NEW P,PATCH,PDATE S (PATCH,PDATE)=""
 S P=$O(^DIC(9.4,I,22,A,"PAH","B",""),-1) I P S PATCH=$P($G(^DIC(9.4,I,22,A,"PAH",P,0)),U),PDATE=$$FMTE^XLFDT($P($G(^(0)),U,2))
 ;W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!?L,"*",$$CTR("INDIAN HEALTH SERVICE",N),?R,"*",!?L,"*",$$CTR("RELEASE OF INFORMATION SYSTEM",N),?R,"*",!?L,"*",$$CTR("VERSION "_V_", "_Y,N),?R,"*",!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!?L,"*",$$CTR("INDIAN HEALTH SERVICE",N),?R,"*"
 W !?L,"*",$$CTR("RELEASE OF INFORMATION SYSTEM",N),?R,"*"
 W !?L,"*",$$CTR("VERSION "_V_" P"_PATCH_", "_$S(PDATE]"":PDATE,1:Y),N),?R,"*",!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 ;end of PATCH 1 changes
 ;
 W $$CTR($$LOC())
 ;Sub Menu Displays
 Q:$G(XQY0)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2)
 S:X="Release of Information System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 ;W !,$$CTR(X),!
 W !,$$CTR(X)   ;IHS/OIT/LJF 01/24/2008 PATCH 1
 Q
 ;----------
SEL(S) ;EP - Select a Disclosure to edit, S is DIC("S")
 NEW BRN,BRNY,DA,DIC
 S:$D(S) DIC("S")=S
 S DIC="^BRNREC(",Y=$$DIC(.DIC)
 I Y<1 Q Y
 S DA=+Y D LOCK(DA) E  Q 0
 S BRN=DA
 I '$D(ZTQUEUED) D
 .S DIC="^BRNREC(" D DIQ^BRNFMC
 .S DA=$O(^BRNCOM("AD",BRN,0)) I DA S DIC="^BRNCOM(" D DIQ^BRNFMC
 .F BRNY=0:0 S BRNY=$O(^BRNDX("AD",BRN,BRNY)) Q:'BRNY  S DA=BRNY,DIC="^BRNDX(" D DIQ^BRNFMC
 .F BRNY=0:0 S BRNY=$O(^BRNPX("AD",BRN,BRNY)) Q:'BRNY  S DA=BRNY,DIC="^BRNPX(" D DIQ^BRNFMC
 .D EOP
 .Q
 Q BRN
 ;----------
DEV ; EP - SELECT OUTPUT DEVICE
 S BRNQ=0
 S %ZIS="PQ" D ^%ZIS
 S:POP BRNQ=1
 Q
 ;----------
PAUSE ; EP - PAUSE FOR USER
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 S DIR(0)="E",DIR("A")="Press any key to continue" D ^DIR K DIR
 W !
 Q
 ;----------
CONF ; EP - CONFIDENTIAL CLIENT DATA HEADER
 W !,$$CTR("*** CONFIDENTIAL PATIENT INFORMATION ***"),!
 Q
 ;----------
TOFAC(R) ; EP - RETURN APPROPRIATE
 ;      'TO PRIMARY VENDOR/TO IHS FACILITY/TO OTHER PROVIDER'
 ; R = ROI DISCLOSURE IEN
 NEW X,Y
 S Y=""
 G:'$G(R) TOFACX
 G:'$D(^BRNREC(R,0)) TOFACX
 S X=^BRNREC(R,0)
 S Y=$P(X,U,8) I Y S Y=$P(^DIC(4,Y,0),U) G TOFACX
 S Y=$P(X,U,7) I Y S Y=$P(^AUTTVNDR(Y,0),U)
 I Y="OTHER PROVIDER (NON-CHS)" S Y=$P(X,U,9) I Y S Y=$P(^BRNLPRV(Y,0),U)
TOFACX ;
 Q Y
