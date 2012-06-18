BLRMERG2 ; IHS/TUCSON/DG/ANMC/CLS/ISD/EDE - LAB MERGE ROUTINE  [ 12/21/1998  3:55 PM ]
 ;;5.2;LR;**1005,1022,1024**;May 02, 2008
 ;
 ;Variables:
 ;  BLROLD=from patient's LR ien
 ;  BLRNEW=to patient's LR ien
 ;  BLRQ=quit flag
 ;  BLRSUB=accession area subscript
 ;  BLRDINVDT=subfile entry ien within BLRSUB in ^LR(BLROLD,
 ;  BLRAIEN=accession area ien in file 68 ^LRO(68, 
 ;  BLRDTSUB=date subscript in ^LRO(68, within accession area, ^LRO(69,
 ;
START ;
 D PREMERGE
 D MERGE
 D BULLT
 Q
 ;
PREMERGE ; PREMERGE CHECK
 ; Check to see if any "From" patient nodes have same collection
 ; date/time as "To" patient nodes, if they do, then uptick by one
 ; second until date/time unique for both "From" and "To" patients.
 ;
 F BLRSUB="CH","BB","MI","CY","SP","EM" D
 .  S BLRINVDT=0
 .  F  S BLRINVDT=$O(^LR(BLROLD,BLRSUB,BLRINVDT)) Q:BLRINVDT'=+BLRINVDT  I $D(^LR(BLRNEW,BLRSUB,BLRINVDT)) D SHIFT
 .  Q
 Q
 ;
SHIFT ; MAKE DATE/TIME UNIQUE FOR BOTH PATIENTS (SUBSCRIPT)
 S (BLRODT,BLRNDT)=+^LR(BLROLD,BLRSUB,BLRINVDT,0)
 D SHIFT2 ;                              find inverse date slot
 D CHG68 ;                               chg accession file
 D CHG69 ;                               chg order entry file
 ; chg .01 field value
 S $P(^LR(BLROLD,BLRSUB,BLRNINVD,0),U)=BLRNDT ; chg .01 field
 S BLROGBL="^LR(BLROLD,BLRSUB,BLRINVDT)" ;set gbl root of old entry
 ; copy old gbl entries to new gbl entries (by inverse date)
 F  S BLROGBL=$Q(@BLROGBL) Q:+$P(BLROGBL,",",3)'=BLRINVDT  D
 .  S BLRNGBL=$P(BLROGBL,BLRINVDT)_BLRNINVD_$P(BLROGBL,BLRINVDT,2)
 .  S @BLRNGBL=@BLROGBL
 .  Q
 S $P(^LR(BLROLD,BLRSUB,0),U,3,4)=BLRNINVD_"^"_($P($G(^LR(BLROLD,BLRSUB,0)),U,4)+1) ;PHXAO/AEF ADDED $G TO PREVENT <UNDEFINED>SHIFT+13^BLRMERG2 ERROR
 ; delete old ^LR entry
 S DA(1)=BLROLD,DA=BLRINVDT,DIK="^LR("_BLROLD_","""_BLRSUB_"""," D DIK^BLRMERGU
 ; set xrefs for new entry
 S DA(1)=BLROLD,DA=BLRNINVD,DIK="^LR("_BLROLD_","""_BLRSUB_"""," D IX1^BLRMERGU
 Q
 ;
SHIFT2 ; FIND INVERSE DATE/TIME SLOT
 ; Up by .000001 old date/time variable, check if $D(BLRODT+.000001)
 ; "From" patient, if it does exist, up by another .000001, check
 ; again, if okay, check to see if the "To" patient has this date/time
 ;
 F  S BLRNDT=BLRNDT+.000001,BLRNINVD=9999999-BLRNDT I '$D(^LR(BLROLD,BLRSUB,BLRNINVD)),'$D(^LR(BLRNEW,BLRSUB,BLRNINVD)) Q
 Q
 ;
CHG68 ; Changes INVERSE DATE field (^DD(68.01,13.5,0)) value
 D SETVARS^BLRMERGU
 Q:'BLRAIEN    ;PHXAO/AEF - NEW LINE TO PREVENT <SUBSCRIPT> ERROR
 Q:'BLRDTSUB    ;PHXAO/AEF - NEW LINE TO PREVENT <SUBSCRIPT> ERROR
 Q:'$D(^LRO(68,BLRAIEN,1,BLRDTSUB))
 S DIE="^LRO(68,BLRAIEN,1,BLRDTSUB,1,",DA(2)=BLRAIEN,DA(1)=BLRDTSUB,DA=BLRNUM,DR="13.5////"_BLRNINVD
 D DIE^BLRMERGU
 Q
 ;
CHG69 ; Changes DATE(TIME) COLLECTION field (^DD(69.01,10,0)) value
 ; the following code not for CY,SP,EM,AU because they do not have
 ; a .1 node, which points to file 69 (Order).
 I BLRSUB'="CH",BLRSUB'="BB",BLRSUB'="MI" Q
 S BLRDATE=$P(+^LR(BLROLD,BLRSUB,BLRINVDT,0),"."),BLRACC=$P(^(0),U,6),BLRNUM=$P(BLRACC," ",3),BLRAIEN=$O(^LRO(68,"B",$P(BLRACC," "),""))
 Q:'$G(BLRAIEN)   ;PHXAO/AEF - ADDED NEW LINE TO PREVENT <SUBSCRIPT>CHG69+5^BLRMERG2 ERROR
 Q:'$D(^LRO(68,BLRAIEN,1,BLRDATE))
 S BLRORDN=$G(^LRO(68,BLRAIEN,1,BLRDATE,1,BLRNUM,.1))  ;PHXAO/AEF - ADDED $G TO PREVENT <UNDEFINED> ERROR
 Q:'BLRORDN  ;                                 quit if no order #
 S BLRSPECN=0
 F  S BLRSPECN=$O(^LRO(69,"C",BLRORDN,BLRDATE,BLRSPECN)) Q:'BLRSPECN  D
 .  Q:+$G(^LRO(69,BLRDATE,1,BLRSPECN,1))'=BLRODT    ;PHXAO/AEF - ADDED $G TO PREVENT <UNDEFINED> ERROR
 .  S DA(1)=BLRDATE,DA=BLRSPECN,DR="10////"_BLRNDT,DIE="^LRO(69,BLRDATE,1,"
 .  D DIE^BLRMERGU
 .  Q
 Q
 ;
MERGE ;TRANSFER ^LR ENTRIES FROM OLD TO NEW
 F BLRSUB="CH","BB","MI","CY","SP","EM" D
 .  S BLROGBL="^LR(BLROLD,BLRSUB)" ;set gbl root of old entry
 .  Q:'$D(^LR(BLROLD,BLRSUB))  ;    quit if no old nodes to copy
 .  ; copy old gbl entries to new gbl entries (by accession area)
 .  F  S BLROGBL=$Q(@BLROGBL) Q:$P($P(BLROGBL,",",2),"""",2)'=BLRSUB  D
 ..  S BLRNGBL="^LR("_BLRNEW_","""_BLRSUB_$P(BLROGBL,BLRSUB,2,999) ;PHXAO/AEF - REPLACED 2) WITH 2,999) TO PREVENT <SYNTAX> ERROR WHEN SUBSCRIPT CONTAINS MORE THAN ONE CH
 ..  S @BLRNGBL=@BLROGBL
 ..  Q
 .  ; set piece 3 & 4 of 0th node
 .  NEW C,L,X,Y
 .  S (C,L,Y)=0
 .  F  S Y=$O(^LR(BLRNEW,BLRSUB,Y)) Q:'Y  S C=C+1,L=Y
 .  S X=^LR(BLRNEW,BLRSUB,0)
 .  S X=$P(X,U,1,2)_U_L_U_C
 .  S ^LR(BLRNEW,BLRSUB,0)=X
 .  ; set xrefs for new entries
 .  S BLRINVD=0
 .  F  S BLRINVDT=$O(^LR(BLRNEW,BLRSUB,BLRINVDT)) Q:'BLRINVDT  D
 ..  S DA(1)=BLRNEW,DA=BLRINVDT,DIK="^LR("_BLRNEW_","""_BLRSUB_""","
 ..  D IX1^BLRMERGU
 ..  Q
 .  Q
 I $D(^LR(BLROLD,"AU")) D  ;    set autopsy xrefs
 .  S BLRSTKL="S" D AUTXREF ;   set xrefs for new entry
 .  S BLRSTKL="K" D AUTXREF ;   kill xrefs for old entry
 .  Q
 ; copy other old gbl entries to new gbl entries
 S BLRSUB=0
 F  S BLRSUB=$O(^LR(BLROLD,BLRSUB)) Q:BLRSUB=""  D
 .  I BLRSUB'="CH",BLRSUB'="BB",BLRSUB'="MI",BLRSUB'="CY",BLRSUB'="SP",BLRSUB'="EM"
 .  E  Q  ;                     quit if BLRSUB already moved
 .  I ($D(^LR(BLROLD,BLRSUB))#10) S ^LR(BLRNEW,BLRSUB)=^LR(BLROLD,BLRSUB)
 .  S BLROGBL="^LR(BLROLD,BLRSUB)" ;set gbl root of old entry
 .  ; copy old gbl entries to new gbl entries (by accession area)
 .  F  S BLROGBL=$Q(@BLROGBL) Q:$P($P(BLROGBL,",",2),"""",2)'=BLRSUB  D
 ..  S BLRNGBL="^LR("_BLRNEW_","""_BLRSUB_$P(BLROGBL,BLRSUB,2)
 ..  S @BLRNGBL=@BLROGBL
 ..  Q
 .  Q
 ; delete old LR entry from ^LR(
 S DIK="^LR(",DA=BLROLD D DIK^BLRMERGU ; removes old LRDFN entry in ^LR
 I $D(^LAC("LRAC",BLROLD)) S DA=BLROLD,DIK="^LAC(""LRAC""," D DIK^BLRMERGU ; removes entry in cumulative file, 64.7 for old LRDFN
 K ^DPT(BLRFM,"LR") ;           remove LR pointer from ^DPT on old pat
 Q
 ;
AUTXREF ; KILL/SET AUTOPSY X-REFS IN FILE 63 FIELDS 11 AND 14
 I BLRSTKL="S" S DA=BLRNEW I 1
 E  S DA=BLROLD
 D FLD11
 D FLD14
 Q
 ;
FLD11 ; KILL/SET "AAU" XREF FROM FILE 63 FIELD 11
 S X=$P($G(^LR(DA,"AU")),U)
 Q:X=""  ;                             quit if field 11 not valued
 D ^XBGXREFS(63,11,.BLRXREF)
 S BLRN=0
 F  S BLRN=$O(BLRXREF(11,BLRN)) Q:'BLRN  X BLRXREF(11,BLRN,BLRSTKL)
 K BLRXREF
 Q
 ;
FLD14 ; KILL/SET "AAUA" XREF FROM FILE 63 FIELD 14
 S X=$P($G(^LR(DA,"AU")),U,6)
 Q:X=""  ;                             quit if field 14 not valued
 D ^XBGXREFS(63,14,.BLRXREF)
 S BLRN=0
 F  S BLRN=$O(BLRXREF(14,BLRN)) Q:'BLRN  X BLRXREF(14,BLRN,BLRSTKL)
 K BLRXREF
 Q
 ;
BULLT ; Send bulletin re: reprinting of cumulative report
 S BLRDUZ=DUZ,DUZ=.5
 S XMB(1)=BLROLD
 S XMB(2)=BLRNEW
 S XMB(3)=$P(^DPT(BLRFM,0),U)
 S XMB(4)=$P(^DPT(BLRTO,0),U)
 I $G(DUZ(2)) S XMB(5)=$P($G(^AUPNPAT(BLRFM,41,DUZ(2),0)),U,2)
 I $G(XMB(5))
 E  S XMB(5)="NOT INDICATED"
 I $G(DUZ(2)) S XMB(6)=$P($G(^AUPNPAT(BLRTO,41,DUZ(2),0)),U,2)
 I $G(XMB(6))
 E  S XMB(6)="NOT INDICATED"
 S XMB="BLR LAB PATIENT MERGE"
 D ^XMB
 S DUZ=BLRDUZ
 D EN^XBVK("XMB") ;                     kill off mail variables
 K Y1,XMDT
 Q
