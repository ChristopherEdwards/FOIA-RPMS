BTIULO14 ; IHS/MSC/MGH - STILL MORE OBJECTS FOR EHR ;31-Aug-2011 17:25;DU
 ;;1.0;TEXT INTEGRATION UTILITIES;**1009**;NOV 04, 2004;Build 22
VPTED(TARGET) ; returns patient education topics for current vuecentric visit context
 ; MULTI=0 return on=e line of education topic names; MULTI=1 return 1 line per topic
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 ;I VST="" Q " "
 I VST="" S @TARGET@(1,0)="No visit selected" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="A visit was not created." Q "~@"_$NA(@TARGET)
 S CNT=0
 D GETPTED(.RESULT,VST)
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Patient Education Found"
 Q "~@"_$NA(@TARGET)
GETPTED(RETURN,VIEN) ;return every education topic for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,BTIU,LINE,NUM
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPED("AD",VIEN,IEN)) Q:'IEN  D
 . S CNT=$G(CNT)+1,NUM=$G(NUM)+1
 . K BTIU D ENP^XBDIQ1(9000010.16,IEN,".01;.05:.08;.11","BTIU(","I")
 . S LINE="  "_$$EDABBRV(BTIU(.01,"I"))_": "_BTIU(.08)_" min.; "
 . S LINE=LINE_BTIU(.07)_"; Understanding-"_BTIU(.06)
 . S RETURN(CNT)=$J(NUM,2)_LINE
 . D SUBTOPIC(IEN)
 . I $G(BTIU(.11))'=""  D
 .. S CNT=CNT+1
 .. S RETURN(CNT)="  Comment: "_$E(BTIU(.11),1,60)
 Q
 ;
EDABBRV(X) ; -- returns education topic abbreviation
 Q $$GET1^DIQ(9999999.09,X,1)
 ;
SUBTOPIC(IEN) ;Get the subtopics for this patient ed
 N SUB,TOPIC,LEVEL,LINE
 S SUB=0 F  S SUB=$O(^AUPNVPED(IEN,1,SUB)) Q:SUB=""  D
 .S TOPIC=$P($G(^AUPNVPED(IEN,1,SUB,0)),U,1)
 .S CNT=CNT+1
 .S RETURN(CNT)="     "_TOPIC
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
