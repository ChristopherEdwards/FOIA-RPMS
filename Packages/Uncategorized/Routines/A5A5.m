A5A5 ;FIX USER/PERSON STRUCTURE CJS/SLC ; 8/27/86  3:05 PM ; [ 04/09/90  8:29 AM ]
 ;;V~2~
 S U="^" I '$D(DT) S X="T" D ^%DT S DT=Y
 I $D(DUZ)'=11 S DIC(0)="AEMQZ",DIC=3,DIC("A")="Enter your last,first name: " D ^DIC Q:Y<1  S DUZ=+Y,DUZ(0)=$P(Y(0),U,4)
CHOICE W !,"Start at --",!,?10,"1  First pass",!?10,"2  Second pass",!?10,"3  Third pass",!,"Select your choice: 1//" R X:60 G END:'$T!(X="^")
 I X="?" W !,"If you've finished the first pass, you may restart at the second pass, etc." G CHOICE
 I X'="" G FIRST:X=1,SECOND:X=2,THIRD:X=3 W !,"Please enter 1, 2 or 3." G CHOICE
FIRST W !,"Finding all perfect matches, '.' for non-matches, ',' for matches."
 S DIC("S")="I '$P(^(0),U,16)",E1=0 F IA5A5=.5:0 S IA5A5=$N(^DIC(3,IA5A5)) Q:IA5A5'>0  I $D(^(IA5A5,0)),'$P(^(0),U,16) S N=$P(^(0),"^",1),P=$N(^DIC(16,"B",N,0)) W $S(P<0:".",1:"") D:P>0 PERMATCH
SECOND W !!,"Finding all last name matches.  Answer yes if they're the same."
 W !,"Checking through the PERSON file to find possible match(es) for the USER file" S DIC="^DIC(16,",DIC(0)="EM",E1=0,N="",A5="W ""   matching to User   "",N1"  ;IHS/ANMC/CLS 05/10/89
 F IA5A5=0:0 S N=$O(^DIC(3,"B",N)) Q:N=""  Q:E1  F IA5A5=0:0 S IA5A5=$N(^DIC(3,"B",N,IA5A5)) W "." Q:IA5A5'>0  I $D(^DIC(3,IA5A5,0)),'$P(^(0),U,16),N'="POSTMASTER" S N1=$P(^(0),"^",1),X=$P(N1,",",1),DIC("W")=A5 D ^DIC,CLOMATCH:Y>0 Q:E1
 I E1 W !,"OK, We'll pick up later where you left off." G END
THIRD W !!,"Now the entries that had no matches."
 S N="",E1=0 F IA5A5=0:0 S N=$O(^DIC(3,"B",N)) Q:N=""  Q:E1  F IA5A5=0:0 S IA5A5=$N(^DIC(3,"B",N,IA5A5)) Q:IA5A5'>0  I $D(^DIC(3,IA5A5,0)),'$P(^(0),U,16),N'="POSTMASTER" S DA=IA5A5,DIC(0)="EM",X=$E(N,1,3) D ANYMATCH Q:E1
END W !,"Ready to do the x-referencing" S %=1 D YN^DICN G LEND:%=2!(%=-1)
 I %=0 W !,"You may do the x-referencing later." G END
 W !,"NOW CREATING THE 'A6' X-REF ON THE PERSON FILE",!
 F DA=0:0 S DA=$O(^DIC(6,DA)) Q:DA'>0  I $D(^DIC(16,DA,0)) W "." S J=$P(^(0),"^",1) I $L(J) S ^DIC(16,"A6",J,DA)="",^DIC(16,DA,"A6")=DA  ;IHS/ANMC/CLS 05/10/89 added set of "A6" node contents
 W !,"NOW I WILL RE-INDEX THE PERSON FILE ENTRIES THAT HAVE USER POINTERS",!
 S DIK="^DIC(16," F DA=0:0 S DA=$O(^DIC(16,DA)) Q:DA'>0  I $D(^(DA,0)),$P(^(0),"^",16) W "." D IX1^DIK
LEND K DA,DIC,DIE,DIG,DIH,DIU,DIV,DIW,DQ,DR,E1,IA5A5,N,N1,P,X,Y,A5
 Q
PERMATCH I $N(^DIC(16,"B",N,P))>0 W "." Q
 W "," S $P(^DIC(3,IA5A5,0),U,16)=P,^DIC(16,P,"A3")=IA5A5
 Q
CLOMATCH W !!,"USER: ",N1,"   PERSON: ",$P(Y,"^",2),!,"  OK" S %=1 D YN^DICN Q:%=2  I %=0 W !,"If you're not sure, you can answer NO and come back to it later." G CLOMATCH
 I %=-1 S E1=1 Q
 S $P(^DIC(3,IA5A5,0),U,16)=+Y,^DIC(16,+Y,"A3")=IA5A5
C W !,"Use the 'PERSON' name: ",$P(Y,"^",2) S %=1 D YN^DICN I %=0 W !,"YES selects the PERSON name, NO selects the USER name, for both entries." G C
 I %=-1 W !,"""^"" not allowed, you must make a choice." G C
 S DR=".01///"_$S(%=1:$P(Y,"^",2),1:N1),DIE="^DIC(16,",DA=+Y,^DIC(16,+Y,31)=$S(%=1:N1,1:$P(Y,"^",2)) D ^DIE
 Q
ANYMATCH W !!,"USER: ",N,"  PERSON beginning with: ",X S DIC="^DIC(16," D ^DIC I Y<0 W !,"  Nothing even close, accept the default to stuff it."
 S DIE="^DIC(3,",DR="100//"_$S(Y<0:N,1:$P(Y,"^",2)) D ^DIE
 S %=2 I $D(Y) W !,"WANT TO QUIT" S %=1,DIC(0)="AEM" D YN^DICN G ANYMATCH:%=2 I %=0 W !,"If you're not sure, you can answer NO and come back to it later." G ANYMATCH
 I %=-1!(%=1) S E1=1 Q
 S J=$P(^DIC(3,IA5A5,0),U,16),Y=$P(^DIC(16,J,0),"^",1) I N'=Y S N1=N,Y=J_"^"_Y D C
 Q
