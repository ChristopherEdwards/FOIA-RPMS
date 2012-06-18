ASUCOPSP ; IHS/ITSC/LMH -CLOSEOUT PRINTER SPOOLING ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
PRTSPLI ;EP ; print invoice to spool
 I $P($G(^ASUSITE(1,0)),U,7)'["HFS" W !,"Invoice reports not being spooled to UNIX - this option not useable" Q  ;DFM P1 8/28/98
 S ASUU("PDST")=$P($G(^ASUSITE(1,3)),U,7),ASUU("LST")="I"
 S ASUU("FILE")=$G(ASUU("FILE"))
 I $G(ASUK("DT","DA")) D
 .S DIR(0)="Y",DIR("A")="Do you want today's report" D ^DIR
 .I 'Y D ASKDATE^ASUUDATE
 E  D
 .D ASKDATE^ASUUDATE
 I '$D(ASUK("DT","DA")) W !,"Report date not selected" Q
 I ASUU("FILE")']"" S ASUU("FILE")="ASU"_ASUK("DT","MO")_ASUK("DT","DA")_".I"_$S($G(ASUL(2,"STA","CD")):ASUL(2,"STA","CD"),1:"RP")
 G PRNTIT
PRTSPLS ;EP ; print standard to spool
 I $P($G(^ASUSITE(1,0)),U,6)'["HFS" W !,"Standard reports not being spooled to UNIX - this option not useable" Q
 S ASUU("PDST")=$P($G(^ASUSITE(1,3)),U,6),ASUU("LST")="S"
 S ASUU("FILE")=$G(ASUU("FILE"))
 I $G(ASUK("DT","DA")) D
 .S DIR(0)="Y",DIR("A")="Do you want today's report" D ^DIR
 .I 'Y D ASKDATE^ASUUDATE
 E  D
 .D ASKDATE^ASUUDATE
 I '$D(ASUK("DT","DA")) W !,"Report date not selected" Q
 I ASUU("FILE")']"" S ASUU("FILE")="ASU"_ASUK("DT","MO")_ASUK("DT","DA")_".S"_$S($G(ASUL(2,"STA","CD")):ASUL(2,"STA","CD"),1:"RP")
PRNTIT ;
 S ASUU("HOSTCMD")="lp"_$S($G(ASUU("PDST"))]"":" -d"_ASUU("PDST"),1:"")_" /usr/spool/uucppublic/"_ASUU("FILE") K ASUU("FILE")
 W !,"Requesting report file be printed:"
HOSTCMD ;
 U IO(0)
 I ^%ZOSF("OS")'["MSM-UNIX" W !,"This option only available with MSM mumps running under UNIX" G KILL
 W !,"Unix response to request is: ",!
 S X=$$TERMINAL^%HOSTCMD(ASUU("HOSTCMD")) ;SAC exception granted 1/30/97
 D PAZ^ASUURHDR
KILL ;
 K ASUU,X,Y
 Q
GDIR ;EP ;Get archive directory DFM P1 8/28/98
 S ASUP("INV","DIR")=$P($P($G(^ASUSITE(1,0)),U,7),":",4) ;DFM P1 8/28/98
 S ASUP("STD","DIR")=$P($P($G(^ASUSITE(1,0)),U,6),":",4) ;DFM P1 8/28/98
 S XBDIR=$S(ASUP("STD","DIR")]"":ASUP("STD","DIR"),ASUP("INV","DIR")]"":ASUP("INV","DIR"),1:"") ;DFM P1 8/28/98
 I XBDIR="" D  ;WAR 7/27/99 
 .W !,"No reports archived to disk"
 .D PAZ^ASUURHDR
 Q  ;DFM P1 8/28/98
BZLIST ;EP ; list archive files
 D GDIR Q:XBDIR']""  S ASUU("HOSTCMD")="l -l "_XBDIR_"ASU*" D HOSTCMD ;DFM P1 8/28/98
 Q
GFILE ;EP ;Get file to browse ;COMPLETE SUB ROUTINE DFM P1 8/28/98
 S XBFIL="ASU" S DIR("A")="Select report type",DIR(0)="SOB^S:Standard;I:Invoice;M:Monthly",DIR("B")="S" D ^DIR S:$G(X)]"" XBFIL=XBFIL_X_"R"_$G(ASUL(2,"STA","CD"))
 S DIR("A")="Enter date of report",DIR(0)="DO",DIR("B")=$G(ASUK("DT","FM")) D ^DIR S:Y XBFIL=XBFIL_"."_$E(Y,4,7)
 Q
BROWSE ;EP ; brouse listings
 D GDIR Q:XBDIR']""  D GFILE Q:XBFIL']""  ;DFM P1 8/28/98
 D FILE^XBLM(XBDIR,XBFIL)
 Q
