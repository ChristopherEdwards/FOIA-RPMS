XBHEDDH4 ;402,DJB,10/23/91,EDD - Help Text - Field Global Location cont.
 ;;2.6;IHS UTILITIES;;JUN 28, 1993
 ;;David Bolduc - Togus, ME
 F I=1:1 S TEXT=$P($T(TXT+I),";;;",2) Q:TEXT="***"  W !,TEXT I $Y>SIZE D PAGE Q:FLAGQ
 Q
TXT ;
 ;;;
 ;;;  5. 'N'        Allows you to do a look up by global node. At the 'Select NODE:'
 ;;;                prompt type '?' to see all nodes, or enter node. If that
 ;;;                node is a multiple you will be asked for subnode.You will then
 ;;;                get a list of all fields that are contained by that node.
 ;;;                You may do an 'Individual Field Summary' on any of them.
 ;;;                Example: If you wanted to know what fields are contained
 ;;;                         in ^DPT(34,"DA",3,"T",0) you would enter '^DPT' at
 ;;;                         the 'Select FILE:' prompt, select option 7, enter
 ;;;                         'N' for node, and then enter the following:
 ;;;                              Select NODE: 'DA'
 ;;;                              Select 'DA' SUBNODE: 'T'
 ;;;                              Select 'T' SUBNODE: '0'
 ;;;                         EDD will now display all the fields contained in
 ;;;                         the selected node and allow you to do an 'Individual
 ;;;                         Field Summary'.
 ;;;***
PAGE ;
 R !!?2,"<RETURN> to continue, '^' to quit: ",XX:DTIME S:'$T XX="^" S:XX="^" FLAGQ=1 I FLAGQ Q
 W @IOF Q
