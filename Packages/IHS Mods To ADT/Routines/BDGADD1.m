BDGADD1 ; IHS/ANMC/LJF - A&D DETAILED PRINT CONT. ;  [ 07/01/2002  10:18 AM ]
 ;;5.3;PIMS;**1003,1013**;MAY 28, 2004
 ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 adjusted code under Deaths to match other sections
 ;                                 added code for mulitple admits and discharges
 ;ihs/cmi/maw  9/14/2011 PATCH 1013 added day surgery
 ;
PATDATA ;EP; build display lines for patient data
 ; called by INIT^BDGADD
 ;
 D ADMITS,DEATHS,TRANSFER
 D ^BDGADD2                    ;day surgery listing
 Q
 ;
ADMITS ; build array of admits
 ;    first for inpatients, then observations, then newborns
 NEW SUB,SUB2,TITLE,TITLE2,X,NAME,DFN,IFN,LINE,DATA
 F SUB="ADMIT","DSCH" D
 . F SUB2="I","O","N","D" D
 .. ;
 .. ; display total admissions for category
 .. S TITLE=$S(SUB2="I":"Inpatient",SUB2="O":"Observation",SUB2="D":"Day Surgery",1:"Newborn")
 .. S TITLE2=$S(SUB="ADMIT":" Admissions:",1:" Discharges:")
 .. S X=$$COUNT(SUB,SUB2) I X>0 D SET("",.VALMCNT),SET($$PAD(TITLE_TITLE2,25)_X,.VALMCNT)
 .. ;
 .. ; loop through admits
 .. S NAME=0 F  S NAME=$O(^TMP("BDGAD",$J,SUB,SUB2,NAME)) Q:NAME=""  D
 ... S DFN=0 F  S DFN=$O(^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN)) Q:'DFN  D
 .... ;
 .... ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 add extra loop using IFN
 .... ;S DATA=^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN)
 .... S IFN=0 F  S IFN=$O(^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN,IFN)) Q:'IFN  D
 ..... S DATA=^TMP("BDGAD",$J,SUB,SUB2,NAME,DFN,IFN)
 ..... ;
 ..... ; PATCH 1003 added extra . to lines below
 ..... S LINE=$E($$GET1^DIQ(2,DFN,.01),1,25)
 ..... S LINE=$$PAD(LINE,27)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)           ;chart
 ..... S LINE=$$PAD(LINE,35)_$P(DATA,U,4)                             ;age
 ..... S LINE=$$PAD(LINE,40)_$E($$GET1^DIQ(9000001,DFN,1118),1,15)    ;community
 ..... S LINE=$$PAD(LINE,58)_$$GET1^DIQ(9009016.5,+$P(DATA,U,2),.02)  ;ward
 ..... S LINE=$$PAD(LINE,65)_$$GET1^DIQ(45.7,+$P(DATA,U),99)          ;service
 ..... S LINE=$$PAD(LINE,72)_$E($P(DATA,U,3),1,18)                    ;provider
 ..... K BDGX S BDGX="BDGX" D PCP^BSDU1(DFN,.BDGX)                    ;pcp
 ..... S LINE=$$PAD(LINE,92)_$E($P($G(BDGX(1)),"/"),1,18)
 ..... ;
 ..... D SET(LINE,.VALMCNT)
 ;end of PATCH 1003 changes
 ;
 Q
 ;
TRANSFER ; loop through transfers (ward and service)
 NEW SUB,FILE,FIELD,TITLE,X,NAME,DFN,IFN,DATA
 ;
 F SUB="WARD","SERV" D
 . ;
 . ;ward/service abreviations file/field pairs
 . S FILE=$S(SUB="WARD":9009016.5,1:45.7),FIELD=$S(SUB="WARD":.02,1:99)
 . ;
 . ; display total transfers for category
 . S TITLE=$S(SUB="WARD":"Ward",1:"Service")
 . S X=$$COUNT2(SUB)
 . I X>0 D SET("",.VALMCNT),SET(TITLE_" Transfers: "_X,.VALMCNT)
 . ;
 . S NAME=0 F  S NAME=$O(^TMP("BDGAD",$J,SUB,NAME)) Q:NAME=""  D
 .. S DFN=0 F  S DFN=$O(^TMP("BDGAD",$J,SUB,NAME,DFN)) Q:'DFN  D
 ... S IFN=0 F  S IFN=$O(^TMP("BDGAD",$J,SUB,NAME,DFN,IFN)) Q:'IFN  D
 .... ;
 .... S DATA=^TMP("BDGAD",$J,SUB,NAME,DFN,IFN)
 .... ; old ward/srv -> new ward/srv
 .... S LINE=$$PAD($E(NAME,1,17),20)         ;name
 .... S LINE=LINE_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)   ;chart #
 .... S LINE=$$PAD(LINE,30)_$$GET1^DIQ(FILE,+$P(DATA,U),FIELD)
 .... S LINE=$$PAD(LINE,35)_"-> "_$$GET1^DIQ(FILE,$P(DATA,U,2),FIELD)
 .... D SET(LINE,.VALMCNT)
 Q
 ;
 ;
DEATHS ; Now display any deaths
 ;   display total # of deaths first
 NEW X,NAME,DFN,IFN,DATA,LINE
 ;
 ;S X=$$COUNT("DEATH","") I X>0 D SET($$PAD("Deaths:",25)_X,.VALMCNT)
 S X=$$COUNT("DEATH","") I X>0 D SET("",.VALMCNT),SET($$PAD("Deaths:",25)_X,.VALMCNT)
 ;
 S NAME=0 F  S NAME=$O(^TMP("BDGAD",$J,"DEATH",NAME)) Q:NAME=""  D
 . S DFN=0 F  S DFN=$O(^TMP("BDGAD",$J,"DEATH",NAME,DFN)) Q:'DFN  D
 .. ;
 .. ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 changed columns around to match other sections
 .. S DATA=^TMP("BDGAD",$J,"DEATH",NAME,DFN)
 .. S LINE=$$PAD($E($$GET1^DIQ(2,DFN,.01),1,17),25)                 ;name
 .. S LINE=$$PAD(LINE,27)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)            ;chart#
 .. S LINE=$$PAD(LINE,35)_$P(DATA,U,4)                              ;age
 .. S LINE=$$PAD(LINE,40)_$E($$GET1^DIQ(9000001,DFN,1118),1,20)     ;com
 .. S LINE=$$PAD(LINE,58)_$$GET1^DIQ(9009016.5,+$P(DATA,U,2),.02)   ;wd
 .. ;S LINE=$$PAD(LINE,70)_$$GET1^DIQ(45.7,+$P(DATA,U,2),99)        ;srv
 .. S LINE=$$PAD(LINE,65)_$$GET1^DIQ(45.7,+$P(DATA,U),99)           ;srv; PATCH 1003 fixed code
 .. S LINE=$$PAD(LINE,72)_$E($P(DATA,U,3),1,20)                     ;prov
 .. ; PATCH 1003 - 2 new lines
 .. K BDGX S BDGX="BDGX" D PCP^BSDU1(DFN,.BDGX)                    ;pcp
 .. S LINE=$$PAD(LINE,92)_$E($P($G(BDGX(1)),"/"),1,18)
 .. ;
 .. D SET(LINE,.VALMCNT)
 Q
 ;
COUNT(X,X1) ; returns # of events based on type sent in X and X1
 ; X can = "ADMIT" or "DSCH" or "DEATH"
 ; X1 can = "O" or "I" or "N" or "" if X="DEATH"
 ;
 NEW PIECE,SV,N,COUNT,SNM
 S PIECE=$S(X="ADMIT":3,X="DSCH":4,1:7)     ;piece in ^BDGCTX node
 S SV=0 F  S SV=$O(^BDGCTX(SV)) Q:'SV  D
 . S SNM=$$GET1^DIQ(45.7,SV,.01)
 . I X'="DEATH",X1="I" Q:SNM="NEWBORN"  Q:SNM["OBSERVATION"  Q:SNM="DAY SURGERY"
 . I X'="DEATH",X1="O" Q:SNM'["OBSERVATION"
 . I X'="DEATH",X1="N" Q:SNM'="NEWBORN"
 . I X'="DEATH",X1="D" Q:SNM'="DAY SURGERY"
 . ;
 . S N=$G(^BDGCTX(SV,1,BDGT,0))
 . S COUNT=$G(COUNT)+$P(N,U,PIECE)+$P(N,U,PIECE+10)
 Q +$G(COUNT)
 ;
COUNT2(X) ; returns # of events based on type sent in X and X1
 ; X can = "WARD" or "SERV"
 ;
 NEW GBL,SV,N,COUNT
 S GBL=$S(X="WARD":"^BDGCWD",1:"^BDGCTX")
 S SV=0 F  S SV=$O(@GBL@(SV)) Q:'SV  D
 . S N=$G(@GBL@(SV,1,BDGT,0))
 . S COUNT=$G(COUNT)+$P(N,U,5)+$P(N,U,15)
 Q +$G(COUNT)
 ;
SET(LINE,NUM) ; put display line into array
 D SET^BDGADD(LINE,.NUM)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
