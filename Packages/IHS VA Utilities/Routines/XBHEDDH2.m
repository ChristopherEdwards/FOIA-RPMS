XBHEDDH2 ;402,DJB,10/23/91,EDD - Help Text - Main Menu cont.
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
 F I=1:1 S TEXT=$P($T(TXT+I),";;;",2) Q:TEXT="***"  W !,TEXT I $Y>SIZE D PAGE Q:FLAGQ
 Q
TXT ;
 ;;;
 ;;;     6) Individual Field Summary - Lists contents of the Data Dictionary
 ;;;                           for selected field. This option is equivalent
 ;;;                           to Filemanager's LIST FILE ATTRIBUTES.
 ;;;
 ;;;     7) Field Global Location - List of all fields and their global
 ;;;                           location (NODE;PIECE). See the 'HELP' that's
 ;;;                           available in this option.
 ;;;
 ;;;     8) Templates - Lists Print, Sort, and Input templates. If
 ;;;                           listing is too long for any type, you may
 ;;;                           enter 'S' and skip over to next type.
 ;;;
 ;;;     9) File Description - Narrative describing the selected file.
 ;;;
 ;;;     10) List Globals In ASCII Order - Gives listing of your system's globals
 ;;;                             sorted in ASCII order. Includes file number
 ;;;                             and name. Example: If you are looking at the
 ;;;                             RADIOLOGY PATIENT file, the Main Menu screen
 ;;;                             shows it's data global as ^RADPT. If you
 ;;;                             wanted to identify other Radiology files,
 ;;;                             you would use this option and start the
 ;;;                             listing at ^R.
 ;;;
 ;;;     11) File Characteristics  - Displays post-selection actions, special
 ;;;                             look-up programs, and identifiers. For more
 ;;;                             information on any of these topics see Chapter 5
 ;;;                             Section D of the VA Fileman Programmers' manual
 ;;;                             (Version 18).
 ;;;
 ;;;     12) Printing On/Off  - Allows you to send screens to a printer. You will
 ;;;                             be offered the DEVICE: prompt. Enter printer.
 ;;;                             After <RETURN>, Main Menu will reappear and
 ;;;                             PRINTING STATUS, in the top half of the screen,
 ;;;                             will be set to 'ON'. You then select a Main
 ;;;                             Menu option and output will go to the selected
 ;;;                             device. When you return to the Main Menu,
 ;;;                             PRINTING STATUS will be 'OFF'. To print again
 ;;;                             you must select Printing On/Off option again
 ;;;                             to reset PRINTING STATUS to 'ON'. If PRINTING
 ;;;                             STATUS is 'ON' you may turn it off by selecting
 ;;;                             Printing On/Off option again. To slave
 ;;;                             print, enter '0;;60' at the DEVICE: prompt.
 ;;;
 ;;;                             NOTE: Since all screens are designed to be
 ;;;                             displayed on a CRT, printing to a 10 pitch,
 ;;;                             80 margin printer looks best.
 ;;;***
PAGE ;
 I FLAGP,IO'=IO(0) W @IOF,!!! Q
 R !!?2,"<RETURN> to continue, '^' to quit: ",XX:DTIME S:'$T XX="^" S:XX="^" FLAGQ=1 I FLAGQ Q
 W @IOF Q
