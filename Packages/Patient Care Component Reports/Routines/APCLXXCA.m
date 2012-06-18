APCLXXCA ; IHS/OHPRD/TMJ -CREATED BY ^XBERTN ON APR 18, 1996 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ;;ATXTXCHK ; IHS/OHPRD/TMJ - CHECK CODE AGAINST TAXONOMY ; 
 ;; ;;5.1T1;TAXONOMY SYSTEM;;APR 18, 1996
 ;; ;
 ;; ; This routine checks to see if a specific code is in a specific
 ;; ; taxonomy.
 ;; ;
 ;; ; If the taxonomy entry says the taxonomy is a 'range' of codes, the
 ;; ; lookup is on the AA xref of the 2101 multiple.  Otherwise, the
 ;; ; lookup is on the B xref of the 2101 multiple.  See .16 RANGE field.
 ;; ;
 ;; ; There are many ways the AA xref can be messed up.  It is only set if
 ;; ; a range of codes is specified and it has a " " appended if
 ;; ; non-canonic is set.  It is not set if the high value of the range is
 ;; ; not entered.  If the taxonomy is created with range or non-canonic
 ;; ; set one way, then changed later you may have AA entries missing,
 ;; ; some canonic, and some non-canonic.
 ;; ;
 ;; ; There needs to be a routine that checks the validity of the entries
 ;; ; in the taxonomy file.
 ;; ;
 ;; ; ** I hope the taxonomy dictionary prevents overlapping ranges **
 ;; ; ** I checked.  It does not. It also doesn't prevent the high  **
 ;; ; ** code from being lower than the low code.                   **
 ;; ;
 ;;TXC(ATXCIEN,ATXTIEN,TEST) ;EP-EXTRN FUNC/see if code is in taxonomy
 ;; ; input variables: ATXCIEN=code ien, ATXTIEN=taxonomy ien
 ;; ;                  TEST causes code and hits to be displayed
 ;; ; returns 1 if in taxonomy, otherwise returns 0
 ;; ;
 ;; NEW ATXBEG,ATXEND,ATXFILE,ATXGBL,ATXMIXED,ATXMODE,ATXQ,ATXQV,X,Y
 ;; S (ATXQ,ATXQV)=0
 ;; G:'$G(ATXCIEN) TXCX
 ;; G:'$G(ATXTIEN) TXCX
 ;; D GETCODE ;                                 get code
 ;; G:ATXQ TXCX ;                               can't find code
 ;; D CHKTAX ;                                  check taxonomy
 ;; ; if taxonomy single values instead of code ranges do test & exit
 ;; I 'ATXRANGE S:$D(^ATXAX(ATXTIEN,21,"B",ATXCODE)) ATXQV=1 D  G TXCX
 ;; . Q:'ATXQV  ;                               no hit
 ;; . W:$G(TEST) "  SINGLE VALUES HIT ",!
 ;; . Q
 ;; D SRCHTAX ;                                 search taxonomy for code
 ;;TXCX ;
 ;; Q ATXQV
 ;; ;
 ;;GETCODE ; GET CODE TO CHECK
 ;; S ATXQ=1
 ;; S ATXFILE=$P($G(^ATXAX(ATXTIEN,0)),U,15) ;  get reference file
 ;; Q:ATXFILE="" ;                              quit if no file
 ;; S ATXGBL=$$ROOT^DILFD(ATXFILE) ;            get gbl root to file
 ;; Q:ATXGBL="" ;                               corrupt data dictionary
 ;; S ATXGBL=ATXGBL_ATXCIEN_"," ;               set gbl to entry in file
 ;; S @("ATXCODE=$P($G("_ATXGBL_"0)),U)") ;     get code
 ;; Q:ATXCODE="" ;                              quit if can't find code
 ;; W:$G(TEST) !,"CODE=""",ATXCODE,""""
 ;; S ATXQ=0
 ;; Q
 ;; ;
 ;;CHKTAX ; CHECK TAXONOMY ENTRY
 ;; S ATXRANGE=$P(^ATXAX(ATXTIEN,0),U,16) ;     single value or range
 ;; Q:'ATXRANGE ;                               quit if not range
 ;; ;
 ;; ; When we talk about xref being canonic or non-canonic we are talking
 ;; ; about the AA xref in the taxonomy 2101 multiple.  This has nothing
 ;; ; to do with the file from which the code was retrieved.  Treat as
 ;; ; non-canonic if the dictionary says it is, the xref really is, or
 ;; ; if the passed code is.
 ;; ;
 ;; S ATXNONC=$P(^ATXAX(ATXTIEN,0),U,13) ;      is xref non-canonic?
 ;; S:ATXCODE'=+ATXCODE ATXNONC=1 ;             code non-canonic, force it
 ;; I 'ATXNONC D  ;                             confirm canonic
 ;; . S X=$O(^ATXAX(ATXTIEN,21,"AA","~"),-1),X=$S(X'=+X:1,1:0)
 ;; . S:X ATXNONC=1 ;                           go with what really is
 ;; . Q
 ;; ; see if xref is both canonic and non-canonic (i.e., mixed).
 ;; S X=$O(^ATXAX(ATXTIEN,21,"AA","~"),-1),X=$S(X'=+X:1,1:0)
 ;; S Y=$O(^ATXAX(ATXTIEN,21,"AA","")),Y=$S(Y=+Y:1,1:0)
 ;; S ATXMIXED=((X+Y)-1) ;                      1=mixed mode xref
 ;; Q
 ;; ;
 ;;SRCHTAX ; SEARCH TAXONOMY FOR CODE
 ;; I ATXMIXED D  Q  ;                          mixed mode xref
 ;; . D NONCANON
 ;; . Q:ATXQV
 ;; . D CANONIC
 ;; . Q
 ;; I ATXNONC D NONCANON Q  ;                   non-canonic xref
 ;; D CANONIC ;                                 canonic xref
 ;; Q
 ;; ;
 ;;NONCANON ; NON CANONIC XREF OR CODE
 ;; S X=ATXCODE
 ;; S:$E(X,$L(X))'=" " X=X_" " ;                add " " force non-canonic
 ;; S ATXNXT=$O(^ATXAX(ATXTIEN,21,"AA",X),-1) ; right before code
 ;; I ATXNXT]"",ATXNXT'=+ATXNXT S ATXNXT=$O(^ATXAX(ATXTIEN,21,"AA",ATXNXT),-1) ;1 more back to insure $O from atxnxt will not move past atxcode
 ;; F  S ATXNXT=$O(^ATXAX(ATXTIEN,21,"AA",ATXNXT)) Q:ATXNXT=""  D EQUALIZE(1) Q:ATXBEG]ATXCMPC  D  Q:ATXQV
 ;; . S ATXEND=$O(^ATXAX(ATXTIEN,21,"AA",ATXNXT,""))
 ;; . S:ATXEND="" ATXEND=ATXBEG ;               must be single code
 ;; .;actually if no end code no "AA" xref is created (design flaw?)
 ;; . D EQUALIZE(2) ;                           equalize lengths
 ;; . Q:ATXCMPC]ATXEND  ;                       higher than end of range
 ;; . S ATXQV=1 ;                               found code in taxonomy
 ;; . W:$G(TEST) "  NON-CANONIC HIT: RANGE=""",$TR(ATXBEG," ","_"),"""-""",$TR(ATXEND," ","_"),"""",!
 ;; . Q
 ;; Q
 ;; ;
 ;;EQUALIZE(F) ; EQUALIZE LENGTH AND FORCE LAST CHAR TO " "
 ;; NEW A,B,C,X,Y
 ;; S X=$S(F=1:ATXNXT,1:ATXEND)
 ;; S:$E(X,$L(X))="." X=$E(X,1,($L(X)-1)) ;     strip off trailing period
 ;; S X=X_$S($E(X,$L(X))'=" ":" ",1:"")
 ;; S Y=ATXCODE
 ;; S:$E(Y,$L(Y))="." Y=$E(Y,1,($L(Y)-1)) ;     strip off trailing period
 ;; S Y=Y_$S($E(Y,$L(Y))'=" ":" ",1:"")
 ;; S A=$L(X),B=$L(Y)
 ;; I A'=B D  ;                                 pad short var with blanks
 ;; . S $P(C," ",$S(A>B:A-B,1:B-A))=" "
 ;; . I A>B S Y=Y_C I 1
 ;; . E  S X=X_C
 ;; . Q
 ;; S @($S(F=1:"ATXBEG",1:"ATXEND")_"=X,ATXCMPC=Y")
 ;; Q
 ;; ;
 ;;CANONIC ; CANONIC XREF AND CODE
 ;; Q:ATXCODE'=+ATXCODE  ;                      code is not canonic
 ;; S X=ATXCODE
 ;; S ATXNXT=$O(^ATXAX(ATXTIEN,21,"AA",X),-1) ; right before code
 ;; S:ATXNXT]"" ATXNXT=$O(^ATXAX(ATXTIEN,21,"AA",ATXNXT),-1) ;1 more back
 ;; F  S ATXNXT=$O(^ATXAX(ATXTIEN,21,"AA",ATXNXT)) Q:ATXNXT=""  Q:ATXNXT>ATXCODE  S ATXBEG=ATXNXT D  Q:ATXQV
 ;; . S ATXEND=$O(^ATXAX(ATXTIEN,21,"AA",ATXNXT,""))
 ;; . S:ATXEND="" ATXEND=ATXBEG ;               must be single code
 ;; .;actually if no end code no "AA" xref is created (design flaw?)
 ;; . Q:ATXCODE>ATXEND  ;                       higher than end of range
 ;; . S ATXQV=1 ;                               found code in taxonomy
 ;; . W:$G(TEST) "  CANONIC HIT: RANGE=""",ATXBEG,"""-""",ATXEND,"""",!
 ;; . Q
 ;; Q
