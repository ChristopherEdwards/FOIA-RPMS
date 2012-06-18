TIUPRDS ; SLC/SBW - Print Form 10-1000 Discharge Summaries ;2/4/93  07:52
 ;;1.0;TEXT INTEGRATION UTILITIES;;Jun 20, 1997
WRITE(TIUFLAG) ; Writes form 10-1000 data to screen or paper.
 N ZTRTN,%I,%T,%Y,POP
 S ZTRTN="ENTRY^TIUPRDS"
DEVICE ; Device handling
 ; Call with: ZTRTN
 N %ZIS,IOP
 S:$D(TIUDEV) %ZIS("B")=TIUDEV
 S %ZIS="Q" D ^%ZIS Q:POP
 S TIUDEV=ION
 G:$D(IO("Q")) QUE
NOQUE D @ZTRTN
 D ^%ZISC
 Q
QUE ; Queue output
 N %,ZTDTH,ZTIO,ZTSAVE,ZTSK
 Q:'$D(ZTRTN)  K IO("Q"),ZTSAVE F %="DA","DFN","TIU*" S ZTSAVE(%)=""
 S:'$D(ZTDESC) ZTDESC="PRINT DISCHARGE SUMMARY" S ZTIO=ION
 D ^%ZTLOAD W !,$S($D(ZTSK):"Request Queued!",1:"Request Cancelled!")
 K ZTSK,ZTDESC,ZTDTH,ZTIO,ZTRTN,ZTSAVE D ^%ZISC
 S IOP="HOME" D ^%ZIS
 Q
ENTRY ; Entry point to print queued discharge summary
 N TIUERR,TIUI,DFN,D0,DN,Y,DTOUT,DUOUT,DIRUT,DIROUT,TIU0,TIUINI
 K ^TMP("TIULQ",$J)
 S TIUINI=1 ; Indicate initials only for transcriber
 I $D(ZTQUEUED) S ZTREQ="@" ; Tell TaskMan to delete Task log entry
 U IO
 I '$D(^TMP("TIUPR",$J)) W !,"No Document Record Specified.",$C(7) Q
 S DFN=0 F  S DFN=$O(^TMP("TIUPR",$J,DFN)) Q:+DFN'>0  D
 . S TIUI=0 F  S TIUI=$O(^TMP("TIUPR",$J,DFN,TIUI)) Q:+TIUI'>0!$D(DIROUT)  D
 . . S TIUDA=0
 . . F  S TIUDA=+$O(^TMP("TIUPR",$J,DFN,TIUI,TIUDA)) Q:+TIUDA'>0!$D(DIROUT)  D
 . . . S TIU0=$G(^TIU(8925,+TIUDA,0))
 . . . I +$$ISADDNDM^TIULC1(TIUDA) S TIUDA=$P(TIU0,U,6)
 . . . D EXTRACT^TIULQ(+TIUDA,"^TMP(""TIULQ"",$J)",.TIUERR,"","",1)
 . . . I +$G(TIUERR) W !,$P(TIUERR,U,2) Q
 . . . Q:'$D(^TMP("TIULQ",$J))
 . . . D PRINT^TIUPRDS1(+TIUDA,$G(TIUFLAG))
 . . . K ^TMP("TIULQ",$J),^TMP("TIUPR",$J,DFN,TIUI,TIUDA)
 Q
