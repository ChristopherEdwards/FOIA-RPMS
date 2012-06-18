AUPTLAB ;BRJ-IHS OHPD-TUCSON FIX LAB POINTERS [ 03/19/87  10:29 AM ]
 W !,*7,"This program is a stand-alone one-timer to fix pointers in the ^LR global",!
 S DA=0,U="^"
 K ^AUPTLAB S ^AUPTLAB(0)="OLD/NEW STATUS OF ^LR(DA,0) AS MODIFIED BY AUPTLAB"
 F AUPTL=0:0 S DA=$O(^LR(DA)) Q:'+DA  W "." I $P(^LR(DA,0),U,2)=2 S X=$P(^(0),U,3) I $D(^ARGOTON(X)) D SWAP
 W !,*7,"Done!!"
 Q
SWAP ;
 W "*" S ^AUPTLAB(DA,0,1)=^LR(DA,0) X ^DD(63,.03,1,1,2) W "/" S X1=^ARGOTON(X),$P(^LR(DA,0),U,3)=X1 S ^AUPTLAB(DA,0,2)=^LR(DA,0) W "!" S X=X1 X ^DD(63,.03,1,1,1) W "\"
 Q
