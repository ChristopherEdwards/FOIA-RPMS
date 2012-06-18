ACDCNV ;IHS/ADC/EDE/KML - CONVERT CS 3TO4, 4TO3; [ 07/06/1999  4:22 PM ]
 ;;4.1;CHEMICAL DEPENDENCY MIS;**2**;MAY 11, 1998
 ; Modified for Y2k compliance  IHS/DSD/HJT  6/22/1999
 ;
 ; This routine converts CS visits from v3 to v4 style, and from
 ; v4 to v3 style, depending on the passed parameter.
 ;
EP(ACDDIR)         ;EP
 ; acddir determines direction of conversion.  3=v3tov4, 4=v4tov3
 D INIT
 Q:ACDQ
 D CONVERT
 D EOJ
 Q
 ;
INIT ; INITIALIZATION
 D ^XBKVAR
 S ACDQ=1
 S ACDDIR=$G(ACDDIR)
 I ACDDIR'=+ACDDIR D INITERR Q
 I "34"'[ACDDIR D INITERR Q
 K ^TMP("ACD",$J)
 D ^ACD
 S ACDHV=$O(^ACDVIS("A"),-1)
 S $P(^ACDVIS(0),U,3)=ACDHV
 S ACDQ=0
 Q
 ;
INITERR ; PARAMETER ERROR
 W !,"Invalid parameter!",!,*7
 Q
 ;
CONVERT ; CONVERT VISITS
 W !,"Converting visits "
 S ACDCTR=0
 S ACDVIEN=0
 F  S ACDVIEN=$O(^ACDVIS(ACDVIEN)) Q:'ACDVIEN!(ACDVIEN>ACDHV)  I $D(^ACDVIS(ACDVIEN,0)) S ACDVIS=^(0) I $P(ACDVIS,U,4)="CS" D CONVERT2
 Q
 ;
CONVERT2 ; CONVERT ONE CS VISIT
 S ACDCTR=ACDCTR+1
 W:'(ACDCTR#100) "."
 S ACDVDT=$P(ACDVIS,U) ;              visit date cyymmdd
 S ACDVDT5=$E(ACDVDT,1,5) ;           visit date cyymm
 S ACDVDAY=+$E(ACDVDT,6,7) ;          visit day of the month
 S ACDCOMPC=$P(ACDVIS,U,2) ;          component code ien
 S ACDPAT=$P(ACDVIS,U,5) ;            patient ien
 S ACDCOMPT=$P(ACDVIS,U,7) ;          component type
 S ACDBWP=$P($G(^ACDVIS(ACDVIEN,"BWP")),U) ;  program back pointer
 D @("CONVERT"_ACDDIR)
 Q
 ;
CONVERT3 ; CONVERT V3 TO V4 (this label used in indirect do)
 S ACDFV=0
 I '$D(^TMP("ACD",$J,ACDBWP,ACDPAT,ACDCOMPC,ACDCOMPT,ACDVDT5)) D FIXVSIT
 S ACDVTOV=^TMP("ACD",$J,ACDBWP,ACDPAT,ACDCOMPC,ACDCOMPT,ACDVDT5)
 S ACDCSIEN=0
 F  S ACDCSIEN=$O(^ACDCS("C",ACDVIEN,ACDCSIEN)) Q:'ACDCSIEN  D FIXCS
 Q:ACDFV  ;                  quit if first visit for month
 S DIK="^ACDVIS(",DA=ACDVIEN D DIK^ACDFMC
 Q
 ;
FIXVSIT ; FIX VISIT .01 FIELD
 S ^TMP("ACD",$J,ACDBWP,ACDPAT,ACDCOMPC,ACDCOMPT,ACDVDT5)=ACDVIEN
 Q:$E(ACDVDT,6,7)="00"  ;        visit already v4 style
 ;Begin Y2k fix    IHS/DSD/HJT 6/22/1999
 ; The date in this DIE string is sent through %DT without restrictions.
 ;  if, i.e. "10-00" (Oct 2000) is entered it will not evaluate properly
 ;S DIE="^ACDVIS(",DA=ACDVIEN,DR=".01///"_$E(ACDVDT,4,5)_"-"_$E(ACDVDT,2,3)
 ;%DT will require a 4-digit year in order to work properly...
 S DIE="^ACDVIS(",DA=ACDVIEN,DR=".01///"_$E(ACDVDT,4,5)_"-"_($E(ACDVDT,1,3)+1700)  ;Y2000
 ;End Y2k fix
 D DIE^ACDFMC
 S ACDFV=1
 Q
 ;
FIXCS ; SET .01 FIELD OF CS AND REPOINT
 S DR=""
 S:$E(ACDVDT,6,7)'="00" DR=".01///"_ACDVDAY_";"
 S DR=DR_"99.99////"_ACDVTOV
 S DIE="^ACDCS(",DA=ACDCSIEN
 D DIE^ACDFMC
 Q
 ;
CONVERT4 ; CONVERT V4 TO V3 (this label used in indirect do)
 Q:$E(ACDVDT,6,7)'="00"  ;       visit already v3 style
 K ^TMP("ACD",$J,"CS DAY")
 S ACDCSIEN=0
 F  S ACDCSIEN=$O(^ACDCS("C",ACDVIEN,ACDCSIEN)) Q:'ACDCSIEN  I $D(^ACDCS(ACDCSIEN,0)) S X=^(0),^TMP("ACD",$J,"CS DAY",$P(X,U),ACDCSIEN)=""
 S ACDCSDAY=0
 F  S ACDCSDAY=$O(^TMP("ACD",$J,"CS DAY",ACDCSDAY)) Q:'ACDCSDAY  D GENVSIT,REPOINT
 S DIK="^ACDVIS(",DA=ACDVIEN D DIK^ACDFMC ;    delete 00 day CS visit
 Q
 ;
GENVSIT ; GENERATE NEW VISIT
 S X=ACDVDT5_$S($L(ACDCSDAY)=1:"0",1:"")_ACDCSDAY
 S DIC="^ACDVIS(",DIC("DR")="",DIC(0)="L",DLAYGO=9002172.1
 D FILE^ACDFMC
 S ACDNVIEN=+Y
 S %X="^ACDVIS("_ACDVIEN_","
 S %Y="^ACDVIS("_ACDNVIEN_","
 D %XY^%RCR
 S X=ACDVDT5_$S($L(ACDCSDAY)=1:"0",1:"")_ACDCSDAY
 S $P(^ACDVIS(ACDNVIEN,0),U)=X
 S DIK="^ACDVIS(",DA=ACDNVIEN D IX1^DIK
 Q
 ;
REPOINT ; REPOINT CS TO NEW VISIT
 S ACDCSIEN=0
 F  S ACDCSIEN=$O(^TMP("ACD",$J,"CS DAY",ACDCSDAY,ACDCSIEN)) Q:'ACDCSIEN  D
 . S DIE="^ACDCS(",DA=ACDCSIEN,DR="99.99////"_ACDNVIEN
 . D DIE^ACDFMC
 . Q
 Q
 ;
EOJ ;
 K ^TMP("ACD",$J)
 D ^ACDKILL
 Q
