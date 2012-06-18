XPARY26   ;SLC/KCM - convert "AG" xref ;06:15 PM  22 Apr 1998 [ 04/02/2003   8:47 AM ]
 ;;7.3;TOOLKIT;**1001**;APR 1, 2003
 ;;7.3;TOOLKIT;**26**;Apr 25, 1995
AG ; reindex 8989.51 so that "AG" xref has subscript "30"
 N IEN,DA,DIK,DIC,X,Y
 S IEN=0 F  S IEN=$O(^XTV(8989.51,IEN)) Q:'IEN  D
 . I '$D(^XTV(8989.51,IEN,"AG")) Q  ; nothing to convert
 . K ^XTV(8989.51,IEN,"AG"),DIK,DA
 . S DA(1)=IEN,DIK="^XTV(8989.51,"_DA(1)_",30,",DIK(1)=".02^AG"
 . D ENALL^DIK
 Q
