TIUFZZ60 ; SLC/MAM - Post Patch TIU*1*17 Cleanup. Scratch.  Reindexes B xref in TIU DOCUMENT DEFINITION FILE ;8/27/97  14:02
 ;;1.0;TEXT INTEGRATION UTILITIES;**17**;Jun 20, 1997
 ;
RINDEX ; Reindex B xref for file 8925.1 after changing to 60 chars with
 ;patch TIU*1*17.  Done in Post Install.
 N DA,DIK,NAME
 W !!,"Reindexing Document Definition File, 'B' Cross-reference",!!
 S DA=0,DIK="^TIU(8925.1,",DIK(1)=".01^B"
 F  S DA=$O(^TIU(8925.1,DA)) Q:'DA  W:DA#100=1 "." D
 . S NAME=$P($G(^TIU(8925.1,DA,0)),U) Q:NAME=""
 . K ^TIU(8925.1,"B",$E(NAME,1,30),DA)
 . D EN1^DIK
 Q
 ;
