ACDBILLP ;IHS/ADC/EDE/KML - PRINT BILL REPORT;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine prints the hardcopy for billing report for
 ; a specified time frame.
 ;
START ;
 D INIT
 Q:ACDQ
 D DBQUE
 Q
 ;
INIT ;
 S ACDQ=1
 W !,"This routine prints the hardcopy for billing report for a specified time frame",!
 D GETDTR^ACDDEU ;              get acddtlo & acddthi
 Q:ACDQ
 W !
 S DIR(0)="YO",DIR("A")="Print hardcopy only for patients with third party coverage",DIR("B")="YES" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S ACD3PO=Y
 S DIR(0)="YO",DIR("A")="Re-print entries already printed",DIR("B")="NO" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S ACDRPR=Y
 S ACDQ=0
 Q
 ;
DBQUE ; call to XBDBQUE
 S ACDQ=1
 W ! S DIR(0)="S^P:PRINT Output;B:BROWSE Output on Screen",DIR("A")="Do you wish to",DIR("B")="P" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 I Y="B" D BROWSE Q
 S XBRP="PRT^ACDBILLP",XBRC="CMP^ACDBILLP",XBRX="EOJ^ACDBILLP",XBNS="ACD"
 D ^XBDBQUE
 Q
 ;
BROWSE ;
 S XBRP="VIEWR^XBLM(""PRT^ACDBILLP"")"
 S XBRC="CMP^ACDBILLP",XBRX="EOJ^ACDBILLP",XBIOP=0
 D ^XBDBQUE
 Q
 ;
CMP ; EP-COMPUTE ENTRY POINT FOR ^XBDBQUE
 ; All action taken in PRT entry point
 Q
 ;
PRT ; EP-PRINT ENTRY POINT FOR ^XBDBQUE
 ; Print hardcopies for billing
 NEW ACDFHCP
 S ACDMODE="A",ACDFHCP=1
 S ACDBDATE=$O(^ACDBILL("B",ACDDTLO),-1)
 F  S ACDBDATE=$O(^ACDBILL("B",ACDBDATE)) Q:ACDBDATE=""  Q:ACDBDATE>ACDDTHI  D
 .  S ACDBIEN=0
 .  F  S ACDBIEN=$O(^ACDBILL("B",ACDBDATE,ACDBIEN)) Q:'ACDBIEN  D  K ACDPCCL,ACD3PCOV
 ..  Q:'$D(^ACDBILL(ACDBIEN,0))  ;      corrupt database
 ..  S X=^ACDBILL(ACDBIEN,0)
 ..  I 'ACDRPR,$P(X,U,7) Q  ;           quit if already printed
 ..  K ACDMODEE I $P(X,U,9) S ACDMODEE="" ; modified bill
 ..  S ACDDFNP=$P(X,U,2),ACDFILE=$P(X,U,3),ACDVIEN=$P(X,U,4)
 ..  S ACDPCCL(ACDDFNP,ACDVIEN)=""
 ..  I ACDFILE'=3 S ACDPCCL(ACDDFNP,ACDVIEN,$S(ACDFILE=2:"TDC",1:"IIF"),$S(ACDFILE=2:$P(X,U,6),1:$P(X,U,5)))=""
 ..  I ACDFILE=3 D
 ...  S ACDCSIEN=0
 ...  F  S ACDCSIEN=$O(^ACDBILL(ACDBIEN,21,ACDCSIEN)) Q:'ACDCSIEN  D
 ....  S Y=+^ACDBILL(ACDBIEN,21,ACDCSIEN,0)
 ....  Q:'$D(^ACDCS(Y,0))
 ....  S ACDPCCL(ACDDFNP,ACDVIEN,"CS",Y)=""
 ....  Q
 ...  Q
 ..  I ACD3PO D CHKCOV^ACDPCCL I 'ACD3PCOV Q  ;quit if no coverage
 ..  D GENEVENT^ACDPCCL2
 ..  Q:ACDQ
 ..  D WRTBILLP^ACDPCCL4
 ..  D EOJ^ACDPCCL4
 ..  K ACDEV
 ..  S DIE="^ACDBILL(",DA=ACDBIEN,DR=".07////"_DT_";.08////"_DUZ
 ..  D DIE^ACDFMC
 ..  Q
 .  Q
 Q
 ;
EOJ ; EP-CALLED BY XBDBQUE
 W:IOST["P-" @IOF
 K %,%1,%2,%3,%DT,F,M,V,W,X,Y,Z
 K ACD3PDAT,ACD3PO,ACDMODE,ACDBDATE,ACDDTLO,ACDDTHI,ACDBIEN,ACDDFNP,ACDFILE,ACDRPR,ACDVIEN,ACDCSIEN,ACD3PCOV
 Q
