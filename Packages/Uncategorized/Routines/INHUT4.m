INHUT4 ;JAW,JPD; 13 Jan 93 14:16;HANDLE COPIES OF DOCUMENTS 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
COPIES(COPIES,PROMPT) ; ask # copies
 ; COPIES(op)=Default for number of copies; def=1
 ; PROMPT(op)=Alternate prompt; def="Number of Copes: "
 S COPIES=$S($G(COPIES):+COPIES,1:1),PROMPT=$S($G(PROMPT)]"":PROMPT,1:"NUMBER OF COPIES: ")_COPIES_"//"
 F  D  I %["^"!% Q
 .W !,PROMPT R %:DTIME E  S %="^" Q
 .I %["^" S %="^" Q
 .I %="" S %=COPIES
 .I %<1!(%>10)!(%'?.N) W !,"Enter a number between 1 and 10" S %=0
 Q %
PRINT(ROU,COPIES,DOC) ; Print multiple copies of a report to device 'IO'
 ;NOTE:  DEVICE 'IO' MUST BE OPEN WHEN CALLING
 ;    ROU(re) = Run routine to do printing
 ; COPIES(op) = # copies to print (def 1)
 ;    DOC(op) = Name for document being printed.  If passed doc is left
 ;              with an expiration date of a week. Scratch name used &
 ;              doc. deleted if not passed.  DOC contains one copy of
 ;              what is printed by 'ROU'.
 N DA,DIE,DR,INZISDA,INZISDOC,ZISDA,ZISDOC
 ; ZISDOC by ref. - need to know the document name from RUN
 S (ZISDOC,DOC)=$G(DOC) D RUN(ROU,.ZISDOC,IOM,IOSL)
 S ZISCOPY=$S($G(COPIES):COPIES,1:1)
 ; Save values; Print multiple copies; SPOOLER closes device
 S ZISDA=$O(^XUSPLDSM("B",ZISDOC,"")),ZISDOC=$G(^XUSPLDSM(ZISDA,1))
 S INZISDA=ZISDA,INZISDOC=ZISDOC U IO D ENTSK^%ZISPL
 ; Delete spool document and VMS file
 I DOC="" S DA=INZISDA,DIK="^XUSPLDSM(" D ^DIK
 Q
RUN(ROU,DOC,IOM,IOSL) ; Print to spool file 'DOC' once
 ;    ROU(re)=Routine that does printing
 ;    DOC(op)=Document name (def bogus doc)
 ;    IOM(op)=Margin for out (def 80)
 ;   IOSL(op)=Pg length for out (def 60)
 N IO,IOP,IOST
 S DOC=$S($G(DOC)="":"INSPOOL"_$TR($H,",")_$J,1:DOC)
 S IOP="SPOOL;"_DOC_";"_$S($G(IOM):IOM,1:80)_";"_$S($G(IOSL):IOSL,1:60)
 D ^%ZIS D
 .; New DOC in case DOC was by ref. and 'ROU' kills it
 .N DOC U IO D @ROU,^%ZISC
 Q
