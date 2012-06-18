BTIUCHLP ; IHS/ITSC/LJF - Help for Clinician ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ; IHS subroutines called by ^TIUCHLP and ^BTIUVSIT and Field Trip Note title
 ;
CHEKPN(X) ;EP; Display/validate demographic/visit information
 ; called by TIUCHLP
 W !!,"PCC Visit Identifiers..."
 W !?14,"Patient Name:  ",$S($G(X("PNM"))]"":$G(X("PNM")),1:"UNKNOWN")
 W !?14,"Patient HRCN:  ",$S($G(X("HRCN"))]"":$G(X("HRCN")),1:"UNKNOWN")
 W !?8,"Date/time of Visit:  "
 W $S(+$G(X("VISIT")):$$DATE^TIULS($P(X("VISIT"),U,2),"MM/DD/YY HR:MIN"),+$G(X("EDT")):$$DATE^TIULS(X("EDT"),"MM/DD/YY HR:MIN"),1:"UNKNOWN")
 W ?50,$P($G(X("CAT")),U,2)
 I $P($G(X("CAT")),U)="H" W ! D
 . I $G(X("LDT")) W ?12,"Discharge Date:  ",$$DATE^TIULS(+X("LDT"),"MM/DD/YY HR:MIN")
 . W ?50,$P($G(X("WARD")),U,2),?57,$P($G(X("TS")),U,2),!
 . I ($$PNAME^TIULC1(TIUTYPE)="OPERATIVE REPORTS")!($$PNAME^TIULC1(+$$DOCCLASS^TIULC1(TIUTYPE))="OPERATIVE REPORTS") D SURG
 E  D
 . W !?50,$P($G(^DIC(40.7,+$P($G(^AUPNVSIT(+X("VISIT"),0)),U,8),0)),U),!
 . I ($$PNAME^TIULC1(TIUTYPE)="OPERATIVE REPORTS")!($$PNAME^TIULC1(+$$DOCCLASS^TIULC1(TIUTYPE))="OPERATIVE REPORTS") D SURG
 Q
 ;
SURG ;- -- finds surgeries for hospitalization
 NEW ORDT,END,IEN,ARR
 S ORDT=+$P(X("EDT"),".")-.0001
 S END=$S($P($G(X("CAT")),U)'="H":X("EDT")_".2400",+$G(X("LDT")):+X("LDT"),1:DT)
 F  S ORDT=$O(^SRF("AIHS4",ORDT)) Q:'ORDT!(ORDT>END)  D
 . Q:'$D(^SRF("AIHS4",ORDT,DFN))
 . W ?15,"Surgery on ",$$DATE^TIULS(ORDT,"MM/DD/YY")
 . S IEN=0 F  S IEN=$O(^SRF("AIHS4",ORDT,DFN,IEN)) Q:'IEN  D
 .. K ARR D ENP^XBDIQ1(130,IEN,".14;.15;17;26;68","ARR(")
 .. I ARR(17)]"" W ?38,"Cancelled" Q
 .. W ?38,$E(ARR(.14),1,15)
 .. I ARR(.15)]"" W "/",$E(ARR(.15),1,15)
 .. W !?20,$E($S(ARR(26)]"":ARR(26),1:ARR(68)),1,58)
 . W !
 Q
 ;
GETEVNT ;EP ; Help get Fields for PN Dictation/Error Resolution
 ;called by field trip title which needs universal patient lookup and event visit
 N Y,TIU,DFN,TIUY,TITLE
 NEW AUPNLK S AUPNLK("ALL")=1
 S DFN=+$$PATIENT^TIULA Q:+DFN'>0
 S Y=$$READ^TIUU("YO","Okay to create Event visit for this patient")
 Q:'Y
 ;
 S TIUVST=$$ADDEVNT(DFN) Q:'TIUVST  ;create event visit
 ;
 D ENPN^TIUVSIT(.TIU,+DFN,1)
 I '$D(TIU) Q
 S TIUY=$$CHEKPN^TIUCHLP(.TIU)
 I 'TIUY Q
 D MAKE^TIUPEFIX(.SUCCESS,DFN,.TITLE,.TIU,$S(+$G(XQADATA):+$G(XQADATA),+$G(BUFDA):+$G(BUFDA),1:""))
 I +SUCCESS S TIUDONE=1
 Q
 ;
ADDEVNT(DFN) ;EP -- returns visit ien for event visit created
 ; -- create event visit based on user responses; called by ^BTIUVSIT
 NEW TIUFAC,TIUVDT,TIUVST
 S TIUFAC=$$READ^TIUU("P^9999999.06:EMZ","Visit Facility")
 I TIUFAC S TIUVDT=$$READ^TIUU("D^:NOW:EX","Visit Date")
 I $G(TIUVDT) S TIUVST=$$EVENT^BTIUPUTP(DFN,+TIUFAC,TIUVDT)
 Q $G(TIUVST)
