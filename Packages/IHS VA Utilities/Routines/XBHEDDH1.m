XBHEDDH1 ;402,DJB,10/23/91,EDD - Help Text - Main Menu
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
 ;;Called by XBHEDD1
 D INIT G:FLAGQ EX
 I FLAGP,IO'=IO(0) W !!!
 F I=1:1 S TEXT=$P($T(TXT+I),";;;",2) Q:TEXT="***"  W !,TEXT I $Y>SIZE D PAGE Q:FLAGQ
 I 'FLAGQ D ^XBHEDDH2
EX ;
 K TEXT Q
TXT ;Start of text
 ;;;                  E D D  -  Electonic Data Dictionary
 ;;;                 Version 2.2    David Bolduc   Togus,ME
 ;;;==============================================================================
 ;;; HELP  []  HELP  []  HELP  []  HELP  []  HELP  []  HELP  []  HELP  []  HELP
 ;;;==============================================================================
 ;;; NOTE: When you're in EDD, enter '?' at any prompt for help.
 ;;;
 ;;; A)  E N T R Y   P O I N T S:
 ;;;
 ;;;      DO ^XBHEDD    - Main entry point. At 'Select FILE:' prompt
 ;;;                      enter File Name, File Number, or File Global
 ;;;                      in the form '^DG' or '^RA('.
 ;;;      DO GL^XBHEDD  - Gives listing of your system's globals sorted
 ;;;                      in ASCII order, including file number and name.
 ;;;      DO PRT^XBHEDD - Bypasses opening screen and suppressess some page
 ;;;                      feeds. Use if you're on a printing/keyboard device
 ;;;                      such as a counsol.
 ;;;      DO DIR^XBHEDD - Bypasses opening screen.
 ;;;
 ;;;  B)  M E N U   O P T I O N S:
 ;;;
 ;;;     1) Cross References - An '*' in the far left column indicates this
 ;;;                           XREF can be used for lookup purposes. If you
 ;;;                           concantenate the global shown on the Main Menu
 ;;;                           screen with this XREF, there will be data.
 ;;;
 ;;;     2) Pointers To This File - Lists all files that point to this file.
 ;;;
 ;;;     3) Pointers From This File - Lists all fields in this file that are
 ;;;                            pointers, and the files they point to. An 'M' in
 ;;;                            the far left column indicates the pointing field
 ;;;                            is a multiple. Use 'Trace a Field' to determine
 ;;;                            it's path.
 ;;;
 ;;;     4) Groups - In Filenanager Groups are a shorthand way for a user to
 ;;;                            call up several fields at once for Print or
 ;;;                            Entry/Edit purposes. Also, some programmers
 ;;;                            use Groups to keep track of locally added/alterred
 ;;;                            fields. See VA FILEMAN USER'S MANUAL to learn
 ;;;                            how to use Groups.
 ;;;
 ;;;     5) Trace a Field - Displays the pathway to fields that are decendent
 ;;;                          from a multiple.
 ;;;                          Example: When looking at PATIENT file, you type
 ;;;                          'MOV' at the 'Enter Field Name:' prompt. Trace
 ;;;                          a Field will display:
 ;;;                                  401 Admission Date/Time
 ;;;                                    5 Treating Specialty
 ;;;                                 1000 Movement Number
 ;;;                           This is the pathway to the MOVEMENT NUMBER field.
 ;;;                           You can now select 'I' and type in the field
 ;;;                           number of each field in the path. You will get
 ;;;                           the Individual Field Listing for the MOVEMENT
 ;;;                           NUMBER field.
 ;;;***
PAGE ;
 I FLAGP,IO'=IO(0) W @IOF,!!! Q
 R !!?2,"<RETURN> to continue, '^' to quit: ",XX:DTIME S:'$T XX="^" S:XX["^" FLAGQ=1 I FLAGQ Q
 W @IOF Q
INIT ;
 I FLAGP,IO=IO(0),IOSL>25 D SCROLL^XBHEDD7 Q:FLAGQ
 I FLAGP W:IO'=IO(0) "  Printing.." U IO
 W @IOF Q
