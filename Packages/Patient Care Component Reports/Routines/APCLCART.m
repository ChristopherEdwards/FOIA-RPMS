APCLCART ; IHS/CMI/LAB - SET UP TAX CALIF ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
 ;
POST ;EP
 F APCLN=60:1:70,74,80:1:90,94 S APCLTEXT="L"_APCLN D SETTAX
 Q
PCPT ;EP - called from apclcarp
 D HEADER
 Q:APCLQUIT
 S APCLV=0 F  S APCLV=$O(^XTMP("APCLCAR",APCLJ,APCLH,"NO CPT LIST",APCLV)) Q:APCLV'=+APCLV!(APCLQUIT)  D
 .I $Y>(IOSL-3) D HEADER Q:APCLQUIT
 .S P=$P(^AUPNVSIT(APCLV,0),U,5)
 .I P W !,$P(^DPT(P,0),U),?32,$$HRN^AUPNPAT(P,DUZ(2))
 .W ?39,$$VAL^XBDIQ1(9000010,APCLV,.01),?60,$E($$VAL^XBDIQ1(9000010,APCLV,.06),1,18)
 .Q
 Q
HEADER ;EP
 G:'APCLPG HEADER1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT=1 Q
HEADER1 ;
 W:$D(IOF) @IOF S APCLPG=APCLPG+1
 W !?3,$P(^VA(200,DUZ,0),U,2),?35,$$FMTE^XLFDT(DT),?70,"Page ",APCLPG,!
 W !,$$CTR("***  CALIFORNIA ANNUAL UTILIZATION REPORT OF PRIMARY CARE CLINICS  ***",80),!
 W !,$$CTR("*** 2008 VERSION ***",80),!
 ;W $$CTR($P(^DIC(4,DUZ(2),0),U)),!
 I '$D(APCLLOCT) S X="ALL LOCATIONS OF ENCOUNTER SELECTED" W $$CTR(X,80),!
 I $D(APCLLOCT) D
 .S X="Locations Selected:"
 .S Y=0 F  S Y=$O(APCLLOCT(Y)) Q:Y'=+Y  S X=X_"  "_$P(^DIC(4,Y,0),U)
 .W X,!
 S X="Reporting Period: "_$$FMTE^XLFDT(APCLBD)_" to "_$$FMTE^XLFDT(APCLED) W $$CTR(X,80),!
 S X="List of Visits with NO CPT code" W $$CTR(X,80),!
 W !,"Patient Name",?32,"HRN",?39,"Visit Date",?60,"Location"
 W !,$TR($J("",80)," ","-")
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
SETTAX ;
 S ATXFLG=1
 S APCLT=$T(@APCLTEXT),APCLTN=$P(APCLT,";;",2),APCLTN="APCL CAR "_APCLTEXT
 ;W !,"Creating Primary Care Prov disc taxonomy...",APCLTN
 S APCLDA=0 S APCLDA=$O(^ATXAX("B",APCLTN,APCLDA)) I APCLDA K ^ATXAX(APCLDA,21) S APCLTX=APCLDA G SETTAX1
 S X=APCLTN,DIC="^ATXAX(",DIC(0)="L",DIADD=1,DLAYGO=9002226 D ^DIC K DIC,DA,DIADD,DLAYGO,I
 I Y=-1 W !!,"ERROR IN CREATING APCL PRIMARY PROVIDER DISC" Q
 S APCLTX=+Y
SETTAX1 ;
 S $P(^ATXAX(APCLTX,0),U,2)=APCLTN,$P(^(0),U,5)=DUZ,$P(^(0),U,8)=0,$P(^(0),U,9)=DT,$P(^(0),U,12)=210,$P(^(0),U,13)=0,$P(^(0),U,15)=7,^ATXAX(APCLTX,21,0)="^9002226.02101A^0^0"
 D ^XBFMK K DIADD,DLAYGO S APCLC=0 F APCLX=1:1 S X=$P($T(@APCLTEXT+APCLX),";;",2) Q:X=""  S Y=0 F  S Y=$O(^DIC(7,"D",X,Y)) Q:Y'=+Y  K DIC,DA,DR,DIADD,DLAYGO,DQ,DI,D1,D0 D
 .S APCLC=APCLC+1 S ^ATXAX(APCLTX,21,APCLC,0)=+Y,$P(^ATXAX(APCLTX,21,0),U,3)=APCLC,$P(^(0),U,4)=APCLC,^ATXAX(APCLTX,21,"AA",+Y,APCLC)=""
 .Q
 S DA=APCLTX,DIK="^ATXAX(" D IX1^DIK
 K ATXFLG
 Q
 ;
L94 ;;OTHER 2
 ;;C3
 ;;C4
 ;;C5
 ;;C6
 ;;C7
 ;;C2
 ;;C1
 ;;B8
 ;;A8
 ;;A6
 ;;A3
 ;;A2
 ;;95
 ;;94
 ;;91
 ;;89
 ;;87
 ;;84
 ;;67
 ;;66
 ;;65
 ;;59
 ;;53
 ;;47
 ;;43
 ;;42
 ;;39
 ;;38
 ;;36
 ;;31
 ;;30
 ;;27
 ;;23
 ;;22
 ;;20
 ;;19
 ;;14
 ;;09
 ;;06
 ;;02
 ;;
L90 ;;
 ;;
L89 ;;
 ;;
L88 ;;
 ;;48
 ;;
L87 ;;
 ;;99
 ;;97
 ;;93
 ;;37
 ;;35
 ;;34
 ;;29
 ;;26
 ;;07
 ;;04
 ;;
L86 ;;
 ;;03
 ;;
L85 ;;
 ;;05
 ;;
L84 ;;
 ;;32
 ;;01
 ;;13
 ;;
L83 ;;
 ;;A7
 ;;96
 ;;
L82 ;;
 ;;
L81 ;;
 ;;60
 ;;54
 ;;
L80 ;;
 ;;46
 ;;
L74 ;;
 ;;
L70 ;;
 ;;A5
 ;;90
 ;;83
 ;;82
 ;;76
 ;;73
 ;;69
 ;;28
 ;;24
 ;;10
 ;;08
 ;;
L69 ;;
 ;;63
 ;;62
 ;;
L68 ;;
 ;;92
 ;;50
 ;;12
 ;;
L67 ;;
 ;;81
 ;;49
 ;;
L66 ;;
 ;;
L65 ;;
 ;;52
 ;;
L64 ;;
 ;;
L63 ;;
 ;;17
 ;;
L62 ;;
 ;;21
 ;;16
 ;;
L61 ;;
 ;;11
 ;;
L60 ;;
 ;;B6
 ;;B5
 ;;B4
 ;;B3
 ;;B2
 ;;B1
 ;;A9
 ;;A4
 ;;A1
 ;;86
 ;;85
 ;;80
 ;;79
 ;;78
 ;;77
 ;;75
 ;;74
 ;;72
 ;;71
 ;;70
 ;;68
 ;;64
 ;;45
 ;;44
 ;;41
 ;;33
 ;;25
 ;;18
 ;;00
 ;;
