PSN4P29 ;BIR/DMA-fix drug identifiers ;20 Mar 00 / 8:12 AM
 ;;4.0; NATIONAL DRUG FILE;**29**; 30 Oct 98
 ;
 S DA=0 F  S DA=$O(^PS(50.416,DA)) Q:'DA  K ^(DA,1)
 ;get rid of multiple
 ;
 S DA=0 F  S DA=$O(^PSNDF(50.68,DA)),K=0 Q:'DA  S PSN=$P(^(DA,0),"^",2)_"A"_DA D
 .K ^TMP($J) F  S K=$O(^PSNDF(50.68,DA,2,K)) Q:'K  S X=^(K,0),^TMP($J,+X)=X
 .K ^PSNDF(50.68,DA,2)
 .S J=0 F  S J=$O(^TMP($J,J)) Q:'J  S X=^(J),^PSNDF(50.68,DA,2,J,0)=X,J1=$O(^PS(50.416,J,1," "),-1)+1,^(J1,0)=PSN,^PS(50.416,J,1,"B",PSN,J1)=""
 ;now the zero nodes
 S DA=0 F  S DA=$O(^PS(50.416,DA)) Q:'DA  S X=$O(^PS(50.416,DA,1," "),-1),^PS(50.416,DA,1,0)="^50.4161A^"_X_"^"_X
 ;now 56
 K ^TMP($J) F J="AE","AI1","AI2","APD","C" K ^PS(56,J)
 S DA=0 F  S DA=$O(^PS(56,DA)) Q:'DA  S X=^(DA,0),NA=$P(X,"^"),I1=$P(X,"^",2),I2=$P(X,"^",3) D
 .S ^PS(56,"AE",I1,I2,DA)="",^PS(56,"AE",I2,I1,DA)=""
 .S ^PS(56,"AI1",I1,DA)=""
 .S ^PS(56,"AI2",I2,DA)=""
 .S ^PS(56,"C",$P(NA,"/"),DA)=""
 .S ^PS(56,"C",$P(NA,"/",2),DA)=""
 .K ^TMP($J) D
 ..S K=0 F  S K=$O(^PS(50.416,I1,1,K)) Q:'K  S X=^(K,0),^TMP($J,1,X)=""
 ..S K=0 F  S K=$O(^PS(50.416,I2,1,K)) Q:'K  S X=^(K,0),^TMP($J,2,X)=""
 ..S I11=0 F  S I11=$O(^PS(50.416,"APS",I1,I11)),K=0 Q:'I11  F  S K=$O(^PS(50.416,I11,1,K)) Q:'K  S X=^(K,0),^TMP($J,1,X)=""
 ..S I22=0 F  S I22=$O(^PS(50.416,"APS",I2,I22)),K=0 Q:'I22  F  S K=$O(^PS(50.416,I22,1,K)) Q:'K  S X=^(K,0),^TMP($J,2,X)=""
 .S D1="" F  S D1=$O(^TMP($J,1,D1)) Q:D1=""  S D2="" F  S D2=$O(^TMP($J,2,D2)) Q:D2=""  S ^PS(56,"APD",D1,D2,DA)="",^PS(56,"APD",D2,D1,DA)=""
 K D1,D2,DA,I1,I11,I2,I22,J,J1,K,NA,PSN,X,^TMP($J) Q
