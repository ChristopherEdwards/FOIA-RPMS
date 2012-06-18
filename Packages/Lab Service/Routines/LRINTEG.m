LRINTEG ;SLC/FHS - INTEGRITY CHECKER FOR LAB SERVICE PACKAGE ;8/3/89  17:52 ;
 ;;V~5.0~;LAB;;02/27/90 17:09
EN ;set %zosf variables
 ; This routine stores routines (variable X) in ^UTILITY("LRINTEG" returns
 ; XBIT which is = $A(X) and SIZE which is the $L(X)
NEW ;
 N I,A,DIF,DIC,Y,II,XCNP,XCS,XCM,XCN,%,X
 K ^UTILITY("LRINTEG",$J) S XLOAD=^%ZOSF("LOAD"),XTEST=^("TEST"),DIF="^UTILITY(""LRINTEG"""_","_$J_","
 S XSIZE="S SIZE=0,I=1 F A=0:0 S I=$O(^UTILITY(""LRINTEG"",$J,I)) Q:I=""""  S SIZE=SIZE+$L(^(I,0))+2"
 Q
VER ; Select or add version #
 K DIC S U="^",DIC("A")=" Select Version # ",DIC(0)="AQEZ",DIC="^LAB(69.91," S:$D(LOAD) DIC(0)=DIC(0)_"L" D ^DIC G:Y<0 STOP S VNODE=+Y,VER=$P(Y,U,2),VERDDT=$P(Y(0),U,2)
 Q
LOOP ; Loop thru intire file checking for mis-match between file directory
 K %DT S %DT="RX",X="NOW" D ^%DT W !,Y
 D EN,VER Q:Y<1  S II=0,LRST=""
ASK R !," Enter Routine to start checking from ",X:DTIME Q:'$T!(X[U)  W:X["?" !!,"Enter a program name to start with " G:X["?" ASK I $L(X),$E(X)="L" S II=X
 S:'$L(X) X="L" I $E(X)'="L" W *7,!!?7,"ENTER RETURN OR ROUTINE BEGINNING WITH 'L' " G ASK
 S II=X
ASK1 R !!," Enter EXACT routine to stop checking : ALL// ",X:DTIME Q:'$T!(X[U)  W:X["?" !!,"Enter the name of a program to stop this routine " G:X["?" ASK1 I $L(X),$E(X)="L" S LRST=X
 S:'$L(X) X="" I $L(X),$E(X)'="L" W *7,!!?7,"ROUTINE MUST START WITH 'L' " G ASK1
 S LRST=X
 W !!?7,"Enter '^' to stop ",!!
 F A=0:0 R X:.1 Q:X="^"  S II=$O(^LAB(69.91,VNODE,"ROU","B",II)) Q:II=""!(II=LRST)  W "." S IX=$O(^(II,0)),X=$P(^LAB(69.91,VNODE,"ROU",IX,0),U),SIZE=$P(^(0),U,2),YBIT=$P(^(0),U,3),ER=0 D SIZE Q:ER  I XBIT'=YBIT W !,"EDIT/CHANGE IN ",X,!,*7
 Q
SIZE ; Test for existence of X, load routine into ^UTILITY("LRINTEG" AND COUNT $L(X)
 ;Entry point for trigger of ^lab(69.911,.01  Caution if changed.
 N DIF,XCNP S DIF="^UTILITY(""LRINTEG"""_","_$J_"," X XTEST G:'$T ER S XCNP=0 K ^UTILITY("LRINTEG",$J) X XLOAD,XSIZE
BIT ;
 S XBIT=0 F I=2:1 Q:'$D(^UTILITY("LRINTEG",$J,I,0))  S L=^(0),LN=$L(L) F NT=1:1:LN S XBIT=$A(L,NT)+XBIT
 Q
ER ; Error msg for when attempt to use a routine that doen't exist
 S ER=1 W !,"There is not a routine called '",X,"' in this directory ",*7,! K X Q
ER2 ; Error msg when the version being loaded does not match the version selected for auto loading
 W !?10,ROU," is version ",$S($L($P(^UTILITY("LRINTEG",$J,2,0),"~",2)):$P(^(0),"~",2),1:"Unknown ")," NOT LOADED",*7,! Q
STOP ; clean-up
 K A,BIT,CNT,DIF,ER,I,II,IX,L,LN,LOAD,NT,ROU,SIZE,VER,VERDDT,VNODE,XBIT,XCM,XCN,XCMP,XCNP,XCS,XLOAD,XSIZE,XTEST,YBIT,^UTILITY("LRINTEG",$J) Q
 Q
LOOK ; Entry point to look thru the whole selected version routine, checking for mis-matches  Prints the DA every tenth time
 D EN,VER Q:Y<0  D LOOP Q
SING ; Entry point for a single routine data look-up
 K DIC D EN,VER G STOP:Y<0 K DIC S DIC(0)="EQA",DIC="^LAB(69.91,"_VNODE_",""ROU"","
SING1 ; Loop point
 D ^DIC G STOP:Y<0 S X=$P(Y,U,2),YBIT=$P(^LAB(69.91,VNODE,"ROU",+Y,0),U,3),ER=0 D SIZE I ER G SING1
 W !,$S(XBIT'=YBIT:" The "_X_" routine has been EDITED ",1:" The "_X_" routine is unedited"),!,"$(A) SIZE = ",XBIT,"      $(L) SIZE = ",SIZE,! G SING1
