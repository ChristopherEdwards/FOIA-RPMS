AQAOCOD ; IHS/ORDC/LJF - USER INTERFACE TO SELECT ICD CODES ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;IHS/ORDC/LJF; rtn copied from ^ATXCODE ;;4.2;Taxonomy;;MAR 19, 1991
 ;  changed namespacing from ATX to AQAO
 ;  removed kill of variable AQAOTBL from EOJ+2
 ;  added check for procedures using AQAOICD
 ;  use of AQAOTL for dir(a) prompt
 ;  added choice to select ALL ICD codes
 ; AQAOICD must be = to 9 (dx) or 0 (procedures)
 ; AQAOTL must be set to "DIAGNOSIS" or "PROCEDURE"
 ;
 D INIT^AQAOCOD0
BEGIN D ASK1
 I $D(AQAOTBL("ALL")) G X ;IHS/ORDC/LJF code for ALL codes
 I Y="^" S AQAOSTP=1 G X
 I $D(AQAOTBL) D CHECK I Y'=1 G @$S(Y=0:"BEGIN",1:"X")
 I $D(AQAOTBL)!($D(AQAO("MODIFY"))) D ^AQAOCOD2 I $S('$D(AQAOSTP):0,AQAOSTP=1:1,1:0),$D(AQAO("ENTER")) S AQAOSTP=0 G BEGIN
X D EOJ^AQAOCOD0
 Q
 ;
ASK1 ;
 S AQAOA=0 K AQAO("LOW"),AQAO("HI")
 ;original from ^ATXCODE commented out below
 ;S DIR("A")=$S('$D(AQAOTBL):"ENTER DX",1:"ENTER ANOTHER DX") D SETDIR^AQAOCOD0,^DIR K DIR
 S DIR("A")="ENTER "_$S($D(AQAOTBL):"ANOTHER ",1:"")_AQAOTL D SETDIR^AQAOCOD0,^DIR K DIR ;IHS/ORDC/LJF  new version of line
 I "^"[Y G X1
 D PROCESS
 I $D(AQAOTBL("ALL")) G X1 ;IHS/ORDC/LJF user chose all codes
 I $D(AQAOTBL),'AQAO("NO DISPLAY") D RANGES
 S AQAO("NO DISPLAY")=0 G ASK1
X1 Q
PROCESS ;EVALUATE USER RESPONSE
 S (AQAOSUB,AQAONE)=0 ;AQAOSUB=0 => NO DELETE OF CODE(S),AQAONE=0 => RANGE OF CODES ENTERED
 I X="ALL" S AQAOTBL("ALL")="",AQAO("NO DISPLAY")=1 W *7,"   You have selected ALL ",AQAOTL," for this report!" G X2 ;IHS/ORDC/LJF code so user can select all codes
 I AQAOICD=0,$E(X)="[" W *7,"  ?? No taxonomies for procedures" S AQAO("NO DISPLAY")=1 G X2 ;IHS/ORDC/LJF code for ICD0
 I $E(X,1,2)="-[" W *7,"  ?? Not allowed" S AQAO("NO DISPLAY")=1 G X2
 I $E(X)="[" D TAX G X2
 I X'["-" S AQAOTYP="LOW",AQAONE=1 D LOOK^AQAOCOD0 G X2
 I $E(X)="-",'$D(AQAOTBL) W *7,"  ??  No previous codes entered!" G X2
 I $L(X,"-")>3 W *7,"  ??" S AQAOA=1 S AQAO("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$E(X,$L(X))="-" W *7,"  ??" S AQAOA=1 S AQAO("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$P(X,"-")'="" W *7,"  ??" S AQAOA=1 S AQAO("NO DISPLAY")=1 G X2
 I $E(X)="-" S AQAOSUB=1 D  I 1
 .S AQAOSAV("X")=X
 .I $L(X,"-")=3 S X=$P(AQAOSAV("X"),"-",2),AQAOTYP="LOW" D LOOK^AQAOCOD0 I 'AQAOA S X=$P(AQAOSAV("X"),"-",3),AQAOTYP="HI" W ! D LOOK^AQAOCOD0 Q
 .I $L(AQAOSAV("X"),"-")=2 S X=$E(X,2,99),AQAOTYP="LOW",AQAONE=1 D LOOK^AQAOCOD0
 E  S AQAOSAV("X")=X S AQAOTYP="LOW",X=$P(AQAOSAV("X"),"-") D LOOK^AQAOCOD0 I 'AQAOA S AQAOTYP="HI",X=$P(AQAOSAV("X"),"-",2) W ! D LOOK^AQAOCOD0
X2 Q
 ;
DISPLAY ;ENTRY POINT SHOW CODES IN RANGE SELECTED
 I AQAOICD=0 G DISPLAY2^AQAOCOD3 ;IHS/ORDC/LJF procedure lookup
 W !!,"ICD codes in this range =>",!! W $P(AQAO("LOW")," ") S DFN=$O(^ICD9("BA",AQAO("LOW"),"")) W ?9,$P(^ICD9(DFN,0),U,3)
 S AQAO=AQAO("LOW"),AQAOCT=IOSL-2 F  S AQAO=$O(^ICD9("BA",AQAO)) Q:AQAO]AQAO("HI")  S DFN=$O(^(AQAO,"")) W !,$P(AQAO," "),?9,$P(^ICD9(DFN,0),U,3) S AQAOCT=AQAOCT-1 I AQAOCT=0 S AQAOCT=IOSL-2 D  I AQAOR=U Q
A1 .R !,"<>",AQAOR:DTIME W:AQAOR["?" " Enter ""^"" to stop display, return to continue" G:AQAOR["?" A1
 I $S('$D(AQAOR):1,AQAOR'=U:1,1:0) R !!,"Press return to continue",AQAOR:DTIME
 W ! K AQAOR Q
 ;
RANGES ;ENTRY POINT - DISPLAY TABLE OF ALL RANGES
 W !!,"ICD Code Range(s) Selected So Far =>",!
 S (AQAO("NUM"),AQAO)=0 F  S AQAO=$O(AQAOTBL(AQAO)) Q:AQAO=""  S AQAO("NUM")=AQAO("NUM")+1 W !,AQAO("NUM"),")  ",AQAO,$S(AQAO'=AQAOTBL(AQAO):"- "_AQAOTBL(AQAO),1:"")
 I '$D(AQAO("BANG")) W !
 Q
 ;
SHOW ;ENTRY POINT - ALLOW USER TO SELECT FROM RANGES TO DISPLAY CODES
 D RANGES
A W !,"Enter an Item Number from the table above to display code(s): " R AQAO("N"):300 W:"^"[AQAO("N") ! Q:"^"[AQAO("N")  I AQAO("N")'?1N!(AQAO("N")>AQAO("NUM")) W "  ??",*7 G A
 F AQAOI=1:1:AQAO("N") S AQAO=$O(AQAOTBL(AQAO)) I AQAOI=AQAO("N") S AQAO("LOW")=AQAO,AQAO("HI")=AQAOTBL(AQAO) D DISPLAY Q
 S AQAO("BANG")="" D RANGES K AQAO("BANG")
 Q
 ;
TAX ;PLACE CODES FROM SELECTED TAXONOMY IN AQAOTBL
 S AQAO("S")="I Y'=AQAOX",AQAO("S")=$S($D(AQAOX):AQAO("S")_",$O(^ATXAX(Y,21,0))",1:"I $O(^(21,0))"),DIC("A")="TAXONOMY FROM WHICH TO SELECT CODES: ",AQAO("S")=AQAO("S")_$S('$D(AQAOX):"",1:",$P(^ATXAX(AQAOX,0),U,15)=$P(^ATXAX(Y,0),U,15)")
 I $E(X,2)="?" S X="?",DIC="^ATXAX(",DIC(0)="EM",DIC("S")=AQAO("S") D ^DIC S DIC(0)="AEMQ",DIC("S")=AQAO("S"),DIC="^ATXAX(" D ^DIC K DIC I 1
 E  S X=$E(X,2,99),DIC(0)="EMQ",DIC("S")=AQAO("S"),DIC="^ATXAX(" D ^DIC K DIC
 I Y=-1 G X3
 S AQAO("CODE")=0 F  S AQAO("CODE")=$O(^ATXAX(+Y,21,"AA",AQAO("CODE"))) Q:AQAO("CODE")=""  S AQAOTBL(AQAO("CODE"))=$O(^(AQAO("CODE"),""))
X3 W ! Q
 ;
CHECK ;ASKS USER IF SATISFIED WITH ENTERED RANGES
 W ! S DIR(0)="Y",DIR("B")="Y",DIR("A")="Is everything okay" D ^DIR
 K DIR W ! Q
