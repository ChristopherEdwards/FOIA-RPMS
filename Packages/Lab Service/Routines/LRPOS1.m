LRPOS1 ;SLC/FHS - CLEAN UP DIC("S") FROM DD ;7/17/89  12:46
 ;;V~5.0~;LAB;;02/27/90 17:09
 ; This routine is to kill ^(12) AND ^(12.1) NODES
 ; This is done to clean DIC("S") screen which have been changed
 K ^DD(62.31,.01,12),^(12.1)
 K ^DD(63.017,.01,12),^(12.1)
 K ^DD(63.822,.01,12),^(12.1)
 K ^DD(63.12,.01,12),^(12.1)
 K ^DD(63.14,.01,12),^(12.1)
 K ^DD(63.13,.01,12),^(12.1)
 K ^DD(63.16,.01,12),^(12.1)
 K ^DD(63.37,.01,12),^(12.1)
 K ^DD(63.2,.01,12),^(12.1)
 K ^DD(63.39,.01,12),^(12.1)
 K ^DD(63.43,.01,12),^(12.1)
 K ^DD(63.3,.01,12),^(12.1)
 K ^DD(63.34,.01,12),^(12.1)
 K ^DD(63.46,.01,12),^(12.1)
 K ^DD(63.8122,.01,12),^(12.1)
 K ^DD(68.04,.01,12),^(12.1)
 K ^DD(60,"GL",0,6,412)
NM ;Clean up "NM" nodes of DD
 K ^DD(62.41,0,"NM","LAB TESTS")
 K ^DD(62.46,0,"NM","ANTIBIOTIC")
 K ^DD(64.01,0,"NM","STATION NUMBER")
 K ^DD(64.03,0,"NM","REQUESTING LOCATION")
 K ^DD(64.03,0,"NM","TREATING SPECIALTY")
 K ^DD(64.55,0,"NM","CLUSTER HEADING")
 K ^DD(68.21,0,"NM","RUN NUMBER")
 K ^DD(68.22,0,"NM","SEQUENCE #")
 K ^DD(69.04,0,"NM","COMMENTS")
 K ^DD(69.9001,0,"NM","PHLEBOTOMY COLLECTION TIMES(S)")
 I $D(^DD(65,0,"ID","W")) S ^DD(65,0,"ID","WRITE")=^DD(65,0,"ID","W")
 K ^DD(65,0,"ID","W")
 K ^DD(64.53,0,"IX","AC",64.53,.01)
KID ;Remove unneeded fields and x-references
 S DIK="^DD(68.14,",DA=1,DA(1)=68 D ^DIK
 S DIK="^DD(64.708,.01,1,",DA(2)="64.708",DA(1)=".01" F DA=0:0 S DA=$O(@(DIK_DA_")")) Q:DA'>0  D ^DIK
 S DIK="^DD(68.21,.01,1,",DA(2)="68.21",DA(1)=".01" F DA=0:0 S DA=$O(@(DIK_DA_")")) Q:DA'>0  D ^DIK
 S DIK="^DD(68.222,.01,1,",DA(2)="68.222",DA(1)=".01" F DA=0:0 S DA=$O(@(DIK_DA_")")) Q:DA'>0  D ^DIK
W ;Set WRITE access to @ on mumps fields
 S ^DD(62.07,1,9)="@"
 S ^DD(62.1,10,9)="@"
 S ^DD(62.1,20,9)="@"
 S ^DD(62.4,26,9)="@"
 S ^DD(62.43,.7,9)="@"
 Q
