BPXRMP1 ;IHS/CIA/MGH - Pre-Init routine for PXRM 1.5 patch 1001 ;08-Feb-2005 11:33;MGH
 ;;1.5;CLINICAL REMINDERS;**1001**;Jun 19, 2000
 ;
ENV ;EP
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for released version added IHS/ITSC/LJF 12/10/2004
 NEW IEN,PKG S PKG="CLINICAL REMINDERS - IHS 1.5",IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install "_PKG_"; part of the Visit Tracking Suite v2.0." S XPDQUIT=2 Q
 I $$GET1^DIQ(9.6,IEN,.02,"I")'=3040709 D  Q
 . W !,"You have a test version of "_PKG_" installed."
 . W !?5,"Please install the released Visit Tracking Suite v2.0 first."
 . S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
DELDD ; Delete DD for Reminder Definition Findings SubFile
 N DIU
 F DIU=811.902,811.52 D
 .S DIU(0)="S"
 .D EN^DIU2
 S DIU=801.41,DIU(0)="" D EN^DIU2
 Q
 ;
POST ;EP
 ; Fix Out of Order Message for PXRM routines
 ; except for a select few
LOOP N HNAM,FROM
 S HNAM="PXRM",FROM=HNAM
 F  S HNAM=$O(^DIC(19,"B",HNAM)) Q:HNAM=""!($E(HNAM,1,$L(FROM))'=FROM)  D
 .S HIEN=0 F  S HIEN=$O(^DIC(19,"B",HNAM,HIEN)) Q:'HIEN  D
 ..D FIXOMSG(HIEN,HNAM)
 Q
FIXOMSG(OPT,NAME) ;
 N VAL,FDA,IEN
 S IEN=$$FIND1^DIC(19,,"X",NAME)
 I IEN D
 .Q:((NAME["OTHER")!(NAME["EXTRACT")!(NAME["MST"))
 .S VAL=""
 .S FDA(19,IEN_",",2)=VAL
 .D FILE^DIE("K","FDA")
 Q
