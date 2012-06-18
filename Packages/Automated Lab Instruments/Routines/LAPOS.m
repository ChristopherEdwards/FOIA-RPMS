LAPOS ; IHS/DIR/FJE - AUTO INSTRUMENTS POST INIT 11:33 ; [ 5/10/90 ]
 ;;5.2;LA;;NOV 01, 1997
 ;;5.1;LAB;;04/11/91 11:06
EN ;
 W !!?7,*7,"Starting post inits ",!!
 W !!?10,"Updating the 'AD' cross reference in ^LAB(62.06 global",!!
 K ^LAB(62.06,"AD")
 F IFN=0:0 S IFN=$O(^LAB(62.06,IFN)) Q:IFN<1  I $D(^(IFN,0)),$P(^(0),U,2) S ^LAB(62.06,"AD",$P(^(0),U,2),IFN)=""
 K DIK,DA S DIK="^DD(62.4,",DA(1)=62.4 F DA=50,55 D ^DIK
 K DA S DIK="^DD(62.43,1,",DA(1)=62.43 F DA=12,12.1 D ^DIK
 K DA S DIK="^DD(62.46,1,",DA(1)=62.46 F DA=12,12.1 D ^DIK
 D ^LROPUD
END ;
 Q
