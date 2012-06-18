BDGAD5 ; IHS/ANMC/LJF - A&D PTS REMAINING ; 
 ;;5.3;PIMS;**1009,1012**;APR 26, 2002
 ;
 ;cmi/anch/maw 2/11/2008 added fix in SERV PATCH 1009
 ;
 NEW PREV,CURR
 S CURR=BDGT
 S PREV=$$FMADD^XLFDT(CURR,-1)   ;previous day
 ;
SERV ; loop through services and fill in patients remaining
 NEW SRV,REMA,REMP,NEWA,NEWP,N
 S SRV=0 F  S SRV=$O(^BDGCTX(SRV)) Q:'SRV  D
 . Q:'$D(^BDGCTX(SRV,1,PREV,0))  ;cmi/maw 2/11/2008 quit if no current date for service PATCH 1009
 . Q:'$D(^BDGCTX(SRV,1,CURR,0))  ;cmi/maw 4/23/2010 quit if no current date for service PATCH 1012
 . ;
 . ; if no activity, bring old numbers forward
 . I $P(^BDGCTX(SRV,1,CURR,0),U,2,99)="" D  Q
 .. S $P(^BDGCTX(SRV,1,CURR,0),U,2)=$P($G(^BDGCTX(SRV,1,PREV,0)),U,2)
 .. S $P(^BDGCTX(SRV,1,CURR,0),U,12)=$P($G(^BDGCTX(SRV,1,PREV,0)),U,12)
 . ;
 . ; else, perform calculations
 . S REMA=$P($G(^BDGCTX(SRV,1,PREV,0)),U,2)    ;prev adults remaining
 . S REMP=$P($G(^BDGCTX(SRV,1,PREV,0)),U,12)   ;prev peds remaining
 . S N=$G(^BDGCTX(SRV,1,CURR,0))
 . S NEWA=REMA+$P(N,U,3)-$P(N,U,4)+$P(N,U,5)-$P(N,U,6)-$P(N,U,7)
 . S NEWP=REMP+$P(N,U,13)-$P(N,U,14)+$P(N,U,15)-$P(N,U,16)-$P(N,U,17)
 . ;
 . S $P(^BDGCTX(SRV,1,CURR,0),U,2)=NEWA
 . S $P(^BDGCTX(SRV,1,CURR,0),U,12)=NEWP
 ;
WARD ; loop through wards and fill in patients remaining
 NEW WARD,REM,REMA,REMP,NEW,NEWA,NEWP,N,N1
 S WARD=0 F  S WARD=$O(^BDGCWD(WARD)) Q:'WARD  D
 . ;
 . ; if no activity, bring old numbers forward
 . I $P(^BDGCWD(WARD,1,CURR,0),U,2,99)="" D
 .. S $P(^BDGCWD(WARD,1,CURR,0),U,2)=$P($G(^BDGCWD(WARD,1,PREV,0)),U,2)
 . ;
 . ; else, perform calculations
 . E  D
 .. S REM=$P($G(^BDGCWD(WARD,1,PREV,0)),U,2)    ;prev remaining
 .. S N=$G(^BDGCWD(WARD,1,CURR,0))
 .. S NEW=REM+$P(N,U,3)-$P(N,U,4)+$P(N,U,5)-$P(N,U,6)-$P(N,U,7)
 .. S $P(^BDGCWD(WARD,1,CURR,0),U,2)=NEW          ;new remaining total
 . ;
 . ; for services within wards
 . S SRV=0 F  S SRV=$O(^BDGCWD(WARD,1,PREV,1,SRV)) Q:'SRV  D
 .. ;
 .. ; if no activity for service, bring numbers forward
 .. I '$D(^BDGCWD(WARD,1,CURR,1,SRV,0)) D  Q
 ... S $P(^BDGCWD(WARD,1,CURR,1,0),U,3,4)=SRV_U_($P(^BDGCWD(WARD,1,CURR,1,0),U,4)+1)
 ... S ^BDGCWD(WARD,1,CURR,1,SRV,0)=SRV_U_(+$P(^BDGCWD(WARD,1,PREV,1,SRV,0),U,2))
 ... S $P(^BDGCWD(WARD,1,CURR,1,SRV,0),U,12)=+$P(^BDGCWD(WARD,1,PREV,1,SRV,0),U,12)   ;peds remaining
 .. ;
 .. ; else, perform calculations
 .. S REMA=$P($G(^BDGCWD(WARD,1,PREV,1,SRV,0)),U,2)    ;prev adults
 .. S REMP=$P($G(^BDGCWD(WARD,1,PREV,1,SRV,0)),U,12)   ;prev peds
 .. S N=$G(^BDGCWD(WARD,1,CURR,1,SRV,0))
 .. S NEWA=REMA+$P(N,U,3)-$P(N,U,4)+$P(N,U,5)-$P(N,U,6)-$P(N,U,7)
 .. S NEWP=REMP+$P(N,U,13)-$P(N,U,14)+$P(N,U,15)-$P(N,U,16)-$P(N,U,17)
 .. ;
 .. S $P(^BDGCWD(WARD,1,CURR,1,SRV,0),U,2)=NEWA
 .. S $P(^BDGCWD(WARD,1,CURR,1,SRV,0),U,12)=NEWP
 . ;
 . ; for services added to ward for the first time, no prev date
 . S SRV=0 F  S SRV=$O(^BDGCWD(WARD,1,CURR,1,SRV)) Q:'SRV  D
 .. Q:$D(^BDGCWD(WARD,1,PREV,1,SRV))   ;only first timers
 .. ;
 .. ; perform calculations
 .. S N=$G(^BDGCWD(WARD,1,CURR,1,SRV,0))
 .. S NEWA=$P(N,U,3)-$P(N,U,4)+$P(N,U,5)-$P(N,U,6)-$P(N,U,7)
 .. S NEWP=$P(N,U,13)-$P(N,U,14)+$P(N,U,15)-$P(N,U,16)-$P(N,U,17)
 .. ;
 .. S $P(^BDGCWD(WARD,1,CURR,1,SRV,0),U,2)=NEWA
 .. S $P(^BDGCWD(WARD,1,CURR,1,SRV,0),U,12)=NEWP
 Q
