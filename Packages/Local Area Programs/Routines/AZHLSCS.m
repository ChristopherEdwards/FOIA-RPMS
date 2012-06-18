AZHLSCS ; IHS/ADC/GTH:KEU - DSM SPELL CHECKER FOR VARIOUS FILES/FIELDS ; [ 11/24/97  10:55 AM ]
 ;;5.0;AZHLSC;;JUL 10, 1996
 ;
0 W !!!?4,$P($P($T(+1),";",2),"-",2)," v ",$P($T(+2),";",3),!
 I 'AZHLPIEN D NPKG^AZHLSC Q
 ;
1 W !!?10 D PKG^AZHLSC
 F %=1:1:$P($T(SELS),";",3) W !?10,$J(%,3),"   ",$P($T(@"SELS"+%),";",3)
 R !!?15,"Select :  [A]ll // ",AZHLOPTN:300 G:'$T!(AZHLOPTN=U) END S:AZHLOPTN="" AZHLOPTN="A"
 ;
DEVICE W !!,"Report will be QUEUE'd if device other than HOME selected.",! K IOP,%ZIS S %ZIS="NQM",%ZIS("B")="" D ^%ZIS K %ZIS I POP W !,*7,"No device specified." G END
 S AZHLTERM=0,IOP=ION_";"_IOST_$S($D(IO("DOC")):";"_IO("DOC"),1:";"_IOM_";"_IOSL)
 I IO=IO(0),"C"[$E(IOST),$D(IO("Q"))#2 W !,"Can't Q to home device." K IO("Q") G DEVICE
 I IO'=IO(0),'$D(IO("Q")) W !!,"Report being QUEUE'd to run now for you." S IO("Q")=1,ZTDTH=$H
 I '$D(IO("Q")) S AZHLTERM=('$D(IO("S"))&(IO=IO(0))) D ^%ZIS G START
 S ZTRTN="START^AZHLSCS",ZTIO=IOP,ZTDESC="SPELL CHECK of "_AZHLNMSP_" package." F G="AZHLOPTN","AZHLPIEN","AZHLNMSP","AZHLTERM" S ZTSAVE(G)=""
 K IO("Q") D ^%ZTLOAD D HOME^%ZIS
DEVEND K AZHLNMSP,AZHLPIEN,AZHLTERM,G,IOP,ZTSK G END
START ;EP - From TaskMan.
 U IO W !!,"<<<<<<<   DSM SPELL CHECKER    >>>>>>>",! D PKG^AZHLSC,BEG^AZHLSC
 NEW AZHLX,AZHLX1,B,C,D,E,F,G,I,L,Q,W D END S Q=0
 I AZHLOPTN="A" D  G QEND
 .F AZHLOPTN=1:1:$P($T(SELS),";",3) K D D @($P($T(SELS+AZHLOPTN),";",4)) Q:Q
 .Q
 D @($P($T(SELS+AZHLOPTN),";",4))
QEND W !!!,"<< DSM SPELL CHECKER >>" D FIN^AZHLSC,END
 Q
 ;
END K ^TMP($J)
 Q
 ;
CHECK ;EP
 Q:'$D(@(AZHLROOT(1)))  S C=+$P(@(AZHLROOT(1)),U,4)
 F AZHL=1:1:C I $D(@(AZHLROOT_AZHLROOT(2)_AZHL_",0)")) S AZHLX=^(0) D CHK Q:Q
 Q
 ;
CHK ;EP
 S (B,E)=0,L=$L(AZHLX)
 F  D GETWORD Q:X=""!Q  W:AZHLTERM "." D
 .I $D(^AZHLWDIC("B",X)) Q
 .I $L(X)>2,$S($E(X,$L(X))'="S":0,$D(^($E(X,1,$L(X)-1))):1,1:0) Q
 .I $L(X)>3,$S($E(X,$L(X)-1,$L(X))'="ED":0,$D(^($E(X,1,$L(X)-2))):1,1:0) Q
 .I $L(X)>4,$S($E(X,$L(X)-2,$L(X))'="ING":0,$D(^($E(X,1,$L(X)-3))):1,1:0) Q
 .I $D(^TMP($J,X))!$D(@("^"_X)) Q
 .X ^%ZOSF("TEST") I  Q
 .D NOHIT
 .Q
 Q
GETWORD ;
 Q:Q  S G=0,X=" "
 F  S:B>L X="" Q:X=""!G  S B=B+1 I $E(AZHLX,B)?1A S E=B F  S E=E+1 I $E(AZHLX,E)'?1A S X=$E(AZHLX,B,E-1),G=1 Q
 S:X]"" X=$TR(X,"abcdefghijklmnopqrstuvwxyz","ABCDEFGHIJKLMNOPQRSTUVWXYZ")
 S B=E
 Q
NOHIT ;
 I '$D(D(3)) W !!,"***  '",AZHLNMSP,"'; ",D,"  ",D(1)," " W:$D(AZHLROOT) AZHLROOT W:$D(AZHLROOT(2)) AZHLROOT(2) W "; ",$S($D(D(2)):"; "_D(2),1:""),! S D(3)=1 ;IHS/JN 11/21/97
 W !,AZHLX,!,?10,"'",X,"' not found ",! ;IHS/JN 11/21/97
 ; I $D(ZTSK)!$D(IO("S")) W:($X>(IOM-19)) ! W X,$E("                    ",1,20-$L(X)) G IGNORE   ;IHS/JN 11/21/97
 I $D(ZTSK)!$D(IO("S")) G IGNORE ;IHS/JN 11/17/97
NOHIT1 W *7,!,AZHLX,!,"'",X,"' not found in ",$P(^AZHLWDIC(0),U),"""",!!
 F  R "[A]dd, [C]orrect, [I]gnore, [S]uggestions, [Q]uit : ",*AZHL(2):300 S AZHL(2)=$C(AZHL(2)) Q:"AaCcIiSsQq"[$E(AZHL(2))  W !,"Please enter an 'A', 'C', 'I', 'S', or 'Q'.",!
 I "Qq"[AZHL(2) S Q=1 Q
 D ADD:"Aa"[AZHL(2),CORRECT:"Cc"[AZHL(2),IGNORE:"Ii"[AZHL(2)
 Q:"Ss"'[AZHL(2)
 D SUGGEST
 G NOHIT1
 ;
ADD L +^AZHLWDIC(0):10 Q:'$T  S $P(^(0),U,3)=$P(^AZHLWDIC(0),U,3)+1,$P(^(0),U,4)=$P(^(0),U,4)+1 L ^AZHLWDIC($P(^(0),U,3),0) S ^AZHLWDIC($P(^(0),U,3),0)=X,^AZHLWDIC("B",X,$P(^AZHLWDIC(0),U,3))="" L  Q
CORRECT W !!,AZHLX,! F  R "  Replace ",AZHLX1:300 Q:AZHLX1=""  Q:$F(AZHLX,AZHLX1)  W *7,"??"
 G:AZHLX1="" CORREND R "  With ",AZHLX2:300
 S AZHLX=$P(AZHLX,AZHLX1)_AZHLX2_$P(AZHLX,AZHLX1,2,99)
 G CORRECT
CORREND S @(AZHLROOT_AZHLROOT(2)_AZHL_","_AZHLROOT(3)_")")=AZHLX,B=0 W !
 Q
IGNORE S ^TMP($J,X)=""
 Q
SUGGEST N B,C,D,DIC,DUOUT,E,F,G,I,L,W S DIC="^AZHLWDIC(",DIC(0)="EF",%=X
 N X S X=% F  Q:'$L(X)!($D(DUOUT))  D ^DIC Q:Y>0  S X=$E(X,1,$L(X)-1)
 Q
SELS ;;10
 ;;PACKAGE: DESCRIPTION & WP Fields in 22;94^AZHLSCS1
 ;;HELP FRAMES: TEXT;92^AZHLSCS1
 ;;BULLETINS: SUBJECT/DESCRIPTION/MESSAGE;36^AZHLSCS1
 ;;OPTIONS: DESCRIPTION;19^AZHLSCS1
 ;;SECURITY KEY: DESCRIPTION;191^AZHLSCS1
 ;;INPUT TEMPLATEs: DESCRIPTION;INPUT^AZHLSCS1
 ;;SORT TEMPLATEs: DESCRIPTION;SORT^AZHLSCS1
 ;;PRINT TEMPLATEs: DESCRIPTION;PRINT^AZHLSCS1
 ;;FILE: DESCRIPTION;FILEDESC^AZHLSCS1
 ;;DDs: FIELD 'HELP'-PROMPT, DESCRIPTION, & TECH DESC.;DD^AZHLSCS1
