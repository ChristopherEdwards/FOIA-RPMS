BDGCRB1 ; IHS/ANMC/LJF - A SHEET PRINT ;  [ 01/05/2005  10:25 AM ]
 ;;5.3;PIMS;**1001,1004,1008,1009**;MAY 28, 2004
 ;IHS/ITSC/WAR 12/23/2004 PATCH 1001 removed line feed at top
 ;             07/06/2004 PATCH 1001 at admission, put printed lines back in
 ;IHS/OIT/LJF  09/02/2005 PATCH 1004 changed e-code line to match PCC change
 ;cmi/anch/maw 12/07/2007 PATCH 1008 code set versioning ECLINE
 ;cmi/anch/maw 02/22/2008 PATCH 1009 requirement 70 mod at DXLINE
 ;
EN ;EP; entry point from queuing
 ; Assumes DFN, DGPMCA, and BDGFRM are set
 ; BDGHALF may be set; if =1 prints bottom half of sheet-form only
 ;                     if =2, prints data too
 ; Do NOT set BDGA which is reserved as array in ADT ITEMS table
 ; DO NOT use the following in these routines as they are used to
 ;   loop through a sheets by date: BDGDT,BDGADT,BDGPAT,BDGDA
 ;
 U IO
 ;F BDGCNT=1:1:BDGCOP D PRINT  ;cmi/maw 10/3/2007 handled in ZIS^BDGF
 D PRINT  ;cmi/maw 10/3/2007
 I BDGFIN>1 D ^BDGCPT                ;cpt listings
 ;I '$D(BDGDT) D ^%ZISC               ;don't close if looping by date  cmi/maw 10/3/2007
 ;I '$D(BDGDT) K BDGCNT,BDGHALF,BDGFIN,BDGCOP,BDGFRM  cmi/maw 10/3/2007 orig line
 I $D(BDGDT) W @IOF  ;cmi/maw 4/15/2007 is this where the extra form feed is?
 Q
 ;
PRINT ; print this copy
 NEW BDGVST,X,LINE,LN
 ;I BDGCNT>1 W @IOF  ;cmi/maw 10/3/2007 org line
 I $G(BDGCOP)>1 W @IOF  ;cmi/maw 10/3/2007 for mult copies
 ;
 ; title of a sheet
 S X=$$GET1^DIQ(9009016.8,BDGFRM,.03)  ;inpt title from file
 I $$LASTSRVN^BDGF1(DGPMCA,DFN)["OBSERVATION" S X="OBSERVATION COVERSHEET"
 ;W !,X," **",$$CONF^BDGF,"**"  ;IHS/ITSC/WAR 12/23/2004 P #1001 nextLn
 W X," **",$$CONF^BDGF,"**"
 ;
 I '$D(DGPMDA) S DGPMDA=DGPMCA               ;set curr movmnt if not set
 S BDGVST=$$GET1^DIQ(405,DGPMCA,.27,"I")     ;set visit ien
 ;
 ; loop through form line in display order
 S LINE=0 F  S LINE=$O(^BDGFRM(BDGFRM,"LINE","ALN",LINE)) Q:'LINE  D
 . S LN=0 F  S LN=$O(^BDGFRM(BDGFRM,"LINE","ALN",LINE,LN)) Q:'LN  D
 .. ;
 .. ; if beginning of bottom half, want to continue?
 .. I $P(^BDGFRM(BDGFRM,"LINE",LN,0),U,5)=1,$G(BDGHALF)=0 Q
 .. ;
 .. ; does line need dashed line before it?
 .. I $P($G(^BDGFRM(BDGFRM,"LINE",LN,0)),U,3)=1 D
 ... W !,$$REPEAT^XLFSTR("-",80)
 .. ;
 .. D LOOP("HDR")             ;loop thru items and print headers
 .. ;
 .. ;no data if just printing bottom half of form, just blank lines
 .. I $P(^BDGFRM(BDGFRM,"LINE",LN,0),U,5),$G(BDGHALF)=1 D  Q
 ...;IHS/ITSC/WAR 7/26/2004 PATCH #1001 put printed lines back in
 ...; S X=$P(^BDGFRM(BDGFRM,"LINE",LN,0),U,6) S:'X X=1 F I=1:1:X W !
 ... S X=$P(^BDGFRM(BDGFRM,"LINE",LN,0),U,6) S:'X X=1 F I=1:1:X D
 .... W !,I,"_______   _________________________________"
 .... W "____________________________________",!
 .. ;
 .. D LOOP("DATA")            ;loop thru items and print data
 ;
 Q:BDGFIN=1    ;a sheet only
 ;
 Q
 ;
LOOP(TYPE) ; loop thru items in display order & print
 ; If TYPE="HDR" headers will print, else DATA will print
 ;
 I TYPE="HDR" Q:$P(^BDGFRM(BDGFRM,"LINE",LN,0),U,4)=1  ;skip header line
 ;
 NEW ORD,ITEM,NODE,LEN,HDR,DATA
 S ORD=0 W !
 F  S ORD=$O(^BDGFRM(BDGFRM,"LINE",LN,"ITEM","AITM",ORD)) Q:'ORD  D
 . S ITEM=0
 . F  S ITEM=$O(^BDGFRM(BDGFRM,"LINE",LN,"ITEM","AITM",ORD,ITEM)) Q:'ITEM  D
 .. S NODE=^BDGFRM(BDGFRM,"LINE",LN,"ITEM",ITEM,0),LEN=$P(NODE,U,4)
 .. ;
 .. I TYPE="HDR" D  Q
 ... S HDR=$P(NODE,U,3) W $$PAD(HDR,LEN)  ;W:($X<79) "  "
 .. ;
 .. S DATA=$$GET1^DIQ(9009016.9,+NODE,1) Q:DATA=""
 .. K BDGA S Y="" X DATA
 .. I '$D(BDGA) W $$PAD(Y,LEN) Q                  ;single line data
 .. S I=0 F  S I=$O(BDGA(I)) Q:'I  W BDGA(I),!    ;multi line data
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
 ;
DXLINE(VISIT) ;EP; called by diagnosis code ADT ITEM
 ; returns lines of ICD code, hosp acq and provider narrative
 ; returns BDGA array
 Q:'VISIT  K BDGA
 NEW N,LINE,NARR,COUNT,X
 S N=0 F  S N=$O(^AUPNVPOV("AD",VISIT,N)) Q:'N  D
 . S LINE=$$PAD(" "_$$GET1^DIQ(9000010.07,N,.01),16)       ;icd code
 . ;S X=$$GET1^DIQ(9000010.07,N,.07,"I")                   ;cause of dx cmi/maw 2/28/2008 orig line
 . S X=$$GET1^DIQ(9000010.07,N,.22,"I")                    ;POA cmi/maw 2/22/2008 PATCH 1009 requirement 70
 . ;S LINE=LINE_$S(X=1:"X",1:"")                           ;cmi/maw 2/22/2008 PATCH 1009 requirement 70 orig line
 . S LINE=LINE_$S(X="Y":"X",1:"")                          ;cmi/maw 2/22/2008 PATCH 1009 requirement 70 print X if present on admission
 . S NARR=$$GET1^DIQ(9000010.07,N,.04) D WRAP(NARR,27,80)
 . S LINE=$$PAD(LINE,27)_$G(^UTILITY($J,"W",27,1,0))       ;1st line narrO
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=LINE
 . ;
 . ; if any more provider narrative, add more lines
 . S X=1 F  S X=$O(^UTILITY($J,"W",27,X)) Q:'X  D
 .. S COUNT=$G(COUNT)+1,BDGA(COUNT)=$$SP(27)_^UTILITY($J,"W",27,X,0)
 Q
 ;
ECLINE(VISIT) ;EP; called by e-code line ADT ITEM
 ; returns lines of injury date, cause & e-code, place and code
 ; returns BDGA array
 Q:'VISIT  K BDGA
 NEW N,LINE,NARR,COUNT,X
 S N=0 F  S N=$O(^AUPNVPOV("AD",VISIT,N)) Q:'N  D
 . S LINE=$$SP(3)_$$GET1^DIQ(9000010.07,N,.13)                  ;injury date
 . S X=$$GET1^DIQ(9000010.07,N,.09,"I") Q:X=""                  ;E-code ien
 . ;S LINE=$$PAD(LINE,19)_$$GET1^DIQ(80,+X,3)                   ;icd narr
 . S LINE=$$PAD(LINE,19)_$P($$ICDDX^ICDCODE(+X),U,4)            ;icd narr
 . S LINE=$$PAD(LINE,42)_$$SP(2)_$$GET1^DIQ(9000010.07,N,.09)   ;ecode
 . ;
 . ;IHS/OIT/LJF 9/2/2005 PATCH 1004 PCC now asks for ecode-2 and ecode for place
 . ;S LINE=$$PAD(LINE,52)_$E($$GET1^DIQ(9000010.07,N,.11),1,19) ;place
 . ;S LINE=$$PAD(LINE,73)_$$GET1^DIQ(9000010.07,N,.11,"I")      ;place code
 . I '$$PATCH^XPDUTL("APCD*2.0*8") D
 . . S LINE=$$PAD(LINE,52)_$E($$GET1^DIQ(9000010.07,N,.11),1,19) ;place
 . . S LINE=$$PAD(LINE,73)_$$GET1^DIQ(9000010.07,N,.11,"I")      ;place code
 . E  D
 . S LINE=$$PAD(LINE,55)_$$GET1^DIQ(9000010.07,N,.18)           ;e-code 2
 . S LINE=$$PAD(LINE,72)_$$GET1^DIQ(9000010.07,N,.21)           ;place code
 . ;end of PATCH 1004 changes
 . ;
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=LINE
 Q
 ;
PRCLINE1(VISIT) ;EP; called by procedure code ADT ITEM
 ; returns lines of ICD code, DX, narative, infection, op date, prv code
 ; returns BDGA array
 Q:'VISIT  K BDGA
 NEW N,LINE,NARR,COUNT,X
 S N=0 F  S N=$O(^AUPNVPRC("AD",VISIT,N)) Q:'N  D
 . S LINE=$$PAD($J($$GET1^DIQ(9000010.08,N,.01),7),11)             ;icd code
 . S LINE=LINE_$$GET1^DIQ(9000010.08,N,.05)                        ;dx code
 . S NARR=$$GET1^DIQ(9000010.08,N,.04) D WRAP(NARR,22,58)
 . S LINE=$$PAD(LINE,21)_$G(^UTILITY($J,"W",22,1,0))               ;1st line narrO
 . S LINE=$$PAD(LINE,60)_$$GET1^DIQ(9000010.08,N,.08,"I")          ;infection?
 . S LINE=$$PAD(LINE,65)_$E($$GET1^DIQ(9000010.08,N,.06,"I"),4,7)  ;date
 . S LINE=$$PAD(LINE,72)_$$PRVCODE(N)
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=LINE
 . ;
 . ; if any more provider narrative, add more lines
 . S X=1 F  S X=$O(^UTILITY($J,"W",22,X)) Q:'X  D
 .. S COUNT=$G(COUNT)+1,BDGA(COUNT)=$$SP(21)_^UTILITY($J,"W",22,X,0)
 Q
 ;
PRCLINE2(VISIT) ;EP; called by procedure code ADT ITEM
 ; returns lines of ICD code, CPT, DX, narrative, op date, prv code
 ; returns BDGA array
 Q:'VISIT  K BDGA
 NEW N,LINE,NARR,COUNT,X
 S N=0 F  S N=$O(^AUPNVPRC("AD",VISIT,N)) Q:'N  D
 . S LINE=$$PAD($J($$GET1^DIQ(9000010.08,N,.01),7),9)              ;icd code
 . S LINE=LINE_$$GET1^DIQ(9000010.08,N,.16)                        ;cpt code
 . S LINE=LINE_$$GET1^DIQ(9000010.08,N,.17)                        ;cpt modifier
 . S LINE=$$PAD(LINE,17)_$$GET1^DIQ(9000010.08,N,.05)              ;dx code
 . S NARR=$$GET1^DIQ(9000010.08,N,.04) D WRAP(NARR,28,58)
 . S LINE=$$PAD(LINE,24)_$G(^UTILITY($J,"W",28,1,0))               ;1st line narrO
 . S LINE=$$PAD(LINE,62)_$E($$GET1^DIQ(9000010.08,N,.06,"I"),4,7)  ;date
 . S LINE=$$PAD(LINE,70)_$$PRVCODE(N)
 . S COUNT=$G(COUNT)+1,BDGA(COUNT)=LINE
 . ;
 . ; if any more provider narrative, add more lines
 . S X=1 F  S X=$O(^UTILITY($J,"W",28,X)) Q:'X  D
 .. S COUNT=$G(COUNT)+1,BDGA(COUNT)=$$SP(24)_^UTILITY($J,"W",28,X,0)
 . ;
 . ; if elasped anesthesia time entered, display it
 . S X=$$GET1^DIQ(9000010.08,N,.13) I X]"" D
 .. S COUNT=$G(COUNT)+1,BDGA(COUNT)=$$SP(26)_"anesthesia time (min): "_X
 ;
 K ^UTILITY($J,"W")
 Q
 ;
WRAP(X,DIWL,DIWR) ; -- print text fields in word-wrap mode
 K ^UTILITY($J,"W") S DIWF="" D ^DIWP
 Q
 ;
PRVCODE(IEN) ; return provider code for procedure ien
 NEW Y,FILE
 S Y=$$GET1^DIQ(9000010.08,IEN,.11,"I")
 S FILE=$S($P(^DD(9000010.08,.11,0),U,2)["200":200,1:6)
 Q $$GET1^DIQ(FILE,+Y,9999999.09)
