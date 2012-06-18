ATXCODE0 ; IHS/OHPRD/TMJ -  EXTENSION OF ROUTINE ATXCODE ; 
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
LOOK ; ENTRY POINT - LOOKUP USER RESPONSE; SET UTILITY NODES
 S DIC="^ICD9(",DIC(0)="EMF" D ^DIC K DIC,DR
 I Y<0 S ATXA=1 W $C(7),"  ??" S ATX("NO DISPLAY")=1 G X3
 ;S:ATXTYP="LOW" ATX("LOW")=$P(^ICD9(+Y,0),U)_" "
 S:ATXTYP="LOW" ATX("LOW")=$P($$ICDDX^ICDCODE(+Y),U,2)_" "
 I ATXTYP="LOW",ATXONE S ATX("HI")=ATX("LOW") D ^ATXCODE1
 ;I ATXTYP="HI" S ATX("HI")=$P(^ICD9(+Y,0),U)_" " D  I 'ATX("NO DISPLAY") D DISPLAY^ATXCODE,^ATXCODE1
 I ATXTYP="HI" S ATX("HI")=$P($$ICDDX^ICDCODE(+Y),U,2)_" " D  I 'ATX("NO DISPLAY") D DISPLAY^ATXCODE,^ATXCODE1
 . I $E(ATX("HI"))?1N&($E(ATX("LOW"))?1N)!($E(ATX("LOW"))'?1N&($E(ATX("HI"))'?1N))
 . E  W !,$C(7),"Low and high codes of range must both start either with a letter or a number.",! S ATX("NO DISPLAY")=1
 . I 'ATX("NO DISPLAY") I ATX("LOW")]ATX("HI") W !,$C(7),"Low code is higher than high code.",! S ATX("NO DISPLAY")=1
X3 Q
 ;
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF ATXCODE
 S DIR(0)="FO",DIR("?",1)="Enter ICD9 diagnosis code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  You may"
 S DIR("?",5)="also enter ""[TAXONOMY NAME"" to select codes already within a taxonomy."
 S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 S DIR("?")="code ranges selected so far."
 S DIR("??")="^D ASK2^ATXCODE0"
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(ATXTABLE) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^ATXCODE
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
