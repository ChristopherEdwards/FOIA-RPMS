ACRFNEWF ;IHS/OIRM/DSD/THL,AEF - UTILITY TO NOTIFY USER OF NEW ARMS FUNCTION;  [ 11/8/2006   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**19,22**;NOV 05, 2001
EN D EN1
 D EN2:$D(^ACRUAL("LVL",DUZ,3))
EXIT K ACR,ACRTERM
 Q
EN1 ;
 D HOME^ACRFMENU
 ;BEGIN NEW CODE ACR*2.1*22.03 IM22653
 D HEAD^ACRFMENU
 Q:$D(ACRNOFM)
 ;END NEW CODE
 S ACRTERM=+$G(^ACRSYS(1,2))
 Q:DT>ACRTERM
 Q:'$O(^ACRSYS(1,10,0))
 W @IOF,*7,*7,*7
 S D0=1
 D ^ACRPAM
 W !,"If you have any problems or suggestions please call your local ARMS manager."
 D PAUSE^ACRFWARN
 K ACRQUIT,ACROUT
 Q
EN2 S ACRTERM=$P($G(^ACRSYS(1,2)),U,2)
 Q:DT>ACRTERM
 Q:'$O(^ACRSYS(1,20,0))
 W @IOF
 W *7,*7
 W !
 I $P($G(^VA(200,DUZ,.1)),U,4)]"" W $P(^(.1),U,4)
 ;E  W $P($P($P(^VA(200,DUZ,0),U),",",2)," ")  ;ACR*2.1*19.02 IM16848
 E  W $P($P($$NAME2^ACRFUTL1(DUZ),",",2)," ")  ;ACR*2.1*19.02 IM16848
 W !!
 S D0=1
 D ^ACRPAMM
 D PAUSE^ACRFWARN
 K ACRQUIT,ACROUT
 Q
EMESS ;EP;TO EDIT AN ARMS USER MESSAGE
 W @IOF
 W !,"Enter the message you want to broadcast to all ARMS users."
 W !!
 S DA=1
 S DIE="^ACRSYS("
 S DR="[ACR ARMS MESSAGE]"
 D DIE^ACRFDIC
 Q
NSV ;EP;TO CHECK FOR SECURITY VIOLATIONS
 N ACRLVL
 S ACRLVL=$O(^ACRUAL("LVL",DUZ,0))
 Q:ACRLVL=3!(ACRLVL=11)
 N X
 F  S X=$O(^ACRACC(3,"SEC","C",1,X)) Q:'X  I $D(^VA(200,DUZ,51,X)) D  Q
 . S ACRDUZ=DUZ
 .D KILLSEC^ACRFACC
 .W !!,"You have ARMS ACCESS LEVEL ",ACRLVL
 .W !,"However, somehow you have gotten access to secured functions"
 .W !,"within ARMS which can only be accessed by someone with"
 .W !,"ACESS LEVEL 10."
 .W !!,"All your access to ARMS has been temporarily suspended."
 .W !,"Please see your ARMS Manager to re-establish an appropriate"
 .W !,"ACCESS LEVEL for yourself."
 Q
