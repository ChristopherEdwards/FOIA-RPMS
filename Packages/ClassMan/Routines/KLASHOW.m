KLASHOW ;GLRISC/PDW  SLIDE SHOW FOR CLASSMAN ;DEC 18,1990@13:54:58
 ;;1.0;2.01
 S U="^",X="T",%DT="",IOP=$I D ^%DT S DT=Y D ^%ZIS K X,Y,%DT S X=125 X ^%ZOSF("RM")
 S DIC="^%ZIS(2,",DIC(0)="AQMZ",DIC("S")="I $P(^(0),U,1)[""C-""",DIC("B")=$S($D(IOST):IOST,1:"C-VT100") D ^DIC I Y'>0 W !,"Sorry, you must have a subtype !",! Q
 K DIC S IOP="HOME;"_Y(0,0) D ^%ZIS S FF=IOF S X=125 X ^%ZOSF("RM")
 S VN=$P(^%ZIS(2,IOST("0"),5),"^",5),VR=$P(^%ZIS(2,IOST("0"),5),"^",4)
 S:VN="" VN="""""" S:VR="" VR=""""""
 S KLSLDIC="^KLAS(1200.1,"
 ; --- lookup presentation ---
 S DIC=KLSLDIC,DIC(0)="AEQ",DIC("A")="     Which presentation do you want: " D ^DIC G:Y<0 STOP
 S DIE=DIC,DA=+Y,DR="11" D ^DIE
 S NIEN=DA,SEQ=@(KLSLDIC_NIEN_",""S"")"),KLSLDIC=KLSLDIC_NIEN_",1,"
 K X,Y,DIC
 ; --- set up sequence ---
 F I=0:1 S SEQ(I)=$P(SEQ,":",I) Q:I>0&(SEQ(I)="")  S LFR=I ; SET UP SEQUENCE
 ; --- get first frame ---
 S TV=0,X=SEQ(1),FR=0,DIC=KLSLDIC,KLSLNF=SEQ(1)
 D SEL ;**NEW CODE
 Q:'$D(FR)  ;**NEW CODE
A S DIC(0)="ZN" D ^DIC G:Y<0 ERROR
 ; --- get frame parameters ---
 S KLSLCF=$P(Y(0),U,1),KLSLTY=$P(Y(0),U,2),KLSLNF=SEQ(FR+1),KLSLPF=SEQ(FR-1),KLSLIN=+$P(Y(0),U,5)
 S:KLSLTY="" KLSLTY="N"
 S BUILD=$S(KLSLTY["L":1,1:0)
 ; --- set frame type ---
 S KLSLDIC=DIC_+Y_",""W"","
 ; --- display frame ---
B U IO(0) W @FF X ^%ZOSF("EOFF") D FIX1 S I1=0 F I=0:0 S I1=$N(@(KLSLDIC_I1_")")) Q:(I1=-1)!(I1'?.N)  S KLSLLI=@(KLSLDIC_I1_",0)") D LINE D:BUILD B1
 G NEXT
B1 ;R X:600 S X=$A(X) Q:X=94  D:X=63 HELP2 G:X=63 B1 S:(X=88)!(X=120) BUILD=0 Q
 R X:DTIME S X=$E(X) D:X="?" HELP2 G:X="?" B1 S:X="" X="F" S:"^Qq"[X BUILD=0 Q
NEXT ; --- find out what is next ---
 S DX=69 W *13 X "F IN=1:1:DX W "" """
LINE1 R A:DTIME S A=$E(A) D:A="?" HELP G LINE1:A="?" G:"Ff +"[A FWD G:"Bb-"[A BACK G:"^EeQq"[A END G:"Jj"[A JMP S:"Rr"[A X=SEQ(FR) G:$T A W *7 G NEXT
 ; --- subroutines ---
LINE ; line subroutine
 I KLSLTY["N" D LP W ! Q:I1#23  W ?40 R X:DTIME S X=$E(X) S:X="" X=" " D:"?"[X HELP1 G:"?"[X LINE S I1=$S("-BbRr"[X:I1-46,"Xx^"[X:I1+9999,1:I1) S:I1<0 I1=0 W:"-"[X !,"**********MOVING BACKWARD**********",! W *13 Q
 D LP
 W !," ",!
JJJ I '(I1#11) W ?40 R X:DTIME S X=$E(X) S:X="" X="F" D:"?"[X HELP1 G:"?"[X JJJ S I1=$S("-Bb"[X:I1-46,"Qq^"[X:I1+9999,1:I1) S:I1<0 I1=0 W:"-Bb"[X !,"**********MOVING BACKWARD**********",! W *13
 Q
LP ; PRINT LINE
 F K=1:1:$L(KLSLLI) S X=$E(KLSLLI,K) D FIX W ""
 Q
FIX I X="~" S TV=(TV+1)#2 W @$S(TV:"@VR",1:"@VN")
 E  W X
 W:KLSLTY["E" " "
 Q
JMP X ^%ZOSF("EON") W !,*13 S DX=66 X "F IN=1:1:DX W "" """ R "to:",X:DTIME S:X="" X=FR+1 G:$E(X)="^" END
 I X>0,X<(LFR+1) S FR=X,X=SEQ(X) G A
 I X'="?" W *7 G SEL
SEL F I=1:1:LFR W !,?10,I W ?15,$P(@(DIC_SEQ(I)_",0)"),U,1) W:I=FR "   *"
 G JMP
FWD G:KLSLNF="" END S X=KLSLNF S FR=FR+1 G A
BACK W:KLSLPF="" *7 G:KLSLPF="" NEXT S X=KLSLPF S FR=FR-1 G A
END W @FF S DX=33 X "F IN=1:1:DX W "" """ W "T H E   E N D" W !!! X ^%ZOSF("EON")
STOP K VT,VN,VR,KLSLDIC,KLSLCF,KLSLTY,KLSLNF,KLSLPF,KLSLIN,KLSLLI,I,I1,J,A,X,DIE,DA,DR,DIC,IOP,FF,SEQ,NIEN,LFR,TV,FR,BUILD,DX,K,INQ,DA,Y,KLI,KLN,KLP S X=IOM X ^%ZOSF("RM") Q
ERROR W !!,"ERROR" Q
HELP W !!,"OPTIONS FOR THIS COMMAND",!!
 W "TO ADVANCE TO NEXT SLIDE: <RET> ",!!
 W "TO MOVE BACKWARD ONE SLIDE:  <->, <B>, -OR- <b>",!!
 W "TO REPEAT CURRENT SLIDE:  <R>, -OR- <r>",!!
 W "TO JUMP TO ANOTHER SLIDE: <J>, -OR- <j>",!!
 W "TO QUIT: <^>, <Q>, -OR- <q>",!!
 W ?79 Q
HELP1 W !,"<->, <B> or <b> Backs Up 48 Lines",!,"<Q>, <q> or <^> Goes to end of slide",! Q
 ;
HELP2 W !," (^), <Q>, or <q>  -- WILL STOP LINE-BY-LINE MODE",!! Q
FIX1 ;W "SLIDE NAME: ",$P(Y,U,2),?50,"NUMBER: ",FR,! H 2 W @FF Q  ; OLD LINE
 ;W "SLIDE NAME: ",$P(Y,U,2),?50,"NUMBER: ",FR,! H 2 W ! Q  ; NEW LINE
TEST ; TEST VALIDITY OF SEQUENCE
X S KLP=0 F KLC=1:1 S KLP=$F(X,":",KLP) Q:KLP=0
 F KLI=1:1:KLC S KLN=$P(X,":",KLI) D TX
 K KLP,KLN,KLC
 Q
TX I (KLN'?.N)!(KLN<1) S X=""
 E  S:'$D(@("^KLAS(1200.1,"_DA_",1,"_KLN_")")) X=""
 Q
