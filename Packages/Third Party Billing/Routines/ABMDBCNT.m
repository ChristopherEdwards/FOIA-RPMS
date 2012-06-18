ABMDBCNT ; IHS/ASDST/DMJ - Set Array for Bills to Print ;  
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;TMD
 ;
 ;IHS/ASDS/SDH - 03/07/2001 - V2.4 Patch 9 - NOIS XJG-0201-160063
 ;    Modified to allow the exclusion parameter of Provider to work
 ;    properly.
 ;
 ; *********************************************************************
 ;
GBILL ;
 S ABMP("BDFN")=""       ; Initialize IEN to 3P BILL
 S ABM("C")=0            ; Initialize counter
 W !!,"Establishing Bills to be Exported for the Parameters Specified..."
 ; Loop thru claims with approved bill status ("xref")
 F  S ABMP("BDFN")=$O(^ABMDBILL(DUZ(2),"AC","A",ABMP("BDFN"))) Q:'ABMP("BDFN")!(ABM("C")=250)  D
 . ; Quit if mode of export does not match
 . Q:$P($G(^ABMDBILL(DUZ(2),ABMP("BDFN"),0)),U,6)'=ABM("FORM")
 . S ABMLOC=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,3)   ; Visit for bill
 . ; Quit if location does not match
 . I $D(ABMY("LOC")),ABMLOC'=ABMY("LOC") Q
 . S ABMPAT=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,5)   ; Patient IEN
 . ; Quit if patient does not match
 . I $D(ABMY("PAT")),ABMPAT'=ABMY("PAT") Q
 . S ABMTYP=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),2),U,2)   ; Insurer Type
 . ; Quit if insurer type does not match
 . I $D(ABMY("TYP")),ABMY("TYP")'[ABMTYP Q
 . S ABMINS=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8)   ; Active Insurer
 . ; Quit if insurer does not match
 . I $D(ABMY("INS")),ABMINS'=ABMY("INS") Q
 . S ABMAPPR=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,4)  ; Appr. Official
 . ; Quit if approving official does not match
 . I $D(ABMY("APPR")),ABMAPPR'=ABMY("APPR") Q
 . S ABMDT=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),1),U,5)    ; Date approved
 . I $D(ABMY("PRV")),'$D(^ABMDBILL(DUZ(2),ABMP("BDFN"),41,"B",ABMY("PRV"))) Q
 . ; Quit if date approved does not fall within specified range
 . I $G(ABMY("DT"))="A",ABMDT<ABMY("DT",1)!(ABMDT>(ABMY("DT",2)+.9)) Q
 . S ABMBTYP=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,7)  ; Visit type
 . S ABMADM0=$G(^ABMDBILL(DUZ(2),ABMP("BDFN"),6))
 . S ABMDT2=$P(ABMADM0,U)                              ; Admission date
 . ; Quit if visit type is 111 and (no admit date or date not w/i range)
 . I $G(ABMY("DT"))="V",ABMBTYP=111 Q:'ABMADM0  Q:ABMDT2<ABMY("DT",1)!(ABMDT2>ABMY("DT",2))
 . S ABMDT3=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),7),U)     ; Service date from
 . ; Quit if visit type is 111 and (no date from or date not w/i range)
 . I $G(ABMY("DT"))="V",ABMBTYP'=111 Q:ABMDT3<ABMY("DT",1)!(ABMDT3>ABMY("DT",2))
 . ; ABMY(active insurer,IEN to 3P BILL)=""
 . S ABMY($P(^ABMDBILL(DUZ(2),ABMP("BDFN"),0),U,8),ABMP("BDFN"))=""
 . S ABM("C")=ABM("C")+1                            ; increment counter
 . K ABMLOC,ABMPAT,ABMTYP,ABMINS,ABMAPPR,ABMDT,ABMDT2,ABMDT3,ABMBTYP,ABMADM0
 Q
