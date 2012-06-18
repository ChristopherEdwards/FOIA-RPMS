ASULDIRR ; IHS/ITSC/LMH -DIRECT LOOKUP REQUSITION RELATED ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides entry points to lookup
 ;entries in SAMS requsitioner related tables.
 ;**SELCAN & MULTCAN subroutines created to enable mult. can lookup LMH 
SST(X) ;EP ; DIRECT SUB STATION TABLE LOOKUP
 I X["PL" S X=999
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=ASUL(1,"AR","AP")_"0"_X
 I X'?5N D  Q
 .S Y=-4 Q  ;Input paramater did not pass Sub Station IEN edit
 I $D(^ASUL(18,X,0)) D
 .S (Y,ASUL(18,"SST","E#"))=X ;Record found for input parameter
 .S ASUL(18,"SST")=$P($G(^ASUL(18,X,1)),U)
 .S ASUL(18,"SST","NM")=$P($G(^ASUL(18,X,0)),U)
 E  D
 .S ASUL(18,"SST","E#")=X ;IEN to use for LAYGO call
 .S ASUL(18,"SST")=$E(ASUL(18,"SST","E#"),4,5)
 .S:'$D(ASUL(18,"SST","NM")) ASUL(18,"SST","NM")="UNKNOWN"
 .S Y=-1 ;No record found for Input parameter
 Q
USR(X) ;EP ; DIRECT USER TABLE LOOKUP
USRX ;
 I '$G(ASUL(22,"PGM","E#")),X]"" D  Q:$G(Y)'=ASUL(22,"PGM","E#")
 .S X(22)=$S(X'?6N:$E(X,1,2),1:$E(X,3,4)) S:X="00" X=100
 .D PGM($E(X(22),1,2))
 I $L(X)=3,X?2N.1AN S ASUL(19,"USR")=X D USR^ASULALGO(.X) Q:Y<0  ;Translate 3 digit user code to IEN
 I $L(X)=4 S X=ASUL(1,"AR","AP")_X
 I X'?6N D  Q
 .S Y=-4 Q  ;Input paramater did not pass User IEN edit
 I $D(^ASUL(19,X,0)) D
 .S (Y,ASUL(19,"USR","E#"))=X ;Record found for input parameter
 .S ASUL(19,"USR")=$P(^ASUL(19,X,1),U)
 .S ASUL(19,"USR","NM")=$P(^ASUL(19,X,0),U)
 E  D
 .S ASUL(19,"USR","E#")=X ;IEN to use for LAYGO call
 .I '$D(ASUL(19,"USR","NM")) S ASUL(19,"USR","NM")=$G(ASUL(22,"PGM","NM"))
 .S Y=-1 ;No record found for Input parameter
 Q
REQ(X) ;EP ; DIRECT REQUISTIONER TABLE LOOKUP
 I $G(ASUL(18,"SST","E#"))="" D  Q:$G(Y)<0
 .I X?9N S ASUL(18,"SST","E#")=$E(X,1,5) Q
 .S Y=-10 ;Must have Sub Station
 I $G(ASUL(18,"SST"))="" S X(1)=ASUL(18,"SST","E#") D SST(X(1))
 I $G(ASUL(19,"USR","E#"))="" D  Q:Y'=$G(ASUL(19,"USR","E#"))
 .I X?9N S X(1)=X,(X,ASUL(19,"USR","E#"))=$E(X(1),1,2)_$E(X(1),6,9) D USR(X) S X=X(1) Q
 .D USRX
 I $G(ASUL(19,"USR"))="" S X(1)=ASUL(19,"USR","E#") D USR(X(1))
 S X=ASUL(18,"SST","E#")_$E(ASUL(19,"USR","E#"),3,6)
 I X'?9N D  Q
 .S Y=-4 Q  ;Input paramater did not pass User IEN edit
 S ASUL(20,"REQ")=ASUL(19,"USR")
 I $D(^ASUL(20,X,0)) D
 .S (Y,ASUL(20,"REQ","E#"))=X ;Record found for input parameter
 .S ASUL(20,"REQ","NM")=$P(^ASUL(20,X,0),U)
 .S ASUL(20,"ULVQ FCTR")=$P($G(^ASUL(20,X,1)),U)
 .N Z S Z=0
 .;F ASUC("SSA")=1:1 S Z=$O(^ASUL(20,ASUL(20,"REQ","E#"),2,"C",Z)) I ASUC("SSA")>1 D MULTCAN K ASUC("SSA"),ASUL("SSA") Q  Q:Z=""  D
 .F ASUC("SSA")=1:1 S Z=$O(^ASUL(20,ASUL(20,"REQ","E#"),2,"C",Z)) Q:Z=""  D
 ..S ASUL(20,"SSA")=Z,ASUL(20,"SSA","CNT")=ASUC("SSA")
 ..S ASUL("SSA","E#")=$O(^ASUL(20,ASUL(20,"REQ","E#"),2,"C",ASUL(20,"SSA"),0))
 ..S ASUL(20,"CAN",ASUL(20,"SSA"))=$P(^ASUL(20,ASUL(20,"REQ","E#"),2,ASUL("SSA","E#"),0),U)
 .I $G(ASUL(20,"SSA","CNT"))>1 D MULTCAN  ;WAR 11/26/99 
 .K ASUC("SSA"),ASUL("SSA")
 E  D
 .S ASUL(20,"REQ","E#")=X ;IEN to use for LAYGO call
 .S ASUL(20,"ULVQ FCTR")=""
 .S ASUL(20,"REQ","NM")=ASUL(19,"USR","NM")_" @ "_ASUL(18,"SST","NM")
 .S Y=-1 ;No record found for Input parameter
 Q
 ;
MULTCAN ; Allows selection of multiple CANs
 ;
 I $G(ASUDDS)=1 D
 .S DA(1)=ASUL(20,"REQ","E#")
 .S DIC="^ASUL(20,"_DA(1)_",2,"
 .S DIC(0)="AEMQL"
 .I ASUT("TRCD")["0" W !!!! S DIC("A")="Enter a ""??"" and select a CAN: "
 .W !!!! S DIC("A")="Enter a ""??"" and select a CAN: "
 .D ^DIC
 .I +$G(Y)>0 D SELCAN
 Q
 ;
SELCAN ; If there are multiple CANs, uses selection for transaction  
 ;
 S ASUL("SSA","E#")=+Y
 S ASUL(20,"SSA")=$P(^ASUL(20,ASUL(20,"REQ","E#"),2,ASUL("SSA","E#"),0),U,2)
 S ASUL(20,"CAN",ASUL(20,"SSA"))=$P(^ASUL(20,ASUL(20,"REQ","E#"),2,ASUL("SSA","E#"),0),U)
 K ASUC("SSA"),ASUL("SSA")
 Q
SSA(X) ;EP ; DIRECT SUB-SUB ACTVITY TABLE LOOKUP
 I X'?1N.N D
 .S Y=-4 Q  ;Input paramater did not pass Sub-sub activity IEN edit
 S:+X=0 X=100
 I $D(^ASUL(17,+X,0)) D
 .S (Y,ASUL(17,"SSA","E#"))=+X ;Record found for input parameter
 .S ASUL(17,"SSA")=$P(^ASUL(17,+X,1),U)
 .S ASUL(17,"SSA","NM")=$P(^ASUL(17,+X,0),U)
 E  D
 .S ASUL(17,"SSA","E#")=+X ;IEN to use for LAYGO call
 .S ASUL(17,"SSA")="N/F"
 .S ASUL(17,"SSA","NM")="UNKNOWN"
 .S Y=-1 ;No record found for Input parameter
 Q
PGM(X) ;EP ; DIRECT PROGRAM TABLE LOOKUP
PGMX ;
 I +X=0 S X=100
 I $D(^ASUL(22,+X,0)) D
 .S (Y,ASUL(22,"PGM","E#"))=+X ;Record found for input parameter
 .S ASUL(22,"PGM")=$P(^ASUL(22,+X,0),U)
 .S ASUL(22,"PGM","NM")=$P(^ASUL(22,+X,0),U,2)
 E  D
 .I X="" S Y=-2 Q
 .S ASUL(22,"PGM","E#")=+X ;IEN to use for LAYGO call
 .S ASUL(22,"PGM")="N/F"
 .S ASUL(22,"PGM","NM")="UNKNOWN"
 .S Y=-1 ;No record found for Input parameter
 Q
SLC(X) ;EP;.
 S:X]"" ASUL(10,"SLC","E#")=$O(^ASUL(10,"B",X,""))
 I $G(ASUL(10,"SLC","E#"))="" S ASUL(10,"SLC","NM")="UNKNOWN",ASUL(10,"SLC")=" ",ASUL(10,"SLC","E#")="" Q
 S ASUL(10,"SLC","NM")=$P(^ASUL(10,ASUL(10,"SLC","E#"),0),U,2)
 S ASUL(10,"SLC")=X
 Q
