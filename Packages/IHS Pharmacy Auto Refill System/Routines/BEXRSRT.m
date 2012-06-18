BEXRSRT ; cmi/anch/maw - BEX SORT PATIENTS AND DATE 4/6/95 ; 10 Nov 2009  5:43 PM [ 04/30/2010  11:17 AM ]
 ;;1.0;BEX TELEPHONE REFILL SYSTEM;**1,2,3,4**;DEC 01, 2009
 ;This routine optimizes sorting for
 ;option BEX TRANSACTIONS BY PATIENT.
 ;After sorting, it calls routine ^BEXRPAT, which is a compilation
 ;of print template [BEX TRANSACTIONS BY PATIENT].
 ;
 ;cmi/anch/maw 2/1/2007 patch 3 added check of piece 10 for DUZ(2)
 ;CMI/BJI/DAY - 4/28/2010 - patch 4 - allow time in sort
 ;CMI/BJI/DAY - 4/28/2010 - patch 4 - limit to one site
 ;
MAIN ;MAIN DRIVER SUBROUTINE
 N BEX,%DT,X,Y,DTOUT
 S DTIME=$S($D(DTIME):DTIME,1:180),U="^",BEX("OUT")=0
 D ASKDATE
 Q:$D(DTOUT)!(Y=-1)  ;QUIT IF TIMEOUT, "^", OR INVALID DATE
 ;CMI/BJI/DAY - Add question to limit by site (4/28/2010)
 D ASKSITE
 I BEX("OUT")=1 Q
 D DEVICE Q:BEX("OUT")
MAINDQ ;ENTRY POINT FOR TASKMAN WHEN PRINTOUT IS QUEUED
 D SORT Q:BEX("OUT")
 D PRT
 I $D(ZTQUEUED) S ZTREQ="@" D ^%ZISC K BEX
 E  D HOME^%ZIS
 ;I $D(ZTQUEUED) D
 ;.S ZTREQ="@" D ^%ZISC K BEX
 ;E  D
 ;.D HOME^%ZIS
 ;IHS/PIMC/WAR 10/20/06 End mod
 D ^%ZISC  ;cmi/maw 6/12/2006 added for device close
 K ^TMP($J)
 Q
ASKDATE ;GET BEGINNING AND ENDING DATES
 ;CMI/BJI/DAY - Patch 4 - Add T to allow entry of time
 S %DT="AEXT"
 D ASKDATE1 Q:$D(DTOUT)!(Y=-1)
 D ASKDATE2
 Q
ASKDATE1 ;GET BEGINNING DATE
 S BEX("BEGIN")=$O(^VEXHRX0(19080.1,"C",0)),BEX("BEGIN")=$P(BEX("BEGIN"),".")
 S Y=BEX("BEGIN") D DD^%DT
 ;cmi/anch/maw 7/22/2007 new lines for default date patch 3
 S X1=DT,X2=-10 D C^%DTC
 S Y=X D DD^%DT
 ;cmi/anch/maw end of mods patch 3
 ;S %DT("B")=Y,%DT("A")="BEGIN WITH DATE: " D ^%DT  cmi/anch/maw 7/23/2007 orig line patch 3
 S %DT("B")=Y,%DT("A")="BEGIN WITH DATE: " D ^%DT  ;cmi/anch/maw 7/23/2007 new line for default date patch 3
 ;CMI/BJI/DAY - Patch 4 - Allow begin time to be used
 ;S BEX("BEGIN")=$P(Y,".")
 S BEX("BEGIN")=Y
 Q
ASKDATE2 ;GET ENDING DATE
 S BEX("END")=$O(^VEXHRX0(19080.1,"C","ZZZ"),-1)
 S BEX("END")=$P(BEX("END"),".")
 S Y=BEX("END") D DD^%DT
 S %DT(0)=BEX("BEGIN"),%DT("B")=Y,%DT("A")="END WITH DATE: "
 D ^%DT
 ;CMI/BJI/DAY - Patch 4 - Allow End date to use Time
 S BEX("END")=Y
 I $P(Y,".",2)="" S BEX("END")=$P(Y,".")_"."_235959
 Q
 ;
ASKSITE ;EP - Ask to limit by site
 K DIR
 S DIR("A")="Limit to transactions for "_$P($G(^DIC(4,DUZ(2),0)),U)
 S DIR("B")="Y"
 S DIR(0)="YO"
 D ^DIR
 I $D(DIRUT) S BEX("OUT")=1
 I Y=0 S BEXALL=0
 I Y=1 S BEXALL=1
 Q
 ;
DEVICE ;DEVICE SELECTION
 K IO("Q"),ZTSK,ZTQUEUED
 S %ZIS="QML" D ^%ZIS I POP S BEX("OUT")=1 Q
 I $D(IO("Q")) D  Q
 . S ZTRTN="MAINDQ^BEXRSRT"
 . S ZTDESC="BEXR DHCP REFILL TRANSACTIONS BY PATIENT"
 . S ZTSAVE("BEX*")=""
 . S ZTSAVE("DTIME")=""
 . D ^%ZTLOAD
 . K IO("Q")
 . I $D(ZTSK) D  ;
 . .  W !,"REQUEST QUEUED!"
 . .  W !,"Task number: ",ZTSK,!
 . S BEX("OUT")=1
 Q
SORT ;SORT ENTRIES TO BE PRINTED
 ;THIS SUBROUTINE BUILDS TEMPORARY GLOBAL ^TMP($J, IN CORRECT SORT ORDER
 K ^TMP($J) I $E(IOST,1,2)="C-" W !,"Sorting "
 S BEX("DATE")=$O(^VEXHRX0(19080.1,"C",BEX("BEGIN")),-1),BEX("D0")=""
 F  S BEX("DATE")=$O(^VEXHRX0(19080.1,"C",BEX("DATE"))) Q:BEX("DATE")=""!(BEX("DATE")>BEX("END"))  D  ;
 . F  S BEX("D0")=$O(^VEXHRX0(19080.1,"C",BEX("DATE"),BEX("D0"))) Q:BEX("D0")=""  D  ;
 .. Q:BEX("DATE")<BEX("BEGIN")  ;maw to screen out date with 0 timestamp
 . .  S BEX("NAME")=$P($G(^VEXHRX0(19080.1,BEX("D0"),0)),U)
 . .  S BEX("RX")=$P($G(^VEXHRX0(19080.1,BEX("D0"),0)),U,3)
 . .  ;cmi/anch/maw 2/1/2007 added next 3 lines to screen report by site
 . .  N BEXSITE
 . .  S BEXSITE=$P($G(^VEXHRX0(19080.1,BEX("D0"),0)),U,10)
 . .  I $G(BEXALL)=1 Q:BEXSITE'=DUZ(2)  ;screen out patients not at this site added $G for patch 3 7/19/2007
 . .  K BEX("MED")
 . .  I $G(BEX("RX")) D
 . . . N BEXRXI
 . . . S BEXRXI=$O(^PSRX("B",BEX("RX"),0))
 . . . Q:'BEXRXI
 . . . S BEX("MED")=$$GET1^DIQ(52,BEXRXI,6)
 . .  S BEX("DFN")=BEX("NAME")
 . .  Q:BEX("NAME")=""
 . .  S BEX("FOUND")=0
 . .  ;get info from ^TMP($J, if possible
 . .  I $G(^TMP($J,BEX("DFN")))'="" D  ;
 . . .   S BEX("NAME")=^TMP($J,BEX("DFN"))
 . . .   S BEX("SSN")=$P(BEX("NAME"),U,2),BEX("NAME")=$P(BEX("NAME"),U)
 . . .   S BEX("FOUND")=1
 . .  ;get info from ^DPT if you don't have it in ^TMP
 . .  I 'BEX("FOUND") D  ;
 . . .   S BEX("DPT")=$G(^DPT(BEX("NAME"),0))
 . . .   ;S BEX("SSN")=$P(BEX("DPT"),U,9)
 . . .   S BEX("SSN")=$$HRN^AUPNPAT(BEX("DFN"),DUZ(2))  ;cmi/maw 9/12/2002
 . . .   I BEX("SSN")="" S BEX("SSN")="N/A"
 . . .   S BEX("NAME")=$P(BEX("DPT"),U)
 . . .   S ^TMP($J,BEX("DFN"))=BEX("NAME")_U_BEX("SSN")_U_BEX("MED")
 . . .   I $E(IOST,1,2)="C-" W "."
 . .  Q:BEX("NAME")=""
 . .  S ^TMP($J,BEX("NAME"),BEX("SSN"),+BEX("DATE"),BEX("D0"))=BEX("MED")
 I '$D(^TMP($J)) S BEX("OUT")=1
 I BEX("OUT"),$E(IOST,1,2)="C-" W !,*7,"NO RECORDS IN SPECIFIED RANGE!" H 1
 Q
PRT ;PRINT REPORT
 ;This subroutine loops through ^TMP($J, and calls
 ;compiled print template routine ^BEXRPAT.
 U IO  ;cmi/maw added 6/9/2006 not printing to device only screen
 N D0,DXS,DC,N
 S (BEX("TOTAL"),BEX("PATTOT"))=0,BEX=""
 D NOW^%DTC S $P(%,".",2)=$E($P(%,".",2),1,4),BEX("HEADDATE")=%
 S Y=BEX("HEADDATE") D DD^%DT S BEX("HEADDATE")=$TR(Y,"@"," ")
 S BEX("HEAD")=$O(^DIPT("B","BEX TRANSACTIONS BY PATIENT",0))
 S BEX("HEAD")=$G(^DIPT(BEX("HEAD"),"H"))
 Q:BEX("HEAD")=""
 S DC=0,N(1)=1,BEX("LINE")=0
 S BEX("NAME")="@",(BEX("DATE"),BEX("D0"),BEX("SSN"),BEX("LASTSSN"),BEX("MED"))=""
 S BEX("NAME")=$O(^TMP($J,BEX("NAME")))
 S BEX("LASTSSN")=$O(^TMP($J,BEX("NAME"),BEX("LASTSSN"))),BEX("NAME")="@"
PRT2 ;BEGINNING OF PRINTING LOOP
 D PRTHEAD
 F  S BEX("NAME")=$O(^TMP($J,BEX("NAME"))) Q:BEX("NAME")=""!(BEX("OUT"))  D  ;
 . F  S BEX("SSN")=$O(^TMP($J,BEX("NAME"),BEX("SSN"))) Q:BEX("SSN")=""!(BEX("OUT"))  D  ;
 . .  I BEX("SSN")'=BEX("LASTSSN") D PRTTOTP S BEX("LASTSSN")=BEX("SSN")
 . .  F  S BEX("DATE")=$O(^TMP($J,BEX("NAME"),BEX("SSN"),BEX("DATE"))) Q:BEX("DATE")=""!(BEX("OUT"))  D  ;
 . . .   F  S BEX("D0")=$O(^TMP($J,BEX("NAME"),BEX("SSN"),BEX("DATE"),BEX("D0"))) Q:BEX("D0")=""!(BEX("OUT"))  D  ;
 . . . .    I BEX("LINE")>(+IOSL-4) D PRTHEAD
 . . . .    S BEX("MED")=$G(^TMP($J,BEX("NAME"),BEX("SSN"),BEX("DATE"),BEX("D0")))
 . . . .    S D0=BEX("D0") W ! D ^BEXRPAT
 . . . .    S BEX("LINE")=BEX("LINE")+1
 . . . .    S BEX("PATTOT")=BEX("PATTOT")+1,BEX("TOTAL")=BEX("TOTAL")+1
 I 'BEX("OUT") D PRTTOTP,PRTOTAL
 E  I $E(IOST,1,2)="C-" W !,*7,"Exiting report." H 1
 Q
PRTHEAD ;PRINT PAGE HEADING
 ;CMI/BJI/DAY - Changed following read to use DIR
 I $E(IOST,1,2)="C-",DC'=0 K DIR S DIR(0)="E" D ^DIR K DIR
 I $E(X)="^" S BEX("OUT")=1 Q
 I $E(X)="?" G PRTHEAD
 I DC>0!($E(IOST,1,2)="C-") W #
 S DC=DC+1,BEX("LINE")=0
 W !,BEX("HEAD"),?53,BEX("HEADDATE")," PAGE ",DC,!
 D HEAD^BEXRPAT
 S BEX("LINE")=BEX("LINE")+9
 Q
PRTTOTP ;PRINT TOTAL TRANSACTIONS FOR A PATIENT
 ;W !,?8,"Total transactions for patient = ",BEX("PATTOT"),!  ;cmi/maw 9/26/2006 not wanted
 S BEX("PATTOT")=0  ;,BEX("LINE")=BEX("LINE")+2  ;cmi/anch/maw 8/16/2007 patch 3
 Q
PRTOTAL ;PRINT TOTAL TRANSACTIONS FOR REPORT
 S BEX("END")=$P(BEX("END"),".")
 S BEX("BEGIN")=$E(BEX("BEGIN"),4,5)_"/"_$E(BEX("BEGIN"),6,7)_"/"_$E(BEX("BEGIN"),2,3)
 S BEX("END")=$E(BEX("END"),4,5)_"/"_$E(BEX("END"),6,7)_"/"_$E(BEX("END"),2,3)
 W !,?8,"Total transactions for date range ",BEX("BEGIN")," through ",BEX("END")," = ",BEX("TOTAL")
 Q
