BTIULO3 ; IHS/ITSC/LJF - VISIT OBJECTS FOR EHR ;01-Jun-2010 09:18;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1004,1006**;NOV 04, 2004
 ;Added calls for EHR 1.1 visit creation
 ;Patch 1006 - updated error return if visit not found
 ;
VIMM(TARGET) ; returns immunizations given for current vuecentric visit context
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,CNT,RESULT,X
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETIMM(.RESULT,VST)
 ;
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Immunizations Found"
 Q "~@"_$NA(@TARGET)
 ;
GETIMM(RETURN,VIEN) ;return every immunization for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,CNT,SERIES
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVIMM("AD",VIEN,IEN)) Q:'IEN  D
 . S CNT=$G(CNT)+1
 . S SERIES=$$GET1^DIQ(9000010.11,IEN,.04)
 . S RETURN(CNT)=$$GET1^DIQ(9000010.11,IEN,.01)_$S(SERIES]"":" ("_SERIES_")",1:"")
 Q
VLAB(TARGET) ; returns resulted labs for current vuecentric visit context
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETLAB(.RESULT,VST)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Lab Results Found"
 Q "~@"_$NA(@TARGET)
 ;
GETLAB(RETURN,VIEN) ;return every resulted lab for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,CNT,RESULT
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVLAB("AD",VIEN,IEN)) Q:'IEN  D
 . S CNT=$G(CNT)+1
 . S RESULT=$$GET1^DIQ(9000010.09,IEN,.04) Q:RESULT=""     ;not resulted yet
 . S RETURN(CNT)=$$GET1^DIQ(9000010.09,IEN,.01)_" ("_RESULT_")"
 Q
VSKIN(TARGET) ; returns skin tests for current vuecentric visit context
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variables" Q "~@"_$NA(@TARGET)
 NEW VST,I,X,CNT,RESULT
 S CNT=0
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETSKIN(.RESULT,VST)
 K @TARGET
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Skin Tests Found"
 Q "~@"_$NA(@TARGET)
 ;
GETSKIN(RETURN,VIEN) ;return every skin test for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,CNT,BTIU,LINE
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVSK("AD",VIEN,IEN)) Q:'IEN  D
 . S CNT=$G(CNT)+1 D
 .. K BTIU D ENP^XBDIQ1(9000010.12,IEN,".03:.06","BTIU(")
 .. I BTIU(.04)="" S LINE="Placed on "_BTIU(.03) Q
 .. S LINE=$$PAD($J(BTIU(.04),12)_"  "_BTIU(.05),25)
 .. S LINE=LINE_"Date Read: "_BTIU(.06)
 . S RETURN(CNT)=$$PAD($$GET1^DIQ(9000010.12,IEN,.01)_":",12)_LINE
 . Q
VPRC(TARGET,MULTI) ; returns procedures for current vuecentric visit context
 ; MULTI=0 return one line of procedure names; MULTI=1 return 1 line per procedure
 I $T(GETVAR^CIAVMEVT)="" S @TARGET@(1,0)="Invalid context variabled" Q "~@"_$NA(@TARGET)
 NEW VST,I,CNT,RESULT,X
 S VST=$$GETVAR^CIAVMEVT("ENCOUNTER.ID.ALTERNATEVISITID",,"CONTEXT.ENCOUNTER")
 I VST="" S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 S X="BEHOENCX" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^BEHOENCX(DFN,VST) I VST<1 S @TARGET@(1,0)="Invalid visit" Q "~@"_$NA(@TARGET)
 ;S X="CIAVCXEN" X ^%ZOSF("TEST") I $T S VST=+$$VSTR2VIS^CIAVCXEN(DFN,VST) I VST<1 Q
 D GETPRC(.RESULT,VST,MULTI)
 ;
 K @TARGET S CNT=0
 S I=0 F  S I=$O(RESULT(I)) Q:'I  D
 .S CNT=CNT+1
 .S @TARGET@(CNT,0)=RESULT(I)
 I 'CNT S @TARGET@(1,0)="No Procedures Found"
 Q "~@"_$NA(@TARGET)
 ;
GETPRC(RETURN,VIEN,MULTI) ;return every procedure for current visit
 ; VISIT=Visit IEN
 ;
 NEW IEN,CNT,BTIU,LINE
 K RETURN
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPRC("AD",VIEN,IEN)) Q:'IEN  D
 . I 'MULTI S RETURN(1)=$G(RETURN(1))_$$GET1^DIQ(9000010.08,IEN,.04)_"; " Q
 . S CNT=$G(CNT)+1
 . K BTIU D ENP^XBDIQ1(9000010.08,IEN,".06;.11;1204","BTIU(")
 . S LINE=" on "_BTIU(.06)_" by "_$S(BTIU(.11)]"":BTIU(.11),1:BTIU(1204))
 . S RETURN(CNT)=$$GET1^DIQ(9000010.08,IEN,.04)_LINE
 ;
 I 'MULTI,$D(RETURN(1)) S RETURN(1)=$E(RETURN(1),1,$L(RETURN(1))-2)   ;take off last "; "
 Q
 ;
PAD(DATA,LENGTH) ; pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; pad spaces
 Q $$PAD(" ",NUM)
