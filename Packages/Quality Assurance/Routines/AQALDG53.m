AQALDG53 ; IHS/ORDC/LJF - LINK EDITED ADT EVENTS ;
 ;;1;QI LINKAGES-RPMS;;AUG 15, 1994
 ;
 ;This routine handles edits to ADT events and decides what, if any
 ;action to perform on the QI Occurrence file.
 ;
INIT ; >> find ind for event type
 K AQALPAR
 I DGPMT=1 F I=2,12,22 D PARAM
 I DGPMT=2 F I=32,72 D PARAM
 I DGPMT=3 F I=42,52,62 D PARAM
 ;
 ; >> find all auto occ from ADT for pt and visit and event type
 S AQALN=0
 F  S AQALN=$O(^AQAOC("AE",DFN,AQALVST,AQALN)) Q:AQALN=""  D
 .Q:'$D(^AQAOC(AQALN,0))  Q:$P(^(0),U,11)=""  ;not automatic entry
 .I DGPMT=2 Q:+DGPMP'=$P(^AQAOC(AQALN,0),U,4)  ;not same transf dt
 .S X=$P($G(^AQAO(2,+$P(^AQAOC(AQALN,0),U,8),0)),U) ;ind number
 .Q:'$D(AQALPAR(X))  ;occ not for same admit event
 .S AQALAUT(X)=AQALN ;set array of occ for DGPMT that exist
 ;
 ; >> calculate event and create or modify occ
 I DGPMA]"" S X=DGPMT_"^AQALDG5" D @X
 ;
 ; >> delete any occurrences not edited (aqalaut(x) deleted if edited)
 S AQALX=0
 F  S AQALX=$O(AQALAUT(AQALX)) Q:AQALX=""  D
 .S AQALN=AQALAUT(AQALX) D DEL^AQALNK1(AQALN) ;delete occ
 Q
 ;
 ;
PARAM ; >> SUBRTN to find indicator numbers for adt event type
 S X=$P($G(^AQAGP(DUZ(2),"ADT")),U,I)
 I X]"" S AQALPAR(X)=""
 Q
