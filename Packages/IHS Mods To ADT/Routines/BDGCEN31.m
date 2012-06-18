BDGCEN31 ; IHS/ANMC/LJF - BED MOVEMENT LISTING CONT. ;  [ 06/20/2002  12:59 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 ;
LOOP ; initialize subtotals for wards
 NEW WARD,I,WARD,CHANGE,CHANGENB,BDGI,SUB,HEADING
 ;
 ; set ward array
 S WARD=0 F  S WARD=$O(^DIC(42,WARD)) Q:'WARD  D
 . Q:'$D(^BDGWD(WARD))
 . Q:$$GET1^DIQ(9009016.5,WARD,.02)="INACTIVE"
 . F I="A","T","D" S BDGSUB($$GET1^DIQ(42,WARD,.01),I)=0
 ;
 ; newborn subtotals
 F I="A","T","D" S BDGNB(I)=0
 ;
 ; -- loop thru wards and patients found
 S WARD=0
 F  S WARD=$O(^TMP("BDGCEN31",$J,WARD)) Q:WARD=""  D
 . S (CHANGE,CHANGENB)=0                 ;initialize ward change totals
 . ;
 . D SET($$SP(72-$L(WARD)/2)_"*** "_WARD_" ***",.VALMCNT)  ;ward name
 . ;
 . ; loop thru 10 movement categories and display
 . F BDGI=1:1:10 D
 .. S SUB=$P($T(SUB+BDGI),";;",2),HEADING=$P($T(SUB+BDGI),";;",3)
 .. Q:'$D(^TMP("BDGCEN31",$J,WARD,SUB))   ;no data for mvmnt type
 .. D FIND
 .. ;
 . ; now display ward change totals
 . D SET("",.VALMCNT)
 . D SET($$SP(45)_"CENSUS CHANGE FOR WARD:  "_$J(CHANGE,3),.VALMCNT)
 . D SET("",.VALMCNT)
 . D SET($$SP(37)_"NEWBORN CENSUS CHANGE FOR WARD:  "_$J(CHANGENB,3),.VALMCNT)
 . D SET("",.VALMCNT)
 Q
 ;
 ;
FIND ; within ward loop by patient and display data
 NEW COUNT,DATE,NAME,DFN,LINE
 D SET("",.VALMCNT)
 D SET($$SP(80-$L(HEADING)/2)_HEADING,.VALMCNT)
 ;
 S (DATE,COUNT)=0
 F  S DATE=$O(^TMP("BDGCEN31",$J,WARD,SUB,DATE)) Q:'DATE  D
 . S NAME=0
 . F  S NAME=$O(^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME)) Q:NAME=""  D
 .. S DFN=0
 .. F  S DFN=$O(^TMP("BDGCEN31",$J,WARD,SUB,DATE,NAME,DFN)) Q:'DFN  D
 ... ;
 ... ; display patient data
 ... S LINE=$$PAD($P($$FMTE^XLFDT(DATE),":",1,2),22)
 ... S LINE=$$PAD(LINE_NAME,55)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)
 ... D SET(LINE,.VALMCNT)
 ... ;
 ... ; increment counts within type of movement
 ... S COUNT=$G(COUNT)+1
 ;
 ; increment counts for type of movement
 I BDGI=1 S BDGSUB(WARD,"A")=COUNT,CHANGE=CHANGE+COUNT
 I BDGI=2 S BDGSUB(WARD,"T")=BDGSUB(WARD,"T")+COUNT,CHANGE=CHANGE+COUNT
 I BDGI=3 S BDGSUB(WARD,"T")=BDGSUB(WARD,"T")-COUNT,CHANGE=CHANGE-COUNT
 ; discharges and deaths
 I (BDGI=4)!(BDGI=5) S BDGSUB(WARD,"D")=BDGSUB(WARD,"D")+COUNT,CHANGE=CHANGE-COUNT
 ;
 ; now newborn counts
 I BDGI=6 S BDGNB("A")=BDGNB("A")+COUNT,CHANGENB=CHANGENB+COUNT
 I BDGI=7 S BDGNB("T")=BDGNB("T")+COUNT,CHANGENB=CHANGENB+COUNT
 I BDGI=8 S BDGNB("T")=BDGNB("T")-COUNT,CHANGENB=CHANGENB-COUNT
 ;6/20/2002 LJF10 (per Linda) changed the plus sign to minus sign
 ;I (BDGI=9)!(BDGI=10) S BDGNB("D")=BDGNB("D")+COUNT,CHANGENB=CHANGENB+COUNT
 I (BDGI=9)!(BDGI=10) S BDGNB("D")=BDGNB("D")+COUNT,CHANGENB=CHANGENB-COUNT  ;IHS/ANMC/LJF 6/19/2002
 ;
 ; display subtotal for category within ward
 D SET($$SP(60)_"SUBTOTAL: "_$J(COUNT,3),.VALMCNT)
 ;
 Q
 ;
 ;
SET(LINE,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGCEN3",$J,NUM,0)=LINE
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
SUB ;;     
 ;;AMV1;;ADMISSIONS;;1;;
 ;;TI;;WARD TRANSFERS IN;;1;;
 ;;AMV2;;WARD TRANSFERS OUT;;-1;;
 ;;AMV3;;DISCHARGES;;-1;;
 ;;DT;;DEATHS;;-1;;
 ;;NBAMV1;;NEWBORN ADMISSIONS;;1;;
 ;;NBTI;;NEWBORN TRANSFERS IN;;1;;
 ;;NBAMV2;;NEWBORN TRANSFERS OUT;;-1;;
 ;;NBAMV3;;NEWBORN DISCHARGES;;-1;;
 ;;NBDT;;NEWBORN DEATHS;;-1;;
