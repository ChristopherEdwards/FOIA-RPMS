BMC ; IHS/PHXAO/TMJ - REFERRED CARE INFO SYSTEM ;     
 ;;4.0;REFERRED CARE INFO SYSTEM;**5,6**;JAN 09, 2006
 ;IHS/ITSC/FCJ CHG TST FOR IOT FOR VIR TRM
 ;BMC*4.0*6 2.16.2010 IHS.OIT.FCJ ADDED PATCH NUMBER PRINT IN LOGO SUB
 ;
 ;
 I '$D(ZTQUEUED) W !!,*7,"NO ENTRY FROM THE TOP OF ^BMC.",!
 S BMCQ=1
 Q
 ;----------
PARMCHK ;EP - Check RCIS SITE PARAMETER file
 ; Check/edit RCIS parameters.
 S BMCQ=1
 S BMCPARM=$G(^BMCPARM(DUZ(2),0))
 I BMCPARM="",'$D(ZTQUEUED) W !!,*7,"PARAMETERS NOT SET FOR '",$$LOC,"'.  PLEASE ENTER THEM, NOW." D PARMADD S BMCPARM=$G(^BMCPARM(DUZ(2),0))
 Q:BMCPARM=""
 D BMCFYRY ; set current fiscal year and referral year
 I BMCRY="" W !!,*7,"RCIS SITE PARAMETER file REFERRAL YEAR field missing or invalid.",! H 2 Q
 I BMCRY'=BMCFY W !!,*7,"RCIS SITE PARAMETER file REFERRAL YEAR does not match current FISCAL YEAR",!,"IGNORE If Operating on Calendar Year Basis..",! H 2
 I $P(BMCPARM,U,7)'?1.6N W !!,*7,"RCIS SITE PARAMETER file REFERRAL # field missing or invalid.",! Q
 D PARMSET
 S BMCQ=0
 Q
 ;----------
PARMSET ;EP - SET SYSTEM WIDE VARIABLES FROM SITE PARAMETER FILE
 ; Variables set here need to be kill in ^BMCSKILL
 S:$G(BMCPARM)="" BMCPARM=$G(^BMCPARM(DUZ(2),0))
 I $P(BMCPARM,U,25)="U" S AUPNLK("ALL")="" ;UNIVERSAL/SITE LOOKUP
 S BMCPCC=$P(BMCPARM,U,3) ;           pcc interface
 S BMCCHS=$P(BMCPARM,U,4) ;           chs interface
 S BMCDXPR=$P(BMCPARM,U,8) ;          icd/cpt coding
 S BMCDXCPT=$P(BMCPARM,U,27) ;        stuff DX & CPT Codes
 S BMCLCAT=$P(BMCPARM,U,9) ;          local category
 S BMCOLOC=$P(BMCPARM,U,11) ;         other location
 S BMCMGCR=$P($G(BMCPARM),U,26) ;      Mged Care Committee
 S BMCDMGR=""
 S Y=$P(BMCPARM,U,12) S:Y BMCDMGR=$P($G(^VA(200,Y,0)),U) ;dflt case mgr
 S BMCCHSS=$P(BMCPARM,U,13) ;         chs supervisor
 S BMCBOS=$P(BMCPARM,U,14) ;          business office supervisor
 S BMCCHSA=$P(BMCPARM,U,15) ;         chs alert wanted
 S BMCIHSA=$P(BMCPARM,U,21) ;         ihs alert wanted
 S BMCOTHRA=$P(BMCPARM,U,22) ;          other alert wanted
 S BMCHOUSA=$P(BMCPARM,U,23) ;          inhouse alert waned
 S BMCPRIO=$P(BMCPARM,U,16)
 ; set taxonomy ien's
 S BMCTXPHC=$O(^ATXAX("B","BMC POTENTIAL HIGH COST DX",0))
 S BMCTXCCP=$O(^ATXAX("B","BMC COSMETIC CPT PROCEDURES",0))
 S BMCTXCEX=$O(^ATXAX("B","BMC EXPERIMENTAL CPT PROC",0))
 S BMCTXCHC=$O(^ATXAX("B","BMC HIGH COST PROCEDURES",0))
 S BMCTXL3P=$O(^ATXAX("B","BMC 3RD PARTY LIABILITY ALERT",0))
 ; set referral year and fiscal year
 D BMCFYRY
 Q
 ;----------
BMCFYRY ; calculate current fiscal year and referral year 
 S BMCGFY=$P($$FISCAL^XBDT(DT,10),U)
 S BMCFY=$E(BMCGFY,3,4)
 S BMCRY=$P(BMCPARM,U,2)
 Q
 ;----------
PARMADD ; ADD SITE PARAMETER ENTRY
 S DLAYGO=90001.31,DIC(0)="AEMNQL",DIC="^BMCPARM("
 D DIC^BMCFMC
 Q:+Y<1
 S DA=+Y,DIE="^BMCPARM(",DR=".01:999"
 D DIE^BMCFMC
 Q
 ;----------
GETR() ;EP - Return referral # from RCIS REFERRAL record
 I '$G(BMCRIEN) Q ""
 Q $P($G(^BMCREF(BMCRIEN,0)),U,2)
 ;----------
REFN() ;EP - Return the next referral number and update control file
 LOCK +^BMCPARM(DUZ(2)):20 E  W:'$D(ZTQUEUED) *7,!!,"  Unable to lock the RCIS SITE PARAMETER entry for ",$$LOC,".",!! D EOP Q 0
 S BMCPARM=$G(^BMCPARM(DUZ(2),0))
 S X=$$ASF
 S X=X_$P(BMCPARM,U,2)
 S Y=$P(BMCPARM,U,7)+1
 S X=X_$$LZERO(Y,5)
 S BMCX=X
 S DIE="^BMCPARM(",DA=DUZ(2),DR=".07////"_Y D DIE^BMCFMC
 LOCK -^BMCPARM(DUZ(2)):20
 Q BMCX
 ;----------
REFNFY() ;EP - Get Referral Number for Desired Fiscal Year
 S X=$$ASF
 ;
 S X=X_BMCFY_$$LZERO(BMCRNUM,5)
 S BMCX=X
 Q BMCX
 ;
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
 D DIC^BMCFMC
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
 S:X="Referred Care Information System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 W @IOF,!,$$CTR("REFERRED CARE INFORMATION SYSTEM"),!,$$CTR($$LOC()),!,$$CTR(X),!!
 Q
 ;----------
LOCK(DA) ;EP - Lock the selected referral.
 LOCK +^BMCREF(DA):20
 E  W:'$D(ZTQUEUED) *7,!!,"  This Document Is Currently Being Processed (Document LOCKED).",!! D EOP I 0
 Q
 ;----------
UNLOCK(DA)         ;EP - Unlock the selected referral.
 LOCK -^BMCREF(DA):20
 E  W:'$D(ZTQUEUED) *7,!!,"  UNABLE TO UNLOCK REFERRAL.  NOTIFY PROGRAMMER.",!! D EOP I 0
 Q
 ;----------
LOGO ;EP - Print logo of main menu.
 NEW A,D,I,L,N,R,V,P,P1     ;BMC*4.0*6 2.16.2010 IHS.OIT.FCJ ADDED P AND P1
 S L=18,R=61,D=R-L+1,N=R-L-1
 S I=$O(^DIC(9.4,"C","BMC",0)),V=^DIC(9.4,I,"VERSION"),A=$O(^DIC(9.4,I,22,"B",V,0)),Y=$$FMTE^XLFDT($P(^DIC(9.4,I,22,A,0),U,2))
 S P=0 F  S P=$O(^DIC(9.4,I,22,A,"PAH","B",P)) Q:P'?1.N.N  S P1=P     ;BMC*4.0*6 2.16.2010 IHS.OIT.FCJ ADDED LINE
 ;BMC*4.0*6 2.16.2010 IHS.OIT.FCJ SPLIT NEXT LINE REMOVED DATE PRINT AND ADDED PATCH
 ;W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!?L,"*",$$CTR("INDIAN HEALTH SERVICE",N),?R,"*",!?L,"*",$$CTR("REFERRED CARE INFORMATION SYSTEM",N),?R,"*",!?L,"*",$$CTR("VERSION "_V_", "_Y,N),?R,"*",!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W @IOF,!,$$CTR($$REPEAT^XLFSTR("*",D)),!?L,"*",$$CTR("INDIAN HEALTH SERVICE",N),?R,"*",!?L,"*",$$CTR("REFERRED CARE INFORMATION SYSTEM",N),?R,"*"
 W !?L,"*",$$CTR("VERSION "_V_", Patch "_P1,N),?R,"*",!,$$CTR($$REPEAT^XLFSTR("*",D)),!
 W $$CTR($$LOC())
 ;Sub Menu Displays
 Q:$G(XQY0)=""
 I '$D(IORVON) S X="IORVON;IORVOFF" D ENDR^%ZISS
 S X=$P(XQY0,U,2)
 S:X="Referred Care Information System" X="MAIN MENU"
 S X=$J("",2*$L(IORVON)-1)_IORVON_X_IORVOFF
 W !,$$CTR(X),!
 Q
 ;----------
SEL(S) ;EP - Select a referral to edit, S is DIC("S")
 NEW BMC,BMCY,DA,DIC
 S:$D(S) DIC("S")=S
 S DIC="^BMCREF(",Y=$$DIC(.DIC)
 I Y<1 Q Y
 S DA=+Y D LOCK(DA) E  Q 0
 S BMC=DA
 I '$D(ZTQUEUED) D
 .S DIC="^BMCREF(" D DIQ^BMCFMC
 .S DA=$O(^BMCCOM("AD",BMC,0)) I DA S DIC="^BMCCOM(" D DIQ^BMCFMC
 .F BMCY=0:0 S BMCY=$O(^BMCDX("AD",BMC,BMCY)) Q:'BMCY  S DA=BMCY,DIC="^BMCDX(" D DIQ^BMCFMC
 .F BMCY=0:0 S BMCY=$O(^BMCPX("AD",BMC,BMCY)) Q:'BMCY  S DA=BMCY,DIC="^BMCPX(" D DIQ^BMCFMC
 .D EOP
 Q BMC
 ;----------
DEV ; EP - SELECT OUTPUT DEVICE
 S BMCQ=0
 S %ZIS="PQ" D ^%ZIS
 S:POP BMCQ=1
 Q
 ;----------
PAUSE ; EP - PAUSE FOR USER
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT["TRM")!$D(IO("S"))
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
 ; R = RCIS REFERRAL IEN
 NEW X,Y
 S Y=""
 G:'$G(R) TOFACX
 G:'$D(^BMCREF(R,0)) TOFACX
 S X=^BMCREF(R,0)
 S Y=$P(X,U,8) I Y S Y=$P(^DIC(4,Y,0),U) G TOFACX
 S Y=$P(X,U,7) I Y S Y=$P(^AUTTVNDR(Y,0),U)
 I Y="OTHER PROVIDER (NON-CHS)" S Y=$P(X,U,9) I Y S Y=$P(^BMCLPRV(Y,0),U)
TOFACX ;
 Q Y
 ;
 ;BMC*4.0*5 IHS.OIT.FCJ ADDED READ SECTION ORIGINAL FROM ACHSFU
READ ;EP
 K DTOUT,DUOUT,BMCQUIT
 N BMCDOIT
 S BMCDOIT="R"_" Y:"_DTIME
 X BMCDOIT
 I '$T S (DTOUT,Y)=""
 S:Y="/.," DTOUT=""
 S:Y="^" (DUOUT,Y)=""
 I $D(DTOUT)!$D(DUOUT) S BMCQUIT=1
 Q
 ;
 ;BMC*4.0*5 IHS.OIT.FCJ ADDED YN MODULE
YN ;EP
 W !!,"Enter a ""Y"" for YES or an ""N"" for NO."
 Q
 ;
ZEROTH(A,B,C,D,E,F,G,H,I,J,K) ;EP - Return 0th node.  A is file #, rest fields.
 N Z
 I '$G(A) Q -1
 I '$G(B) Q -1
 F Z=67:1:75 Q:'$G(@($C(Z)))  S A=+$P($G(^DD(A,B,0)),U,2),B=@($C(Z))
 I 'A!('B) Q -1
 I '$D(^DD(A,B,0)) Q -1
 Q U_$P($G(^DD(A,B,0)),U,2)
