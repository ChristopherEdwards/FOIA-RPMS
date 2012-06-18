ASDWL ; IHS/ADC/PDW/ENM - WAITING LIST ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
 K ^TMP("ASDWL",$J)
A ; -- driver
 NEW ASDC,ASDS
 D SC I Y<0 Q
 D SB I $D(DIRUT) Q
 D SD I POP D Q Q
 B
 I $D(IO("Q")) D QUE,Q Q
EN ;EP; -- queued EP
 U IO
 D LF,HD,LT,Q Q
 ;
 ;
SC ; -- select clinic
 K DIC S DIC="^ASDWL(",DIC(0)="AEQ" D ^DIC S ASDC=+Y K DIC Q
 ;
SB ; -- sort by
 K DIR S DIR("A")="Select SORT for Report",DIR(0)="N^1:3"
 S DIR("A",1)="Sort by  (1) Provider to be Seen"
 S DIR("A",2)="         (2) Date Added to List"
 S DIR("A",3)="         (3) Recall Date"
 W ! D ^DIR S ASDS=Y K DIR Q
 ;
SD ; -- select device
 S %ZIS="PQ" D ^%ZIS Q
 ;
QUE ; -- queued output
 S ZTRTN="EN^ASDWL",ZTDESC="Waiting List"
 S ZTSAVE("ASDC")="",ZTSAVE("ASDS")=""
 D ^%ZTLOAD Q
 ;
LF ; -- loop waiting list
 NEW I,N
 S I=0 F  S I=$O(^ASDWL(ASDC,1,I)) Q:'I  D
 . S N=$G(^ASDWL(ASDC,1,I,0)) Q:'N
 . S ^TMP("ASDWL",$J,ASDC,$$SORT(ASDS,N),+N,I)=N
 Q
 ;
LT ; -- loop temp
 NEW ASDI,DFN,ASDJ
 S ASDQ="",ASDI=0
 F  S ASDI=$O(^TMP("ASDWL",$J,ASDC,ASDI)) Q:ASDI=""!(ASDQ=U)  D
 . S DFN=0
 . F  S DFN=$O(^TMP("ASDWL",$J,ASDC,ASDI,DFN)) Q:'DFN!(ASDQ=U)  D
 .. S ASDJ=0
 .. F  S ASDJ=$O(^TMP("ASDWL",$J,ASDC,ASDI,DFN,ASDJ)) Q:'ASDJ!(ASDQ=U)  D
 ... I $Y>(IOSL-4) D NWPG Q:ASDQ=U
 ... S N=^TMP("ASDWL",$J,ASDC,ASDI,DFN,ASDJ)
 ... W !!,$E($P(^DPT(DFN,0),U),1,20),?22,$$HRN^ASDUT(DFN)
 ... W ?32,$$AGE(DFN),?40,$$PHONE(DFN)
 ... W ?56,$$DT($P(N,U,3)),?66,$$DT($P(N,U,6))
 ... W ?76,$$PRV($P(N,U,7))
 ... W:$P(N,U,4)]"" !?3,"(",$E($P(N,U,4),1,75),")"
 Q
 ;
HD ; -- heading
 I IOST["C-" W @IOF
 W !?12,$$CONF^ASDUT
 W !?2,"WAITING LIST for ",$P($G(^SC(+ASDC,0)),U)
 S Y=DT X ^DD("DD") W ?60,Y
 W !!,"Patient",?22,"HRCN",?33,"Age",?40,"Phone",?56,"Dt Added"
 W ?66,"Recall",?76,"Prov"
 W !,$$REPEAT^XLFSTR("=",80) Q
 ;
Q ; -- cleanup
 D ^%ZISC K ^TMP("ASDWL",$J) K DIR,POP,ASDQ Q
 ;
NWPG ; -- new page
 I IOST'["C-" W @IOF D HD Q
 K DIR S DIR(0)="E" D ^DIR S ASDQ=X
 I ASDQ="" D HD
 Q
 ;
DT(Y) ; -- date entered
 Q $S(Y="":"",1:$E(Y,4,5)_"/"_$E(Y,6,7)_"/"_$E(Y,2,3))
 ;
PRV(X) ; -- returns provider name
 Q $P($G(^VA(200,+X,0)),U,2)
 ;
SORT(S,N) ; -- returns sort subscript
 I S=1 Q $S($P(N,U,7)]"":$$PRV($P(N,U,7)),1:" ")
 I S=2 Q $S($P(N,U,3)]"":$P(N,U,3),1:" ")
 I S=3 Q $S($P(N,U,6)]"":$P(N,U,6),1:" ")
 Q " "
 ;
AGE(DFN) ; -- returns printable age
 Q $$VAL^XBDIQ1(9000001,DFN,1102.98)
 ;
PHONE(DFN) ; -- returns patient's phone #
 Q $E($$VAL^XBDIQ1(2,DFN,.131),1,15)
