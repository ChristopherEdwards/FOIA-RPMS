AQAOCOD2 ; IHS/ORDC/LJF - RETRIEVES CODES IF MOD & ENTERS CODES INTO FILE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;IHS/ORDC/LJF; copy of rtn ^ATXCODE2 ;;4.2;Taxonomy;;MAR 19, 1991
 ;  changes:  changed namespacing from ATX to AQAO
 ;            added check if using procedures, taxonomies for dx only
 ;            added incremental locks
 ;
 ;
 I AQAOICD=0 Q  ;IHS/ORDC/LJF cannot add taxonomy for procedures
 I '$D(AQAOX) D ASK I $D(AQAOSTP)!'$D(AQAOX) Q
 D @$S($D(AQAO("ENTER")):"ENTER",1:"EDIT")
 D EOJ
 Q
 ;
ASK ;ASK FOR TAXONOMY IF NOT COMING THROUGH TAXONOMY SYSTEM
 W !!,"Would you like to save these codes in a Taxonomy for future use"
 S %=2 D YN^DICN I %=2!(%=-1) Q
 I %=0 D  G ASK
 .W !!,"You may store these ICD codes in the TAXONOMY file if you"
 .W " desire.  You will be",!,"able to use these in future database"
 .W " searches."
 I %=1 D
 .S %H=$H D YX^%DTC S AQAOTIME=X_%
 .S ATXFLG="",DIC("S")="I $P(^(0),U,5)=DUZ,$P(^(0),U,8)"
 .S DIC="^ATXAX(",DIC(0)="AEMQL"
 .S DIC("DR")=".05////"_DUZ_";.09////"_AQAOTIME_";.13////1;.14////BA;.15////80;.16////1"
 .S DLAYGO=9002226 L +(^ATXAX(0)):1 I '$T W !!,"TAXONOMY FILE LOCKED; CANNOT ADD.  TRY AGAIN!",! Q  ;IHS/ORDC/LJF added lock
 .D ^DIC L -(^ATXAX(0))
 .K DIC,AQAOTIME,ATXFLG,DLAYGO
 I Y=-1 S AQAOSTP=1 G X
 I $O(^ATXAX(+Y,21,0)) W !!,*7,"You have selected a taxonomy with codes already entered.  Do you want to delete",!,"the codes in this taxonomy and enter this new range of codes" S %=2 D YN^DICN D  I %'=1 G ASK
 .I %=1 S AQAO("EDIT")="",AQAOX=+Y W !!,$P(^ATXAX(AQAOX,0),U)," TAXONOMY:"
 .I %=0 W !!,"You may add codes to an existing taxonomy by selecting a taxonomy when asked to ""ENTER DX:"""
 I '$O(^ATXAX(+Y,21,0)) S AQAOX=+Y,AQAO("ENTER")=""
 I $D(AQAO("ENTER"))!$D(AQAO("EDIT")) L +^ATXAX(AQAOX):1 Q:'$T  S DIE="^ATXAX(",DR=".02;1101;.08////1",DA=AQAOX D ^DIE K DIE,DR L -^ATXAX(AQAOX) ;IHS/ORDC/LJF added lock
X Q
 ;
ENTER ;
 I '$D(ZTQUEUED),$D(AQAO("NOT TAX")) W !!,"Entering codes into the ",$P(^ATXAX(AQAOX,0),U)," taxonomy"
 E  I '$D(ZTQUEUED),$D(AQAO("NOT TAX")) W !,"One moment please ..."
 S AQAO=0 F  S AQAO=$O(AQAOTBL(AQAO)) Q:AQAO=""  S AQAO("X")=$E(AQAO,1,($L(AQAO)-1)) D CALLDIE I $D(Y) S AQAOSTP=1 Q
 I '$D(ZTQUEUED),$D(AQAO("NOT TAX")) W !!,"Done!"
 Q
 ;
CALLDIE ;
 L +^ATXAX(AQAOX):1 I '$T W !!,"CANNOT EDIT; TAXONOMY LOCKED.  TRY AGAIN.",! Q  ;IHS/ORDC/LJF added line
 S AQAOHI=$E(AQAOTBL(AQAO),1,($L(AQAOTBL(AQAO))-1)),DIE="^ATXAX(",DR="2101///"_AQAO("X"),DA=AQAOX,DR(2,9002226.02101)=".02////"_AQAOHI D ^DIE L -^ATXAX(AQAOX) I $D(Y)
 E  I '$D(ZTQUEUED),$D(AQAO("NOT TAX")) W "."
 I $D(Y),'$D(ZTQUEUED),$D(AQAO("NOT TAX")) W !!,"ERROR ENCOUNTERED - REENTER RANGES",!
 K DIE,DR,DA
 Q
 ;
EDIT ;DELETE CODES IN TAXONOMY FILE, THEN ENTER NEW RANGES
 S AQAO=0 F  S AQAO=$O(^ATXAX(AQAOX,21,AQAO)) Q:AQAO'=+AQAO  S DA(1)=AQAOX,DA=AQAO,DIK="^ATXAX("_DA(1)_",21," D ^DIK K DIK,DA
 D ENTER
 Q
 ;
EOJ ;
 K AQAOHI
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
