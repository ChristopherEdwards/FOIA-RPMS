XWBTEST ;TEST to see if listener is running [ 02/14/96  1:08 PM ]
 ;
 J ENTRY^XWBTEST
 Q
ENTRY N YY
 L +^XWB("TMP","RUNNING"):1
 I $T D
 . L -^XWB("TMP","RUNNING")
 . D STRT^XWBTCP(9200)
 . S Y=$$NOW^XLFDT D DD^%DT
 . D OPEN^%ZMAGOSF(51,"C:\ANONYMOUS\IMAGING\XWBLOG.TXT","A")
 . U 51 W "TCP Listener restarted at: ",Y,!
 . C 51
 H 10 G ENTRY
 Q
