PSGOT ;BIR/CML3-TRANSFERS DATA FROM 53.1 TO 55 ;24 SEP 97 / 7:54 AM
 ;;5.0; INPATIENT MEDICATIONS ;**13,68,90**;16 DEC 97
 ;
 ; Reference to ^PS(55 supported by DBIA 2191.
 ;
START ; get internal record number, lock record, and write
 S ODA=+PSGORD S:$D(^PS(55,PSGP,0))[0 ^(0)=PSGP,^PS(55,"B",PSGP,PSGP)="",$P(^PS(55,0),U,3,4)=PSGP_U_($P($G(^PS(55,0)),U,4)+1) F  L +^PS(55,PSGP,5,0):1 I  Q
 S ZND=$G(^PS(55,PSGP,5,0)) S:ZND="" ZND="^55.06IA" F DA=$P(ZND,"^",3)+1:1 I '$D(^PS(55,PSGP,5,DA)),'$D(^("B",DA)) L +^PS(55,PSGP,5,DA):1 I  S $P(ZND,"^",3)=DA,$P(ZND,"^",4)=$P(ZND,"^",4)+1,^PS(55,PSGP,5,0)=ZND Q
 L -^PS(55,PSGP,5,0) S ND0=^PS(53.1,ODA,0),$P(ND0,"^",23)=PSJPWD,^PS(55,PSGP,5,DA,0)=ND0
 S (ND1,^PS(55,PSGP,5,DA,.2))=$G(^PS(53.1,ODA,.2)),^PS(55,PSGP,5,DA,.3)=$G(^PS(53.1,ODA,.3)),(ND2,^PS(55,PSGP,5,DA,2))=^PS(53.1,ODA,2),^PS(55,PSGP,5,DA,4)=$G(^PS(53.1,ODA,4)),^PS(55,"AUD",+$P(ND2,"^",4),PSGP,DA)=""
 S X=^PS(55,PSGP,0) I $P(X,"^",7)="" S $P(X,"^",7)=$P($P(ND0,"^",16),"."),$P(X,"^",8)="A",^(0)=X
 F X=6,7 I $D(^PS(53.1,ODA,X)) S ^PS(55,PSGP,5,DA,X)=^(X)
 I $O(^PS(53.1,ODA,1,0)) S (C,X)=0 F  S X=$O(^PS(53.1,ODA,1,X)) Q:'X  S:$D(^(X,0)) C=C+1,^PS(55,PSGP,5,DA,1,C,0)=^(0),^PS(55,PSGP,5,DA,1,"B",+$P($G(^(0)),U),C)=""
 ;F C=0:0 S C=$O(^PS(55,PSGP,5,DA,1,C)) Q:'C  S X=+$G(^(C,0)) S:X ^PS(55,PSGP,5,DA,1,"B",X,C)=""
 I $O(^PS(53.1,ODA,1,0)) S ^PS(55,PSGP,5,DA,1,0)="^55.07P^"_C_"^"_C
 F X=3,12 D  S ^PS(55,PSGP,5,DA,X,0)="^55.0"_$S(X=3:8,1:612)_U_CNT_U_CNT
 .S CNT=0 F C=0:0 S C=$O(^PS(53.1,ODA,X,C)) Q:'C  I $D(^(C,0)) S ^PS(55,PSGP,5,DA,X,C,0)=^(0),CNT=CNT+1
 ;F X=3,12 I $O(^PS(53.1,ODA,X,0)) S ^PS(55,PSGP,5,DA,X,0)=^(0) F C=0:0 S C=$O(^PS(53.1,ODA,X,C)) Q:'C  I $D(^(C,0)) S ^PS(55,PSGP,5,DA,X,C,0)=^(0)
 S $P(^PS(53.1,ODA,0),"^",19)=DA
CR ; set x-refs
 I $D(^PS(55,PSGP,5.1)),$P(^(5.1),"^",6) S X=$P(^(5.1),"^",6) I $P(ND2,"^",3),$P(ND2,"^",6)'>X S $P(^(5.1),"^",6)=$P(ND2,"^",3)
 S ^PS(55,PSGP,5,"B",+ODA,DA)="",^PS(55,PSGP,5,"AU",$P(ND0,"^",7),+$P(ND2,"^",4),DA)=""
 S ^PS(55,PSGP,5,"AUS",+$P(ND2,"^",4),DA)=""
 S ^PS(55,PSGP,5,"C",+ND1,DA)="",^PS(55,"AUE",PSGP,DA)=""
 S ^PS(55,"AUDS",+$P(ND2,"^",2),PSGP,DA)=""
 I $$PATCH^XPDUTL("PXRM*1.5*12") S X(1)=+$P(ND2,"^",2),X(2)=+$P(ND2,"^",4),DA(1)=PSGP D SPSPA^PSJXRFS(.X,.DA,"UD")
 S PSGTOL=2,PSGTOO=1 F PSGUOW=0:0 S PSGUOW=$O(^PS(53.41,2,1,PSGUOW)) Q:'PSGUOW  I $D(^(PSGUOW,1,PSGP,1,2,1,ODA)) K ^(ODA) D ENL^PSGVDS
DONE I $D(PSGOE2),PSGOE2]"",$D(^TMP("PSJON",$J,PSGOE2)) S ^(PSGOE2)=DA_"U"
 S PSGODA=ODA,PSGORD=DA_"U"
 S PSGNODE=$G(^PS(55,PSGP,5,DA,0)),PSG25=$P(PSGNODE,"^",25),PSG26=$P(PSGNODE,"^",26)
 I PSG25 S X=$S(PSG25["V":"^PS(55,"_PSGP_",""IV"",",PSG25["U"!(PSG25["A"):"^PS(55,"_PSGP_",5,",1:"^PS(53.1,")_+PSG25_","_$E("02",PSG25["V"+1)_")" I $D(@X) S $P(@X,"^",$S(PSG25["V":6,1:26))=DA_"U"
 I $P(PSGNODE,"^",26),$P(PSGNODE,"^",26)'["V",$D(^PS(55,PSGP,5,+$P(PSGNODE,"^",26),0)) S $P(^(0),"^",25)=DA_"U"
 ;I $P(PSGNODE,"^",21) S X=$O(^ORD(101,"B","PS EVSEND OR",0))_";ORD(101,",PSOC="SC",PSJORDER=$$ORDER^PSJHLU(PSGORD) D EN1^XQOR:X K X
 F Q=0:0 S Q=$O(^PS(53.44,Q)) Q:'Q  I $D(^(Q,1,PSGP,ODA,0)) S $P(^(0),"^",2)=DA
 L -^PS(53.1,ODA) L -^PS(55,DFN,5,+PSGORD) K CNT,ND,ODA,XX,ZND Q
