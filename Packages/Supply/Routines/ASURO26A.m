ASURO26A ; IHS/ITSC/LMH -CUPBOARD STOCK BIN LABLES ;   
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine formats and prints report 26A, Cupboard Stock Bin Labels
 ;Report.
 Q  ;WAR 5/21/99
 K ^XTMP("ASUR","R26A")
 S ^XTMP("ASUR","R26A",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 D SETAREA^ASULARST
 K ASUF("QU")
 D DIR
 G EXIT
DIR ;Menu
 ;
 F ASU1(10)=1:1:3 W !,ASU1(10),"  ",$P($T(@ASU1(10)),";",3) I ASU1(10)=3 D  S:X["^" ASUF("QU")=1 Q
 .S DIR(0)="L^1:3^S ASUV(""RP26"")=Y",DIR("A")="ENTER SELECTION "
 .W !
 .D ^DIR
 Q:$D(ASUF("QU"))
 K ASUU("SST")
 D SST I $D(ASUF("QU")) K ASUF("QU") Q
 D USR I $D(ASUF("QU")) K ASUF("QU") Q
 ;
Q ;Queue
 S ZRTN="LIST^ASURO26A"
 S ASUF("NOQUE")=1
 K IO("Q"),%ZIS,IOP S %ZIS="QM" D ^%ZIS Q:POP!('$D(IO("Q")))
 K ZTDTH,ZTSAVE,ZTSK S ZTIO=ION
 F ASU1="ASUX(","ASUU(","ASUK(","ASUV(","DUZ(" S ZTSAVE(ASU1)=""
 D ^%ZTLOAD W !,"Report Queued.."
 I POP!($D(IO("Q"))) K ASUF("QU") D COMPUTE Q
 D COMPUTE G LIST
COMPUTE ;
 S ASUNW(4)=ASUV("RP26")
 F ASUNW(0)=1:1:$L(ASUNW(4),",")-1 S ASUTG=$P(ASUNW(4),",",ASUNW(0)) D A0
 Q
LIST ;EP ;Taskman Entry Point
 D HED,A1
EXIT ;
 I $D(ASUNW),'$D(^XTMP("ASUR","R26A")) U IO(0) W !!,"******** NO DATA FOUND *********"
 ;
 F X=10:1:21,29 K ASU1(X)
 K ASUF,ASUR,ASUNW,ASUTG,ASUV,ASUT,DIR,ZRTN,ASUMS,ASUMX,ASUMB
BYE ;
 K ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15),ASU1(16),ASU1(17),ASU1(18),ASU1(19),ASU1(20)
 K ASUC,ASUF,ASUFB,ASUMU,ASU1,ASUF("NOQUE"),ASUMX,ASUMS,ASUMB
 K ASUL,ASUR,ASUT,ASUTG,ASUX,DIR,ZTDESC,ZTIO,ZTRTN
 K ^XTMP("ASUR","R26A")
 K ASUT,ASUV,ASUC,ASUF("NOQUE"),ASUE
 D PAZ^ASUURHDR W @IOF D ^%ZISC
 Q
HED ;Header vars
 S ASUX(0)=$P($T(@ASUTG),";",3),ASUX(1)="IND # ",ASUX(2)="U/I: ",ASUX(3)="USER LEVEL",ASUX(4)="AR ",ASUX(5)="ST ",ASUX(6)="S-ST ",ASUX(7)="U-C "
 Q
1 ;;CUPBOARD STOCK BIN LABELS -ALPHA SEQ BY SUB STATION AND USER
2 ;;CUPBOARD STOCK BIN LABLES -ALPHA SEQ BY CATEGORY
3 ;;CUPBOARD STOCK BIN LABLES -INDEX SEQ
A0 ;
 S X=$O(ASUU("SST","")) Q:X']""
 I X="*ALL*" D
 .S ASUX("STA")=ASUL(1,"AR","AP")_"000"
 .F  S ASUX("STA")=$O(^ASUMK(ASUX("STA"))) Q:$E(ASUX("STA"),1,2)'=ASUL(1,"AR","AP")  D USER
 E  D
 .S ASUX("STA")=ASUL(2,"STA","E#")
 .F  S ASUX("STA")=$O(ASUU("SST",ASUX("STA"))) Q:ASUX("STA")']""  D USER
 K ASUMK,ASUMX,ASUMS,ASUC,ASUU,ASUC,ASUX
 Q
USER ;Process Users in Sub Station
 S ASUMK("E#","STA")=ASUX("STA")
 S X=$O(ASUU("USR","")) Q:X']""
 I X="*ALL*" D
 .S ASUX("USR")=ASUL(1,"AR","AP")_"0000"
 .F  S ASUX("USR")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUX("USR"))) Q:ASUX("USR")'?1N.N  D BUILD
 E  D
 .S ASUX("USR")=""
 .F  S ASUX("USR")=$O(ASUU("USR",ASUMK("E#","STA"),ASUX("USR"))) Q:ASUX("USR")']""  D BUILD
 Q
BUILD ;Process Indexs in User
 S ASUMK("E#","REQ")=ASUX("USR")
 S ASUMK("E#","IDX")=0
 F ASUC("IDX")=1:1 S ASUMK("E#","IDX")=$O(^ASUMK(ASUMK("E#","STA"),1,ASUMK("E#","REQ"),1,ASUMK("E#","IDX"))) Q:ASUMK("E#","IDX")'?1N.N  D
 .W:ASUC("IDX")#20=0 "."
 .D READ^ASUMKBIO
 .S ASUMS("E#","STA")=$G(ASUL(1,"AR","STA1"))
 .S:ASUMS("E#","STA")']"" ASUMS("E#","STA")=ASUMK("E#","STA")
 .D DIS^ASUMDIRM(ASUMS("E#","STA")) I Y<0 D
 ..S ASUMS("E#","STA")=$O(^ASUMS("C",ASUMK("E#","IDX"),""))
 .I '$D(^ASUMS("C",ASUMK("E#","IDX"),ASUMS("E#","STA"))) D
 ..S ASUMS("E#","STA")=$O(^ASUMS("C",ASUMK("E#","IDX"),""))
 .I ASUMS("E#","STA")']"" D  Q
 ..W *7,!,"*** ERROR *** -Unable to find Station for Index # ",$E(ASUMK("E#","IDX"),3,8)," for to Sub Station ",$E(ASUMK("E#","STA"),3,5)
 .S ASUMS(2)=^ASUMS(ASUMS("E#","STA"),1,ASUMK("E#","IDX"),2)
 .S ASUMX(0)=^ASUMX(ASUMK("E#","IDX"),0)
 .S ASUMS("EOQ","TP")=$P(ASUMS(2),U,5)
 .S ASUMS("SLC")=$P(ASUMS(2),U)
 .S ASUMX("ACC")=$P(ASUMX(0),U,6)
 .S ASUMX("CAT")=$P(ASUMX(0),U,8)
 .S ASUMX("DESC",1)=$E($P(ASUMX(0),U,2),1,30)
 .S ASUMX("DESC",2)=$E($P(ASUMX(0),U,2),31,60)
 .S ASUX("ACCG")=$S(ASUMX("ACC")=1:1,ASUMX("ACC")=3:3,1:4)
 .S ASUX("SLC")=$S(ASUMS("SLC")="H":"H",ASUMS("SLC")="R":"R",1:"Z")
 .S ASUX("CAT")=$S(+ASUV("RP26")=2:ASUMX("CAT"),1:"*")
 .S:ASUX("CAT")']"" ASUX("CAT")="*"
 .S ASUX("IDX")=$S(+ASUV("RP26")=3:ASUMX("IDX"),1:ASUMX("DESC",1))
 .S X=$E(ASUMX("IDX"),1,5)_"."_$E(ASUMX("IDX"),6,6)_U_ASUMX("AR U/I")_U_ASUMX("DESC",1)
 .S X=X_U_ASUMX("DESC",2)_U_ASUMK("ULQTY")_U_ASUL(1,"AR","AP")_U_ASUMS("E#","STA")_U_ASUMK("SST")_U_ASUMK("USR")
 .S ^XTMP("ASUR","R26A",ASUX("STA"),ASUX("USR"),ASUX("ACCG"),ASUX("SLC"),ASUX("CAT"),ASUX("IDX"))=X
 .K X
 Q
A1 ;
 I '$D(^XTMP("ASUR","R26A")) Q
 ;Print initial header
 U IO
 K ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15),ASU1(16),ASU1(17),ASU1(18),ASU1(19),ASU1(20)
 S ASU1(11)=""
 F  S ASU1(11)=$O(^XTMP("ASUR","R26A",ASU1(11))) Q:ASU1(11)=""  D
 .S ASU1(12)="",ASU2(2)=0
 .F  S ASU1(12)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12))) Q:ASU1(12)=""  D  S ASU2(2)=1
 ..S ASU1(13)="",ASU2(3)=0
 ..F  S ASU1(13)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13))) Q:ASU1(13)=""  D  S ASU2(3)=1
 ...S ASU1(14)="",ASU2(4)=0
 ...F  S ASU1(14)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13),ASU1(14))) Q:ASU1(14)=""  D  S ASU2(4)=1
 ....S ASU1(15)="",ASU2(5)=0
 ....F  S ASU1(15)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15))) Q:ASU1(15)=""  D SLC S ASU2(5)=1
 ....I ASU2(6) D NEWPAGE Q
 ....S ASU2(5)=0 Q
 ...I ASU2(5) D NEWPAGE Q
 ...S ASU2(4)=0 Q
 ..I ASU2(4) D NEWPAGE Q
 ..S ASU2(3)=0 Q
 .I ASU2(3) D NEWPAGE Q
 .S ASU2(2)=0 Q
 I ASU2(2) D NEWPAGE Q
 Q
SLC ;Order on ASU1(16)...it will be in form STORAGE LOCATION H,R,or *
 S ASU1(16)="",ASU2(6)=0
 F  S ASU1(16)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15),ASU1(16))) Q:ASU1(16)=""  D  S ASU2(6)=1
 .S ASU1(17)="",ASU2(7)=0
 .F  S ASU1(17)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15),ASU1(16),ASU1(17))) Q:ASU1(17)=""  D  S ASU2(7)=1
 ..W !,"LABELS FOR USER ",ASU1(14),!?11,"ACCOUNT ",ASU1(15)
 ..W !?11,"LOCATION ",$S(ASU1(16)="Z":"",1:ASU1(16)),!?11,"CATEGORY ",$S(ASU1(17)="*":"",1:ASU1(17)),!!
 ..S ASU1(18)="",ASU2(8)=0
 ..F  D LOOP Q:ASU1(18)']""
 .I ASU2(8) D NEWPAGE Q
 .S ASU2(7)=0 Q
 I ASU2(7) D NEWPAGE Q
 S ASU2(6)=0 Q
LOOP ;
 S ASU1(21)=0
 F ASU1(19)=1:1:3 D  I ASU2(8) D COLUMN
 .S ASU2(9)=0
 .F  S ASU1(18)=$O(^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15),ASU1(16),ASU1(17),ASU1(18))) S:ASU1(18)="" ASU2(9)=1 D  Q:ASU2(9)
 ..Q:ASU2(9)
 ..S ASU1(21)=ASU1(21)+1,ASU2(8)=1
 ..S ASUF("BK",ASU1(21))=1
 ..S ASUT(0)=^XTMP("ASUR","R26A",ASU1(11),ASU1(12),ASU1(13),ASU1(14),ASU1(15),ASU1(16),ASU1(17),ASU1(18))
 ..F ASU1(20)=1:1:9 S ASUC(ASU1(21),ASU1(20))=$P(ASUT(0),U,ASU1(20))
 ..S:ASU1(21)=3 ASU2(9)=1
 .I ASU1(21)<3 F  S ASU1(21)=ASU1(21)+1 D BLANK Q:ASU1(21)=3
 .S ASU1(19)=3
 Q
BLANK ;blank out one labels worth of print fields
 S ASUF("BK",ASU1(21))=0
 F ASU1(20)=1:1:9 S ASUC(ASU1(21),ASU1(20))=""
 Q
NEWPAGE ;Form feed code
 Q
 D PAZ^ASUURHDR Q:$D(DUOUT)
 W @IOF
 Q
COLUMN ;Display columns
 W !,ASUX(1),ASUC(1,1),?15,ASUX(2),ASUC(1,2),?24,ASUX(3)
 I ASUF("BK",2) W ?41,ASUX(1),ASUC(2,1),?55,ASUX(2),ASUC(2,2),?64,ASUX(3)
 I ASUF("BK",3) W ?81,ASUX(1),ASUC(3,1),?95,ASUX(2),ASUC(3,2),?104,ASUX(3)
 W !,ASUC(1,3)
 I ASUF("BK",2) W ?41,ASUC(2,3)
 I ASUF("BK",3) W ?81,ASUC(3,3)
 W !,ASUC(1,4),?37,ASUC(1,5)
 I ASUF("BK",2) W ?41,ASUC(2,4),?73,ASUC(2,5)
 I ASUF("BK",3) W ?81,ASUC(3,4),?115,ASUC(3,5)
 W !,ASUX(4),ASUC(1,6),?7,ASUX(5),ASUC(1,7),?13,ASUX(6),ASUC(1,8),?21,ASUX(7),ASUC(1,9)
 I ASUF("BK",2) W ?41,ASUX(4),ASUC(2,6),?51,ASUX(5),ASUC(2,7),?57,ASUX(6),ASUC(2,8),?65,ASUX(7),ASUC(2,9)
 I ASUF("BK",3) W ?81,ASUX(4),ASUC(3,6),?87,ASUX(5),ASUC(3,7),?93,ASUX(6),ASUC(3,8),?101,ASUX(7),ASUC(3,9)
 W !!
 S:'$D(ASUC("LAB")) ASUC("LAB")=0 S ASUC("LAB")=ASUC("LAB")+1 I ASUC("LAB")=9 S ASUC("LAB")=0 D NEWPAGE
 Q
SST ;EP ;
 ;********************************************************
 ;Reports are running by sub-station. A futher breakdown
 ;is now determined. Run ALL or SELECTED
 ;This routine will return a ASUU("SST",E#) that holds the entry numbers
 ;*********************************************************
 K ASUU("SST"),DIR S ASUX(32)="GROUP SUB-TOTALED BY: NO SUB-TOTALS"
 S DIR(0)="S^1:Print 'ALL' sub-stations;2:Print 'SELECTED' sub-stations",DIR("A")="Sub-Station Print Criteria"
 D ^DIR G:Y="^" KILSS
 I Y=1 D
 .S ASUX(31)="GROUP RESTRICTED TO ALL SUB-STATIONS"
 .S ASUU("SST","*ALL*")=""
 E  D
 .S ASUX(31)="GROUP RESTRICTED TO SELECTED SUB-STATIONS ONLY"
 .S DIC("A")="Select Sub stations ",DIC="^ASUL(18,",DIC(0)="AEMQI"
 .F  D  Q:Y<0
 ..D ^DIC Q:Y<0
 ..I $D(^ASUL(18,+Y,0)),$P(^ASUL(18,+Y,0),U)]"" S ASUU("SST",+Y)=+Y
 .K DIC
KILSS ;
 I '$D(ASUU("SST")) S ASUF("QU")=1 Q
 K DIC,DIR,Y
 Q             ;Added quit here so would not go to USR twice. LMH 4/7/00
USR ;EP ;
 ;**********************************************************
 ;Now ask what users they wish to include on the report
 ;Choose ALL or SELECTED
 ;Routine returns a ASUU("USR",array) that holds the user
 ;pointers to table 17 (20)
 ;**********************************************************
 K ASUU("USR"),DIR
 S DIR("B")=1
 S DIR(0)="S^1:Print 'ALL' users;2:Print 'SELECTED' users",DIR("A")="Users Print Criteria"
 D ^DIR
 I Y=1  D
 .S ASUX(33)="GROUP INCLUDES ALL USERS"
 .S ASUU("USR","*ALL*")=""
 E  D
 .S ASUX(33)="GROUP INCLUDES SELECTED USERS ONLY"
 .I '$D(ASUU("SST","*ALL*")) D
 ..S ASUU("SELU")=""
 ..F  S ASUU("SELU")=$O(ASUU("SST",ASUU("SELU"))) Q:ASUU("SELU")=""  D SU
 .E  D
 ..S ASUU("SELU")=0
 ..F  S ASUU("SELU")=$O(^ASUMK(ASUU("SELU"))) Q:ASUU("SELU")'?1N.N  D
 ...I ASUU("SELU")=ASUL(2,"STA","E#") D SU
 Q
SU ;Select User for Sub-Station
 ;WAR 4/21/2000 originally this tag only had the 'Else' side of the 
 ;          'If' statement. I added the 'If' statement to handle
 ;          looking up USER codes by the Substation, then I included 
 ;          the check (another 'If') on the value returned in Y.
 ;          An error or warning msg may be needed if a USER code is
 ;          selected that is not associated with the substation.
 I '$D(ASUU("SST","*ALL*")) D
 .S DIC("A")="Select Sub station "_$E(ASUU("SELU"),3,5)_" Users: ",DIC="^ASUL(20,",DIC(0)="AEQMI"
 .F  D ^DIC Q:Y<0  Q:$D(DUOUT)  I ASUU("SELU")=$E(Y,1,5) S ASUU("USR",ASUU("SELU"),+Y)=+Y
 E  D
 .S DIC("A")="Select Sub station "_$E(ASUU("SELU"),3,5)_" Users: ",DIC="^ASUMK("_ASUU("SELU")_",1,",DIC(0)="AEQMI"
 .F  D ^DIC Q:Y<0  Q:$D(DUOUT)  S ASUU("USR",ASUU("SELU"),+Y)=+Y
 Q
