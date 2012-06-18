ASUBTCH ; IHS/ITSC/LMH -SCREENMAN FOR DATA ENTRY ; 
 ;;4.2T2;Supply Accounting Mgmt. System;;JUN 30, 2000
 ;This routine will be used to process transactions already entred
 D:'$D(U) ^XBKVAR D:'$D(ASUK) ^ASUVAR I $D(DTOUT)!($D(DUOUT))!($D(DIROUT)) Q
 I $G(ASUL(1,"AR","STA1"))]"" D
 .D STA^ASULARST(ASUL(1,"AR","STA1"))
 .W !!,"Process transactions for Station: ",ASUL(2,"STA","NM")," - Code: ",ASUL(2,"STA","CD"),!
 S ASUSB=1
 F ASUJ=4,5 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Master Add transactions" D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)  D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) W !,"None entered" Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["A"  D UPDT
 ...E  S ASUC("TRN")=$G(ASUC("TRN"))-1
 .W " Count=",$FN(ASUC("TRN"),",") S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN")-1 D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)
 F ASUJ=4,5 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Master Change transactions" D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)  D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) W !,"None entered" Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["C"  D UPDT
 ...E  S ASUC("TRN")=$G(ASUC("TRN"))-1
 .W " Count=",$FN(ASUC("TRN"),",") S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN") D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)
 F ASUJ=5 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Station User Level Change transactions" D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)  D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) W !,"None entered" Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["B"  D UPDT
 ...E  S ASUC("TRN")=$G(ASUC("TRN"))-1
 .W " Count=",$FN(ASUC("TRN"),",") S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN") D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)
 F ASUJ1=1,"2T",2,6,"3T",3,7 S ASUJ=$E(ASUJ1) W !,"Processing ",$P(^ASUT(ASUJ,0),U),$S($E(ASUJ1,2)="T":" Transfer ",1:"")," Debit transactions" D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)  D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) W !,"None entered" Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUJ1="2T",ASUL(11,"TRN","TYPE")'=8 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUJ1="3T",ASUL(11,"TRN","TYPE")'=9 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUT(ASUT,"SIGN")=1  D UPDT
 ...E  S ASUC("TRN")=$G(ASUC("TRN"))-1
 .W " Count=",$FN(ASUC("TRN"),",") S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN") D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)
 F ASUJ1=1,"2T",2,6,"3T","3I",3,7 S ASUJ=$E(ASUJ1) W !,"Processing ",$P(^ASUT(ASUJ,0),U),$S($E(ASUJ1,2)="T":" Transfer ",$E(ASUJ1,2)="I":" Post Posted ",1:"")," Credit transactions" D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)  D
 .I ASUJ1="3T"
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) W !,"None entered" Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUJ1="2T",ASUL(11,"TRN","TYPE")'=8 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUJ1="3T",ASUL(11,"TRN","TYPE")'=9 S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUJ1="3I",ASUT(ASUT,"PST")'="I" S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 ...I ASUT(ASUT,"SIGN")=-1  D UPDT
 ...E  S ASUC("TRN")=$G(ASUC("TRN"))-1
 .W " Count=",$FN(ASUC("TRN"),",") S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN") D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)
 F ASUJ=5,4 W !,"Processing ",$P(^ASUT(ASUJ,0),U)," Master Delete transactions" D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)  D
 .S ASUV("E#")=0 I '$D(^ASUT(ASUJ,"C","Y")) W !,"None entered" Q
 .F ASUC("TRN")=0:1 S ASUV("E#")=$O(^ASUT(ASUJ,"C","Y",ASUV("E#"))) Q:ASUV("E#")']""  D
 ..S ASUT=0,ASUHDA=ASUV("E#") D TRRD Q:$G(ASUT)']""  D
 ...I ASUT("TRCD")["D"  D UPDT
 ...E  S ASUC("TRN")=$G(ASUC("TRN"))-1
 .W " Count=",$FN(ASUC("TRN"),",") S ASUC("TOT")=$G(ASUC("TOT"))+ASUC("TRN") D PAZ^ASUURHDR Q:$D(DTOUT)  Q:$D(DUOUT)
 W !!,$FN(ASUC("TOT"),",")," Total Records processed." D PAZ^ASUURHDR
 K ASUC,ASUT,ASUJ,ASUMX,ASUMS,ASUMK,ASUV
 Q
UPDT ;EP ;Update masters
 S ASUJ("RTN")=ASUJ_$E($G(ASUT),1,2)
 I $G(ASUJ)']""!($G(ASUT)']"")!($G(ASUT("TRCD"))']"") S ASUC("TRN")=$G(ASUC("TRN"))-1 Q
 S ASUV("ASUT")=ASUT,ASUV("TRCD")=ASUT("TRCD")
 S ASUJ("FILE")=9002036_"."_ASUJ
 S ASUJ("GLOB")="^ASUT("_ASUJ_","
 S ASUJ("TMPL")="[ASUJ"_ASUJ_$E(ASUT,1,3)_"]"
 S DIE="9002036."_ASUJ,DA=ASUHDA,DDSFILE=ASUJ("FILE"),DDSPARM="CES",DR=ASUJ("TMPL")
 D ^DDS
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
 .S DIK=ASUJ("GLOB"),DA=ASUHDA D ^DIK
 .S DDSSAVE=0
 Q
TRRD ;EP ;Read transactions
 D READ^ASU0TRRD(.ASUHDA,.ASUJ) Q
 Q
CKFLD ;EP ;Validate fields for batch processing
 D @(ASUJ)
 Q
1 ;Due in validation
 N F,M,X S M="E" F F="IDX","PON","QTY","VAL" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="R" S F="SSA" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="D" S F="DTE" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
2 ;Receipt validation
 N F,M,X S M="E" F F="VOU","PON","QTY","VAL","FPN" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="R" S F="SSA" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="F" S F="SRC" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="D" F F="DTX","DTE" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
3 ;Issue validation
 N F,M,X S M="E" F F="IDX","VOU","FPN","PST","QTYR","RTP" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="R" F F="SST","USR" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 ;S M="F",F="SRC",X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 ;S M="N" S F="VAL" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="AN" F F="CTG","RQN" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="D",F="DTE",X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
4 ;Index validation
 N F,M,X S M="E" F F="NSN" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="F" F F="ACC","SSO","CAT" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="N" S F="BCD" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="A" S F="AUI" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="AN" F F="DESC","CTG" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="D" S F="DTE" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
5 ;Station validation
 N F,M,X S M="E" F F="IDX","STA","VEN","ORD","EOQ" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="R" F F="SST","USR" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="A" S F="SUI" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="N" F F="UCS","LTM","SPQ","RPQ","ULQ" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="D" S F="DTE" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
6 ;Adjustment validation
 N F,M,X S M="E" F F="IDX","VOU" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="N" F F="QTY","VAL" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="D" S F="DTE" S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
7 ;Direct Issue validation
 N F,M,X S M="E" F F="PON","VOU" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="R" F F="SST","USR" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="F" F F="ACC","DSO","SRC" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 S M="N" F F="QTY","VAL" D
 .S X=$G(ASUT(ASUT,F)) Q:X']""  D VAL(.M,.F,.X)
 Q
VAL(M,F,X) ;Validate and save field
 N Z
 I ASUJ<7,ASUT("TRCD")'="4A",$G(ASUT(ASUT,"PT","IDX"))]"" S ASUMS("E#","IDX")=ASUT(ASUT,"PT","IDX") D ^ASUMXDIO
 I ASUJ<7,ASUJ'=4,ASUT("TRCD")'="5A",$G(ASUT(ASUT,"PT","STA"))]"",$G(ASUMS("E#","IDX"))]"" S ASUMS("E#","STA")=$G(ASUL("ST#")) D ^ASUMSTRD
 I M="E" S Z="D "_F_"^ASUJVALF(.X,.DDSERROR)" X Z Q
 S Z="D EN^ASUJVALD(.X,.DDSERROR,.F,.M)" X Z Q
 Q
