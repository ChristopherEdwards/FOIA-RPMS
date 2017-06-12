APCDCAF7 ;IHS/OIT/LJF - NEW INCOMPLETE CHART EDIT OPTION
 ;;2.0;IHS PCC SUITE;**11**;MAY 14, 2009;Build 58
 ;
 ;
INIT ;EP; -- init variables and list array
 NEW CATG,LINE,FIELD,ITEM,X
 S VALMCNT=0 K APCDCDEV
 S LINE="Date Chart Tagged:  "_$$GET1^DIQ(9000095,APCDVSIT,.03)
 D SET(LINE,.VALMCNT)
 ;S LINE="Date Reviewed/Complete:  "_$$GET1^DIQ(9000095,APCDVSIT,.04)
 ;D SET(LINE,.VALMCNT)
 ;
 ; display ALL provider deficiencies
 NEW APCDN1,IENS,PROV,PROVN
 D SET("",.VALMCNT)
 D SET($$PAD($$PAD("Provider",25)_"Deficiencies",60)_"Status",.VALMCNT)
 D SET($$REPEAT^XLFSTR("=",75),.VALMCNT)
 ;
 S APCDN1=0 F  S APCDN1=$O(^AUPNCANT(APCDVSIT,12,APCDN1)) Q:'APCDN1  D
 . S IENS=APCDN1_","_APCDVSIT
 . Q:$$GET1^DIQ(9000095.12,IENS,.11,"I")'="P"
 . I '$G(APCDDALL),$$GET1^DIQ(9000095.12,IENS,.03)]"" Q  ;skip if resolved & not displaying all
 . I '$G(APCDDALL),$$GET1^DIQ(9000095.12,IENS,.08)]"" Q  ;skip if deleted & not displaying all
 . I '$G(APCDDALL),$$GET1^DIQ(9000095.12,IENS,.11,"I")'="P"
 . ;
 . S PROV=$$GET1^DIQ(9000095.12,IENS,.01,"I")             ;provider IEN
 . S PROVN=$$GET1^DIQ(9000095.12,IENS,.01)                ;provider name
 . ;
 . S LINE=$$PAD($E(PROVN,1,22),25)_$$GET1^DIQ(9000095.12,IENS,.02)   ;provider & deficiency
 . S LINE=$$PAD(LINE,60)_$$GET1^DIQ(9000095.12,IENS,.11)           ;resolution status
 . D SET(LINE,.VALMCNT)
 . S LINE=$$PAD("    Entered by: "_$$GET1^DIQ(9000095.12,IENS,.05),50)_"Date Entered: "_$$GET1^DIQ(9000095.12,IENS,.04)
 . D SET(LINE,.VALMCNT)
 . I $P(^AUPNCANT(APCDVSIT,12,APCDN1,0),U,10)]"" S LINE="Comments: "_$P(^AUPNCANT(APCDVSIT,12,APCDN1,0),U,10) D SET(LINE,.VALMCNT)
 . ;
 S APCDN1=0 F  S APCDN1=$O(^AUPNCANT(APCDVSIT,12,APCDN1)) Q:'APCDN1  D
 . S IENS=APCDN1_","_APCDVSIT
 . Q:$$GET1^DIQ(9000095.12,IENS,.11,"I")="P"
 . I '$G(APCDDALL),$$GET1^DIQ(9000095.12,IENS,.03)]"" Q  ;skip if resolved & not displaying all
 . I '$G(APCDDALL),$$GET1^DIQ(9000095.12,IENS,.08)]"" Q  ;skip if deleted & not displaying all
 . I '$G(APCDDALL),$$GET1^DIQ(9000095.12,IENS,.11,"I")'="P"
 . ;
 . S PROV=$$GET1^DIQ(9000095.12,IENS,.01,"I")             ;provider IEN
 . S PROVN=$$GET1^DIQ(9000095.12,IENS,.01)                ;provider name
 . ;
 . S LINE=$$PAD($E(PROVN,1,22),25)_$$GET1^DIQ(9000095.12,IENS,.02)   ;provider & deficiency
 . S LINE=$$PAD(LINE,60)_$$GET1^DIQ(9000095.12,IENS,.11)           ;resolution status
 . D SET(LINE,.VALMCNT)
 . S LINE=$$PAD("Entered by: "_$$GET1^DIQ(9000095.12,IENS,.05),50)_"Date Entered: "_$$GET1^DIQ(9000095.12,IENS,.04)
 . D SET(LINE,.VALMCNT)
 . I $P(^AUPNCANT(APCDVSIT,12,APCDN1,0),U,10)]"" S LINE="Comments: "_$P(^AUPNCANT(APCDVSIT,12,APCDN1,0),U,10) D SET(LINE,.VALMCNT)
 . ;
 I '$O(^AUPNCANT(APCDVSIT,12,0)) D SET($$SP(5)_"NO DEFICIENCIES ON RECORD",.VALMCNT)
 D SET("",.VALMCNT)
 ;PUT IN CHART AUDIT NOTES
 D SET("Chart Audit Notes",.VALMCNT)
 D SET($$REPEAT^XLFSTR("=",17),.VALMCNT)
 S APCDN1=0 F  S APCDN1=$O(^AUPNCANT(APCDVSIT,11,APCDN1)) Q:APCDN1'=+APCDN1  D
 .D SET(^AUPNCANT(APCDVSIT,11,APCDN1,0),.VALMCNT)
 Q
 ;
SET(DATA,COUNT) ; stuff data into display lie
 S COUNT=COUNT+1
 S APCDCDEV(COUNT,0)=DATA
 Q
 ;
PAD(D,L) ;EP pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; pad N number of spaces
 Q $$PAD(" ",N)
