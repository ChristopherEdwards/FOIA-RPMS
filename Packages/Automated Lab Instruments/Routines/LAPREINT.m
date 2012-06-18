LAPREINT ;SLC/BA- AUTO INSTRUMENT PRE-INIT ; 1/31/89  14:49 ;
 ;;V~5.0~;LAB;**45**;09/12/90 08:16
BEGIN S U="^" D ASK
END K DA,I,%
 Q
ASK F I=0:0 W !,"Do you wish to clear out and replace inactive auto instrument entries" S %=1 D YN^DICN Q:%  D INFO
 Q:%'=1
K S DIK="^LAB(62.4," F DA=99:0 S DA=$O(^LAB(62.4,DA)) Q:DA'>99  D ^DIK
 Q
INFO W !!,"Answering YES will wipe out all auto instrument entries >99.",!,"This will not effect entries 1-99 (entries for on-line instruments).",!
 Q
