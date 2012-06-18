AUNODEL ;PREVENT USER FROM DELETING ENTRIES [ 06/05/87  2:39 PM ]
 ;
BEGIN S DUZ(0)="@",U="^" D CURRENT^%ZIS
 W !!,"This program sets FileMan dictionaries so users cannot delete"
 W !,"entries.  Files are set by a range of dictionary numbers.",!!
 ;
 D ^%AUDSET
 G:'$D(^UTILITY("AUDSET",$J)) EOJ
ASK W !!,"Do you want to be asked before setting each file? (Y/N) Y// " R AUNDASK S:AUNDASK="" AUNDASK="Y" I "YyNn"'[AUNDASK W *7 G ASK
 W !
 S AUNDASK=$S("Yy"[$E(AUNDASK):1,1:0)
 S AUNDFILE="" F AUNDL=0:0 S AUNDFILE=$O(^UTILITY("AUDSET",$J,AUNDFILE)) Q:AUNDFILE=""  D PROCESS
 G EOJ
 ;
PROCESS ;
 S AUNDANS="Y"
 I $D(@("^DD("_AUNDFILE_",.01,""DEL"",.01,0)")) W !,@("$P(^DIC("_AUNDFILE_",0),U,1)")," is already protected." Q
 W !,@("$P(^DIC("_AUNDFILE_",0),U,1)"),$S(AUNDASK:"..OK? Y// ",1:"")
P2 I AUNDASK R AUNDANS S:AUNDANS="" AUNDANS="Y" I "YyNn"'[$E(AUNDANS) D P2ERR G P2
 I AUNDANS="Y" S @("^DD("_AUNDFILE_",.01,""DEL"",.01,0)")="I 1" W "  Done"
 Q
P2ERR W *7 F AUNDI=1:1:$L(AUNDANS) W @BS," ",@BS
 Q
 ;
EOJ ;
 K ^UTILITY("AUDSET",$J)
 K AUNDANS,AUNDASK,AUNDFILE,AUNDI,AUNDL
 K BS,FF,RM,SL,SUB,XY
 W !!,"Bye",!!
 Q
