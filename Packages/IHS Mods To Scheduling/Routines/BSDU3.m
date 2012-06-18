BSDU3 ; IHS/ANMC/LJF - TEAM INFO UTILITIES ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
PROV(TEAM,DATES,LIST) ;EP; returns array in LIST of providers tied to team
 ;Only called if PCMM is used!!!!!!!!!!!!!
 ; TEAM=team ien
 ; DATES("BEGIN")=earliest date for provider on team
 ; DATES("END")=lastest date for provider
 ; DATES("INCL")=1 to get only those on team throughout date range
 ;              =0 to get those on team sometime during date range
 N OKAY,XLIST,YLIST,POS,PRV,PLIST
 S LIST="^TMP(""SCRP"",$J,""LIST"")"
 K XLIST,@LIST
 ;
 ; find positions for team
 S OKAY=$$TPTM^SCAPMC(TEAM,.DATES,"","","XLIST","ERROR")
 ;
 ; loop thru positions to find providers
 S POS=0 F  S POS=$O(XLIST("SCTP",TEAM,POS)) Q:'POS  D
 . S POS0=$G(^SCTM(404.57,POS,0)) Q:'$L(POS0)
 . ;
 . ; find providers for position during date range
 . K YLIST S OKAY=$$PRTP^SCAPMC(POS,.SCDT,"YLIST","ERROR",1,0)
 . ;
 . ; loop thru providers found
 . S PRV=0 F  S PRV=$O(YLIST(PRV)) Q:'PRV  D
 .. S @LIST@(0)=$G(@LIST@(0))+1
 .. S @LIST@(@LIST@(0))=YLIST(PRV)
 ;
 Q LIST
 ;
CLINICS(PROV,LIST) ;EP; returns array of clinics for this provider
 ; PROV=provider ien; LIST returns as array
 NEW X
 S X=0 F  S X=$O(^SC("AIHSDPR",PROV,X)) Q:'X  D
 . S Y=$O(^SC("AIHSDPR",PROV,X,0)) Q:'Y  ;quit if bad xref
 . Q:$G(^SC("AIHSDPR",PROV,X,Y))'=1      ;quit if not default provider
 . S LIST(X)=""
 Q
