BDMCOD0 ; IHS/CMI/LAB - EXTENSION OF ROUTINE BDMCODE ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**2**;JUN 14, 2007
 ;
 ;cmi/anch/maw 9/10/2007 code set versioning in LOOK
 ;
LOOK ; ENTRY POINT - LOOKUP USER RESPONSE; SET UTILITY NODES
 S DIC="^ICD9(",DIC(0)="EMF" D ^DIC K DIC,DR
 I Y<0 S BDMA=1 W $C(7),"  ??" S BDM("NO DISPLAY")=1 G X3
 ;S:BDMTYP="LOW" BDM("LOW")=$P(^ICD9(+Y,0),U)_" "
 S:BDMTYP="LOW" BDM("LOW")=$P($$ICDDX^ICDCODE(+Y),U,2)_" "
 I BDMTYP="LOW",BDMONE S BDM("HI")=BDM("LOW") D ^BDMCOD1
 ;I BDMTYP="HI" S BDM("HI")=$P(^ICD9(+Y,0),U)_" " D  I 'BDM("NO DISPLAY") D DISPLAY^BDMCODE,^BDMCOD1
 I BDMTYP="HI" S BDM("HI")=$P($$ICDDX^ICDCODE(+Y),U,2)_" " D  I 'BDM("NO DISPLAY") D DISPLAY^BDMCODE,^BDMCOD1
 . I $E(BDM("HI"))?1N&($E(BDM("LOW"))?1N)!($E(BDM("LOW"))'?1N&($E(BDM("HI"))'?1N))
 . E  W !,$C(7),"Low and high codes of range must both start either with a letter or a number.",! S BDM("NO DISPLAY")=1
 . I 'BDM("NO DISPLAY") I BDM("LOW")]BDM("HI") W !,$C(7),"Low code is higher than high code.",! S BDM("NO DISPLAY")=1
X3 Q
 ;
SETDIR ; ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF BDMCODE
 S DIR(0)="FO",DIR("?",1)="Enter ICD9 diagnosis code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  You may"
 S DIR("?",5)="also enter ""[TAXONOMY NAME"" to select codes already within a taxonomy."
 S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 S DIR("?")="code ranges selected so far."
 S DIR("??")="^D ASK2^BDMCODE0"
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(BDMTBLE) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^BDMCODE
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
