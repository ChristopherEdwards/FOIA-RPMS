BLRICDU0 ; IHS/MSC/MKK - IHS Laboratory ICD Utilities ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1034**;NOV 01, 1997;Build 88
 ;
EEP ; Ersatz EP
 D EEP2^BLRGMENU
 Q
 ;
 ;
 ; AICD 4.0 modified ICD9 global.  Need new functions/routines to retrieve data.
 ;
FINDER(BLRINP,RES) ; EP - Mimic FIND^DIC call
 NEW ICD,ICDSTR
 ;
 K RES
 ;
 S ICDSTR=$$ICDDX^ICDEX(BLRINP)
 Q:+ICDSTR<1
 ;
 S RES("DILIST",0)="1^*^0^"
 S RES("DILIST",0,"MAP")=".01^10"
 S RES("DILIST",1,1)=$P(ICDSTR,"^",2)
 S RES("DILIST",2,1)=+ICDSTR
 S RES("DILIST","ID",1,.01)=$P(ICDSTR,"^",2)
 S ICD=+ICDSTR
 S RES("DILIST","ID",1,10)=$$DESCICD(ICD)
 Q
 ;
 ;
DESCICD(ICD,BLRVDT) ; EP - DESCRIPTION is now a multiple
 NEW DESCDATE,DESCNUM,DESCRIP
 ;
 S DESCRIP=$G(^ICD9(ICD,68,+$O(^ICD9(ICD,68,"A"),-1),1)) ; Most Current Description
 ;
 I +$G(BLRVDT) D   ; If there is date, retrieve description current as of that date
 . S BLRVDT=$$FMADD^XLFDT(BLRVDT,-1)   ; "Back up" 1 day to account for $ORDER function
 . S DESCDATE=$O(^ICD9(ICD,68,"B",BLRVDT))
 . Q:DESCDATE<1
 . ;
 . S DESCNUM=$O(^ICD9(ICD,68,"B",DESCDATE,0))
 . Q:DESCNUM<1
 . ;
 . S DESCRIP=$G(^ICD9(ICD,68,DESCNUM,1))
 ;
 Q DESCRIP
 ;
 ;
DIAGICD(ICD,BLRVDT) ; EP - DIAGNOSIS is now a multiple
 NEW DIAGDATE,DIAGNUM,DIAGDESC
 ;
 S DIAGDESC=$P($G(^ICD9(ICD,67,+$O(^ICD9(ICD,67,"A"),-1),0)),"^",2)  ; Most Current Diagnosis
 ;
 I +$G(BLRVDT) D   ; If there is date, retrieve diagnosis current as of that date
 . S BLRVDT=$$FMADD^XLFDT(BLRVDT,-1)   ; "Back up" 1 day to account for $ORDER function
 . S DIAGDATE=$O(^ICD9(ICD,67,"B",BLRVDT))
 . Q:DIAGDATE<1
 . ;
 . S DIAGNUM=$O(^ICD9(ICD,67,"B",DIAGDATE,0))
 . Q:DIAGNUM<1
 . ;
 . S DIAGDESC=$P($G(^ICD9(ICD,67,DIAGNUM,0)),"^",2)
 ;
 Q DIAGDESC
 ;
 ;
INACTDT(ICD,BLRVDT)     ; EP - Determine if ICD is Inactive, given a date
 NEW ICDDATE
 ;
 D ICD10IDT(.ICDDATE)
 ;
 Q:BLRVDT<ICDDATE&(+$G(^ICD9(ICD,1))>29) 1   ; "Inactive" if ICD-10 code and Date < ICD-10 Active
 ;
 Q:$G(BLRVDT)<1 0       ; If no date, then cannot check STATUS EFFECTIVE DATE ==> Not Inactive
 ;
 NEW STATUS,STSDATE,STSNUM
 ;
 S BLRVDT=$$FMADD^XLFDT(BLRVDT,-1)   ; "Back up" 1 day to account for $ORDER function
 S STSDATE=$O(^ICD9(ICD,66,"B",BLRVDT))
 Q:STSDATE<1 0          ; If no STATUS EFFECTIVE DATE ==> Not Inactive
 ;
 Q:STSDATE>BLRVDT 0     ; If STATUS EFFECTIVE DATE > BLRVDT, then cannot check STATUS ==> Not Inactive
 ;
 S STSNUM=$O(^ICD9(ICD,66,"B",STSDATE,0))
 Q:STSNUM<1 0           ; If no STATUS ==> Not Inactive
 ;
 S STATUS=+$G(^ICD9(ICD,66,STSNUM,0))
 Q $S(STATUS=1:0,1:1)   ; STATUS = 1 ==> ACTIVE; STATUS = 0 ==> INACTIVE
 ;
 ;
CURINACT(ICD) ; EP - Determine if ICD is Currently Inactive
 NEW ICDDATE,STATUS,STSDATE,STSNUM
 ;
 D ICD10IDT(.ICDDATE)
 ;
 Q:$$DT^XLFDT<ICDDATE&(+$G(^ICD9(ICD,1))>29) 1   ; "Inactive" if ICD-9 code and Date is < ICD-10 Date
 ;
 S STSDATE=$O(^ICD9(ICD,66,"B","A"),-1)
 Q:STSDATE<1 0          ; If no STATUS EFFECTIVE DATE ==> Not Inactive
 ;
 S STSNUM=$O(^ICD9(ICD,66,"B",STSDATE,0))
 Q:STSNUM<1 0           ; If no STATUS ==> Not Inactive
 ;
 S STATUS=+$G(^ICD9(ICD,66,STSNUM,0))
 Q $S(STATUS=1:0,1:1)   ; STATUS = 1 ==> ACTIVE; STATUS = 0 ==> INACTIVE
 ;
SETDICS ; EP - Set the DIC("S") based on Today
 NEW ICD10DT
 ;
 D ICD10IDT(.ICDDATE)
 ;
 ; Set DIC("S") to check just the status if Date >= ICD-10 date
 I $$DT^XLFDT>=ICDDATE S DIC("S")="I $P($G(^ICD9(Y,66,+$O(^ICD9(Y,66,""A""),-1),0)),""^"",2)"  Q
 ;
 ; Set DIC("S") to check to make sure no ICD-10 codes are returned to the user if Date < ICD-10 Active
 S DIC("S")="I $P($G(^ICD9(Y,66,+$O(^ICD9(Y,66,""A""),-1),0)),""^"",2)&(+$G(^ICD9(Y,1))<30)"
 Q
 ;
SETDICSD(DT) ; EP - Set the DIC("S") based on DT
 NEW ICD10DT
 ;
 D ICD10IDT(.ICDDATE)
 ;
 ; Set DIC("S") to check just the status if Date >= ICD-10 date
 I DT>=ICDDATE S DIC("S")="I $P($G(^ICD9(Y,66,+$O(^ICD9(Y,66,""A""),-1),0)),""^"",2)"  Q
 ;
 ; Set DIC("S") to check to make sure no ICD-10 codes are returned to the user if Date < ICD-10 Active
 S DIC("S")="I $P($G(^ICD9(Y,66,+$O(^ICD9(Y,66,""A""),-1),0)),""^"",2)&(+$G(^ICD9(Y,1))<30)"
 Q
 ;
ICD10IDT(DATE,TYPE) ; EP - Return the Implementation Date for the ICD-10
 NEW ICDSTR,IEN
 ;
 S ICDSTR="ICD-10-"_$G(TYPE,"CM")
 S IEN=+$O(^ICDS("B",ICDSTR,0))
 S DATE=$$GET1^DIQ(80.4,IEN,"IMPLEMENTATION DATE","I")
 S:DATE<1 DATE=3151001  ; If no Date returned from 80.4, hard set to 10/1/2015.
 Q
