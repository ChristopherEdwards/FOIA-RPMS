ABSPOS6F ; IHS/FCS/DRS - debugging for ABSPOS ;  [ 09/12/2002  10:04 AM ]
 ;;1.0;PHARMACY POINT OF SALE;**3**;JUN 21, 2001
 Q
 ; Problem:  errors occurring in ABSPOS, but NEW commands
 ; and use of temp storage indexed by $J mean there's no wreckage
 ; to inspect.  Well, here, we copy some wreckage for analysis.
 ; It's a supplement to the main error log.
 ; Also, some extra $ZT set in ABSPOS itself, to hopefully save
 ; what data is otherwise lost as NEW stuff is unwound.
LOGERR(WHERE)      ;EP - from ABSPOS6I
 N ERRSPOT
 S ERRSPOT=$P($H,",",2)\600*600 ; leave ERRSPOT for error trap to report
 ; spread it out so only one every 10 minutes at most,
 ; just in case there's a flood of them (don't fill up disk)
 N ROU S ROU=$T(+0)
 K ^TMP("ABSPOS6F",$J,ERRSPOT)
 S ^TMP("ABSPOS6F",$J,ERRSPOT,"WHERE")=WHERE_" at "_$H
 M ^TMP("ABSPOS6F",$J,ERRSPOT,"ABSPOS")=^TMP("ABSPOS",$J)
 M ^TMP("ABSPOS6F",$J,ERRSPOT,"ABSPOSUA")=^TMP("ABSPOSUA",$J)
 I $D(VALMAR) M ^TMP("ABSPOS6F",$J,ERRSPOT,"VALMAR")=@VALMAR
 S ^TMP("ABSPOS6F",$J,ERRSPOT,"VALMCNT")=$G(VALMCNT)
 S ^TMP("ABSPOS6F",$J,ERRSPOT,"VALMBG")=$G(VALMBG)
 S ^TMP("ABSPOS6F",$J,ERRSPOT,"VALMAR")=$G(VALMAR)
 Q
