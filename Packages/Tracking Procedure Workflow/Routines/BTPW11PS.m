BTPW11PS ;VNGT/HS/BEE-Post Installation for CMET PATCH 1 ; 24 Apr 2008  7:46 PM
 ;;1.0;CARE MANAGEMENT EVENT TRACKING;**1**;Feb 07, 2011;Build 37
 ;
EN ;EP
 ;
 ; Check for missing Record File Type
 NEW N,DA,DIE,DR
 S N=0
 F  S N=$O(^BTPWQ(N)) Q:'N  D
 . I $P(^BTPWQ(N,0),"^",6)'="" Q
 . I $P(^BTPWQ(N,0),"^",4)="~" S DA=N,DR=".06////~",DIE="^BTPWQ(" D ^DIE
 . I $P(^BTPWQ(N,0),"^",10)'="" S DA=N,DR=".06////4",DIE="^BTPWQ(" D ^DIE
 ;
 S N=0
 F  S N=$O(^BTPWP(N)) Q:'N  I $G(^BTPWP(N,0))="" K ^BTPWP(N)
 ;
 ; Add BTPW entry to 90506.1
 F BI=1:1 S TEXT=$P($T(CMET+BI),";;",2) Q:TEXT=""  D
 . F BJ=1:1:$L(TEXT,"~") D
 .. NEW NDATA,ND,VAL
 .. S NDATA=$P(TEXT,"~",BJ)
 .. S ND=$P(NDATA,"|",1),VAL=$P(NDATA,"|",2)
 .. I ND=0 D
 ... NEW DIC,X,Y
 ... S DIC(0)="LQZ",DIC="^BQI(90506.1,",X=$P(VAL,U,1)
 ... D ^DIC
 ... S IEN=+Y
 ... I IEN=-1 K DO,DD D FILE^DICN S IEN=+Y
 .. I ND=1 S BQIUPD(90506.1,IEN_",",1)=VAL Q
 .. F BK=1:1:$L(VAL,"^") D
 ... S BN=$O(^DD(90506.1,"GL",ND,BK,"")) I BN="" Q
 ... I $P(VAL,"^",BK)'="" S BQIUPD(90506.1,IEN_",",BN)=$P(VAL,"^",BK) Q
 ... I $P(VAL,"^",BK)="" S BQIUPD(90506.1,IEN_",",BN)="@"
 . D FILE^DIE("","BQIUPD","ERROR")
 ;
 Q
 ;
CMET ; Add new CMET Items
 ;;0|BTPWNPEV^^Preceding Event^^^^^T01024BTPWNPEV~1|S VAL="" N VL S VL=$$GET1^DIQ(90620,TIEN_",",.11,"I") S:VL]"" VAL=$$FMTE^BQIUL1($$GET1^DIQ(90620,VL_",",.03,"I"))_$C(28)_$$GET1^DIQ(90620,VL_",",.01,"E")_$C(28)_VL~3|21^^^D^^^^^4~5|
 ;;
