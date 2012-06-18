TIUPRCN ; SLC/JER - Driver to Print Form 513 Consult Reports ;3/9/98@17:00:31
 ;;1.0;TEXT INTEGRATION UTILITY;**4**;Jun 20, 1997
ENTRY ; Entry point to print SF 513
 N TIUERR,TIUI,TIUJ,D0,DN,Y,DTOUT,DUOUT,DIRUT,DIROUT,TIU0,TIU14,TIUINI
 K ^TMP("TIULQ",$J)
 S TIUINI=1 ; Indicate initials only for transcriber
 I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
 U IO
 I '$D(^TMP("TIUPR",$J)) W !,"No Document Record Specified.",$C(7) Q
 S TIUJ=0 F  S TIUJ=$O(^TMP("TIUPR",$J,TIUJ)) Q:+TIUJ'>0  D
 . S TIUI=0 F  S TIUI=$O(^TMP("TIUPR",$J,TIUJ,TIUI)) Q:+TIUI'>0!$D(DIROUT)  D
 . . S TIUDA=0
 . . F  S TIUDA=+$O(^TMP("TIUPR",$J,TIUJ,TIUI,TIUDA)) Q:+TIUDA'>0!$D(DIROUT)  D
 . . . S TIU0=$G(^TIU(8925,+TIUDA,0)),TIU14=$G(^(14))
 . . . I +$$ISADDNDM^TIULC1(TIUDA) S TIUDA=$P(TIU0,U,6)
 . . . S TIUCDA=+$P(TIU14,U,5)
 . . . I +TIUCDA'>0 D  Q
 . . . . ; W !!,"This Consult Result is not associated with a request.",!
 . . . . D ENTRY^TIUPRPN
 . . . . ; I $E(IOST)="C",$$READ^TIUU("EA","Press RETURN to continue...")
 . . . . K ^TMP("TIUPR",$J,TIUJ,TIUI,TIUDA)
 . . . N VALMAR,VALMCNT,VALMPGE
 . . . D TIUEN^GMRCP513(TIUCDA)
 . . . I $E(IOST)="C",$$READ^TIUU("EA","Press RETURN to continue...")
 . . . K ^TMP("TIUPR",$J,TIUJ,TIUI,TIUDA)
 Q
