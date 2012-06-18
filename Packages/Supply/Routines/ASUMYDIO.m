ASUMYDIO ; IHS/ITSC/LMH -YTD ISSUE DATA MASTER I/O ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;;This routine is a utility routine which provides an entry point to
 ;;read (retreve) data from the SAMS YTD Issue Data Master file.
 ;;(in global ^ASUMY & VA Fileman file ASUMST YTD ISSUE DATA).
READ ;EP; TO SET YEAR TO DATE ISSUE DATA FIELDS
 I '$D(ASUMY("E#","REQ")) Q
 S ASUMY("E#","USR")=$P(^ASUL(20,ASUMY("E#","REQ"),0),U,2)
 S ASUMY("USR")=$P(^ASUL(19,ASUMY("E#","USR"),1),U)
 S ASUMY("USR","NM")=$P(^ASUL(19,ASUMY("E#","USR"),0),U)
 S ASUMY("E#","PGM")=+($P(^ASUL(19,ASUMY("E#","USR"),0),U,3))
 I ASUMY("E#","PGM")'>0 D
 .S ASUMY("PGM")=$E(ASUMY("USR"),1,2),ASUMY("PGM","NM")="UNKNOWN"
 E  D
 .S ASUMY("PGM")=$P(^ASUL(22,ASUMY("E#","PGM"),0),U)
 .S ASUMY("PGM","NM")=$P(^ASUL(22,ASUMY("E#","PGM"),0),U,2)
 S ASUMY(0,"REQ")=$G(^ASUMY(ASUMY("E#","REQ"),0))
 S ASUMY("E#","SST")=$P(^ASUL(20,ASUMY("E#","REQ"),0),U,3)
 S ASUMY("SST")=$P(^ASUL(18,ASUMY("E#","SST"),1),U)
 S ASUMY("SST","NM")=$P(^ASUL(18,ASUMY("E#","SST"),0),U)
 I '$D(ASUMY("E#","SSA")) Q
 S ASUMY("SSA")=$P(^ASUL(17,ASUMY("E#","SSA"),1),U)
 S ASUMY("SSA","NM")=$P(^ASUL(17,ASUMY("E#","SSA"),0),U)
 S ASUMY(0,"SSA")=$G(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),0))
 I '$D(ASUMY("E#","ACC")) Q
 S ASUMY(0)=$G(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"),1))
 I $D(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"),0)) D
 .S ASUMY("ACC")=$P(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"),0),U)
 E  D
 .S (ASUMY("ACC"),^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"),0))=ASUMY("E#","ACC")
 S ASUMY("CMO","RCR","VAL")=$P(ASUMY(0),U)
 S ASUMY("YTD","RCR","VAL")=$P(ASUMY(0),U,2)
 S ASUMY("YTD","NRC","VAL")=$P(ASUMY(0),U,3)
 S ASUMY("CMO","DIR","VAL")=$P(ASUMY(0),U,4)
 S ASUMY("YTD","DIR","VAL")=$P(ASUMY(0),U,5)
 S ASUMY("CMO","SCH","LI")=$P(ASUMY(0),U,6)
 S ASUMY("YTD","SCH","LI")=$P(ASUMY(0),U,7)
 S ASUMY("CMO","SCH","DOC")=$P(ASUMY(0),U,8)
 S ASUMY("YTD","SCH","DOC")=$P(ASUMY(0),U,9)
 S ASUMY("CMO","USC","LI")=$P(ASUMY(0),U,10)
 S ASUMY("YTD","USC","LI")=$P(ASUMY(0),U,11)
 S ASUMY("CMO","USC","DOC")=$P(ASUMY(0),U,12)
 S ASUMY("YTD","USC","DOC")=$P(ASUMY(0),U,13)
 S ASUMY("IS0","LI")=$P(ASUMY(0),U,14)
 S ASUMY("ISP","LI")=$P(ASUMY(0),U,15)
 S ASUMY("B/O","LI")=$P(ASUMY(0),U,16)
 S ASUMY("QTYADJ","LI")=$P(ASUMY(0),U,17)
 S ASUMY("CMO","DIR","LI")=$P(ASUMY(0),U,18)
 S ASUMY("YTD","DIR","LI")=$P(ASUMY(0),U,19)
 S ASUMY("CMO","DIR","DOC")=$P(ASUMY(0),U,20)
 S ASUMY("YTD","DIR","DOC")=$P(ASUMY(0),U,21)
 Q
WRITY ;EP ;WRITE YTD ISSUE DATA MASTER ASUMY("E#","REQ") REQUIRED
 S ASUMY("CHGD")=0
 I $P(ASUMY(0),U)'=ASUMY("CMO","RCR","VAL") S $P(ASUMY(0),U)=ASUMY("CMO","RCR","VAL"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,2)'=ASUMY("YTD","RCR","VAL") S $P(ASUMY(0),U,2)=ASUMY("YTD","RCR","VAL"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,3)'=ASUMY("YTD","NRC","VAL") S $P(ASUMY(0),U,3)=ASUMY("YTD","NRC","VAL"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,4)'=ASUMY("CMO","DIR","VAL") S $P(ASUMY(0),U,4)=ASUMY("CMO","DIR","VAL"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,5)'=ASUMY("YTD","DIR","VAL") S $P(ASUMY(0),U,5)=ASUMY("YTD","DIR","VAL"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,6)'=ASUMY("CMO","SCH","LI") S $P(ASUMY(0),U,6)=ASUMY("CMO","SCH","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,7)'=ASUMY("YTD","SCH","LI") S $P(ASUMY(0),U,7)=ASUMY("YTD","SCH","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,8)'=ASUMY("CMO","SCH","DOC") S $P(ASUMY(0),U,8)=ASUMY("CMO","SCH","DOC"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,9)'=ASUMY("YTD","SCH","DOC") S $P(ASUMY(0),U,9)=ASUMY("YTD","SCH","DOC"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,10)'=ASUMY("CMO","USC","LI") S $P(ASUMY(0),U,10)=ASUMY("CMO","USC","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,11)'=ASUMY("YTD","USC","LI") S $P(ASUMY(0),U,11)=ASUMY("YTD","USC","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,12)'=ASUMY("CMO","USC","DOC") S $P(ASUMY(0),U,12)=ASUMY("CMO","USC","DOC"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,13)'=ASUMY("YTD","USC","DOC") S $P(ASUMY(0),U,13)=ASUMY("YTD","USC","DOC"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,14)'=ASUMY("IS0","LI") S $P(ASUMY(0),U,14)=ASUMY("IS0","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,15)'=ASUMY("ISP","LI") S $P(ASUMY(0),U,15)=ASUMY("ISP","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,16)'=ASUMY("B/O","LI") S $P(ASUMY(0),U,16)=ASUMY("B/O","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,17)'=ASUMY("QTYADJ","LI") S $P(ASUMY(0),U,17)=ASUMY("QTYADJ","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,18)'=ASUMY("CMO","DIR","LI") S $P(ASUMY(0),U,18)=ASUMY("CMO","DIR","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,19)'=ASUMY("YTD","DIR","LI") S $P(ASUMY(0),U,19)=ASUMY("YTD","DIR","LI"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,20)'=ASUMY("CMO","DIR","DOC") S $P(ASUMY(0),U,20)=ASUMY("CMO","DIR","DOC"),ASUMY("CHGD")=1
 I $P(ASUMY(0),U,21)'=ASUMY("YTD","DIR","DOC") S $P(ASUMY(0),U,21)=ASUMY("YTD","DIR","DOC"),ASUMY("CHGD")=1
 I ASUMY("CHGD") D
 .S ^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"),1)=ASUMY(0)
 .S ^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,ASUMY("E#","ACC"),0)=ASUMY("E#","ACC")
 .S DA=ASUMY("E#","REQ"),DIK="^ASUMY(" D IX^DIK ;Re xref new record
 Q:$G(ASUMY("NOKL"))]""
 K ASUMY
 Q
WRITE(X) ;EP ;WITH PARAMETER PASSING
 S ASUMY("E#","REQ")=X
 G WRITY
ADDREQ(X) ;EP ; DIRECT REQUSITIONER ADD
 ;Error conditions passed back in 'Y'
 ;  -3 : No Index Master found for Index # add requested for
 ;  -4 : Station Index master already on file
 ;  -7 : IEN not for Area signed into KERNEL with (DUZ 2)
 ;  -8 : Failed IEN edit
 ;  -10 : Sub Station IEN Index to be added to not in ASUMS variable
 I X'?9N S Y=-8 Q  ;Failed IEN edit
 I $D(^ASUMY(X,0)) S Y=0 Q  ;Sub Station already on file
 S ^ASUMY(X,0)=X
 S ^ASUMY(X,1,0)="^9002034.01PA"
 S $P(^ASUMY(0),U,4)=$P(^ASUMY(ASUMY("E#","REQ"),1,0),U,4)+1 ;Add one to the count of Requsitioners
 S $P(^ASUMY(0),U,3)=X ;Set last Requsitioner updated piece
 S DA=X
 S DIK="^ASUMY("
 D IX^DIK K DIK,DA
 Q
ADDSSA(X) ;EP ; DIRECT SUBACTIVITY ADD -MUST HAVE IEN FOR REQ
 I $G(ASUMY("E#","REQ"))']"" S Y=-11 Q  ;Usr IEN not available
 I X'?1N.N D SSA^ASULDIRR(.X) Q:Y<0
 S ASUMY("E#","SSA")=+X
 I $D(^ASUMY(ASUMY("E#","REQ"),1,X,0)) S Y=0 Q  ;SSA already on file
 S ^ASUMY(ASUMY("E#","REQ"),1,X,0)=X
 S ^ASUMY(ASUMY("E#","REQ"),1,X,1,0)="^9002034.11PA"
 ;Add one to the count of SSActivities for this User
 S $P(^ASUMY(ASUMY("E#","REQ"),1,0),U,4)=$P(^ASUMY(ASUMY("E#","REQ"),1,0),U,4)+1
 ;Set last SSActivity updated piece
 S $P(^ASUMY(ASUMY("E#","REQ"),1,0),U,3)=X
 S DA=X,DA(1)=ASUMY("E#","REQ")
 S DIK="^ASUMY(DA(1),1,"
 D IX^DIK K DIK,DA
 Q
ADDACC(X) ;EP ; DIRECT ACCOUNT ADD -MUST HAVE IEN FOR REQ & SSA
 I $G(ASUMY("E#","REQ"))']"" S Y=-10 Q  ;Usr IEN not available
 I $G(ASUMY("E#","SSA"))']"" S Y=-11 Q  ;Subactivity IEN not available
 I X'?1N S Y=-4 Q  ;Input paramater did not pass Index IEN edit
 I X=0!(X>5&(X'=9)) S Y=-4 Q  ;Input paramater did not pass Index IEN edit
 I $D(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,X,0)) S Y=0 Q  ;SSA already on file
 S ^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,X,0)=X
 ;Add one to the count of Accounts for this SSActivities
 S $P(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,0),U,4)=$P(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,0),U,4)+1
 ;Set last SSActivity updated piece
 S $P(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,0),U,3)=X
 S DA=X,DA(1)=ASUMY("E#","SSA"),DA(2)=ASUMY("E#","REQ")
 S DIK="^ASUMY(DA(2),1,DA(1),1,"
 D IX^DIK K DIK,DA
 Q
REQ(X) ;EP ; DIRECT USER LOOKUP -MUST HAVE IEN FOR SUBSTATION
 I X'?9N D REQ^ASULDIRR(.X) Q:Y<0
 I $D(^ASUMY(X,0)) D
 .S (Y,ASUMY("E#","REQ"))=X ;Record found for input parameter
 E  D
 .S ASUMY("E#","REQ")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
SSA(X) ;EP ; DIRECT SUBACTIVITY LOOKUP -MUST HAVE IEN FOR SST & USR
 I $G(ASUMY("E#","REQ"))']"" S Y=-11 Q  ;Usr IEN not available
 I X?1N.N D SSA^ASULDIRR(.X) Q:Y<0
 S X=+X
 I $D(^ASUMY(ASUMY("E#","REQ"),1,X,0)) D
 .S (Y,ASUMY("E#","SSA"))=X ;Record found for input parameter
 E  D
 .S ASUMY("E#","SSA")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
ACC(X) ;EP ; DIRECT ACCOUNT LOOKUP -MUST HAVE IEN FOR SST USR & SSA
 I $G(ASUMY("E#","REQ"))']"" S Y=-11 Q  ;Usr IEN not available
 I $G(ASUMY("E#","SSA"))']"" S Y=-12 Q  ;Subactivity IEN not available
 I X'?1N S Y=-4 Q  ;Input paramater did not pass Index IEN edit
 I X=0!(X>5&(X'=9)) S Y=-4 Q  ;Input paramater did not pass Index IEN edit
 I $D(^ASUMY(ASUMY("E#","REQ"),1,ASUMY("E#","SSA"),1,X,0)) D
 .S (Y,ASUMY("E#","ACC"))=X ;Record found for input parameter
 E  D
 .S ASUMY("E#","ACC")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
