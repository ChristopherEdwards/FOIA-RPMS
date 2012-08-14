KLASMAN3 ;ROUTINE FOR CLASSROOM CRTS W/INSTRUCTION  PDW/CINCINNATI  ;DEC 18,1990@13:54:58 [ 07/28/93  3:11 PM ]
 ;;1.0
DOC U IO(0)
 W !!," INSTRUCTIONS FOR USING THIS PROGRAM ARE:",!!
 W !,?5,"Press CTRL-",$C(CTRL+64)," followed by:"
 W !,?10,"? ..... Review Instructions"
 W !,?10,"^ ..... Stop and Exit the Class"
 W !,?10,"# ..... Change Command Character"
 W !,?10,"char .. Send CTRL-char (for CTRL Characters that are not transparent)"
 W !,?10,"***********************************"
 W !,?10,"+ ..... Direct Input Mode"
 W !,?10,"* ..... Give Command to a Student"
 W !,?10,"= ..... Switch IO Device"
 W !,?10,"@ ..... Purge Student List"
 W !,?10,"% ..... System Status"
 W !,?10,"***********************************"
 W !,?10,"$ ..... Save Screens"
 W !,?10,"0 ..... Turn Broadcast Off"
 W !,?10,"1 ..... Turn Broadcast On"
 W !,?10,"& ..... Pickup A Class"
 W !,?10,"` ..... Xray View Text Buffer"
 W !!,?5,">> BE SURE TO EXIT YOUR APPLICATION BEFORE STOPPING THE CLASS.  <<"
 U IO(0) W !,"YOU ARE NOW CONNECTED TO YOUR APPLICATION, PLEASE CONTINUE.",!,"------->>ON-LINE MODE<<",!
 Q
PORT ;EP FOR PORT SELECTION
 B
 W !,"CURRENT DEVICE IS  ",ION S P2=ION X:KNAM'=ION ^%ZIS("C") U IO(0) X TERMNORM
 W !,"You are ",$S(KNAM=ION:"ON ",1:"LEAVING "),":",ION,! D:KNAM'=ION ^%ZISC
 S DIC="^%ZIS(1,",DIC(0)="EQMZ",X="KLASDEV",DIC("S")="I ($P(^(0),""^"")=KNAM)!(DIY'[""CLASS"")"
 D ^DIC S IOP=$S(Y>0:Y(0,0),1:KNAM) D ^%ZIS I POP W !,"SORRY ! BUSY !...",! S IOP=KNAM D ^%ZIS G PORT
 W !,"YOU ARE ON :",ION,!,$C(7) H 1 U IO(0) X TERMKLAS W !,"------>>ON LINE MODE<<",! U IO S X=0 X ^%ZOSF("RM"),^("EOFF"),^("TYPE-AHEAD"),^("TRMOFF")
 ;U IO:(0::::801001) ; CODE FOR MSM 2.1 UNIX
 ;U IO:(::::2097152) S X=0 X ^%ZOSF("RM") Q  ; CODE FOR READING SI  CTRL-O FOR DSM-11 FOR DSM
 Q
