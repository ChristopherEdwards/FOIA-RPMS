ACDBILLD ;IHS/ADC/EDE/KML - PURGE BILL FILE;
 ;;4.1;CHEMICAL DEPENDENCY MIS;;MAY 11, 1998
 ;
 ; This routine purges entries in the CDMIS BILL file for
 ; a specified time frame.
 ;
START ;
 D MAIN
 D EOJ
 Q
 ;
MAIN ;
 D INIT
 Q:ACDQ
 D PURGE
 Q
 ;
INIT ;
 S ACDQ=1
 W !,"This routine purges entries in the CDMIS BILL file for a specified time frame",!
 D GETDTR^ACDDEU ;              get acddtlo & acddthi
 Q:ACDQ
 W !
 S DIR(0)="YO",DIR("A")="Purge entries within time frame that have not been printed",DIR("B")="NO" K DA D ^DIR K DIR
 Q:$D(DIRUT)
 S ACDALL=Y
 S ACDPC=0
 S ACDQ=0
 Q
 ;
PURGE ; PURGE ENTRIES WITHIN TIME FRAME
 S ACDBDATE=$O(^ACDBILL("B",ACDDTLO),-1)
 F  S ACDBDATE=$O(^ACDBILL("B",ACDBDATE)) Q:ACDBDATE=""  Q:ACDBDATE>ACDDTHI  D
 .  S ACDBIEN=0
 .  F  S ACDBIEN=$O(^ACDBILL("B",ACDBDATE,ACDBIEN)) Q:'ACDBIEN  D
 ..  Q:'$D(^ACDBILL(ACDBIEN,0))  ;      corrupt database
 ..  S X=^ACDBILL(ACDBIEN,0)
 ..  I 'ACDALL,$P(X,U,7)="" Q  ;        quit if not printed
 ..  I ACDALL,$P(X,U,7)="" D  I ACD3PCOV D P3COV Q:ACDQ
 ...  S ACDDFNP=$P(X,U,2),ACDVIEN=$P(X,U,4)
 ...  D CHKCOV^ACDPCCL
 ...  Q
 ..  S DIK="^ACDBILL(",DA=ACDBIEN
 ..  D DIK^ACDFMC
 ..  W "."
 ..  S ACDPC=ACDPC+1
 ..  Q
 .  Q
 W !!,ACDPC," entr"_$S(ACDPC=1:"y",1:"ies")_" purged.",!!
 D PAUSE^ACDDEU
 Q
 ;
P3COV ; 3RD PARTY COVERAGE
 S ACDQ=1
 W !
 S DIC="^ACDBILL(",DA=ACDBIEN,DR=0
 D DIQ^ACDFMC
 W !,"There is third party coverage for this unprinted visit"
 S DIR(0)="Y",DIR("A")="Do you really want to purge this entry",DIR("B")="NO" K DA D ^DIR K DIR
 S:Y ACDQ=0
 Q
 ;
EOJ ;
 K ACD3PCOV,ACD3PDAT,ACDALL,ACDBDATE,ACDBIEN,ACDDFNP,ACDDTHI,ACDDTLO,ACDPC,ACDQ,ACDVIEN
 Q
