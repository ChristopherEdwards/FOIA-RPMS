ABMDE2X5 ; IHS/ASDST/DMJ - PAGE 2 - Primary Insurer Check-CONT ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; IHS/SD/SDR - v2.5 p10 - IM21846
 ;   Fix for <UNDEF>EXP+1^ABMDE2X5
 ;
 ; *********************************************************************
 ;
EXP ;EP - Entry Point for setting billing parms
 S ABM("H")=$S($P($G(^ABMDPARM(DUZ(2),1,2)),U,9):$P(^(2),U,9),1:2)
 I '$D(ABMP("EXP")) D EXP^ABMDEVAR
 S $P(ABMV("X6"),U)=ABMP("EXP")
 I '$D(ABMP("FEE")) S ABMP("FEE")=$S($P(^ABMDPARM(DUZ(2),1,0),U,9)]"":$P(^(0),U,9),1:1)
 S ABMP("PX")=$S($P(ABMV("X6"),U,2)]"":$P(ABMV("X6"),U,2),1:"C"),$P(ABMV("X6"),U,2)=ABMP("PX")
 D PAGE^ABMDEVAR
 Q
 ;
COV ;EP - Entry Point for setting Coverage Types
 Q:'$G(ABM("XIEN"))
 S ABMX=0
 S ABMP("COV")=""
 F  S ABMX=$O(@(ABMP("GL")_"13,"_ABM("XIEN")_",11,"_ABMX_")")) Q:'ABMX  S ABMP("COV")=$S(ABMP("COV")]"":ABMP("COV")_";"_ABMX,1:ABMX)
 Q
