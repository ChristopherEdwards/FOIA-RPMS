AMQQTXC ; IHS/CMI/THL - CODE RANGE TAXONOMY ; 17 Mar 2014  2:25 PM
 ;;2.0;IHS PCC SUITE;**11**;MAY 14, 2009;Build 58
 ;-----
 K AMQQXSAV
 ;I ^DD("VERSION")<22 S DIC=$S($G(DUZ("AG"))="I":"@AMQQTGBL@(",1:AMQQTGBL_"(")
 I AMQQTGBL="^ICD9"!(AMQQTGBL="^ICD0"),'$G(AMQQISYS) S AMQQXSAV=X D ICDCS^AMQQTXG I AMQQISYS="" W !!,"You must indicate the coding system (ICD9 or ICD10).",! K AMQQISYS,AMQQXSAV S X=U,Y=-1 S AMQQA=1 S AMQQ("NO DISPLAY")=1 Q
 I $D(AMQQXSAV) S X=AMQQXSAV
 S DIC=AMQQTGBL_"("
 S DIC(0)="EMF"
 I $D(AMQQXX),$D(AMQQNECO) S DIC(0)="MF"
 I $G(AMQQSQNM)="CAUSE OF INJURY (PRIMARY)" S DIC("S")="I $$CAUSE^APCDAPOV(+Y,AMQQISYS)"
 E  I AMQQTGBL="^ICD9" S DIC("S")="I '$$CAUSE^APCDAPOV(+Y,AMQQISYS)"
 I AMQQTGBL="^ICD9"!(AMQQTGBL="^ICD0") S ICDSYS=AMQQISYS
 D ^DIC
 K DIC,DR
 I Y<0 S AMQQA=1 W:'$D(DUOUT) *7,"  ?? ",X," => Code does not exist!" S AMQQ("NO DISPLAY")=1 Q
 S:AMQQTYP="LOW" AMQQ("LOW")=$P(@AMQQTGBL@(+Y,0),U)_" "
 I AMQQTYP="LOW",AMQQONE S AMQQ("HI")=AMQQ("LOW") D ^AMQQTXC1
 I AMQQTYP="HI" S AMQQ("HI")=$P(@AMQQTGBL@(+Y,0),U)_" " D L1 I 'AMQQ("NO DISPLAY") D DISPLAY Q:$D(AMQQQUIT)  D ^AMQQTXC1
EXIT K %,AMQQXSAV
 Q
 ;
L1 I $E(AMQQ("HI"))?1N&($E(AMQQ("LOW"))?1N)!($E(AMQQ("LOW"))'?1N&($E(AMQQ("HI"))'?1N))
 E  W !,*7,"Low and high codes of range must both start either with a letter or a number.",! S AMQQ("NO DISPLAY")=1
 I 'AMQQ("NO DISPLAY") I AMQQ("LOW")]AMQQ("HI") W !,*7,"Low code is higher than high code.",! S AMQQ("NO DISPLAY")=1
 Q
 ;
DISPLAY ;SHOW CODES IN RANGE SELECTED
 W:$D(IOF) @IOF
 W !!,"Codes in this range =>",!!
 ;I AMQQTGBL="^ICD9"!(AMQQTGBL="^ICD0") D ICDL Q
 W $P(AMQQ("LOW")," ")
 S AMQQDFN=$O(@AMQQTGBL@("BA",AMQQ("LOW"),""))
 W ?9,$S(AMQQTGBL="^ICPT":$P(@AMQQTGBL@(AMQQDFN,0),U,2),AMQQTGBL="^ICD9":$P($$ICDDX^ICDEX(AMQQDFN),U,4),1:$P($$ICDOP^ICDEX(AMQQDFN,"","","I"),U,5))
 S AMQQ=AMQQ("LOW")
 S AMQQCNT=IOSL-5
 S AMQQDFN=$O(@AMQQTGBL@("BA",AMQQ,""))
 D A1
 F  S AMQQ=$O(@AMQQTGBL@("BA",AMQQ)) Q:AMQQ=""!(AMQQ]AMQQ("HI"))  S AMQQDFN=$O(^(AMQQ,"")) D
 .I AMQQTGBL="^ICD9" Q:$P($$ICDDX^ICDEX(AMQQDFN),U,20)'=AMQQISYS
 .I AMQQTGBL="^ICD0" Q:$P($$ICDOP^ICDEX(AMQQDFN,"","","I"),U,15)'=AMQQISYS
 .I $D(AMQQTJMP) W "." S ^UTILITY("AMQQ TAX",$J,AMQQURGN,AMQQDFN)="""" Q
 .W !,$P(AMQQ," "),?9,$S(AMQQTGBL="^ICPT":$P(@AMQQTGBL@(AMQQDFN,0),U,2),AMQQTGBL="^ICD9":$P($$ICDDX^ICDEX(AMQQDFN),U,4),AMQQTGBL="^ICD0":$P($$ICDOP^ICDEX(AMQQDFN,"","","I"),U,5),1:$P(@AMQQTGBL@(AMQQDFN,0),U,3)) D A1 I $D(AMQQQUIT) Q
 K AMQQTJMP
 I $S('$D(AMQQR):1,AMQQR'=U:1,1:0) R !!,"Press return to continue",AMQQR:DTIME E  S AMQQR=U
 I AMQQR=U Q
 W !
 Q
 ;
A1 S AMQQCNT=AMQQCNT-1
 I '$D(AMQQTXEX) S ^UTILITY("AMQQ TAX",$J,AMQQURGN,AMQQDFN)=""
 E  K ^UTILITY("AMQQ TAX",$J,AMQQURGN,AMQQDFN)
 I AMQQCNT Q
A11 S AMQQCNT=IOSL-4
 R !,"<>",AMQQR:DTIME E  S AMQQR=U
 I AMQQR=U S AMQQTJMP="" W !,"OK" Q
 I AMQQR["?" W " Enter ""^"" to stop display, return to continue" G A11
 Q
 ;
RANGES ; ENTRY POINT FROM AMQQTXG1 ; DISPLAY TABLE OF ALL RANGES
 I $D(AMQQXX) Q
 W:$D(IOF) @IOF
 I '$D(AMQQNECO) W !!,"Code Range(s) Selected So Far =>",!
 S (AMQQ("NUM"),AMQQ)=0
 F  S AMQQ=$O(@AMQQHILO@(AMQQ)) Q:AMQQ=""  S AMQQ("NUM")=AMQQ("NUM")+1 W !,AMQQ("NUM"),")  ",AMQQ,$S(AMQQ'=$P(@AMQQHILO@(AMQQ),U,1):"- "_$P(@AMQQHILO@(AMQQ),U,1),1:"") W:$P(@AMQQHILO@(AMQQ),U,3) $P(^ICDS($P(@AMQQHILO@(AMQQ),U,3),0),U,1)
 I '$D(AMQQ("BANG")) W !
 Q
 ;
SHOW ; ENTRY POINT FROM AMQQTXG1 ; ALLOW USER TO SELECT FROM RANGES TO DISPLAY CODES
 D RANGES
 I AMQQ("NUM")=1 S X=1 G AA
A W !,"Enter an Item Number from the table above to display code(s): "
 R X:DTIME E  S X=U
 I X?1."?" W !!,"Enter a number between 1 and ",AMQQ("NUM"),! G A
 I X=U Q
 I X,X'>AMQQ("NUM"),X?1N
 E  W "  ??",*7 G A
AA S AMQQ("N")=X
 F AMQQI=1:AMQQ("N") S AMQQ=$O(@AMQQHILO@(AMQQ)) I AMQQI=AMQQ("N") S AMQQ("LOW")=AMQQ,AMQQ("HI")=@AMQQHILO@(AMQQ) D DISPLAY Q
 S AMQQ("BANG")=""
 D RANGES
 K AMQQ("BANG")
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(@AMQQHILO) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected"
 S %=1
 D YN^DICN
 I %=1 D SHOW
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
