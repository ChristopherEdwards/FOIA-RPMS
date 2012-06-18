APCHTAXM ; IHS/CMI/LAB - INTERFACE TO SELECT ICD CODES ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 8/28/2007 code set versioning in DISPLAY
 ;
 D INIT
BEGIN D ASK1
 I Y="^" S APCHSTP=1 G X
 I $D(APCHTBLE) D CHECK I Y'=1 G @$S(Y=0:"BEGIN",1:"X")
X D EOJ
 Q
 ;
INIT ;
 S APCH("NO DISPLAY")=0
 I $D(APCHX) D  I 1
 . I $D(APCHTBLE) S APCH("MODIFY")=1 D RANGES I 1
 . E  S APCH("ENTER")=1
 E  S APCH("NOT TAX")=""
 Q
 ;
ASK1 ;
 S APCHA=0
 K APCH("LOW"),APCH("HI")
 S DIR("A")=$S('$D(APCHTBLE):"ENTER CPT",1:"ENTER ANOTHER CPT") D SETDIR,^DIR K DIR
 I "^"[Y G X1
 D PROCESS
 I $D(APCHTBLE),'APCH("NO DISPLAY") D RANGES
 S APCH("NO DISPLAY")=0
 G ASK1
X1 Q
 ;
PROCESS ;EVALUATE USER RESPONSE
 S (APCHSUB,APCHONE)=0 ;APCHSUB=0 => NO DELETE OF CODE(S),APCHONE=0 => RANGE OF CODES ENTERED
 I $E(X,1,2)="-[" W $C(7),"  ?? Not allowed" S APCH("NO DISPLAY")=1 G X2
 I $E(X)="[" D TAX G X2
 I X'["-" S APCHTYP="LOW",APCHONE=1 D LOOK G X2
 I $E(X)="-",'$D(APCHTBLE) W $C(7),"  ??  No previous codes entered!" G X2
 I $L(X,"-")>3 W $C(7),"  ??"  S APCHA=1 S APCH("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$E(X,$L(X))="-" W $C(7),"  ??" S APCHA=1 S APCH("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$P(X,"-")]"" W $C(7),"  ??" S APCHA=1 S APCH("NO DISPLAY")=1 G X2
 I $E(X)="-" S APCHSUB=1 D  I 1
 . S APCHSAVE("X")=X
 . I $L(X,"-")=3 S X=$P(APCHSAVE("X"),"-",2),APCHTYP="LOW" D LOOK I 'APCHA S X=$P(APCHSAVE("X"),"-",3),APCHTYP="HI" W ! D LOOK Q
 . I $L(APCHSAVE("X"),"-")=2 S X=$E(X,2,99),APCHTYP="LOW",APCHONE=1 D LOOK
 E  S APCHSAVE("X")=X S APCHTYP="LOW",X=$P(APCHSAVE("X"),"-") D LOOK I 'APCHA S APCHTYP="HI",X=$P(APCHSAVE("X"),"-",2) W ! D LOOK
X2 Q
 ;
DISPLAY ;EP - SHOW CODES IN RANGE SELECTED
 W:$D(IOF) @IOF
 ;W !!,"CPT codes in this range =>",!! W $P(APCH("LOW")," ") S APCHDFN=$O(^ICPT("BA",APCH("LOW"),"")) W ?9,$P(^ICPT(APCHDFN,0),U,2)  ;cmi/anch/maw 8/28/2007 orig line
 W !!,"CPT codes in this range =>",!! W $P(APCH("LOW")," ") S APCHDFN=$O(^ICPT("BA",APCH("LOW"),"")) W ?9,$P($$CPT^ICPTCOD(APCHDFN),U,3)  ;cmi/anch/maw 8/28/2007 code set versioning
 ;S APCH=APCH("LOW"),APCHCNT=IOSL-2 F  S APCH=$O(^ICPT("BA",APCH)) Q:APCH]APCH("HI")  S APCHDFN=$O(^(APCH,"")) W !,$P(APCH," "),?9,$P(^ICPT(APCHDFN,0),U,2) S APCHCNT=APCHCNT-1 I APCHCNT=0 S APCHCNT=IOSL-2 D  I APCHR=U Q
 ;  ;cmi/anch/maw 8/28/2007 orig line
 S APCH=APCH("LOW"),APCHCNT=IOSL-2
 F  S APCH=$O(^ICPT("BA",APCH)) Q:APCH]APCH("HI")  S APCHDFN=$O(^(APCH,"")) W !,$P(APCH," "),?9,$P($$CPT^ICPTCOD(APCHDFN),U,3) S APCHCNT=APCHCNT-1 I APCHCNT=0 S APCHCNT=IOSL-2 D  I APCHR=U Q  ;cmi/anch/maw 8/28/2007 code set versioning
A1 . R !,"<>",APCHR:DTIME W:APCHR["?" " Enter ""^"" to stop display, return to continue" G:APCHR["?" A1
 I $S('$D(APCHR):1,APCHR'=U:1,1:0) R !!,"Press return to continue",APCHR:DTIME
 W !
 K APCHR Q
 ;
RANGES ;DISPLAY TABLE OF ALL RANGES
 W:$D(IOF) @IOF
 W !!,"CPT Code Range(s) Selected So Far =>",!
 S (APCH("NUM"),APCH)=0 F  S APCH=$O(APCHTBLE(APCH)) Q:APCH=""  S APCH("NUM")=APCH("NUM")+1 W !,APCH("NUM"),")  ",APCH,$S(APCH'=APCHTBLE(APCH):"- "_APCHTBLE(APCH),1:"")
 I '$D(APCH("BANG")) W !
 Q
 ;
SHOW ; ENTRY POINT - ALLOW USER TO SELECT FROM RANGES TO DISPLAY CODES
 D RANGES
A W !,"Enter an Item Number from the table above to display code(s): " R APCH("N"):300 W:"^"[APCH("N") ! Q:"^"[APCH("N")  I APCH("N")'?1N!(APCH("N")>APCH("NUM")) W "  ??",$C(7) G A
 F APCHI=1:1:APCH("N") S APCH=$O(APCHTBLE(APCH)) I APCHI=APCH("N") S APCH("LOW")=APCH,APCH("HI")=APCHTBLE(APCH) D DISPLAY Q
 S APCH("BANG")="" D RANGES K APCH("BANG")
 Q
 ;
TAX ;PLACE CODES FROM SELECTED TAXONOMY IN APCHTBLE
 S APCH("S")="I Y'=APCHX",APCH("S")=$S($D(APCHX):APCH("S")_",$O(^ATXAX(Y,21,0))",1:"I $O(^(21,0))"),DIC("A")="TAXONOMY FROM WHICH TO SELECT CODES: ",APCH("S")=APCH("S")_$S('$D(APCHX):"",1:",$P(^ATXAX(APCHX,0),U,15)=$P(^ATXAX(Y,0),U,15)")
 I $E(X,2)="?" S X="?",DIC="^ATXAX(",DIC(0)="EM",DIC("S")=APCH("S") D ^DIC S DIC(0)="AEMQ",DIC("S")=APCH("S"),DIC="^ATXAX(" D ^DIC K DIC I 1
 E  S X=$E(X,2,99),DIC(0)="EMQ",DIC("S")=APCH("S"),DIC="^ATXAX(" D ^DIC K DIC
 I Y=-1 G X3
 S APCH("CODE")=0 F  S APCH("CODE")=$O(^ATXAX(+Y,21,"AA",APCH("CODE"))) Q:APCH("CODE")=""  S APCHTBLE(APCH("CODE"))=$O(^(APCH("CODE"),""))
X3 W ! Q
 ;
CHECK ;ASKS USER IF SATISFIED WITH ENTERED RANGES
 W ! S DIR(0)="Y",DIR("B")="Y",DIR("A")="Is everything okay" D ^DIR K DIR
 W !
 Q
 ;
EOJ ;
 K APCHSUB,APCHTYP,APCHDFN,DIR,APCHSAVE,APCHA,APCHCNT,APCH,APCHR,APCHI,APCHONE,APCHFLG,APCHSTP
 Q
 ;
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF APCHCODE
 S DIR(0)="FO",DIR("?",1)="Enter cpt code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  You may"
 S DIR("?",5)="also enter ""[TAXONOMY NAME"" to select codes already within a taxonomy."
 S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 S DIR("?")="code ranges selected so far."
 S DIR("??")="^D ASK2"
 Q
 ;
LOOK ; ENTRY POINT - LOOKUP USER RESPONSE; SET UTILITY NODES
 S DIC="^ICPT(",DIC(0)="EMF" D ^DIC K DIC,DR
 I Y<0 S APCHA=1 W $C(7),"  ??" S APCH("NO DISPLAY")=1 G X5
 S:APCHTYP="LOW" APCH("LOW")=$P(^ICPT(+Y,0),U)_" "
 I APCHTYP="LOW",APCHONE S APCH("HI")=APCH("LOW") D ^APCHTAXN
 I APCHTYP="HI" S APCH("HI")=$P(^ICPT(+Y,0),U)_" " D  I 'APCH("NO DISPLAY") D DISPLAY^APCHTAXM,^APCHTAXN
 . I $E(APCH("HI"))?1N&($E(APCH("LOW"))?1N)!($E(APCH("LOW"))'?1N&($E(APCH("HI"))'?1N))
 . E  W !,$C(7),"Low and high codes of range must both start either with a letter or a number.",! S APCH("NO DISPLAY")=1
 . I 'APCH("NO DISPLAY") I APCH("LOW")]APCH("HI") W !,$C(7),"Low code is higher than high code.",! S APCH("NO DISPLAY")=1
X5 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(APCHTBLE) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^APCHTAXM
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
