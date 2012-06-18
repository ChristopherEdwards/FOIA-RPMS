APCLVL03 ; IHS/CMI/LAB - SCREEN LOGIC ; 
 ;;2.0;IHS PCC SUITE;**2,4,7**;MAY 14, 2009
 ;
MEAS ;EP - measurements and values
 ;get measurement type and value range and store as T_U_RANGE
 W !,"With this selection item you will be prompted to enter which measurement types"
 W !,"you want included in the VGEN search.  When you select a measurement type you"
 W !,"will be asked to include all values of the measurement or to just include"
 W !,"a user specified range of values.",!
GETMEAS ;
 K APCLMSR
GETMEAS1 ;
 W !
 K DIC S DIC="^AUTTMSR(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y=-1,'$D(APCLMSR) W !,"no measurements selected." D PAUSE^APCLVL01 Q
 I Y=-1 D SETRPT Q
 S APCLMT=+Y,APCLMSR(APCLMT)="",APCLMTT=$P(^AUTTMSR(APCLMT,0),U)
 ;now get value
 S DIR(0)="S^A:ANY/ALL "_APCLMTT_" Values;S:Selected Range of "_APCLMTT_" Values",DIR("A")="Include which "_APCLMTT_" Values" KILL DA
 S DIR("B")="A" D ^DIR KILL DIR
 I $D(DIRUT) S APCLMSR(APCLMT)="" W !,"skipping measurement ",APCLMTT K APCLMSR(APCLMT) G GETMEAS1
 I Y="A" G GETMEAS1
MVAL ;GET VALUE RANGE
 S DIR(0)="F^1:999",DIR("A")="Enter the value range for "_APCLMTT
 S APCLMTVG=$O(^APCLVGMS("B",APCLMT,0))
 I 'APCLMTVG W !,"value range search not available for that measurement, all values will be included." G GETMEAS1
 S DIR("?")="Enter the value range for "_APCLMTT
 S X=0,C=0 F  S X=$O(^APCLVGMS(APCLMTVG,1,X)) Q:X'=+X  S C=C+1,DIR("?",C)=^APCLVGMS(APCLMTVG,1,X,0)
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) K APCLMSR(APCLMT) G GETMEAS1
 S (X,APCLVR)=Y X ^APCLVGMS(APCLMTVG,2)
 I '$D(X) W !,"Invalid range for ",APCLMTT D  G MVAL
 .S X=0,C=0 F  S X=$O(^APCLVGMS(APCLMTVG,1,X)) Q:X'=+X  W !,^APCLVGMS(APCLMTVG,1,X,0)
 S APCLMSR(APCLMT)=APCLVR
 G GETMEAS1
 ;
SETRPT ;
 S (X,Y)=0 F  S X=$O(APCLMSR(X)) Q:X'=+X  D
 .S Y=Y+1
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"^"_APCLMSR(X)
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X,Y)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y
 Q
HESCR ;
 I V=R S D=1 Q
 Q
EDIP ;
 NEW A,M,B,H,S
 S H=X,S=""
 S A=$$STRIP^XLFSTR(X," ")
 F B=1:1 S C=$P(A,",",B) Q:C=""  D
 .S X=C X ^AUTTMSR($P(^APCLVGMS(APCLMTVG,0),U),12) I '$D(X) S S=1
 I S K X Q
 S APCLVR=A
 Q
NUMIP ;
 NEW A,M
 S M=$P(^APCLVGMS(APCLMTVG,0),U)
 S A=X
 S X=$P(A,"-",1) X ^AUTTMSR(M,12) I '$D(X) Q
 S X=$P(A,"-",2) X ^AUTTMSR(M,12) I '$D(X) Q
 S X=A
 Q
MSRSCR ;
 NEW A,B,C,D,R,F,S,E,G
 S Y=0 F  S Y=$O(^AUPNVMSR("AD",APCLVIEN,Y)) Q:Y'=+Y!(X=1)  I '$P($G(^AUPNVMSR(Y,2)),U,1) S A=$P(^AUPNVMSR(Y,0),U,1) I $D(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A)) D
 .;check value if need be
 .S B=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A,0))
 .S R=$P(^APCLVRPT(APCLRPT,11,APCLI,11,B,0),U,2)
 .I R="" S X=1,X(1)="" Q
 .S V=$P(^AUPNVMSR(Y,0),U,4)
 .S C=$P(^AUTTMSR(A,0),U)
 .S E=$O(^APCLVGMS("B",A,0))
 .S G=$P(^APCLVGMS(E,0),U,2)
 .K D
 .I G D NUMSCR I 1
 .E  D @(C_"SCR")
 .Q:'$D(D)
 .S X=1,X(1)=""
 .Q
 Q
NUMSCR ;
 S F=$P(R,"-"),S=$P(R,"-",2)
 I +V<F Q
 I +V>S Q
 S D=1
 Q
EDSCR ;
 NEW A,B
 F A=1:1 S B=$P(V,",",A) Q:B=""  I V=B S D=1
 Q
BPIP ;
 NEW A,M,S,D
 I X'["," K X Q
 S A=$P(X,",")
 I A]"",A'?1.3N1"-"1.3N K X Q
 S A=$P(X,",",2)
 I A]"",A'?1.3N1"-"1.3N K X Q
 S M=$P(^APCLVGMS(APCLMTVG,0),U)
 S A=X
 S S=$P(A,",",1) I S]"" D  Q:'$D(X)
 .S X=$P(S,"-",1) I X<20!(X>275) K X Q
 .S X=$P(S,"-",2) I X<20!(X>275) K X Q
 S D=$P(A,",",2) I D]"" D  Q:'$D(X)
 .S X=$P(D,"-",1) I X<20!(X>200) K X Q
 .S X=$P(D,"-",2) I X<20!(X>200) K X Q
 S X=A
 Q
BPSCR ;
 NEW S,E,A,B,F,Z
 S E=0,F=0
 S S=$P(R,",",1) I S]"" D
 .S A=$P(S,"-",1) I $P(V,"/",1)<A Q
 .S A=$P(S,"-",2) I $P(V,"/",1)>A Q
 .S E=1
 I S]"",'E Q
 S E=1
 S Z=$P(R,",",2) I Z]"" D
 .S B=$P(Z,"-",1) I $P(V,"/",2)<B Q
 .S B=$P(Z,"-",2) I $P(V,"/",2)>B Q
 .S F=1
 I Z]"",'F Q
 I E,F S D=1 Q
 Q
PRIP ;
 NEW A,M,S,D
 S A=$$STRIP^XLFSTR(X," ")
 F S=1:1 S D=$P(A,",",S) Q:D=""  D
 .I D=1 Q
 .I D=2 Q
 .I D=3 Q
 .I D=4 Q
 .I D=5 Q
 .I D=6 Q
 .I D=7 Q
 .I D=8 Q
 .I D=9 Q
 .I D="U" Q
 .K X
 S APCLVR=A
 Q
PRSCR ;
 NEW A,B
 F A=1:1 S B=$P(V,",",A) Q:B=""  I V=B S D=1
 Q
OTHSPEC ;EP - other speciaty providers
 ;get provider type and list of providers
 W !,"With this selection item you will be prompted to enter which specialty "
 W !,"provider type you want included in the search.  When you select a provider "
 W !,"type you will be asked to include all providers in that category or to "
 W !,"just include certain providers.",!
GETTYPE ;
 NEW APCLPROV,APCLPRVN,APCLPRVD
 K APCLMSR
GETTYPE1 ;
 W !
 K DIC S DIC="^BDPTCAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y=-1,'$D(APCLMSR) W !,"no provider types selected." D PAUSE^APCLVL01 Q
 I Y=-1 D SETRPT Q
 S APCLMT=+Y,APCLMSR(APCLMT)="",APCLMTT=$P(^BDPTCAT(APCLMT,0),U)
 ;now get value
 S DIR(0)="S^A:ANY/ALL "_APCLMTT_" Providers;S:Selected Set of "_APCLMTT_" Providers",DIR("A")="Include which "_APCLMTT_" Providers" KILL DA
 S DIR("B")="A" D ^DIR KILL DIR
 I $D(DIRUT) S APCLMSR(APCLMT)="" W !,"skipping provider type ",APCLMTT K APCLMSR(APCLMT) G GETTYPE1
 I Y="A" G GETTYPE1
PROV ;GET VALUE RANGE
 K APCLPROV,APCLPRVN,APCLPRVD
 S X="PRIMARY CARE PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G GETTYPE1
 D PEP^AMQQGTX0(+Y,"APCLPROV(")
 I '$D(APCLPROV) W !,"no providers selected, will search for all ",APCLMTT," providers." G GETTYPE1
 I $D(APCLPROV("*")) W !,"all ",APCLMTT," will be searched for" K APCLPROV G GETTYPE1
 S APCLVR=""
 S Y=0 F  S Y=$O(APCLPROV(Y)) Q:Y'=+Y  D
 .I APCLVR="" S APCLVR=Y Q
 .S APCLVR=APCLVR_","_Y
 S APCLMSR(APCLMT)=APCLVR
 G GETTYPE1
 ;
OTHSPECS ;EP
 NEW D,G
 ;S D=$S(APCLPTVS="P":DT,1:$P($P(APCLVREC,U),"."))
 K D
 D ALLDPVG^BDPAPI(DFN,,.D)
 I '$D(D) Q
 NEW A,B,C,R,E
 S G=0
 S A=0 F  S A=$O(D(A)) Q:A'=+A!(G=1)  I $D(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A)) D
 .S B=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A,0))
 .S R=$P(^APCLVRPT(APCLRPT,11,APCLI,11,B,0),U,2)
 .I R="" S G=1 Q  ;patient has a provider of this category
 .F E=1:1 S C=$P(R,",",E) Q:C=""!(G)  I $P(D(A),U,3)=C S G=1
 .Q
 I G S X=1,X(1)=""
 Q
OTHSPED ;EP - other speciaty providers
 ;get provider type and list of providers
 W !,"With this selection item you will be prompted to enter which specialty "
 W !,"provider type you want included in the search.  When you select a provider "
 W !,"type you will then be asked the date range to search for date last update.",!
GTD ;
 NEW APCLPROV,APCLPRVN,APCLPRVD
 K APCLMSR
GTD1 ;
 W !
 K DIC S DIC="^BDPTCAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y=-1,'$D(APCLMSR) W !,"no provider types selected." D PAUSE^APCLVL01 Q
 I Y=-1 D SETRPT Q
 S APCLMT=+Y,APCLMSR(APCLMT)="",APCLMTT=$P(^BDPTCAT(APCLMT,0),U)
 ;
DATE ;GET VALUE RANGE
BD ;
 W ! S DIR(0)="D^::EP",DIR("A")="Enter beginning Update Date for Search" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) W !,"No date selected.  Choose again." K APCLMSR(APCLMT) G GTD
 S APCLBDAT=Y
ED ;get ending date
 W ! S DIR(0)="D^"_APCLBDAT_"::EP",DIR("A")="Enter ending Update Date for Search" S Y=APCLBDAT D DD^%DT S DIR("B")=Y,Y="" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 I $D(DIRUT) G BD
 S APCLEDAT=Y
 S APCLMSR(APCLMT)=APCLBDAT_":"_APCLEDAT
 G GTD1
 ;
SETRPT1 ;
 S (X,Y)=0 F  S X=$O(APCLMSR(X)) Q:X'=+X  D
 .S Y=Y+1
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,0)=APCLCRIT,^APCLVRPT(APCLRPT,11,"B",APCLCRIT,APCLCRIT)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,Y,0)=X_"^"_APCLMSR(X)
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,"B",X,Y)=""
 .S ^APCLVRPT(APCLRPT,11,APCLCRIT,11,0)="^9001003.8110101A^"_Y_"^"_Y
 Q
OTHSPECD ;EP
 NEW D,G
 K D
 D ALLDPVG^BDPAPI(DFN,,.D)
 I '$D(D) Q
 NEW A,B,C,R,E,B,T
 S G=0
 S A=0 F  S A=$O(D(A)) Q:A'=+A!(G=1)  I $D(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A)) D
 .S B=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A,0))
 .S R=$P(^APCLVRPT(APCLRPT,11,APCLI,11,B,0),U,2)
 .I R="" S G=1 Q  ;patient has a provider of this category
 .S B=$P(R,":",1),E=$P(R,":",2)
 .S T=$P(D(A),U,5)
 .I B>T Q
 .I E<T Q
 .S G=1
 .Q
 I G S X=1,X(1)=""
 Q
OTHSPECU ;EP
 NEW D,G
 K D
 D ALLDPVG^BDPAPI(DFN,,.D)
 I '$D(D) Q
 NEW A,B,C,R,E
 S G=0
 S A=0 F  S A=$O(D(A)) Q:A'=+A!(G=1)  I $D(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A)) D
 .S B=$O(^APCLVRPT(APCLRPT,11,APCLI,11,"B",A,0))
 .S R=$P(^APCLVRPT(APCLRPT,11,APCLI,11,B,0),U,2)
 .I R="" S G=1 Q  ;patient has a provider of this category
 .F E=1:1 S C=$P(R,",",E) Q:C=""!(G)  I $P(D(A),U,6)=C S G=1
 .Q
 I G S X=1,X(1)=""
 Q
OTHSPEU ;EP - other speciaty providers
 ;get provider type and list of providers
 W !,"With this selection item you will be prompted to enter which specialty "
 W !,"provider type you want included in the search.  When you select a provider "
 W !,"type you will be asked to include all users who last updated that provider"
 W !,"or to include on a selected set of users",!
GTU ;
 NEW APCLPROV,APCLPRVN,APCLPRVD
 K APCLMSR
GTU1 ;
 W !
 K DIC S DIC="^BDPTCAT(",DIC(0)="AEMQ" D ^DIC K DIC,DA
 I Y=-1,'$D(APCLMSR) W !,"no provider types selected." D PAUSE^APCLVL01 Q
 I Y=-1 D SETRPT Q
 S APCLMT=+Y,APCLMSR(APCLMT)="",APCLMTT=$P(^BDPTCAT(APCLMT,0),U)
 ;now get value
 S DIR(0)="S^A:ANY/ALL "_APCLMTT_" Users who Updated the Provider;S:Selected Set of "_APCLMTT_" Users who Updated the Provider",DIR("A")="Include which Users who Updated "_APCHMTT KILL DA
 S DIR("B")="A" D ^DIR KILL DIR
 I $D(DIRUT) S APCLMSR(APCLMT)="" W !,"skipping provider type ",APCLMTT K APCLMSR(APCLMT) G GTU1
 I Y="A" G GTU1
PU ;GET VALUE RANGE
 K APCLPROV,APCLPRVN,APCLPRVD
 S X="PRIMARY CARE PROVIDER",DIC="^AMQQ(5,",DIC(0)="FM",DIC("S")="I $P(^(0),U,14)" D ^DIC K DIC,DA I Y=-1 W "OOPS - QMAN NOT CURRENT - QUITTING" G GTU1
 D PEP^AMQQGTX0(+Y,"APCLPROV(")
 I '$D(APCLPROV) W !,"no users selected, will search for all ",APCLMTT," users." G GTU1
 I $D(APCLPROV("*")) W !,"all ",APCLMTT," will be searched for" K APCLPROV G GTU1
 S APCLVR=""
 S Y=0 F  S Y=$O(APCLPROV(Y)) Q:Y'=+Y  D
 .I APCLVR="" S APCLVR=Y Q
 .S APCLVR=APCLVR_","_Y
 S APCLMSR(APCLMT)=APCLVR
 G GTU1
 ;
