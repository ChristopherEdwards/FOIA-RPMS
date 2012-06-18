BDGBULL1 ; IHS/ANMC/LJF - POST ADT BULLETINS ;  
 ;;5.3;PIMS;**1007,1013**;FEB 27, 2007
 ; Called by ADT Event Driver protocol
 ;
 ; Input Variables:
 ;    DGPMT   = type of event (1-admit, 3-discharge, etc.)
 ;    DGPMDA  = event ien
 ;    DGPMCA  = admission ien
 ;    DGPMP   = zero node of 405 entry Prior to event
 ;    DGPMA   = zero node of 405 entry After event
 ;    DFN     = patient ien
 ;    DGQUIET = if $G(DGQUIET), no user interaction
 ;
 ;
 ;cmi/anch/maw 2/22/2007 added code OBS and code in EVENT to send bulletin if a patient goes from observation to admission PATCH 1007 item 1007.43
 ;ihs/cmi/maw 04/08/2011 PATCH 1013 RQMT157 added code for delete admit reason
 ;
EVENT ; process event type
 NEW DIV S DIV=$$DIV^BDGPAR(DUZ(2)) Q:'DIV
 ;
 ;   admission event
 I DGPMT=1 D  Q
 . ;  check if transfer in from another facility
 . I $$GET1^DIQ(9009020.1,DIV,101)="YES" D
 .. NEW CODE S CODE=$$GET1^DIQ(405.1,+$P(DGPMA,U,4),9999999.1)
 .. I (CODE=2)!(CODE=3) D TI
 . ;
 . ;IHS/ITSC/LJF 4/9/2004 moved code around so if admit w/in 24 hours then quit after
 . ;  check if readmitted w/24 hrs to same service (might be same admit)
 . NEW BDGQUIT
 . I $$GET1^DIQ(9009020.1,DIV,114)="YES" D  Q:$G(BDGQUIT)
 .. S Y=$$READM24(DGPMCA,DFN) I Y S BDGQUIT=1 D SAMEADM($P(Y,U,2))
 . ;
 . ;  check if readmission within parameter limit
 . I $$GET1^DIQ(9009020.1,DIV,104)="YES" D
 .. S Y=$$READM^BDGF1(DGPMCA,DFN) I Y D READM($P(Y,U,2))
 . ;
 . ;  check if readmitted w/24 hrs to same service (might be same admit)
 . ;I $$GET1^DIQ(9009020.1,DIV,114)="YES" D
 . ;. S Y=$$READM24(DGPMCA,DFN) I Y D SAMEADM($P(Y,U,2))
 . ;IHS/ITSC/LJF 4/9/2004 end of changes
 . ;
 . ;  check if admit after day surgery within parameter limit
 . I $$GET1^DIQ(9009020.1,DIV,106)="YES" D
 .. S Y=$$DSADM^BDGF1(DGPMCA,DFN) I Y D ADMDS($P(Y,U,2))
 . ;
 . ;cmi/anch/maw 2/22/2007 added bulleting if observation to admission PATCH 1007 item 1007.43
 . ;check if observation to admission
 . I $$GET1^DIQ(9009020.1,DIV,115)="YES" D
 .. I $$LASTSRVN^BDGF1(DGPMCA,DFN)["OBSERVATION" D OBS
 . ;
 . ;  check if admission was deleted
 . I DGPMA="" D DELADM
 ;
 ; ward transfer event
 ;IHS/ITSC/LJF 4/9/2004 moved code around so if return to icu, only send one bulletin
 I DGPMT=2 D  Q
 . ;  check if receiving ward is an ICU
 . I $$GET1^DIQ(9009016.5,+$P(DGPMA,U,6),101)="YES" D
 .. NEW BDGQUIT
 .. ;
 .. ; is this a return to ICU within parameter limit?
 .. I $$GET1^DIQ(9009020.1,DIV,111)="YES" D  Q:$G(BDGQUIT)     ;if bulletin turned on
 ... S X=$$LASTICU(DGPMCA,+DGPMA) Q:'X          ;date disch from ICU
 ... I $$FMDIFF^XLFDT(+DGPMA,X)'>$$GET1^DIQ(9009020.1,DIV,112) S BDGQUIT=1 D RICU(X) Q
 .. ;
 .. I $$GET1^DIQ(9009020.1,DIV,110)="YES" D ICU
 .. ;
 .. ; is this also a return to ICU within parameter limit?
 .. ;Q:$$GET1^DIQ(9009020.1,DIV,111)'="YES"     ;bulletin not turned on
 .. ;S X=$$LASTICU(DGPMCA,+DGPMA) Q:'X          ;date disch from ICU
 .. ;I $$FMDIFF^XLFDT(+DGPMA,X)'>$$GET1^DIQ(9009020.1,DIV,112) D RICU(X)
 ;IHS/ITSC/LJF 4/9/2004 end of changes
 ;
 ; discharge event
 I DGPMT=3 D  Q
 . Q:DGPMA=""       ;quit if discharge deleted
 . ;
 . ; check if patient died
 . I $$GET1^DIQ(2,DFN,.351)]"" D  Q
 .. I $$GET1^DIQ(9009020.1,DIV,103)="YES" D DEATH
 . ;
 . ; check if AMA discharge
 . I $$GET1^DIQ(405.1,$$GET1^DIQ(405,+DGPMDA,.04,"I"),9999999.1)=3 D
 .. I $$GET1^DIQ(9009020.1,DIV,108)="YES" D AMA
 . ;
 . ; check if transfer to other facility
 . I $$GET1^DIQ(9009020.1,DIV,102)="YES" D
 .. I $$GET1^DIQ(405,+DGPMDA,.05)]"" D TO
 . ;
 . ; check if LOS less than 24 hours and not observation
 . I $$LOSHRS^BDGF1(DGPMCA,+DGPMA,DFN)<24 D
 .. I $$LASTSRVN^BDGF1(DGPMCA,DFN)'["OBSERVATION" D
 ... I $$GET1^DIQ(9009020.1,DIV,113)="YES" D ONEDAY
 . ;
 ;
 Q
GEN ; -- set general data
 K XMB   ;IHS/ITSC/LJF 4/9/2004 start with clean array
 S XMB(1)=$$GET1^DIQ(2,DFN,.01)                ;patient name
 S XMB(2)=$$HRCN^BDGF2(DFN,DUZ(2))             ;chart #
 S XMB(3)=$$GET1^DIQ(405,DGPMCA,.01)           ;admit date/time
 S X="NOW",%DT="T" D ^%DT S XMDT=Y             ;send bulletin now
 Q
 ;
TI ; -- bulletin for transfers in to facility
 D GEN                                           ;set general variables
 S XMB="BDG TRANSFER IN ADMIT"                   ;bulletin name
 S XMB(4)=$$GET1^DIQ(405,+DGPMCA,.05)            ;transfer facility
 S XMB(5)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 S XMB(6)=$$ADMSRV^BDGF1(DGPMCA,DFN)             ;service
 D ^XMB Q
 ;
OBS ; -- bulletin for observation to admission
 ;cmi/anch/maw 2/22/2007 added for observation to admission PATCH 1007 item 1007.43
 D GEN                                           ;set general variables
 S XMB="BDG OBS TO ADMIT"                        ;bulletin name
 S XMB(4)=$$ADMSRV^BDGF1(DGPMCA,DFN)             ;service
 S XMB(5)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 D ^XMB Q
 ;
READM(LAST) ; -- bulletin for readmissions
 ; LAST=last discharge date in FM format
 D GEN                                                    ;set gen vars
 S XMB="BDG READMISSION"                                  ;bulletin name
 S XMB(4)=$$GET1^DIQ(9009020.1,+$$DIV^BDGPAR(DUZ(2)),105)  ;time limit
 S XMB(5)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 S XMB(6)=$$FMTE^XLFDT(LAST)                     ;last discharge
 S XMB(7)=$$LASTDX(LAST)                         ;last adm dx
 S XMB(8)=$$ADMSRV^BDGF1(DGPMCA,DFN)             ;new service
 S XMB(9)=$$LASTSRV(LAST)                        ;last service
 D ^XMB Q
 ;
SAMEADM(LAST) ; -- bulletin for readmission within 24 hrs to same service
 ; LAST=last discharge date in FM format
 D GEN                                           ;set gen vars
 S XMB="BDG SAME ADMIT"                          ;bulletin name
 S XMB(4)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 S XMB(5)=$$LASTDX(LAST)                         ;last adm dx
 S XMB(6)=$$FMTE^XLFDT(LAST)                     ;last discharge
 S XMB(7)=$$ADMSRV^BDGF1(DGPMCA,DFN)             ;new service
 D ^XMB Q
 ;
ADMDS(LAST) ; -- bulletin for admit after day surgery
 ; LAST=date of last day surgery
 D GEN                                           ;set gen variables
 S XMB="BDG ADMIT AFTER DAY SURG"                ;bulletin name
 S XMB(4)=$$GET1^DIQ(9009020.1,+$$DIV^BDGPAR(DUZ(2)),107)  ;time limit
 S XMB(5)=$$GET1^DIQ(405,+DGPMCA,.1)             ;adm dx
 S XMB(6)=$$FMTE^XLFDT(LAST)                     ;day surgery date/time
 S XMB(9)=$$ADMSRV^BDGF1(+DGPMCA,DFN)            ;adm srv
 ;S Y=DGDS D DD^%DT S XMB(6)=Y                    ;day surg date/time;IHS/ITSC/LJF 4/9/2004
 S XMB(7)=$$DSPROC^BDGDSA(LAST,DFN)               ;day surg procedure
 S Y=$$DSDISP^BDGDSA(LAST,DFN)                    ;ds disposition
 ;S XMB(8)=$S(DGDIS="ADM":"**ADMITTED DIRECTLY FROM DAY SURGERY**",1:"")
 S XMB(8)=$S(Y="ADM":"**ADMITTED DIRECTLY FROM DAY SURGERY**",1:"")  ;IHS/ITSC/LJF 4/9/2004
 D ^XMB Q
 ;
DELADM ; bulletin for deleted admission
 D GEN                                           ;set gen variables
 S XMB="BDG DELETED ADMITS"                      ;bulletin name
 S XMB(3)=$$FMTE^XLFDT(+DGPMP)                   ;deleted admit date
 S XMB(4)=$$GET1^DIQ(42,+$P(DGPMP,U,6),.01)      ;ward
 S XMB(5)=$$GET1^DIQ(200,DUZ,.01)                ;deleted by
 S XMB(6)=$$HTE^XLFDT($H)                        ;deleted at
 S XMB(7)=$G(BDGDLREA)                           ;delete reason ihs/cmi/maw 04/08/2011 Patch 1013 RQMT157
 K BDGDLREA
 D ^XMB Q
 ;
ICU ; -- bulletin for ICU transfers
 K XMB
 S XMB="BDG ICU TRANSFER"                        ;bulletin name
 S XMB(1)=$$GET1^DIQ(2,DFN,.01)                  ;patient name
 S XMB(2)=$$HRCN^BDGF2(DFN,DUZ(2))               ;chart number
 S XMB(3)=$$GET1^DIQ(405,+DGPMDA,.01)            ;transfer date/time
 S XMB(4)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 ; treating specialty
 S XMB(5)=$$GET1^DIQ(405,+$$PRIORTXN^BDGF1(+DGPMA,DGPMCA,DFN),.09)
 S X="NOW",%DT="T" D ^%DT S XMDT=Y               ;send bulletin now
 D ^XMB Q
 ;
RICU(DATE) ; -- bulletin for returns to ICU
 ; DATE=date of last discharge from ICU
 K XMB
 S XMB="BDG RETURN TO ICU"                       ;bulletin name
 S XMB(1)=$$GET1^DIQ(2,DFN,.01)                  ;patient name
 S XMB(2)=$$HRCN^BDGF2(DFN,DUZ(2))               ;chart number
 S XMB(3)=$$GET1^DIQ(405,+DGPMDA,.01)            ;transfer date/time
 S XMB(4)=$$FMTE^XLFDT(DATE)                     ;last disch from ICU
 S XMB(5)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 ; treating specialty
 S XMB(6)=$$GET1^DIQ(405,+$$PRIORTXN^BDGF1(+DGPMA,DGPMCA,DFN),.09)
 S X="NOW",%DT="T" D ^%DT S XMDT=Y               ;send bulletin now
 D ^XMB Q
 ;
TO ; -- bulletin for transfers out to other facility
 D GEN                                           ;set general variables
 S XMB="BDG TRANSFER OUT DISCH"                  ;bulletin name
 S XMB(4)=$$GET1^DIQ(405,+DGPMDA,.01)            ;dsch date
 S XMB(5)=$$GET1^DIQ(405,+DGPMDA,.05)            ;transfer facility
 S XMB(6)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 S XMB(7)=$$LASTSRVN^BDGF1(DGPMCA,DFN)           ;service
 D ^XMB Q
 ;
AMA ; -- bulletin for ama discharges
 D GEN                                           ;set general variables
 S XMB="BDG AMA DISCHARGE"                       ;bulletin name
 S XMB(4)=$$GET1^DIQ(405,+DGPMDA,.01)            ;dsch date
 S XMB(5)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 ;
 ;IHS/ITSC/LJF 4/9/2004 fixed parameters
 ;S XMB(6)=$$LASTSRVN^BDGF1(DGPMCA,DFN)           ;service
 S XMB(7)=$$LASTSRVN^BDGF1(DGPMCA,DFN)           ;service
 S XMB(6)=$$GET1^DIQ(405,+DGPMDA,.01)            ;dsch date
 ;IHS/ITSC/LJF end of changes
 ;
 D ^XMB Q
 ;
DEATH ; -- bulletin for inpatient death
 D GEN                                           ;set gen variables
 S XMB="BDG DEATH"                               ;bulletin name
 S XMB(4)=$$GET1^DIQ(405,+DGPMDA,.01)            ;dsch date
 S XMB(5)=$$GET1^DIQ(405,+DGPMDA,.04)            ;dsch type
 S XMB(6)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 S XMB(7)=$$LASTSRVN^BDGF1(DGPMCA,DFN)           ;service
 D ^XMB Q
 ;
ONEDAY ; bulletin for one day admits
 D GEN                                           ;set gen variables
 S XMB="BDG ONEDAY ADMIT"                        ;bulletin name
 S XMB(4)=$$GET1^DIQ(405,+DGPMDA,.01)            ;dsch date
 S XMB(5)=$$GET1^DIQ(405,+DGPMDA,.04)            ;dsch type
 S XMB(6)=$$GET1^DIQ(405,+DGPMCA,.1)             ;admitting dx
 S XMB(7)=$$LASTSRVN^BDGF1(DGPMCA,DFN)           ;service
 D ^XMB Q
 ;
LASTDX(DATE) ; -- find last adm dx
 NEW Y S Y=$O(^DGPM("APTT3",DFN,DATE,0)) I 'Y Q ""
 S Y=$$GET1^DIQ(405,Y,.14,"I")           ;admit movement
 Q $$GET1^DIQ(405,+Y,.1)
 ;
LASTSRV(DATE) ; returns disch service for last admission
 NEW Y S Y=$O(^DGPM("APTT3",DFN,DATE,0)) I 'Y Q ""
 S Y=$$GET1^DIQ(405,Y,.14,"I")           ;admit movement
 Q $$LASTSRVN^BDGF1(+Y,DFN)
 ;
LASTICU(ADM,DATE) ; returns date of last discharge from ICU
 NEW D,FOUND,LAST,N
 S FOUND=0
 S D=DATE F  S D=$O(^DGPM("APCA",DFN,ADM,D),-1) Q:'D  Q:FOUND  D
 . S N=$O(^DGPM("APCA",DFN,ADM,D,0)) Q:'N
 . ; if this transfer was to an ICU ward, quit search
 . ;I $$GET1^DIQ(42,$$GET1^DIQ(405,N,.06,"I"),101)="YES" S FOUND=1
 . I $$GET1^DIQ(9009016.5,$$GET1^DIQ(405,N,.06,"I"),101)="YES" S FOUND=1 Q   ;IHS/ITSC/LJF 4/9/2004
 . S LAST=N
 ;
 ; if previous ICU transfer found, return date of transfer out of ICU
 I FOUND,$G(LAST) Q $$GET1^DIQ(405,LAST,.01,"I")
 Q ""
 ;
READM24(ADM,PAT) ; returns 1 if patient readmitted within 24 hours
 NEW ADMDT,LAST,DIFF
 S ADMDT=$$GET1^DIQ(405,ADM,.01,"I")                 ;new admit date
 S LAST=$O(^DGPM("APTT3",PAT,ADMDT),-1)              ;last discharge
 I 'LAST Q 0                                         ;1st admission
 S DIFF=$$FMDIFF^XLFDT(ADMDT,LAST,2)\3600            ;# of hrs diff
 I DIFF>24 Q 0                                       ;beyond 24 hrs
 S Y=$O(^DGPM("APTT3",PAT,LAST,0)) I 'Y Q 0          ;last disch ien
 S Y=$$GET1^DIQ(405,Y,.14,"I") I 'Y Q 0              ;last admission ien;IHS/ITSC/LJF 4/9/2004
 ;
 ; if same service, then call bulletin (return 1 and last disch date)
 I $$LASTSRVN^BDGF1(Y,PAT)=$$ADMSRV^BDGF1(ADM,PAT) Q 1_U_LAST
 Q 0
