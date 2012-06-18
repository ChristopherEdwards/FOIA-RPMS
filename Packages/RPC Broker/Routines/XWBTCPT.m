XWBTCPT ;SLC/KCM - Test functions for TCP [ 12/05/94  10:45 PM ]
 ;;1.0T11;RPC BROKER;;Oct 31, 1995
 ;
ECHO(Y,X) ; -- echo string passed as parameter back to client
 ;  input:  X := string passed by client
 ; output:  Y := same string to be returned
 S Y=X
 Q
LIST(Y) ; -- return list box with 28 entries
 N I
 F I=1:1:28 S Y(I)="List Item #"_I
 Q
WP(Y) ; -- return text a word processing (50 lines)
 N I
 F I=1:1:50 S Y(I)="The quick brown fox jumped over the lazy dog."
 S Y(51)="End of document."
 Q
BIG(Y) ; -- send a 32K string
 N I
 F I=1:1:320 S $P(Y(I),"D",100)=""
 Q
WNP ; -- start Windows Notepad
 D STARTAPP^XWBTCPZ("c:\windows\notepad.exe",.ERR)
 I $L(ERR) W !,"Error starting Notepad: ",ERR
 Q
MSW ; -- start Microsoft Word
 D STARTAPP^XWBTCPZ("c:\winword\winword.exe",.ERR)
 I $L(ERR) W !,"Error starting MS Word: ",ERR
 Q
OE3 ; -- start windowed OE/RR
 D STARTAPP^XWBTCPZ("c:\dhcpapps\tcpchart.exe",.ERR,1)
 I $L(ERR) W !,"Error starting OE/RR: ",ERR
 Q
ZTST ; -- start ZZTEST program
 D STARTAPP^XWBTCPZ("c:\dhcpapps\zttest.exe",.ERR,1)
 I $L(ERR) W !,"Error starting ZZTEST: ",ERR
 Q
CRYPT ; -- test encryption
 R "Enter text: ",X
 S X=$$NCRYPT^XWBTCPZ(X,"SECRET") W !,"Encrypted: ",X
 S X=$$DCRYPT^XWBTCPZ(X,"SECRET") W !,"Decrypted: ",X
 Q
