APCPDISP ; IHS/TUCSON/LAB - DISPLAY PCC EXPORT LOG DATA AUGUST 14, 1992 ; [ 03/03/03  9:44 AM ]
 ;;2.0;IHS PCC DATA EXTRACTION SYSTEM;**3,6**;APR 03, 1998
 ;IHS/CMI/LAB - commented out reference to APC, INPT
EN1 ;
 W:$D(IOF) @IOF
 K APCPQUIT
 W !!,"Display PCC DATA TRANSMISSION Log Entry",!
 S DIC="^APCPLOG(",DIC(0)="AEMQ" D ^DIC K DIC I Y=-1 W !!,"Goodbye" G XIT
 S APCPLOG=+Y
 S XBRP="PRINT^APCPDISP",XBRC="PROC^APCPDISP",XBRX="XIT^APCPDISP",XBNS="APCP"
 D ^XBDBQUE
 D XIT
 Q
XIT ;EP
 K APCPLOG,APCPREC
 Q
PROC ;
 Q
PRINT ;
 W:$D(IOF) @IOF W !?19,"PCC DATA TRANSMISSION LOG REPORT"
 W !?7,"Information for Log Entry ",APCPLOG," Beginning Date:  ",$$FMTE^XLFDT($P(^APCPLOG(APCPLOG,0),U))
 S APCPREC=^APCPLOG(APCPLOG,0)
 W !!?30,"Number:",?40,APCPLOG
 W !?22,"Beginning Date:",?40,$$FMTE^XLFDT($P(APCPREC,U))
 W !?25,"Ending Date:",?40,$$FMTE^XLFDT($P(APCPREC,U,2))
 W !?17,"Run Start Date/Time:",?40,$$FMTE^XLFDT($P(APCPREC,U,3))
 W !?18,"Run Stop Date/Time:",?40,$$FMTE^XLFDT($P(APCPREC,U,4))
 W !?24,"Run Location:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.09)
 I $P(APCPREC,U,27) W !?22,"**  Special Date Range Re-Export  **"
 W !?17,"Transmission Status:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.15)
 W !?17,"File name created: ",?40,$P(APCPREC,U,24)
 I $P(APCPREC,U,25) W !?17,"This log entry was created with REDO."
 W !!?4,"Total Number of Visits Processed:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.08)
 W:$P(^APCPLOG(APCPLOG,0),U,18) !?5,"Total Number of Visits Exported: ",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.18)
 I $P(^APCPLOG(APCPLOG,0),U,13) W !!?11,"Number of APC Records:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.13)
 I $P(^APCPLOG(APCPLOG,0),U,11) W !?5,"Number of Inpatient Records:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.11)
 I $P(^APCPLOG(APCPLOG,0),U,14) W !?11,"Number of CHA Records:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.14)
 W !?2,"Reasons Visits were skipped and did not generate a statistical record:" D
 .W !?18,"Visits with Errors:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.05)
 .W:$P(^APCPLOG(APCPLOG,0),U,19) !?17,"DEMO,PATIENT visits:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.19)
 .W:$P(^APCPLOG(APCPLOG,0),U,28) !?17,"MFI visits skipped:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.28)
 .W:$P(^APCPLOG(APCPLOG,0),U,21) !?24,"EVENT visits:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.21)
 .W:$P(^APCPLOG(APCPLOG,0),U,22) !?22,"DELETED visits:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.22)
 .W:$P(^APCPLOG(APCPLOG,0),U,23) !?2,"INCOMPLETE Contract or In-Hospital:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.23)
 .W:$P(^APCPLOG(APCPLOG,0),U,26) !?5,"DELETED Visits w/o prior export:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.26)
 W !?6,"# STATISTICAL DATABASE Records:",?40,$$VAL^XBDIQ1(9001005,APCPLOG,.17)
 W !!,"Total Number of Records Transmitted to the Area Office:  ",$$VAL^XBDIQ1(9001005,APCPLOG,.06)
TEXT ;
 I $Y>(IOSL-3) D FF Q:$D(APCPQUIT)
 ;W !!,"**NOTE - the number of records transmitted will be equal to the ",!,"#APC records + #INPT records + #CHA records + (#STATISTICAL DB records x 2)"
 ;I $Y>(IOSL-4) D FF Q:$D(APCPQUIT)
 W !!,"To list the errors, use the 'ERRS - List PCC Data Transmission Errors Report."
 ;W !!,"To review the export criteria for APC, Direct Inpatient, and CHA, refer to the",!,"related help frames in the option 'LOG - Inquire to Log File",!
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)
 S DIR(0)="FO^1:1",DIR("A")="Press 'RETURN' to Continue" D ^DIR K DIR S:$D(DUOUT) DIRUT=1
 Q
FF ;
 I $E(IOST)="C" S DIR(0)="E",DIR("A")="Press 'RETURN' to continue or '^' to exit" D ^DIR K DIR I $D(DIRUT) S APCPQUIT=1 Q
 W:$D(IOF) @IOF
 W !?40,"PCC Data Transmission Log - Page 2",!!
 Q
