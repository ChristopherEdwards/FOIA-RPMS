ABSPOSXE ; IHS/FCS/DRS - Support - error log search ;  
 ;;1.0;PHARMACY POINT OF SALE;;JUN 21, 2001
 Q
ERRLOG ;EP - search error log for $ZE in a POS routine
 ; ^%ZTER(1,$Hdate,m,n,"ZE")=$ZERROR value
 N DERANGE S DERANGE=$$DTRANGE^ABSPOSX Q:'DERANGE
 D SEARCH($$HRANGE^ABSPOSX(DERANGE))
 Q
RECENT D SEARCH($H-1_U_+$H)
 Q
SEARCH(RANGE) ;EP -
 W !,"Searching error log for Point of Sale errors...",!
 N COUNT S COUNT=0
 N H F H=$P(RANGE,U):1:$P(RANGE,U,2) D SEARCH1
 I 'COUNT W "None found",!
 Q
SEARCH1 ; for one given H
 N A,B,C
 S A=""
 F  S A=$O(^%ZTER(1,H,A)) Q:A=""  D
 . S B=""
 . F  S B=$O(^%ZTER(1,H,A,B)) Q:B=""  D
 . . I $$CHECK(H,A,B) D REPORT(H,A,B) S COUNT=COUNT+1
 Q
CHECK(H,A,B)       ; ^%ZTER(1,H,A,B,...  is it for Point of Sale?
 N R S R=$$ZEROU(H,A,B) ; routine name in $ZERROR
 I R?1"ABSP".E Q 1  ; 
 S R=$$XQY0(H,A,B) ; option name in variable XQY0
 I R?1"ABSP".E Q 1
 Q 0
REPORT(H,A,B)      ;
 W "Error # ",B," on "
 N H1 S H1=$P($G(^%ZTER(1,H,A,B,"H")),U) I 'H1 S H1=H
 W $$HPRINT(H1)
 I A'=1 W " (subscript A=",A,"?)"
 W !
 W "Code: ",$G(^%ZTER(1,H,A,B,"LINE")),!
 W "$ZE=",$$ZE(H,A,B),!
 W "XQY0=",$$XQY0(H,A,B),!
 Q
HPRINT(%H) ; 
 N Y,X,% D YX^%DTC
 Q Y
ZE(H,A,B)          ; return $ZERROR variable from error log entry
 Q $G(^%ZTER(1,H,A,B,"ZE"))
ZEROU(H,A,B)       ; return routine name from $ZERROR value
 N X S X=$$ZE(H,A,B)
 I X'[U Q ""
 S X=$P(X,U,2)
 S X=$P(X,":")
 Q X
XQY0(H,A,B)        Q $$VAR("XQY0",H,A,B)
VAR(VAR,H,A,B)     ; return value of variable or "<UNDEF>" if not found
 N V,STOP,VAL S V=""
 F  S V=$O(^%ZTER(1,H,A,B,"ZV",V)) Q:V=""  D  Q:$D(VAL)
 . I $P($G(^%ZTER(1,H,A,B,"ZV",V,0)),U)=VAR D
 . . S VAL=^%ZTER(1,H,A,B,"ZV",V,"D")
 Q $S($D(VAL):VAL,1:"<UNDEF>")
