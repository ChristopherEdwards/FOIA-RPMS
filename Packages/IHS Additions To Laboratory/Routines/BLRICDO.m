BLRICDO ; IHS/OIT/MKK - ICDO Global Utilities ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1034**;NOV 01, 1997;Build 88
 ;
 ; This routine creates the ^BLRICDO global for the Input Transform for Field .07 file 61.
 ;
 ; ICD-10 Codes retrieved from http://seer.cancer.gov/tools/conversion/
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ;
CLEANSET ; EP
 ; This subroutine is called during the post-install phase of LR*5.2*1034.
 ; It first creates the ^BLRICDO (see SETUP below).
 ; It then purges all non-valid ICD codes from ^BLRICDO (see SILPURGE below).
 ;
 D SETUP
 D SILPURGE
 Q
 ;
 ;
SETUP ; EP
 ; This subroutine creates the ^BLRICDO global with the necessary ICDO codes
 ; so that the input transform subroutine (see ICDO below) can use it instead
 ; of having to create an array every time it is accessed.
 ;
 NEW CODE,GLOBAL,I,SUB,X
 ;
 S GLOBAL="^BLRICDO"
 K @GLOBAL
 ;
 ; The following are ICD-9 codes.
 ; They were determined by the original Input Transform.
 F CODE=140:1:199  F SUB=1:1:99  S X=CODE_"."_SUB  I X?3N1"."1N  D STUFFIT(CODE_".",SUB)
 ;
 ; The following are ICD-10 codes from seer.cancer.gov
 ; are equivalent to the ICD-9 codes above.
 F I=0,1,2,3,4,5,6,8,9  D STUFFIT("C00.",I)
 D STUFFIT("C01.",9)
 F I=0,1,2,3,4,8,9  D STUFFIT("C02.",I)
 F I=0,1,9  D STUFFIT("C03.",I)
 F I=0,1,8,9  D STUFFIT("C04.",I)
 F I=0,1,2,8,9  D STUFFIT("C05.",I)
 F I=0,1,2,8,9  D STUFFIT("C06.",I)
 D STUFFIT("C07.",9)
 F I=0,1,8,9  D STUFFIT("C08.",I)
 F I=0,1,8,9  D STUFFIT("C09.",I)
 F I=4,8,9  D STUFFIT("C10.",I)
 F I=0,1,2,3,8,9  D STUFFIT("C11.",I)
 D STUFFIT("C12.",9)
 F I=0,1,2,8,9  D STUFFIT("C13.",I)
 F I=0,2,8  D STUFFIT("C14.",I)
 F I=0,1,2,3,4,5,8,9  D STUFFIT("C15.",I)
 F I=0,1,2,3,4,5,6,8,9  D STUFFIT("C16.",I)
 F I=0,1,2,3,8,9  D STUFFIT("C17.",I)
 F I=0:1:9  D STUFFIT("C18.",I)
 D STUFFIT("C19.",9)
 D STUFFIT("C20.")
 F I=0,1,8  D STUFFIT("C21.",I)
 F I=0,1  D STUFFIT("C22.",I)
 D STUFFIT("C23.",9)
 F I=0,1,8,9  D STUFFIT("C24.",I)
 F I=0,1,2,3,4,5,7,8,9  D STUFFIT("C25.",I)
 F I=0,1,9  D STUFFIT("C26.",I)
 Q
 ;
 ;
STUFFIT(CODE,SUB) ; EP - Create and "stuff" resulting code into ^BLRICDO
 S ^BLRICDO(CODE_$G(SUB))=""
 Q
 ;
 ;
ICHEKALL ; EP - Interactively CHEcK ALL the codes in ^BLRICDO
 ; This is to ensure that the codes are in the ICD DIAGNOSIS (#80) dictionary.
 ; If the code is in ^BLRICDO but not in File 80, delete it from ^BLRICDO
 ;
 NEW CNT,GLOBAL,HEADER,ICD,KILLER,PURGED
 ;
 S GLOBAL="^BLRICDO"
 ;
 S HEADER(1)="ICDO Codes"
 S HEADER(2)="Data File Analysis"
 D HEADERDT^BLRGMENU
 S ICD=""
 S (CNT,PURGED)=0
 ;
 W ?4,"Analysis "
 F  S ICD=$O(^BLRICDO(ICD))  Q:ICD=""  D
 . S CNT=CNT+1
 . W:(CNT#10)=0 "."  W:$X>74 !,?4
 . ;
 . Q:+$$ICDDX^ICDEX(ICD)>0  ; Valid code
 . ;
 . S PURGED(ICD)=""
 . S PURGED=PURGED+1
 ;
 W !!,?4,CNT," Codes Analyzed.",!!
 I PURGED=0  W ?9,"No Codes Purged.",!
 E  D
 . W ?9,"The following ",PURGED," codes will be purged from the ^BLRICDO global.",!!,?14
 . S ICD=""
 . F  S ICD=$O(PURGED(ICD))  Q:ICD=""  D
 .. W $$LJ^XLFSTR(ICD,7)
 .. W:$X>64 !,?14
 .. S ICDSTR=ICD
 .. S:$E(ICD)?1A!($P(ICD,".",2)="0") ICDSTR=$C(34)_ICD_$C(34)
 .. S KILLER=GLOBAL_"("_ICDSTR_")"
 .. K @KILLER
 ;
 D PRESSKEY^BLRGMENU(4)
 Q
 ;
SILPURGE ; EP - SILent Purge of BLRICDO dictionary
 ; This is to ensure that the codes are in the ICD DIAGNOSIS (#80) dictionary.
 ; If the code is in ^BLRICDO but not in File 80, delete it from ^BLRICDO
 ;
 NEW CNT,GLOBAL,ICD,KILLER,PURGED
 ;
 S GLOBAL="^BLRICDO"
 ;
 S ICD=""
 S (CNT,PURGED)=0
 ;
 F  S ICD=$O(^BLRICDO(ICD))  Q:ICD=""  D
 . S CNT=CNT+1
 . ;
 . Q:+$$ICDDX^ICDEX(ICD)>0  ; Valid code
 . ;
 . S PURGED(ICD)=""
 . S PURGED=PURGED+1
 ;
 I PURGED D
 . S ICD=""
 . F  S ICD=$O(PURGED(ICD))  Q:ICD=""  D
 .. S ICDSTR=ICD
 .. S:$E(ICD)?1A!($P(ICD,".",2)="0") ICDSTR=$C(34)_ICD_$C(34)
 .. S KILLER=GLOBAL_"("_ICDSTR_")"
 .. K @KILLER
 Q
 ;
 ;
ICDO(X) ; EP - Input Transform for field .07 file 61
 ;X is the value entered by the user, this subroutine checks to make
 ;sure that the value matches a valid code.  This function evaluates
 ;to true if X is okay, false if X is not valid.
 Q $D(^BLRICDO(X))
