ASUJTRAN ; IHS/ITSC/LMH -SCREENMAN FOR DATA ENTRY ;  
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine will be used for transaction entry and review
 ;Modified in ENTR to enable multiple can selection  LMH 11/22/99
 D:'$D(U) ^XBKVAR D:'$D(ASUK) ^ASUVAR I $D(DUOUT)!($D(DTOUT))!($D(DIROUT)) Q
 I $G(ASUL(2,"STA","CD"))]"" D
 .W !!,"Data entry for Station: ",ASUL(2,"STA","NM")," - Code: ",ASUL(2,"STA","CD"),!
 E  D  Q:'$D(ASUL(2))
 .K DIR S DIR(0)="P^9002039.02",DIR("A")="Enter Station Code" D ^DIR
 .Q:$D(DTOUT)  Q:$D(DUOUT)  Q:Y<0
 .D STA^ASULARST(Y)
 W ! K DIR S DIR(0)="SB^1:DUE IN;2:RECEIPT;3:ISSUE;4:INDEX;5:STATION;6:ADJUSTMENT;7:DIRECT ISSUE;8:TRANSFER ISSUE;9:BACKORDER CANCEL",DIR("A")="Enter Transaction Type" D ^DIR
 Q:$D(DTOUT)  Q:$D(DUOUT)
 S ASUJ=Y,ASUT=$E(Y(0),1,3),ASUJ("RTN")=$E(ASUT,1,2)
 G @ASUJ
 W !,"Error - invalid transaction type entered"
 Q
1 ;DUEIN
 N DIR
 S DIR(0)="SB^12:PURCHASED;14:UNREQUIRED;15:DONATED;16:EXCESS;1K:CANCEL PURCHASED;1M:CANCEL UNREQUIRED;1N:CANCEL DONATED;1O:CANCEL EXCESS"
 G SELECT
2 ;RECEIPT
 N DIR
 S ASUJ("RTN")="RC"
 S DIR(0)="SB^22:PURCHASED;24:UNREQUIRED;25:DONATED;26:EXCESS;2K:REVERSAL PURCHASED;2M:REVERSAL UNREQUIRED;2N:REVERSAL DONATED;1O:REVERSAL EXCESS"
 G SELECT
3 ;ISSUE
 S DIR(0)="SB^32:REPLENISHMENT;33:NON REPLENISHMENT;3K:REVERSAL REPLENISHMENT;3L:REVERSAL NON REPLENISHMENT"
 G SELECT
4 ;INDEX
 S ASUT="IDX",ASUJ("RTN")="IX"
 S DIR(0)="SB^4A:ADD;4C:CHANGE;4D:DELETE"
 G SELECT
5 ;STATION
 S DIR(0)="SB^5A:ADD;5B:USER LEVEL;5C:CHANGE;5D:DELETE"
 G SELECT
6 ;ADJUSTMENT
 S ASUJ("RTN")="AJ"
 S DIR(0)="SB^27:DEBIT;37:CREDIT;2K:REVERSAL DEBIT;3K:REVERSAL CREDIT"
 G SELECT
7 ;DIRECT ISSUE
 S DIR(0)="SB^02:PURCHASED;04:UNREQUIRED;05:DONATED;06:EXCESS;0K:REVERSAL PURCHASED;0M:REVERSAL UNREQUIRED;0N:REVERSAL DONATED;1O:REVERSAL EXCESS"
 G SELECT
8 ;TRANSFER ISSUE
 S ASUJ=3
 S DIR(0)="SB^34:UNREQUIRED;36:EXCESS;3M:REVERSAL UNREQUIRED;3O:REVERSAL EXCESS"
 G SELECT
9 ;BACKORDER CANCEL
 S ASUJ=3,ASUT="CBO",ASUT("TRCD")="3J",ASUJ("RTN")="BO"
 G SELECTED
SELECT ;SELECT TRANSATION CODE
 W ! S DIR("A")="Enter Transaction Code" D ^DIR Q:$D(DTOUT)  Q:$D(DUOUT)
 S ASUT("TRCD")=Y
 S:$E(ASUT("TRCD"))=4 ASUT=$S($E(ASUT("TRCD"),2)="A":"XAD",$E(ASUT("TRCD"),2)="C":"XCG",$E(ASUT("TRCD"),2)="D":"XDL",1:"")
 S:$E(ASUT("TRCD"))=5 ASUT=$S($E(ASUT("TRCD"),2)="A":"SAD",$E(ASUT("TRCD"),2)="C":"SCG",$E(ASUT("TRCD"),2)="D":"SDL",1:"STB")
SELECTED ;EP ;
 S:$G(ASUJ("RTN"))="" ASUJ("RTN")=$E($G(ASUT),1,2)
 S ASUJ("RTN")=ASUJ_ASUJ("RTN"),ASUF("TRAN")=0
 D ENTR
 K ASUF("TRAN") Q
ENTR ;EP - Call Screenman for transaction entry
 I $G(ASUJ)=""!($G(ASUT)="")!($G(ASUT("TRCD")))="" Q
 ;Q:$G(ASUJ)']""  Q:$G(ASUT)']""  Q:$G(ASUT("TRCD"))']""
 S ASUV("ASUT")=ASUT,ASUV("TRCD")=ASUT("TRCD"),ASUT("TYPE")=ASUJ
 S ASUJ("FILE")=9002036_"."_ASUJ
 S ASUJ("GLOB")="^ASUT("_ASUJ_","
 S ASUJ("TMPL")="[ASUJ"_ASUJ_$E(ASUT,1,3)_"]"
 S ASUJ("WRIT")="S ASUF(""SV"")=1 D WRITE^ASU0TRWR(DA,.ASUJ)"
 S ASUJ("NEXT")="S DA=$O(^ASUT("_ASUJ_",9999999999),-1)+1"
 S ASUPOP=""  ;WAR 4/30/99 prevents UPDT from being performed if need B 
 N Z S Z=$G(ASUT("TRCD")) D TRN^ASULARST("T"_Z) S ASUT(ASUT,"SIGN")=$G(ASUL(11,"TRN","DRCR"))
 I $G(ASUF("TRAN"))=0 D NEWTRAN
 F ASUC("TRN")=0:1 D  Q:$G(DDSSAVE)=0
 .I ASUPOP S ASUC("TRN")=ASUC("TRN")-1  ;WAR 4/30/99
 .S ASUPOP=0
 .D DUP S ASUHDA=DA,DDSFILE=ASUJ("FILE"),DDSPARM="CES",DR=ASUJ("TMPL")
 .I ASUT("TRCD")["3"!(ASUT("TRCD")["0") S ASUDDS=1  ;WAR 11/22/99
 .D ^DDS
 .S ASUDDS=0       ;LMH 11/22/99 Reset ASUDDS
 .I $G(DDSSAVE)=1&('ASUPOP) D  ;WAR 4/28/99 ASUPOP set in ASUJHELP
 ..D UPDT
 .E  D
 ..S DIK=ASUJ("GLOB"),DA=ASUHDA D ^DIK
 ..;REM'D WAR - 2/19/99 W !,"RECORD NOT SAVED!" D PAZ^ASUURHDR
 ..S DDSSAVE=0
 W !,$FN(ASUC("TRN"),",")," Records Entered during this session."
 D PAZ^ASUURHDR
 K ASU("STARTING DA"),ASU("DA CNT")
 K ASUC,ASUT,ASUJ,ASUJT,ASUMX,ASUMS,ASUMK,ASUV,ASUDDS
 K ASUL(3),ASUL(7),ASUL(8),ASUL(9),ASUL(10),ASUL(11)
 K ASUL(4),ASUL(5),ASUL(17),ASUL(18),ASUL(19),ASUL(20),ASUL(22)
 Q
UPDT ;EP ;Update masters
 S DDSSAVE=""
 I ASUJ=1 D ^ASU1DUPD Q
 I ASUJ=2 D ^ASU2RUPD Q
 I ASUJ=3 D  Q
 .I ASUT("TRCD")="3J" D BKORDCAN^ASU3BKOR Q
 .I $E(ASUT("TRCD"),2)?1N D
 ..I ASUT("TRCD")=32 D ^ASU3IUPD Q
 ..I ASUT("TRCD")=33 D ^ASU3IUPD Q
 ..D TXFIS^ASU3IUPD
 .E  D
 ..D RVIS^ASU3IUPD
 I ASUJ=4 D ^ASU4XUPD Q
 I ASUJ=5 D ^ASU5SUPD Q
 I ASUJ=6 D ^ASU6JUPD Q
 I ASUJ=7 D ^ASU7DUPD
 Q
DUP ;EP ;Duplicate data from transaction
 S ASUT=ASUV("ASUT"),ASUT("TRCD")=ASUV("TRCD") D DAYTIM^ASUUDATE S ASUJT("TRKY")=$G(ASUT(ASUT,"TRKY"))
 M ASUT(ASUT)=ASUJT
 S:$G(ASUT("TYPE"))']"" ASUT("TYPE")=$G(ASUJ)
 X ASUJ("NEXT")
 ;WAR 4/26/99  REM'D->S ASUF("SV")=1 X ASUJ("WRIT")
 X ASUJ("WRIT")
 F Z=3:1:10,12:1:22 K ASUL(Z)
 Q
NEWTRAN ;
 I '$D(ASUL(1)) D SETAREA^ASULARST
 I '$D(DUZ) D ^XBKVAR
 S ASUF("TRAN")=1
 S:$G(ASUT("TYPE"))']"" ASUT("TYPE")=$G(ASUJ)
 S ASUT=ASUV("ASUT"),ASUT("TRCD")=ASUV("TRCD")
 S ASUT(ASUT,"ACC")="",ASUT(ASUT,"PT","ACC")=""
 S ASUT(ASUT,"PT","AR")=$G(ASUL(1,"AR","AP")),ASUT(ASUT,"AR")=ASUT(ASUT,"PT","AR")
 S ASUT(ASUT,"AR U/I")=""
 S ASUT(ASUT,"CALCED")=""
 S ASUT(ASUT,"CAN")=""
 S ASUT(ASUT,"CAT")="",ASUT(ASUT,"PT","CAT")=""
 S ASUT(ASUT,"CTG")=""
 S ASUT(ASUT,"UCS")=""
 S ASUT(ASUT,"DESC")=""
 S ASUT(ASUT,"BCD")=""
 S ASUT(ASUT,"DTD")=""
 S ASUT(ASUT,"DTE")=ASUK("DT","FM")
 S ASUT(ASUT,"DTS")=ASUK("DT","FM")
 S ASUT(ASUT,"DTX")=""
 S ASUT(ASUT,"DTW")=""
 S ASUT(ASUT,"DT IDX")=""
 S ASUT(ASUT,"DTP")=""
 S ASUT(ASUT,"DTR")=""
 S ASUT(ASUT,"ENTR BY")=DUZ
 S ASUT(ASUT,"EOQ TYP")="",ASUT(ASUT,"PT","EOQ TYP")="",ASUT(ASUT,"EOQ MM")="",ASUT(ASUT,"EOQ QM")="",ASUT(ASUT,"EOQ AM")=""
 S ASUT(ASUT,"FPN")=""
 S ASUT(ASUT,"IDX")="",ASUT(ASUT,"PT","IDX")=""
 S ASUT(ASUT,"LTM")=$FN($G(ASUL(1,"AR","DLTM")),"-",1)
 S ASUT(ASUT,"MST","QTY")="",ASUT(ASUT,"MST","VAL")=""
 S ASUT(ASUT,"NSN")=""
 S ASUT(ASUT,"ORD#")=""
 S ASUT(ASUT,"PST")=""
 S ASUT(ASUT,"PON")=""
 S ASUT(ASUT,"QTY")="",ASUT(ASUT,"QTY","REQ")="",ASUT(ASUT,"QTY","ISS")=""
 S ASUT(ASUT,"REQ")="",ASUT(ASUT,"PT","REQ")=""
 S ASUT(ASUT,"RPQ")=""
 S ASUT(ASUT,"REQ TYP")=1,ASUT(ASUT,"RQN")=""
 S ASUT(ASUT,"SLC")="",ASUT(ASUT,"PT","SLC")=""
 S ASUT(ASUT,"SOBJ")="",ASUT(ASUT,"PT","SOBJ")=""
 S ASUT(ASUT,"SPQ")=""
 S ASUT(ASUT,"SRC")="",ASUT(ASUT,"PT","SRC")=""
 S ASUT(ASUT,"SSA")="",ASUT(ASUT,"PT","SSA")=""
 S ASUT(ASUT,"SST")="",ASUT(ASUT,"PT","SST")=""
 S ASUT(ASUT,"PT","STA")=$G(ASUL(1,"AR","STA1")),ASUT(ASUT,"STA")=$E(ASUT(ASUT,"PT","STA"),4,5)
 S ASUT(ASUT,"STATUS")="Y"
 S ASUT(ASUT,"TRKY")=$G(ASUT(ASUT,"TRKY"))
 S ASUT(ASUT,"USR")="",ASUT(ASUT,"PT","USR")=""
 S ASUT(ASUT,"ULVQTY")=""
 S ASUT(ASUT,"VAL")=""
 S ASUT(ASUT,"VEN")="",ASUT(ASUT,"PT","VEN")="",ASUT(ASUT,"VEN NM")="",ASUT(ASUT,"SUI")=""
 S ASUT(ASUT,"VOU")=""
 M ASUJT=ASUT(ASUT)
 Q