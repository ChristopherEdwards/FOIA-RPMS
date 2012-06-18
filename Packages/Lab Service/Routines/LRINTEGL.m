LRINTEGL ;SLC/FHS - LOAD INTERGRITY FILE 69.91 ; 4/7/89  00:05 ;
 ;;V~5.0~;LAB;**24**;02/27/90 17:09
LOAD ;load routines into ^LAB(69.91,VNODE
 D STOP S LOAD=1 D VER^LRINTEG G STOP:Y<0
 S %ZIS="Q" D ^%ZIS G STOP:POP I $D(IO("Q")) S ZTRTN="QUE^LRINTEGL",ZTDESC="Loading LR INTEGRITY file #69.91 ",ZTIO=ION F I="LOAD","VNODE","VER","VERDAT" S ZTSAVE(I)=""
 I $D(IO("Q")) D ^%ZTLOAD G STOP
 U IO
QUE ;
 S U="^",XLOAD=^%ZOSF("LOAD"),DIF="^UTILITY(""LRINTEG"""_","_$J_",",LROSYS=$S(^%ZOSF("OS")["M/VX"!(^%ZOSF("OS")["M/11"):"^ROUTINE(ROU)",1:"^ (ROU)")
 S DA(1)=VNODE,DIE="^LAB(69.91,"_DA(1)_",""ROU"",",DIC(0)="L" S:'$D(@(DIE_"0)")) @(DIE_"0)")="^69.911^^" S DA=$S($D(@(DIE_"0)")):+$P(^(0),U,3)+1,1:1) S CNT=$S(DA=1:1,1:+$P(@(DIE_"0)"),U,4)+1)
 S (DIC(0),ROU)="L" F CNT=CNT:1 S ROU=$O(@LROSYS) Q:$E(ROU,1)'="L"  W !,ROU D GLB
 S $P(@(DIE_"0)"),U,3)=DA,CNT=CNT-1,$P(^(0),U,4)=CNT W !!,"TOTAL = ",CNT,@IOF K:$D(ZTSK) ^%ZSTK(ZTSK),ZTSK G STOP
GLB ; Stuff new routine in to global using auto load [if it doesn,t already exist] in global
 K ^UTILITY("LRINTEG",$J) S X=ROU,XCNP=0 X XLOAD I '$D(^UTILITY("LRINTEG",$J,2,0)) S CNT=CNT-1 W !?10,"ONLY ONE LINE IN ROUTINE ",! Q
 I ^UTILITY("LRINTEG",$J,2,0)'[";;V~" D ER2 S CNT=CNT-1 Q
 I ^UTILITY("LRINTEG",$J,2,0)'[VER D ER2 S CNT=CNT-1 Q
 I $D(@(DIE_"""B"","""_ROU_""")")) S CNT=CNT-1 Q
GLB1 I $D(@(DIE_DA_",0)")) S DA=DA+1 G GLB1
 K ^UTILITY("LRINTEG",$J) S DR=".01///^S X="""_ROU_""";" D ^DIE
 S $P(@(DIE_"0)"),U,3)=DA,$P(^(0),U,4)=CNT Q
STOP ; clean-up
 X ^%ZIS("C") K DIC,DIE,%ZIS
 K A,BIT,CNT,DIF,ER,I,II,IX,L,LN,LOAD,LROSYS,NT,ROU,SIZE,VER,VERDDT,VNODE,XBIT,XCMP,XCNP,XLOAD,XSIZE,XTEST,YBIT,^UTILITY("LRINTEG",$J) Q
ER2 ; Error msg when the version being loaded do not match the version selected for auto loading
 W !?10,ROU," is version ",$S($L($P(^UTILITY("LRINTEG",$J,2,0),"~",2)):$P(^(0),"~",2),1:"Unknown ")," NOT LOADED",*7,! Q
