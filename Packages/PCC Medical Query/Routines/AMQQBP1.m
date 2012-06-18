AMQQBP1 ; IHS/CMI/THL - PATCH 1 FOR BETA TEST VERSION 1.32 OF Q-MAN ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;-----
 N X,Y,Z,DA
 S U="^"
 W !,"Now changing ""AQTOO"" x-ref on the .01 field of the V IMMUNIZATION file."
 S ^DD(9000010.11,.01,1,4,1)="N % S %=$P(^AUPNVIMM(DA,0),U,4) I $P($G(^AUTTSITE(1,0)),U,19)=""Y"" S ^AUPNVIMM(""AQ"",(X_"";""_%),DA)="""""
 S ^DD(9000010.11,.01,1,4,2)="N % S %=$P(^AUPNVIMM(DA,0),U,4) I $P($G(^AUTTSITE(1,0)),U,19)=""Y"" K ^AUPNVIMM(""AQ"",(X_"";""_%),DA)"
 ;
RECOMP ;RECOMPILE APCD INPUT TEMPLATES
 W !!,"Now Some Data Entry Input Templates will be re-compiled because of several"
 W !,"dictionary changes.  Hold On..."
 ;
 F AUPNTEMP=1:1 S AUPNX="T"_AUPNTEMP Q:$T(@AUPNX)=""  D RECOMP1
 W !,"All done with re-compiling",!
 W !,*7,"Please D MAILTASK^AMQQMGR1 at this time or when most convenient."
 W !,"This task is the same as when you first created the ""AQ"" x-refs on your"
 W !,"system and will take 1-72 to run in background."
 Q
RECOMP1 ;
 S DIC="^DIE("
 S DIC(0)=""
 S X=$P($T(@AUPNX),";;",2)
 D ^DIC
 I Y=-1 W !!,"WHOOPS ... COULDN'T FIND INPUT TEMPLATE ",X Q
 Q:'$D(^DIE(+Y,"ROU"))
 Q:$P(^DIE(+Y,"ROU"),U,2)=""
 S DMAX=4000
 S Y=+Y
 S X=$P(^DIE(Y,"ROU"),U,2)
 D EN^DIEZ
 Q
T1 ;;APCD EX (ADD);;APCDT10
T2 ;;APCD HBS (ADD);;APCDT14
T3 ;;APCD HEX (ADD);;APCDT18
T4 ;;APCD HHCT (ADD);;APCDT15
T5 ;;APCD HIM (ADD);;APCDT19
T6 ;;APCD HPAP (ADD);;APCDT16
T7 ;;APCD HS (ADD);;APCDT20
T8 ;;APCD HUA (ADD);;APCDT17
T9 ;;APCD IM (ADD);;APCDT21
T10 ;;APCD LAB (ADD);;APCDT56
T11 ;;APCD LAB TEST (ADD);;APCDT26
T12 ;;APCD LABLOG (ADD);;APCDT27
T13 ;;APCD LABTEST (ADD);;APCDT28
T14 ;;APCD MEASUREMENT (ADD);;APCDT29
T15 ;;APCD METRIC MEASUREMENT (ADD);;APCDT30
T16 ;;APCD ST (ADD);;APCDT48
T17 ;;APCD VISIT (ADD);;APCDT52
T18 ;;APCD VISIT LOOKUP;;APCDT53
T19 ;;APCDALVR 9000010 (MOD);;APCDA01
T20 ;;APCDALVR 9000010.01 (ADD);;APCDA02
T21 ;;APCDALVR 9000010.09 (ADD);;
T22 ;;APCDALVR 9000010.09 (MOD);;
T23 ;;APCDALVR 9000010.11 (ADD);;
