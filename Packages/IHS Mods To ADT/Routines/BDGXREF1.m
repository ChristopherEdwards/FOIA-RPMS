BDGXREF1 ; IHS/ANMC/LJF - IHS MUMPS XREFS ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
SVACSET ;EP; set AC xref on Scheduled Visit file
 ; uses 3 fields - visit type, date expected & ward
 ; used by bed availability to list future scheduled admissions
 ;
 NEW BDGX1,BDGX2,BDGX3
 S BDGX1=$P($G(^BDGSV(DA,0)),U,2)    ;date expected
 S BDGX2=$P($G(^BDGSV(DA,0)),U,3)    ;visit type
 S BDGX3=$P($G(^BDGSV(DA,0)),U,9)    ;ward
 Q:BDGX1=""  Q:BDGX2=""  Q:BDGX3=""
 S ^BDGSV("AC",BDGX2,BDGX3,BDGX1,DA)=""
 Q
 ;
SVACKIL ;EP; kill AC xref on Scheduled Visit file
 NEW BDGX1,BDGX2,BDGX3
 S BDGX1=$P($G(^BDGSV(DA,0)),U,2)    ;date expected
 S BDGX2=$P($G(^BDGSV(DA,0)),U,3)    ;visit type
 S BDGX3=$P($G(^BDGSV(DA,0)),U,9)    ;ward
 Q:BDGX1=""  Q:BDGX2=""  Q:BDGX3=""
 K ^BDGSV("AC",BDGX2,BDGX3,BDGX1,DA)
 Q
 ;
SVADSET ;EP; set AD xref on Scheduled Visit file
 ; uses 2 fields - patient and date expected
 ; used by patient inquiry
 ;
 NEW BDGX1,BDGX2
 S BDGX1=$P($G(^BDGSV(DA,0)),U,1)    ;patient
 S BDGX2=$P($G(^BDGSV(DA,0)),U,2)    ;date expected
 Q:BDGX1=""  Q:BDGX2=""
 S ^BDGSV("AD",BDGX1,BDGX2,DA)=""
 Q
 ;
SVADKIL ;EP; kill AC xref on Scheduled Visit file
 NEW BDGX1,BDGX2
 S BDGX2=$P($G(^BDGSV(DA,0)),U,1)    ;patient
 S BDGX1=$P($G(^BDGSV(DA,0)),U,2)    ;date expected
 Q:BDGX1=""  Q:BDGX2=""
 K ^BDGSV("AD",BDGX1,BDGX2,DA)
 Q
