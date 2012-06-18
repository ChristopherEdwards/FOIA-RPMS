APCHPOST ; IHS/TUCSON/LAB - post-init routine ;  [ 06/24/97  2:42 PM ]
 ;;2.0;IHS RPMS/PCC Health Summary;;JUN 24, 1997
 ;
START ;start of routine
 W !?25,"* * * * * * * * * * * * *",!!
 W !!,"HEALTH SUMMARY POST-INIT"
 ; Loads taxonomy:  SURVEILLANCE PHYSICAL EXAM
 D ^APCHTX
 D ^XBFMK
 S APCHX=$O(^ATXAX("B","SURVEILLANCE PNEUMOCOCCAL RISK",0))
 S ATXX=APCHX D ZTM^ATXAX ;update these codes in icd9 file
 S ATXX=APCHX
 I '$D(^ATXPAT(ATXX,0)) S DIADD="",DIC="^ATXPAT(",DIC(0)="L",X="`"_ATXX,DIC("DR")=".02////"_DT_";.03////"_DUZ D ^DIC K DIADD,DIC,DR S ^ATXPAT(ATXX,11,0)="^9002227.01101PA^0^0"
 D TSKMN^ATXENP ;enter patients into patient taxonomy
 I '$D(^APCHTMP) W !!,$C(7),$C(7),"TMP global not restored!!" Q
MEASPAN ;install measurement panels
 S DIK="^AUTTMSR(",DIK(1)=".03^C" D ENALL^DIK ;reindex C on measurement type file
 I '$D(^APCHTMP) W !!,"Health Summary global APCHTMP not loaded!!!" D XIT Q
 W !,"Installing Measurement Panels"
 S APCHFG=0 F  S APCHFG=$O(^APCHTMP("MEASPAN",APCHFG)) Q:APCHFG'=+APCHFG  D
 .S DIFGLO="^APCHTMP(""MEASPAN"",APCHFG,"
 .S APCHN=$P(^APCHTMP("MEASPAN",APCHFG,2,0),"=",2)
 .W !,APCHN
 .S APCHDA=$O(^APCHSMPN("B",APCHN,0))
 .I APCHDA S DA=APCHDA,DIK="^APCHSMPN(" D ^DIK ;delete entry
 .K DA,DIK
 .S DIADD=1
 .I APCHDA S DINUM=APCHDA
 .D ^DIFG W "."
 .I $D(DIFGER) W "    *** FAILED INSTALL ***   ",DIFGER D DIFGX Q
 .S APCHDA=+DIFGY
 .S APCHY=$S(APCHN="ADULT STD":"AS",APCHN="ADULT STD METRIC":"ASM",APCHN="PEDIATRIC STD":"PS",APCHN="PEDIATRIC STD METRIC":"PSM",1:"")
 .Q:APCHY=""
 .F APCHJ=1:1 S APCHX=$T(@APCHY+APCHJ),APCHIEN=$P(APCHX,";;",2) Q:APCHIEN="QUIT"!(APCHIEN="")  D
 ..S APCHVAL=$P(APCHX,";;",3),^APCHSMPN(APCHDA,1,APCHIEN,1)=APCHVAL
 .D DIFGX
 .Q
HSTYPE ;
 W !,"Installing Health Summary Types"
 S APCHFG=0 F  S APCHFG=$O(^APCHTMP("TYPE",APCHFG)) Q:APCHFG'=+APCHFG  D
 .S DIFGLO="^APCHTMP(""TYPE"",APCHFG,"
 .S APCHN=$P(^APCHTMP("TYPE",APCHFG,2,0),"=",2)
 .W !,APCHN
 .S APCHDA=$O(^APCHSCTL("B",APCHN,0))
 .I APCHDA S DA=APCHDA,DIK="^APCHSCTL(" D ^DIK ;delete entry
 .K DA,DIK
 .S DIADD=1
 .I APCHDA S DINUM=APCHDA
 .D ^DIFG W "."
 .I $D(DIFGER) W "    *** FAILED INSTALL ***   ",DIFGER D DIFGX Q
 .D DIFGX
 .Q
 D XIT
 Q
DIFGX ;
 K APCHDA,APCHN,APCHJ,APCHY,APCHVAL,APCHIEN,APCHX
 K DIFG,DIFGER,DIC,DA,DIADD,DLAYGO,DIFGY,DINUM
 Q
XIT ;end of routine
 K ^APCHTMP ;unsubscripted temporary global to be used in install only
 D DIFGX
 W !!!!,"PCC Health Summary v2.0 has been successfully completed!!",!
 K APCHY,APCHX,APCHC,APCHFG,APCHTDFN
 Q
 ;=====================================================================
 ;
 ;
AS ;ADULT STD
 ;;20;;D BMI^APCHS2A1
 ;;25;;D RW^APCHS2A1
 ;;30;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;35;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;QUIT
PS ;PEDIATRIC STD
 ;;7;;D HTPER^APCHS2A1
 ;;12;;D WTPER^APCHS2A1
 ;;25;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;30;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;QUIT
ASM ;ADULT STD METRIC
 ;;5;;S X=X*2.54
 ;;10;;S X=X/2.2
 ;;20;;D BMI^APCHS2A1
 ;;25;;D RW^APCHS2A1
 ;;30;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;35;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;QUIT
PSM ;PEDIATRIC STD METRIC
 ;;5;;S X=X*2.54
 ;;7;;D HTPER^APCHS2A1
 ;;10;;S X=X/2.2
 ;;12;;D WTPER^APCHS2A1
 ;;20;;S X=X*2.54
 ;;25;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
 ;;30;;S X=$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",1)_"-"_$S($G(APCHSVNM):APCHSVNM,1:20)_"/"_$P(X,"/",2)
