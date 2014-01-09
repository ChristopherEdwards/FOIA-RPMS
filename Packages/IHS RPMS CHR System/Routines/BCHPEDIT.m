BCHPEDIT ; IHS/CMI/LAB - INPUT TX ON PATIENT FIELD OF CHR RECORD ; 
 ;;2.0;IHS RPMS CHR SYSTEM;;OCT 23, 2012;Build 27
 ;
 ;
PAT04 ;EP called from input transform on #.04 (Patient)
 Q:'$D(BCHDATE)
 I AUPNDOD,$P(BCHDATE,".")>AUPNDOD W !,"  <Patient died before the visit date>" K X Q
 I $P(BCHDATE,".",1)<AUPNDOB W !,"  <Patient born after the visit date>" K X Q
 Q
 ;
 ;
DOB1102 ;EP  called from input transform on #1102
 Q:'$D(BCHDATE)
 I $P(BCHDATE,".")<X W !,"  <DOB is after the visit date>" K X Q
 Q
