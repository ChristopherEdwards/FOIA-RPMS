ACRFSHFT ;IHS/OIRM/DSD/THL,AEF - SHIFT ACCOUNTS;  [ 11/02/2001  2:46 PM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;UTILITY TO SHIFT FINANCIAL ACCOUNTS
EN ;EP;
 D EN1
EXIT K ACR,ACRSADA
 Q
EN1 ;
AL ;SELECT ACCOUNT LEVEL
 S DIR(0)="SO^1:Delete a Financial Account(s);2:Move a Financial Account"
 S DIR("A")="Which one"
 W !
 D DIR^ACRFDIC
 Q:$D(ACROUT)!$D(ACRQUIT)!'$D(Y)
 Q:'ACRY
 I Y=1 S ACRDEL=""
 E  K ACRDEL
 S DIR(0)="SO^1:Department Account(s);2:Sub-Allowance(s);3:Allowance(s)"
 S:$D(ACRDEL) DIR(0)=DIR(0)_";4:Appropriation(s)"
 S DIR("A")="Which Account Level"
 W !
 D DIR^ACRFDIC
 Q:$D(ACROUT)!$D(ACRQUIT)!'$D(Y)
 Q:'ACRY
 S ACRAL=ACRY ; SET ACCOUNT LEVEL VARIABLE
ID ;SELECT ID NO(S) TO SHIFT
 S DIR(0)="LO^"_$S(ACRY=1:$O(^ACRLOCB(0)),ACRY=2:$O(^ACRALC(0)),ACRY=3:$O(^ACRALW(0)),1:$O(^ACRAPP(0)))_":"_$S(ACRY=1:$P(^ACRLOCB(0),U,3),ACRY=2:$P(^ACRALC(0),U,3),ACRY=3:$P(^ACRALW(0),U,3),1:$P(^ACRAPP(0),U,3))
 S DIR("A")="Which ID NO(s)"
 W !
 D DIR^ACRFDIC
 Q:$D(ACROUT)!$D(ACRQUIT)!'$D(Y)
 Q:'ACRY
 S ACRID=ACRY ; SET ID NO(S) VARIABLE
 D:'$D(ACRDEL) TO
 D WARN
 Q
TO ;SELECT ACCOUNT TO SHIFT TO
 S DIC(0)="AENQZ"
 S DIC=$S(ACRAL=1:"^ACRALC(",ACRAL=2:"^ACRALW(",1:"^ACRAPP(")
 S DIC("A")="Which "_$S(ACRAL=1:"Sub-Allowance",ACRAL=2:"Allowance",1:"Appropration")_": "
 W !!,"Select the ",$S(ACRAL=1:"Sub-Allowance",ACRAL=2:"Allowance",1:"Appropration")," to move selected ",$S(ACRAL=1:"Department Account(s)",ACRAL=2:"Sub-Allowance(s)",1:"Allowance(s)")," to: "
 W !
 D DIC^ACRFDIC
 I $D(ACROUT)!$D(ACRQUIT)!'$D(Y) S ACRQUIT="" Q
 I Y<1 S ACRQUIT="" Q
 S ACRTO=+Y ; SET ID NO VARIABLE OF ACCOUNT TO MOVE TO
 Q
DEPT ;
 F ACRI=1:1 S ACRLBDA=$P(ACRID,",",ACRI) Q:ACRLBDA=""  D:$D(^ACRLOCB(ACRLBDA,0))
 .I $D(ACRDEL) D  Q
 ..I $D(^ACROBL("D",ACRLBDA)) D  Q
 ...W *7,*7
 ...W !!,"Department Account ID NO. ",@ACRON,ACRLBDA,@ACROF," has dependent documents."
 ...W !,"It cannot be deleted."
 ...H 1
 ..I '$D(^ACROBL("D",ACRLBDA)) D  Q
 ...I $D(^ACRLOCB("NEXTFY",ACRLBDA)) S DA=$O(^(ACRLBDA,0)) D:DA
 ....S DIE="^ACRLOCB("
 ....S DR=".06///@;.07///@"
 ....D DIE^ACRFDIC
 ...S DA=ACRLBDA
 ...S DIK="^ACRLOCB("
 ...D DIK^ACRFDIC
 .S DA=ACRLBDA
 .S DIE="^ACRLOCB("
 .S DR=".04////"_ACRTO
 .D DIE^ACRFDIC
 .D CRQ
 Q
SALW ;
 F ACRI=1:1 S ACRSADA=$P(ACRID,",",ACRI) Q:ACRSADA=""  I $D(^ACRALC(ACRSADA,0)) D
 .I $D(ACRDEL) D  Q
 ..I $D(^ACRLOCB("M",ACRSADA))!$D(^ACROBL("C",ACRSADA)) D  Q
 ...W *7,*7
 ...W !!,"Sub-Allowance ID NO. ",@ACRON,ACRSADA,@ACROF," has dependent Department Accounts."
 ...W !,"It cannot be deleted."
 ...H 1
 ..I '$D(^ACRLOCB("M",ACRSADA))&'$D(^ACROBL("C",ACRSADA)) D  Q
 ...I $D(^ACRALC("NEXTFY",ACRSADA)) S DA=$O(^(ACRSADA,0)) D:DA
 ....S DIE="^ACRALC("
 ....S DR=".06///@;.07///@"
 ....D DIE^ACRFDIC
 ...S DA=ACRSADA
 ...S DIK="^ACRALC("
 ...D DIK^ACRFDIC
 .S DA=ACRSADA
 .S DIE="^ACRALC("
 .S DR=".03////"_ACRTO
 .D DIE^ACRFDIC
 .D CLB
 Q
ALLW ;
 F ACRI=1:1 S ACRALDA=$P(ACRID,",",ACRI) Q:ACRALDA=""  I $D(^ACRALW(ACRALDA,0)) D
 .I $D(ACRDEL) D  Q
 ..I $D(^ACRALC("M",ACRALDA))!$D(^ACROBL("LOT",ACRALDA)) D  Q
 ...W *7,*7
 ...W !!,"Allowance ID NO. ",@ACRON,ACRALDA,@ACROF," has dependent Sub-Allowances."
 ...W !,"It cannot be deleted."
 ...H 1
 ..I '$D(^ACRALC("M",ACRALDA))&'$D(^ACROBL("LOT",ACRALDA)) D  Q
 ...I $D(^ACRALW("NEXTFY",ACRALDA)) S DA=$O(^(ACRALDA,0)) D:DA
 ....S DIE="^ACRALW("
 ....S DR=".06///@;.07///@"
 ....D DIE^ACRFDIC
 ...S DA=ACRALDA
 ...S DIK="^ACRALW("
 ...D DIK^ACRFDIC
 .S DA=ACRALDA
 .S DIE="^ACRALW("
 .S DR=".02////"_ACRTO
 .D DIE^ACRFDIC
 .D CSA
 Q
APPR ;DELETE APPROPRIATIONS
 F ACRI=1:1 S ACRAPPDA=$P(ACRID,",",ACRI) Q:ACRAPPDA=""  I $D(^ACRAPP(ACRAPPDA,0)) D
 .I $D(ACRDEL) D  Q
 ..I $D(^ACRALW("M",ACRAPPDA))!$D(^ACROBL("PROP",ACRAPPDA)) D  Q
 ...W *7,*7
 ...W !!,"Allowance ID NO. ",@ACRON,ACRAPPDA,@ACROF," has dependent Sub-Allowances."
 ...W !,"It cannot be deleted."
 ...H 1
 ..I '$D(^ACRALW("M",ACRAPPDA))&'$D(^ACROBL("PROP",ACRAPPDA)) D  Q
 ...I $D(^ACRAPP("NEXTFY",ACRAPPDA)) S DA=$O(^(ACRAPPDA,0)) D:DA
 ....S DIE="^ACRAPP("
 ....S DR=".06///@;.07///@"
 ....D DIE^ACRFDIC
 ...S DA=ACRAPPDA
 ...S DIK="^ACRAPP("
 ...D DIK^ACRFDIC
 Q
WARN Q:$D(ACRQUIT)
 D W1
 S DIR(0)="YO"
 S DIR("A")="Are you ABSOLUTELY CERTAIN this is what you want to do."
 S DIR("B")="NO"
 W !
 D DIR^ACRFDIC
 Q:$D(ACROUT)!$D(ACRQUIT)
 Q:Y'=1
 W !
 D:$E($G(IOST),1,2)="C-" WAIT^DICD
 I ACRAL=1 D DEPT Q
 I ACRAL=2 D SALW Q
 I ACRAL=3 D ALLW Q
 I ACRAL=4 D APPR Q
 Q
W1 W !!,"You have chosen to ",$S('$D(ACRDEL):"move ",1:"delete ")
 W !,$S(ACRAL=1:"Department Account(s)",ACRAL=2:"Sub-Allowance(s)",ACRAL=3:"Allowance(s)",1:"Appropriation(s)"),": ",ACRID
 W:'$D(ACRDEL) !," to ",$S(ACRAL=1:"Sub-Allowance",ACRAL=2:"Allowance",1:"Appropration")," ID NO: ",ACRTO
 Q
P D PAUSE^ACRFWARN
 Q
CSA ;CHANGE SUB-ALLOWANCE
 S ACRSADA=0
 F  S ACRSADA=$O(^ACRALC("M",ACRALDA,ACRSADA)) Q:'ACRSADA  D:$D(ACRALC(ACRSADA,0))
 .S DA=ACRSADA
 .S DIE="^ACRALC("
 .S DR=".02////"_ACRTO_";.03////"_ACRALDA
 .D DIE^ACRFDIC
 .D CLB
 Q
CLB ;CHANGE DEPARTMENT ACCOUNT
 S ACRLBDA=0
 F  S ACRLBDA=$O(^ACRLOCB("M",ACRSADA,ACRLBDA)) Q:'ACRLBDA  D:$D(^ACRLOCB(ACRLBDA,0))
 .S DA=ACRLBDA
 .S DIE="^ACRLOCB("
 .S DR=".04////"_ACRSADA
 .D DIE^ACRFDIC
 .D CRQ
 Q
CRQ ;CHANGE REQUEST
 S ACRDOCDA=0
 F  S ACRDOCDA=$O(^ACROBL("D",ACRLBDA,ACRDOCDA)) Q:'ACRDOCDA  D
 .S DA=ACRDOCDA
 .S DIE="^ACROBL("
 .S DR=".03////"_ACRLBDA
 .D DIE^ACRFDIC
CSUP ;CHANGE SUPPLY/ITEM FILE
 S ACRSSDA=0
 F  S ACRSSDA=$O(^ACRSS("F",ACRLBDA,ACRSSDA)) Q:'ACRSSDA  D
 .S DA=ACRSSDA
 .S DIE="^ACRSS("
 .S DR=".06////"_ACRLBDA
 .D DIE^ACRFDIC
 Q
