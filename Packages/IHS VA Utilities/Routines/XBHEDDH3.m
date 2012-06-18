XBHEDDH3 ;402,DJB,10/23/91,EDD - Help Text - Field Global Location
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
 ;;Called by XBHEDD1
 W @IOF
 F I=1:1 S TEXT=$P($T(TXT+I),";;;",2) Q:TEXT="***"  W !,TEXT I $Y>SIZE D PAGE Q:FLAGQ
 I 'FLAGQ D ^XBHEDDH4
EX ;
 K TEXT I 'FLAGQ D PAUSE
 Q
TXT ;
 ;;;     INPUT               EFFECT
 ;;;==========================================================================
 ;;;
 ;;;  1.   '^'      Exit back to Main Menu.
 ;;;
 ;;;  2.   'B'      Back up to previous screen.
 ;;;
 ;;;  3.   'n'      Typing a number here allows you to jump to that screen.
 ;;;                In the lower right hand corner of the screen, you will
 ;;;                see 2 numbers: TOP and CUR. TOP is the highest screen
 ;;;                you have <RETURNED> to. CUR is the current screen you
 ;;;                are viewing. You can only jump between the first and TOP
 ;;;                screen. As an example, if you selected the 'Field Global
 ;;;                Location' option and then hit <RETURN> 6 times, TOP would
 ;;;                be equal to 6 and CUR would be equal to 6. Now you can jump
 ;;;                to any screen between 1 and 6. If you entered '2' and <RETURN>,
 ;;;                you would jump to screen 2. TOP would still be equal to 6 but
 ;;;                CUR would now be 2. If you then hit 'B' to back up 1 screen,
 ;;;                TOP would be 6 and CUR would be 1. If you now wanted to return
 ;;;                to TOP (screen 6), you would type a '6' and this page
 ;;;                would now be displayed. TOP and CUR would both be equal
 ;;;                to 6 again.
 ;;;
 ;;;  4.  'I'       Allows you to zoom in on an individual field. It prompts you
 ;;;                for a field and then gives you the Individual Field Summary
 ;;;                for that field. When using 'I', you must start at the top
 ;;;                of the multiple. For example, if you were looking at the
 ;;;                Patient file and you had selected 'Admission Date' as the
 ;;;                starting point for Field Global Location and you <RETURNED>
 ;;;                thru 2 screens, you would see the field Treating Specialty.
 ;;;                To view the Individual Field Summary for this field you would
 ;;;                have to first select Admission Date and then Treating Specialty.
 ;;;                This is made easier by the design of the Field Global Location
 ;;;                screens. Each layer of multiple fields is preceeded by
 ;;;                dashes that indicated their level. You trace these dashes
 ;;;                back to locate the starting point for each layer. You can
 ;;;                also use the Trace a Field option.
 ;;;***
PAGE ;
 R !!?2,"<RETURN> to continue, '^' to quit: ",XX:DTIME S:'$T XX="^" S:XX["^" FLAGQ=1 I FLAGQ Q
 W @IOF Q
PAUSE ;
 I $Y<SIZE F I=1:1:(SIZE-$Y) W !
 R !?2,"<RETURN> to continue..",XX:DTIME
 Q
