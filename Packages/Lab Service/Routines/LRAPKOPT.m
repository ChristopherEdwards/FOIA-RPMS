LRAPKOPT ;AVAMC/REG - DEL OBSOLETE OPTIONS/CREATE X-REF 62.5,5 ; 1/29/89  12:45 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
EN ;
 S DIK="^DD(63.199,.01,1,",DA(2)="63.199",DA(1)=".01" F DA=0:0 S DA=$O(@(DIK_DA_")")) Q:DA'>0  D ^DIK
 S U="^" I $D(^DD(60,0,"VR")),^DD(60,0,"VR")>4.15 Q
 W !!,"This routine deletes the old anatomic pathology options from the option file",! D HELP W !!,"OK to delete old options " S %=2 D YN^DICN G:%>1!(%<0) LDF I %=0 D HELP G LRAPKOPT
 F LR="LRCXz","LRSOz","LRELz","LRATz","LRAOz" S LRB=$S(LR["C":"LRCYZ",LR["S":"LRSPZ",LR["E":"LREMZ",LR["AT":"LRAUP",1:"LRAPZ") D K
 S DIK="^DIC(19," S DA=$O(^DIC(19,"B","LRULY",0)) I DA D ^DIK W !,LR," deleted"
 G LDF
K S LRA=LR F A=0:0 S LRA=$O(^DIC(19,"B",LRA)) Q:LRA=""!(LRA]LRB)  W !,LRA," deleted" F LRC=0:0 S LRC=$O(^DIC(19,"B",LRA,LRC)) Q:'LRC  D M S DA=LRC,DIK="^DIC(19," D ^DIK
 Q
M ;delete entry in menu
 F LRM=0:0 S LRM=$O(^DIC(19,"AD",LRC,LRM)) Q:'LRM  S LRE=$O(^(LRM,0)) D:LRE D
 Q
D Q:'$D(^DIC(19,LRM,10,LRE,0))  S Y=^(0),Y(1)=$P(^DIC(19,+Y,0),"^",2),Y(2)=$P(Y,"^",2) K:Y(2)]"" ^DIC(19,LRM,10,"C",Y(2),LRE) K ^DIC(19,LRM,10,"B",LRC,LRE),^DIC(19,LRM,10,LRE,0),^DIC(19,"AD",LRC,LRM,LRE)
 K:Y(2)]"" ^(Y(2))
 L ^DIC(19,LRM,10,0) S X=^DIC(19,LRM,10,0),Y=$O(^(0)),^(0)=$P(X,"^",1,2)_"^"_Y_"^"_($P(X,"^",4)-1) L  Q
 ;
LDF W !!,"This part of the pre-init cross-references the screen field",!,"in the lab descriptions file (field# 62.5,5).",!
 F DA=0:0 S DA=$O(^LAB(62.5,DA)) Q:'DA  W:DA#100=0 "." S X=^(DA,0),%=$P(X,"^"),X=$P(X,"^",4) I X]"",%]"" S ^LAB(62.5,"A"_X,%,DA)=""
 W !,*7,"DONE." D V^LRU Q
 ;
HELP F A=1:1 S Y=$P($T(TXT+A),";",2) Q:Y=""  W !,Y
 Q
TXT ;
 ;Before initialization of the new anatomic pathology menu, the old options
 ;will be deleted if you answer 'YES'.
 ;If the old option is a menu entry that entry will be deleted from the menu.
 ;If you do not want the old options deleted you are responsible for cleaning
 ;up all the obsolete options.
