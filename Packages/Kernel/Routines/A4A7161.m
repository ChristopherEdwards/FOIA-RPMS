A4A7161 ; GLRISC/REL - New Person File conversion ;5/4/89  14:27 ;
 ;;1.01
 S U="^" W !!,"*** WARNING! ***  This program will take all File 16 entries"
 W !,"and add them to the New Person File. This conversion REQUIRES"
 W !,"that the prior A5A5 File 3-16 linkage programs have been run."
 D DT^DICRW S (NUM200,LAST200,PTR,TOT)=0
 W !,"A VERIFY run will perform the same checks as the UPDATE run"
 W !,"except that no entries are moved to the New Person file"
 W !,"nor are any persons in File 16 added to File 3."
 W !!,"You should run VERIFY first. Correct as many errors as"
 W !,"possible and then make an UPDATE run which will move"
 W !,"entries into the New Person File. The final step is the"
 W !,"initialization of the files using A4A7INIT and re-indexing File 200."
P0 R !!,"Verify or Update run? VER// ",VER:DTIME Q:'$T!(VER["^")  S:VER="" VER="V" I $P("VERIFY",VER,1)'="",$P("UPDATE",VER,1)'="" W *7," Enter V or U" G P0
 S VER=$E(VER,1)
P1 W !!,"Pass 1 will be made through File 3 to make sure"
 W !,"that the 3-16 pointer has a 16-3 back-pointer."
 W !!,"Beginning Pass 1...",!
 F K=.9:0 S K=$N(^DIC(3,K)) Q:K<1  D A1
 I TOT,(PTR/TOT)>.7999 G P2
 W *7,!!,"***** Less than 80% of your File 3 entries have pointers"
 W !,"to File 16. It appears that your A5A5 initialization was"
 W !,"never performed or was incomplete. We cannot continue with"
 W !,"this ",$S(VER="V":"verification",1:"update")," until the A5A5 updating is complete.",! Q
P2 W !!,"During Pass 2 the File 16 pointer to File 3 will be checked"
 W !,"as well as the File 3 to 16 back-pointer."
 W !!,"Two possible error conditions may occur: the name in File 3"
 W !,"may not match that in 16. Most likely this is the result of"
 W !,"a typing error. A list of such mis-matches will be produced."
 W !!,"A second condition is if more than one entry in File 16"
 W !,"points to the same File 3 entry. Such cases are also listed.",!
 I VER="U" W !,"File 200 entries will be created during this pass.",!,"If the File 3 name differs from that in 16, the File 3 name is used.",!
 W !!,"Beginning Pass 2...",!
 S (ERR1,ERR2)=0 K ^UTILITY($J)
 F K=.9:0 S K=$N(^DIC(16,K)) Q:K<1  I $D(^DIC(16,K,"A3"))#2 D A2
 D:ERR2 A22 K ^UTILITY($J)
 G ^A4A7162
A1 S P16=$S($D(^DIC(3,K,0))#2:$P(^(0),"^",16),1:""),TOT=TOT+1 Q:P16<1
 S P3=$S($D(^DIC(16,P16,"A3"))#2:^("A3"),1:""),PTR=PTR+1
 Q:P3=K  I P3>0 S $P(^DIC(3,K,0),"^",16)="" Q
 I $D(^DIC(16,P16,0))#2 S ^DIC(16,P16,"A3")=K Q
 S $P(^DIC(3,K,0),"^",16)="" Q
A2 S X0=$S($D(^DIC(16,K,0))#2:^(0),1:""),P3=+^("A3") I P3<1 K ^DIC(16,K,"A3") Q
 S X3=$S($D(^DIC(3,P3,0))#2:^(0),1:"") I X3="" K ^DIC(16,K,"A3") Q
 S P16=$P(X3,"^",16) I P16="" S $P(^DIC(3,P3,0),"^",16)=K,P16=K
 S NAM3=$P(X3,"^",1),NAM16=$P(X0,"^",1),SSN=$P(X0,"^",9)
 I $D(^UTILITY($J,P3)) S ^UTILITY($J,"E2",P3)=K,ERR2=ERR2+1 Q
 G:NAM3=NAM16 A21
 I 'ERR1 W !!?18,"File 3 - File 16 Name Mis-Matches",!,"File 3 #",?12,"File 3 Name",?45,"File 16 #",?57,"File 16 Name",!
 S ERR1=ERR1+1 W !,+P3,?12,NAM3,?45,K,?57,NAM16
A21 S ^UTILITY($J,P3)=K I VER="U" D ADD200
 Q
A22 W !!?8,"File 3 Entries pointed to by More than 1 File 16 Entry"
 W !,"File 3 #",?12,"File 3 Name",?45,"File 16 #",?57,"File 16 Name",!
 F P3=0:0 S P3=$N(^UTILITY($J,"E2",P3)) Q:P3<1  S K2=^(P3) D A23
 Q
A23 S K1=^UTILITY($J,P3),NAM3=$S($D(^DIC(3,P3,0))#2:$P(^(0),"^",1),1:"")
 W !!,P3,?12,NAM3,?45,K1,?57,$S($D(^DIC(16,K1,0))#2:$P(^(0),"^",1),1:"")
 W !?45,K2,?57,$S($D(^DIC(16,K2,0))#2:$P(^(0),"^",1),1:"") Q
ADD200 Q:$D(^VA(200,P3))  Q:NAM3=""  S NUM200=NUM200+1,LAST200=P3
AD1 I NAM3[", " S NAM3=$P(NAM3,", ",1)_","_$P(NAM3,", ",2,99) G AD1
 S ^VA(200,P3,0)=NAM3
 S:SSN'="" $P(^VA(200,P3,1),"^",9)=SSN Q
