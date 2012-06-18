ASUMDIRM ; IHS/ITSC/LMH -DIRECT LOOK UP RECORD ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is a utility which provides entry points to lookup
 ;entries in SAMS Station (in ^ASUMS) and Index (in ^ASUMX) Master
 ;files.
DIS(X) ;EP ; DIRECT STATION MASTER LOOKUP
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=$S(X="PL":ASUL(1,"AR","AP")_999,1:ASUL(1,"AR","AP")_"0"_X)
 I X'?5N D  Q
 .S Y=-4 Q  ;Input paramater did not pass Station IEN edit
 I $D(^ASUMS(X,0)) D
 .S (Y,ASUMS("E#","STA"))=X ;Record found for input parameter
 .S:$P(^ASUMS(Y,0),U)="" Y=-9 ;Deleted Station Master
 E  D
 .S ASUMS("E#","STA")=X ;IEN to use for LAYGO call
 .S Y=-1 ;K ASUMS("E#","STA") No record found for Input parameter
 Q
DISX(X) ;EP ; DIRECT STATION MASTER INDEX LOOKUP -MUST HAVE IEN FOR STATION
 ;WAR 4/21/99 - rewrote this paragraph - it was never being called
 S ASUMS(0)=$G(^ASUMS(ASUL(2,"STA","E#"),1,X,0))  ;X=Area Code_IDX#
 S ASUMS(2)=$G(^ASUMS(ASUL(2,"STA","E#"),1,X,2))
 I ASUMS(0)'="" D  ;$D(^ASUMS(ASUL(2,"STA","E#"),1,X,0)) D 
 .I $P(ASUMS(0),U)'[999999 D
 ..S Y=X             ;Y is used by calling Rtn (ASUJVALF)
 ..I +$P(ASUMS(0),U,17)=0 D
 ...I '$P(ASUMS(0),U,18)&('$P(ASUMS(0),U,23))&('$P(ASUMS(0),U,28))&('$P(ASUMS(2),U,2)) D
 ....;Nothing for now, delete is performed in ASU5SUPD
 ....;S $P(^ASUMS(ASUL(2,"STA","E#"),1,X,0),U)=ASUL(1,"AR","E#")_999999
 ....;S DIK="^ASUMS("_ASUL(2,"STA","E#")_",1,"
 ....;S DA=X,DA(1)=ASUL(2,"STA","E#")
 ....;D IX^DIK K DIK,DA
 ....;these next 4 lines would allow FM to do the Del & Re-ndx
 ....;S DIE="^ASUMS("_ASUL(2,"STA","E#")_",1,"
 ....;S DA=X,DA(1)=ASUL(2,"STA","E#")
 ....;S DR=".01///"_$E(X,3,7)_"."_$E(X,8)
 ....;D ^DIE
 ...E  D
 ....I ASUJ=5 D CHKSTA                  ;Due ins are not 0
 ..E  D
 ...I ASUJ=5 D CHKSTA                   ;Qty On Hand is not 0
 .E  D
 ..D IDXDL^ASUJHELP
 ..S Y=-9                               ;Already deleted
 E  D
 .I $G(ASUT("TRCD"))'="5A" D
 ..S Y=-1                               ;Record not found
 Q
CHKSTA ;
 I ASUT'="STA"&(ASUT'="STC")&(ASUT'="STB") D
 .D QTYORDI^ASUJHELP
 Q
DIX(X) ;EP ; DIRECT INDEX MASTER LOOKUP
 I $L(X)=6 S X=ASUL(1,"AR","AP")_X
 I X'?8N S Y=-4 Q  ;Input paramater did not pass Index IEN edit
 I $D(^ASUMX(X,0)) D
 .S (Y,ASUMX("E#","IDX"))=X ;Record found for input parameter
 .S:$P(^ASUMX(X,0),U)[999999 Y=-9 ;Deleted Index Master
 E  D
 .S Y=-1 K ASUMX("E#","IDX") ;No record found for Input parameter
 Q
