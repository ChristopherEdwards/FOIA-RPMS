ABMDRAPP ; IHS/ASDST/DMJ - DISPLAY APPROVED BILLS ;  
 ;;2.6;IHS 3P BILLING SYSTEM;**8**;NOV 12, 2009
 ;Original;TMD;07/11/95 3:42 PM
 ;
 ; IHS/DSD/LSL - 05/21/98 -  NOIS QDD-0598-130116
 ;              Not doing dates right
 ;
 ; IHS/ASDS/SDH - 03/08/01 - V2.4 Patch 9 - NOIS XJG-0201-160063
 ;     Modified to allow the exclusion parameter of Provider to work
 ;     properly.
 ;
 ; *********************************************************************
 ;
 K ABM,ABMY,DIR
 S DIR(0)="SO^1:Summarized Report by EXPORT MODE;2:Summarized Report by INSURER;3:Listing of UNPRINTED BILLS"
 S DIR("A")="Select the desired REPORT TYPE"
 S DIR("B")=1
 D ^DIR
 Q:$D(DIRUT)!$D(DIROUT)
 S ABMP("VAR")=Y
 S ABM("NODX")=""
 S:$D(DUZ) ABM("APPR")=DUZ
 D ^ABMDRSEL
 G XIT:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 S ABM("HD",0)="BILLS AWAITING EXPORT"
 D ^ABMDRHD
 S ABMQ("RX")="POUT^ABMDRUTL"
 S ABMQ("NS")="ABM"
 I ABMP("VAR")>2 S ABMQ("RC")="COMPUTE^ABMDRAPP",ABMQ("RP")="PRINT^ABMDRAPP"
 E  S ABMQ("RC")="COMPUTE^ABMDRAP1",ABMQ("RP")="PRINT^ABMDRAP1"
 D ^ABMDRDBQ
 Q
 ;
COMPUTE ;EP - Entry Point for Setting up Data
 Q
 ;
PRINT ;EP for printing data
 U IO
 S ABM("PG")=0
 D HDB
 S ABMP("BDFN")="",U="^"
 F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AC","A",ABMP("BDFN"))) Q:'ABMP("BDFN")  D  Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 . Q:'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),0))
 . Q:"RA"'[$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,4)
 . I $Y>(IOSL-5) D HD Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 . I $D(ABMY("LOC")),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,3)'=ABMY("LOC") Q
 . I $D(ABMY("PRV")),'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"B",ABMY("PRV"))) Q
 . I $D(ABMY("DX")),'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,ABMY("DX"))) Q
 . I $D(ABMY("TYP")),ABMY("TYP")'[$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,2) Q
 . I $D(ABMY("INS")),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)'=ABMY("INS") Q
 . I $D(ABMY("APPR")),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,4)'=ABMY("APPR") Q
 . I $G(ABMY("DT"))="A",$P($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,5),".")<ABMY("DT",1)!($P($P(^(1),U,5),".")>ABMY("DT",2)) Q
 . I $D(ABMY("DT"))="V",$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,7)=111,$P($P(^(6),U),".")<ABMY("DT",1)!($P($P(^(6),U),".")>ABMY("DT",2)) Q
 . I $D(ABMY("DT"))="V",$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,7)'=111,$P($P(^(7),U),".")<ABMY("DT",1)!($P($P(^(7),U),".")>ABMY("DT",2)) Q
 . I $D(ABMY("DT"))="X",$P($P(^ABMDTXST(DUZ(2),$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,7),0),U),".")<ABMY("DT",1)!($P($P(^(0),U),".")>ABMY("DT",2)) Q
 . W !,$J("",8-$L($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U))\2)_$P(^(0),U),?10,$E($P(^DPT($P(^(0),U,5),0),U),1,29)
 . W ?41,$P(^ABMDEXP($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,6),0),U)
 .; W ?53,$E($P(^AUTNINS($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8),0),U),1,27)  ;abm*2.6*8 NOHEAT
 . W:+$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,8)'=0 ?53,$E($P(^AUTNINS($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8),0),U),1,27)  ;abm*2.6*8 NOHEAT
 . Q
 ;
XIT ;
 D POUT^ABMDRUTL
 Q
 ;
HD ;
 D PAZ^ABMDRUTL
 Q:$D(DTOUT)!$D(DUOUT)!$D(DIROUT)
 ;
HDB ;
 S ABM("PG")=ABM("PG")+1
 S ABM("I")=""
 D WHD^ABMDRHD
 W !,"  Bill",?42,"Export"
 W !," Number",?17,"Patient",?43,"Mode",?58,"Billing Source"
 W !,"-------------------------------------------------------------------------------"
 Q
