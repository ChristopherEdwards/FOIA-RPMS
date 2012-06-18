BTIUED ; IHS/ITSC/LJF - CALLS FROM TIUEDIT ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 ;
VEDIT(DEFAULT) ;EP; -- called to ask user to edit PCC visit
 Q:'$D(^XUSEC("TIUZVSIT",DUZ))                                      ;quit if user doesn't have key
 NEW X S X=$$SC^APCLV(+$G(TIU("VISIT")),"I") Q:X="H"                ;check service category
 I $G(DEFAULT)="" S DEFAULT=$S(X="A":"NO",1:"YES")                  ;set default if not sent
 S Y=$$READ^TIUU("YO","Want to ADD data to this visit",DEFAULT)
 I Y S APCDVSIT=+TIU("VISIT") D EN^APCDEFL,EN^APCDEKL,EN2^APCDEKL   ;calls to PEPs in PCC
 Q
