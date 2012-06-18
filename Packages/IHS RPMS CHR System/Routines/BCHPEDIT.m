BCHPEDIT ; IHS/TUCSON/LAB - INPUT TX ON PATIENT FIELD OF CHR RECORD ;  [ 10/28/96  2:05 PM ]
 ;;1.0;IHS RPMS CHR SYSTEM;;OCT 28, 1996
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
