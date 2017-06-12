ACHSADTR ;IHS/OIT/FCJ - Display all transactions for a document [ 03/20/97  5:38 PM ]
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**26**;JUN 11, 2001;Build 37
 ;Orig rtn frm Dina Hanson
 ;
 S ACHS("LN")=0
A ;
 D ^ACHSUD
 G:('$D(ACHSDIEN))!($D(DFOUT))!($D(DUOUT)) EXT
 I '$D(^ACHSF(DUZ(2),"D",ACHSDIEN,0)) U 0 W !!,*7,"No data on file for Doc. #" H 2 G A
 D HEAD
 S ACHS("R")=^ACHSF(DUZ(2),"D",ACHSDIEN,0)
 S ACHS("FY")=$P(ACHS("R"),"^",14),ACHS("DOC")=$P(ACHS("R"),"^",1)
 S ACHS("PAT")=$P(ACHS("R"),"^",22) I ACHS("PAT")'="" S ACHS("PAT")=$P($G(^DPT(ACHS("PAT"),0)),"^",1)
 S ACHS("TY")=$P(ACHS("R"),"^",4),ACHS("TY")=$S(ACHS("TY")=1:43,ACHS("TY")=2:57,ACHS("TY")=3:64)
 S ACHS("V")=$P(ACHS("R"),"^",8),ACHS("V")=$P(^AUTTVNDR(ACHS("V"),0),"^",1)
 U 0 W !,ACHS("FY")_"-"_ACHS("DOC"),?10,ACHS("TY"),?16,ACHS("PAT"),?50,$E(ACHS("V"),1,30),!,"TRANSACTIONS:"
B ;
 S ACHS=0
 F  S ACHS=$O(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHS)) G A:+ACHS=0 D
 .Q:'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHS,0))
 .S ACHS("REC")=^ACHSF(DUZ(2),"D",ACHSDIEN,"T",ACHS,0)
 .S Y=$P(ACHS("REC"),"^",1) X ^DD("DD") S ACHS("DT")=Y
 .S Y=$P(ACHS("REC"),"^",2) S ACHS("TY")=$S(Y="I":"INI",Y="S":"SUP",Y="P":"PAY",Y="ZA":"P ADJ",Y="C":"CAN",1:"")
 .S ACHS("AMT")=$P(ACHS("REC"),"^",4)
 .I ACHS("LN")>20 D PGFULL G A:(Y=0)!(Y="") S ACHS("LN")=1
 .S X=ACHS("AMT"),X2=2 D COMMA^%DTC S ACHS("AMT")=X
 .U 0 W !,?13,ACHS("DT"),?27,ACHS("TY"),?36,$J(ACHS("AMT"),12)
 .S ACHS("LN")=ACHS("LN")+1
 ;
EXT ;
 K ACHS
 Q
HEAD ;
 D ^XBCLS
 W !!,"DOC. #   TYPE   PATIENT",?60,"VENDOR"
 W !,"TRANSACTION   DATE        TYPE          AMT"
 W ! F I=1:1:80 W "-"
 S ACHS("LN")=4
 Q
PGFULL ;
 S DIR(0)="E" D ^DIR
 Q
