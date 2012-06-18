TIUESFIX ; SLC/JER - find/fix entries w/o es-blocks ;9/1/98@10:20:48
 ;;1.0;TEXT INTEGRATION UTILITIES;**33**;Jun 20, 1997
MAIN ; Control branching
 N TIUDA S TIUDA=0
 F  S TIUDA=$O(^TIU(8925,TIUDA)) Q:+TIUDA'>0  D FIXREC(TIUDA)
 Q
FIXREC(DA) ; Fix bad records
 N TIUD0,TIUD15
 S TIUD0=$G(^TIU(8925,DA,0)),TIUD15=$G(^(15))
 ; If 15-node doesn't exist, continue to next record
 I '$L(TIUD15) W "." Q
 ; If the document is deleted, then continue to next record
 I $P(TIUD0,U,5)=14 W "." Q
 ; If signed, and signature block name empty, fill it in
 I +$P(TIUD15,U,2),'$L($P(TIUD15,U,3)) D
 . N DIE,DR S DIE=8925
 . S DR="1503///^S X=$$SIGNAME^TIULS("_+$P(TIUD15,U,2)_")"
 . I '$L($P(TIUD15,U,4)) S DR=DR_";1504///^S X=$$SIGTITL^TIULS("_$P(TIUD15,U,2)_")"
 . D ^DIE W !,"Record #",DA,": Signature block corrected."
 . D SEND^TIUALRT(DA),SIGNIRT^TIUDIRT(+DA)
 ; If cosigned, and cosignature block name empty, fill it in
 I +$P(TIUD15,U,8),'$L($P(TIUD15,U,9)) D
 . N DIE,DR S DIE=8925
 . S DR="1509///^S X=$$SIGNAME^TIULS("_+$P(TIUD15,U,8)_")"
 . I '$L($P(TIUD15,U,10)) S DR=DR_";1510///^S X=$$SIGTITL^TIULS("_$P(TIUD15,U,8)_")"
 . D ^DIE W !,"Record #",DA,": Cosignature block corrected."
 . D SEND^TIUALRT(DA),SIGNIRT^TIUDIRT(+DA)
 W "."
 Q
