ASURD02P ; IHS/ITSC/LMH -RPT 2 -YEARLY PURGE TRANS LIST ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine formats and prints statistics concerning the Yearly
 ;closeout transaction purge proceedure.  All transactions more than 3
 ;years old will be purged during a yearly closeout.
EN ;EP;PRIMARY ENTRY POINT FOR REPORT 02
 I '$D(IO) D HOME^%ZIS
 I '$D(DUZ(2)) W !,"Report must be run from Kernel option" Q
 I '$D(ASUL(1,"AR","AP")) D SETAREA^ASULARST
 S ASUK("PTRSEL")=$G(ASUK("PTRSEL")) I ASUK("PTRSEL")]"" G PSER
 S ZTRTN="PSER^ASURD02P",ZTDESC="SAMS RPT 02" D O^ASUUZIS
 I POP S IOP=$I D ^%ZIS Q
 I ASUK(ASUK("PTR"),"Q") Q
PSER ;EP;FOR TASKMAN QUEUE OF PRINT
 I ($D(ASUK("DT"))#10)'=1 D DATE^ASUUDATE
 D U^ASUUZIS
 W @ASUK(ASUK("PTR"),"IOF")
 W !,"REPORT #2 -YEARLY FILE UPDATE",?50,ASUK("DT"),?70,"PAGE :   1",!!!
 F  S ASUX=$O(^XTMP("ASUR","R02",$G(ASUX))) Q:ASUX=""  S ASURX=^XTMP("ASUR","R02",ASUX) X ASURX
 K ASUX
 D PAZ^ASUURHDR W @(IOF)
 Q:ASUK("PTRSEL")']""
 ;D C^ASUUZIS
 Q
