AUM101R1 ;IHS/SD/DMJ,SDR - ICD 9 CODES FOR FY 2010 ; [ 08/18/2003  11:02 AM ]
 ;;10.2;TABLE MAINTENANCE;;MAR 09, 2010
 ;
ADDFAIL D RSLT($J("",5)_$$M(0)_"ADD FAILED => "_L)
 Q
DASH D RSLT(""),RSLT($$REPEAT^XLFSTR("-",$S($G(IOM):IOM-10,1:70))),RSLT("")
 Q
DIE ;EP
 NEW @($P($T(SVARS^AUM101RL),";",3))
 LOCK +(@(DIE_DA_")")):10 E  D RSLT($J("",5)_$$M(0)_"Entry '"_DIE_DA_"' IS LOCKED.  NOTIFY PROGRAMMER.") S Y=1 Q
 D ^DIE LOCK -(@(DIE_DA_")")) KILL DA,DIE,DR
 Q
DIK NEW @($P($T(SVARS^AUM101RL),";",3)) D ^DIK KILL DIK
 Q
FILE NEW @($P($T(SVARS^AUM101RL),";",3)) K DD,DO S DIC(0)="L" D FILE^DICN KILL DIC
 Q
M(%) Q $S(%=0:"ERROR : ",%=1:"NOT ADDED : ",1:"")
MODOK D RSLT($J("",5)_"Changed : "_L)
 Q
RSLT(%) S ^(0)=$G(^TMP("AUM2104",$J,0))+1,^(^(0))=% D MES(%)
 Q
MES(%) NEW @($P($T(SVARS^AUM101RL),";",3)) D MES^XPDUTL(%)
 Q
IXDIC(DIC,DIC0,D,X,DLAYGO,DINUM) ;EP
 NEW @($P($T(SVARS^AUM101RL),";",3))
 S DIC(0)=DIC0
 KILL DIC0
 I '$G(DLAYGO) KILL DLAYGO
 I X[" " S X(1)=X,X=+$G(X)
 D IX^DIC
 Q Y