BLRCLRAL ;IHS/OIT/MKK - Clear ALL Lab Module Errors in the Error Trap [ 06/27/2007  3:45 PM ]
 ;;5.2;LR;**1024**;May 02, 2008
 ; 
 ;Clear ALL BLR Errors from ERROR LOG, no matter the date
 ;Code cloned from CLRERRS^BLRUTIL.
CLRALLER    ; EP
 NEW BLRERLIM,BLRERRS,CURUCI,ERRDT,ERRNUM,HEADER,RTN,TODAY,TONLERRS
 ;
 S HEADER(1)="CLEAR ALL BLR ERRORS IN ERROR TRAP"
 D HEADERDT^BLRGMENU
 ;
 S STARTDT=$O(^%ZTER(1,0))                     ; Earliest date in Error Trap
 S TODAY=+$H
 S BLRQSITE=$P($G(^AUTTSITE(1,0)),U)           ; Division
 S BLRERLIM=$P($G(^BLRSITE(BLRQSITE,0)),U,11)  ; GET ERROR OVERFLOW LIMIT
 X ^%ZOSF("UCI")
 S CURUCI=Y
 ;
 S (BLRERRS,TONLERRS)=0
 F ERRDT=STARTDT:1:TODAY  Q:+$G(BLRERRS)>5  D          ; <<<<<<<DEBUG
 . S ERRNUM=0
 . F  S ERRNUM=$O(^%ZTER(1,ERRDT,1,ERRNUM)) Q:ERRNUM=""!(ERRNUM'?.N)  D
 .. Q:$P($G(^%ZTER(1,ERRDT,1,ERRNUM,"J")),U,4)'=CURUCI
 .. ;
 .. I $G(^%ZTER(1,ERRDT,1,ERRNUM,"ZE"))'[("^BLR") D  Q
 ... S TONLERRS=1+$G(TONLERRS)               ; Count # of Non-BLR errors
 .. ;
 .. S BLRERRS(ERRDT)=1+$G(BLRERRS(ERRDT))
 .. S BLRERRS=1+$G(BLRERRS)
 .. K ^%ZTER(1,ERRDT,1,ERRNUM)
 .. S $P(^%ZTER(1,ERRDT,0),U,2)=$P($G(^%ZTER(1,ERRDT,0)),U,2)-1
 ;
 W !!
 I +$G(TONLERRS)>0 W ?5,"Total Non-Link Errors = ",TONLERRS,!
 ;
 I +$G(BLRERRS)<1 D
 . W !,?5,"No link errors were found for Date Range: "
 . W $$HTE^XLFDT(STARTDT,"2DZ")
 . W " thru "
 . W $$HTE^XLFDT(TODAY,"2DZ")
 . W !!
 ;
 I +$G(BLRERRS)>0 D
 . W !
 . W +$G(BLRERRS)
 . W ?5,"Link Errors were found and cleared from the error log!",!!
 . S ERRDT=0
 . F  S ERRDT=$O(BLRERRS(ERRDT))  Q:ERRDT=""  D
 .. W ?10,"Date: "
 .. W $$HTE^XLFDT(ERRDT,"2DZ")     ; External Date format
 .. W " had "
 .. W +$G(BLRERRS(ERRDT))          ; # of errors on that date
 .. W " link error"
 .. I +$G(BLRERRS(ERRDT))>1 W "s"  ; if > 1 then make plural
 .. W "."
 .. W !
 S $P(^BLRSITE(BLRQSITE,0),U,9)=0
 ;
 D BLRGPGR^BLRGMENU(20)                 ; Press Return
 ;
 Q
