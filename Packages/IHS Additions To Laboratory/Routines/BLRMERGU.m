BLRMERGU ; IHS/TUCSON/DG/ANMC/CLS/ISD/EDE - COMMON FUNCTIONS  [ 12/21/1998  3:56 PM ]
 ;;5.2;BLR;**1005**;DEC 14, 1998
 ;
 ; This routine contains common function used by other BLRMERG*
 ; routines.
 ;
 Q  ;                                        no entry from top
 ;
SETVARS ;EP - SET BLRDATE, BLRDTSUB, BLRNUM, BLRAIEN, BLRACC
 ; upon entry BLROLD,BLRSUB,BLRINVDT must be set
 S (BLRDATE,BLRDTSUB,BLRNUM,BLRAIEN)=""
 ; get accession area and ien within date subscript
 I BLRSUB="AU" S BLRACC=$P(^LR(BLROLD,BLRSUB),U,6) I 1
 E  S BLRACC=$P(^LR(BLROLD,BLRSUB,BLRINVDT,0),U,6) ;get accession link
 ; At this point in time I see 2 forms for BLRACC, the accession
 ; link field.  One is just the ien for CY, SP, EM, and AU.
 ; The other is 'XX YYYY Z' where XX is the accession area, and Z
 ; is the ien within the date subscript.
 I BLRACC=+BLRACC D  I 1  ;                CY, SP, EM, AU
 .  S BLRNUM=BLRACC ;                      accession ien by datesub
 .  S BLRAIEN=$O(^LRO(68,"B",BLRSUB,0))  ; get accession area
 .  Q
 E  D  ;                                   CH, BB, MI etc.
 .  S BLRNUM=$P(BLRACC," ",3) ;            accession ien by datesub
 .  S BLRAIEN=$O(^LRO(68,"B",$P(BLRACC," "),0)) ;get accession area
 .  Q
 Q:'BLRAIEN  ;                             quit if no accession area
 S BLRSTYPE=$P(^LRO(68,BLRAIEN,0),U,3) ;   get daily, yearly, etc.
 Q:BLRSTYPE=""  ;                          quit if bad data
 ; get specimen date and compute date subscript
 I BLRSUB="AU" S BLRDATE=$P(+^LR(BLROLD,BLRSUB),".") I 1
 E  S BLRDATE=$P(+^LR(BLROLD,BLRSUB,BLRINVDT,0),".")
 D @("SETDS"_BLRSTYPE) ;                   compute date subscript
 ; compute accession number in form XX YY Z for lookup into blr tx log
 I BLRACC=+BLRACC D  ;                     CY, SP, EM, AU
 .  S X=$E(BLRDATE,2,3) ;                  get year
 .  S BLRACC=BLRSUB_" "_X_" "_BLRACC ;     set to XX YY Z
 .  Q
 Q
 ;
SETDSD ; SET DATE SUB DAILY
 S BLRDTSUB=BLRDATE
 Q
 ;
SETDSM ; SET DATE SUB MONTHLY
 S BLRDTSUB=$E(BLRDATE,1,5)_"00"
 Q
 ;
SETDSQ ; SET DATE SUB QUARTERLY
 S BLRDTSUB=$E(BLRDATE,1,3)_"0000"+(($E(BLRDATE,4,5)-1)\3*300+100)
 Q
 ;
SETDSY ; SET DATE SUB YEARLY
 S BLRDTSUB=$E(BLRDATE,1,3)_"0000"
 Q
 ;
DIE ; ^DIE CALL
 D ^DIE
 K DA,DIE,DR
 Q
 ;
DIK ; CALL ^DIK
 D ^DIK
 K DA,DIK
 Q
 ;
IX1 ; CALL IX1^DIK
 D IX1^DIK
 K DA,DIK
 Q
