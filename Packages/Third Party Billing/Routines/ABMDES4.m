ABMDES4 ; IHS/ASDST/DMJ - ADA Form Dental Charge Summary ;   
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/EFG - V2.5 P8 - IM16385
 ;   Fix header wrapping; include misc services
 ; IHS/SD/SDR - v2.5 p10 - IM20395
 ;   Split out lines bundled by rev code
 ; IHS/SD/SDR - v2.5 p10 - IM21581
 ;   Added active insurer print to summary
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
 N ABM
 Q:'$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,0))&('$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,0)))
 D HD
 G XIT:$D(DUOUT)
 D WRT
 Q:$G(ABMQUIET)
 F  W ! Q:$Y+4>IOSL
 S DIR(0)="E"
 D ^DIR
 K DIR
 ;
XIT ;
 K DUOUT
 Q
 ;
HD ;
 ; SCREEN HEADER
 Q:$G(ABMQUIET)
 W $$EN^ABMVDF("IOF")
 W !?15,"***** ADA FORM DENTAL CHARGE SUMMARY *****"
 W !!,"Active Insurer: ",$P($G(^AUTNINS(ABMP("INS"),0)),U),!
 W !!?2,"Tooth",?9,"Surface",?20,"Description of Service",?52,"Date",?60,"ADA Code",?73,"Fee"
 W !,"-------------------------------------------------------------------------------"
 Q
 ;
WRT ;
 S (ABM("C"),ABM,ABM("TCHRG"))=0
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),33,ABM)) Q:'ABM  S ABM(0)=^(ABM,0) D  Q:$D(DUOUT)
 .S ABM("CHRG")=$P(ABM(0),U,8)
 .S ABM("CHRG")=ABM("CHRG")*$P($G(ABM(0)),U,9)
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")
 .Q:$G(ABMQUIET)
 .I $Y+5>IOSL D HD Q:$D(DUOUT)
 .W !
 .I $P(ABM(0),U,5) D
 ..S ABMOPS=$P(ABM(0),U,5)
 ..S ABMTMP=$P($G(^ADEOPS(ABMOPS,88)),U)
 ..S:ABMTMP["D" ABMTMP=$P($G(^ADEOPS(ABMOPS,0)),U,4)
 ..W ?2,ABMTMP
 .W ?9,$P(ABM(0),U,6)
 .W ?18,$E($P(^AUTTADA(+ABM(0),0),U,2),1,30)
 .W ?50,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .W ?62,$P(^AUTTADA(+ABM(0),0),U)
 .W ?70,$J($FN(ABM("CHRG"),",",2),8)
 ;
 S ABM=0
 I '$G(ABMQUIET) W !
 F  S ABM=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),43,ABM)) Q:'ABM  S ABM(0)=^(ABM,0)  D
 .S ABM("CHRG")=$P(ABM(0),U,4)
 .S ABM("CHRG")=ABM("CHRG")*$P($G(ABM(0)),U,3)
 .S ABM("TCHRG")=ABM("TCHRG")+ABM("CHRG")
 .Q:$G(ABMQUIET)
 .I $Y+5>IOSL D HD Q:$D(DUOUT)
 .W !
 .W ?18,$E($P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,3),1,30)  ;CSV-c
 .W ?50,$$HDT^ABMDUTL($P(ABM(0),U,7))
 .W ?62,$P($$CPT^ABMCVAPI(+ABM(0),ABMP("VDT")),U,2)  ;CSV-c
 .W ?70,$J($FN(ABM("CHRG"),",",2),8)
 ;
 ; Include RX charges
 I '$G(ABMQUIET) W !
 N ABMRV
 S DA=0
 F  S DA=$O(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA)) Q:'DA  D
 .F J=1:1:5 S ABM(J)=$P(^ABMDCLM(DUZ(2),ABMP("CDFN"),23,DA,0),U,J)
 .S ABMCNTR=+$O(ABMRV(+ABM(2),ABM(1),0))
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U)=ABM(2)  ; revenue code IEN
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,5)=$P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,5)+ABM(3)  ; cumulative units
 .S ABM(6)=ABM(3)*ABM(4)+ABM(5)  ; units * units cost + dispense fee
 .S ABM(6)=$J(ABM(6),1,2)
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,6)=$P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,6)+ABM(6)   ; cumulative charges
 .S $P(ABMRV(+ABM(2),ABM(1),ABMCNTR),U,9)=$P($G(^PSDRUG(ABM(1),2)),U,4)_" "_$P($G(^(0)),U)  ; NDC generic name
 ;
 S ABMRCD=0
 F  S ABMRCD=$O(ABMRV(ABMRCD)) Q:'+ABMRCD  D
 .S ABMED=0
 .F  S ABMED=$O(ABMRV(ABMRCD,ABMED)) Q:'+ABMED  D  Q:$D(DUOUT)
 ..S ABMCNTR=0
 ..F  S ABMCNTR=$O(ABMRV(ABMRCD,ABMED,ABMCNTR)) Q:ABMCNTR=""  D
 ...S ABMRXCHG=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,6)  ;Charge
 ...S ABM("TCHRG")=ABM("TCHRG")+ABMRXCHG
 ...Q:$G(ABMQUIET)
 ...S ABMRX=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,9)  ;NDC# name
 ...S ABMRXDT=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,10)  ;date/time
 ...S ABMRXQTY=$P(ABMRV(ABMRCD,ABMED,ABMCNTR),U,5)  ;quantity
 ...I $Y+5>IOSL D HD Q:$D(DUOUT)
 ...W !
 ...W ?2,$E(ABMRX,1,48)
 ...W ?50,$$HDT^ABMDUTL(ABMRXDT)
 ...W ?62,"QTY "_ABMRXQTY
 ...W ?70,$J($FN(ABMRXCHG,",",2),8)
 ;
 I '$G(ABMQUIET) D
 .W !?71,"========"
 .W !?10,"TOTAL CHARGE",?69,$J($FN(ABM("TCHRG"),",",2),9)
 I $D(ABMP("FLAT")) D
 .S ABM("TCHRG")=$P(ABMP("FLAT"),U)
 .Q:$G(ABMQUIET)
 .W !!?49,"Flat Rate Applied:",?69,$J($FN(ABM("TCHRG"),",",2),9)
 S:ABM("TCHRG") ABMP("EXP",ABMP("EXP"))=ABM("TCHRG")
 Q
