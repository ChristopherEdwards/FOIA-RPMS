ASURD70I ; IHS/ITSC/LMH -RPT 70I - ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine formats and prints report 70I, Replenishment Post Posted
 ;Issues Invoice/Shipping list.
 I '$D(IO) D HOME^%ZIS
 I '$D(DUZ(2)) W !,"Report must be run from Kernel option" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTRSEL")=$G(ASUK("PTRSEL")) I ASUK("PTRSEL")]"" G PSER
 S ZTRTN="PSER^ASURD70I",ZTDESC="SAMS RPT 70I" D O^ASUUZIS
 I POP S IOP=$I D ^%ZIS Q
 I ASUK(ASUK("PTR"),"Q") Q
PSER ;EP;FOR TASKMAN QUEUE OF PRINT
 D U^ASUUZIS D DATE^ASUUDATE S ASUX("RPT")="R7I",ASUT="ISS" D P7
 S (ASUT(ASUT,"DTR"),ASUT(ASUT,"CAN"),ASUL(19,"USR"),ASUT(ASUT,"REQ#"),ASUT(ASUT,"SSA"))=""
 S ASUX("AR")=$O(^XTMP("ASUR","R7I",0))
 I ASUX("AR")="" D  G K
 .W @IOF,!!,"NO DATA FOR REPORT 70I"
 E  D READX^ASURD70P
 K ASUU,ASUX,ASUTR,ASUC,ASUV,ASULR,ASUF,DIC,DA,X,Y D PAZ^ASUURHDR Q:($D(DUOUT))
 I ASUK("PTRSEL")]"" W @IOF Q
 Q
 S ASUX("STA")=""
 F  S ASUX("STA")=$O(^XTMP("ASUR",ASUX("RPT"),ASUX("STA"))) Q:ASUX("STA")=""  D
 .I ASUX("STA")'=ASUV("STA") D
 ..I ASUV("STA")="" S ASUV("STA")=ASUX("STA") D STA^ASULARST(ASUX("STA")) S ASUV("SST")=0
 .S ASUX("SST")="" F  S ASUX("SST")=$O(^XTMP("ASUR",ASUX("RPT"),ASUX("STA"),ASUX("SST"))) Q:ASUX("SST")=""  Q:$D(DUOUT)  D
 ..S ASUF("HDR")=0,ASUX("VOU")="" S:ASUV("SST")="" ASUV("SST")=ASUX("SST") S:ASUV("SST")'=ASUX("SST") ASUV("SST")=ASUX("SST") D SST^ASULDIRR(ASUV("SST"))
 ..S ASUX("VOU")="" F  S ASUX("VOU")=$O(^XTMP("ASUR",ASUX("RPT"),ASUX("STA"),ASUX("SST"),ASUX("VOU"))) Q:ASUX("VOU")=""  Q:$D(DUOUT)  D
 ...I ASUV("VOU")="" S ASUF("HDR")=1,ASUC("PG")=0,ASUV("VOU")=ASUX("VOU")
 ...I ASUV("VOU")'=ASUX("VOU") S ASUF("HDR")=1,ASUC("PG")=0,ASUV("VOU")=ASUX("VOU")
 ...D INVOICE^ASURD70P
K ;
P7 ;EP ;SERIES INIT
 S ASUC("LN")=IOSL+1
 I ASUX("RPT")="ASUR71" D
 .S (ASUC("PG"),ASUF("1ST"),ASUF("BK"),ASUF("HDR"))=1,ASUF("END")=0
 E  D
 .S (ASUF("1ST"),ASUF("BK"),ASUF("END"),ASUF("HDR"))=0
 S (ASUX("STA"),ASUX("SST"),ASUX("VOU"),ASUX("SLC"),ASUX("IDX"),ASUX("SEQ"))=""
 S (ASUV("VOU"),ASUV("STA"),ASUV("SST"),ASUV("SLC"),ASULR("SLC"))=""
 F ASUC("TR")=0:1:2 S ASUV("RMK",ASUC("TR"))=""
 S ASUS("QTYAJ")=1 S ASUA("DFN")=0
 Q