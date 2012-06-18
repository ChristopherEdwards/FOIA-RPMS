BDGPCCE1 ; IHS/ANMC/LJF - BUILD DISPLAY SCREENS FOR CODE ;  [ 06/19/2002  11:37 AM ]
 ;;5.3;PIMS;**1008**;APR 26, 2002
 ;
 ;cmi/anch/maw 12/7/2007 PATCH 1008 added code set versioning ADMIT,OP
 ;
 ;6/19/2002 LJF8 next line added per Linda
 S IORVON=$G(IORVON),IORVOFF=$G(IORVOFF),IOUON=$G(IOUON),IOUOFF=$G(IOUOFF)    ;IHS/ANMC/LJF 6/18/2002 to prevent undef if device not set up completely
 D ADMIT,POV,OP,PROV,OTHER Q
 ;
ADMIT ; build display of admit data   
 NEW LINE,VH
 S VH=$O(^AUPNVINP("AD",BDGV,0)) I 'VH D  Q
 . D SET("** ERROR!  Cannot find V Hospitalization Entry! **",.VALMCNT)
 ;
 D SET(IORVON_"General Admission Data"_IORVOFF,.VALMCNT)
 S LINE=$$PAD(IOUON_"Admission",42)_"Discharge"_IOUOFF
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$PAD($$GET1^DIQ(9000010,BDGV,.01),38)
 S LINE=LINE_$$GET1^DIQ(9000010.02,VH,.01)
 D SET(LINE,.VALMCNT)     ;admit and disch dates
 ;
 S LINE=$$PAD($$GET1^DIQ(9000010.02,VH,.04),38)
 S LINE=LINE_$$GET1^DIQ(9000010.02,VH,.05)
 D SET(LINE,.VALMCNT)     ;admit and disch services
 ;
 S LINE=$$GET1^DIQ(9000010.02,VH,.07)_" ("
 S X=$$GET1^DIQ(9000010.02,VH,.07,"I")
 S LINE=$$PAD(LINE_$$GET1^DIQ(405.1,X,9999999.1)_")",38)
 S LINE=LINE_$$GET1^DIQ(9000010.02,VH,.06)_" ("
 S X=$$GET1^DIQ(9000010.02,VH,.06,"I")
 S LINE=LINE_$$GET1^DIQ(405.1,X,9999999.1)_")"
 D SET(LINE,.VALMCNT)      ;admit and disch types (IHS)
 ;
 S LINE=$$GET1^DIQ(9000010.02,VH,6101)
 I LINE]"" S LINE=LINE_" ("_$$GET1^DIQ(9000010.02,VH,6101,"I")_")"
 S LINE=$$PAD(LINE,38)_$$GET1^DIQ(9000010.02,VH,.09)
 D SET(LINE,.VALMCNT)      ;admit type (ub92) & transfer facility
 ;
 S LINE=$$GET1^DIQ(9000010.02,VH,6102)
 I LINE]"" S LINE=LINE_" ("_$$GET1^DIQ(9000010.02,VH,6102,"I")_")"
 S LINE=$$PAD(LINE,38)_$$GET1^DIQ(9000010.02,VH,6103)
 S LINE=LINE_" ("_$$GET1^DIQ(9000010.02,VH,6103,"I")_")"
 D SET(LINE,.VALMCNT)     ;admit source & disch status (UB92 style)
 ;
 S LINE="DX upon Admission: ",X=$O(^DGPM("AVISIT",BDGV,0))
 I X S LINE=LINE_$$GET1^DIQ(405,X,.1)
 D SET(LINE,.VALMCNT)     ;free text admitting dx
 ;
 S LINE=$$SP(5)_"Coded Adm DX: "_$$GET1^DIQ(9000010.02,VH,.12)
 I $L(LINE)>10 S LINE=LINE_" - "
 ;S LINE=LINE_$$GET1^DIQ(80,+$$GET1^DIQ(9000010.02,VH,.12,"I"),3)
 S LINE=LINE_$P($$ICDDX^ICDCODE(+$$GET1^DIQ(9000010.02,VH,.12,"I")),U,4)
 D SET(LINE,.VALMCNT)     ;admitting dx
 ;
 S LINE=$$SP(14)_"DRG: "_$$GET1^DIQ(9000010,BDGV,.34)
 I $L(LINE)>9 S LINE=LINE_" - "
 S LINE=LINE_$G(^ICD(+$$GET1^DIQ(9000010,BDGV,.34,"I"),1,1,0))
 D SET(LINE,.VALMCNT)     ;visit DRG
 ;
 S LINE=$$SP(7)_"# Consults: "_$$GET1^DIQ(9000010.02,VH,.08)
 D SET(LINE,.VALMCNT)
 D SET("",.VALMCNT)   ;blank line between sections
 Q
 ;
POV ; build diagnosis display
 NEW IEN,LINE,X,Y
 I '$D(^AUPNVPOV("AD",BDGV)) D  Q
 . D SET("** No Diagnoses Entered for Visit! **",.VALMCNT)
 ;
 D SET("",.VALMCNT),SET(IORVON_"POV (Diagnoses)"_IORVOFF,.VALMCNT)
 S IEN=0 F  S IEN=$O(^AUPNVPOV("AD",BDGV,IEN)) Q:'IEN  D
 . S LINE=$$GET1^DIQ(9000010.07,IEN,.01)
 . S LINE=$$PAD(LINE,8)_"("_$$GET1^DIQ(9000010.07,IEN,.12,"I")_") "
 . S LINE=LINE_$$GET1^DIQ(9000010.07,IEN,.019)
 . D SET(LINE,.VALMCNT)    ;icd code, prim/sec and icd description
 . ;
 . D SET($$SP(12)_$$GET1^DIQ(9000010.07,IEN,.04),.VALMCNT)  ;prov narr
 . ;
 . S X=$$GET1^DIQ(9000010.07,IEN,.06),Y=$$GET1^DIQ(9000010.07,IEN,.07)
 . I (X]"")!(Y]"") D
 .. D SET($$PAD($$SP(12)_"Modifier: "_X,38)_"Cause of DX: "_Y,.VALMCNT)
 . ;
 . S X=$$GET1^DIQ(9000010.07,IEN,.09) I X]"" D
 .. S LINE=$$PAD($$SP(12)_"E-Code: "_X,38)_$$GET1^DIQ(9000010.07,IEN,.13)
 .. D SET(LINE,.VALMCNT)   ;e-code & date of injury
 .. D SET($$SP(12)_"Place of Accident: "_$$GET1^DIQ(9000010.07,IEN,.11),.VALMCNT)
 .. ;
 .. D SET("",.VALMCNT)   ;blank line between dx
 Q
 ;
OP ; build list of procedures
 NEW IEN,LINE,X,Y
 I '$D(^AUPNVPRC("AD",BDGV)) Q   ;no procedures
 ;
 D SET("",.VALMCNT),SET(IORVON_"Procedures"_IORVOFF,.VALMCNT)
 ;
 S IEN=0 F  S IEN=$O(^AUPNVPRC("AD",BDGV,IEN)) Q:'IEN  D
 . S LINE=$$PAD($$GET1^DIQ(9000010.08,IEN,.01),10)
 . S X=$$GET1^DIQ(9000010.08,IEN,.07)   ;princ procedure?
 . S LINE=$$PAD(LINE_$S(X="YES":" (P)",1:""),17)
 . S LINE=LINE_$$GET1^DIQ(9000010.08,IEN,.019)
 . D SET(LINE,.VALMCNT)     ;icd code, princ?, icd description
 . ;
 . D SET($$SP(10)_$$GET1^DIQ(9000010.08,IEN,.04),.VALMCNT)  ;prov narr
 . ;
 . S LINE=$$GET1^DIQ(9000010.08,IEN,.16)_$$GET1^DIQ(9000010.08,IEN,.17)
 . S LINE=LINE_$$SP(3)_$$GET1^DIQ(9000010.08,IEN,.1609)
 . S LINE=$$PAD("CPT: "_LINE,50)_"Infection? "
 . S LINE=LINE_$$GET1^DIQ(9000010.08,IEN,.08)
 . D SET(LINE,.VALMCNT)           ;CPT codes & infection question
 . ;
 . S LINE="Date: "_$$GET1^DIQ(9000010.08,IEN,.06)
 . S X=$$GET1^DIQ(9000010.08,IEN,.05)
 . I X]"" D
 .. S Y=$$GET1^DIQ(9000010.08,IEN,.05,"I")
 .. ;S X=X_$$SP(3)_$$GET1^DIQ(80,Y,3)
 .. S X=X_$$SP(3)_$P($$ICDDX^ICDCODE(Y),U,4)
 . D SET($$PAD(LINE,30)_"Dx: "_X,.VALMCNT)  ;date & dx
 . ;
 . S LINE="Operating: "_$$GET1^DIQ(9000010.08,IEN,.11)
 . S X=$$GET1^DIQ(9000010.08,IEN,.12)
 . I X]"" S LINE=$$PAD(LINE,38)_"Anesthesiologist: "_X
 . D SET(LINE,.VALMCNT)        ;providers-operating & anesthesia
 . ;
 . S X=$$GET1^DIQ(9000010.08,IEN,.14)
 . I X="YES" D
 .. S LINE="Elapsed Time (Anes): "_$$GET1^DIQ(9000010.08,IEN,.13)
 .. S LINE=$$PAD(LINE,38)_"ASA-PS Class: "_$$GET1^DIQ(9000010.08,IEN,.15)
 .. D SET(LINE,.VALMCNT)    ;anesthesia data
 . ;
 . D SET("",.VALMCNT)   ;blank line between procedures
 Q
 ;
PROV ; build display of providers
 NEW IEN,LINE,X,Y
 I '$D(^AUPNVPRV("AD",BDGV)) D  Q
 . D SET("** No Providers Entered for Visit! **",.VALMCNT)
 ;
 D SET("",.VALMCNT),SET(IORVON_"Providers"_IORVOFF,.VALMCNT)
 S IEN=0 F  S IEN=$O(^AUPNVPRV("AD",BDGV,IEN)) Q:'IEN  D
 . S LINE=$$PAD($$GET1^DIQ(9000010.06,IEN,.01),37)   ;prov name
 . S LINE=LINE_$$GET1^DIQ(9000010.06,IEN,.019)       ;prov code
 . S X=$$GET1^DIQ(9000010.06,IEN,.04)                ;prim/sec
 . S Y=$$GET1^DIQ(9000010.06,IEN,.05)                ;atten/oper/cons
 . S LINE=$$PAD(LINE,50)_X_$S(Y]"":"/"_Y,1:"")
 . D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 Q
 ;
OTHER ; build display of all other PCC data for patient's visit
 NEW FILE,GLOBAL,IEN,LINE,X,Y,NAME
 S FILE=9000010
 F  S FILE=$O(^DIC(FILE)) Q:'FILE  Q:(FILE>9000010.9999)  D
 . Q:FILE=9000010.02  Q:FILE=9000010.06  Q:FILE=9000010.07
 . Q:FILE=9000010.08
 . S GLOBAL=$G(^DIC(FILE,0,"GL")) Q:GLOBAL=""
 . S GLOBAL=$P(GLOBAL,"(")            ;strip off parens for indirection
 . S NAME=$P($P(^DIC(FILE,0),U),"V ",2)
 . ;
 . I $D(@GLOBAL@("AD",BDGV)) D SET("",.VALMCNT),SET(IORVON_NAME_IORVOFF,.VALMCNT)
 . ;
 . S IEN=0 F  S IEN=$O(@GLOBAL@("AD",BDGV,IEN)) Q:'IEN  D
 .. S LINE=$$GET1^DIQ(FILE,IEN,.01)
 .. ;
 .. ;  do CPT file differently
 .. I NAME="CPT" D  Q
 ... S LINE=LINE_$$GET1^DIQ(FILE,IEN,.08)_$$SP(4)
 ... S X=$$GET1^DIQ(FILE,IEN,.16)       ;quantity
 ... S LINE=LINE_"("_$S(X="":1,1:X)_")  "
 ... S LINE=LINE_$$GET1^DIQ(FILE,IEN,.019)   ;cpt short name
 ... D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 .. ;
 .. S LINE=LINE_$$SP(3)_$$GET1^DIQ(FILE,IEN,.04)
 .. D SET(LINE,.VALMCNT),SET("",.VALMCNT)
 Q
 ;
SET(DATA,NUM) ; puts display data into array
 S NUM=NUM+1
 S ^TMP("BDGPCCE",$J,NUM,0)=DATA
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
