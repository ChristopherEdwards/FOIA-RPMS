APCLTAXO ; IHS/CMI/LAB - EXTENSION OF ROUTINE APCLCODE ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;cmi/anch/maw 9/12/2007 code set versioning in LOOK
 ;
LOOK ; ENTRY POINT - LOOKUP USER RESPONSE; SET UTILITY NODES
 S DIC="^ICPT(",DIC(0)="EMF" D ^DIC K DIC,DR
 I Y<0 S APCLA=1 W $C(7),"  ??" S APCL("NO DISPLAY")=1 G X3
 ;S:APCLTYP="LOW" APCL("LOW")=$P(^ICPT(+Y,0),U)_" "  ;cmi/anch/maw 9/12/2007 orig line
 S:APCLTYP="LOW" APCL("LOW")=$P($$CPT^ICPTCOD(+Y),U,2)_" "  ;cmi/anch/maw 9/12/2007 csv
 I APCLTYP="LOW",APCLONE S APCL("HI")=APCL("LOW") D ^APCLTAXN
 ;I APCLTYP="HI" S APCL("HI")=$P(^ICPT(+Y,0),U)_" " D  I 'APCL("NO DISPLAY") D DISPLAY^APCLTAXM,^APCLTAXN  ;cmi/anch/maw 9/12/2007 orig line
 I APCLTYP="HI" S APCL("HI")=$P($$CPT^ICPTCOD(+Y),U,2)_" " D  I 'APCL("NO DISPLAY") D DISPLAY^APCLTAXM,^APCLTAXN  ;cmi/anch/maw 9/12/2007 csv
 . I $E(APCL("HI"))?1N&($E(APCL("LOW"))?1N)!($E(APCL("LOW"))'?1N&($E(APCL("HI"))'?1N))
 . E  W !,$C(7),"Low and high codes of range must both start either with a letter or a number.",! S APCL("NO DISPLAY")=1
 . I 'APCL("NO DISPLAY") I APCL("LOW")]APCL("HI") W !,$C(7),"Low code is higher than high code.",! S APCL("NO DISPLAY")=1
X3 Q
 ;
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF APCLCODE
 S DIR(0)="FO",DIR("?",1)="Enter cpt code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  You may"
 S DIR("?",5)="also enter ""[TAXONOMY NAME"" to select codes already within a taxonomy."
 S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 S DIR("?")="code ranges selected so far."
 S DIR("??")="^D ASK2^APCLTAX0"
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(APCLTBLE) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^APCLTAXM
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
