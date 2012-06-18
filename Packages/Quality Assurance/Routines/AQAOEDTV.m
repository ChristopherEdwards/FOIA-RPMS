AQAOEDTV ; IHS/ORDC/LJF - VENDOR DISPLAY SUBRTNS ;
 ;;1.01;QAI MANAGEMENT;;OCT 05, 1995
 ;
 ;This routine displays various aspects of contract health visits
 ;in PCC. It is called where provider information has been expanded
 ;to include vendors. This routine added for ENHANCE #1.
 ;
PROV ;EP; -- display vendor for PCC visit
 Q:'$D(^AUPNVCHS("AD",AQAOVSIT))
 S AQAODX=0
 F  S AQAODX=$O(^AUPNVCHS("AD",AQAOVSIT,AQAODX)) Q:AQAODX=""  D
 . Q:'$D(^AUPNVCHS(AQAODX,0))  Q:$P(^(0),14)=""
 . S AQAOCNT=AQAOCNT+1 W ?23,AQAOCNT,")"
 . S AQAOA(AQAOCNT)=$$VALI^XBDIQ1(9000010.03,AQAODX,.14)_";AUTTVNDR("
 . W ?28,$E($$VAL^XBDIQ1(9999999.11,+AQAOA(AQAOCNT),.01),1,20)
 . S X=$$VALI^XBDIQ1(9999999.11,+AQAOA(AQAOCNT),1103)
 . S Y=$$VAL^XBDIQ1(9999999.11,+AQAOA(AQAOCNT),1103.01)
 . I Y]"" W ?50," (CHS ",Y Q
 . W ?50," (",$$VAL^XBDIQ1(9999999.34,X,.02),")",!
 Q
