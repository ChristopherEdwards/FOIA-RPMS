ASUMDIRA ; IHS/ITSC/LMH -DIRECT ADD RECORD ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides entry points to verify and
 ;assign internal entry numbers and add new entries into SAMS Station
 ;(in ^ASUMS) and Index (in ^ASUMX) Master files and the Sub Station
 ;table (in ^ASUL(18)).
DIS(X) ;EP ; ADD NEW RECORD STATION MASTER
 ;Error conditions passed back in 'Y'
 ;  -1 : Failed IEN edit
 ;  -2 : IEN not for Area signed into KERNEL with (DUZ 2)
 I $G(X)']"" S X=$G(ASUL(2,"STA","E#"))
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=ASUL(1,"AR","AP")_"0"_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-2 Q  ;Not for Area Signed on as
 I X'?5N S Y=-1 Q  ;Failed IEN edit
 S ^ASUMS(X,0)=X_U_$E(X,1,2)
 S ^ASUMS(X,1,0)="^9002031.02PA^"
 ;Add one to the count of Stations
 S $P(^ASUMS(0),U,4)=$P(^ASUMS(0),U,4)+1
 ;Set last station updated piece
 S $P(^ASUMS(0),U,3)=X
 S DA=X,DIK="^ASUMS(" D IX^DIK K DIK,DA
 S Y=+X
 Q
SST(X) ;EP ; ADD NEW RECORD SUB STATION
 ;Error conditions passed back in 'Y'
 ;  -1 : Failed IEN edit
 ;  -2 : IEN not for Area signed into KERNEL with (DUZ 2)
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=ASUL(1,"AR","AP")_"0"_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-2 Q  ;Not for Area Signed on as
 I X'?5N S Y=-1 Q  ;Failed IEN edit
 I $G(X(1))="" S Y=-3 Q
 S ^ASUL(18,X,0)=X(1)_U_$E(X,1,2)
 S ^ASUL(18,X,1)=$E(X,4,5)
 ;Add one to the count of Sub Stations
 S $P(^ASUL(18,0),U,4)=$P(^ASUL(18,0),U,4)+1
 ;Set last sub station updated piece
 S $P(^ASUL(18,0),U,3)=X
 S DA=X,DIK="^ASUL(18," D IX^DIK K DIK,DA
 Q
DISX(X) ;EP ; ADD NEW RECORD STATION MASTER
 ;Error conditions passed back in 'Y'
 ;  -1 : Failed IEN edit
 ;  -2 : IEN not for Area signed into KERNEL with (DUZ 2)
 ;  -3 : No Index Master found for Index # add requested for
 ;  -4 : Station Index master already on file
 ;  -7 : Station IEN Index to be added to not in ASUMS variable
 ;  -9 : Index # requested was assigned to a deleted item not yet
 ;        available for re-use
 I '$D(ASUMS("E#","STA")) S ASUMS("E#","STA")=$G(ASUL(2,"STA","E#"))
 I $L(X)=6 S X=ASUL(1,"AR","AP")_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-2 Q  ;Not for Area Signed on as
 I X'?8N S Y=-1 Q  ;Failed IEN edit
 I '$D(^ASUMX(X,0)) S Y=-3 Q  ;No Index master
 I $P(^ASUMX(X,0),U)']"" S Y=-8 Q  ;Deleted Index master
 I $D(^ASUMS(ASUMS("E#","STA"),1,X,0)) D  Q:Y<0
 .I $P(^ASUMS(ASUMS("E#","STA"),1,X,0),U)[999999 D  ;Deleted Station Index
 ..I ASUK("DT","YRMO")-$P(^ASUMS(ASUMS("E#","STA"),1,X,0),U,2)<300 S Y=-9
 ..E  K ^ASUMS(ASUMS("E#","STA"),1,X)
 .E  S Y=-4 ;Station Index master already on file
 S ASUMS("E#","IDX")=X
 S ^ASUMS(ASUMS("E#","STA"),1,X,0)=X,^ASUMS(ASUMS("E#","STA"),1,X,1,0)="^9002031.232A^12^12",^ASUMS(ASUMS("E#","STA"),1,X,2)=""
 F V=0:1:12 S ^ASUMS(ASUMS("E#","STA"),1,X,1,V,0)=V
 ;Add one to the count of index records for this Station
 S $P(^ASUMS(ASUMS("E#","STA"),1,0),U,4)=$P(^ASUMS(ASUMS("E#","STA"),1,0),U,4)+1
 ;Set last index updated piece
 S $P(^ASUMS(ASUMS("E#","STA"),1,0),U,3)=X
 S DA=X,DA(1)=ASUMS("E#","STA"),DIK="^ASUMS(DA(1),1," D IX^DIK K DIK,DA
 Q
DIX(Z) ;EP ; ADD NEW RECORD INDEX MASTER
 ;Error conditions passed back in 'Y'
 ;  -1 : Failed IEN edit
 ;  -2 : IEN not for Area signed into KERNEL with (DUZ 2)
 N X
 S X=$G(Z(Z,"PT","IDX"))
 I X="" D
 .S X=Z(Z,"AR")_Z(Z,"IDX")
 ;S X=Z(Z,"IDX") S:X']"" X=Z(Z,"PT","IDX")
 ;I $L(X)=6 S X=ASUL(1,"AR","AP")_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-2 Q
 I X'?8N S Y=-1 Q
 S ^ASUMX(X,0)=Z(Z,"IDX")_U_Z(Z,"DESC")_U_Z(Z,"BCD")_U_Z(Z,"AR U/I")_U_Z(Z,"NSN")_U_Z(Z,"ACC")_U_Z(Z,"SOBJ")_U_Z(Z,"CAT")_U_Z(Z,"DTS")_U_U_Z(Z,"AR")
 S ^ASUMX(X,2)=U_U_U_U_Z(Z,"PT","ACC")_U_Z(Z,"PT","SOBJ")_U_Z(Z,"PT","CAT")
 ;Add one to the count of index records
 S $P(^ASUMX(0),U,4)=$P(^ASUMX(0),U,4)+1
 ;Set last index updated piece
 S $P(^ASUMX(0),U,3)=X
 S DA=X,DIK="^ASUMX(" D IX^DIK K DIK,DA
 Q
