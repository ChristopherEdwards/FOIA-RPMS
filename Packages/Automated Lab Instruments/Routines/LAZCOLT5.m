LACOLT5 ;SLC/RWF- COULTER S PLUS IV, V, VI ; 4/13/87  16:49 ; [ 12/11/89  2:27 PM ]
 ;;V~4.08~
 ;Format 1, CROSS LINK ID = SEQ # ,TRAY=1, CUP = ID, IDE=patient id
LA1 S LANM=$T(+0),TSK=$N(^LAB(62.4,"C",LANM,0)),U="^" Q:TSK<1
 Q:'$D(^LA(TSK,"I",0))
 S TOUT=0,TP="",LRTOP=$P(^LAB(69.9,1,1),U,1) D ^LASET Q:'TSK  S @TRAP
 S SS="CH"
LA2 K TV,Y S A=0,TOUT=0 D IN G QUIT:TOUT,LA2:IN'["--------"
C2 S TOUT=0 D IN G QUIT:TOUT,SAVE:$E(IN,1,8)="--------"
C3 S A=A+1,Y(A)=""
 S X="" F I=1:1:$L(IN) S:$A(IN,I)-32 X=X_$E(IN,I)
 S F(A)=$P(X,",",1),X=$P(X,",",2),Y(A)=$S(".....-----+++++"[X:"",1:X) G C2
SAVE G LOST:'$D(Y(2)) F I=0:0 S I=$O(TC(I)) Q:I<1  X TC(I,2) S @TC(I,1)=V
 S ID=+Y(4),TRAY=1,CUP=ID,IDE=+Y(4) G LA2:ID'>0 S SPEC=$P(^LAB(69.9,1,1),U,1)  ;IHS/ANMC/CLS 12/11/89
LA3 X LAGEN G LA2:ISQN<1
 S Z=TSK_">" F I=0:0 S I=$N(TV(I)) Q:I<1  S:TV(I,1)]"" ^LAH(LWL,1,ISQN,I)=TV(I,1),Z=Z_TV(I,1)_" "
 D WRITE G LA2
LOST S:'$D(^LA("LOST",DT)) ^LA("LOST",DT)=1
 S AA=^LA("LOST",DT),^LA("LOST",DT,AA)=IN,^LA("LOST",DT)=AA+1
 S Z="LOST DATA " D WRITE G LA2
 Q
IN S CNT=^LA(TSK,"I",0)+1 IF '$D(^(CNT)) S TOUT=TOUT+1 Q:TOUT>9  H 9 G IN
 S ^LA(TSK,"I",0)=CNT,IN=^(CNT),TOUT=0 I ECHOALL S Z=IN D WRITE
 S:IN["~" CTRL=$P(IN,"~",2),IN=$P(IN,"~",1)
 Q
OUT S CNT=^LAB(TQ,"O")+1,^("O")=CNT,^("O",CNT)=OUT
 LOCK ^LAB("Q") S Q=^LAB("Q")+1,^("Q")=Q,^("Q",Q)=TQ LOCK
 Q
WRITE I IO]"" O IO::1 IF $T U IO W:'ECHOALL *7 W !,Z C IO
 Q
QUIT LOCK ^LA(TSK) H 1 K ^LA(TSK),^LA("LOCK",TSK) I $D(ZTSK) K ^%ZTSK(ZTSK)
 Q
TRAP K ^LA("LOCK",TSK) S T=TSK D SET^LAB X ^LAB("X","%ET") G @("^"_LANM) ;ERROR TRAP