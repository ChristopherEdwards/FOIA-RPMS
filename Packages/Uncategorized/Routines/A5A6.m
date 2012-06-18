A5A6 ;FIX WARD/HOSPITAL LOCATION STRUCTURE CJS/SLC ; 8/27/86  8:28 AM ; [ 04/09/90  8:38 AM ]
 ;;V~2~
 S U="^" I '$D(DT) S X="T" D ^%DT S DT=Y
 I $D(DUZ)'=11 S DIC(0)="AEMQZ",DIC=3,DIC("A")="Enter your last,first name: " D ^DIC Q:Y<1  S DUZ=+Y,DUZ(0)=$P(Y(0),U,4)
 W !,"Finding all perfect matches, '.' for non-matches, ',' for matches."
 S DIC("S")="I '$D(^(42)),""W""=$P(^(0),""^"",3)",E1=0 F IA5A6=0:0 S IA5A6=$N(^DIC(42,IA5A6)) Q:IA5A6'>0  I $D(^(IA5A6,0)),'$D(^(44)) S N=$P(^(0),"^",1),P=$N(^SC("B",N,0)) W $S(P<0:".",1:"") D:P>0 PERMATCH
 W !!,"Now the entries that had no matches."
 S N="" F IA5A6=0:0 S N=$O(^DIC(42,"B",N)) Q:N=""  Q:E1  F IA5A6=0:0 S IA5A6=$N(^DIC(42,"B",N,IA5A6)) Q:IA5A6'>0  I $D(^DIC(42,IA5A6,0)),'$D(^(44)) S DA=IA5A6,DIC(0)="EM",X=$E(N,1,2) D ANYMATCH Q:E1
END K DA,DIC,DIE,DIG,DIH,DIU,DIV,DIW,DQ,DR,E1,IA5A6,N,N1,P,X,Y
 Q
PERMATCH I $N(^SC("B",N,P))>0 W "." Q
 W "," S ^DIC(42,IA5A6,44)=P,^SC(P,42)=IA5A6
 Q
CLOMATCH W !!,"WARD LOCATION: ",N1,"   HOSPITAL LOCATION: ",$P(Y,"^",2),!,"  OK" S %=1 D YN^DICN Q:%=2  I %=0 W !,"If you're not sure, you can answer NO and come back to it later." G CLOMATCH
 I %=-1 S E1=1 Q
 S ^DIC(42,IA5A6,44)=+Y,^SC(+Y,42)=IA5A6
C W !,"Use the 'HOSPITAL LOCATION' name: ",$P(Y,"^",2) S %=1 D YN^DICN I %=0 W !,"YES selects the HOSPITAL LOCATION name, NO selects the WARD LOCATION name, for both entries." G C
 I %=-1 W !,"""^"" not allowed, you must make a choice." G C
 S DR=".01///"_$S(%=1:$P(Y,"^",2),1:N1),DIE="^SC(",DA=+Y D ^DIE
 Q
ANYMATCH W !!,"WARD LOCATION: ",N S DIC="^SC(" D ^DIC I Y<0 W !,"  Nothing even close, accept the default to stuff it."
 S DIE="^DIC(42,",DR="44//"_$S(Y<0:N,1:$P(Y,"^",2)) D ^DIE
 S %=2 I $D(Y) W !,"WANT TO QUIT" S %=1,DIC(0)="AEM" D YN^DICN G ANYMATCH:%=2 I %=0 W !,"If you're not sure, you can answer NO and come back to it later." G ANYMATCH
 I %=-1!(%=1) S E1=1 Q
 S J=^DIC(42,IA5A6,44),Y=$P(^SC(J,0),"^",1),$P(^SC(J,0),"^",3)="W" I N'=Y S N1=N,Y=J_"^"_Y D C
 Q
