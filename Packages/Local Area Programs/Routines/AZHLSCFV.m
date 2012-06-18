AZHLSCFV ; IHS/ADC/GTH:KEU - DSM QABLE FIELD VERIFIER ;
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
 NEW A,AZHLFLDS,AZHLNMSP,DIC,DA,DDC,DE,DG,DIFLD,DIR,DIRUT,DISYS,DIU,DQ,DQI,DR,D0,B,C,D,E,F,G,I,J,L,N,P,Q,S,T,V,W,Z
 ;
 S:'$D(DTIME) DTIME=300
0 W !!!?4,$P($P($T(@"AZHLSCFV"),";",2),"-",2)," v ",$P($T(@"AZHLSCFV"+1),";",3),!
 W !! S DIC="^DIC(",DIC(0)="QAZEM" D ^DIC G:Y<0 Q S A=+Y,AZHLNMSP=$P(^DIC(A,0),U),DIU=^(0,"GL")
 ;
 K J
 S Q="""",S=";",V=0,P=0,I(0)=DIU,@("(A,J(0))=+$P("_DIU_"0),U,2)")
 I $O(^(0))'>0 W *7,"  NO ENTRIES ON FILE!" Q
DIC S DIC="^DD(A,",DIC(0)="EZ",DIC("W")="W:$P(^(0),U,2) ""  (multiple)"""
 S DIC("S")="S %=$P(^(0),U,2) I %'[""C"",$S('%:1,1:$P(^DD(+%,.01,0),U,2)'[""W"")"
 W !,"VERIFY WHICH "_$P(^DD(A,0),U)_": " R X:DTIME Q:U[X
 I X="ALL" D ALL^DIV G Q:$D(DIRUT) I Y S AZHLFLDS="ALL" G DEVICE
 D ^DIC K DQI,^UTILITY("DIVR",$J)
 I Y<0 W:X?1."?" !?3,"You may enter ALL to verify every field at this level of the file.",! G DIC
 S DR=$P(Y(0),U,2) I DR S J(V)=A,P=+Y,V=V+1,A=+DR,I(V)=$P($P(Y(0),U,4),S,1) S:+I(V)'=I(V) I(V)=Q_I(V)_Q G DIC
 S AZHLFLDS=X
 ;
 ;
DEVICE W !!,"Report will be QUEUE'd if device other than HOME selected.",! K IOP,%ZIS S %ZIS="NQM",%ZIS("B")="" D ^%ZIS K %ZIS I POP W !,*7,"No device specified." G Q
 S IOP=ION_";"_IOST_$S($D(IO("DOC")):";"_IO("DOC"),1:";"_IOM_";"_IOSL)
 I IO=IO(0),"C"[$E(IOST),$D(IO("Q"))#2 W !,"Can't Q to home device." K IO("Q") G DEVICE
 I IO'=IO(0),'$D(IO("Q")) W !!,"Report being QUEUE'd to run now for you." S IO("Q")=1,ZTDTH=$H
 I '$D(IO("Q")) D ^%ZIS G START
 S ZTRTN="START^AZHLSCFV",ZTIO=IOP,ZTDESC="FIELD VERIFICATION of "_AZHLNMSP_" file." S ZTSAVE("*")=""
 K IO("Q") D ^%ZTLOAD D HOME^%ZIS
DEVEND K IOP,ZTSK G Q
START ;EP - From TaskMan.
 S X="QEND^AZHLSCFV",@^%ZOSF("TRAP")
 U IO W !!,"<<<<<<<   DSM QABLE FIELD VERIFIER    >>>>>>>",!,"File : ",AZHLNMSP," (",$S($D(^DIC(A,0,"GL")):^("GL"),1:A),")",! D BEG^AZHLSC
 I AZHLFLDS="ALL" F DQI=0:0 S DQI=$O(^DD(A,DQI)) G QEND:DQI'>0 S Y=DQI,Y(0)=^(Y,0),DR=$P(Y(0),U,2) I 'DR,DR'["C" W !!,"--",$P(Y(0),U),"--" D 1
 S Y=$O(^DD(A,"B",AZHLFLDS,0))
1 F T="N","D","P","S","V","F" Q:DR[T
 F W="FREE TEXT","SET OF CODES","DATE","NUMERIC","POINTER","VARIABLE POINTER","K" I T[$E(W) S:W="K" W="MUMPS" W "   ",W
 K DA S Z=$P(Y(0),U,3),DDC=$P(Y(0),U,5,99),(DIFLD,DA)=+Y
 D ^DIVR
 Q:AZHLFLDS="ALL"
QEND ;EP - If error, probable for NODEV at Q+1^DIVR.
 S X="^%ET",@^%ZOSF("TRAP")
 W !!!,"<< DSM QABLE FIELD VERIFIER >>" D FIN^AZHLSC
 I $D(ZTQUEUED) Q
 D Q
 G 0
Q K DIR,DIRUT,N,P,Q,S,V,C
 Q
