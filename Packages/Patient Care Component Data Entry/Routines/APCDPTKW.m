APCDPTKW ; IHS/CMI/LAB - post selection action on RPMS PCC DATA ENTRY CONTROL ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 Q:'$D(APCDPAT)
 I $P(^APCDTKW(+Y,0),U,7) W !,$C(7),$C(7),"This Mnemonic is currently DISABLED (NOT Allowed) to be used!",! S Y=-1 Q
 I $P(^APCDTKW(+Y,0),U,8),$D(APCDENV) W !,$C(7),$C(7),"This Mnemonic to used in VISIT MODE only.  YOU MUST BE IN A VISIT!!",! S Y=-1 Q
 Q
