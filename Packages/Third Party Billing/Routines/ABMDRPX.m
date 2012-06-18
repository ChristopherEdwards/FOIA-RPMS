ABMDRPX ; IHS/ASDST/DMJ - CPT Summary Report ; 
 ;;2.6;IHS Third Party Billing;**1**;NOV 12, 2009
 ;Original;TMD;10/20/95 3:37 PM
 ;
 ; IHS/SD/SDR - 10/21/02 - V2.5 P2 - UXX-1002-170028
 ;      Modified so report would print data second time if same session
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ; IHS/SD/SDR - abm*2.6*1 - HEAT4716 - Include NDC on RXs
 ;
 K ABM,ABMY,^TMP("ABM-PX","CL")
 K ^TMP($J,"ABM-PX","CL")
 ;
SEL ;
 ; Ask the user what category they would like to list procedures
 W !!,"----- PROCEDURE CATEGORIES -----",!
 K DIR
 S DIR(0)="SO^1:MEDICAL;2:SURGICAL;3:RADIOLOGY;4:LABORATORY;5:ANESTHESIA;6:DENTAL;7:ROOM & BOARD;8:MISCELLANEOUS (HCPCS);9:PHARMACY;10:ALL"
 S DIR("A")="Select Desired CATEGORY"
 D ^DIR
 G XIT:$D(DIROUT)!$D(DIRUT)
 S ABM("CAT")=Y(0)
 S ABM=+Y
 ;ABM("SUB") ; multiple in bill file         
 S ABM("SUB")=$S(ABM=1:27,ABM=2:21,ABM=3:35,ABM=4:37,ABM=5:39,ABM=6:33,ABM=7:25,ABM=8:43,ABM=9:23,1:"")
 I ABM("SUB")="" S ABM("ALL")=1
 ;
RSEL ;
 ; Select exclusion parameters
 D ^ABMDRSEL
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
HD ;
 S ABM("HDCAT")=$S(ABM=1:"MEDICAL ",ABM=2:"SURGICAL ",ABM=3:"RADIOLOGY ",ABM=4:"LABORATORY ",ABM=5:"ANESTHESIA ",ABM=6:"DENTAL ",ABM=7:"ROOM & BOARD ",ABM=8:"MISCELLANEOUS (HCPCS) ",ABM=9:"PHARMACY ",1:"")
 S ABM("HD",0)="BILLED "_ABM("HDCAT")_"PROCEDURES"
 D ^ABMDRHD                        ; Write report header
 S ABMQ("RC")="COMPUTE^ABMDRPX"    ; Compute routine
 S ABMQ("RP")="PRINT^ABMDRPX1"     ; Print routine
 S ABMQ("RX")="POUT^ABMDRUTL"      ; Namespace
 S ABMQ("NS")="ABM"
 D ^ABMDRDBQ                       ; Double queue rtn - uses ABMQ array
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 ; Loop through bill file
 S ABM("SUBR")="ABM-PX"
 K ^TMP(ABM("SUBR"),$J)
 S ABMP("RTN")="ABMDRPX"
 D LOOP^ABMDRUTL
 Q
 ;
DATA ;
 ; for each bill. . . gather data (called from ABMDRUTL)
 S ABMP("HIT")=0
 D ^ABMDRCHK   ; Check bill parameters
 Q:'ABMP("HIT")
 S ABM("CL")=+^ABMDBILL(DUZ(2),ABM,0)
 Q:$D(^TMP($J,"ABM-PX","CL",ABM("CL")))
 S ^TMP($J,"ABM-PX","CL",ABM("CL"))=""
 I +ABM("SUB") D ONE
 I $G(ABM("ALL")) D
 .F ABM("SUB")=21,23,25,27,33,35,37,39,43 D
 ..I $O(^ABMDBILL(DUZ(2),ABM,ABM("SUB"),0)) D ONE
 .I $P($G(^ABMDBILL(DUZ(2),ABM,8)),U,10),'$D(ABMY("PX")) D
 ..S ABM("FEE")=$P(^ABMDBILL(DUZ(2),ABM,8),U,10)
 ..S ABM("CD")=450
 ..S ABM("NM")=$P(^AUTTREVN(ABM("CD"),0),U,2)
 ..D TL
 .I $P($G(^ABMDBILL(DUZ(2),ABM,9)),U,8),'$D(ABMY("PX")) D
 ..S ABM("FEE")=$P(^ABMDBILL(DUZ(2),ABM,9),U,8)
 ..S ABM("CD")=$P(^ABMDBILL(DUZ(2),ABM,9),U,7)
 ..S ABM("NM")=$P(^AUTTREVN(ABM("CD"),0),U,2)
 ..D TL
 Q
 ;
ONE ;
 ; ONE CATEGORY
 I $D(ABMY("PX")),"23^25^33^43"[ABM("SUB") Q
 S ABM("PX")=0
 F  S ABM("PX")=$O(^ABMDBILL(DUZ(2),ABM,ABM("SUB"),ABM("PX"))) Q:'ABM("PX")  D
 .Q:'$D(^ABMDBILL(DUZ(2),ABM,ABM("SUB"),ABM("PX"),0))
 .S ABM(0)=^ABMDBILL(DUZ(2),ABM,ABM("SUB"),ABM("PX"),0)
 .;S ABM("CD")=$S(ABM("SUB")=23:"ZZZZZ",ABM("SUB")=25:+ABM(0),ABM("SUB")=33:$P(^AUTTADA(+ABM(0),0),U),1:$P($$CPT^ABMCVAPI(+ABM(0),ABM("D")),U,2))  ;CSV-c  ;abm*2.6*1 HEAT4716
 .S ABM("CD")=$S(ABM("SUB")=23:$P($G(ABM(0)),U,24),ABM("SUB")=25:+ABM(0),ABM("SUB")=33:$P(^AUTTADA(+ABM(0),0),U),1:$P($$CPT^ABMCVAPI(+ABM(0),ABM("D")),U,2))  ;CSV-c  ;abm*2.6*1 HEAT4716
 .I +ABM("CD")<+$G(ABMY("PX",1)) Q
 .I $D(ABMY("PX",2)),+ABM("CD")>+ABMY("PX",2) Q
 .;S ABM("NM")=$S(ABM("SUB")=23:"PRESCRIPTIONS",ABM("SUB")=25:$E($P(^AUTTREVN(+ABM(0),0),U,2),1,40),ABM("SUB")=33:$E($P(^AUTTADA(+ABM(0),0),U,2),1,40),1:$P($$CPT^ABMCVAPI(+ABM(0),ABM("D")),U,3))  ;CSV-c  ;abm*2.6*1 HEAT4716
 .;start new code abm*2.6*1 HEAT4716
 .S ABM("NM")=$S(ABM("SUB")=23&(ABM("CD")'=""):$E($P(^PSDRUG(+ABM(0),0),U),1,30),ABM("SUB")=25:$E($P(^AUTTREVN(+ABM(0),0),U,2),1,40),ABM("SUB")=33:$E($P(^AUTTADA(+ABM(0),0),U,2),1,40),1:$P($$CPT^ABMCVAPI(+ABM(0),ABM("D")),U,3))  ;CSV-c
 .I ABM("SUB")=23&(ABM("CD")="") S ABM("NM")="PRESCRIPTIONS"
 .;end new code HEAT4716
 .I ABM("SUB")=21 S ABM("FEE")=$P(ABM(0),U,7)
 .I ABM("SUB")=23 S ABM("FEE")=$P(ABM(0),U,3)*$P(ABM(0),U,4)+$P(ABM(0),U,5)
 .I ABM("SUB")=25 S ABM("FEE")=$P(ABM(0),U,2)*$P(ABM(0),U,3)
 .I ABM("SUB")=27 S ABM("FEE")=$P(ABM(0),U,3)*$P(ABM(0),U,4)
 .I ABM("SUB")=33 S ABM("FEE")=$P(ABM(0),U,8)
 .I ABM("SUB")=35!(ABM("SUB")=37)!(ABM("SUB")=43) S ABM("FEE")=$P(ABM(0),U,3)*$P(ABM(0),U,4)
 .I ABM("SUB")=39 D
 ..S ABM("FEE")=$P(ABM(0),U,3)+$P(ABM(0),U,4)
 ..S ABM("CD")=ABM("CD")_".1"
 ..Q:'$G(ABM("ALL"))
 ..S ABM("NM")=ABM("NM")_" (ANEST)"
 .I ABM("CD")=""&(ABM("SUB")=23) S ABM("CD")="NONDC-"  ;abm*2.6*1 HEAT4716
 .D TL
 Q
 ;
TL ;
 ;SET ENTRY IN TMP
 S $P(^TMP("ABM-PX",$J),U)=$P($G(^TMP("ABM-PX",$J)),U)+1
 S $P(^TMP("ABM-PX",$J),U,2)=$P(^TMP("ABM-PX",$J),U,2)+ABM("FEE")
 S $P(^TMP("ABM-PX",$J,ABM("CD")),U)=$P($G(^TMP("ABM-PX",$J,ABM("CD"))),U)+1,$P(^(ABM("CD")),U,2)=$P(^(ABM("CD")),U,2)+ABM("FEE"),$P(^(ABM("CD")),U,3)=ABM("NM")
 Q
 ;
XIT ;
 K ABM,ABMY,ABMP
 Q
