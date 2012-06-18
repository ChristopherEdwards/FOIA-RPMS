ASU4XUPD ; IHS/ITSC/LMH -POST INDEX ITEM ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine provides logic to add, change and delete SAMS INDEX
 ;master records to/from the database
 S:$G(DDSREFT)']"" DDSREFT=$G(ASUV("DDSREFT"))
 I $E(ASUT,3)="A" D
 .D DIX^ASUMDIRA(.ASUT) ;Add Index Master
 .S DIE=9002036.4
 .;B
 .D PUT^DDSVAL(DIE,.DA,.05,ASUT(ASUT,"PT","IDX"),"","I")
 .;D WRITE^ASUMXDIO ;Update Index Master from Variables
 I $E(ASUT,3)="C" D
 .S:ASUT(ASUT,"DTS")]"" ASUMX("ESTB")=ASUT(ASUT,"DTS")
 .S:ASUT(ASUT,"DESC")]"" ASUMX("DESC")=ASUT(ASUT,"DESC")
 .S:ASUT(ASUT,"AR U/I")]"" ASUMX("AR U/I")=ASUT(ASUT,"AR U/I")
 .S:ASUT(ASUT,"NSN")]"" ASUMX("NSN")=ASUT(ASUT,"NSN")
 .S:ASUT(ASUT,"BCD")]"" ASUMX("BCD")=ASUT(ASUT,"BCD")
 .I ASUT(ASUT,"ACC")]"" D
 ..I ASUMX("ACC")'=ASUT(ASUT,"ACC") D
 ...D ACCHANGE S ASUMX("ACC")=ASUT(ASUT,"ACC")
 .E  D
 ..S ASUT(ASUT,"ACC")=ASUMX("ACC")
 .S:ASUT(ASUT,"SOBJ")]"" ASUMX("SOBJ")=ASUT(ASUT,"SOBJ")
 .S:ASUT(ASUT,"CAT")]"" ASUMX("CAT")=ASUT(ASUT,"CAT")
 .D WRITE^ASUMXDIO ;Update Index Master from Variables
 I $E(ASUT,3)="D" D
 .S ASUT(ASUT,"ACC")=ASUMX("ACC")
 .S ASUMX("DELDS")=ASUMX("DESC")
 .S ASUMX("DELDT")=ASUK("DT","FM")
 .S ASUMS("E#","STA")=0,ASUMX("DELIX")=ASUMX("IDX"),ASUMX("IDX")=999999
 .S:ASUMX("DELDS")']"" ASUMX("DELDS")=$P(ASUMX(2),U,2)
 .K ^ASUMX("B",ASUMX("DELIX"),ASUMX("E#","IDX"))
 .K ^ASUMX("S",ASUMX("DELDS"),ASUMX("E#","IDX"))
 .S ASUMX("DESC")=""
 .D WRITE^ASUMXDIO ;Update Index Master
 D ^ASUJHIST ;Move transaction to History file
 Q
XSSO ;EP;Stock Sub Object table
 N DIC
 S:$D(ASUL(9,"ACC")) DIC("S")="I $P(^(0),U,2)=ASUL(9,""ACC"")" D XTBL^ASUJHELP(3) Q
 S DDSERROR=1 Q
CKDELSTA ;EP;
 F  S ASUMS("E#","STA")=$O(^ASUMS(ASUMS("E#","STA"))) Q:ASUMS("E#","STA")=""  D  Q:$D(DDSERROR)  ;Loop through all Stations
 .I $G(^ASUMS(ASUMS("E#","STA"),1,ASUMX("E#","IDX"),0))']"" Q  ;Index being deleted not used by this station
 .I $P(^ASUMS(ASUMS("E#","STA"),1,ASUMX("E#","IDX"),0),U)[999999 Q
 .;Index record still being used by this station
 .W *7 D MSG^ASUJHELP("Delete Unsucessful - STATION MASTER ON FILE") S DDSERROR=1 ;DSD P1 9/1/98
 Q
REUSEIX ;
 ;;This sub routine is involked whenever a new INDEX MASTER is being
 ;;added.  It checks to see if the Index Number being assigned has
 ;;previously been used and the item deleted.  In that case and it has
 ;;been 3 years or more since the number was used, it may be re-assigned
 ;;to the new item.  Otherwise, the add is rejected and must be
 ;;redone using a different index number.
 I ASUK("DT","YRMO")<$P(^ASUMX(ASUMX("E#","IDX"),2),U,3)+30000 D  Q
 .;Old Index number has not expired -must wait 3 years after deletion
 .W *7 D MSG^ASUJHELP("Delete Unsucessful DEL INDEX not expired (less than 3 years since deleted)") ;DFM P1 9/1/98
 .S DDSERROR=2
 ;Old Index number may be re-used for new item
 K DA
 ;Remove old entry for Index # in Index Master
 S (DA,Y)=ASUMX("E#","IDX"),DIK="^ASUMX(" D ^DIK
 ;Remove old entries for Index # in Station Masters
 ;DA(1) (Station IEN) Will be pointer to Station table: format
 ;    2 digit accounting point and (Stop loop if not correct area)
 ;    3 digit station code
 ;    total 5 digits
 S DA(1)=0
 F  S DA(1)=$O(^ASUMS(DA(1))) Q:DA(1)'?5N  Q:$E(DA(1),1,2)'=ASUL(1,"AR","AP")  D
 .S DIK="^ASUMS("_DA(1)_"," D ^DIK
 ;Remove old entries for Index # in Issue Book (Requsitioner) Masters
 ;DA(1) (Requsitioner IEN) Will be pointer to Requsitioner table: format
 ;    2 digit accounting point (Stop loop if not correct area)
 ;    3 digit station code and
 ;    4 digit User code (run through algorythm)
 ;    total 9 digits
 S DA(1)=0
 F  S DA(1)=$O(^ASUMK(DA(1))) Q:DA(1)'?9N  Q:$E(DA(1),1,2)'=ASUL(1,"AR","AP")  D
 .S DIK="^ASUMK("_DA(1)_"," D ^DIK
 ;Although the Back Order file also points to the Index Master, It is
 ;being assumed that the old Index number could not have been deleted
 ;if there were still backorders against it, so no effort will be made
 ;to check for and delete items in that file with this Index # IEN
 Q
ACCHANGE ;
 ;;This sub routine generates  ADJUSTMENT transactions based on
 ;;an INDEX MASTER CHANGE transaction which changes the account code.
 ;;The adjustments are required to move the related STATION MASTER
 ;;record balances from one account to another.
 S ASUSV("STA")=$G(ASUMS("STA"))
 F  S ASUV("STA")=$O(^ASUMS("B",$G(ASUV("STA")))) Q:ASUV("STA")=""  S ASUMS("E#","STA")=$O(^ASUMS("B",ASUV("STA"),"")) D L3727
 S ASUV("STA")=ASUSV("STA")
 Q
L3727 ;
 S ASUMS("E#","IDX")=ASUMX("E#","IDX")
 S ASUMS(0)=$G(^ASUMS(ASUMS("E#","STA"),1,ASUMS("E#","IDX"),0))
 Q:ASUMS(0)']""
 D MI^ASUMSTRD
 S ASUV("QTY",1)=ASUMS("QTY","O/H")
 S ASUV("QTY",2)=ASUMS("D/I","QTY-TOT"),ASUV("QTY",3)=ASUV("QTY",2)*-1
 S ASUT("GAJ","AR")=ASUT(ASUT,"AR")
 S ASUT("GAJ","STA")=$E(ASUV("STA"),4,5)
 S ASUT("GAJ","IDX")=ASUT(ASUT,"IDX")
 S ASUT("GAJ","ACC")=ASUT(ASUT,"ACC")
 S ASUT("GAJ","QTY")=ASUMS("QTY","O/H")
 S ASUT("GAJ","VAL")=ASUMS("VAL","O/H")
 S ASUT("GAJ","VOU")=$E(ASUK("DT","FYMO"),1,2)_$E(ASUK("DT","FYMO"),3,4)_"2737"
 S (ASUSV("TRCD"),ASUT("TRCD"))="27"
 S ASUM("TRTYP")="REGULAR"
 S ASUT="GAJ"
 S ASUT("GAJ","ACC")=ASUMX("ACC")
 S (ASUSV("TRCD"),ASUT("TRCD"))="37",ASUV("QTY",2)=ASUV("QTY",3)
 S ASUT="IXC"
 K ASUT("GAJ"),ASUV("QTY")
 D MIKF^ASUMSTRD
 S (ASUSV("TRCD"),ASUT("TRCD"))="4C"
 Q
CKIDX ;
 I Y=-9 D REUSEIX Q:$G(Y)=-9  Q:$D(DDSERROR)
 Q
