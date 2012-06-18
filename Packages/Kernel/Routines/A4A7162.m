A4A7162 ; GLRISC/REL - New Person conversion ;5/4/89  14:28 ;
 ;;1.01
P3 W !!,"During Pass 3 we will identify all entries in File 16"
 W !,"which are NOT in File 3."
 I VER="U" W !!,"We will add them to File 3 as well as to File 200."
 W !!,"Beginning Pass 3...",! S ERR3=0
 F K=.9:0 S K=$N(^DIC(16,K)) Q:K<1  I '$D(^DIC(16,K,"A3"))#2 D A3
P4 W !!,"We will now check that there are no entries in File 3 which"
 W !,"are NOT in File 16. If so, this means that the"
 W !,"File 3-16 linkage was missing. We will list any such cases."
 I VER="U" W !!,"We will also move them to File 200."
 W !!,"Beginning Pass 4...",!
 S ERR4=0
 F K=.9:0 S K=$N(^DIC(3,K)) Q:K<1  I $D(^DIC(3,K,0))#2,$P(^(0),"^",16)<1 D A4
 G ^A4A7163
A3 S X0=$S($D(^DIC(16,K,0))#2:^(0),1:"") Q:X0=""
 S NAM16=$P(X0,"^",1),SSN=$P(X0,"^",9)
 S ERR3=ERR3+1
 I VER="U" D ADD3 S NAM3=NAM16,INIT="" D:P3>0 ADD200 W:ERR3#10=0 "."
 Q
A4 S X0=$S($D(^DIC(3,K,0))#2:^(0),1:""),NAM3=$P(X0,"^",1) Q:NAM3=""
 S INIT=$P(X0,"^",2)
 I 'ERR4 W !!?20,"File 3 Entries NOT in File 16",!,"File 3 #",?12,"File 3 Name",!
 S ERR4=ERR4+1 W !,K,?12,NAM3
 S SSN="",P3=K I VER="U" D ADD200
 Q
ADD200 Q:$D(^VA(200,P3))  Q:NAM3=""  S NUM200=NUM200+1,LAST200=P3
AD1 I NAM3[", " S NAM3=$P(NAM3,", ",1)_","_$P(NAM3,", ",2,99) G AD1
 S ^VA(200,P3,0)=NAM3
 S:SSN'="" $P(^VA(200,P3,1),"^",9)=SSN Q
ADD3 S DIC="^DIC(3,",DIC(0)="LMF",X=NAM16 K DO D FILE^DICN
 S P3=+Y Q:P3<1  S $P(^DIC(3,P3,0),"^",16)=K,^DIC(16,K,"A3")=P3 Q
