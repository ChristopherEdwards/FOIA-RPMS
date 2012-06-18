AQAOCOD0 ; IHS/ORDC/LJF - EXTENSION OF ROUTINE AQACODE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;IHS/ORDC/LJF; copy of rtn ^ATXCODE0;4.2;Taxonomy;;MAR 19, 1991
 ;  changes:  changed namespacing from ATX to AQA
 ;            added code checking AQAOICD to determine if ICD9 or ICD0
 ;            changed dir(?) to include procedures
 ;
 ;
INIT ;ENTRY POINT - initialize array; originally in ^ATXCODE
 S U="^",AQAO("NO DISPLAY")=0
 S:'$D(IOSL) IOP=$I D:'$D(IOSL) ^%ZIS I '$D(DTIME) D ^XBKVAR
 I $D(AQAOX) D  I 1
 .I $D(AQAOTBL) S AQAO("MODIFY")=1 D RANGES^AQAOCOD I 1
 .E  S AQAO("ENTER")=1
 E  S AQAO("NOT TAX")=""
 Q
 ;
LOOK ;ENTRY POINT - LOOKUP USER RESPONSE; SET UTILITY NODES
 S DIC=$S(AQAOICD=9:"^ICD9(",1:"^ICD0("),DIC(0)="EMF" D ^DIC K DIC,DR ;IHS/ORDC/LJF added code for ICD0
 I Y<0 S AQAOA=1 W *7,"  ??" S AQAO("NO DISPLAY")=1 G X3
 S:AQAOTYP="LOW" AQAO("LOW")=$S(AQAOICD=9:$P(^ICD9(+Y,0),U)_" ",1:$P(^ICD0(+Y,0),U)_" ") ;IHS/ORDC/LJF added code for ICD0
 I AQAOTYP="LOW",AQAONE S AQAO("HI")=AQAO("LOW") D ^AQAOCOD1
 I AQAOTYP="HI" S AQAO("HI")=$S(AQAOICD=9:$P(^ICD9(+Y,0),U)_" ",1:$P(^ICD0(+Y,0),U)_" ") D  I 'AQAO("NO DISPLAY") D DISPLAY^AQAOCOD,^AQAOCOD1 ;IHS/ORDC/LJF added code for ICD0
 .I $E(AQAO("HI"))?1N&($E(AQAO("LOW"))?1N)!($E(AQAO("LOW"))'?1N&($E(AQAO("HI"))'?1N))
 .E  W !,*7,"Low and high codes of range must both start either with a letter or a number.",! S AQAO("NO DISPLAY")=1
 .I 'AQAO("NO DISPLAY") I AQAO("LOW")]AQAO("HI") W !,*7,"Low code is higher than high code.",! S AQAO("NO DISPLAY")=1
X3 Q
 ;
SETDIR ;ENTRY POINT - SETS HELP AND DIR FOR INIT SUBROUTINE OF AQAOCOD
 ;
 ;IHS/ORDC/LJF original 6 lines of code from ^ATXCODE
 ;S DIR(0)="FO",DIR("?",1)="Enter ICD9 diagnosis code or narrative.  You may enter a range of",DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 ;S DIR("?",3)="include the first and last codes indicated and all codes that fall",DIR("?",4)="between.  Only one code or one range of codes at a time.  You may"
 ;S DIR("?",5)="also enter ""[TAXONOMY NAME"" to select codes already within a taxonomy."
 ;S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in",DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91')  Enter ""??"" to see"
 ;S DIR("?")="code ranges selected so far."
 ;S DIR("??")="^D ASK2^AQAOCOD0"
 ;
 ;IHS/ORDC/LJF new version of code
 S DIR(0)="FO"
 S DIR("?",1)="Enter ICD code or diagnosis/procedure narrative.  You may enter a range of"
 S DIR("?",2)="codes by placing a ""-"" between two codes.  Codes in a range will"
 S DIR("?",3)="include the first and last codes indicated and all codes that fall"
 S DIR("?",4)="between.  Only one code or one range of codes at a time.  You may also"
 S DIR("?",5)="enter ""[TAXONOMY NAME"" to select diagnosis codes already within a taxonomy."
 S DIR("?",6)="You can also ""de-select"" a code or range of codes by placing a ""-"" in"
 S DIR("?",7)="front of it. (e.g. '-250.00' or '-250.01-250.91').  To select ALL CODES"
 S DIR("?",8)="enter the letters ""ALL"" at the ENTER "_AQAOTL_" prompt."
 S DIR("?")="Enter ""??"" to see code ranges selected so far."
 S DIR("??")="^D ASK2^AQAOCOD0"
 Q
 ;
ASK2 ;ASKS USER IF WANTS TO DISPLAY/PRINT RESULTS TO THIS POINT
 I '$D(AQAOTBL) W !!,"A code range has yet to be selected.  A display cannot be generated.",! Q
 W !!,"Do you want to display the codes from a range you have already selected" S %=1 D YN^DICN I %=1 D SHOW^AQAOCOD
 I %=2!(%=-1) Q
 I %=0 W !!,"A table of ranges you have selected is displayed above.  You may ask for the",!,"codes in one of the ranges to be displayed.",! G ASK2
 Q
 ;
EOJ ;ENTRY POINT - end of job
 ;I $D(AQAO("NOT TAX")) K AQAOSTP,AQAOX
 ;K AQAOSUB,AQAOTYP,DFN,DIR,AQAOSAV,AQAOA,AQAOCT,AQAO,AQAOR,AQAOI,AQAONE,AQAOFLG
 Q
