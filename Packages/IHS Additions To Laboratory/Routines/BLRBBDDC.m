BLRBBDDC ; IHS/OIT/MKK - BLOOD BANK DATA DICTIONARY CORRECTION(S) [12/07/05 1:43 PM]
 ;;5.2;LR;**1022**;September 20, 2007
 ;;
EEP ;
 D EEP^BLRGMENU
 Q
 ;
PEP     ;
 ; Check all of DD files for instances of $$SITE^VASITE
 ; and correct, if possible.  This mainly appears to be
 ; an issue with the Blood Bank dictionaries.
 D ^XBCLS
 D BLRHEADR("BLOOD BANK DATA DICTIONARY INPUT TRANSFORM","MODIFY $$SITE^VASITE to $P($$SITE^VASITE,U,3)",$TR($J("",80)," ","-"))
 NEW CNT,CNTREC,TAB,DICN,FUZZY
 NEW D0,D1,D2,D3
 S (CNT,CNTREC)=0,FUZZY="|"
 S (D0,D1,D2,D3)=""
 F  S D0=$O(^DD(D0))  Q:D0=""  D
 . S DICN=$P(D0,".",1)
 . S CNTREC=CNTREC+1
 . ;
 . F  S D1=$O(^DD(D0,D1))  Q:D1=""  D
 .. D WARMFZZY
 .. I $G(^DD(D0,D1))["$$SITE^VASITE"  D
 ... I $G(^DD(D0,D1))["$P($$SITE^VASITE,U,3)" Q   ; Valid
 ... D FIXIT(D0,D1)
 .. ;
 .. F  S D2=$O(^DD(D0,D1,D2))  Q:D2=""  D
 ... D WARMFZZY
 ... I $G(^DD(D0,D1,D2))["$$SITE" D
 .... I $G(^DD(D0,D1,D2))["$P($$SITE^VASITE,U,3)" Q    ; Valid
 .... D FIXIT(D0,D1,D2)
 ... ;
 ... F  S D3=$O(^DD(D0,D1,D2,D3))  Q:D3=""  D
 .... D WARMFZZY
 .... I $G(^DD(D0,D1,D2,D3))["$$SITE" D
 ..... I $G(^DD(D0,D1,D2,D3))["$P($$SITE^VASITE,U,3)" Q     ; Valid
 ..... D FIXIT(D0,D1,D2,D3)
 ;
 W !!,"Done.",!!
 ;
 I CNT>0 D
 . W "Number of records corrected:",CNT,!!
 ;
 I CNT<1 D
 . W "Number of records searched:",CNTREC,!!
 . W ?10,"No corrections necessary.",!!
 Q
 ;
WARMFZZY ;
 I CNTREC#500'=0 Q
 W "."
 I $X>70 W !
 Q
 ;
 ; At this point, there is a $$SITE^VASITE call that does
 ; not have the $P($$SITE^VASITE,U,3) correction.  This means
 ; that no matter what is using that call, it is incorrect,
 ; be it a Blood Bank dictionary or not.
FIXIT(D0,D1,D2,D3) ;
 NEW STR,SUBSTR
 NEW SPEC
 S SPEC("$$SITE^VASITE")="$P($$SITE^VASITE,U,3)"
 ;
 ; Write out the offending line
 S CNT=CNT+1
 W $J(CNT,3)
 W ?5,"D0:",D0
 W ?15,"D1:",D1
 W:$G(D2)'="" ?25,"D2:",D2
 W:$G(D3)'="" ?35,"D3:",D3
 W !
 I $G(D3)'="" W ?5,$E($G(^DD(D0,D1,D2,D3)),1,73),!
 I $G(D2)'=""&($G(D3)="") W ?5,$E($G(^DD(D0,D1,D2)),1,73),!
 I $G(D2)=""&($G(D3)="") W ?5,$E($G(^DD(D0,D1)),1,73),!
 ;
 ; Now, try to fix.
 I $G(D3)'="" D  Q
 . S STR=$G(^DD(D0,D1,D2,D3))
 . S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 . S SUBSTR="^DD(D0,D1,D2,D3)"
 . S @SUBSTR=STR
 . W ?5,$E(STR,1,73),!!
 ;
 I $G(D2)'="" D  Q
 . S STR=$G(^DD(D0,D1,D2))
 . S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 . S SUBSTR="^DD(D0,D1,D2)"
 . S @SUBSTR=STR
 . W ?5,$E(STR,1,73),!!
 ;
 S STR=$G(^DD(D0,D1))
 S STR=$$REPLACE^XLFSTR(STR,.SPEC)
 S SUBSTR="^DD(D0,D1)"
 S @SUBSTR=STR
 W ?5,$E(STR,1,73),!!
 ;
 Q
 ;
BLRHEADR(LINE1,LINE2,LINE3) ; HEADER subroutine
 NEW TMPLN
 W $$CJ^XLFSTR($$LOC^XBFUNC,IOM)                  ; Location
 ;
 S TMPLN=$$CJ^XLFSTR(LINE1,IOM)
 S $E(TMPLN,1,13)="Date:"_$$HTE^XLFDT($H,"2DZ")   ; Today's Date
 S $E(TMPLN,IOM-15)=$J("Time:"_$$NOWTIME,16)      ; Current Time
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")             ; Trim extra spaces
 W TMPLN,!
 ;
 I $G(LINE2)="" Q
 ;
 W $$CJ^XLFSTR(LINE2,IOM),!
 ;
 I $G(LINE3)="" Q
 ;
 W $$CJ^XLFSTR(LINE3,IOM),!
 ;
 Q
 ;
NOWTIME()          ; EP - return NOW TIME in xx:xx AM/PM format
 NEW X
 S X=$$HTE^XLFDT($H,"2MPZ")      ; MM/DD/YY HH:MM am/pm format
 S X=$P(X," ",2,3)               ; Get HH:MM am/pm
 S X=$$UP^XLFSTR(X)              ; Uppercase am/pm to AM/PM
 Q X
