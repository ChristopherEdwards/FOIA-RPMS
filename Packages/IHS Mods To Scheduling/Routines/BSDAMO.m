BSDAMO ; IHS/ANMC/LJF - IHS MODS TO APPT MGT REPORT ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ;EP; -- main entry point for BSDRM APPT MGT
 NEW VALMCNT D TERM^VALM0
 D EN^VALM("BSDRM APPT MGT")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDAMO",$J),^TMP("BSDAMO1",$J)
 D GUIR^XBLM("START^SDAMOS","^TMP(""BSDAMO1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDAMO1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDAMO",$J,X,0)=^TMP("BSDAMO1",$J,X)
 K ^TMP("BSDAMO1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDAMO",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
LEGEND ;EP; Legend on bottom of output
 ; called by LEGEND^SDAMOSP
 ;
 W !?5,"* CI=Checked-In ; RB=Rebooked"
 W !?5,"* Cancelled appointments only reflect appointments cancelled using"
 W !?7,"the ""Cancel Clinic Availability"" option, not Cancel Appointment."
 W !?5,"* Checked-In does not include no-shows or cancelled appointments"
 W !?7,"that have been checked in.  They are listed under those categories.",!
 Q
 ;
