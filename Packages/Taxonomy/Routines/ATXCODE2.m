ATXCODE2 ; IHS/OHPRD/TMJ -  CODES IF MODIFYING AND ENTERS CODES INTO FILE ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 I '$D(ATXX) D ASK I $D(ATXSTP)!'$D(ATXX) Q
 D @$S($D(ATX("ENTER")):"ENTER",1:"EDIT")
 D EOJ
 Q
 ;
ASK ;ASK FOR TAXONOMY IF NOT COMING THROUGH TAXONOMY SYSTEM
 W !!,"Would you like to save these codes in a Taxonomy for future use" S %=2 D YN^DICN
 I %=2!(%=-1) Q
 I %=0 W !!,"You may store these ICD codes in the TAXONOMY file if you desire.  You will be",!,"able to use these in future database searches." G ASK
 I %=1 D  S ATXFLG="",DIC("S")="I $P(^(0),U,5)=DUZ,$P(^(0),U,8)",DIC="^ATXAX(",DIC(0)="AEMQL",DIC("DR")=".05////"_DUZ_";.09////"_ATXTIME_";.13////1;.14////BA;.15////80;.16////1",DLAYGO=9002226 D ^DIC K DIC,ATXTIME
 . S %H=$H D YX^%DTC S ATXTIME=X_%
 I Y=-1 S ATXSTP=1 G X
 I $O(^ATXAX(+Y,21,0)) W !!,$C(7),"You have selected a taxonomy with codes already entered.  Do you want to delete",!,"the codes in this taxonomy and enter this new range of codes" S %=2 D YN^DICN D  I %'=1 G ASK
 . I %=1 S ATX("EDIT")="",ATXX=+Y W !!,$P(^ATXAX(ATXX,0),U)," TAXONOMY:"
 . I %=0 W !!,"You may add codes to an existing taxonomy by selecting a taxonomy when asked to ""ENTER DX:"""
 I '$O(^ATXAX(+Y,21,0)) S ATXX=+Y,ATX("ENTER")=""
 I $D(ATX("ENTER"))!$D(ATX("EDIT")) S DIE="^ATXAX(",DR=".02;1101;.08////1",DA=ATXX D ^DIE K DIE,DR
X Q
 ;
ENTER ;
 I '$D(ZTQUEUED),$D(ATX("NOT TAX")) W !!,"Entering codes into the ",$P(^ATXAX(ATXX,0),U)," taxonomy"
 E  I '$D(ZTQUEUED),$D(ATX("NOT TAX")) W !,"One moment please ..."
 S ATX=0 F  S ATX=$O(ATXTABLE(ATX)) Q:ATX=""  S ATX("X")=$E(ATX,1,($L(ATX)-1)) D CALLDIE I $D(Y) S ATXSTP=1 Q
 I '$D(ZTQUEUED),$D(ATX("NOT TAX")) W !!,"Done!"
 Q
 ;
CALLDIE ;
 S ATXHI=$E(ATXTABLE(ATX),1,($L(ATXTABLE(ATX))-1)),DIE="^ATXAX(",DR="2101///"_ATX("X"),DA=ATXX,DR(2,9002226.02101)=".02////"_ATXHI D ^DIE I $D(Y)
 E  I '$D(ZTQUEUED),$D(ATX("NOT TAX")) W "."
 I $D(Y),'$D(ZTQUEUED),$D(ATX("NOT TAX")) W !!,"ERROR ENCOUNTERED - REENTER RANGES",!
 K DIE,DR,DA
 Q
 ;
EDIT ;DELETE CODES IN TAXONOMY FILE, THEN ENTER NEW RANGES
 S ATX=0 F  S ATX=$O(^ATXAX(ATXX,21,ATX)) Q:ATX'=+ATX  S DA(1)=ATXX,DA=ATX,DIK="^ATXAX("_DA(1)_",21," D ^DIK K DIK,DA
 D ENTER
 Q
 ;
EOJ ;
 K ATXHI
 I $D(ZTQUEUED) S ZTREQ="@"
 Q
 ;
