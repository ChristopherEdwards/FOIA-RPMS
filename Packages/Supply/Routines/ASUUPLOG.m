ASUUPLOG ; IHS/ITSC/LMH -UTILITY PRINT LOG FILE ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine is involked to both save and print (involked at the top)
 ;or just print information saved (involked at entry point 'P')
 ;in the update log global ^XTMP("ASU0"). Physical inventory log messages
 ;are also saved and printed in the same way, except to ^XTMP("ASUR","R0V").
 S ASUK("LG","LN")=$G(ASUK("LG","LN"))+1
 S ASULX=$G(ASULX) S:ASULX']"" ASULX=0
 S ^ASURX(ASULX,ASUK("LG","LN"))=ASURX
 S:'$D(ASUK("PTR-Q")) ASUK("PTR-Q")=0
 I ASUK("PTR-Q") Q
 D:'$D(IO(0)) HOME^%ZIS U IO(0)
 X ASURX
 Q
P ;EP -PRINT LOGS
 I $G(ASUK("PTR"))]"" D
 .W @ASUK(ASUK("PTR"),"IOF")
 E  D
 .I '$D(IOF) D HOME^%ZIS U IO(0)
 .W @IOF
 S ASULX=$G(ASULX)
 S:ASULX']"" ASULX=$S($G(ASUL(1,"AR","WHSE")):0,1:"0D")
 S ASULX(0)=$S(ASULX=0:"Update",ASULX="0D":"Entered Transaction Extract",1:"Re-extract")
 W !,"Printout of ",ASULX(0)," Log Report",!
 F ASUC("LOG")=1:1 S ASULX(1)=$O(^ASURX(ASULX,$G(ASULX(1)))) Q:ASULX(1)=""  D
 .S ASURX=^ASURX(ASULX,ASULX(1))
 .X ASURX
 I ASUC("LOG")'>1 W !!,"No Log on file for printing",!!
 K ASULX,ASURX,ASUC("LOG")
 Q
V ;EP; SAVE OR PRINT INVENTORY LOG DATA
 S:'$D(ASUK("PTR-Q")) ASUK("PTR-Q")=0
 I ASUK("PTR-Q") D
 .S ASUK("LG","VL")=$G(ASUK("LG","VL"))+1
 .S ^XTMP("ASUR","R0V",ASUK("LG","VL"))=ASURX
 E  D
 .D:'$D(IO(0)) HOME^%ZIS U IO(0)
 .X ASURX
 .S DIR(0)="E" D ^DIR K DIR
 Q
PV ;EP -QUEUED JOB LISTING
 I '$D(^XTMP("ASUR","R0V")) Q
 D CLS^ASUUHDG
 W !!,"The following are S.A.M.S. Inventory System messages from Queued Jobs:",!!
 F  S ASUK("LG","VL")=$O(^XTMP("ASUR","R0V",$G(ASUK("LG","VL")))) Q:ASUK("LG","VL")']""  D
 .X ^XTMP("ASUR","R0V",ASUK("LG","VL"))
 .S DIR(0)="E" D ^DIR K DIR
 W !!,"ALL MESSAGES HAVE BEEN PRINTED",!!
 S DIR(0)="E" D ^DIR K DIR
 K ^XTMP("ASUR","R0V"),ASUK("LG","VL")
 S ^XTMP("ASUR","R0V",0)=ASUK("DT","FM")+10000_U_ASUK("DT","FM")
 Q
