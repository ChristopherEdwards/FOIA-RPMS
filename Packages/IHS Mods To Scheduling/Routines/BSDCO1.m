BSDCO1 ; IHS/ANMC/LJF - IHS CHECK-OUT PROCESS ;  [ 02/10/2005  4:02 PM ]
 ;;5.3;PIMS;**1002,1010**;APR 26, 2002
 ;
 ;cmi/anch/maw 05/01/2009 PATCH 1010 RQMT 34 checkout date/time on visit
 Q
 ;
CO(SDOE,DFN,SDT,SDCL) ;EP; called to ask check-out date/time
 ;  Called by SDCO1
 ; SDOE = Oupatient Encounter IEN
 ;  DFN = Patient IEN
 ;  SDT = Appointment Date/Time
 ; SDCL = Clinic IEN
 ;
 I '$G(SDOE) D ^%ZTER Q  ;lets trap an error here to see what is causing the problem
 NEW DIE,DA,DR,SDN,SDV,AUPNVSIT
 S DIE="^SC("_SDCL_",""S"","_SDT_",1,"
 S DA(2)=SDCL,DA(1)=SDT,(DA,SDN)=$$SCIEN^BSDU2(DFN,SDCL,SDT)
 ;
 I $P($G(^SC(+SDCL,"S",SDT,1,SDN,"C")),U)="" D  Q
 . W !!,"Patient NOT checked in; Cannot check-out yet."
 . D PAUSE^BDGF
 ;
 ;IHS/ITSC/WAR 1/20/2005 PATCH #1002 to correctly identify ck-out 'user'
 ;S DR="303R//NOW;304///"_DUZ_";306///"_$$NOW^XLFDT
 S DR="303R//NOW;304///`"_DUZ_";306///"_$$NOW^XLFDT
 D ^DIE
 ;
 ; if checked out and status not updated, do it now
 I $P($G(^SC(+SDCL,"S",SDT,1,DA,"C")),U,3)]"" D
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
