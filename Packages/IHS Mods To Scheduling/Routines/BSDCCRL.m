BSDCCRL ; IHS/ANMC/LJF - LIST TEMPLATE FOR CLINIC CAPACTIY REPORT ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BSDRM CLINIC CAPACITY
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BSDRM CLINIC CAPACITY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 Q
 ;
INIT ; -- init variables and list array
 K ^TMP("BSDCCR",$J),^TMP("BSDCCR1",$J)
 D GUIR^XBLM("IHS^BSDCCR2","^TMP(""BSDCCR1"",$J,")
 S X=0 F  S X=$O(^TMP("BSDCCR1",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("BSDCCR",$J,X,0)=^TMP("BSDCCR1",$J,X)
 K ^TMP("BSDCCR1",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BSDCCR",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SUBT(SDTY) ;EP;Print subtitles
 ; called by SUBT^SCRPW72
 N SDI
 W !?(SDCOL+44),"Avail.",?(SDCOL+54),"Pct."
 I SDPAST W ?(SDCOL+60),"Actual",?(SDCOL+68),"---Future Appts---"
 W ! W:SDTY>1 ?(SDCOL),"Clinic Code"
 W ?(SDCOL+36),"Clinic",?(SDCOL+45),"Appt.",?(SDCOL+53),"Slots"
 W:SDPAST ?(SDCOL+60),"Clinic"
 I SDPAST W ?(SDCOL+70),"Total    Ave"
 W !?(SDCOL),$S(SDTY=1:"  Availability Date",1:"  Clinic Name")
 W ?(SDCOL+34),"Capacity",?(SDCOL+45),"Slots",?(SDCOL+52),"Avail."
 W:SDPAST ?(SDCOL+62),"Enc."
 I SDPAST W ?(SDCOL+70),"Made    Wait"
 W !?($S(SDTY>1:SDCOL,1:SDCOL+4)),$E(SDLINE,1,($S(SDPAST:80,1:58)-$S(SDTY=1:4,1:0)))
 Q
 ;
FOOT(SDTX) ;EP; Report footer for report
 ; called by FOOT^SCRPW75
 ;Input: SDTX=array to return text
 S SDTX(1)=SDLINE
 S SDTX(2)="NOTE:  Clinic Capacity    = total # of appointments slots"
 S SDTX(3)="       Avail. Appt. Slots = # of slots still open"
 S SDTX(4)="       Pct. Slots Avail.  = % of slots still open"
 I 'SDPAST S SDTX(5)=SDLINE Q
 S SDTX(5)="   If past dates selected:"
 S SDTX(6)="       Actual Clinic Enc. = # patients seen (checked in)"
 S SDTX(7)="       Total Made         = # new appointments made that day"
 S SDTX(8)="       Ave. Wait          = average # days between making appt & appt date"
 S SDTX(9)=SDLINE
 Q
 ;
CP ;EP;Get clinic codes for detailed report
 ; called by CP^SCRPW70
 N DIR,SDQUIT,X,CNT,Y
 W ! S Y=1,CNT=0
 F  Q:Y<1  D
 . S X=$S(CNT=1:"Another ",1:""),CNT=1
 . S Y=$$READ^BDGF("PO^40.7:EMQZ","Select "_X_"Clinic Code")
 . Q:Y<1  S CODE=$$GET1^DIQ(40.7,+Y,1),SDSORT(CODE)=CODE
 ;
