BSDSCPAT ; IHS/ANMC/LJF - Provider's Patients ;
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDSC PRACT PATIENTS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDSCPAT",$J),^TMP("BSDSCPAT1",$J)
 D GUIR^XBLM("IHS^SCRPPAT","^TMP(""BSDSCPAT1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDSCPAT1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDSCPAT",$J,X,0)=^TMP("BSDSCPAT1",$J,X)
 K ^TMP("BSDSCPAT1",$J)
 Q
 ;
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 D END^SCRPW50 K ^TMP("BSDSCPAT",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
FORMAT ;EP; formats data dislay line
 ; called by STOR^SCRPPAT2
 S @STORE@(IIEN,SEC,TRD,TPI,PIEN)=PTNAME
 S $E(@STORE@(IIEN,SEC,TRD,TPI,PIEN),22)=$P(PINF,U,3)  ;HRCN
 S $E(@STORE@(IIEN,SEC,TRD,TPI,PIEN),32)=$P(PINF,"^",8)  ;last appt
 S $E(@STORE@(IIEN,SEC,TRD,TPI,PIEN),52)=$P(PINF,"^",9)  ;nxt appt
 Q
 ;
SHEAD ;EP; set up column headings
 ; called by SHEAD^SCRPPAT3
 S @STORE@("H2")="Pt Name"
 S $E(@STORE@("H2"),22)="Pt ID"
 S $E(@STORE@("H1"),32)="Last Team"
 S $E(@STORE@("H2"),32)="Appt & Clinic"
 S $E(@STORE@("H1"),52)="Next Team"
 S $E(@STORE@("H2"),52)="Appt & Clinic"
 S $P(@STORE@("H3"),"=",80)=""
 Q
