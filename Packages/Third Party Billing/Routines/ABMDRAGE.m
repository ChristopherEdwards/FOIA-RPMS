ABMDRAGE ; IHS/ASDST/DMJ - A/R Aged Report ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 K ABM,ABMY,ABMQ
 S ABM(132)="",ABM("OVER-DUE")=3
 D ^ABMDRSEL Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
HD S ABM("HD",0)="AGED ACCOUNTS RECEIVABLE SUMMARY" D ^ABMDRHD
 S ABMQ("RC")="COMPUTE^ABMDRAGE",ABMQ("RP")="PRINT^ABMDRAG1",ABMQ("RX")="POUT^ABMDRUTL",ABMQ("NS")="ABM"
 ;S ABM("$J")=DUZ_"-"_$P($H,",",1)_"-"_$P($H,",",2)
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 S ABM("SUBR")="ABM-AG" K ^TMP(ABM("SUBR"),$J)
 S ABMP("RTN")="ABMDRAGE" D LOOP^ABMDRUTL
 Q
 ;
DATA Q:'$D(^ABMDBILL(DUZ(2),ABM,0))  Q:$P(^(0),U,4)="C"
 S ABMP("HIT")=0 D ^ABMDRCHK Q:'ABMP("HIT")
 S ABM("INS")=$P(^AUTNINS(ABM("I"),0),U)
 S X2=$P($G(^ABMDBILL(DUZ(2),ABM,1)),U,7) Q:X2=""  S ABM("B")=$P(^ABMDBILL(DUZ(2),ABM,2),U),X2=$P(^ABMDTXST(DUZ(2),X2,0),U),X1=DT D ^%DTC S ABM("AG")=$S(X<31:3,X<61:4,X<91:5,X<121:6,1:7)
 S (ABM("J"),ABM("PD"))=0 F  S ABM("J")=$O(^ABMDBILL(DUZ(2),ABM,3,ABM("J"))) Q:'ABM("J")  D
 .S ABM("PD")=$P(^ABMDBILL(DUZ(2),ABM,3,ABM("J"),0),U,2)+ABM("PD")
 S X=ABM("INS"),ABM("BAL")=ABM("B")-ABM("PD"),ABM("CR")=0
TL S:'$D(^TMP("ABM-AG",$J)) ^TMP("ABM-AG",$J)=0_U_0_U_0_U_0_U_0_U_0_U_0_U_0_U_0
 S $P(^TMP("ABM-AG",$J),U)=$P(^($J),U)+1,$P(^($J),U,2)=$P(^($J),U,2)+ABM("CR"),$P(^($J),U,8)=$P(^($J),U,8)+ABM("BAL")
 S $P(^TMP("ABM-AG",$J),U,ABM("AG"))=$P(^($J),U,ABM("AG"))+ABM("BAL"),$P(^($J),U,9)=$P(^($J),U,9)+ABM("BAL")-ABM("CR")
 S:'$D(^TMP("ABM-AG",$J,X)) ^TMP("ABM-AG",$J,X)=0_U_0_U_0_U_0_U_0_U_0_U_0_U_0_U_0
 S $P(^TMP("ABM-AG",$J,X),U)=$P(^(X),U)+1,$P(^(X),U,2)=$P(^(X),U,2)+ABM("CR"),$P(^(X),U,8)=$P(^(X),U,8)+ABM("BAL"),$P(^(X),U,ABM("AG"))=$P(^(X),U,ABM("AG"))+ABM("BAL"),$P(^(X),U,9)=$P(^(X),U,9)+ABM("BAL")-ABM("CR")
 Q
