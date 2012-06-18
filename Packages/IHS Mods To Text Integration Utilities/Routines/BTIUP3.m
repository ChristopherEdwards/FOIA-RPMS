BTIUP3 ; IHS/CIA/MGH - POST INSTALL FOR PATCH 1003;03-Jan-2006 11:22;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1003**;SEPT 04, 2005
 ;
ENV ;EP environment check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1002"
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
CLEAN ; Delete the BTIU OBJECT DESCRIPTION file
 NEW DIU
 S DIU=9003130.1,DIU(0)="DT"
 D EN^DIU2
 Q
 ;
POST ;EP; beginning of post install code
 D DOCDEF
 Q
 ;
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
