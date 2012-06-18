ACRFDCC ;IHS/OIRM/DSD/THL,AEF - CHANGE DEFAULT CAN DATA FOR ALL CAN'S; [ 11/01/2001   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;;NOV 05, 2001
 ;;ROUTINE USED TO CHANGE DEFAULT CAN DATA FOR ALL CAN'S DURING CAN
 ;;DEFAULT EDIT
EN2 ;EP;CHANGE DATA
 N ACRDA,ACRALL,ACR,ACRCAN,ACRCANDA,ACRLBDA,ACRDPT,ACRDPTX,ACRI,ACRJ,ACRSEL,ACRN,ACRP,ACRFR,ACRTO,ACRQUIT,ACRY
 D EN21
EXIT K ^TMP("ACRDCC",$J),^TMP("ACRDCAN",$J)
 Q
EN21 W !!,"You selected to make changes in CAN DEFAULT data."
 S DIR(0)="YO"
 S DIR("A")="Proceed to make changes"
 S DIR("B")="YES"
 W !
 D DIR^ACRFDIC
 Q:Y'=1
 D WHICH
 Q:'$O(^TMP("ACRDCAN",$J,0))
 W !
 D:$E($G(IOST),1,2)="C-" WAIT^DICD
 S ACRDA=0
 F  S ACRDA=$O(^TMP("ACRDCAN",$J,ACRDA)) Q:'ACRDA  D
 .S ACRF=0,DR=""
 .F  S ACRF=$O(^TMP("ACRDCC",$J,ACRF)) Q:'ACRF  D
 ..S ACRP=^TMP("ACRDCC",$J,ACRF)
 ..S ACRFR=$P(ACRP,U)
 ..S ACRTO=$P(ACRP,U,2)
 ..S ACRN=$P(ACRP,U,4)
 ..S ACRP=$P(ACRP,U,3)
 ..I $D(^ACRCAN(ACRDA,ACRN)),$P(^(ACRN),U,ACRP)'=ACRTO S DR=DR_ACRF_"////"_ACRTO_";"
 .Q:DR=""
 .W !,$P(^AUTTCAN(ACRDA,0),U)," has been changed."
 .S DA=ACRDA
 .S DIE="^ACRCAN("
 .D DIE^ACRFDIC
 D PAUSE^ACRFWARN
 Q
INQ ;EP;TO INQUIRE IF CHANGE SHOULD APPLY TO ALL CAN'S
 Q:'$G(ACRF)
 N %
 W !!,"Should this change apply to other CAN's"
 S %=2
 D YN^DICN
 Q:%'=1
 S %=$P($G(^DD(9002186.5,ACRF,0)),U,4)
 S ^TMP("ACRDCC",$J,ACRF)=ACRFR_U_ACRTO_U_$P(%,";",2)_U_$P(%,";")
 K ACRF,ACRFR,ACRTO,ACRP,ACR,ACRQUIT,ACRN
 W !,"Change will take place after edit completed."
 W !
 Q
WHICH ;EP;TO CHANGE ALL OR SELECTED CANS
 F  D W Q:$D(ACRQUIT)
 K ACRQUIT
 Q
W S DIR(0)="SO^1:Change all CAN's;2:Change selected CAN's"
 S DIR("?",1)="Select '1' to have the change made to ALL CAN's."
 S DIR("?",2)="Select '2' to choose selected CAN's to change."
 S DIR("?")="Choose an option from the list"
 W !
 D DIR^ACRFDIC
 I "12"'[+$G(Y) S ACRQUIT="" Q
 S ACRALL=Y
 I Y=1 D ALL Q
 I Y=2 D SELECT Q
 Q
SELECT ;SELECT CAN'S FOR CHANGE
 F  D S Q:$D(ACRQUIT)
 K ACRQUIT
 Q
S S DIR(0)="SO^1:List ALL CAN's;2:List ONLY ACTIVE CAN's;3:Select CAN's One by One"
 S DIR("?",1)="Select '1' to get a list of ALL CAN's used by ARMS as DEFAULT CAN's."
 S DIR("?",2)="Select '2' to get a list of CAN's for current Department Accounts."
 S DIR("?",3)="Select '3' to select CAN's individually"
 S DIR("?")="Choose an option from the list"
 W !
 W:$O(^TMP("ACRDCAN",$J,0)) "You may now select additional CAN's if you wish."
 D DIR^ACRFDIC
 I "123"'[+$G(Y) S ACRQUIT="" Q
 I Y=3 D ONE Q
 S ACRSEL=+Y
 D LIST
 Q
LIST ;LIST CANS
 D L
 D CHOOSE
 Q
L W @IOF
 W !?10,"NO."
 W ?18,"CAN"
 W ?27,"DEPARTMENT"
 W !?10,"------"
 W ?18,"-------"
 W ?27,"------------------------------"
 S ACR=""
 S ACRJ=0
 F  S ACR=$O(^AUTTCAN("B",ACR)) Q:ACR=""!$D(ACRQUIT)  D
 .S ACRCANDA=0
 .F  S ACRCANDA=$O(^AUTTCAN("B",ACR,ACRCANDA)) Q:'ACRCANDA!$D(ACRQUIT)  I $D(^ACRLOCB("DCAN",ACRCANDA)) D
 ..S (ACRI,ACRLBDA)=0
 ..F  S ACRLBDA=$O(^ACRLOCB("DCAN",ACRCANDA,ACRLBDA)) Q:'ACRLBDA!$D(ACRQUIT)  D
 ...I ACRLBDA,$D(^ACRLOCB(ACRLBDA,0)) S ACRDPTDA=$P(^(0),U,5) I ACRDPTDA,$D(^AUTTPRG(ACRDPTDA,0)) S ACRDPT=$P(^(0),U) D:ACRDPT]""
 ...Q:ACRSEL=2&'$D(^ACRLOCB(ACRLBDA,"SC",0))
 ...S ACRI=ACRI+1
 ...I ACRI=1 D
 ....S ACRJ=ACRJ+1
 ....S ACRCAN(ACRJ)=ACRCANDA
 ...I ACRI=1 D
 ....W !?10,ACRJ
 ....W ?18,ACR
 ....W ?27,ACRDPT
 ...I ACRI>1,ACRDPTX'=ACRDPT W !?27,ACRDPT
 ...S ACRDPTX=ACRDPT
 ...I $Y>(IOSL-4) D PAUSE^ACRFWARN W:'$D(ACRQUIT) @IOF
 K ACRQUIT
 Q
ONE ;SELECT INDIVIDUAL CAN'S
 F  D O Q:$D(ACRQUIT)
 K ACRQUIT
 Q
O S DIC="^AUTTCAN("
 S DIC(0)="AEMQZ"
 S DIC("A")="Select a CAN: "
 S DIC("S")="I $D(^ACRLOCB(""DCAN"",+Y))"
 W !
 D DIC^ACRFDIC
 I +Y<1 S ACRQUIT="" Q
 I +Y>0 S ^TMP("ACRDCAN",$J,+Y)=""
 I $O(^TMP("ACRDCAN",$J,0)) S DIC("A")="Select another CAN: "
 Q
CHOOSE ;CHOOSE CAN'S FROM LIST
 S DIR(0)="LO^1:"_ACRJ,DIR("A")="Which CAN(s)"
 W !
 D DIR^ACRFDIC
 F ACRI=1:1 S ACRX=$P(Y,",",ACRI) Q:ACRX=""  S:$D(ACRCAN(ACRX))#2 ^TMP("ACRDCAN",$J,ACRCAN(ACRX))=""
 Q
ALL ;SET TEMPORARY ARRAY WITH ALL DEFAULT CAN'S
 S ACR=0
 F  S ACR=$O(^ACRCAN(ACR)) Q:'ACR  I $D(^ACRCAN(ACR,"DFLT")) S ^TMP("ACRDCAN",$J,ACR)=""
 Q
