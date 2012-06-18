DGPTR4 ;ALB/JDS/MJK/MTC - ALB/BOK  PTF TRANSMISSION ; 01 DEC 87 @0800
 ;;5.3;Registration;**338,423,415**;Aug 13, 1993
701 ; -- setup 701 transaction
 S Y=$S(T1:"C",1:"N")_"701"_DGHEAD,DGDDX=$P(+DG70,".")_"       ",Y=Y_$E(DGDDX,4,5)_$E(DGDDX,6,7)_$E(DGDDX,2,3)_$E($P(+DG70,".",2)_"0000",1,4)
 S X=DG70,(L,Z)=2 D ENTER0 K DGDDX
 S X=DG70 I "467"[($P(X,U,3)\1) S Y=Y_$P(X,U,3)_"         " G J
 S L=1 F Z=3:1:5 D ENTER
 S Y=Y_$S($D(^DIC(45.6,+$P(X,U,6),0)):$P(^(0),U,2),1:" "),L=3,Z=12 D ENTER S Y=Y_$E($P(X,U,13)_"   ",1,3)
J S L=3,Z=8 D ENTER0
 S Y=Y_"X"_$J($P(DG70,U,9),1)
 S DGXLS=$S($D(^ICD9(+$P(DG70,U,10),0)):$P(^(0),U,1),1:""),Y=Y_$S(DGXLS[".":$J($P(DGXLS,".",1),3)_$E($P(DGXLS,".",2)_"   ",1,3),1:$J(DGXLS,6))_" "
 S L=$P(DG70,U,16,24) S DG702="" F K=1:1:9 I $D(^ICD9(+$P(L,U,K),0)) S DG702=DG702_$P(^(0),U,1)_U
 S Y=Y_$S(DG702']"":"X",1:" ")
 ; -- get phy cdr @ d/c
 S X="",Z=+$O(^DGPT(J,535,"AM",DG70-.0000001)) I $D(^DGPT(J,535,+$O(^(Z,0)),0)) S X=^(0)
 ; -- set phy cdr
 S Z=$P(X,U,16) D CDR
 ; -- set phy spec
 S L=2,Z=2 D ENTER0
 S X=$S($P(DG3,U)="Y":$$RTEN($P(DG3,U,2)),1:"0"),L=3,Z=1 D ENTER0
 ;-- additional ptf questions
 S DGAUX=$S($D(^DGPT(J,300)):^(300),1:"")
 D ADDQUES
 K DGAUX,DGDRUG
 ;-- sc,ao,ir,ec questions
 S X=DG70
 ;-- sc
 S Y=Y_$E($P(DG70,U,25)_" ")
 ;-- ao
 S Y=Y_$E($P(DG70,U,26)_" ")
 ;-- ir
 S Y=Y_$E($P(DG70,U,27)_" ")
 ;-- ec
 S Y=Y_$E($P(DG70,U,28)_" ")
 ;-- mst
 S Y=Y_$E($P(DG70,U,29)_" ")
 ;-- Head/Neck CA
 S Y=Y_$E($P(DG70,U,30)_" ")
 D ETHNIC
 D RACE
 D FILL
 I T1 F K=41:1:55,65:1:73 S Y=$E(Y,1,K-1)_" "_$E(Y,K+1,125)
 I T1 D CEN^DGPTR1 S:'DGERR ^XMB(3.9,DGXMZ,2,DGCNT,0)=Y,DGCNT=DGCNT+1 Q
 I 'T1 D SAVE
702 ;
 Q:DG702']""
 S Y="N702"_$E(Y,5,40)
 F K=1:1:9 S F=$P(DG702,U,K),F=$P(F,".",1)_$E($P(F,".",2)_"   ",1,3),F=F_$E("      ",1,7-$L(F)),Y=Y_F
 D FILL
 I 'DGERR S ^XMB(3.9,DGXMZ,2,DGCNT,0)=Y,DGCNT=DGCNT+1
 I DGERR'>0 S DGACNT=DGACNT+1,^TMP("AEDIT",$J,$E(Y,1,4),DGACNT)=Y
 S DG702=$P(DG702,U,6,9)
 Q
 ;
ENTER S Y=Y_$J($P(X,U,Z),L)
 Q
 ;
ENTER0 S Y=Y_$S($P(X,U,Z)]"":$E("00000",$L($P(X,U,Z))+1,L)_$P(X,U,Z),1:$J($P(X,U,Z),L))
 Q
 ;
SAVE D START^DGPTR1 S:'DGERR ^XMB(3.9,DGXMZ,2,DGCNT,0)=Y,DGCNT=DGCNT+1
 I DGERR'>0 S DGACNT=DGACNT+1,^TMP("AEDIT",$J,$E(Y,1,4),DGACNT)=Y
Q Q
 ;
FILL F K=$L(Y):1:124 S Y=Y_" "
 Q
 ;
CDR S Y=Y_$E($P(Z,".")_"0000",1,4)_$E($P(Z,".",2)_"00",1,2)
 Q
ADDQUES ;-- additional PTF questions load records for trans 501/701
 S DGDRUG=$S($D(^DIC(45.61,+$P(DGAUX,U,4),0)):$P(^(0),U,2),1:"    ")
 S Y=Y_$E($P(DGAUX,U,3)_" ")_$E($P(DGAUX,U,2)_" ")_$J($P(DGDRUG,U),4)
 S Y=Y_$E($P(DGAUX,U,5)_" ")
 S DGT=0,X=$P(DGAUX,U,6) I X]"" S DGT=1,Z=1,L=2 D ENTER0
 I 'DGT S Y=Y_"  "
 S DGT=0,X=$P(DGAUX,U,7) I X]"" S DGT=1,Z=1,L=2 D ENTER0
 I 'DGT S Y=Y_"  "
 Q
RTEN(X) ; This function will round X to the nearest mulitple of ten.
 ; 0-4 ->DOWN; 5-9->UP
 Q (X\10)*10+$S(X#10>4:10,1:0)
ETHNIC ;-- Ethnicity (use first active value)
 N NODE,NUM,ETHNIC,I,X
 S ETHNIC=""
 S I=0
 S NUM=1
 F  S I=+$O(DG06(I)) Q:'I  D  Q:NUM>1
 .S NODE=$G(DG06(I,0))
 .Q:('NODE)!('$D(^DIC(10.2,+NODE,0)))
 .Q:$$INACTIVE^DGUTL4(+NODE)
 .S X=$$PTR2CODE^DGUTL4(+NODE,2,4)
 .S ETHNIC=$S(X="":" ",1:X)
 .S X=$$PTR2CODE^DGUTL4(+$P(NODE,"^",2),3,4)
 .S ETHNIC=ETHNIC_$S(X="":" ",1:X)
 .S NUM=NUM+1
 S Y=Y_$S(ETHNIC="":"  ",1:ETHNIC)
 Q
RACE ;-- Race (use first 6 active values)
 N NODE,NUM,RACE,I,X
 S RACE=""
 S I=0
 S NUM=1
 F  S I=+$O(DG02(I)) Q:'I  D  Q:NUM>6
 .S NODE=$G(DG02(I,0))
 .Q:('NODE)!('$D(^DIC(10,+NODE,0)))
 .Q:$$INACTIVE^DGUTL4(+NODE)
 .S X=$$PTR2CODE^DGUTL4(+NODE,1,4)
 .S RACE=RACE_$S(X="":" ",1:X)
 .S X=$$PTR2CODE^DGUTL4(+$P(NODE,"^",2),3,4)
 .S RACE=RACE_$S(X="":" ",1:X)
 .S NUM=NUM+1
 S X="" S $P(X," ",12)=""
 S RACE=$S(RACE="":"  ",1:RACE)_X
 S Y=Y_$E(RACE,1,12)
 Q
