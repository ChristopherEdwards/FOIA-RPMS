BDGADS1 ; IHS/ANMC/LJF - A&D SUMMARY PRINT CONT. ; 
 ;;5.3;PIMS;**1003,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 added code for multiple admits or discharges
 ;
PATDATA ;EP; build display lines for patient data
 ; called by INIT^BDGADS
 ;
 D ADMITS,TRANSFER,DEATHS
 D ^BDGADS2                    ;day surgery listing
 Q
 ;
ADMITS ; build array of admits and discharges
 NEW SUB2,X,LINE
 I '$D(^TMP("BDGAD",$J,"ADMIT")),'$D(^TMP("BDGAD",$J,"DSCH")) Q
 ;    first for inpatients, then observations, then newborns
 F SUB2="I","O","N","D" D
 . ;
 . I '$D(^TMP("BDGAD",$J,"ADMIT",SUB2)),'$D(^TMP("BDGAD",$J,"DSCH",SUB2)) Q
 . ;
 . ; print heading
 . S X=$S(SUB2="I":"Inpatient",SUB2="O":"Observation",SUB2="D":"Day Surgery",1:"Newborn")
 . S LINE=$$PAD($$SP(5)_X_" Admissions",45)_X_" Discharges"
 . D SET(LINE,.VALMCNT)
 . S LINE=$$PAD($$REPEAT^XLFSTR("-",36),40)_$$REPEAT^XLFSTR("-",36)
 . D SET(LINE,.VALMCNT)
 . ;
 . ;
 . ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 rewrote this section to add extra loop using IFN
 . ; loop through admits, then discharges to set up 2 columns
 . NEW ADMIT,DSCH,COUNT,NAME,DFN,DATA,IFN  ;PATCH 1003 added IFN
 . F SUB="ADMIT","DSCH" D
 .. S COUNT=0
 .. S NAME=0 F  S NAME=$O(^TMP("BDGAD",$J,SUB,SUB2,NAME)) Q:NAME=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN)) Q:'DFN  D
 .... ;
 .... ;S DATA=^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN)
 .... S IFN=0 F  S IFN=$O(^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN,IFN)) Q:'IFN  D
 ..... S DATA=^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN,IFN)
 ..... ;
 ..... ; PATCH 1003 added extra .
 ..... S LINE=$$GET1^DIQ(45.7,+$P(DATA,U),99)                       ;service abbrev
 ..... S LINE=$$PAD(LINE,6)_$$GET1^DIQ(9009016.5,$P(DATA,U,2),.02)  ;ward
 ..... S LINE=$$PAD(LINE,12)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)         ;chart #
 ..... S LINE=$$PAD(LINE,20)_$E(NAME,1,18)                          ;name
 ..... S COUNT=COUNT+1,@SUB@(COUNT)=LINE
 . ;end of PATCH 1003 changes
 . ;
 . ; Then put both columns into display array
 . F COUNT=1:1 Q:('$D(ADMIT(COUNT))&'$D(DSCH(COUNT)))  D
 . . S LINE=$$PAD($G(ADMIT(COUNT)),40)_$G(DSCH(COUNT))
 .. D SET(LINE,.VALMCNT)
 ;
 Q
 ;
TRANSFER ; loop through transfers (ward and service)
 NEW LINE,WARD,SERV,COUNT,FILE,FIELD,NAME,DFN,IFN
 I '$D(^TMP("BDGAD",$J,"WARD")),'$D(^TMP("BDGAD",$J,"SERV")) Q
 ;
 ;    display headings
 S LINE=$$PAD($$SP(5)_"Ward Transfers",45)_"Service Transfers"
 D SET(LINE,.VALMCNT)
 S LINE=$$PAD($$REPEAT^XLFSTR("-",36),40)_$$REPEAT^XLFSTR("-",36)
 D SET(LINE,.VALMCNT)
 ;
 F SUB="WARD","SERV" D
 . S COUNT=0
 . ;
 . ;ward/service abreviations file/field pairs
 . S FILE=$S(SUB="WARD":9009016.5,1:45.7),FIELD=$S(SUB="WARD":.02,1:99)
 . ;
 . S NAME=0 F  S NAME=$O(^TMP("BDGAD",$J,SUB,NAME)) Q:NAME=""  D
 .. S DFN=0 F  S DFN=$O(^TMP("BDGAD",$J,SUB,NAME,DFN)) Q:'DFN  D
 ... S IFN=0 F  S IFN=$O(^TMP("BDGAD",$J,SUB,NAME,DFN,IFN)) Q:'IFN  D
 .... ;
 .... S DATA=^TMP("BDGAD",$J,SUB,NAME,DFN,IFN)
 .... ; old ward/srv -> new ward/srv
 .... S LINE=$$GET1^DIQ(FILE,+$P(DATA,U),FIELD)
 .... S LINE=$$PAD(LINE,5)_"-> "_$$GET1^DIQ(FILE,$P(DATA,U,2),FIELD)
 .... S LINE=$$PAD(LINE,13)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)      ;chart #
 .... S LINE=$$PAD(LINE,21)_$E(NAME,1,17)                       ;name
 .... S COUNT=COUNT+1,@SUB@(COUNT)=LINE
 ;
 ; Then put both columns into display array
 F COUNT=1:1 Q:'$D(WARD(COUNT))&'$D(SERV(COUNT))  D
 . S LINE=$$PAD($G(WARD(COUNT)),40)_$G(SERV(COUNT))
 . D SET(LINE,.VALMCNT)
 Q
 ;
 ;
DEATHS ; Now display any deaths
 NEW NAME,DFN,DATA,LINE
 Q:'$D(^TMP("BDGAD",$J,"DEATH"))
 ;
 D SET($$SP(45)_"Deaths",.VALMCNT)
 D SET($$SP(40)_$$REPEAT^XLFSTR("-",36),.VALMCNT)
 ;
 S NAME=0 F  S NAME=$O(^TMP("BDGAD",$J,"DEATH",NAME)) Q:NAME=""  D
 . S DFN=0 F  S DFN=$O(^TMP("BDGAD",$J,"DEATH",NAME,DFN)) Q:'DFN  D
 .. ;
 .. S DATA=^TMP("BDGAD",$J,"DEATH",NAME,DFN)
 .. S LINE=$$SP(40)_$$GET1^DIQ(45.7,+DATA,99)   ;sserv abbrev
 .. S LINE=$$PAD(LINE,47)_$$GET1^DIQ(9009016.5,$P(DATA,U,2),.02)  ;ward
 .. S LINE=$$PAD(LINE,54)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)      ;chart #
 .. S LINE=$$PAD(LINE,62)_$E(NAME,1,17)                       ;name
 .. D SET(LINE,.VALMCNT)
 Q
 ;
SET(LINE,NUM) ; put display line into array
 D SET^BDGADS(LINE,.NUM)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
