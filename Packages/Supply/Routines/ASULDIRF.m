ASULDIRF ; IHS/ITSC/LMH -DIRECT LKUP FINANCE RELATED ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides entry points to lookup
 ;entries in SAMS finance related tables.
ACC(X) ;EP ; DIRECT ACCOUNT TABLE LOOKUP
 I $D(^ASUL(9,+X,0)) D
 .S (Y,ASUL(9,"ACC","E#"))=+X ;Record found for input parameter
 .S ASUL(9,"ACC")=$P(^ASUL(9,+X,0),U,2)
 .S ASUL(9,"ACC","NM")=$P(^ASUL(9,+X,0),U)
 .S ASUL(9,"ACG")=$S(ASUL(9,"ACC")=1:1,ASUL(9,"ACC")=3:3,1:"*") D ACGNM(ASUL(9,"ACG"))
 E  I X  D   ;IHS/DSD/JLG 5/6/99  Modified to only apply if X is true
 .S ASUL(9,"ACC","E#")=+X ;IEN to use for LAYGO call
 .S (ASUL(9,"ACC"),ASUL(9,"ACG"))="N/F"
 .S (ASUL(9,"ACC","NM"),ASUL(9,"ACG","NM"))="UNKNOWN"
 .S Y=-1 ;No record found for Input parameter
 E  D
 .;If X is not a valid ien value set the flag and make sure there is
 .;no left over values for the ASUL array.  It is possible this will not
 .;work out and may require something else to be done.
 .S Y=-1  ;X is not a valid ien
 .K ASUL(9,"ACC")
 Q
ACGNM(X) ;EP ; SET ACCOUNT GROUP NAME
 S:$G(ASUL(9,"ACG"))']"" ASUL(9,"ACG")=X
 I X="*" S ASUL(9,"ACG","NM")="GENERAL SUPPLIES" Q
 S ASUL(9,"ACG","NM")=$P(^ASUL(9,+X,0),U)
 Q
SOBJ(X) ;EP
 D SSO(.X)
 Q
SSO(X) ;EP ; STOCK SUB OBJECT TABLE LOOKUP
 ;Format of IEN: 1st digit=Account
 ;               digit 2-3 = digit 3-4 of Sub Object Code
 ;I (X?4N)!(X?1A.AN) D OBJ(3) I Y>0 S X=+Y
 D OBJ(3) I Y>0 S X=+Y
 I X']"" S Y=-10 K ASUL(3) Q
 I '$G(ASUL(9,"ACC","E#")) D
 .I $L(X)=3 D  Q:$G(Y)<0
 ..S X(1)=$E(X) D ACC(X(1)) K:Y<0 ASUL(3)
 E  D  Q:$G(Y)<0
 .;I ASUT("E#")=13 B
 .I $L(X)=3 D  Q:$G(Y)<0
 ..I ASUL(9,"ACC","E#")'=$E(X) S Y=-11 K ASUL(3) Q
 I X[".",$L(X)=5 S X=$E(X,5)
 I $L(X)=4 S X=$E(X,4)
 I $L(X)=1 D TR^ASULALGO(.X) S:Y>0 X=$G(ASUL(9,"ACC","E#"))_Y
 I $L(X)=3,$D(^ASUL(3,X,0)) D
 .S (Y,ASUL(3,"SOBJ","E#"))=X
 .S ASUL(3,"SOBJ","ACC")=ASUL(9,"ACC","E#")
 .S ASUL(3,"SOBJ","NM")=$P(^ASUL(3,Y,0),U)
 .S X=$P(^ASUL(3,Y,1),U),ASUL(3,"SOBJ","CD")=$E(X,1,2)_"."_$E(X,3,4)
 E  D
 .S ASUL(3,"SOBJ","NM")="UNKNOWN",ASUL(3,"SOBJ","CD")="NF",ASUL(3,"SOBJ","ACC")=""
 .S Y=-1
 Q
OBJ(Z) ;
 S DIC="^ASUL("_Z_",",DIC(0)="MS" D ^DIC
 ;I ASUT("E#")=13 B
 Q
DSO(X) ;EP ; DIRECT SUB OBJECT TABLE LOOKUP
 ;Format of IEN: 1st digit=Account
 ;               digit 2-3 = digit 3-4 of Sub Object Code
 ;I (X?4N)!(X?1A.AN) D OBJ(4) I Y>0 S X=+Y
 D OBJ(4) I Y>0 S X=+Y
 I X']"" S Y=-10 K ASUL(4) Q
 I '$G(ASUL(9,"ACC","E#")) D
 .I $L(X)=3 D  Q:$G(Y)<0
 ..S X(1)=$E(X) D ACC(X(1)) K:Y<0 ASUL(4)
 E  D  Q:Y<0
 .I $L(X)=3 D  Q:$G(Y)<0
 ..I ASUL(9,"ACC","E#")'=$E(X) S Y=-11 K ASUL(4) Q
 I X[".",$L(X)=5 S X=$E(X,5)
 I $L(X)=4 S X=$E(X,4)
 I $L(X)=1 D TR^ASULALGO(.X) S:Y>0 X=$G(ASUL(9,"ACC","E#"))_Y
 I $L(X)=3,$D(^ASUL(4,X,0)) D
 .S (Y,ASUL(4,"SOBJ","E#"))=X,ASUL(4,"SOBJ","ACC")=ASUL(9,"ACC","E#")
 .S ASUL(4,"SOBJ","NM")=$P(^ASUL(4,X,0),U)
 .S X=$P(^ASUL(4,Y,1),U),ASUL(4,"SOBJ","CD")=$E(X,1,2)_"."_$E(X,3,4)
 E  D
 .S ASUL(4,"SOBJ","NM")="UNKNOWN",ASUL(4,"SOBJ","CD")="NF",ASUL(4,"SOBJ","ACC")=""
 .S Y=-1
 Q
DCAN(X) ;EP ; DIRECT ISSUE COMMON ACCOUNTING NUMBER
 Q
SRC(X) ;EP ; DIRECT SOURCE TABLE LOOKUP
 ;I X?1AN D TR^ASULALGO(.X)
 ;I X?2N,$D(^ASUL(5,X,0)) D
 S Y=$O(^ASUL(5,"C",X,"")) I Y D
 .S ASUL(5,"SRC","E#")=Y ;Record found for input parameter
 .S ASUL(5,"SRC","NM")=$P(^ASUL(5,Y,0),U),ASUL(5,"SRC")=$P(^(0),U,2)
 E  D
 .S Y=-1 ;No record found for Input parameter
 Q
CAT(X) ;EP ; DIRECT CATEGORY TABLE LOOKUP
 ;Format of IEN - digits1-3 = IEN of Stock Sub Object (ASUL(3))
 ;                digits4-5 = Algolrythm of Category Code
 ;                ie 1=01,2=02,A=10,B=11
 I $G(ASUL(3,"SOBJ","E#"))']"" D  Q:Y<0
 .I X?5N S ASUL(3,"SOBJ","E#")=$E(X,1,3)
 E  D
 .K ASUL(7) S Y=-10 Q  ;Must have Stock Sub Object
 I $G(ASUL(3,"SOBJ","CD"))']"" S X(1)=ASUL(3,"SOBJ","E#") D SSO(X(1))
 I X?1AN D TR^ASULALGO(.X) S:Y>0 X=ASUL(3,"SOBJ","E#")_Y
 I X'?5N D  Q
 .S Y=-4 Q  ;Input paramater did not pass User IEN edit
 I $D(^ASUL(7,X,0)) D
 .S (Y,ASUL(7,"CAT","E#"))=X ;Record found for input parameter
 .S ASUL(7,"CAT","NM")=$P(^ASUL(7,X,0),U)
 .S ASUL(7,"CAT","CD")=$P(^ASUL(7,X,1),U)
 E  D
 .S ASUL(7,"CAT","E#")=X ;IEN to use for LAYGO call
 .S Y=-1 ;No record found for Input parameter
 Q
EOQT(X) ;EP ; DIRECT EOQ TABLE LOOKUP
 S ASUL(8,"EOQTB","E#")=X,Y=0
 I $D(^ASUL(8,X))'>0 S Y=-1 Q
 F  S Y=$O(^ASUL(8,X,1,Y)) Q:Y']""  D
 .S ASUL(8,"EOQTB",Y)=^ASUL(8,X,1,Y,0)
 Q
EOQ(X) ;EP ; DIRECT EOQ TYPE LOOKUP
 S Y=0
 I X?1A D
 .S ASUL(6,"EOQTP","E#")=$O(^ASUL(6,"B",X,""))
 E  D
 .S ASUL(6,"EOQTP","E#")=X
 I ASUL(6,"EOQTP","E#")'?1N.N S Y=-1 Q
 I $D(^ASUL(6,ASUL(6,"EOQTP","E#")))'>0 S Y=-2 Q
 S ASUL(6,"EOQTP")=$P($G(^ASUL(6,ASUL(6,"EOQTP","E#"),0)),U)
 S ASUL(6,"EOQTP","NM")=$P($G(^ASUL(6,ASUL(6,"EOQTP","E#"),0)),U,2)
 Q
