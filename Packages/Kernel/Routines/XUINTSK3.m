XUINTSK3 ;SEA/RDS-TaskMan: Conversion, ^%ZIS, Part 2 ;6/24/91  10:16 ;
 ;;7.0;Kernel;;Jul 17, 1992
 ;
FILE146 ;FIRST--build file 14.6
 S ZTDINUM=0
 K DD,DO S DIC="^%ZIS(14.6,",DIC(0)="L" D DO^DIC1
 S ZT1="" F ZT=0:0 S ZT1=$O(@(ZTXMB_"(1,""AT"",ZT1)")),ZT2="" Q:ZT1=""  F ZT=0:0 S ZT2=$O(@(ZTXMB_"(1,""AT"",ZT1,ZT2)")),ZT3="" Q:ZT2=""  F ZT=0:0 S ZT3=$O(@(ZTXMB_"(1,""AT"",ZT1,ZT2,ZT3)")),ZT4="" Q:ZT3=""  D LOOP
 S ZT1=0 F ZT=0:0 S ZT1=$O(@(ZTXMB_"(1,1,4,ZT1)")),ZT2=0 Q:'ZT1  I $D(^(ZT1,0))#2 S ZTS=^(0),ZTV=$P(ZTS,U) I ZTV]"" F ZT=0:0 S ZT2=$O(@(ZTXMB_"(1,1,4,ZT1,""UCI"",ZT2)")) Q:'ZT2  I $D(^(ZT2,0))#2 S ZTU=$P(^(0),U) D CHECK
 S ZT1=0 F ZT=0:0 S ZT1=$O(^%ZIS(14.5,ZT1)) Q:'ZT1  S ZTS=^(ZT1,0) D ADD:$P(ZTS,U,6)="",MGR
 Q
 ;
LOOP ;FILE146--extend nested loop
 F ZT=0:0 S ZT4=$O(@(ZTXMB_"(1,""AT"",ZT1,ZT2,ZT3,ZT4)")) Q:ZT4=""  D FILL W "."
 Q
 ;
FILL ;LOOP--fill in new ^%ZIS table based on old ^XMB table
 S ZTF1=$O(^%ZIS(14.5,"B",ZT1,""))
 I ZTF1="" K DD,DO S DIC="^%ZIS(14.5,",DIC(0)="L",X=ZT1 D FILE^DICN K DD S DIE=DIC,DA=$P(Y,U),ZTF1=DA,DR=".01:7" D ^DIE S DIC="^%ZIS(14.6,",DIC(0)="L" K DD,DO D DO^DIC1 W !?5
 S ZTF2=$O(^%ZIS(14.5,"B",ZT3,""))
 I ZT3]"",ZTF2="" K DD,DO S DIC="^%ZIS(14.5,",DIC(0)="L",X=ZT3 D FILE^DICN K DD S DIE=DIC,DA=$P(Y,U),ZTF2=DA,DR=".01:7" D ^DIE S DIC="^%ZIS(14.6,",DIC(0)="L" K DD,DO D DO^DIC1 W !?5
 S ZTDINUM=ZTDINUM+1
 K DD S DIC="^%ZIS(14.6,",DIC(0)="L",X=ZT2,DINUM=ZTDINUM D FILE^DICN
 K DD S DIE=DIC,DA=ZTDINUM,DR="1////"_ZTF1_";2////"_ZTF2_";3///"_ZT4 D ^DIE
 K DINUM Q
 ;
MGR ;FILE146--add MGR ucis that aren't in table to 14.6
 S ZTM=$P(ZTS,U,6)
 I $O(^%ZIS(14.6,"AV",ZTV,ZTM,""))]"" Q
 S ZTDINUM=ZTDINUM+1
 K DD S DIC="^%ZIS(14.6,",DIC(0)="L",X=ZTM,DINUM=ZTDINUM D FILE^DICN
 K DD S DIE=DIC,DA=ZTDINUM,DR="1////"_ZT1 D ^DIE
 W "."
 Q
 ;
CHECK ;FILE146--check for ucis that aren't in the table and add to 14.6
 I ZTU="" Q
 I $O(^%ZIS(14.6,"AV",ZTV,ZTU,""))]"" Q
 S ZTDINUM=ZTDINUM+1
 K DD S DIC="^%ZIS(14.6,",DIC(0)="L",X=ZTU,DINUM=ZTDINUM D FILE^DICN
 K DD S DIE=DIC,DA=ZTDINUM,DR="1////"_ZT1 D ^DIE
 W "."
 Q
 ;
ADD ;FILE146--fill in added volume sets
 K DD,D0 S DIE="^%ZIS(14.5,",DA=ZT1,DR=".01:7" D ^DIE W !?5,"."
 Q
 ;
