APCLXXBA ; IHS/OHPRD/TMJ -CREATED BY ^XBERTN ON APR 18, 1996 ;
 ;;3.0;IHS PCC REPORTS;;FEB 05, 1997
 ;;ATXSTX2 ; IHS/OHPRD/TMJ - SEND TAXONOMY WITH PACKAGE ; 
 ;; ;;5.1T1;TAXONOMY SYSTEM;;APR 18, 1996
 ;; ;
 ;; ;
 ;;BULL ;EP GENERATE OR UPDATE BULLETIN
 ;; S ATXBSBR=$O(^TMP("ATX",$J,3.6,0))
 ;; S ATXBULL=^TMP("ATX",$J,3.6,ATXBSBR,.01)
 ;; S ATXBIEN=$O(^XMB(3.6,"B",ATXBULL,0))
 ;; W !,$S(ATXBIEN:"Updating [",1:"Creating [")_ATXBULL_"] bulletin... "
 ;; I 'ATXBIEN D
 ;; . S X=ATXBULL,DIC="^XMB(3.6,",DIC(0)="L",DIC("DR")="",DIADD=1,DLAYGO=3.6
 ;; . D DIC
 ;; . I Y<0 W !!,"Adding bulletin failed.  Notify developer.",! Q
 ;; . S ATXBIEN=+Y
 ;; . Q
 ;; Q:'ATXBIEN
 ;; S DR="2////"_$G(^TMP("ATX",$J,3.6,ATXBSBR,2))
 ;; D BULLDIE
 ;; K ^XMB(3.6,ATXBIEN,1) ; kill message (field 10, subscript 1)
 ;; I $D(^TMP("ATX",$J,3.63,ATXBSBR,1,0)) S X=^(0) D
 ;; . S ^XMB(3.6,ATXBIEN,1,0)=X
 ;; . S ATXBMIEN=0
 ;; . F  S ATXBMIEN=$O(^TMP("ATX",$J,3.63,ATXBSBR,1,ATXBMIEN)) Q:'ATXBMIEN  S X=^(ATXBMIEN,0),^XMB(3.6,ATXBIEN,1,ATXBMIEN,0)=X
 ;; . Q
 ;; K ^XMB(3.6,ATXBIEN,3) ; kill message (field 6, subscript 3)
 ;; ; add new message
 ;; I $D(^TMP("ATX",$J,3.63,ATXBSBR,3,0)) S X=^(0) D
 ;; . S ^XMB(3.6,ATXBIEN,3,0)=X
 ;; . S ATXBMIEN=0
 ;; . F  S ATXBMIEN=$O(^TMP("ATX",$J,3.63,ATXBSBR,3,ATXBMIEN)) Q:'ATXBMIEN  S X=^(ATXBMIEN,0),^XMB(3.6,ATXBIEN,3,ATXBMIEN,0)=X
 ;; . Q
 ;; ; delete current parameter list
 ;; S ATXBMIEN=0
 ;; F  S ATXBMIEN=$O(^XMB(3.6,ATXBIEN,4,ATXBMIEN)) Q:'ATXBMIEN  D
 ;; . S DIK="^XMB(3.6,"_ATXBIEN_",4,",DA(1)=ATXBIEN,DA=ATXBMIEN
 ;; . D ^DIK
 ;; . Q
 ;; ; add new parameter list
 ;; S ATXBIENS=""
 ;; F  S ATXBIENS=$O(^TMP("ATX",$J,3.64,ATXBIENS)) Q:ATXBIENS=""  S X=^(ATXBIENS,.01) D
 ;; . S DIC="^XMB(3.6,"_ATXBIEN_",4,",DIC(0)="L",DIC("P")="3.64A",DA(1)=ATXBIEN
 ;; . D DIC
 ;; . Q:Y<0
 ;; . S ATXBMIEN=+Y
 ;; .; add wp description under parameter multiple
 ;; . I $D(^TMP("ATX",$J,3.64,ATXBIENS,1,0)) S X=^(0) D
 ;; .. S ^XMB(3.6,ATXBIEN,4,ATXBMIEN,1,0)=X
 ;; .. S ATXY=0
 ;; .. F  S ATXY=$O(^TMP("ATX",$J,3.64,ATXBIENS,1,ATXY)) Q:'ATXY  S X=^(ATXY,0),^XMB(3.6,ATXBIEN,4,ATXBMIEN,1,ATXY,0)=X
 ;; .. Q
 ;; . Q
 ;; Q
 ;; ;
 ;;BULLDIE ; ^DIE CALLS FOR BULLETIN
 ;; Q:DR=""
 ;; S DIE="^XMB(3.6,",DA=ATXBIEN
 ;; D DIE
 ;; Q
 ;; ;
 ;;TAX ;EP GENERATE OR UPDATE TAXONOMY
 ;; S ATXTSBR=$O(^TMP("ATX",$J,9002226,0))
 ;; S ATXTNAM=^TMP("ATX",$J,9002226,ATXTSBR,.01)
 ;; S ATXTIEN=$O(^ATXAX("B",ATXTNAM,0))
 ;; W !,$S(ATXTIEN:"Updating [",1:"Creating [")_ATXTNAM_"] taxonomy... "
 ;; I 'ATXTIEN D
 ;; . S X=ATXTNAM,DIC="^ATXAX(",DIC(0)="L",DIC("DR")="",DIADD=1,DLAYGO=9002226
 ;; . NEW ATXFLG S ATXFLG=1
 ;; . D DIC
 ;; . I Y<0 W !!,"Adding taxonomy failed.  Notify developer.",! Q
 ;; . S ATXTIEN=+Y
 ;; . Q
 ;; Q:'ATXTIEN
 ;; S DR=".05////.5" S:$G(ATXBIEN) DR=DR_";.07////"_ATXBIEN
 ;; S ATXFIELD=""
 ;; F  S ATXFIELD=$O(^TMP("ATX",$J,9002226,ATXTSBR,ATXFIELD)) Q:ATXFIELD=""  S X=^(ATXFIELD),DR=DR_";"_ATXFIELD_"////"_X
 ;; D TAXDIE
 ;; ; delete current code list
 ;; S ATXTMIEN=0
 ;; F  S ATXTMIEN=$O(^ATXAX(ATXTIEN,21,ATXTMIEN)) Q:'ATXTMIEN  D
 ;; . S DIK="^ATXAX("_ATXTIEN_",21,",DA(1)=ATXTIEN,DA=ATXTMIEN
 ;; . D ^DIK
 ;; . Q
 ;; ; add new code list
 ;; S ATXTIENS=""
 ;; F  S ATXTIENS=$O(^TMP("ATX",$J,9002226.02101,ATXTIENS)) Q:ATXTIENS=""  S X=^(ATXTIENS,.01) D
 ;; . S DIC="^ATXAX("_ATXTIEN_",21,",DIC(0)="L",DIC("P")="9002226.02101A",DA(1)=ATXTIEN
 ;; . S Y=$G(^TMP("ATX",$J,9002226.02101,ATXTIENS,.02))
 ;; . S:Y'="" DIC("DR")=".02////"_Y
 ;; . D DIC
 ;; . Q
 ;; Q
 ;; ;
 ;;TAXDIE ; ^DIE CALL FOR TAX
 ;; Q:DR=""
 ;; S DIE="^ATXAX(",DA=ATXTIEN
 ;; D DIE
 ;; Q
 ;; ;
 ;;DIC ; CALL ^DIC
 ;; D ^DIC
 ;; K D,DD,D0,D1,DA,DI,DIADD,DIC,DICR,DIE,DIPGM,DLAYGO,DO,DQ,DR,DINUM
 ;; Q
 ;; ;
 ;;DIE ; CALL ^DIE
 ;; D ^DIE
 ;; K D,D0,D1,DI,DIADD,DIC,DICR,DIE,DLAYGO,DQ,DR,DINUM
 ;; Q
 ;; ;
 ;;KILL ;EP KILL VARIABLES AND ^TMP GLOBAL ENTRIES
 ;; D EN^XBVK("ATX")
 ;; K ^TMP("ATX",$J)
 ;; Q
