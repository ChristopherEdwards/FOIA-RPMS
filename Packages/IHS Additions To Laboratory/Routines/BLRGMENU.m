BLRGMENU ; IHS/OIT/MKK - GENERIC MENU DRIVER [ 04/26/2006 ]
 ;;5.2;LR;**1022**;September 20, 2007
 ;;
 ;; The main array is the BLRMMENU array.  It's format is
 ;;      BLRMMENU(CNT,RTN,MENUDISP)
 ;;           where      CNT = # of Item
 ;;                      RTN = Full routine name, including Entry Points
 ;;                 MENUDISP = Menu display string
 ;;
 ;; The BLRMMENU array is added to by using ADDTMENU.
 ;; 
 ;; The calling routines must ensure that BLRMMENU is intialized before
 ;; using the ADDTMENU call.
 ;;
EEP ; Ersatz EP
 D ^XBCLS
 W !!!,$C(7),$C(7),$C(7)
 W !!
 W $$SHOUTMSG("USE LABEL")
 W !!
 W !,$C(7),$C(7),$C(7),!
 Q
 ;
 ; Display up to 4 Header lines
MENUDRVR(HD1,HD2,HD3,HD4)              ; EP
 I $G(HD1)="" Q                        ; Must be at least 1 HEADER line
 ;
 I $G(IOM)="" D HOME^%ZIS              ; Reset screen variables, if need be
 ;
 NEW HEADER,HDCNT,MMSEL,MAX            ; NEW variables so they don't hang around.
 ;
 F  D  Q:MMSEL'>0                      ; "Infinite loop"
 . D MAINHEAD                          ; Set up MAIN header array
 . ;
 . S:HDCNT<3 HEADER(HDCNT)="MAIN MENU"
 . S:HDCNT>2 HEADER(HDCNT)=$$CJ^XLFSTR("MAIN MENU",IOM)
 . ;
 . D BLRGSHSH                          ; Generic Header
 . D DISPMENU                          ; Display the BLRMMENU array
 . D GOFORIT                           ; Select & Do menu item
 ;
 Q                                     ; Exit
 ;
 ; Display up to 4 Header lines in FileMan format
MENUDRFM(HD1,HD2,HD3,HD4)         ; EP
 I $G(HD1)="" Q                   ; Must be at least 1 HEADER line
 ;
 I $G(IOM)="" D HOME^%ZIS
 NEW HEADER,HDCNT,MMSEL,MAX,STR,STR2
 ;
 F  D  Q:MMSEL'>0                 ; "Infinite loop"
 . D MAINHEAD
 . D BLRGSHSH
 . D DISPMEFM                     ; Display BLRMMENU array in FileMan format
 . D GOFORIT
 ;
 Q                                ; Exit
 ;
 ; Set up Main Menu driver heading
MAINHEAD ;                       ; EP
 K HEADER
 S HEADER(1)=HD1
 S HDCNT=2
 S:$G(HD2)'="" HEADER(2)=HD2,HDCNT=HDCNT+1
 S:$G(HD3)'="" HEADER(3)=HD3,HDCNT=HDCNT+1
 S:$G(HD4)'="" HEADER(4)=HD4,HDCNT=HDCNT+1
 ;
 S MAX=$G(BLRMMENU(-1))           ; Maximum # of menu items
 Q
 ;
 ; Select Item and try to do it
GOFORIT                         ; EP
 NEW STR,STR2
 ;
 S MMSEL=$$SELITEM                ; Select the Item from the menu
 I MMSEL<1 Q                      ; If zero, just RETURN
 ;
 W !
 S STR=$P($G(BLRMMENU(MMSEL)),"|",1)   ; Get routine "string"
 I STR="" Q                            ; If routine = Null, just RETURN
 ;
 ; If routine string is of the form LABEL^ROUTINE, then have to make
 ; sure to test the existance of the ROUTINE and not the LABEL^ROUTINE.
 ; This is the reason for the code involving the STR2 variable.
 S STR2=$P($P(STR,"^",2),"(",1)
 I STR2="" Q                           ; If no routine Name, skip
 ;
 I $$EXIST^%R(STR2_".INT") D @STR      ; If routine exists, do it
 Q
 ;
 ; Select Item Function
SELITEM()                         ; EP
 D ^XBFMK                         ; Kernel call cleans up FILEMAN vars
 S DIR("A")="Select"
 S DIR(0)="NO^1:"_MAX
 D ^DIR
 Q Y
 ;
 ; Add Menu Items to BLRMMENU array
 ;      RTN = Routine
 ;      DISPSTR = Display String
ADDTMENU(RTN,DISPSTR)             ; EP
 I $G(RTN)="" Q
 I $G(DISPSTR)="" Q
 ;
 NEW MAX
 S MAX=1+$O(BLRMMENU(""),-1)
 S BLRMMENU(MAX)=RTN_"|"_DISPSTR
 ;
 S BLRMMENU(-1)=MAX               ; Special node
 Q
 ;
 ; Display BLRMMENU array -- Tab positions are hardcoded
DISPMENU                          ; EP
 NEW ITEM
 ;
 S ITEM=0
 F  S ITEM=$O(BLRMMENU(ITEM))  Q:ITEM=""  D
 . I ITEM#2'=0 D
 .. W ?4,$J(ITEM,2),") "
 .. W $E($P($G(BLRMMENU(ITEM)),"|",2),1,31)
 . I ITEM#2=0 D
 .. W ?41,$J(ITEM,2),") "
 .. W $E($P($G(BLRMMENU(ITEM)),"|",2),1,31)
 .. W !
 W !
 Q
 ;
 ; Display BLRMMENU array in FileMan format
DISPMEFM                          ; EP
 NEW ITEM
 ;
 S ITEM=0
 F  S ITEM=$O(BLRMMENU(ITEM))  Q:ITEM=""  D
 . W ?4,ITEM
 . W ?9,$E($P($G(BLRMMENU(ITEM)),"|",2),1,53)
 . W !
 W !
 Q
 ;
 ; New Page with just Header & Date & Time
HEADERDT                               ; EP
BLRGSHSH                               ; EP
 NEW J,TMPLN                           ; Temporary Line
 NEW RMPSOS                            ; RPMS' Operating System
 NEW TIMELEN,TIMESTR
 ;
 I IOST["C-VT" D ^XBCLS                ; Clear sceen and home cursor
 I IOST'["C-VT" W @IOF                 ; Form Feed if not terminal
 ;
 W $$CJ^XLFSTR($$LOC^XBFUNC,IOM),!     ; Location
 ;
 S TMPLN=$$CJ^XLFSTR(HEADER(1),IOM)              ; Center string
 S $E(TMPLN,1,13)="Date:"_$$HTE^XLFDT($H,"2DZ")  ; Today's Date
 S $E(TMPLN,IOM-15)=$J("Time:"_$$NOWTIME,16)     ; Current Time
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")            ; Trim extra spaces
 W TMPLN,!
 ;
 I $G(HEADER(2))'="" D
 . S TMPLN=$$CJ^XLFSTR(HEADER(2),IOM)
 . S:$G(BLRVERN)'="" $E(TMPLN,(IOM-10))=$J(BLRVERN,11)     ; Version number
 . S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")
 . W TMPLN,!
 ;
 ; Other Header lines, iff they exist
 F J=3:1  Q:$G(HEADER(J))=""  D
 . W $G(HEADER(J)),!
 ;
 W $TR($J("",IOM)," ","-"),!           ; Dashed Line
 ;
 S LINES=J+2                           ; Re-intialize # lines
 ;
 Q
 ;
 ; Header with Date/Time & Page Numbers
BLRGHWPN(PG,QFLG,HEADONE)         ; EP
 D HEDPGNUM
 Q
 ;
 ; HEaDer with PaGe Number & date/time
HEADERPG(PG,QFLG,HEADONE)         ; EP
 D HEDPGNUM
 Q
 ;
 ; HEaDer with PaGe NUMber & date & time
HEDPGNUM ;                       ; EP
 NEW J,TMPLN
 NEW TIMELEN,TIMESTR
 ;
 ; Check "Print Header Once" Flag
 I $E($G(HEADONE),1,1)="Y"&(PG>0) S QFLG="HO"  Q
 ;
 I IOST["C-VT"&(PG>0) D  I $G(QFLG)="Q" Q   ; If Fileman quit, then skip
 . D ^XBFMK
 . W !
 . S DIR(0)="E",(X,Y)=""
 . D ^DIR
 . I $G(X)="^" S QFLG="Q"
 ;
 I IOST["C-VT" D ^XBCLS                ; If terminal, clear sceen & home cursor
 I IOST'["C-VT" W @IOF                 ; Form Feed if not terminal
 ;
 W $$CJ^XLFSTR($$LOC^XBFUNC,IOM),!     ; Location
 ;
 S PG=PG+1                             ; Increment Page Number
 S TMPLN=$$CJ^XLFSTR(HEADER(1),IOM)    ; Center Header string
 S $E(TMPLN,1,13)="Date:"_$$NOWDATE    ; Today's Date
 S $E(TMPLN,IOM-10)=$J("Page "_PG,11)  ; Page Number
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")  ; Trim extra spaces
 W TMPLN,!
 ;
 S TMPLN=$$CJ^XLFSTR(HEADER(2),IOM)
 S TIMESTR="Time:"_$$NOWTIME                            ; Current Time
 S TIMELEN=$L(TIMESTR)                                  ; Length of string
 S $E(TMPLN,1,TIMELEN)=TIMESTR
 S:$G(BLRVERN)'="" $E(TMPLN,(IOM-10))=$J(BLRVERN,11)    ; Version number
 S TMPLN=$$TRIM^XLFSTR(TMPLN,"R"," ")
 W TMPLN,!
 ;
 ; Other Header lines, iff they exist
 F J=3:1  Q:$G(HEADER(J))=""  D
 . W $G(HEADER(J)),!
 ;
 W $TR($J("",IOM)," ","-"),!           ; Dashed line
 ;
 S LINES=J+2
 ;
 Q
 ;
 ; Generic "Press Any Key"
BLRGPGR(TAB)                           ; EP
 NEW TABSTR
 I $G(TAB)'="" S TABSTR=$J("",TAB)_"Press RETURN Key"
 I $G(TAB)="" S TABSTR="Press RETURN Key"
 W !                         ; Blank line
 D ^XBFMK
 S DIR(0)="E",(X,Y)=""
 S DIR("A")=TABSTR
 D ^DIR
 I $G(X)="^" S QFLG="Q"      ; If Fileman quit, then set Quit Flag
 ;
 Q
 ;
 ; Generic "Press Any Key"
PRESSKEY(TAB)                          ; EP
 NEW TABSTR
 S TABSTR=$J("",+$G(TAB))_"Press RETURN Key"
 W !                         ; Blank line
 D ^XBFMK
 S DIR(0)="E",(X,Y)=""
 S DIR("A")=TABSTR
 D ^DIR
 I $G(X)="^" S QFLG="Q"      ; If Fileman quit, then set Quit Flag
 ;
 Q
 ;
 ; NOW DATE in MM/DD/YY format
NOWDATE()                              ; EP
 Q $$HTE^XLFDT($H,"2DZ")
 ;
 ; NOW TIME in xx:xx AM/PM format
NOWTIME()                              ; EP
 Q $$UP^XLFSTR($P($$HTE^XLFDT($H,"2MPZ")," ",2,3))
 ;
 ; Return a string like >>>> STR <<<<
SHOUTMSG(STR,RM)                       ; EP
 NEW HALFLEN,J,STRLEN,TMPSTR
 ;
 I $G(RM)="" S RM=IOM
 ;
 S HALFLEN=(RM\2)-(($L(STR)+2)\2)
 S TMPSTR=$TR($J("",HALFLEN)," ",">")
 S TMPSTR=TMPSTR_" "_STR_" "
 S STRLEN=$L(TMPSTR)
 F J=STRLEN:1:(RM-1) S TMPSTR=TMPSTR_"<"
 Q TMPSTR
