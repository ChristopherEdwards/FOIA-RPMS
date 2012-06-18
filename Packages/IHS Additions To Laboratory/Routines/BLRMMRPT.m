BLRMMRPT ;IHS/OIT/MKK - MICRO MNEMONICS REPORT;DEC 09, 2008 8:30 AM
 ;;5.2;IHS LABORATORY;**1025**;NOV 01, 1997
 ;
 ; Lab Description File Abbreviation Report
 ;
 ; Per IHS LAB PSG - Need a report of the mnemonics/abbreviations used
 ; in the MICRO reports for certification purposes.
 ;
EP ; EP
 ; Report only on 5 SCREEN entries:
 ;      C - AP CYTO
 ;      F - FUNGUS
 ;      M - MICRO
 ;      P - PARASITE
 ;      V - VIRUS
 ;
 ; NEW all variables to make sure nothing left "hanging around"
 NEW CNT,ABBREV,EXPANSION,IEN,MICROREPORT,NAME,SCREEN,SYNONYM
 NEW HEADER,HD1,LINES,MAXLINES,PG,QFLG
 ;
 S HEADER(1)="LAB DESCRIPTION FILE REPORT"
 S HEADER(2)="MICRO SCREEN VARIABLES ONLY"
 S HEADER(3)=" "
 ;
 D HEADERDT^BLRGMENU
 ;
 W !!,"LAB DESCRIPTION FILE WILL BE SORTED FIRST",!!
 ;
 ; First, Sort the Descriptions by the NAME field
 S (CNT,IEN)=0
 F  S IEN=$O(^LAB(62.5,IEN))  Q:IEN=""!(IEN'?.N)  D
 . S SCREEN=$P($G(^LAB(62.5,IEN,0)),"^",4)
 . I SCREEN="" Q                   ; If Screen field is NULL, skip
 . I "CFMPV"'[SCREEN Q             ; If not one of the 5, skip
 . ;
 . S EXPANSION=$P($G(^LAB(62.5,IEN,0)),"^",2)
 . I $E(EXPANSION,1,1)'?.A Q       ; If 1st Letter not Alpha, skip
 . ;
 . S NAME=$P($G(^LAB(62.5,IEN,0)),"^",1)
 . S SYNONYM=$P($G(^LAB(62.5,IEN,0)),"^",3)
 . I SYNONYM="" S SYNONYM=" "      ; If NULL, set to 1 Space
 . ;
 . S MICROREPORT(NAME,SYNONYM,IEN)=EXPANSION
 . S CNT=CNT+1
 ;
 W !!,"Number of abbreviations Sorted = ",CNT,!!
 ;
 I $$YESNO("Produce Report","YES")="Q" D  Q
 . W !!,"Fileman QUIT entered; Routine Ending.",!!
 . D PRESSKEY^BLRGMENU(10)
 ;
 ; Now, the Report
 ; 
 D BLRMMRPI                        ; Initialize
 ;
 F  S NAME=$O(MICROREPORT(NAME))  Q:NAME=""!(QFLG="Q")  D
 . F  S SYNONYM=$O(MICROREPORT(NAME,SYNONYM))  Q:SYNONYM=""!(QFLG="Q")  D
 .. F  S IEN=$O(MICROREPORT(NAME,SYNONYM,IEN))  Q:IEN=""!(QFLG="Q")  D
 ... D BLRMMRPL
 ;
 I +$G(CNT)>0 W !!,"Number of abbreviations = ",CNT,!!
 ;
 D ^%ZISC                          ; Close ALL open devices
 ;
 D PRESSKEY^BLRGMENU(10)
 ;
 Q
 ;
YESNO(QUESTION,DEFAULT) ; PEP
 W !!
 D ^XBFMK
 S DIR("A")=QUESTION
 I $G(DEFAULT)'="" S DIR("B")=DEFAULT
 S DIR(0)="YO"
 D ^DIR
 I $D(DTOUT) Q "Q"                 ; Time-Out means QUIT
 I $D(DUOUT) Q "Q"                 ; ^ means QUIT
 S X=$E($$UP^XLFSTR(X),1,1)
 I X="N" Q "Q"                     ; If NO, that means QUIT
 ;
 Q "YES"
 ;
BLRMMRPI ; PEP -- Initialization of routines and output device
 S (CNT,PG)=0
 S (IEN,NAME,SYNONYM)=""
 S (HD1,QFLG)="NO"
 ;
 D ^%ZIS
 I POP=1 D  Q
 . W !!,"Could not open device ",!!
 . S QFLG="Q"
 ;
 U IO
 S MAXLINES=IOSL-4
 S LINES=MAXLINES+10
 ;
 S HEADER(4)="NAME"
 S $E(HEADER(4),21)="SYNONYM"
 S $E(HEADER(4),31)="IEN"
 S $E(HEADER(4),41)="EXPANSION"
 ;
 Q
 ;
BLRMMRPL ; PEP -- Output a line of data
 I LINES>MAXLINES D HEADERPG^BLRGMENU(.PG,.QFLG,HD1)  I QFLG="Q" Q
 ;
 S EXPANSION=$G(MICROREPORT(NAME,SYNONYM,IEN))
 ;
 W $E(NAME,1,18)
 W ?20,$E(SYNONYM,1,8)
 W ?30,IEN                         ; Internal Entry Number
 W ?40,$E(EXPANSION,1,38)
 W !
 S LINES=LINES+1
 S CNT=CNT+1
 Q
