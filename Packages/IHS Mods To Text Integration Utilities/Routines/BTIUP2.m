BTIUP2 ; IHS/ITSC/LJF - POST INSTALL FOR PATCH 1002
 ;;1.0;TEXT INTEGRATION UTILITIES;**1002**;NOV 04, 2004
 ;
ENV ;EP environment check
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1001"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 Q
 ;
PATCH(X) ;return 1 if patch X was installed, X=aaaa*nn.nn*nnnn
 ;copy of code from XPDUTL but modified to handle 4 digit IHS patch numbers
 Q:X'?1.4UN1"*"1.2N1"."1.2N.1(1"V",1"T").2N1"*"1.4N 0
 NEW NUM,I,J
 S I=$O(^DIC(9.4,"C",$P(X,"*"),0)) Q:'I 0
 S J=$O(^DIC(9.4,I,22,"B",$P(X,"*",2),0)),X=$P(X,"*",3) Q:'J 0
 ;check if patch is just a number
 Q:$O(^DIC(9.4,I,22,J,"PAH","B",X,0)) 1
 S NUM=$O(^DIC(9.4,I,22,J,"PAH","B",X_" SEQ"))
 Q (X=+NUM)
 ;
PRE ;EP; beginning of pre install code
CLEAN ; clean out BTIU OBJECT DESCRIPTION file before restoring data
 NEW X
 S X=0 F  S X=$O(^BTIUOD(X)) Q:'X  K ^BTIUOD(X)
 K ^BTIUOD("B")
 S $P(^BTIUOD(0),U,3,4)="0^0"
 Q
 ;
POST ;EP; beginning of post install code
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
 NEW I,NAME,IEN
 F I=1:1 Q:$P($T(OBJECT+I),";;",2)=""  S NAME=$P($T(OBJECT+I),";;",2) D
 . S IEN=$O(^TIU(8925.1,"B",NAME,0))
 . I IEN S ^TIU(8925.1,IEN,9)=$P($T(OBJECT+I),";;",3)
 Q
 ;
OBJECT ;;
 ;;LAST BP;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"BP",0,1);;
 ;;LAST HEIGHT-DETAILED;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"HT",0,1);;
 ;;LAST PAIN;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"PA",0,1);;
 ;;LAST PULSE;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"PU",0,1);;
 ;;LAST RESPIRATION;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"RS",0,1);;
 ;;LAST TEMPERATURE;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"TMP",0,1);;
 ;;LAST WEIGHT - DETAILED;;S X=$$LASTMSR^BTIUPCC1(+$G(DFN),"WT",0,1);;
 ;;TIU HEADER;;S X=$S($L($T(LIST^CIAOTIUH)):$$LIST^CIAOTIUH(DFN,"^TMP(""TIUFLD"",$J)"),1:"");;
 ;;VCDICTATE NOTE IEN;;S X=$S($L($T(IEN^CIAOTIUH)):$$IEN^CIAOTIUH("CIAOTIUD"),1:"");;
 ;;VITALS FOR VISIT CONTEXT;;S X=$$VMSRD^BTIULO4("TMP(""VUECC"",$J)");;
