ATX51P2 ; IHS/OHPRD/TMJ - PATCH 2 [ 03/13/01  8:59 PM ]
 ;;5.1;TAXONOMY;**2**;FEB 04, 1997
 ;
ENV ;EP - environment check
 ; The following line prevents the "Disable Options..." and "Move
 ; Routines..." questions from being asked during the install.
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 Q
