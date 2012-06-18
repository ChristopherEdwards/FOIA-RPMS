BDGCENI ; IHS/ANMC/LJF - AUTO INITIALIZE CENSUS ;  [ 06/28/2002  4:31 PM ]
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 12/29/2005 PATCH 1005 cahnged AGE^BDGF2 to official API
 ;
 NEW BDGBEG,DEFAULT,DA,DR,DIE
 ;
 ; ask min age for adult patient
 S DA=$$DIV^BSDU Q:'DA  S DR=.05,DIE=9009020.1 D ^DIE Q:$D(Y)
 ;
 ; ask begin date for census
 S DA=1,DIE=43,DR=10 D ^DIE Q:$D(Y)
 S BDGBEG=$$GET1^DIQ(43,1,10,"I") Q:BDGBEG<1
 S DIE=43,DA=1,DR="1000.11///"_BDGBEG_";1000.07///"_BDGBEG D ^DIE
 ;
 D MSG^BDGF("I will now DELETE all data in your census files and start over.",2,1)
 Q:'$$READ^BDGF("YO","Ready to Initialize Census for "_$$FMTE^XLFDT(BDGBEG),"NO")
 ;
 ; reset G&L dates in file 43
 S DR="1000.01///"_BDGBEG_";1000.07///"_BDGBEG_";1000.11///"_BDGBEG
 S DIE=43,DA=1 D ^DIE
 ;
 ; queue to background
 S ZTIO="",ZTRTN="EN^BDGCENI",ZTDESC="AUTO INITIALIZE CENSUS"
 S ZTDTH=$H,ZTSAVE("BDGBEG")=""
 D ^%ZTLOAD
 D MSG^BDGF("Queued to run in the background.",2,1),PAUSE^BDGF
 Q
 ;
EN ;EP; entry point after queuing to background
 NEW X,BEGCEN,DFN,CA,DATE,IEN,LAST,SRV,WARD,ADULT
 ;
 ; delete all data in census files
 I '$D(ZTQUEUED) D MSG^BDGF("Deleting old data in census files...",2,0)
 S X=0 F  S X=$O(^BDGCWD(X)) Q:X=""  K ^BDGCWD(X)
 S X=0 F  S X=$O(^BDGCTX(X)) Q:X=""  K ^BDGCTX(X)
 ;
 S BDGCEN=$$FMADD^XLFDT(BDGBEG,-1)   ;set census init date (begin-1)
 ;
 I '$D(ZTQUEUED) D MSG^BDGF("Finding all inpatients for initialization date...",1,0)
 S CA=0 F  S CA=$O(^DGPM(CA)) Q:'CA  D
 . ;
 . ; check if in date range
 . Q:'$G(^DGPM(CA,0))        ;bad node
 . Q:$P(^DGPM(CA,0),U,2)'=1  ;not admission node
 . I $$DSCH(CA)<BDGBEG Q     ;if patient discharged before begin date
 . I +^DGPM(CA,0)>BDGBEG Q   ;if patient admitted after census date
 . ;
 . ; get patient
 . S DFN=$$GET1^DIQ(405,CA,.03,"I")  ;patient pointer
 . ;
 . ; set ADULT=1 if at least min age for adult; 0=peds
 . ;S ADULT=$S($$AGE^BDGF2(DFN,+^DGPM(CA,0))<$$ADULT^BDGPAR:0,1:1)
 . S ADULT=$S($$AGE^AUPNPAT(DFN,+^DGPM(CA,0))<$$ADULT^BDGPAR:0,1:1)  ;IHS/OIT/LJF 12/29/2005 PATCH 1005
 . ;
 . ; find last ward transfer date before census date
 . S (LAST,DATE)=0
 . F  S DATE=$O(^DGPM("APCA",DFN,CA,DATE)) Q:'DATE  Q:(DATE>BDGBEG)  D
 .. S LAST=DATE
 . Q:'LAST            ;bad xref
 . ; find ien for last transfer before begin date
 . S IEN=$O(^DGPM("APCA",DFN,CA,LAST,0)) Q:'IEN
 . ; get last ward
 . S WARD=$$GET1^DIQ(405,IEN,.06,"I") Q:'WARD
 . ;
 . ; find last service transfer before census date
 . S LAST=9999999.9999999-BDGBEG
 . S LAST=$O(^DGPM("ATS",DFN,CA,(9999999.9999999-BDGBEG)))
 . Q:'LAST            ;bad xref
 . S SRV=$O(^DGPM("ATS",DFN,CA,LAST,0))
 . ;
 . ; put this admission into census file
 . I '$D(ZTQUEUED) D MSG^BDGF("Adding patient data to file...",0,0)
 . D SET(WARD,SRV,ADULT)
 ;
 ; now recalculate census from initialization date to today
 I '$D(ZTQUEUED) D MSG^BDGF("Running recalc from initialization date...",2,0)
 NEW RC,BDGFRM,BDGREP
 S RC=BDGBEG,BDGFRM="",BDGREP=0
 D DEFS^DGPMBSAR,QUE^DGPMBSAR
 ;
 ; send e-amil to person starting job
 NEW DUZ D MAIL^XBMAIL("DGZMGR","MSG^BDGCENI")
 ;
 Q
 ;
DSCH(ADM) ; return discharge date for admission ADM
 NEW X
 S X=$P($G(^DGPM(ADM,0)),U,17) I X="" Q 9999999    ;still inpatient
 Q $S($G(^DGPM(X,0)):+^(0),1:9999999)
 ;
SET(WD,SV,ADULT) ; stuff census files
 NEW PIECE
 I (WD="")!(SV="")!(ADULT="") Q
 S PIECE=$S(ADULT:2,1:12)
 ;
 ; set wardnodes if first time for this ward
 I '$D(^BDGCWD(WD)) D
 . S ^BDGCWD(WD,0)=WD,^BDGCWD("B",WD,WD)=""
 . S $P(^BDGCWD(0),U,3,4)=WD_U_($P(^BDGCWD(0),U,4)+1)
 I '$D(^BDGCWD(WD,1,0)) S ^BDGCWD(WD,1,0)="^9009016.21D^"_BDGCEN_"^1"
 I '$D(^BDGCWD(WD,1,BDGCEN,0)) S ^BDGCWD(WD,1,BDGCEN,0)=BDGCEN
 ;
 ; increment count for ward
 S $P(^BDGCWD(WD,1,BDGCEN,0),U,2)=$P(^BDGCWD(WD,1,BDGCEN,0),U,2)+1
 ;
 ; set service within ward node if first time for service/ward pair
 I '$D(^BDGCWD(WD,1,BDGCEN,1,0)) S ^BDGCWD(WD,1,BDGCEN,1,0)="^9009016.211P"
 I '$D(^BDGCWD(WD,1,BDGCEN,1,SV)) D
 . S $P(^BDGCWD(WD,1,BDGCEN,1,0),U,3,4)=SV_U_($P(^BDGCWD(WD,1,BDGCEN,1,0),U,4)+1)
 . S ^BDGCWD(WD,1,BDGCEN,1,SV,0)=SV
 ;
 ; increment count for service within ward
 S $P(^BDGCWD(WD,1,BDGCEN,1,0),U,3,4)=SV_U_($P(^BDGCWD(WD,1,BDGCEN,1,0),U,4)+1)
 S $P(^BDGCWD(WD,1,BDGCEN,1,SV,0),U,PIECE)=$P(^BDGCWD(WD,1,BDGCEN,1,SV,0),U,PIECE)+1
 ;
 ; set service node if first time for this service
 I '$D(^BDGCTX(SV)) D
 . S ^BDGCTX(SV,0)=SV,^BDGCTX("B",SV,SV)=""
 . S $P(^BDGCTX(0),U,3,4)=SV_U_($P(^BDGCTX(0),U,4)+1)
 I '$D(^BDGCTX(SV,1,0)) S ^BDGCTX(SV,1,0)="^9009016.61D^"_BDGCEN_"^1"
 I '$D(^BDGCTX(SV,1,BDGCEN,0)) S ^BDGCTX(SV,1,BDGCEN,0)=BDGCEN
 ;
 ; increment count for service
 S $P(^BDGCTX(SV,1,BDGCEN,0),U,PIECE)=$P(^BDGCTX(SV,1,BDGCEN,0),U,PIECE)+1
 Q
 ;
MSG ;EP; text of mail message
 ;;ADT CENSUS FILES INITIALIZATION
 ;;The initialization of the census files has been completed.
