ASUMBOIO ; IHS/ITSC/LMH -BACKORDER MASTER I/O ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides the ability to write to
 ;(update) and read (retrieve) from Backorder Master file (^ASUMB).
 ;A record entry number must be provided for Requsitioner
 ;(ASUMB("E#","REQ")) and Index (ASUMB("E#","IDX")).
READBO ;EP ;READ BACKORDER MASTER
 Q:$G(ASUMB("E#","REQ"))=""
 Q:$G(ASUMB("E#","IDX"))=""
 S ASUMB(1)=$G(^ASUMB(ASUMB("E#","REQ"),1,ASUMB("E#","IDX"),1))
 S ASUMB("E#","USR")=$P(^ASUL(20,ASUMB("E#","REQ"),0),U,2)
 S ASUMB("USR")=$P(^ASUL(19,ASUMB("E#","USR"),1),U)
 S ASUMB("USR","NM")=$P(^ASUL(19,ASUMB("E#","USR"),0),U)
 S ASUMB("IDX")=$E(ASUMB("E#","IDX"),3,8)
 S ASUMB("TRCD")=$P(ASUMB(1),U)
 S ASUMB("VOU")=$P(ASUMB(1),U,2)
 S ASUMB("QTYB/O")=$P(ASUMB(1),U,3)
 S ASUMB("CAN")=$P(ASUMB(1),U,4)
 S ASUMB("B/O")=$P(ASUMB(1),U,5)
 S ASUMB("QTYAJ")=$P(ASUMB(1),U,6)
 S ASUMB("ACC")=$P(ASUMB(1),U,7)
 S ASUMB("SSA")=$P(ASUMB(1),U,8)
 S ASUMB("CTG")=$P(ASUMB(1),U,9)
 S ASUMB("DT")=$P(ASUMB(1),U,10)
 S ASUMB("RQN")=$P(ASUMB(1),U,11)
 S ASUMB("REQTYP")=$P(ASUMB(1),U,12)
 S ASUMB("STA")=$P(ASUMB(1),U,13)
 S ASUMB("SST")=$P(ASUMB(1),U,14)
 S ASUMB("QTYISS")=$P(ASUMB(1),U,15)
 S ASUMB("SLC")=$P(ASUMB(1),U,16) D SLC^ASULDIRR(ASUMB("SLC")) S ASUMB("E#","SLC")=ASUL(10,"SLC","E#")
 S ASUMB("FPN")=$P(ASUMB(1),U,17)
 S ASUMB("DTPR")=$P(ASUMB(1),U,18)
 S ASUMB("UCS")=$P(ASUMB(1),U,19),ASUMB("VAL")=ASUMB("UCS")*ASUMB("QTYB/O")
 Q
WRITEBO ;EP ;BUILD NEW BACKORDER MASTER FROM ISSUE TRANSACTION
 Q:$G(ASUMB("E#","REQ"))=""
 Q:$G(ASUMB("E#","IDX"))=""
 S $P(ASUMB(1),U)=ASUT("TRCD")
 S ASUMB("VOU")=$S($E(ASUT(ASUT,"VOU"),5)<5:$E(ASUT(ASUT,"VOU"),5)+5,1:$E(ASUT(ASUT,"VOU"),5))
 S ASUMB("VOU")=$E(ASUT(ASUT,"VOU"),1,4)_ASUMB("VOU")_$E(ASUT(ASUT,"VOU"),6,8)
 S $P(ASUMB(1),U,2)=ASUMB("VOU")
 S $P(ASUMB(1),U,3)=ASUMB("QTYB/O")
 S $P(ASUMB(1),U,4)=ASUT(ASUT,"CAN")
 S $P(ASUMB(1),U,5)="B"
 S $P(ASUMB(1),U,6)=ASUT(ASUT,"QTY","ADJ")
 S $P(ASUMB(1),U,7)=ASUT(ASUT,"ACC")
 S $P(ASUMB(1),U,8)=ASUT(ASUT,"SSA")
 S $P(ASUMB(1),U,9)=ASUT(ASUT,"CTG")
 S $P(ASUMB(1),U,10)=ASUT(ASUT,"DTR")
 S $P(ASUMB(1),U,11)=ASUT(ASUT,"RQN")
 S $P(ASUMB(1),U,12)=ASUT(ASUT,"REQ TYP")
 S $P(ASUMB(1),U,13)=ASUT(ASUT,"STA")
 S $P(ASUMB(1),U,14)=$E(ASUMB("E#","REQ"),1,5)
 S $P(ASUMB(1),U,15)=ASUT(ASUT,"QTY","ISS")
 S $P(ASUMB(1),U,16)=ASUMS("SLC")
 S $P(ASUMB(1),U,17)=ASUT(ASUT,"FPN")
 S $P(ASUMB(1),U,18)=ASUK("DT","FM")
 S $P(ASUMB(1),U,19)=$G(ASUMB("UCS"))
 S ^ASUMB(ASUMB("E#","REQ"),1,ASUMB("E#","IDX"),0)=ASUMB("E#","IDX")
 D WNODE ;Write new node
 Q
UPDTBO ;EP ;UPDATE BACKORDER MASTER
 Q:$G(ASUMB("E#","REQ"))=""
 Q:$G(ASUMB("E#","IDX"))=""
 I ASUMB("VOU")'=$P(ASUMB(1),U,2) S $P(ASUMB(1),U,2)=ASUMB("VOU")
 I ASUMB("QTYB/O")'=$P(ASUMB(1),U,3) D
 .D KFAC^ASUMBOIO,KAC^ASUMBOIO ;Kill old quantity cross references before setting new quantity
 .S $P(ASUMB(1),U,3)=ASUMB("QTYB/O")
 I ASUMB("QTYAJ")'=$P(ASUMB(1),U,6) S $P(ASUMB(1),U,6)=ASUMB("QTYAJ")
 I ASUMB("ACC")'=$P(ASUMB(1),U,7) S $P(ASUMB(1),U,7)=ASUMB("ACC")
 I ASUMB("QTYISS")'=$P(ASUMB(1),U,15) S $P(ASUMB(1),U,15)=ASUMB("QTYISS")
 I ASUMB("FPN")'=$P(ASUMB(1),U,17) S $P(ASUMB(1),U,17)=ASUMB("FPN")
 I ASUMB("DTPR")'=$P(ASUMB(1),U,18) S $P(ASUMB(1),U,18)=ASUMB("DTPR")
WNODE ;EP ;
 S ^ASUMB(ASUMB("E#","REQ"),1,ASUMB("E#","IDX"),1)=ASUMB(1),$P(^ASUMB(ASUMB("E#","REQ"),0),U,3)=ASUMB("E#","IDX")
XRF ;
 S DA=ASUMB("E#","IDX"),DA(1)=ASUMB("E#","REQ"),DIK="^ASUMB("_DA(1)_",1,"
 D IX^DIK K DA,DIK ;New quantity cross references will be created here
 Q
REQADD(X) ;EP ; DIRECT USER ADD -MUST HAVE IEN FOR SUBSTATION
 ;Error conditions passed back in 'Y'
 ;  -3 : No Index Master found for Index # add requested for
 ;  -7 : IEN not for Area signed into KERNEL with (DUZ 2)
 ;  -8 : Failed IEN edit
 ;  -10 : Station IEN Index to be added to not in ASUMS variable
 I $L(X)=4 S X=$G(ASUL(2,"E#","SST"))_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-7 Q  ;Not for Area Signed on as
 I X'?9N S Y=-8 Q  ;Failed IEN edit
 I $D(^ASUMB(X,0)) S Y=0 Q  ;Requsitioner already on file
 S ASUMB("E#","REQ")=X
 S ^ASUMB(X,0)=X
 S ^ASUMB(X,1,0)="^9002035.01PA"
 ;Add one to the count of Requsitioners
 S $P(^ASUMB(0),U,4)=$P(^ASUMB(0),U,4)+1
 ;Set last Requsitioner updated piece
 S $P(^ASUMB(ASUMB("E#","REQ"),1,0),U,3)=X
 S DA=X
 S DIK="^ASUMB("
 D IX^DIK K DIK,DA
 Q
IDXADD(X) ;EP ; DIRECT INDEX ADD -MUST HAVE IEN FOR REQ
 I $G(ASUMB("E#","REQ"))="" S Y=-11 Q  ;Requsitioner IEN not available
 I X'?1N.N D DIX^ASUMDIRM(.X) Q:Y<0
 S ASUMB("E#","IDX")=X
 I $D(^ASUMB(ASUMB("E#","REQ"),1,X,0)) S Y=0 Q  ;IDX already on file
 S ^ASUMB(ASUMB("E#","REQ"),1,X,0)=X
 D WRITEBO^ASUMBOIO ;Set up new entry from issue transaction
 S $P(^ASUMB(ASUMB("E#","REQ"),1,0),U,4)=$P(^ASUMB(ASUMB("E#","REQ"),1,0),U,4)+1 ;Add one to the count of IDX for this Requsitioner
 S $P(^ASUMB(ASUMB("E#","REQ"),1,0),U,3)=X ;Set last IDX updated piece
 S DA=X,DA(1)=ASUMB("E#","REQ")
 S DIK="^ASUMB(DA(1),1,"
 D IX^DIK K DIK,DA
 Q
REQ(X) ;EP ; DIRECT USER LOOKUP -MUST HAVE IEN FOR SUBSTATION
 ;;This routine provides for the lookup of a Backorder record for a
 ;;Requsitioner and Index number. Since the Backorder file is primary
 ;;key is DINUM (has the exact same internal entry number) as an entry
 ;;in the EQUSITIONER TABLE, and that is based on SUB STATION & USER
 ;;codes, a Sub Station table lookup must have been made before calling
 ;;this User table lookup.  If the actual internal entry number is being
 ;;passed, verification of a back order for that ien is determined.
 I X'?9N D REQ^ASULDIRR(.X) Q:Y<0
 I $D(^ASUMB(X,0)) D
 .S (Y,ASUMB("E#","REQ"))=X ;Record found for input parameter
 E  D
 .S ASUMB("E#","REQ")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
IDX(X) ;EP ; DIRECT INDEX LOOKUP -MUST HAVE IEN FOR REQ
 I $G(ASUMB("E#","REQ"))="" S Y=-11 Q  ;Usr IEN not passed
 I X?1N.N D DIX^ASUMDIRM(.X) Q:Y<0
 I $D(^ASUMB(ASUMB("E#","REQ"),1,X,0)) D
 .;S (Y,ASUMB("E#","IDX"))=X ;Record found for input parameter
 .S Y=X  ;WAR 5/4/99
 .S ASUVOU=$P($G(^ASUMB(ASUMB("E#","REQ"),1,X,1)),U,2)  ;WAR 5/4/99
 E  D
 .S ASUMB("E#","IDX")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
KFAC ;EP; KILL FACILITY
 N X,Y
 I $G(DA)="" S DA=$G(ASUMB("E#","IDX"))
 I $G(DA(1))="" S DA=$G(ASUMB("E#","REQ"))
 Q:$G(DA)=""  Q:$G(DA(1))=""
 I '$D(ASUMB(1)) D
 .I $D(D) I D[U S ASUMB(1)=D Q
 .S ASUMB(1)=^ASUMB(DA(1),1,DA,1)
 .S $P(ASUMB(1),U,3)=$P(ASUMB(1),U,3)+$P(^ASUMB(DA(1),1,DA,1),U,15)
 K ^ASUMB("AC",DA,$P(ASUMB(1),U,3),DA(1),DA)
 I $G(ASUMB("E#","REQ"))="" K ASUMB(1)
 Q
KAC ;EP; KILL ACCOUNT
 N X,Y
 I $G(DA)="" S DA=$G(ASUMB("E#","IDX"))
 I $G(DA(1))="" S DA=$G(ASUMB("E#","REQ"))
 Q:$G(DA)=""  Q:$G(DA(1))=""
 I '$D(ASUMB(1)) D
 .I $D(D) I D[U S ASUMB(1)=D Q
 .S ASUMB(1)=^ASUMB(DA(1),1,DA,1)
 .S $P(ASUMB(1),U,3)=$P(ASUMB(1),U,3)+$P(^ASUMB(DA(1),1,DA,0),U,15)
 D QTY
 K ^ASUMB(DA(1),1,"AC",DA_ASUMB("B/OQ"),DA)
 I $G(ASUMB("E#","REQ"))="" K ASUMB(1)
 Q
SFAC ;EP ; SET FOR FACILITY
 N X,Y
 I $G(DA)="" S DA=$G(ASUMB("E#","IDX"))
 I $G(DA(1))="" S DA=$G(ASUMB("E#","REQ"))
 Q:$G(DA)=""  Q:$G(DA(1))=""
 S:'$D(ASUMB(1)) ASUMB(1)=^ASUMB(DA(1),1,DA,1)
 S ^ASUMB("AC",DA,$P(ASUMB(1),U,3),DA(1),DA)=""
 I $G(ASUMB("E#","IDX"))="" K ASUMB
 Q
SAC ;EP ; SET FOR ACCOUNT
 N X,Y
 I $G(DA)="" S DA=$G(ASUMB("E#","IDX"))
 I $G(DA(1))="" S DA=$G(ASUMB("E#","REQ"))
 Q:$G(DA)=""  Q:$G(DA(1))=""
 S:'$D(ASUMB(1)) ASUMB(1)=^ASUMB(DA(1),1,DA,1)
 D QTY
 S ^ASUMB(DA(1),1,"AC",DA_ASUMB("B/OQ"),DA)=""
 I $G(ASUMB("E#","IDX"))="" K ASUMB
 Q
QTY ;EP -GET PROPER LENGTH ON QUANTITY
 ;;This routine left zero fills the quantity being backored.
 S X=$P(ASUMB(1),U,4)*.000001
 I $L($P(X,".",2))<6 S Y=1_$P(X,".",2),Y=Y*1000000,X="."_$E(Y,2,7)
 S ASUMB("B/OQ")=$TR(X,".","*")
 Q
