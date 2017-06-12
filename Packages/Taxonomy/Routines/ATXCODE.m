ATXCODE ; IHS/CMI/LAB - INTERFACE TO SELECT ICD CODES ;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in DISPLAY
 ;
 I ATXFILE=80.1 G ^ATXTAXI
 D INIT
BEGIN D ASK1
 I Y="^" S ATXSTP=1 G X
 I $D(ATXTBLE) D CHECK I Y'=1 G BEGIN  ;@$S(Y=0:"BEGIN",1:"X")
X D EOJ
 Q
 ;
INIT ;
 S ATX("NO DISPLAY")=0
 I $D(ATXX) D  I 1
 . I $D(ATXTBLE) S ATX("MODIFY")=1 D RANGES I 1
 . E  S ATX("ENTER")=1
 E  S ATX("NOT TAX")=""
 Q
 ;
ASK1 ;
 W !!,"Updating codes in the ",$P(^ATXAX(ATXTAXI,0),U)," Taxonomy.",!
 S ATXA=0
 I $G(ATXREMM) W !!,"To remove a code from the list, enter an ""-"" before the code, e.g. -250.00 or -250.00-250.93",!
 K ATX("LOW"),ATX("HI")
 S DIR("A")=$S('$D(ATXTBLE):"ENTER DX",1:"ENTER ANOTHER DX") D SETDIR,^DIR K DIR
 I "^"[Y G X1
 I Y="" G X1
 D PROCESS
 I $D(ATXTBLE),'ATX("NO DISPLAY") D RANGES
 S ATX("NO DISPLAY")=0
 G ASK1
X1 Q
ICDCS ;
 ;WHAT CODING SYSTEM?
 S ATXSYS=""
 NEW Y,X
 W !,"You must enter the coding system from which you want to "_$S($G(ATXREMM):"remove ",1:" enter")_" a code,",!,"or range of codes.",!
 S DIC="^ICDS(",DIC("S")="I $P(^(0),U,3)=80",DIC(0)="AEMQ" D ^DIC K DIC
 I Y=-1 G X1
 S ATXSYS=+Y
 Q
 ;I Y="*" W !!,"Sorry, '*' is not allowed.
 ;
LOOK ; ENTRY POINT - LOOKUP USER RESPONSE; SET UTILITY NODES
 S DIC="^ICD9(",DIC(0)="EMF",ICDSYS=ATXSYS D ^DIC K DIC,DR
 I Y<0 S ATXA=1 W $C(7),"  ??" S ATX("NO DISPLAY")=1 G X3
 S:ATXTYP="LOW" ATX("LOW")=$P($S(ATXSYS=1:$$ICDDX^ICDEX(+Y),1:$$ICDDX^ICDEX(+Y)),U,2)_" "
 I ATXTYP="LOW",ATXONE S ATX("HI")=ATX("LOW") D ^ATXCOD1
 I ATXTYP="HI" S ATX("HI")=$P($S(ATXSYS=1:$$ICDDX^ICDEX(+Y),1:$$ICDDX^ICDEX(+Y)),U,2)_" " D  I 'ATX("NO DISPLAY") D DISPLAY,^ATXCOD1
 . I $E(ATX("HI"))?1N&($E(ATX("LOW"))?1N)!($E(ATX("LOW"))'?1N&($E(ATX("HI"))'?1N))
 . E  W !,$C(7),"Low and high codes of range must both start either with a letter or a number.",! S ATX("NO DISPLAY")=1
 . I 'ATX("NO DISPLAY") I ATX("LOW")]ATX("HI") W !,$C(7),"Low code is higher than high code.",! S ATX("NO DISPLAY")=1
X3 Q
 ;
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF ATXCODE
 S DIR(0)="FO",DIR("?",1)="Enter ICD diagnosis code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  You may"
 S DIR("?",5)="also enter ""[TAXONOMY NAME"" to select codes already within a taxonomy."
 S DIR("?",6)="To select all codes in a set you can use a '*' wildcard.  E.g. E11*, 250*"
 S DIR("?",7)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",8)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 S DIR("?")="code ranges selected so far."
 S DIR("??")="^D ASK2^ATXCODE"
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(ATXTBLE) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^ATXCODE
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
STAR ;
 I $E(X)="-" S ATXSUB=1
 NEW ATXTEMP
 D LST^ATXAPI(ATXSYS,80,$S($E(X)="-":$E(X,2,999),1:X),"CODE","ATXTEMP")
 I '$D(ATXTEMP) W "  ?? There are no codes in that range!" S ATX("NO DISPLAY")=1 Q
 S ATX("LOW")=$O(ATXTEMP(0))
 NEW Z,C
 S (Z,C)="" F  S Z=$O(ATXTEMP(Z)) Q:Z=""  S C=Z
 S ATX("HI")=C
 D DISPLAY,^ATXCOD1
 Q
PROCESS ;EVALUATE USER RESPONSE
 S (ATXSUB,ATXONE)=0 ;ATXSUB=0 => NO DELETE OF CODE(S),ATXONE=0 => RANGE OF CODES ENTERED
 I $E(X,1,2)="-[" W "  ?? Not allowed" S ATX("NO DISPLAY")=1 G X2
 I $E(X)="[" D TAX G X2
 I $E(X,$L(X))="*" D ICDCS G:'$G(ATXSYS) X2 D STAR G X2
 I X'["-" D ICDCS G:'$G(ATXSYS) X2 S ATXTYP="LOW",ATXONE=1 D LOOK G X2
 I $E(X)="-",'$D(ATXTBLE) W $C(7),"  ??  No previous codes entered!" G X2
 I $L(X,"-")>3 W $C(7),"  ??"  S ATXA=1 S ATX("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$E(X,$L(X))="-" W $C(7),"  ??" S ATXA=1 S ATX("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$P(X,"-")]"" W $C(7),"  ??" S ATXA=1 S ATX("NO DISPLAY")=1 G X2
 D ICDCS G:'$G(ATXSYS) X2
 I $E(X)="-" S ATXSUB=1 D  I 1
 . S ATXSAVE("X")=X
 . I $L(X,"-")=3 S X=$P(ATXSAVE("X"),"-",2),ATXTYP="LOW" D LOOK I 'ATXA S X=$P(ATXSAVE("X"),"-",3),ATXTYP="HI" W ! D LOOK Q
 . I $L(ATXSAVE("X"),"-")=2 S X=$E(X,2,99),ATXTYP="LOW",ATXONE=1 D LOOK
 E  S ATXSAVE("X")=X S ATXTYP="LOW",X=$P(ATXSAVE("X"),"-") D LOOK I 'ATXA S ATXTYP="HI",X=$P(ATXSAVE("X"),"-",2) W ! D LOOK
 ;
X2 Q
 ;
EOP ;
 S ATXQ=0
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR K DIR
 I $D(DUOUT) S ATXQ=1 Q
 W:$D(IOF) @IOF
 Q
DISPLAY ;EP - SHOW CODES IN RANGE SELECTED
 W:$D(IOF) @IOF
 NEW ATXX,ATXQ,ATXARR
 ;W !!,"ICD codes in this range =>",!! W $P(ATX("LOW")," ") S ATXDFN=$O(^ICD9("BA",ATX("LOW"),"")) W ?9,$P(^ICD9(ATXDFN,0),U,3)  ;cmi/anch/maw 9/10/2007 orig line
 W !!,"ICD codes in this range =>",!!
 ;call new API to get all codes back in ATXARR
 D LST^ATXAPI(ATXSYS,80,$$STRIP^XLFSTR(ATX("LOW"))_"-"_$$STRIP^XLFSTR(ATX("HI")),"CODE","ATXARR")
 S ATXX="",ATXQ=0 F  S ATXX=$O(ATXARR(ATXX)) Q:ATXX=""!($G(ATXQ))  D
 .I $Y>(IOSL-2) D EOP Q:ATXQ
 .I $P(ATXARR(ATXX),U,2)=1 W !,ATXX,?12,$E($P($$ICDDX^ICDEX($P(ATXARR(ATXX),U,1)),U,4),1,40),?60,$P(ATXARR(ATXX),U,4) I 1
 .E  W !,ATXX,?12,$E($P($$ICDDX^ICDEX($P(ATXARR(ATXX),U,1)),U,4),1,40),?60,$P(ATXARR(ATXX),U,4)
 NEW DIR
 S DIR(0)="E",DIR("A")="Press Enter to Continue <>" D ^DIR
 Q
 ;
RANGES ;DISPLAY TABLE OF ALL RANGES
 W:$D(IOF) @IOF
 W !!,"ICD Code Range(s) Selected So Far =>",!
 S (ATX("NUM"),ATX)=0 F  S ATX=$O(ATXTBLE(ATX)) Q:ATX=""  S ATX("NUM")=ATX("NUM")+1 W !,ATX("NUM"),")  ",ATX,$S(ATX'=$P(ATXTBLE(ATX),U,1):"- "_$P(ATXTBLE(ATX),U,1),1:"") D
 .I $P(ATXTBLE(ATX),U,2) W ?30,$P(^ICDS($P(ATXTBLE(ATX),U,2),0),U,1)
 I '$D(ATX("BANG")) W !
 Q
 ;
SHOW ; ENTRY POINT - ALLOW USER TO SELECT FROM RANGES TO DISPLAY CODES
 D RANGES
A W !,"Enter an Item Number from the table above to display code(s): " R ATX("N"):300 W:"^"[ATX("N") ! Q:"^"[ATX("N")  I ATX("N")'?1N!(ATX("N")>ATX("NUM")) W "  ??",$C(7) G A
 F ATXI=1:1:ATX("N") S ATX=$O(ATXTBLE(ATX)) I ATXI=ATX("N") S ATX("LOW")=ATX,ATX("HI")=ATXTBLE(ATX) D DISPLAY Q
 S ATX("BANG")="" D RANGES K ATX("BANG")
 Q
 ;
TAX ;EP - PLACE CODES FROM SELECTED TAXONOMY IN ATXTBLE
 S ATX("S")="I Y'=ATXX",ATX("S")=$S($D(ATXX):ATX("S")_",$O(^ATXAX(Y,21,0))",1:"I $O(^(21,0))"),DIC("A")="TAXONOMY FROM WHICH TO SELECT CODES: ",ATX("S")=ATX("S")_$S('$D(ATXX):"",1:",$P(^ATXAX(ATXX,0),U,15)=$P(^ATXAX(Y,0),U,15)")
 I $E(X,2)="?" S X="?",DIC="^ATXAX(",DIC(0)="EM",DIC("S")=ATX("S") D ^DIC S DIC(0)="AEMQ",DIC("S")=ATX("S"),DIC="^ATXAX(" D ^DIC K DIC I 1
 E  S X=$E(X,2,99),DIC(0)="EMQ",DIC("S")=ATX("S"),DIC="^ATXAX(" D ^DIC K DIC
 I Y=-1 G X4
 ;S ATX("CODE")=0 F  S ATX("CODE")=$O(^ATXAX(+Y,21,"AA",ATX("CODE"))) Q:ATX("CODE")=""  S ATXTBLE(ATX("CODE"))=$O(^(ATX("CODE"),""))
 NEW X,A,B,ATXN
 S ATXN=+Y
 S X="" F  S X=$O(^ATXAX(ATXN,21,"B",X)) Q:X=""  D
 .S Y=0 F  S Y=$O(^ATXAX(ATXN,21,"B",X,Y)) Q:Y=""  D
 ..S A=$P(^ATXAX(ATXN,21,Y,0),U,1),B=$P(^ATXAX(ATXN,21,Y,0),U,2),C=$P(^ATXAX(ATXN,21,Y,0),U,3)
 ..S ATXTBLE(A)=B_U_C
X4 W ! Q
 ;
CHECK ;ASKS USER IF SATISFIED WITH ENTERED RANGES
 W ! S DIR(0)="Y",DIR("B")="Y",DIR("A")="Is everything okay" D ^DIR K DIR
 W !
 Q
 ;
EOJ ;
 K ATXSUB,ATXTYP,ATXDFN,DIR,ATXSAVE,ATXA,ATXCNT,ATX,ATXR,ATXI,ATXONE,ATXFLG,ATXSTP
 Q
 ;
