BTIUPUTP ; IHS/ITSC/LJF - IHS calls from ^TIUPUTPN ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;Code to find visit for document
 ;
 ; -- special call for op reports
 I $$PNAME^TIULC1(+$$DOCCLASS^TIULC1(TIUTYPE))="OPERATIVE REPORTS" D OPRPT Q
 ;
 ; -- special call for field trip notes
 I $P(TIUTYPE,U,2)="FIELD TRIP NOTE" D FIELD Q
 ;
 ; -- all other reports
 NEW TIUMODE S TIUMODE=$S($D(ZTQUEUED):0,1:1)
 D MAIN^TIUVSIT(.TIU,.DFN,TIUSSN,TIUEDT,TIULDT,"LAST",TIUMODE,TIULOC)
 Q
 ;
OPRPT ; -- find surgery visit for op report
 D GETSURG^BTIUVSIT(.TIUX,.DFN,TIUSSN,TIUEDT)
 ;
 ; -- if not found & user interaction, show list of visits for selection
 I 'TIUX,'$D(ZTQUEUED) D  I 'TIUX Q
 . S X1=TIUEDT,X2=-300 D C^%DTC S TIUEDT=X
 . D MAIN^TIUVSIT(.TIU,.DFN,TIUSSN,TIUEDT,TIULDT,"LAST",1,TIULOC,"",0)
 I 'TIUX Q
 ;
 ; -- set patient and visit variables needed for rest of upload link
 I $P($G(^AUPNVSIT(+TIUX,0)),U,5)'=DFN Q
 NEW TIUA D ENP^XBDIQ1(9000010,TIUX,".01;.07;.22","TIUA(","I")
 NEW TIUV S TIUV=TIUA(.22,"I")_";"_TIUA(.01,"I")_";"_TIUA(.07,"I")
 S BTIUVSIT=TIUX
 D PATVADPT^TIULV(.TIU,DFN,"",TIUV,$G(TIUSDC))
 Q
 ;
 ;
FIELD ; -- find patient and facility, make event visit
 NEW TIUN,TIUF,FOUND,QUIT,DOB
 S X=TIUDOB,%DT="P" D ^%DT Q:Y=-1  S DOB=Y  ;convert to internal
 S (FOUND,QUIT,TIUN,TIUX)=0
 ;
 ; -- find patient with hrcn and dob
 F  S TIUN=$O(^AUPNPAT("D",TIUSSN,TIUN)) Q:'TIUN  D     ;loop by hrcn
 . I $$GET1^DIQ(2,TIUN,.03,"I")'=DOB Q                  ;wrong date of birth
 . I FOUND S QUIT=1                                     ;>1 found
 . I '$D(^AUPNPAT(TIUN,41,DUZ(2),0)) Q                  ;must be patient at this facility
 . S FOUND=TIUN_U_$O(^AUPNPAT("D",TIUSSN,TIUN,0))       ;dfn_^_facility
 I QUIT Q                                               ;too many found
 I 'FOUND Q                                             ;none found
 ;
 ; -- create visit
 S DFN=$P(FOUND,U),TIUFAC=$P(FOUND,U,2)
 S X=TIUVDT,%DT="P" D ^%DT Q:Y=-1             ;visit date to internal
 S TIUX=$$EVENT(DFN,TIUFAC,Y)                 ;create event visit
 ;
 ; -- set visit and patient variables needed by TIU
 NEW TIUA D ENP^XBDIQ1(9000010,TIUX,".01;.07;.22","TIUA(","I")
 NEW TIUV S TIUV=TIUA(.22,"I")_";"_TIUA(.01,"I")_";"_TIUA(.07,"I")
 S BTIUVSIT=TIUX
 D PATVADPT^TIULV(.TIU,DFN,"",TIUV,$G(TIUSDC))
 Q
 ;
 ;
EVENT(APCDPAT,APCDLOC,APCDDATE) ;EP -- creates event type visit
 ; also called by ^BTIUCHLP
 K APCDALVR
 S APCDALVR("APCDADD")=1,APCDALVR("AUPNTALK")="",APCDALVR("APCDANE")=""
 S APCDALVR("APCDPAT")=APCDPAT
 S APCDALVR("APCDLOC")=APCDLOC
 S APCDALVR("APCDTYPE")="O"
 S APCDALVR("APCDCAT")="E"
 S APCDALVR("APCDDATE")=+APCDDATE
 S APCDALVR("APCDAUTO")=""
 D EN^APCDALV                    ;call PEP in PCC
 I $D(APCDALVR("APCDAFLG")) Q 0
 Q +APCDALVR("APCDVSIT")
