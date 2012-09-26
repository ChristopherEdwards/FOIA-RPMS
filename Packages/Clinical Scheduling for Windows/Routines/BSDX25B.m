BSDX25B ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
 ;cmi/anch/maw 05/01/2009 PATCH 1010 RQMT 34 checkout date/time on visit
 Q
 ;
CO(SDOE,DFN,SDT,SDCL,SDCODT,BSDXAPTID,SDQUIET,VPRV,APIERR) ;EP; called to ask check-out date/time   ;SAT ADDED PARAMETERS SDCODT, BSDXAPTID, & SDQUIET
 ;  Called by SDCO1
 ; SDOE      = Oupatient Encounter IEN
 ;  DFN      = Patient IEN
 ;  SDT      = Appointment Date/Time
 ; SDCL      = Clinic IEN
 ; SDCODT    = APPOINTMENT CHECKOUT TIME [OPTIONAL - USED WHEN SDQUIET=1] USER ENTERED FORMAT
 ; BSDXAPTID = APPOINTMENT ID - POINTER TO ^BSDXAPPT
 ; SDQUIET   = ALLOW NO TERMINAL INPUT/OUTPUT 0=ALLOW; 1=DO NOT ALLOW
 ; VPRV      = V Provider IEN - pointer to V PROVIDER file
 ; APIERR    = Returned Array of errors
 ;             APIERR = counter
 ;             APIERR(counter)=message -- <Prog name>: <message>
 ;
 I '$G(SDOE) D ^%ZTER Q  ;lets trap an error here to see what is causing the problem
 NEW DIE,DA,DR,SDN,SDV,AUPNVSIT
 S DIE="^SC("_SDCL_",""S"","_SDT_",1,"
 S DA(2)=SDCL,DA(1)=SDT,(DA,SDN)=$$SCIEN^BSDU2(DFN,SDCL,SDT)
 ;S DA(4)=SDCL,DA(3)="S",DA(2)=SDT,DA(1)=1,(DA,SDN)=$$SCIEN^BSDU2(DFN,SDCL,SDT)
 ;CHECK THAT APPOINTMENT IS CHECKED IN
 I $P($G(^SC(+SDCL,"S",SDT,1,SDN,"C")),U)="" D  Q
 . S APIERR($I(APIERR))="BSDX25B: Patient not checked in"
 . Q
 ;
 ;IHS/ITSC/WAR 1/20/2005 PATCH #1002 to correctly identify ck-out 'user'
 ;S DR="303R//NOW;304///"_DUZ_";306///"_$$NOW^XLFDT
 S DR="303///"_$$FMTE^XLFDT(SDCODT)_";304///`"_DUZ_";306///"_$$NOW^XLFDT
 D ^DIE
 ;
 ; if checked out and status not updated, do it now
 I $P($G(^SC(+SDCL,"S",SDT,1,DA,"C")),U,3)]"" D
 . ;UPDATE APPOINTMENT SCHEDULE GLOBAL ^BSDXAPPT
 . I $G(BSDXAPTID) D
 . . S PSTAT=$P(^SCE(SDOE,0),U,12)
 . . S DIE="^BSDXAPPT("
 . . S DA=BSDXAPTID
 . . S DR=".14///"_$G(SDCODT)_";.19///"_PSTAT
 . . D ^DIE
 . . ;possibly update VProvider
 . . S BSDXNOD=^BSDXAPPT(BSDXAPTID,0)
 . . I $G(VPRV),+$P(BSDXNOD,U,15) D
 . . . ;get BSDX appointment schedule
 . . . S DIE="^AUPNVPRV("
 . . . S DA=$P(BSDXNOD,U,15)
 . . . S DR=".01///"_VPRV
 . . . D ^DIE
 . ;
 . Q:$$GET1^DIQ(409.68,SDOE,.12)="CHECKED OUT"
 . S DIE=409.68,DA=SDOE,DR=".12///2;.07///"_$$NOW^XLFDT
 . D ^DIE
 . ;
 . ; if visit pointer stored, update visit checkout date/time
 . S SDV=$$GET1^DIQ(409.68,SDOE,.05,"I") Q:'SDV
 . Q:'$D(^AUPNVSIT(SDV,0))  Q:$$GET1^DIQ(9000010,SDV,.05,"I")'=DFN
 . Q:$$GET1^DIQ(9000010,SDV,.11,"I")=1    ;deleted
 . ;
 . ;cmi/maw 5/1/2009 PATCH 1010 RQMT 34
 . S DIE="^AUPNVSIT(",DA=SDV
 . S DR=".18///"_$P($G(^SC(+SDCL,"S",SDT,1,SDN,"C")),U,3)
 . D ^DIE S AUPNVSIT=SDV D MOD^AUPNVSIT
 Q
 ;
