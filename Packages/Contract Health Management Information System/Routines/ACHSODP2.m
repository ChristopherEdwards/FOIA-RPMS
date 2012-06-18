ACHSODP2 ; IHS/ITSC/PMF - PRINT DCR REPORT (3/3) ;   [ 10/16/2001   8:16 AM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 D SB2           ;PRINT COLUMN HEADINGS
 ;
 S ACHSACTN=$G(^ACHS(9,DUZ(2),"RN"))  ;'R-1 NAME' 
 S X2=2,X3=12,ACHSOUT=0,ACHSBBAL=""
 I ACHSREG>1,$D(^ACHS(9,DUZ(2),"FY",ACHSFYY,"W",ACHSREG-1,1)) S ACHSBBAL=$G(^ACHS(9,DUZ(2),"FY",ACHSFYY,"W",ACHSREG-1,1))
 ;
 ;
 F %=1:1:7 S $P(ACHSSUM(%),U,3)=$P(ACHSSUM(%),U)-$P(ACHSSUM(%),U,2)
 F K=1:1:7 W !,$E($P(ACHSACTN,U,K),1,18),?18 D SB1 W:K<7 !
 ;
 W !
 D S21            ;UNDERLINE COLUMN HEADINGS
 W !,"TOTAL",?18
 S X=0 F %=1:1:7 S X=X+$P(ACHSBBAL,U,%)
 ;
 D FMT            ;FORMAT DOLLAR AMTS
 ;
 F ACHSX=1,2,3 F I=1:1:7 S X=X+$P(ACHSSUM(I),U,ACHSX) D:I=7 FMT
 ;
 S ACHSEBAL=""
 F %=1:1:7 S Y=$P(ACHSBBAL,U,%)+$P(ACHSSUM(%),U,3),X=X+Y,ACHSEBAL=ACHSEBAL_Y_"^",ACHSACTO=X
 ;
 D FMT             ;FORMAT DOLLAR AMTS
 ;
 S ACHSCHSS="V"
 D:'$D(ACHS("DCR")) ^ACHSUF    ;CHS FACILITY VARS, CHECK DATA INTEGRITY 
 ;
 S ACHSEBCK=$G(^ACHS(9,DUZ(2),"FY",ACHSFYY,"W",ACHSREG,1))
 ;
 F %=1:1:7 I +$P(ACHSEBAL,U,%)'=+$P(ACHSEBCK,U,%) W !!!!?15,"*****  SYSTEM OUT OF BALANCE  *****  DCR ACCOUNT# ",%," ********" S ACHSOUT=2
 I ACHSREG=+(ACHSFYWK(DUZ(2),$S($D(ACHS("DCR")):ACHSCFY-1,1:ACHSCFY))) S ACHSACWK=ACHSREG,ACHSACFY=ACHSFYY D CKB^ACHSUUP G END:$D(ACHSCNC)
 ;
 S X2="2$",X3=18
 S X=$P(^ACHS(9,DUZ(2),"FY",ACHSFYY,0),U,2) ;'CURRENT ADVICE OF ALLOWANCE
 S ACHSACT1=X
 D COMMA^%DTC
 ;
 W !!!!!?2,"Year to Date Allowance:",X,!?7,"Obligated Balance:" S X=ACHSACTO D COMMA^%DTC W X,!?27,"----------------",!?5,"Unobligated Balance:"
 ;
 S X=$J(ACHSACT1-ACHSACTO,1,2)
 D FMT
END ; Ask RTRN, write IOF, kill vars, quit.
 D RTRN^ACHS
 W @IOF
 K ACHSBBAL,ACHSEBAL,ACHSEBCK,X2,X3
 Q
 ;
SB1 ;
 S X=$P(ACHSBBAL,U,K)
 D FMT
 F ACHSX=1,2,3 S X=$P(ACHSSUM(K),U,ACHSX) D FMT
 S X=$P(ACHSBBAL,U,K)+$P(ACHSSUM(K),U,3)
 D FMT
 Q
 ;
FMT ;EP.
 I '+X,'+$P(X,".",2) S X=$J("",X3) W X S X=0 Q
 D COMMA^%DTC
 W X
 S X=0
 Q
 ;
SB2 ;EP - Column headers.
 W !!?4,"Register",?20,"Beginning",?32,"Increased",?45,"Decreased",?58,"Net",?71,"Ending",!?21,"Balance",?34,"Amount",?46,"Amount",?59,"Change",?71,"Balance",!,"----------------"
S21 ;EP - Underline column headers.
 W ?18,"------------",?32,"----------",?44,"----------",?56,"----------",?68,"-----------"
 Q
 ;
