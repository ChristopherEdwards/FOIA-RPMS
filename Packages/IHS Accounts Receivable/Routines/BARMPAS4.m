BARMPAS4 ; IHS/SD/PKD - Patient Account Statement ;
 ;;1.8;IHS ACCOUNTS RECEIVABLE;**19**;OCT 26, 2005
 ;; IHS/SD/PKD 1.8*19 9/10/10 ADDED ADDT'L SORTS TO THE PATIENT STATEMENTS
 ;;            Moved code here due to size limitations per SAC
 ; **************
 Q  ; 	quit - old code old code old code old code
 S BARBL=0
 F  S BARBL=$O(^XTMP("BARPAS"_BARRUNDT,DUZ(2),BARACDA,BARBL)) Q:'+BARBL  D
 . S BARBNUM=+$$GET1^DIQ(90050.01,BARBL,.01)   ; Only Bill # (no A/B)
 . S BARBILL(BARBNUM,BARBL)=""
 S BARBNUM=0
 F  S BARBNUM=$O(BARBILL(BARBNUM)) Q:BARBNUM'>0  D BILEROR
 S BARBNUM=0
 ;IHS/SD/AR PATCH 19 06/02/2010
 F  S BARBNUM=$O(BARBILL(BARBNUM)) Q:BARBNUM'>0  D  Q:$G(BARF1)
 . N BARBILLD,BARITOT,BARPTOT,BARATOT,BARPRSP,BARPTAC,BARPRV
 . S BARBILLD=0,BARITOT=0,BARPTOT=0,BARATOT=0,BARPRSP=0,BARPTAC=0
 . D BLDA
 . S BARPBNUM=BARBNUM_" "
 . S BARPBNUM=$O(^BARBL(DUZ(2),"B",BARPBNUM))
 . ; IHS/SD/PKD 1.8.19 Quit only if BILL in error; not if 1 skippable trx on a bill
 . Q:$D(BARBILL("X",BARPBNUM))  ;Trx Error code is now BARBIL("XTR",... pkd
 . ; There is a bill owed amt in ^BARBL - need research???
 . ;Q:BARITOT=0&(BARPTOT=0)&(BARATOT=0)&(BARBILLD=0)&(BARITOT=0)
 . ; IHS/SD/PKD - allow more than 1 line per screen
 . ;D PG^BARMPAS3(10)
 . D PG^BARMPAS3(1)
 . Q:$G(BARF1)
 . ; IHS/SD/PKD 9/3/10 date: mm/dd/yy prvName: 9 lenghth
 . ;W !!,$$SDT^BARDUTL(BAR(102,"I")),?11,$J(BARBNUM,6),?18,$J(BARPRV,9),?29,$J(BARBILLD,9)
 . I $G(BARPRV)="" S BARPRV="***** "
 . W !!,$$SHDT^BARDUTL(BAR(102,"I")),?10,BARBNUM," ",?19,$E(BARPRV,1,9),?29,$J(BARBILLD,9)
 . W ?39,$J($FN(BARITOT,"p",2),9),?49,$J($FN(BARPTOT,"p",2),9),?59,$J($FN(BARATOT,"p",2),9)
 . W:BARPTAC=1 ?69,$J($FN(BARPRSP,"p",2),9)
 . W:BARPTAC=0 ?74,"**"
 Q:$G(BARF1)
 D AGE                                          ; Age bills
 D SUM                                          ; Print patient trailer
 Q
 ; **********************************
 ;
BILEROR  ; NO TAG
BLDA  ; NO TAG
AGE  ; NO TAG
SUM  ; NO TAG
