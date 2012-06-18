A6V7PCH1 ;SFISC/RWF - TO RESET THE CREATOR AND DATE FOR FILE 200. ;12/12/91  07:51
 ;;1;
A W !!,"This routine will move the 'date entered' and 'creator' data",!,"from the USER file to the NEW PERSON file. The NEW PERSON file was filled in"
 W !,"when the A4A7161 routine was run."
 S DIR(0)="Y",DIR("A")="Move the data from file 3 to file 200 ",DIR("B")="YES" D ^DIR G EXIT:$D(DIRUT)!(Y'=1)
 W !!,"Moving the data: "
 F DA=0:0 S DA=$O(^DIC(3,DA)) Q:DA'>0  S F3=$G(^DIC(3,DA,1)),F2=$G(^VA(200,DA,1)) D  W:'(DA#10) "."
 . S X3=$P(F3,U,7,8),X2=$P(F2,U,7,8)
 . Q:"^"[X3  Q:X3=X2  I X2,X2<X3 Q
 . S $P(^VA(200,DA,1),U,7,8)=X3
 . Q
 W !!,"DONE"
EXIT K DIR,DA,F2,F3,X2,X3,U
 Q
