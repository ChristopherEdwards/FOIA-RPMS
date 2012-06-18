BTIUP6 ; IHS/CIA/MGH - POST INSTALL FOR PATCH 1006;02-Feb-2010 13:27;MGH
 ;;1.0;TEXT INTEGRATION UTILITIES;**1006**;SEPT 04, 2005
 ;
ENV ;EP environment check
 N PATCH
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;
 S PATCH="TIU*1.0*1005"
 I '$$PATCH(PATCH) D  Q
 . W !,"You must first install "_PATCH_"." S XPDQUIT=2
 ;Check for PCC patches
 S IN="IHS PCC SUITE 2.0",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the IHS PCC SUITE version 2.0 before installing TIU patch 1006" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"IHS PCC SUITE 2.0  must be completely installed before installing TIU patch 1006" S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
 ;Check for patch 6 of the EHR
 S IN="EHR*1.1*6",INSTDA=""
 I '$D(^XPD(9.7,"B",IN)) D  Q
 .W !,"You must first install the EHR patch 6 before installing patch TIU patch 1006" S XPDQUIT=2
 S INSTDA=$O(^XPD(9.7,"B",IN,INSTDA),-1)
 S STAT=+$P($G(^XPD(9.7,INSTDA,0)),U,9)
 I STAT'=3 D  Q
 .W !,"EHR patch 6 must be completely installed before installing TIU patch 1006" S XPDQUIT=2
 S (XPDDIQ("XPZ1"),XPDDIQ("XPZ2"))=0
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
