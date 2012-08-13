INHUTST ;DGH; 10 May 96 13:39; Utility routine with stub tags
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
STORE ;This is a test lookup-store routine for incoming DBSS messages.
 ;It simply quits.
 Q
 ;
QUIT ;Just quit
 Q
 ;
TF(%) ;set $T to true or false
 ;% - value for $T ( 1 or 0 (def) )
 I '$G(%) D FALSE Q
 D TRUE
 Q
TRUE ;Sets $T to 1
 I 1
 Q
FALSE ;Set $T to 0
 I 0
 Q
DEST ;Tag dest contains allowable message types for incoming messages
 S INDSTP=""
 Q
