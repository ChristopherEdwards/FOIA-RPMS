ATXTAXM ; IHS/CMI/LAB - INTERFACE TO SELECT ICD CODES ;
 ;;5.1;TAXONOMY;**11**;FEB 04, 1997;Build 48
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in DISPLAY
 ;
 D INIT
BEGIN D ASK1
 I Y="^" S ATXSTP=1 G X
 I $D(ATXTBLE) D CHECK I Y'=1 G @$S(Y=0:"BEGIN",1:"X")
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
 S ATXA=0
 K ATX("LOW"),ATX("HI")
 S DIR("A")=$S('$D(ATXTBLE):"ENTER CPT",1:"ENTER ANOTHER CPT") D SETDIR^ATXTAXO,^DIR K DIR
 I "^"[Y G X1
 D PROCESS
 I $D(ATXTBLE),'ATX("NO DISPLAY") D RANGES
 S ATX("NO DISPLAY")=0
 G ASK1
X1 Q
 ;
PROCESS ;EVALUATE USER RESPONSE
 S (ATXSUB,ATXONE)=0 ;ATXSUB=0 => NO DELETE OF CODE(S),ATXONE=0 => RANGE OF CODES ENTERED
 I $E(X,1,2)="-[" W $C(7),"  ?? Not allowed" S ATX("NO DISPLAY")=1 G X2
 I $E(X)="[" D TAX G X2
 I X'["-" S ATXTYP="LOW",ATXONE=1 D LOOK^ATXTAXO G X2
 I $E(X)="-",'$D(ATXTBLE) W $C(7),"  ??  No previous codes entered!" G X2
 I $L(X,"-")>3 W $C(7),"  ??"  S ATXA=1 S ATX("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$E(X,$L(X))="-" W $C(7),"  ??" S ATXA=1 S ATX("NO DISPLAY")=1 G X2
 I $L(X,"-")=3,$P(X,"-")]"" W $C(7),"  ??" S ATXA=1 S ATX("NO DISPLAY")=1 G X2
 I $E(X)="-" S ATXSUB=1 D  I 1
 . S ATXSAVE("X")=X
 . I $L(X,"-")=3 S X=$P(ATXSAVE("X"),"-",2),ATXTYP="LOW" D LOOK^ATXTAXO I 'ATXA S X=$P(ATXSAVE("X"),"-",3),ATXTYP="HI" W ! D LOOK^ATXTAXO Q
 . I $L(ATXSAVE("X"),"-")=2 S X=$E(X,2,99),ATXTYP="LOW",ATXONE=1 D LOOK^ATXTAXO
 E  S ATXSAVE("X")=X S ATXTYP="LOW",X=$P(ATXSAVE("X"),"-") D LOOK^ATXTAXO I 'ATXA S ATXTYP="HI",X=$P(ATXSAVE("X"),"-",2) W ! D LOOK^ATXTAXO
X2 Q
 ;
DISPLAY ;EP - SHOW CODES IN RANGE SELECTED
 W:$D(IOF) @IOF
 ;W !!,"CPT codes in this range =>",!! W $P(ATX("LOW")," ") S ATXDFN=$O(^ICPT("BA",ATX("LOW"),"")) W ?9,$P(^ICPT(ATXDFN,0),U,2)  ;cmi/anch/maw 9/12/2007 orig line
 W !!,"CPT codes in this range =>",!! W $P(ATX("LOW")," ") S ATXDFN=$O(^ICPT("BA",ATX("LOW"),"")) W ?9,$P($$CPT^ICPTCOD(ATXDFN),U,3)  ;cmi/anch/maw 9/12/2007 csv
 ;S ATX=ATX("LOW"),ATXCNT=IOSL-2 F  S ATX=$O(^ICPT("BA",ATX)) Q:ATX]ATX("HI")  S ATXDFN=$O(^(ATX,"")) W !,$P(ATX," "),?9,$P(^ICPT(ATXDFN,0),U,2) S ATXCNT=ATXCNT-1 I ATXCNT=0 S ATXCNT=IOSL-2 D  I ATXR=U Q  ;cmi/maw orig line
 S ATX=ATX("LOW"),ATXCNT=IOSL-2 F  S ATX=$O(^ICPT("BA",ATX)) Q:ATX]ATX("HI")  S ATXDFN=$O(^(ATX,"")) W !,$P(ATX," "),?9,$P($$CPT^ICPTCOD(ATXDFN),U,3) S ATXCNT=ATXCNT-1 I ATXCNT=0 S ATXCNT=IOSL-2 D  I ATXR=U Q  ;cmi/maw csv
A1 . R !,"<>",ATXR:DTIME W:ATXR["?" " Enter ""^"" to stop display, return to continue" G:ATXR["?" A1
 I $S('$D(ATXR):1,ATXR'=U:1,1:0) R !!,"Press return to continue",ATXR:DTIME
 W !
 K ATXR Q
 ;
RANGES ;DISPLAY TABLE OF ALL RANGES
 W:$D(IOF) @IOF
 W !!,"CPT Code Range(s) Selected So Far =>",!
 S (ATX("NUM"),ATX)=0 F  S ATX=$O(ATXTBLE(ATX)) Q:ATX=""  S ATX("NUM")=ATX("NUM")+1 W !,ATX("NUM"),")  ",ATX,$S(ATX'=ATXTBLE(ATX):"- "_ATXTBLE(ATX),1:"")
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
TAX ;PLACE CODES FROM SELECTED TAXONOMY IN ATXTBLE
 S ATX("S")="I Y'=ATXX",ATX("S")=$S($D(ATXX):ATX("S")_",$O(^ATXAX(Y,21,0))",1:"I $O(^(21,0))"),DIC("A")="TAXONOMY FROM WHICH TO SELECT CODES: ",ATX("S")=ATX("S")_$S('$D(ATXX):"",1:",$P(^ATXAX(ATXX,0),U,15)=$P(^ATXAX(Y,0),U,15)")
 I $E(X,2)="?" S X="?",DIC="^ATXAX(",DIC(0)="EM",DIC("S")=ATX("S") D ^DIC S DIC(0)="AEMQ",DIC("S")=ATX("S"),DIC="^ATXAX(" D ^DIC K DIC I 1
 E  S X=$E(X,2,99),DIC(0)="EMQ",DIC("S")=ATX("S"),DIC="^ATXAX(" D ^DIC K DIC
 I Y=-1 G X3
 S ATX("CODE")=0 F  S ATX("CODE")=$O(^ATXAX(+Y,21,"AA",ATX("CODE"))) Q:ATX("CODE")=""  S ATXTBLE(ATX("CODE"))=$O(^(ATX("CODE"),""))
X3 W ! Q
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