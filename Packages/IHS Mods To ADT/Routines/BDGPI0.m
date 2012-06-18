BDGPI0 ; IHS/ANMC/LJF - PATBDGNT INQUIRY CONTINUED ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
SECTION4 ;EP; called by SECTION4^BDGPI
 ; display scheduled visit info
 NEW BDGDT,BDGN,LINE,X
 S BDGDT=$$FMADD^XLFDT(DT,-7)                    ;start up to a week ago
 I '$O(^BDGSV("AD",DFN,BDGDT)) S BDGS=BDGS-1 Q   ;nothing scheduled
 ;
 S LINE="("_BDGS_") Scheduled Visits - "
 D SET^BDGPI("",.VALMCNT,BDGS,BDGI),SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 ;
 F  S BDGDT=$O(^BDGSV("AD",DFN,BDGDT)) Q:'BDGDT  D
 . S BDGN=0 F  S BDGN=$O(^BDGSV("AD",DFN,BDGDT,BDGN)) Q:'BDGN  D
 .. S LINE="Scheduled "_$$GET1^DIQ(9009016.7,BDGN,.03)   ;visit type
 .. I $$GET1^DIQ(9009016.7,BDGN,.15)="YES" S LINE=LINE_" (SDA)"
 .. S LINE=$$PAD(LINE,26)_" - Expected on "_$$GET1^DIQ(9009016.7,BDGN,.02)
 .. S LINE=LINE_" by "_$$GET1^DIQ(9009016.7,BDGN,.04)  ;auth provider
 .. D SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 .. S X=$$GET1^DIQ(9009016.7,BDGN,.03,"I") I X]"" S X="SV"_X D @X
 Q
 ;
SVA ; admission specific info
 NEW LINE
 S LINE=$$SP(5)_$$GET1^DIQ(9009016.7,BDGN,.09)                 ;ward
 S LINE=LINE_" / "_$$GET1^DIQ(9009016.7,BDGN,.08)              ;service
 S LINE=LINE_" Expected LOS: "_$$GET1^DIQ(9009016.7,BDGN,.13)  ;los
 S LINE=$$PAD(LINE,50)_$$GET1^DIQ(9009016.7,BDGN,.16)          ;status
 D SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 Q
 ;
SVD ; day surgery specific info
 NEW LINE
 S LINE=$$SP(5)_"For Surgery on "_$$GET1^DIQ(9009016.7,BDGN,.14)
 S LINE=$$PAD(LINE,30)_$$GET1^DIQ(9009016.7,BDGN,.121)  ;service
 S LINE=$$PAD(LINE,50)_$$GET1^DIQ(9009016.7,BDGN,.16)
 D SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 Q
 ;
SVO ; outpatient specific info
 NEW LINE
 S LINE=$$SP(5)_$$GET1^DIQ(9009016.7,BDGN,.11)    ;clinic
 S LINE=$$PAD(LINE,50)_$$GET1^DIQ(9009016.7,BDGN,.16)
 D SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 Q
 ;
SECTION6 ;EP; called by SECTION6^BDGPI
 ; displays incomplete chart status info
 I '$O(^BDGIC("B",DFN)) S BDGS=BDGS-1 Q   ;chart never incomplete
 ;
 NEW BDGN,FIRST,LINE
 S BDGN=0,FIRST=1 F  S BDGN=$O(^BDGIC("B",DFN,BDGN)) Q:'BDGN  D
 . I $$GET1^DIQ(9009016.1,BDGN,.14)]"" Q    ;already completed
 . I $$GET1^DIQ(9009016.1,BDGN,.17)]"" Q    ;deleted-entered in error
 . I $$GET1^DIQ(9009016.1,BDGN,.03)="" Q    ;no visit pointer
 . ;
 . I FIRST D
 .. S LINE="("_BDGS_") Active Incomplete Chart - "
 .. D SET^BDGPI("",.VALMCNT,BDGS,BDGI)
 .. D SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 .. S FIRST=0
 . ;
 . S TYPE=$$GET1^DIQ(9009016.1,BDGN,.0392)
 . S LINE=$$SP(3)_$S(TYPE["DAY":"DAY SURGERY",1:"INPATIENT")_" CHART: "
 . ;  get discharge or surgery date
 . S LINE=LINE_$$GET1^DIQ(9009016.1,BDGN,$S(TYPE["DAY":.05,1:.02))
 . S LINE=$$PAD(LINE,40)_"Service - "
 . ;  get inpatient or surgical service
 . S LINE=LINE_$$GET1^DIQ(9009016.1,BDGN,$S(TYPE["DAY":.06,1:.04))
 . D SET^BDGPI(LINE,.VALMCNT,BDGS,BDGI)
 ;
 I FIRST S BDGS=BDGS-1   ;if no active ic charts found
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
