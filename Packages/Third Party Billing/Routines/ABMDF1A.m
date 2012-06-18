ABMDF1A ; IHS/ASDST/DMJ - Set UB82 Print Array - cont ;
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD;
 ;
 ;IHS/DSD/DMJ - 5/14/1999 - NOIS HQW-0599-100027 Patch 2
 ;          Y2K IV&V issues, all $$HDT^ABMDUTL changed to $$HDTO^ABMDUTL
 ;                    in lines: ADMIT,FRM,TO,FROM,THRU
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
BNODES S ABM("B5")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),5)),ABM("B6")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6)),ABM("B7")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),7)),ABM("B8")=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),8))
ACCDHR S $P(ABMF(8),U,8)=$P(ABM("B8"),U,4)
 I $P(ABMP("B0"),U,7)'=111 G FROM
 ;
 ; Hosp Info
DX ;
 I $P(ABM("B5"),U,9)]"",$D(^ICD9($P(ABM("B5"),U,9),0)) S $P(ABMF($S($P($G(^AUTNINS(ABMP("INS"),2)),U)="R":59,1:4)),U,6)=$P($$DX^ABMCVAPI($P(ABM("B5"),U,9),ABMP("VDT")),U,2)  ;CSV-c
ADMIT I $P(ABM("B6"),U,1)]"" S $P(ABMF(8),U,4)=$$HDTO^ABMDUTL($P(ABM("B6"),U))
HR S $P(ABMF(8),U,5)=$P(ABM("B6"),U,2)
TYPE I $P(ABM("B5"),U,1)]"" S $P(ABMF(8),U,6)=$P(^ABMDCODE($P(ABM("B5"),U,1),0),U)
SRC I $P(ABM("B5"),U,2)]"" S $P(ABMF(8),U,7)=$P(^ABMDCODE($P(ABM("B5"),U,2),0),U)
DISCHR S $P(ABMF(8),U,9)=$P(ABM("B6"),U,4)
STAT I $P(ABM("B5"),U,3)]"" S $P(ABMF(8),U,10)=$P(^ABMDCODE($P(ABM("B5"),U,3),0),U)
PSRO I $P(ABM("B5"),U,4) S $P(ABMF(57),U)=$P(^ABMDCODE($P(ABM("B5"),U,4),0),U)
FRM S $P(ABMF(57),U,2)=$$HDTO^ABMDUTL($P(ABM("B5"),U,5))
TO S $P(ABMF(57),U,3)=$$HDTO^ABMDUTL($P(ABM("B5"),U,6))
GRC S $P(ABMF(57),U,4)=$P(ABM("B5"),U,7)
AUTH S $P(ABMF(57),U,5)=$P(ABM("B5"),U,8)
 ;
DAYS ; Service Periods
CVD I $P(ABM("B7"),U,3)]"" S $P(ABMF(8),U,13)=$P(ABM("B7"),U,3)
NONCVD I $P(ABM("B6"),U,6)]"" S $P(ABMF(8),U,14)=$P(ABM("B6"),U,6)
CID I $P(ABM("B6"),U,7)]"" S $P(ABMF(8),U,15)=$P(ABM("B6"),U,7)
LRD I $P(ABM("B6"),U,8)]"" S $P(ABMF(8),U,16)=$P(ABM("B6"),U,8)
FROM I $P(ABM("B7"),U)]"" S $P(ABMF(8),U,11)=$$HDTO^ABMDUTL($P(ABM("B7"),U))
THRU I $P(ABM("B7"),U,2)]"" S $P(ABMF(8),U,12)=$$HDTO^ABMDUTL($P(ABM("B7"),U,2))
BLOOD I $P(ABM("B7"),U,6)]"" S $P(ABMF(12),U,7)=$P(ABM("B7"),U,6)
 I $P(ABM("B7"),U,7)]"" S $P(ABMF(12),U,8)=$P(ABM("B7"),U,7)
 I $P(ABM("B7"),U,8)]"" S $P(ABMF(12),U,9)=$P(ABM("B7"),U,8)
 I $P(ABM("B7"),U,9)]"" S $P(ABMF(12),U,10)=$P(ABM("B7"),U,9)
 ;
 K ABM,ABMX,ABMV
 G ^ABMDF1B
