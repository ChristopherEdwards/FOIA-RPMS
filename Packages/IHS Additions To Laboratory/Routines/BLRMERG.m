BLRMERG ; IHS/TUCSON/DG/ANMC/CLS/ISD/EDE - LAB PATIENT MERGE  [ 01/13/1999  4:29 PM ]
 ;;5.2;BLR;**1005**;DEC 14, 1998
 ;
 ; Modified ALRMERG by EDE
 ;
 ; Repoint entries in ^LR
 ; Change LRDFN & XREFs in ^LRO(68, ^LRO(69,
 ;
 ; *** MERGE ROUTINE FOR VA LAB V5.2 ***
 ;
 ; When VA LAB PACKAGE versions change, so must the version number
 ; that is checked.  Confirm lab merge works in new package.
 ;
 ;Variables:
 ;  XDRMRG("FR")=from patient's ien
 ;  XDRMRG("TO")=to patient's ien
 ;
 ;  BLRFM=from patient's ien
 ;  BLRTO=to patient's ien
 ;
 ;  BLROLD=from patient's LR ien
 ;  BLRNEW=to patient's LR ien
 ;  BLRQ=quit flag
 ;  BLRSUB=accession area subscript
 ;  BLRDINVDT=subfile entry ien within BLRSUB in ^LR(BLROLD,
 ;  BLRAIEN=accession area ien in file 68 ^LRO(68, 
 ;  BLRDTSUB=date subscript in ^LRO(68, within accession area, ^LRO(69,
 ;  BLRNUM=subfile entry ien in file 68 ^LRO(68, within accession area
 ;  BLRDATE=date of lab test order
 ;  BLRSPECN=specimen ien in ^LRO(69,
 ;  BLRLBPK=lab package ien in ^DIC(9.4,
 ;
EN ; Entry point for lab merge
 D INIT
 I BLRQ D EOJ Q
 D MERGE
 D EOJ
 Q
 ;
INIT ;
 S BLRQ=1
 K ^TMP("BLRMERG",$J)
 ; insure correct version of Lab
 S BLRLBPK=$O(^DIC(9.4,"C","LR","")) ;            get Lab package ien
 I 'BLRLBPK D  Q
 .  I '$D(XDRM("NOTALK"))&'$D(ZTQUEUED) D
 ..  W !!,*7,"Cannot determine what version of Lab you are running!"
 ..  Q
 .  S:$D(^%ZOSF("$ZE")) X="VA Lab Merge: Cannot determine version",@^("$ZE")
 .  D MERGE^XDRMRG1 ; Causes merge to abort if lab merge cannot occur
 .  Q
 I $G(^DIC(9.4,BLRLBPK,"VERSION"))'=5.2 D  Q
 .  I '$D(XDRM("NOTALK"))&'$D(ZTQUEUED) D
 ..  W !!,*7,"The version of lab you are running is not compatible with this version of",!,"lab merge!"
 ..  Q
 .  S:$D(^%ZOSF("$ZE")) X="VA Lab Merge: Incorrect Version",@^("$ZE")
 .  D MERGE^XDRMRG1 ; Causes merge to abort if lab merge cannot occur
 .  Q
 ;
 I '$D(^TMP("XDRMRGFR",$J,XDRMRG("FR"),"LR")) Q  ;from entry not in Lab so nothing to merge
 ;
 ; Set up needed vars
 S BLRFM=XDRMRG("FR")
 S BLRTO=XDRMRG("TO")
 S BLROLD=^TMP("XDRMRGFR",$J,BLRFM,"LR")
 S BLRNEW=$G(^TMP("XDRMRGTO",$J,BLRTO,"LR"))
 I 'BLRNEW S BLRNEW=$G(^DPT(BLRTO,"LR"))
 ;
 ; If 'from' patient in Lab system but 'to' patient is not, then
 ; repoint 'from' patient's LR entry to 'to' patient, then quit.
 I '$D(^TMP("XDRMRGTO",$J,BLRTO,"LR")),'$D(^DPT(BLRTO,"LR")) D  Q
 .  S DIE="^LR(",DA=BLROLD,DR=".03////"_BLRTO
 .  D DIE^BLRMERGU
 .  Q
 ;
 S BLRQ=0
 Q
 ;
MERGE ; Begin merge process
 D REP6869 ;                          repoint files 68,69 & 9009022
 D ^BLRMERG2 ;                        move file 63 data
 Q
 ;
REP6869 ; REPOINT FILE 68, 69 & 9009022
 K ^TMP("BLRMERG",$J,"ORD")
 ; first navigate via file 63 entries
 F BLRSUB="CH","BB","MI","CY","SP","EM","AU" D LRINFO
 D CHKXREFS ;                         chg any missed entries
 K ^TMP("BLRMERG",$J,"ORD")
 Q
 ;
LRINFO ; FIND 68, 69 & 9009022 ENTRIES VIA 63 ENTRIES
 I BLRSUB="AU" D  Q
 .  Q:'$D(^LR(BLROLD,BLRSUB))
 .  S BLRINVDT=$P($G(^LR(BLROLD,BLRSUB)),U)
 .  Q:'BLRINVDT
 .  D SETVARS^BLRMERGU ;                 setup needed variables
 .  I BLRAIEN,BLRDATE,BLRDTSUB,BLRNUM
 .  E  Q  ;                              quit if not all vars
 .  D LRINFO2
 .  Q
 S BLRINVDT=0
 F  S BLRINVDT=$O(^LR(BLROLD,BLRSUB,BLRINVDT)) Q:'BLRINVDT  D
 .  D SETVARS^BLRMERGU ;                 setup needed variables
 .  I BLRAIEN,BLRDATE,BLRDTSUB,BLRNUM
 .  E  Q  ;                              quit if not all vars
 .  D LRINFO2
 .  Q
 Q
 ;
LRINFO2 ;
 D BLRTXLOG ;                             repoint blr tx log
 D 68 ;                                   repoint file 68
 Q
 ;
BLRTXLOG ; REPOINT BLRTXLOG
 S BLRDTANM=0
 F  S BLRDTANM=$O(^LR(BLROLD,BLRSUB,BLRINVDT,BLRDTANM)) Q:'BLRDTANM  D
 .  S BLRLTSUB=BLRSUB_";"_BLRDTANM_";1"
 .  S BLRLTIEN=$O(^LAB(60,"C",BLRLTSUB,0))
 .  S BLRTXIEN=0
 .  Q:'BLRLTIEN  ;                   quit if no lab test ien
 .  F  S BLRTXIEN=$O(^BLRTXLOG("AAT",BLRACC,BLRLTIEN,BLRTXIEN)) Q:'BLRTXIEN  D
 ..  Q:'$D(^BLRTXLOG(BLRTXIEN,0))  ; quit if corrupt file
 ..  Q:$P(^BLRTXLOG(BLRTXIEN,0),U,2)'=2  ; quit if not patient file
 ..  S X=$G(^BLRTXLOG(BLRTXIEN,12))
 ..  I X]"",+X,$E(+X,2,3)'=$E(BLRDATE,2,3) Q  ;quit if wrong year
 ..  S DIE="^BLRTXLOG(",DR=".03////"_BLRNEW_";.04////"_BLRTO,DA=BLRTXIEN
 ..  D DIE^BLRMERGU
 ..  Q
 .  Q
 Q
 ;
68 ; REPOINT FILE 68
 I $D(^LRO(68,BLRAIEN,1,BLRDTSUB,1,BLRNUM)) D
 .  D CHG68 ;                        modify file 68, accessions
 .  S BLRORDN=$G(^LRO(68,BLRAIEN,1,BLRDTSUB,1,BLRNUM,.1))
 .  Q:'BLRORDN  ;                    quit if no order #
 .  Q:$D(^TMP("BLRMERG",$J,"ORD",BLRORDN))
 .  ; there may be several 68 entries for one 69 entry
 .  D 69 ;                           modify file 69, orders
 .  Q
 Q
 ;
CHG68 ;MAKE CHANGE TO FILE 68
 ; Change LRDFN (68.02,.01) to point to TO patient LR entry
 S BLRSTKL="K"
 D XREF68 ;                            kill xrefs prior to value chg
 S DIE="^LRO(68,BLRAIEN,1,BLRDTSUB,1,",DA(2)=BLRAIEN,DA(1)=BLRDTSUB,DA=BLRNUM,DR=".01///"_BLRNEW
 D DIE^BLRMERGU
 Q:$D(Y)  ;                            quit if ^DIE error
 S BLRSTKL="S"
 D XREF68 ;                            set xrefs after value chg
 Q
 ;
XREF68 ; KILL/SET X-REFS IN SUBFILE 68.02, FIELD 13
 S DA=BLRNUM,DA(1)=BLRDTSUB,DA(2)=BLRAIEN,X=$P($G(^LRO(68,DA(2),1,DA(1),1,DA,3)),U,3)
 Q:X=""  ;                             quit if field 13 not valued
 ; this executes LRXREF1 that aborts if there is no 4 node
 Q:'$O(^LRO(68,DA(2),1,DA(1),1,DA,4,0))  ; quit if no 4 node entries
 D ^XBGXREFS(68.02,13,.BLRXREF)
 S BLRN=0
 F  S BLRN=$O(BLRXREF(13,BLRN)) Q:'BLRN  X BLRXREF(13,BLRN,BLRSTKL)
 K BLRXREF
 Q
 ;
69 ;MAKE CHANGE TO FILE 69
 S BLRSPECN=0
 F  S BLRSPECN=$O(^LRO(69,"C",BLRORDN,BLRDTSUB,BLRSPECN)) Q:'BLRSPECN  D CHG69
 S ^TMP("BLRMERG",$J,"ORD",BLRORDN)=""
 Q
 ;
CHG69 ; CHG LRDFN IN FILE 69
 ; warning - this label done from CHKXREFS also
 ; Change LRDFN (69.01,.01) to point to TO patient LR entry
 S BLRSTKL="K"
 D XREF69 ;                            kill xrefs prior to value chg
 S DA=BLRSPECN,DA(1)=BLRDTSUB,DIE="^LRO(69,BLRDTSUB,1,",DR=".01///"_BLRNEW
 D DIE^BLRMERGU
 Q:$D(Y)  ;                            quit if ^DIE error
 S BLRSTKL="S"
 D XREF69 ;                            set xrefs after value chg
 D FIXAN1 ;                            fix low level AN xref
 D FIXAN2 ;                            fix top level AN xref
 Q
 ;
FIXAN1 ; FIX LOW LEVEL AN XREF
 ; fix odd ball "AN" xrefs generated by who knows what
 ; get field 21 DATE/TIME RESULTS AVAILABLE
 S BLRRDT=$P($P($G(^LRO(69,BLRDTSUB,1,BLRSPECN,3)),U,2),".")
 Q:BLRRDT=""  ;                        quit if results not available
 S BLRLOC=$E($P($G(^LRO(69,BLRDTSUB,1,BLRSPECN,0)),U,7),1,15)
 Q:BLRLOC=""  ;                        quit if no location
 Q:'$D(^LRO(69,BLRRDT,1,"AN",BLRLOC,BLROLD))  ; quit if no old LRDFN
 S Y=0
 F  S Y=$O(^LRO(69,BLRRDT,1,"AN",BLRLOC,BLROLD,Y)) Q:'Y  D
 .  S ^LRO(69,BLRRDT,1,"AN",BLRLOC,BLRNEW,Y)=""
 .  K ^LRO(69,BLRRDT,1,"AN",BLRLOC,BLROLD,Y)
 .  Q
 Q
 ;
FIXAN2 ; FIX TOP LEVEL AN XREF
 S BLRLOC=""
 F  S BLRLOC=$O(^LRO(69,"AN",BLRLOC)) Q:BLRLOC=""  D
 .  S Y=0
 .  F  S Y=$O(^LRO(69,"AN",BLRLOC,BLROLD,Y)) Q:'Y  D
 ..  S ^LRO(69,"AN",BLRLOC,BLRNEW,Y)=""
 ..  K ^LRO(69,"AN",BLRLOC,BLROLD,Y)
 ..  Q
 .  Q
 Q
 ;
XREF69 ; KILL/SET X-REFS IN SUBFILE 69.01, FIELD 21 & 69.03, FIELD .01
 D FLD21
 D FLD01
 Q
 ;
FLD21 ; KILL/SET X-REFS IN SUBFILE 69.01, FIELD 21
 S DA=BLRSPECN,DA(1)=BLRDTSUB,X=$P($G(^LRO(69,DA(1),1,DA,3)),U,2)
 Q:X=""  ;                             quit if field 21 not valued
 D ^XBGXREFS(69.01,21,.BLRXREF)
 S BLRN=0
 F  S BLRN=$O(BLRXREF(21,BLRN)) Q:'BLRN  X BLRXREF(21,BLRN,BLRSTKL)
 K BLRXREF
 Q
 ;
FLD01 ; KILL/SET X-REFS IN SUBFILE 69.03, FIELD .01
 S DA(1)=BLRSPECN,DA(2)=BLRDTSUB
 F DA=0:0 S DA=$O(^LRO(69,DA(2),1,DA(1),2,DA)) Q:'DA  D
 .  S X=$P($G(^LRO(69,DA(2),1,DA(1),2,DA,0)),U)
 .  Q:X=""  ;                          should never happen
 .  D ^XBGXREFS(69.03,.01,.BLRXREF)
 .  X BLRXREF(.01,2,BLRSTKL) ;         "AT" xref only
 .  K BLRXREF
 .  Q
 Q
 ;
CHKXREFS ; CHECK FILE 68 & 69 XREFS
 ; now check xrefs to see if any file 68 or 69 entries left
 ; "AC" in file 68
 S BLRDTSUB=0
 F  S BLRDTSUB=$O(^LRO(68,"AC",BLROLD,BLRDTSUB)) Q:BLRDTSUB=""  D
 .  S Y=0
 .  F  S Y=$O(^LRO(68,"AC",BLROLD,BLRDTSUB,Y)) Q:'Y  D
 ..  S ^LRO(68,"AC",BLRNEW,BLRDTSUB,Y)=""
 ..  K ^LRO(68,"AC",BLROLD,BLRDTSUB,Y)
 ..  Q
 .  Q
 ; "MI" in file 68
 S BLRDTSUB=0
 F  S BLRDTSUB=$O(^LRO(68,"MI",BLROLD,BLRDTSUB)) Q:BLRDTSUB=""  D
 .  S Y=0
 .  F  S Y=$O(^LRO(68,"MI",BLROLD,BLRDTSUB,Y)) Q:'Y  D
 ..  S ^LRO(68,"MI",BLRNEW,BLRDTSUB,Y)=""
 ..  K ^LRO(68,"MI",BLROLD,BLRDTSUB,Y)
 ..  Q
 .  Q
 ; "D" in file 69
 S BLRDTSUB=0
 F  S BLRDTSUB=$O(^LRO(69,"D",BLROLD,BLRDTSUB)) Q:BLRDTSUB=""  D
 .  S BLRDATE=BLRDTSUB
 .  S BLRSPECN=""
 .  F  S BLRSPECN=$O(^LRO(69,"D",BLROLD,BLRDTSUB,BLRSPECN)) Q:'BLRSPECN  D
 ..  D CHG69
 ..  Q
 .  Q
 Q
 ;
EOJ ;
 K ^TMP("BLRMERG",$J)
 D EN^XBVK("BLR")
 D EN^XBVK("LR")
 D ^XBFMK ;                         kill off fileman variables
 Q
