FHASS1 ; GLRISC/REL - Nutritional Assessment Cont. ; 30-Jan-88  12:32 pm ; [ 06/07/90  12:32 PM ]
 ;;3.16;NUTRITION & DIETETICS;;*;;1NOV90
 S RTE=0,ACT="" D BEE,STR:TYP="Y",ACT:TYP'="Y",RAT:OPT'="M",PRO
 K IOP S %IS="MQ",%IS("A")="Select Report Device: ",%IS("B")="HOME" W ! D ^%ZIS K %IS,IOP G:POP KIL^FHASS
 I $D(IO("Q")) S FHPGM="^FHASS3",FHLST="NAM^SEX^AGE^WGT^IBW^FRM^HGT^UWGT^BEE^AMP^TYP^ACT^KCAL^RTE^OPT^PRO^NIT^EXT^X(^Y(" D EN2^FH G F1^FHASS
 U IO D ^FHASS3 U IO(0) X ^%ZIS("C") S IOP="" D ^%ZIS K %IS,IOP G F1^FHASS
RAT S RTE=0 W !!,"Select rate of ",$S(OPT="G":"gain",1:"loss")," in lbs./week (0-2.5): " R RTE:DTIME Q:"^"[RTE  I RTE'?.N.1".".N!(RTE<0)!(RTE>2.5) W *7," ??" G RAT
 S KCAL=$S(OPT="L":-RTE,1:RTE)*500+KCAL Q
ACT R !!,"Activity Level (Sedentary, Moderate, High): ",ACT:DTIME S:ACT="" ACT="M" I $P("SEDENTARY",ACT,1)'="",$P("MODERATE",ACT,1)'="",$P("HIGH",ACT,1)'="" W *7,"  Enter S, M or H" G ACT
 S ACT=$E(ACT,1),KCAL=$S(ACT="S":3,ACT="H":10,1:5)*WGT+BEE Q
PRO R !!,"Select Protein Level (0.5-3.5 g/kg): 0.8// ",PRO:DTIME S:PRO="" PRO=0.8
 I PRO'?.N.1".".N!(PRO<.5)!(PRO>3.5) W *7," Select value between .5 and 3.5" G PRO
 S PRO=$S(OPT="M":WGT,1:IBW)/2.2*PRO,NIT=PRO/6.25 Q
STR W !!,"Activity Factor (AF)",!?3,"1  Confined to Bed (1.2)",!?3,"2  Out of Bed (1.3)"
 R !!?3,"Level: ",AF:DTIME I AF'=1,AF'=2 W *7," Select 1 or 2" G STR
S1 W !!,"Stress/Injury Factor (IF)",!?3,"1.20 Minor Operation",!?3,"1.35 Skeletal Trauma"
 W !?3,"1.60 Major Sepsis",!?3,"2.10 Severe Burn"
 R !!?3,"Level (1.00-2.10): ",IF:DTIME S:'$T IF=1 I IF'?.N.1".".N!(IF<1)!(IF>2.1) W *7,"  select value between 1.00 and 2.10" G S1
S2 R !!,"Oral Temperature (deg F): ",FF:DTIME S:FF="" FF=98.6 I FF'?.N.1".".N!(FF<94)!(FF>107) W *7," Enter values in degrees F." G S2
 S KCAL=BEE*$S(AF=1:1.2,1:1.3)*IF
 S:FF>98.6 KCAL=KCAL+(FF-98.6*.07*BEE) Q
BEE I SEX="M" S BEE=66.47+(6.25*WGT)+(12.70*HGT)-(6.76*AGE)
 I SEX="F" S BEE=655.10+(4.35*WGT)+(4.70*HGT)-(4.68*AGE)
 S BEE=$J(BEE,0,0) Q
