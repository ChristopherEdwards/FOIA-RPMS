XUINPRE1 ;SF/RSD - KERNEL 8.0 Patch  PRE-INITIALIZATION ; 25 Jan 96 09:16 [ 04/02/2003   8:29 AM ]
 ;;8.0;KERNEL;**1002,1003,1004,1005,1007**;APR 1, 2003
 ;;8.0;KERNEL;**15**;Jul 10, 1995
 ;Remove old identifiers
 K ^DD(9.6,0,"ID",1),^DD(9.7,0,"ID",.02)
 ;set new identifiers
 S ^DD(9.6,0,"ID","W1")="D:$P(^(0),U,2) EN^DDIOL(""   ""_$$EXTERNAL^DILFD(9.6,1,"""",$P(^(0),U,2)),"""",""?0"")"
 S ^DD(9.7,0,"ID","W1")="D ID97^XPDET"
 Q
