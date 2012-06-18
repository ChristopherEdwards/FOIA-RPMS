BTIUP1 ; IHS/ITSC/LJF - PRE-INSTALL ROUTINE FOR TIU PATCH 1001 ;
 ;;1.0;TEXT INTEGRATION UTILITIES;**1001**;NOV 04, 2004
 ;
ENV ;EP; envorinment check
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 ;Check for released version added IHS/ITSC/LJF 12/10/2004
 NEW IEN,PKG S PKG="TEXT INTEGRATION UTILITIES-IHS 1.0",IEN=$O(^XPD(9.6,"B",PKG,0))
 I 'IEN W !,"You must first install "_PKG_"." S XPDQUIT=2 Q
 I $$GET1^DIQ(9.6,IEN,.02,"I")'=3041110 D  Q
 . W !,"You have a test version of "_PKG_" installed."
 . W !?5,"Please install the released version first."
 . S XPDQUIT=2
 ;
 Q
 ;
PRE ;EP; beginning of pre install code
CLEAN ; clean out BTIU OBJECT DESCRIPTION file before restoring data
 NEW X
 S X=0 F  S X=$O(^BTIUOD(X)) Q:'X  K ^BTIUOD(X)
 K ^BTIUOD("B")
 S $P(^BTIUOD(0),U,3,4)="0^0"
 Q
 ;
POST ;EP; beginnig of post install code
 D OBJCHK,DOCDEF,OBJFIX
 Q
 ;
OBJCHK ; clean up object description file .01 pointers
 NEW IEN,DIE,PNAME,SNAME,PTR,DR,DA
 S DIE="^BTIUOD("
 S IEN=0 F  S IEN=$O(^BTIUOD(IEN)) Q:'IEN  D
 . S PNAME=$$GET1^DIQ(9003130.1,IEN,.01)     ;name based on pointer
 . S SNAME=$$GET1^DIQ(9003130.1,IEN,.02)     ;name as stored in .02 field
 . I PNAME=SNAME Q                           ;skip if names match - installed ok
 . ;
 . S PTR=$O(^TIU(8925.1,"B",SNAME,0)) I PTR D   ;find correct pointer
 . . I $$GET1^DIQ(8925.1,PTR,.04)'="OBJECT" Q   ;make sure it is an object
 . . S DR=".01///`"_PTR,DA=IEN
 . . D ^DIE                                     ;then fix it
 Q
 ;
DOCDEF ; clean up any dangling pointers in Document Definition file
 NEW DOC,ITEM,PTR,SEQ,TEXT
 S DOC=0 F  S DOC=$O(^TIU(8925.1,DOC)) Q:'DOC  D
 . Q:'$O(^TIU(8925.1,DOC,10,0))    ;no items
 . S ITEM=0
 . F  S ITEM=$O(^TIU(8925.1,DOC,10,ITEM)) Q:'ITEM  D
 . . S PTR=$P(^TIU(8925.1,DOC,10,ITEM,0),U)     ;item pointer
 . . Q:$D(^TIU(8925.1,PTR,0))                   ;skip if good pointer
 . . S SEQ=$P(^TIU(8925.1,DOC,10,ITEM,0),U,3)   ;sequence
 . . S TEXT=$P(^TIU(8925.1,DOC,10,ITEM,0),U,4)  ;menu text
 . . ;
 . . ; kill cross-references and main item entry
 . . K ^TIU(8925.1,DOC,10,"B",PTR,ITEM)
 . . I SEQ]"" K ^TIU(8925.1,DOC,10,"AC",SEQ,ITEM)
 . . I TEXT]"" K ^TIU(8925.1,DOC,10,"C",TEXT,ITEM)
 . . K ^TIU(8925.1,DOC,10,ITEM)
 Q
 ;
OBJFIX ; fix definition of objects previously sent
 S DA=$O(^TIU(8925.1,"B","VITALS FOR TODAY",0))
 I DA S ^TIU(8925.1,DA,9)="S X=$$TODAYVIT^BTIULO7(+$G(DFN))"
 Q
