APCDPOST ; IHS/CMI/TUCSON - POST INIT ;
 ;;2.0;IHS RPMS/PCC Data Entry;;MAR 09, 1999
TABLE ;
 D INFORM
 D ^APCDONIT
 D ^APCDL
 S XBPKNSP="APCM" D ^XBPKDEL
 ;delete package entry APCM
 S DA=$O(^DIC(9.4,"C","APCM",0)) I DA S DIK="^DIC(9.4," D ^DIK
HF ;
 W !,"Adding Health Factor entries",!
 S X="CESSATION-SMOKELESS",DIC="^AUTTHF(",DIC(0)="L",DLAYGO=9999999.64,DIC("DR")=".1///FACTOR;.03///TOBACCO" D ^DIC K DIC,DD,DLAYGO,DA,D0
 S X="CESSATION-SMOKER",DIC="^AUTTHF(",DIC(0)="L",DLAYGO=9999999.64,DIC("DR")=".1///FACTOR;.03///TOBACCO" D ^DIC K DIC,DD,DLAYGO,DA,D0
SITE ;
 W !!,$C(7),$C(7),"There are several new DATA ENTRY SITE PARAMETERS that need to be set-up.",!,"For each facility (DUZ(2)) for which you log in to do Data Entry PLEASE",!,"UPDATE THE SITE PARAMETER FILE!!!!"
 Q
 ;
INFORM ;
 W:$D(IOF) @IOF W !!,"Welcome to the PCC Data Entry Post init."
 W !!,"This post init will do the following:"
 W !?5,"- Delete the old package called APCM"
 W !?5,"- add a few new Health Factors"
 W !?5,"- install protocols"
 W !?5,"- install List Templates"
 W !?5,"- inform you if you need to run a DG5 init (IF YOU ARE RUNNING MAS 5.0)"
 Q
