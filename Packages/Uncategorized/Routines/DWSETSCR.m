DWSETSCR ;NEW PROGRAM [ 02/25/92  1:48 PM ]
 ;this progrm written by dan walz, pimc, phoenix
 ;when called set variables for screen enhancement
 ;IV=INVERSE VIDEO
 ;NO=NORMAL INTENSITY
 ;HI=HI INTENSITY
 ;BLK=BLINK
BEGIN S IV=$C(27)_"[7m"
 S NO=$C(27)_$C(91)_$C(109)
 S HI=$C(27)_$C(91)_$C(49)_$C(109)
 S BLK=$C(27)_"[5m"
 Q
KILL K IV,NO,HI,BLK
 Q
