ADEENV ; IHS/HQT/MJL - ADA CODE TABLE UPDATE (CDT4) [ 06/19/2001  8:37 AM ]
 ;;6.0;ADE;**8,10,11,12**;JAN 15, 2002
EN ;
 ; The following line prevents the "DISABLE" and 'move routines'
 ; questions from being asked during the install.
 ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZW"))=0
 Q
