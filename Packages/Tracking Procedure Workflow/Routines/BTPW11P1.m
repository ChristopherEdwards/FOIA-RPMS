BTPW11P1 ;GDHS/HS/ALA-Patch 4 pre/post install program ; 29 Dec 2015  7:28 AM
 ;;1.1;CARE MANAGEMENT EVENT TRACKING;**1**;APR 1,2015;Build 5
 ;
PRE ;EP
 NEW DA,DIK
 ; Pre-delete all the events
 S DIK="^BTPW(90621,",DA=0
 F  S DA=$O(^BTPW(90621,DA)) Q:'DA  D ^DIK
 ; Pre-delete all the result types
 S DIK="^BTPW(90620.9,",DA=0
 F  S DA=$O(^BTPW(90620.9,DA)) Q:'DA  D ^DIK
 ; Pre-delete all the categories
 S DIK="^BTPW(90621.2,",DA=0
 F  S DA=$O(^BTPW(90621.2,DA)) Q:'DA  D ^DIK
 Q
 ;
POS ;EP
 ;Repoint taxonomies in 90621
 NEW EVT,TXN,TYP,ATXN,GLOB
 S EVT=0
 F  S EVT=$O(^BTPW(90621,EVT)) Q:'EVT  D
 . S TXN=0
 . F  S TXN=$O(^BTPW(90621,EVT,1,TXN)) Q:'TXN  D
 .. S TAX=$P(^BTPW(90621,EVT,1,TXN,0),U,1),TYP=$P(^(0),U,3)
 .. I TYP'=3 D
 ... S ATXN=$O(^ATXAX("B",TAX,""))
 ... S $P(^BTPW(90621,EVT,1,TXN,0),U,2)=ATXN_";ATXAX("
 .. I TYP=3 D
 ... S ATXN=$O(^ATXLAB("B",TAX,"")),GLOB=";ATXLAB("
 ... I ATXN="" S ATXN=$O(^ATXAX("B",TAX,"")),GLOB=";ATXAX(" I ATXN="" S GLOB=""
 ... S $P(^BTPW(90621,EVT,1,TXN,0),U,2)=ATXN_GLOB
 Q
 ;
EN ;EP
 ; Set BTPWRPC into BQIRPC
 NEW IEN,DA,X,DIC,Y
 S DA(1)=$$FIND1^DIC(19,"","B","BQIRPC","","","ERROR"),DIC="^DIC(19,"_DA(1)_",10,",DIC(0)="LMNZ"
 I $G(^DIC(19,DA(1),10,0))="" S ^DIC(19,DA(1),10,0)="^19.01IP^^"
 S X="BTPWRPC"
 D ^DIC I +Y<1 K DO,DD D FILE^DICN
 Q
