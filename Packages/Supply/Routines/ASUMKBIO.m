ASUMKBIO ; IHS/ITSC/LMH -SET FIELD VARIABLES ISSUE BOOK ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine provides an entry points to
 ;read (retreve) data from and write (store) data to the SAMS Issue
 ;Book Master file. Entry points are also provided to lookup and add
 ;records. A 'key' is be used to access each of the 3 levels.
 ;The 1st is STATION, a Station Table pointer; The 2nd is REQUSITIONER
 ;a Requsitioner Table pointer; the 3rd is INDEX NUMBER a ASUMST INDEX
 ;master file pointer.
READ ;EP;READ ISSUE BOOK
 Q:$G(ASUMK("E#","STA"))']""
 S ASUMK("STA")=$P(^ASUL(2,ASUMK("E#","STA"),1),U)
 S ASUMK("STA","NM")=$P(^ASUL(2,ASUMK("E#","STA"),0),U)
 Q:$G(ASUMK("E#","REQ"))']""
 D REQ^ASULDIRR(ASUMK("E#","REQ"))
 S ASUMK("E#","SST")=ASUL(18,"SST","E#")
 S ASUMK("SST")=ASUL(18,"SST")
 S ASUMK("SST","NM")=ASUL(18,"SST","NM")
 S ASUMK("E#","USR")=ASUL(19,"USR","E#")
 S ASUMK("USR")=ASUL(19,"USR")
 S ASUMK("USR","NM")=ASUL(19,"USR","NM")
 Q:$G(ASUMK("E#","IDX"))']""
 S ASUMK("IDX")=$E(ASUMK("E#","IDX"),3,8)
 S ASUMK(0)=$G(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"),0))
 S ASUMK(1)=$G(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"),1))
 S ASUMK(2)=$G(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"),2))
 S ASUMK("ULQTY")=$P(ASUMK(0),U,2)
 K ASUMK("TOT"),ASUMK("P6MO")
 F ASUU(17)=0:1:11 D
 .S:$G(ASUK("DT","MO"))']"" ASUK("DT","MO")=1
 .S ASUQ("MO")=ASUK("DT","MO")+ASUU(17)
 .S:ASUQ("MO")>12 ASUQ("MO")=ASUQ("MO")-12
 .S ASULMO(ASUU(17)+1)=ASUQ("MO")
 .S ASUMK(ASUQ("MO"),"DOC")=$P(ASUMK(1),U,ASUQ("MO"))
 .S ASUMK("TOT","DOC")=$G(ASUMK("TOT","DOC"))+ASUMK(ASUQ("MO"),"DOC")
 .S ASUMK(ASUQ("MO"),"QTY")=$P(ASUMK(2),U,ASUQ("MO"))
 .S ASUMK("TOT","QTY")=$G(ASUMK("TOT","QTY"))+ASUMK(ASUQ("MO"),"QTY")
 .I ASUU(17)>5 D
 ..S ASUMK("P6MO","QTY")=$G(ASUMK("P6MO","QTY"))+ASUMK(ASUQ("MO"),"QTY")
 ..S ASUMK("P6MO","DOC")=$G(ASUMK("P6MO","DOC"))+ASUMK(ASUQ("MO"),"DOC")
 K ASUU(17)
 I ASUMK("ULQTY")?1N.N D
 .S ASUMK("PULQTY")=1
 E  D
 .S ASUMK("PULQTY")=0
 .I ASUMK("E#","IDX")'=$G(ASUMS("E#","IDX")) D
 ..S ASUV("MOLD")=6
 .E  D
 ..S Y=$E(ASUMS("ESTB"),1,3)+1700
 ..S Y=ASUK("DT","YEAR")-Y
 ..S X=$E(ASUMS("ESTB"),4,5)
 ..S X=ASUK("DT","MO")-X
 ..S ASUMK("MOLD")=(Y*12)+X
 ..K X,Y
 ..S:ASUMK("MOLD")>6 ASUMK("MOLD")=6
 .I +$G(ASUMK("MOLD"))=0 S ASUMK("ULQTY")=0
 .E  S ASUMK("ULQTY")=$FN(ASUMK("P6MO","QTY")/ASUMK("MOLD"),"",0)
 .S ASUMK("ULQTY")=$FN(ASUMK("ULQTY")*ASUL(20,"ULVQ FCTR"),"",0)
 S ASUMK("CFY","VAL")=$P(ASUMK(0),U,3)
 S ASUMK("PFY","VAL")=$P(ASUMK(0),U,4)
 S ASUMK("PPY","VAL")=$P(ASUMK(0),U,5)
 K ASUQ("MO")
 Q
DISPLAY ;
 S X=0 F Y=10:10 S X=$O(ASUMK(X)) Q:X']""  D
 .W:$G(ASUMK(X))]"" ?Y,X," : ",ASUMK(X),"  "
 .S X(1)="" F  S X(1)=$O(ASUMK(X,X(1))) Q:X(1)']""  D
 ..W:X?1N.N "MO " W ?Y,X,",",X(1)," : ",ASUMK(X,X(1)),"  "
 Q
EN1 ;EP ; PRIMARY ENTRY POINT - ASUMY("E#","REQ") REQUIRED
 I '$D(ASUMK("E#","REQ")) Q
 I '$D(ASUMK("E#","STA")) Q
 I '$D(ASUMK("E#","IDX")) Q
 S ASUMK("CHGD")=0
 I ASUMK("PULQTY") D
 .I $P(ASUMK(0),U,2)'=ASUMK("ULQTY") S $P(ASUMK(0),U,2)=ASUMK("ULQTY"),ASUMK("CHGD")=1
 F ASUMK("MO")=1:1:12 D
 .I $P(ASUMK(1),U,ASUMK("MO"))'=ASUMK(ASUMK("MO"),"DOC") S $P(ASUMK(1),U,ASUMK("MO"))=ASUMK(ASUMK("MO"),"DOC"),ASUMK("CHGD")=1
 .I $P(ASUMK(2),U,ASUMK("MO"))'=ASUMK(ASUMK("MO"),"QTY") S $P(ASUMK(2),U,ASUMK("MO"))=ASUMK(ASUMK("MO"),"QTY"),ASUMK("CHGD")=1
 I $P(ASUMK(0),U,3)'=ASUMK("CFY","VAL") S $P(ASUMK(0),U,3)=ASUMK("CFY","VAL"),ASUMK("CHGD")=1
 I $P(ASUMK(0),U,4)'=ASUMK("PFY","VAL") S $P(ASUMK(0),U,4)=ASUMK("PFY","VAL"),ASUMK("CHGD")=1
 I $P(ASUMK(0),U,5)'=ASUMK("PPY","VAL") S $P(ASUMK(0),U,5)=ASUMK("PPY","VAL"),ASUMK("CHGD")=1
 I ASUMK("CHGD") D
 .I $D(^ASUMY(ASUMK("E#","REQ"),0)) D
 ..S DA=ASUMK("E#","REQ"),DIK="^ASUMK(" D ^DIK ;Delete old record and xrefs
 .S ^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"),0)=ASUMK(0)
 .S ^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"),1)=ASUMK(1)
 .S ^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"),2)=ASUMK(2)
 .S DA=ASUMK("E#","REQ"),DIK="^ASUMK(" D IX^DIK ;Re xref new record
 Q:$G(ASUMK("NOKL"))
 K ASUMK
 Q
WRITE(X) ;EP ;WITH PARAMETER PASSING
 S ASUMK("E#","REQ")=X
 G EN1
 Q
STA(X) ;EP ; DIRECT STA LOOKUP
 I X?5N D STA^ASULARST(.X) Q:Y<0
 I $D(^ASUMK(X,0)) D
 .S (Y,ASUMK("E#","STA"))=X ;Record found for input parameter
 E  D
 .S ASUMK("E#","STA")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
REQ(X) ;EP ; DIRECT USER LOOKUP -MUST HAVE IEN FOR SUBSTATION
 I $G(ASUMK("E#","STA"))']"" S Y=-10 Q  ;Station IEN not passed
 I X'?9N D REQ^ASULDIRR(.X) Q:Y<0
 I $D(^ASUMK(ASUMK("E#","STA"),1,X,0)) D
 .S (Y,ASUMK("E#","REQ"))=X ;Record found for input parameter
 E  D
 .S ASUMK("E#","REQ")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
IDX(X) ;EP ; DIRECT INDEX LOOKUP -MUST HAVE IEN FOR SST & USR
 I $G(ASUMK("E#","STA"))']"" S Y=-10 Q  ;Sub Station IEN not passed
 I $G(ASUMK("E#","REQ"))']"" S Y=-11 Q  ;Usr IEN not passed
 I X?1N.N D DIX^ASUMDIRM(.X) Q:Y<0
 I $D(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,X,0)) D
 .S (Y,ASUMK("E#","IDX"))=X ;Record found for input parameter
 E  D
 .S ASUMK("E#","IDX")=X ;IEN to use for LAYGO call
 .S Y=0 ;No record found for Input parameter
 Q
ADDSTA(X) ;EP ; DIRECT STATION ADD
 ;Error conditions passed back in 'Y'
 ;  -7 : IEN not for Area signed into KERNEL with (DUZ 2)
 ;  -8 : Failed IEN edit
 ;  -10 : Station IEN Index to be added to not in ASUMS variable
 I $L(X)=3 S X=ASUL(1,"AR","AP")_X
 I $L(X)=2 S X=ASUL(1,"AR","AP")_"0"_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-7 Q  ;Not for Area Signed on as
 I X'?5N S Y=-8 Q  ;Failed IEN edit
 I $D(^ASUMK(X,0)) S Y=0 Q  ;Station already on file
 S ASUMK("E#","STA")=X
 S ^ASUMK(X,0)=X ;Pointer to Station table
 S ^ASUMK(X,1,0)="^9002033.02PA"
 ;Add one to the count of Stations
 S $P(^ASUMK(0),U,4)=$P(^ASUMK(0),U,4)+1
 ;Set last Station updated piece
 S $P(^ASUMK(0),U,3)=X
 S DA=X
 S DIK="^ASUMK("
 D IX^DIK K DIK,DA
 Q
ADDREQ(X) ;EP ; DIRECT USER ADD -MUST HAVE IEN FOR SUBSTATION
 I $G(ASUMK("E#","STA"))']"" S Y=-10 Q  ;Station IEN not available
 I $L(X)=4 S X=$G(ASUL(2,"E#","SST"))_X
 I $E(X,1,2)'=ASUL(1,"AR","AP") S Y=-7 Q  ;Not for Area Signed on as
 I X'?9N S Y=-8 Q  ;Failed IEN edit
 I $D(^ASUMK(ASUMK("E#","STA"),1,X,0)) S Y=0 Q  ;Requsitioner on file
 S ASUMK("E#","REQ")=X
 S ^ASUMK(ASUMK("E#","STA"),1,X,0)=X
 S ^ASUMK(ASUMK("E#","STA"),1,X,1,0)="^9002033.21PA"
 ;Add one to the count of Requsitioner for this Station
 S $P(^ASUMK(ASUMK("E#","STA"),1,0),U,4)=$P(^ASUMK(ASUMK("E#","STA"),1,0),U,4)+1
 ;Set last Requsitioner updated piece
 S $P(^ASUMK(ASUMK("E#","STA"),1,0),U,3)=X
 S DA=X,DA(1)=ASUMK("E#","STA")
 S DIK="^ASUMK(DA(1),1,"
 D IX^DIK K DIK,DA
 Q
ADDIDX(X) ;EP ; DIRECT INDEX ADD -MUST HAVE IEN FOR STA & REQ
 I $G(ASUMK("E#","STA"))']"" S Y=-10 Q  ;Station IEN not available
 I $G(ASUMK("E#","REQ"))']"" S Y=-11 Q  ;Requsitioner IEN not available
 I X'?1N.N D DIX^ASUMDIRM(.X) Q:Y<0
 S ASUMK("E#","IDX")=X
 I $D(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,X,0)) S Y=0 Q  ;IDX on file
 S ^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,X,0)=X
 S ^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,X,1)=""
 S ^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,X,2)=""
 S $P(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,0),U,4)=$P(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,0),U,4)+1 ;Add one to the count of IDX for this Requsitioner
 S $P(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,0),U,3)=X ;Set last IDX updated piece
 S DA=X,DA(1)=ASUMK("E#","REQ"),DA(2)=ASUMK("E#","STA")
 S DIK="^ASUMK(DA(2),1,DA(1),1,"
 D IX^DIK K DIK,DA
 Q
