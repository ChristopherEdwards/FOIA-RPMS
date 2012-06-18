ASUJBTCN ; IHS/ITSC/LMH -SCREENMAN FOR DATA ENTRY ;  [ 07/17/2000  9:11 AM ]
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine will be used to process transactions already entred
 D:'$D(U) ^XBKVAR D:'$D(ASUK) ^ASUVAR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q
 I $G(ASUL(1,"AR","STA1"))]"" D
 .D STA^ASULARST(ASUL(1,"AR","STA1"))
 .W !!,"Process transactions for Station: ",ASUL(2,"STA","NM")," - Code: ",ASUL(2,"STA","CD"),!
 S ASUSB=1
 F ASUJ=4,5 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Master Add transactions" D
 .D PTRSET(ASUJ)
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) S ASUC("TRN")=0 D DCOUNT Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["A"  D
 ....D UPDT
 ...E  D
 ....S ASUC("TRN")=$G(ASUC("TRN"))-1
 .D DCOUNT
 F ASUJ=4,5 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Master Change transactions" D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) S ASUC("TRN")=0 D DCOUNT Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["C"  D
 ....D UPDT
 ...E  D
 ....S ASUC("TRN")=$G(ASUC("TRN"))-1
 .D DCOUNT
 F ASUJ=5 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Station User Level Change transactions" D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) S ASUC("TRN")=0 D DCOUNT Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["B"  D
 ....D UPDT
 ...E  D
 ....S ASUC("TRN")=$G(ASUC("TRN"))-1
 .D DCOUNT
 F ASUJ=1,2,3,6,7 D PTRSET(ASUJ)
 F ASUJ1=1,"2T",2,6,"3T",3,7 S ASUJ=$E(ASUJ1) W !,"Processing ",$P(^ASUT(ASUJ,0),U),$S($E(ASUJ1,2)="T":" Transfer ",1:"")," Debit transactions" D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) S ASUC("TRN")=0 D DCOUNT Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUJ1="2T",ASUL(11,"TRN","TYPE")'=8 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUJ1="3T",ASUL(11,"TRN","TYPE")'=9 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUT(ASUT,"SIGN")=1  D
 ....D UPDT
 ...E  D
 ....S ASUC("TRN")=$G(ASUC("TRN"))-1
 .D DCOUNT
 F ASUJ1=1,"2T",2,6,"3T","3I",3,7 S ASUJ=$E(ASUJ1) W !,"Processing ",$P(^ASUT(ASUJ,0),U),$S($E(ASUJ1,2)="T":" Transfer ",$E(ASUJ1,2)="I":" Post Posted ",1:"")," Credit transactions" D
 .I ASUJ1="3T"
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) S ASUC("TRN")=0 D DCOUNT Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUJ1="2T",ASUL(11,"TRN","TYPE")'=8 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUJ1="3T",ASUL(11,"TRN","TYPE")'=9 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUJ1="3I",ASUT(ASUT,"PST")'="I" S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUT(ASUT,"SIGN")=-1  D
 ....D UPDT
 ...E  D
 ....S ASUC("TRN")=$G(ASUC("TRN"))-1
 .D DCOUNT
 F ASUJ=5,4 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Master Delete transactions" D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) S ASUC("TRN")=0 D DCOUNT Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["D"  D
 ....D UPDT
 ...E  D
 ....S ASUC("TRN")=$G(ASUC("TRN"))-1
 .D DCOUNT
 W !!,$FN(ASUC("TOT"),",")," Total Records processed."
 K ASUC,ASUT,ASUJ,ASUMX,ASUMS,ASUMK,ASUV
 Q
DCOUNT ;
 W !?15," Count=",$J($FN(ASUC("TRN"),","),10) S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN")
 Q
UPDT ;EP ;Update masters
 S ASUJ("RTN")=ASUJ_$E($G(ASUT),1,2)
 I $G(ASUJ)']""!($G(ASUT)']"")!($G(ASUT("TRCD"))']"") S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 S ASUV("ASUT")=ASUT,ASUV("TRCD")=ASUT("TRCD")
 S ASUJ("FILE")=9002036_"."_ASUJ
 S ASUJ("GLOB")="^ASUT("_ASUJ_","
 S DIE="9002036."_ASUJ,DA=ASUHDA
 W !?5,ASUHDA," ",ASUT("TRCD"),$J($G(ASUT(ASUT,"IDX")),8),$J($G(ASUT(ASUT,"VOU")),12),!," Editing:"
 D CKFLD
 I $G(DDSSAVE)=1 D
 .S DDSSAVE=""
 .I ASUJ=1 D ^ASU1DUPD Q
 .I ASUJ=2 D ^ASU2RUPD Q
 .I ASUJ=3 D  Q
 ..I $E(ASUT("TRCD"),2)?1N D
 ...I ASUT("TRCD")=32 D ^ASU3IUPD Q
 ...I ASUT("TRCD")=33 D ^ASU3IUPD Q
 ...D TXFIS^ASU3IUPD
 ..E  D
 ...D RVIS^ASU3IUPD
 .I ASUJ=4 D ^ASU4XUPD Q
 .I ASUJ=5 D ^ASU5SUPD Q
 .I ASUJ=6 D ^ASU6JUPD Q
 .I ASUJ=7 D ^ASU7DUPD
 E  D
 .I $G(E)=0 Q
 .D MREJ K E,DDSERROR S DDSSAVE=0,DDSERROR=99
 I $G(ASUF("ERR"))>0 S DDSSAVE=0,DDSERROR=ASUF("ERR")
 E  S DDSSAVE=1
 I $G(DDSSAVE)=1 W " UDOK"
 E  W " NOUD" Q:DDSERROR=99  D MREJ
 S DDSSAVE=0 K E,Z,DDSERROR,ASUF("ERR")
 Q
MREJ ;
 S X=ASUJ("GLOB")_ASUHDA_")" M ^ASUTR(ASUJ,ASUHDA)=@(X)
 W !?5,"Reject/move to ^ASUTR ERR=",$G(DDSERROR)
 S DIK=ASUJ("GLOB"),DA=ASUHDA D ^DIK
 Q
TRRD ;EP ;Read transactions
 D READ^ASU0TRRD(.ASUHDA,.ASUJ) Q
 Q
PTRSET(F) ;
 N C,R
 S R=0 F C=1:1 S R=$O(^ASUT(F,R)) Q:R'?1N.N  D
 .D READ^ASU0TRRD(R,F)
 .D WRITE^ASU0TRWR(R,F)
 Q
CKFLD ;EP ;Validate fields for batch processing
 N E I ASUT(ASUT,"AR")=ASUL(1,"AR","AP"),ASUT(ASUT,"STA")=ASUL(2,"STA","CD") D
 .D @(ASUJ)
 .I $G(E)>0 D
 ..S DDSSAVE=0 W " EDBD"
 .E  D
 ..S DDSSAVE=1 W " EDOK"
 E  D
 .W " Transaction not for YOUR Area/Station - Not Edited" S DDSSAVE=0,E=0
 Q
1 ;Due in validation
 N F,M,P,R,X
 S M="E" F P="R^IDX","R^PON","R^QTY","R^VAL" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="R",P="R^SSA" D VLD(.P) Q:$G(E)>0
 S M="D",P="R^DTE" D VLD(.P)
 Q
2 ;Receipt validation
 N F,M,P,R,X
 S M="E" F P="R^VOU",$S(ASUT("TRCD")=22:"R",1:"")_"^PON","R^QTY","R^VAL","R^FPN" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="R",P="R^SSA" D VLD(.P) Q:$G(E)>0
 S M="F",P="R^SRC" D VLD(.P) Q:$G(E)>0
 S M="D" F P="^DTX","R^DTE" D VLD(.P) Q:$G(E)>0
 Q
3 ;Issue validation
 N F,M,P,R,X
 S M="E" F P="R^IDX","R^VOU","^PST","R^QTYR",$S($E(ASUT("TRCD"),2)=2:"R",1:"")_"^FPN","^RTP" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="R" F P="R^SST","R^USR" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="AN" F F="^CTG","^RQN" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="D",P="R^DTE" D VLD(.P)
 Q
4 ;Index validation
 N F,M,P,R,X
 S M="E" F P="R^IDX","A^NSN" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="F" F P="C^ACC","A^SSO","A^CAT" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="N",P="^BCD" D VLD(.P) Q:$G(E)>0
 S M="A",P="^AUI" D VLD(.P) Q:$G(E)>0
 S M="A",P="A^DESC" D VLD(.P) Q:$G(E)>0
 S M="D",P="R^DTE" D VLD(.P)
 Q
5 ;Station validation
 N F,M,P,R,X
 S M="E" F P="R^IDX","^VEN","^ORD","A^EOQ" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="F",P="A^SRC" D VLD(.P) Q:$G(E)>0
 S M="R",P="^SLC" D VLD(.P) Q:$G(E)>0
 I ASUT("TRCD")="5B" D  Q:$G(E)>0
 .S M="R" F P="R^SST","R^USR" D VLD(.P) Q:$G(E)>0
 .S M="N",P="R^ULQ" D VLD(.P)
 S M="A",P="^SUI" D VLD(.P) Q:$G(E)>0
 S M="N" F P="A^UCS","^LTM","^SPQ","A^RPQ" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="D",P="R^DTE" D VLD(.P)
 Q
6 ;Adjustment validation
 N F,M,P,R,X
 S M="E" F P="R^IDX","R^VOU" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="N" F P="^QTY","^VAL" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="D",P="R^DTE" D VLD(.P)
 Q
7 ;Direct Issue validation
 N F,M,P,R,X
 S M="E" F P="^PON","R^VOU" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="R" F P="R^SST","R^USR" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="F" F P="R^ACC","R^DSO","^SRC" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="N" F P="R^QTY","R^VAL" D VLD(.P) Q:$G(E)>0
 Q:$G(E)>0
 S M="D",P="R^DTE" D VLD(.P)
 Q
VLD(P) ;
 S F=$P(P,U,2),R=$P(P,U) I R="A" S R=$S($E(ASUT("TRCD"),2)="A":"R",1:"")
 S X=$G(ASUT(ASUT,$S(F="SSO":"SOBJ",F="DSO":"SOBJ",F="EOQ":"EOQ TYP",1:F)))
 I F="QTYR" S X=ASUT(ASUT,"QTY","REQ")
 I X']"" D  Q
 .I R="R" S E="1^"_F_" a required field is null" W " #",$P(E,U,2),! Q
 .W " *",F
 D VLDF(.M,.F,.X)
 Q
VLDF(M,F,X) ;Validate and save field
 N Z I $G(ASUSB)=1 W " ",F
 I ASUJ<7,ASUT("TRCD")'="4A",$G(ASUT(ASUT,"PT","IDX"))]"" S ASUMS("E#","IDX")=ASUT(ASUT,"PT","IDX") D ^ASUMXDIO
 I ASUJ<7,ASUJ'=4,ASUT("TRCD")'="5A",$G(ASUT(ASUT,"PT","STA"))]"",$G(ASUMS("E#","IDX"))]"" S ASUMS("E#","STA")=$G(ASUL("ST#")) D ^ASUMSTRD
 S DDSERROR=""
 I M="E" D
 .S Z="D "_F_"^ASUJVALF(.X,.DDSERROR)" X Z
 E  D
 .S Z="D EN^ASUJVALD(.X,.DDSERROR,.F,.M)" X Z
 S E=$G(DDSERROR)
 Q
