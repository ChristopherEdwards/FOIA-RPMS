BSDX25A ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
CO(DFN,SDT,SDCL,SDDA,SDASK,SDCODT,SDCOACT,SDLNE,SDCOALBF,BSDXAPTID,SDQUIET,VPRV,APIERR) ;Appt Check Out
 ; Input  -- DFN      Patient file IEN
 ;           SDT      Appointment Date/Time
 ;           SDCL     Hospital Location file IEN for Appt
 ;           SDDA     IEN in ^SC multiple or null [Optional]
 ;           SDASK    Ask Check Out Date/Time     [Optional]
 ;           SDCODT   Date/Time of Check Out      [Optional]
 ;           SDCOACT  Appt Mgmt Check Out Action  [Optional]
 ;           SDLNE    Appt Mgmt Line Number       [Optional]
 ; Output -- SDCOALBF Re-build Appt Mgmt List
 ; Input  -- BSDXAPTID Appointment ID
 ;           SDQUIET  No Terminal output 0=allow display 1=do not allow
 ;           VPRV     V Provider IEN - pointer to V PROVIDER file
 I $D(XRTL) D T0^%ZOSV
 N SDCOQUIT,SDOE,SDATA
 S:'SDDA SDDA=$$FIND^SDAM2(DFN,SDT,SDCL)
 I 'SDDA D  Q  ; RETURN ERROR IF SDQUIET
 . S APIERR($I(APIERR))="SDCO1: Cannot check out this appointment - Hospital Location not identified."
 . G COQ
 S SDATA=$G(^DPT(DFN,"S",SDT,0))
 ; ** MT Blocking removed
 ;S X="EASMTCHK" X ^%ZOSF("TEST") I $T,$G(EASACT)'="W",$$MT^EASMTCHK(DFN,$P($G(SDATA),U,16),"C",$G(SDT)) D PAUSE^VALM1 G COQ
 ;
 ;-- if new encounter, pass to PCE
 I $$NEW^SDPCE(SDT) D  S VALMBCK="R",SDCOALBF=1 G COQ
 . N SDCOED
 . S SDOE=$$GETAPT^SDVSIT2(DFN,SDT,SDCL)
 . ;
 . ; -- has appt already been checked out
 . S SDCOED=$$CHK($TR($$STATUS^SDAM1(DFN,SDT,SDCL,SDATA,SDDA),";","^"))
 . ;
 . D CO^BSDX25B(SDOE,DFN,SDT,SDCL,SDCODT,BSDXAPTID,SDQUIET,VPRV,.APIERR) Q
 ;
COQ K % Q
 ;
 ;
 ;
CHK(SDSTB) ; -- is appointment checked out
 N Y
 I "^2^8^12^"[("^"_+SDSTB_"^"),$P(SDSTB,"^",3)["CHECKED OUT" S Y=1
 Q +$G(Y)
 ;
DT(DFN,SDT,SDCL,SDDA,SDASK,SDCODT,SDCOQUIT) ;Update Check Out Date
 N %DT,DR,SDCIDT,X
 S:'$D(^SC(SDCL,"S",0)) ^(0)="^44.001DA^^"
 S DR="",SDCIDT=$P($G(^SC(SDCL,"S",SDT,1,SDDA,"C")),"^"),X=$P($G(^("C")),"^",3)
 I X G DTQ:'SDASK  S DR="303R"
 I DR="",$P(^SC(SDCL,0),U,24),$$REQ^SDM1A(SDT)="CO" S DR="303R//"_$S($G(SDCODT):$$FTIME^VALM1($S(SDCODT<SDCIDT:SDCIDT,1:SDCODT)),1:"NOW")
 I DR="" S DR="303R///"_$S($G(SDCODT):"/"_$S(SDCODT<SDCIDT:SDCIDT,1:SDCODT),1:"NOW")
 S DR="S SDCOQUIT="""";"_DR_";K SDCOQUIT"
 D DIE(SDCL,SDT,SDDA,DR)
DTQ Q
 ;
DIE(SDCL,SDT,SDDA,DR) ; -- update appt data in ^SC
 N DA,DIE
 S DA(2)=SDCL,DA(1)=SDT,DA=SDDA,DIE="^SC("_DA(2)_",""S"","_DA(1)_",1,"
 D ^DIE K DQ,DE
DIEQ Q
