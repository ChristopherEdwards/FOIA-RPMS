LRKDIFF2 ;SLC/RWF,LL/RES- RBC MORPHOLOGY ; 7/14/87  08:01 ; [ 10/14/90  8:57 PM ]
 ;;V~5.0~;LAB;;02/27/90 17:09
A K KEY,NC,TY,T1,T2 S KEY="" F I=0:0 S I=$O(^UTILITY($J,"R",I)) Q:I=""  S X=^(I),KEY(X)=I,KEY=KEY_X
 S T1=1,(T1(T1),T2(T1))="" F I=31:1:58 S T2=I,X=$S($D(^UTILITY("LA",$J,I,4)):^(4),1:""),Y=$S($D(^(.1)):^(.1),1:""),T1(T1)=T1(T1)_$J(X,8),T2(T1)=T2(T1)_$J(Y,8) Q:$O(^UTILITY("LA",$J,I))=""  I '(I-30#9) S T1=T1+1,(T1(T1),T2(T1))=""
 S DONE=0,FLAG=0 D HD1,HD2
L F J=0:0 Q:FLAG!DONE  S DX=0,DY=22 X XY W !,?40,*13,"RBC: " R TYPE#1:DTIME D CHECK
 D STORE:DONE
 K X,A,DATYP,X,DD,CODE,TYPE,CONT,DONE,J,K Q
CHECK I '$T!(TYPE=U) S FLAG=1 Q
 S LINE=$S(TYPE="":"STOP",TYPE="!":"COM",TYPE="\":"WBC",KEY'[TYPE:"HELP",1:"RESULT") D @LINE Q
RESULT S Y=KEY(TYPE) W *13,$P(^LAB(60,^UTILITY("LA",$J,Y,0),0),U,1) W:$D(TY(TYPE)) "  ",TY(TYPE),"//" R "  ",X:DTIME I '$T!(X=U) S FLAG=1 Q
 I X="" Q
DELETE I X="@"&$D(TY(TYPE)) K TY(TYPE) Q
 S DA=^UTILITY("LA",$J,Y,.2),DD=^("DD") D SET:$P(DD,U,2)["S" X $P(DD,U,5,99) I $D(X) S TY(TYPE)=X Q
HELP2 S DX=0,DY=22 W !,*7,$S($D(^DD(63.04,DA,3)):^(3),1:"") I $P(DD,U,2)'["S" R X:2 Q
 F K=1:1 Q:$P(LRSET,";",K)=""  W !,"You can enter '",$P($P(LRSET,";",K),":",1),"' which stands for ",$P($P(LRSET,";",K),":",2)
 R !,"Press return to continue ",X:DTIME D HD1,HD2 Q
 Q
HELP I TYPE'="?" W *13,*7,"  INVALID RBC CELL KEY" R X:2 Q
 S DX=0,DY=LRDY,X=0 X XY F I1=1:9:T2-30 W !!!!,?7 F I=I1:1:I1+8 Q:I+30>T2  S X=$S($D(^UTILITY($J,"R",I+30)):^(I+30),1:"^"),K=$S($D(TY(X)):TY(X),1:"") W $J(K,8)
 Q
SET S LRSET=$P(DD,U,3),%=$P($P(";"_LRSET,";"_X_":",2),";",1) I %]"" W "  ",% Q
 F I=1:1 S LRSUBS=$P(LRSET,";",I),Y=$F(LRSUBS,":"_X) G HUH:LRSUBS="" IF Y S X=$P(LRSUBS,":",1) W $E(LRSUBS,Y,255) Q
 Q
HUH K X Q
 W:X'["?" "  ??" W *7 K X F K=1:1 Q:$P(CODE,";",K)=""  W !,"YOU CAN ENTER ",$P($P(CODE,";",K),":")," WHICH STANDS FOR ",$P($P(CODE,";",K),":",2)
 Q
WBC D HD1 W !!,?30,"> WBC MORPHOLOGY <",! F K=0:0 S K=$O(^UTILITY($J,"W",K)) Q:K'>0  S X=^UTILITY("LA",$J,K,1) I $D(@X) W !,?3,^(.1),":  ",@X
 R !!,?24,"Press return to continue: ",X:DTIME D HD1,HD2 Q
STOP D EVAL
DONE R !,"ARE YOU FINISHED WITH THIS PATIENT (Y/N) Y//",X:DTIME I '$T S FLAG=1 Q
 S:X="" X="Y" I "YyNn^"'[X W *7,"  ??" G DONE
 S:"Yy"[X DONE=1 S:U[X FLAG=1 D:FLAG=DONE HD1,HD2 Q
 Q
EVAL D HD1
 S X="" F I=0:0 S I=$O(^UTILITY($J,"R",I)) Q:I=""  S Y=^(I) I $D(TY(Y)) W !?2,^UTILITY("LA",$J,I,.1),": ",?12 S V=TY(Y) X ^UTILITY("LA",$J,I,2) W $J(V,3)
 Q
STORE S X="" F I=0:0 S I=$O(^UTILITY($J,"R",I)) Q:I=""  S Y=^(I) I $D(TY(Y)) S V=TY(Y) X ^UTILITY("LA",$J,I,2) S @^UTILITY("LA",$J,I,1)=V
 Q
HD1 W @IOF,!!,"Patient name: ",PNM,?45,"HRCN: ",HRCN Q  ;IHS/ANMC/CLS 10/14/90 HRCN
HD2 S LRDY=$Y W !,?3,"RBC MORPHOLOGY ('?' = DISPLAY, '!' = COMMENTS, '\' = WBC, <RETURN> = EXIT)" F I=1:1:T1 W !,"KEY",?7,T1(I),!,"TEST",?7,T2(I),!!
HD3 S TYPE="?" D HELP Q
HD4 W !!,?34,"> CBC PROFILE <",!
 S I=1 F C=1:0 S C=$O(^LR(LRDFN,"CH",LRDAT,C)) Q:C'>0  S V=^(C),X=$O(^LAB(60,"C","CH;"_C_";1",0)) I X>0 W $P(^LAB(60,X,0),U,1),": ",$P(V,U,1)_" "_$P(V,U,2),?(I*25) S I=I+1 I I>3 W ! S I=1
 Q
COM W !,"Comment: ",RMK,! I RMK="" R RMK:DTIME G COM2
 S Y=RMK D RW^LRDIED S RMK=$S(X="@":"",1:Y)
COM2 D HD1,HD4,HD2 Q
