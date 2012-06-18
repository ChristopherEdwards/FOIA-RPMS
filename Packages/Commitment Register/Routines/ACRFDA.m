ACRFDA ;IHS/OIRM/DSD/THL,AEF - DISAPPROVAL HISTORY REPORT; [ 09/23/2005   9:44 AM ]
 ;;2.1;ADMIN RESOURCE MGT SYSTEM;**19**;NOV 05, 2001
EN ;EP;
 F  D EN1 Q:$D(ACRQUIT)!$D(ACROUT)
EXIT K ACRQUIT,ACROUT,ACR0,ACRAPDA,ACRCNG,ACRDAT,ACRPAI,ACRJ,ACRDOCDA,ACRI,ACRINAM,ACRINDV,ACRINDVA,ACRNO,ACRRESP,ACRRSN,ACRRTN,ACRAPDA,ACRY,ACRZ,ACRDT,ACRDATE,ACRX,ACRQUIT
 K ^TMP("ACRDA",$J)
 Q
EN1 D EXIT
 D SELECT
 Q:$D(ACRQUIT)!$D(ACROUT)
 D PRINT
 Q
SELECT ;SELECT DOCUMENT FOR DA HISTORY REPORT
 S DIC="^ACRDOC("
 S DIC(0)="AEMQZ"
 S DIC("A")="Which Document: "
 S DIC("S")="I $D(^ACRAPVS(""D"",+Y))"
 W @IOF,!?20,"DELETED Signature History Report"
 W !!,"The report which follows lists all DELETED approvals for the selected document."
 W !,"The approvals listed may have been deleted because the document was DISAPPROVED"
 W !,"or becuase accounting or item information was changed or because the document"
 W !,"was re-sent for approval.  ARMS does not know WHY these signatures were"
 W !,"deleted but the listing below will indicate who deleted them and when.",!!
 D DIC^ACRFDIC
 I $G(Y)<1 S ACRQUIT="" Q
 S ACRDOCDA=+Y
 Q
PRINT ;PRINT REPORT
 N X
 S (ZTRTN,ACRRTN)="P1^ACRFDA"
 S X=$P(^ACRDOC(ACRDOCDA,0),U,1,2)
 S X=$P(X,U)_$S($P(X,U,2)]""&($P(X,U,2)'=$P(X,U)):" ("_$P(X,U,2)_")",1:"")
 S ZTDESC="DELETED APPROVALS FOR "_X
 D ^ACRFZIS
 K ACRQUIT
 Q
P1 ;EP;TO PRINT DA HISTORY REPORT
 S (ACRAPDA,ACRJ)=0
 F  S ACRAPDA=$O(^ACRAPVS("D",ACRDOCDA,ACRAPDA)) Q:'ACRAPDA  I $D(^ACRAPVS(ACRAPDA,0)) S Y=^(0) D
 .S ACRDATE=$E($P(Y,U,10),1,13)
 .S:'ACRDATE ACRDATE="NOT STATED"
 .S ^TMP("ACRDA",$J,+$P(Y,U,6),ACRDATE,$P(Y,U,4),ACRAPDA)=""
 Q:'$D(^TMP("ACRDA",$J))#2
 S ACRREFDA=0
 F  S ACRREFDA=$O(^TMP("ACRDA",$J,ACRREFDA)) Q:'ACRREFDA  D
 .S ACRJ="",ACRI=0
 .F  S ACRJ=$O(^TMP("ACRDA",$J,ACRREFDA,ACRJ)) Q:ACRJ=""  D
 ..S ACRPAI=0
 ..F  S ACRPAI=$O(^TMP("ACRDA",$J,ACRREFDA,ACRJ,ACRPAI)) Q:'ACRPAI  D
 ...S:ACRPAI=1 ACRI=ACRI+1
 ...S ACRAPDA=0
 ...F  S ACRAPDA=$O(^TMP("ACRDA",$J,ACRREFDA,ACRJ,ACRPAI,ACRAPDA)) Q:'ACRAPDA  D P
 D S
 D PAUSE^ACRFWARN
 D EXIT:'$D(ACRSIGS)
 Q
P S ACR0=^ACRAPVS(ACRAPDA,0)
 S ACRDT=^ACRAPVS(ACRAPDA,"DT")
 S ACRRSN=$G(^ACRAPVS(ACRAPDA,"RSN"))
 S ACRCNG=$G(^ACRAPVS(ACRAPDA,"CNG"))
 I ACRPAI=1 D
 .I $G(ACRDAT),ACRDAT D
 ..D S
 ..D PAUSE^ACRFWARN
 .S ACRDAT=$G(ACRDAT)+1
 .N X,Y
 .S X=$P(ACR0,U,9)
 .S Y=$P(ACR0,U,10)
 .W !,"The approvals listed below were deleted by: "
 .;S X=$P($G(^VA(200,+X,0)),U)            ;ACR*2.1*19.02 IM16848
 .;S X=$P($P(X,",",2)," ")_" "_$P(X,",")  ;ACR*2.1*19.02 IM18648
 .S X=$$NAME3^ACRFUTL1(+X)                ;ACR*2.1*19.02 IM16848
 .W !,X
 .D:Y]""
 ..X:Y ^DD("DD")
 ..W " on ",Y
 .W !!
 S D0=ACRAPDA
 D ^ACRPRCA
 I $D(ACRSIGS) S ACRSIGS(ACRDAT,ACRAPDA)=""
 Q
SIGS ;EP;TO RECOUP DELETED SIGS
 K ACRSIGS
 S ACRSIGS=""
 D EN1
 I $D(^ACRAPVS("AB",ACRDOCDA)) D  I $D(ACRQUIT) D OUT Q
 .S DIR(0)="YO"
 .S DIR("A",1)="There are active signatures on file for this document"
 .S DIR("A")="Delete these signatures"
 .S DIR("B")="NO"
 .W !
 .D DIR^ACRFDIC
 .I +Y=1 K ^ACRAPVS("AB",ACRDOCDA) Q
 .K ACRQUIT
 .S DIR(0)="YO"
 .S DIR("A",1)="You may end up with two sets of active signatures"
 .S DIR("A")="Are you certain this is what you want"
 .S DIR("B")="NO"
 .W !
 .D DIR^ACRFDIC
 .Q:+Y=1
 .K ^ACRAPVS("AB",ACRDOCDA)
 S DIR(0)="NO^1:"_ACRDAT
 S DIR("A")="Which set should be restored"
 W !!
 D DIR^ACRFDIC
 Q:'+$G(Y)
 S ACRX=+Y
 N X
 S X=0
 F  S X=$O(ACRSIGS(ACRX,X)) Q:'X  D
 .W !,ACRDOCDA,?10,X
 .S ^ACRAPVS("AB",ACRDOCDA,X)=""
 .K ^ACRAPVS("D",ACRDOCDA,X)
 .S ^ACRAPVS("AORDR",ACRDOCDA,+$P($G(^ACRAPVS(X,0)),U,4),X)=""
OUT D EXIT
 K ACRSIGS
 Q
S ;DISPLAY APPROVAL IEN'S
 Q:'$O(ACRSIGS(0))
 W !!,"ID NO's:  Set number ",ACRDAT,!
 N X
 S X=0
 F  S X=$O(ACRSIGS(ACRDAT,X)) Q:'X  W X,", "
 Q
