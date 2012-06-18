ACGS2811 ;IHS/OIRM/DSD/THL,AEF - UTILITY TO PRINT THE SMALL PURCHASE 281 REPORT - CONT;  [ 03/27/2000   2:22 PM ]
 ;;2.0t1;CONTRACT INFORMATION SYSTEM;;FEB 16, 2000
 ;;UTILITY TO PRINT THE SMALL PURCHASE 281 REPORT - CONT
 D L2
 W !,"1. TARIFF/REGULATED"
 D L111
 W !,"   ACQUISITION"
 D L111
 D L2
 W !,"2. CONTRACT FOR GOV"
 D L111
 W !,"   OR INTNAT ORG"
 D L111
 D L2
 I $D(IOST),$E(IOST,1,2)="C-" D HOLD^ACGSMENU
 W !,"3. SMALL PURCHASE"
 D L11
 W !,"   (FAR PART 13)"
 S ACGX=1 D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W !,"4. DO (GSA SCHED)"
 S ACGX=2 D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W !,"5. DO (OTH FED SCHED"
 S ACGX=3 D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W !,"6. DO (ALL OTHER)"
 S ACGX=4 D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W !,"7. OTHER PROC METHOD"
 S ACGX=5 D L4
 D L2
 W !,"   PERRY POINT"
 S ACGX=6 D L4
 D L2
 W !,"   VA - HINES"
 S ACGX=7 D L4
 D L2
 W !,"   FEDSTRIP"
 S ACGX=8 D L4
 D L2
 W !,"   IMPREST FUND"
 S ACGX=9 D L4
 D L2
 W !,"   SF-44"
 S ACGX=0 D L4
 D L2
 W !,"8. TOTAL NEW AWARDS"
 D L11
 W !,"   AND MODIFICATIONS"
 W ?20,"|",$J($P(ACGPM(ACG4XX,1),U,3),8),?30,"|",$J($FN(ACGPM(ACG4XX,"A1"),"P",0),9),?40,"|",$J($FN(ACGPM(ACG4XX,"A2"),"P",0),9),?50,"|",$J($FN(ACGPM(ACG4XX,"A3"),"P",0),9),?60,"|",$J($FN(ACGPM(ACG4XX,"A4"),"P",0),9),?70,"|"
 W $J($FN($P(ACGPM(ACG4XX,1),U,4),"P",0),9)
 I $D(IOST),$E(IOST,1,2)="C-" D HOLD^ACGSMENU I 1
 D L
 W !?4,"COMPETITION"
 D L
 W ! D L11
 W !,"9. COMPETED"
 S ACGX="A" D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W !,"10.NOT AVAILABLE FOR"
 D L11
 W !,"   COMPETITION"
 S ACGX="B" D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W ! D L11
 W !,"11.NOT COMPETED"
 S ACGX="C" D L4 ;W ?20,"|",?30,"|",?40,"|",?50,"|",?60,"|",?70,"|"
 D L2
 W !,"12.TOT MODIFICATIONS"
 D L111
 W !,"  (EXCLUDING -L 3)"
 D L111
 D L
 I $D(IOST),$E(IOST,1,2)="C-" D HOLD^ACGSMENU
 W @IOF,!?15,"PART II - SELECTED SOCIOECONOMIC STATISTICS"
 W !?15,"(includes both new awards and modifications)"
 D L
 W !?10,"PREFERENCE PROGRAM",?40,"|",?50,"TYPE OF CONTRACTOR"
 W !,"----------------------------------------|---------------------------------------"
 W !?20,"| NUMBER  |  TOTAL  |                   | NUMBER  |  TOTAL"
 W !?5,"CATEGORY",?20,"|   OF    |   NET   |    CATEGORY       |   OF    |   NET"
 W !?20,"| ACTIONS | DOLLARS |                   | ACTIONS | DOLLARS"
 D L3
 W !,"13.SMALL BUS. SMALL |",?30,"|",?40,"|18.SMALL DISADVAN  |",?70,"|"
 W !,"   PURCHASE SETASIDE|" S X=ACGPP(ACG4XX,1) D L5
 W ?40,"|   BUSINESS        |" S X=ACGTC(ACG4XX,1) D L5
 W !,"14.LABOR SURPLUS    |",?30,"|",?40,"|19.WOMAN OWND SMALL|",?70,"|"
 W !,"   AREA SET-ASIDE   |" S X=ACGPP(ACG4XX,2) D L5
 W ?40,"|   BUSINESS        |" S X=ACGTC(ACG4XX,2) D L5
 W !,"15.COMB LABOR SURP/ |",?30,"|",?40,"|20.SHELTERED       |",?70,"|"
 W !,"   SM BUS. SET-ASIDE|" S X=ACGPP(ACG4XX,3) D L5
 W ?40,"|   WORKSHOP        |" S X=ACGTC(ACG4XX,3) D L5
 W !,"16.BUY INDIAN       |" S X=ACGPP(ACG4XX,4) D L5
 W ?40,"|21.UNICOR          |" S X=ACGTC(ACG4XX,4) D L5
 W !,"17.OTHER            |" S X=ACGPP(ACG4XX,5) D L5
 W ?40,"|22.BUY INDIAN      |" S X=ACGTC(ACG4XX,6) D L5
 W !?40,"|23.OTHER           |" S X=ACGTC(ACG4XX,5) D L5
 D L
 W !,"PERSON SUBMITTING REPORT"
 D L
 W !,"NAME",?25,"| SIGNATURE",?50,"| PHONE",?65,"| DATE"
 W !,ACGDUZ,?25,"|",?50,"| ",ACGPHONE,?65,"| ",ACGTODAY
 I $D(IOST),$E(IOST,1,2)="C-" D HOLD^ACGSMENU I 1
 E  D L
 Q
L W !,"--------------------------------------------------------------------------------"
 Q
L1 W !?20,"|---------|---------|---------|---------|---------|---------"
 Q
L11 W ?20,"|         |         |         |         |         |"
 Q
L111 W ?20,"|         |XXXXXXXXX|XXXXXXXXX|XXXXXXXXX|XXXXXXXXX|"
 Q
L2 W !,"--------------------|---------|---------|---------|---------|---------|---------"
 Q
L3 W !,"--------------------|---------|---------|-------------------|---------|---------"
 Q
L4 S ACG5=0
 F X=1:1:4 S X(X)=+ACGPM(ACG4XX,ACGX,"A"_X) D Y S ACG5=ACG5+X(X)
 S X=$P(ACGPM(ACG4XX,ACGX),U,2),X=$S(X:X,1:0)
 W ?20,"|",$J(X,8),?30,"|",$J($FN(X(1),"P",0),9),?40,"|",$J($FN(X(2),"P",0),9),?50,"|",$J($FN(X(3),"P",0),9),?60,"|",$J($FN(X(4),"P",0),9),?70,"|",$J($FN(ACG5,"P",0),9)
 Q
L5 S X(1)=X,X=1
 D Y
 W $J($S($P(X(1),U,2):$P(X(1),U,2),1:0),8)," |",$J($FN(+X(1),"P",0),9)
 Q
Y Q  S Y=X(X),Y=$E(Y,1,$L(Y)-3)+$S($E(Y,$L(Y)-2)>4:1,1:0),X(X)=Y
 Q
