APCPRLOG ; IHS/TUCSON/LAB - OHPRD-TUCSON/LAB - UPDATE LOG IN REDO AUGUST 14, 1992 ; [ 04/30/2002 9:36 PM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**1,3,6**;APR 03, 1998
 ;IHS/CMI/LAB - new date format
LOG ; UPDATE LOG
 W:'$D(ZTQUEUED) !!,APCP("COUNT")," transactions were generated."
 W:'$D(ZTQUEUED) !,"Updating Log entry."
 D NOW^%DTC S APCP("RUN STOP")=%
 S X="AD0"_"^"_$P(^AUTTSITE(1,1),U,3)_"^"_$P(^DIC(4,DUZ(2),0),U)_"^"_$$DATE($E(APCP("RUN START"),1,7))_"^"_$$DATE(APCP("RUN BEGIN"))_"^"_$$DATE(APCP("RUN END"))
 S X=X_"^"_$S(APCPO("RUN")="REDO":"R",1:"")_"^"_APCP("COUNT")_"^"_APCP("VISITS STAT")_"^"
 S Y=$G(APCP("ERROR COUNT"))+$G(APCP("DEMO PAT"))+$G(APCP("DEL NEVER SENT"))+$G(APCP("IN NO PP"))
 S X=X_Y_"^"_$G(APCP("ERROR COUNT"))_"^"_$G(APCP("DEMO PAT"))_"^"_$G(APCP("FILENAME"))
 S ^BAPCDATA(0)=X
 S X=^APCPLOG(APCP("RUN LOG"),0),$P(X,U,3)="",$P(X,U,4)="",$P(X,U,5)="",$P(X,U,6)="",$P(X,U,7)="",$P(X,U,11)="",$P(X,U,12)="",$P(X,U,13)="",$P(X,U,15)=""
 S $P(X,U,17)="",$P(X,U,18)="",$P(X,U,19)="",$P(X,U,21)="",$P(X,U,22)="",$P(X,U,23)="",$P(X,U,26)="",^APCPLOG(APCP("RUN LOG"),0)=X
 S DA=APCP("RUN LOG"),DIE="^APCPLOG(",DR=".03////"_APCP("RUN START")_";.04////"_APCP("RUN STOP")_";.05////"_APCP("ERROR COUNT")_";.06////"_APCP("COUNT")_";.15///P"
 D ^DIE
 I $D(Y) S APCP("QFLG")=30 Q
 S DA=APCP("RUN LOG"),DIE="^APCPLOG(",DR=".11////"_APCP("INPT")_";.14////"_APCP("CHA")_";.13////"_APCP("APC")_";.17////"_APCP("STAT")_";.18////"_$G(APCP("VISITS STAT")) D ^DIE I $D(Y) S APCP("QFLG")=30 Q
 S DA=APCP("RUN LOG"),DIE="^APCPLOG(",DR=".19////"_$G(APCP("DEMO PAT"))_";.21////"_$G(APCP("EVENTS"))_";.22////"_$G(APCP("DELETED"))_";.23////"_$G(APCP("IN NO PP")) D ^DIE I $D(Y) S APCP("QFLG")=30 Q
 S DA=APCP("RUN LOG"),DIE="^APCPLOG(",DR=".24///"_APCP("FILENAME")_";.25///"_$S(APCPO("RUN")="REDO":1,1:"")_";.26///"_APCP("DEL NEVER SENT") D ^DIE I $D(Y) S APCP("QFLG")=26 Q
 ;
 Q
 ;
DATE(D) ;EP ;IHS/CMI/LAB - new date format - format date in YYYYMMDD format
 I $G(D)="" Q ""
 Q $E(D,1,3)+1700_$E(D,4,7)
 ;
