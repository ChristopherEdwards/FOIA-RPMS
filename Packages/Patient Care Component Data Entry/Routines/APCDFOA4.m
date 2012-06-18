APCDFOA4 ; IHS/CMI/LAB - EXTENSION OF ROUTINE APCDFOA3 ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
LOOK ; ENTRY POINT - LOOKUP USER RESPONSE; SET TMP NODES
 S DIC="^ICD0(",DIC(0)="EMF" D ^DIC K DIC,DR
 I Y<0 S APCDA=1 W $C(7),!,"  ??  Invalid ",$S(APCDTYP="LOW":"LOW",1:"HIGH")," Code" S APCD("NO DISPLAY")=1 G X3
 ;S:APCDTYP="LOW" APCD("LOW")=$P(^ICD0(+Y,0),U)_" "
 S:APCDTYP="LOW" APCD("LOW")=$P($$ICDOP^ICDCODE(+Y),U,2)_" "
 I APCDTYP="LOW",APCDONE S APCD("HI")=APCD("LOW") D ^APCDFOA5
 I APCDTYP="HI" S APCD("HI")=$P($$ICDOP^ICDCODE(+Y),U,2)_" " D  I 'APCD("NO DISPLAY") D DISPLAY^APCDFOA3,^APCDFOA5
 . I $E(APCD("HI"))?1N&($E(APCD("LOW"))?1N)!($E(APCD("LOW"))'?1N&($E(APCD("HI"))'?1N))
 . E  W !,$C(7),"Low and high codes of range must both start either with a letter or a number.",! S APCD("NO DISPLAY")=1
 . I 'APCD("NO DISPLAY") I APCD("LOW")]APCD("HI") W !,$C(7),"Low code is higher than high code.",! S APCD("NO DISPLAY")=1
X3 Q
 ;
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF APCDFOA3
 S DIR(0)="FO",DIR("?",1)="Enter ICD OPERATION/PROCEDURE code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time."
 S DIR("?",5)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 S DIR("?")="code ranges selected so far."
 S DIR("??")="^D ASK2^APCDFOA4"
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(APCDTABL) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^APCDFOA3
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
