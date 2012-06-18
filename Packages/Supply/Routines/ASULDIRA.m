ASULDIRA ; IHS/ITSC/LMH -DIRECT ADD TABLE RECORD ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides entry points to add new
 ;entries into SAMS tables.
SST(X) ;EP ; ADD NEW RECORD SUB STATION TABLE
 ;Error conditions passed back in 'Y'
 ;  -1 : Failed IEN edit
 ;  -2 : IEN not for Area signed into KERNEL with (DUZ 2)
 K Y
 I X["PL" S X=999,X(1)="OEH 121 PROJECTS"
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=ASUL(1,"AR","AP")_"0"_X
 ;I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-2 Q  ;Not for Area Signed on as
 I X'?5N S Y=-1 Q  ;Failed IEN edit
 I $G(X(1))="" S X(1)=$P($G(^ASUL(2,X,0)),U) S:X(1)']"" X(1)="UNKNOWN"
 S ^ASUL(18,X,0)=X(1)_U_$E(X,1,2)
 S ^ASUL(18,X,1)=$S($E(X,3,5)=999:"PL",1:$E(X,4,5))
 ;Add one to the count of Sub Stations
 S $P(^ASUL(18,0),U,4)=$P(^ASUL(18,0),U,4)+1
 ;Set last sub station updated piece
 S $P(^ASUL(18,0),U,3)=X
 D SST^ASULDIRR(X)
 S DA=X,DIK="^ASUL(18," D IX^DIK K DIK,DA
 Q
USR(X) ;EP ; ADD NEW RECORD USER TABLE
 ;Error conditions passed back in 'Y'
 ;  -1 : Failed IEN edit
 ;  -2 : IEN not for Area signed into KERNEL with (DUZ 2)
 K Y
 I $L(X)=3 S ASUL(19,"USR")=X D USR^ASULALGO(.X) S X=ASUL(1,"AR","AP")_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-2 Q  ;Not for Area Signed on as
 S X(2)=$E(X,3,4) S:X(2)="00" X(2)=100
 I $G(^ASUL(22,+(X(2)),0))']"" S Y=-4 Q  ;Not valid Program code
 I X'?6N S Y=-1 Q  ;Failed IEN edit
 I $G(X(1))="" S X(1)=$G(ASUL(22,"PGM","NM")) S:X(1)']"" X(1)="UNKNOWN"
 S ^ASUL(19,X,0)=X(1)_U_ASUL(1,"AR","AP")_U_+($E(X,3,4))
 S ^ASUL(19,X,1)=ASUL(19,"USR")
 S $P(^ASUL(19,0),U,4)=$P(^ASUL(19,0),U,4)+1 ;Add one to User count
 S $P(^ASUL(19,0),U,3)=X ;Set last User updated piece
 D USR^ASULDIRR(X)
 S DA=X,DIK="^ASUL(19," D IX^DIK K DIK,DA
 Q
REQ(X) ;EP ; ADD NEW RECORD REQUSITIONER TABLE
 ;Error conditions passed back in 'Y'
 ;  -11 : Failed IEN edit
 ;  -12 : IEN not for Area signed into KERNEL with (DUZ 2)
 K Y
 I $G(ASUL(18,"SST","E#"))']"" D
 .I X?9N D
 ..S ASUL(18,"SST","E#")=$E(X,1,5) D SST(ASUL(18,"SST","E#")) Q:Y>0
 ..S ASUL(19,"USR","E#")=$E(X,1,2)_$E(X,6,0) D USR(ASUL(19,"SST","E#")) Q:Y>0
 .E  D
 ..S Y=-14 Q
 I $L(X)=3 D  Q:+Y<0  S X=ASUL(18,"SST","E#")_$E(ASUL(19,"USR","E#"),3,6)
 .D USR^ASULDIRR(X)
 ;I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-12 Q  ;Not for Area Signed on as
 I X'?9N S Y=-11 Q  ;Failed IEN edit
 I $G(X(1))="" S X(1)=ASUL(19,"USR","NM")_" @ "_ASUL(18,"SST","NM")
 S ^ASUL(20,X,0)=X(1)_U_ASUL(19,"USR","E#")_U_ASUL(18,"SST","E#")_U_ASUL(1,"AR","AP")
 ;The following line put something into the 2nd piece which is not
 ;defined in the DD.  The Var X(3) does seem to get defined during the
 ;running of the conversion.
 S ^ASUL(20,X,1)=$S($G(X(3))]"":X(3),ASUL(1,"AR","AP")=59:2,1:"1.5")
 ;Add one to the count of requsitioners
 S $P(^ASUL(20,0),U,4)=$P(^ASUL(20,0),U,4)+1
 ;Set last requsitioner updated piece
 S $P(^ASUL(20,0),U,3)=X
 ;S ^ASUL(20,X,2,0)="9002039.2I^0^0"   ;LMH  2/22/2000
 D REQ^ASULDIRR(X)
 S DA=X,DIK="^ASUL(20," D IX^DIK K DIK,DA
 Q
