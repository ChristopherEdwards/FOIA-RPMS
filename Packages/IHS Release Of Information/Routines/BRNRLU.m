BRNRLU ; IHS/PHXAO/TMJ - ROI GEN RETR UTILITIES ; 
 ;;2.0;RELEASE OF INFO SYSTEM;*1*;APR 10, 2003
 ;IHS/OIT/LJF - 01/10/2008 PATCH 1 Removed unused code especially ICD code
 ;
 ;
AVDOS(R,F) ;EP - return available Date of Disclosure
 NEW BRNDOS
 I $G(F)="" S F="S"
 S BRNDOS=""
 S BRNDOS=$P($G(^BRNREC(R,0)),U,19)
 I BRNDOS="" Q BRNDOS
 I F="N" Q BRNDOS
 I F="E" S BRNDOS=$$FMTE^XLFDT(BRNDOS,"2P")
 I F="S" S BRNDOS=$E(BRNDOS,4,5)_"/"_$E(BRNDOS,6,7)_"/"_$E(BRNDOS,2,3)
 I F="C" S BRNDOS=$E(BRNDOS,4,5)_"/"_$E(BRNDOS,6,7)_"/"_$E(BRNDOS,2,3)_" ("_$S($$VAL^XBDIQ1(90001,R,.19)]"":"A)",1:"E)")
 Q BRNDOS
 ;
FACREF(R) ;EP return requesting party
 N BRNF,%
 S %=^BRNREC(R,0)
 S BRNF=$S($P(%,U,6):$P($G(^BRNTREQ($P(%,U,6),0)),U),1:"<UNKNOWN>")
 Q BRNF
 ;
REFDTI(R,F) ; EP - Date Disclosure Initiated
 NEW BRNDOS
 I $G(F)="" S F="E"
 S BRNDOS=""
 S BRNDOS=$S($P($G(^BRNREC(R,0)),U)]"":$P(^BRNREC(R,0),U),1:$P($G(^BRNREC(R,0)),U,6))
 I BRNDOS="" Q BRNDOS
 I F="E" S BRNDOS=$$FMTE^XLFDT(BRNDOS)
 I F="S" S BRNDOS=$E(BRNDOS,4,5)_"/"_$E(BRNDOS,6,7)_"/"_$E(BRNDOS,2,3)
 I F="C" S BRNDOS=$E(BRNDOS,4,5)_"/"_$E(BRNDOS,6,7)_"/"_$E(BRNDOS,2,3)_" ("_$S($$VAL^XBDIQ1(90001,R,.01)]"":"A)",1:"E)")
 Q BRNDOS
