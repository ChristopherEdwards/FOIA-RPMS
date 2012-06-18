AMQQPOST ;IHS/CMI/THL - POST INSTALL ROUTINE;
 ;;2.0;IHS PCC SUITE;**2,7**;MAY 14, 2009
 ;PATCH XXX
 ;-----
ENV ;EP 
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"),XPDDIQ("XPI1"),XPDDIQ("XPO1"))=0
 D PRE
 Q
PRE ;EP;FOR PRE-INSTALL
 N X,Y,Z
 F X=1,5 D
 .S Y=0
 .F  S Y=$O(^AMQQ(X,Y)) Q:Y>999!'Y  K ^AMQQ(X,Y)
 .S Y="A"
 .F  S Y=$O(^AMQQ(X,Y)) Q:Y=""  K ^AMQQ(X,Y)
 Q
POST ;EP;
 D DATA
 F DIK="^AMQQ(1,","^AMQQ(5," D IXALL^DIK
 S DA=0
 F  S DA=$O(^AMQQ(5,DA)) Q:'DA  S X=$P(^(DA,0),U) D:X["  "
 .S DIE="^AMQQ(5,"
 .S DR=".01///^S X="""_$P(X,"  ")_""""
 .D ^DIE
 S DA=$O(^AUTTMSR("B","PA",0))
 Q:'DA!(DA=21)
 F J=1,2 D
 .S X=^AMQQ(1,725,J)
 .S X=$P(X,"AUPNVMSR;")_"AUPNVMSR;"_DA_$P(X,"AUPNVMSR;21",2)
 .S ^AMQQ(1,725,J)=X
 .I X["AMQP(0),21" S X=$P(X,"AMQP(0),")_"AMQP(0),"_DA_$P(X,"AMQP(0),21",2),^AMQQ(1,725,J)=X
 Q
DATA ;EP;TO RETRIEVE QMAN DATA
 N A,B,C,D,E,X,Y,Z,XX
 F XX=5,1 D
 .S DA=0
 .F  S DA=$O(^AMQQ(XX,DA)) Q:'DA!(DA>999)  D
 ..S DIK="^AMQQ("_XX_","
 ..D ^DIK
 S AMQQ="XPDI"
 S DA=""
 S X=0
 F  S X=$O(^XTMP(AMQQ,X)) Q:'X  D
 .S Y=0
 .F  S Y=$O(^XTMP(AMQQ,X,"BLD",Y)) Q:'Y  I $G(^(Y,0))["IHS PCC SUITE" S DA=X Q
 .;F  S Y=$O(^XTMP(AMQQ,X,"BLD",Y)) Q:'Y  I $G(^(Y,0))["AMQQ*2.0" S DA=X Q
 Q:'$G(DA)
 F XX=1,5 S FILE=9009070+XX D
 .S A=0
 .F  S A=$O(^XTMP(AMQQ,DA,"DATA",FILE,A)) Q:'A  D A
 Q
A ;
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A))=1 S ^AMQQ(XX,A)=^(A)
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,0))=1 S ^AMQQ(XX,A,0)=^(0)
 S B=0
 F  S B=$O(^XTMP(AMQQ,DA,"DATA",FILE,A,B)) Q:'B  D B
 Q
B ;
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,B))=1 S ^AMQQ(XX,A,B)=^(B)
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,B,0))=1 S ^AMQQ(XX,A,B,0)=^(0)
 S C=0
 F  S C=$O(^XTMP(AMQQ,DA,"DATA",FILE,A,B,C)) Q:'C  D C
 Q
C ;
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,B,C))=1 S ^AMQQ(XX,A,B,C)=^(C)
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,B,C,0))=1 S ^AMQQ(XX,A,B,C,0)=^(0)
 S D=0
 F  S D=$O(^XTMP(AMQQ,DA,"DATA",FILE,A,B,C,D)) Q:'D  D D
 Q
D ;
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,B,C,D))=1 S ^AMQQ(XX,A,B,C,D)=^(D)
 I $D(^XTMP(AMQQ,DA,"DATA",FILE,A,B,C,D,0))=1 S ^AMQQ(XX,A,B,C,D,0)=^(0)
 Q
