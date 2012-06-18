BARAC ; IHS/SD/LSL - A/R ACCOUNTS UTILITY ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;;OCT 26, 2005
 ;;
 Q
 ; *********************************************************************
 ;
DSP(DA)          ;** display an account
 N BART,I
 D ENP^XBDIQ1(90050.02,DA,".01;301:305","BART(")
 S I=""
 F  S I=$O(BART(I)) Q:I'>0  W !,I,?7,BART(I),?19,$P(^DD(90050.02,I,0),U)
 D EOP^BARUTL(0)
 ;
EDSP ;
 Q
