AGGEV1P1 ;VNGT/HS/ALA-Environmental check program ; 03 Jan 2011  2:24 PM
 ;;1.0;PATIENT REGISTRATION GUI;**1**;Nov 15, 2010
 ;;
EN ;
 I $G(XPDENV)=1 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 F X="XPO1","XPZ1","XPZ2","XPI1" S XPDDIQ(X)=0
 I $$VERSION^XPDUTL("AGG")'="1.0" W !,"Version 1.0 of Patient Registration GUI is required",!! D  Q
 . K DIFQ
 . S XPDQUIT=1
 Q
