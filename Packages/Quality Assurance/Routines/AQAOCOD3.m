AQAOCOD3 ; IHS/ORDC/LJF - SHOW PROCEDURE CODE RANGE ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This rtn contains an entry point called by ^AQAOCOD to display the
 ;list of procedures the user has selected so far.
 ;
DISPLAY2 ;ENTRY POINT called by AQAOCOD
 ;SHOW PROCEDURE CODES IN RANGE SELECTED
 W !!,"ICD codes in this range =>",!! W $P(AQAO("LOW")," ") S DFN=$O(^ICD0("BA",AQAO("LOW"),"")) W ?9,$P(^ICD0(DFN,0),U,4) ;IHS/ORDC/LJF changed ICD9 to ICD0
 S AQAO=AQAO("LOW"),AQAOCT=IOSL-2 F  S AQAO=$O(^ICD0("BA",AQAO)) Q:AQAO]AQAO("HI")  S DFN=$O(^(AQAO,"")) W !,$P(AQAO," "),?9,$P(^ICD0(DFN,0),U,4) S AQAOCT=AQAOCT-1 I AQAOCT=0 S AQAOCT=IOSL-2 D  I AQAOR=U Q  ;IHS/ORDC/LJF changed ICD9 to ICD0
A1 .R !,"<>",AQAOR:DTIME W:AQAOR["?" " Enter ""^"" to stop display, return to continue" G:AQAOR["?" A1
 I $S('$D(AQAOR):1,AQAOR'=U:1,1:0) R !!,"Press return to continue",AQAOR:DTIME
 W !
 K AQAOR Q
