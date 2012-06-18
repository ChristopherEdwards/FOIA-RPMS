BMCPOST1 ; IHS/PHXAO/TMJ - Install Mail Groups ;
 ;;4.0;REFERRED CARE INFO SYSTEM;;JAN 09, 2006
 ;
START ;Install Each Mail Group
 D CHS,IHS,OTHER,INHOUSE
 D END
 Q
CHS ;Install BMC CHS ALERT Mail Group
 Q:$D(^XMB(3.8,"B","BMC CHS ALERT"))
 S X="BMC CHS ALERT",DIC="^XMB(3.8,",DIC(0)="L",DIADD=1,DLAYGO=3.8 D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DO
 I Y=-1 W !!,"Error in Creating Mail Group",!! Q
 S BMCBULL=+Y
 S DIE="^XMB(3.8,",DA=BMCBULL,DR="4////PUBLIC;3///A Bulletin is sent when a CHS Type Referral is entered;7////N;5////"_DUZ D ^DIE K DIE,DA,DR,DIU,DIY,DIW,DIV
 I $D(Y) W !!,"Error in updating CHS Mail Group",!!
 Q
 ;
IHS ;Install BMC IHS ALERT Mail Group
 Q:$D(^XMB(3.8,"B","BMC IHS ALERT"))
 S X="BMC IHS ALERT",DIC="^XMB(3.8,",DIC(0)="L",DIADD=1,DLAYGO=3.8 D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DO
 I Y=-1 W !!,"Error in Creating Mail Group",!! Q
 S BMCBULL=+Y
 S DIE="^XMB(3.8,",DA=BMCBULL,DR="4////PUBLIC;3///A Bulletin is sent when a IHS Type Referral is entered;7////N;5////"_DUZ D ^DIE K DIE,DA,DR,DIU,DIY,DIW,DIV
 I $D(Y) W !!,"Error in updating IHS Mail Group",!!
 Q
 ;
OTHER ;Install BMC OTHER ALERT Mail Group
 ;
 Q:$D(^XMB(3.8,"B","BMC OTHER ALERT"))
 S X="BMC OTHER ALERT",DIC="^XMB(3.8,",DIC(0)="L",DIADD=1,DLAYGO=3.8 D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DO
 I Y=-1 W !!,"Error in Creating Mail Group",!! Q
 S BMCBULL=+Y
 S DIE="^XMB(3.8,",DA=BMCBULL,DR="4////PUBLIC;3///A Bulletin is sent when a OTHER Type Referral is entered;7////N;5////"_DUZ D ^DIE K DIE,DA,DR,DIU,DIY,DIW,DIV
 I $D(Y) W !!,"Error in updating OTHER Mail Group",!!
 Q
INHOUSE ;Install BMC INHOUSE ALERT Mail Group
 Q:$D(^XMB(3.8,"B","BMC INHOUSE ALERT"))
 S X="BMC INHOUSE ALERT",DIC="^XMB(3.8,",DIC(0)="L",DIADD=1,DLAYGO=3.8 D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DO
 I Y=-1 W !!,"Error in Creating Mail Group",!! Q
 S BMCBULL=+Y
 S DIE="^XMB(3.8,",DA=BMCBULL,DR="4////PUBLIC;3///A Bulletin is sent when a INHOUSE Type Referral is entered;7////N;5////"_DUZ D ^DIE K DIE,DA,DR,DIU,DIY,DIW,DIV
 I $D(Y) W !!,"Error in updating INHOUSE Mail Group",!!
 Q
 ;
END ;
 W !!,"Mail Groups Successfully Installed",!," - Now add appropriate Members to each of the following Mail Groups",!!
 W "BMC IHS ALERT",!
 W "BMC CHS ALERT",!
 W "BMC OTHER ALERT",!
 W "BMC INHOUSE ALERT",!
 K BMCBULL Q
