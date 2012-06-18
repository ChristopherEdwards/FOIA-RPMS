BDGSTAT2 ; IHS/ANMC/LJF - INPT STATS BY WARD ; 
 ;;5.3;PIMS;**1009,1013**;APR 26, 2002
 ;
 ;
 ;cmi/anch/maw  04/08/2007 PATCH 1009 requirement 24 added code to count swing beds
 ;ihs/cmi/maw 04/15/2011 PATCH 1013 RQMT155 add day surgery
 ;
 NEW BDGBD,BDGED,BDGIA,BDGTYP
 ;
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning Date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select Ending Date") Q:BDGED<1
 ;
 S BDGIA=$$READ^BDGF("Y","Include INACTIVE Wards","NO")
 ;
 ;S BDGTYP=$$READ^BDGF("S^1:Inpatients Only;2:Observation Patients Only;3:Both","Select Patient Type","BOTH") Q:BDGTYP=U
 S BDGTYP=$$READ^BDGF("S^1:Inpatients Only;2:Observation Patients Only;3:Day Surgery Patients Only;4:All","Select Patient Type","ALL") Q:BDGTYP=U  ;ihs/cmi/maw 04/15/2011 PATCH 1013 RQMT155  
 ;
 D ZIS^BDGF("PQ","EN^BDGSTAT2","STATS BY WARD","BDGBD;BDGED;BDGIA;BDGTYP")
 Q
 ;
EN ; -- main entry point for BDG STAT BY WARD
 I $E(IOST,1,2)="P-" D INIT,PRINT Q      ;if printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG STAT BY WARD")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 ;I BDGTYP=3 S X="Includes Inpatients AND Observations"
 I BDGTYP=4 S X="Includes Inpatients, Observations AND Day Surgery"
 E  S X=$S(BDGTYP=1:"Inpatients Only",BDGTYP=2:"Observations Only",1:"Day Surgery Only")
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW BDGDAYS,WARD,WRDNM,DATE,X,BDGA,Y,LINE,I,BDGNB,TOTAL
 K ^TMP("BDGSTAT2",$J)
 S VALMCNT=0,TOTAL=0
 S BDGDAYS=$$FMDIFF^XLFDT(BDGED,BDGBD)+1   ;# of days for division
 ;
 S WARD=0 F  S WARD=$O(^BDGCWD(WARD)) Q:'WARD  D
 . ;
 . ; quit if inactive and not including inactives
 . Q:'$D(^BDGWD(WARD))
 . I BDGIA=0,$$GET1^DIQ(9009016.5,WARD,.03)="INACTIVE" Q
 . S WRDNM=$$GET1^DIQ(9009016.5,WARD,.02)        ;ward abbrev
 . ;
 . S DATE=BDGBD-.001
 . F  S DATE=$O(^BDGCWD(WARD,1,DATE)) Q:DATE>BDGED  Q:'DATE  D
 .. ;
 .. ; if inpatient only or observation only
 .. I BDGTYP'=4 D ONLY(WARD,WRDNM,DATE) Q
 .. ;
 .. ; else grab all
 .. S X=$G(^BDGCWD(WARD,1,DATE,0))     ;grab data node
 .. D NEWBORN(WARD,DATE,.X)            ;subtract out newborn numbers
 .. ;cmi/maw 4/8/2007 PATCH 1009 requirement 24
 .. D SWING(WARD,DATE,.X)              ;subtract out swing bed numbers
 .. ;
 .. ; put data in column order (adm, txi, txo, dsc, dth)
 .. S Y=$P(X,U,3)_U_$P(X,U,5)_U_$P(X,U,6)_U_$P(X,U,4)_U_$P(X,U,7)
 .. ;  then add 1day pts, pat days (remaining + 1day pts)
 .. S Y=Y_U_$P(X,U,8)_U_($P(X,U,2)+$P(X,U,8))
 .. ;  then los (includes observation - converted from hours)
 .. S Y=Y_U_($P(X,U,9)+($P(X,U,11)\24))
 .. ;
 .. ; increment array for totals
 .. F I=1:1:8 S $P(BDGA(WRDNM),U,I)=$P($G(BDGA(WRDNM)),U,I)+$P(Y,U,I)
 .. F I=1:1:8 S $P(TOTAL,U,I)=$P($G(TOTAL),U,I)+$P(Y,U,I)
 ;
 ;
 S WARD=0 F  S WARD=$O(BDGA(WARD)) Q:WARD=""  D
 . S LINE=$$PAD(WARD,10)
 . F I=1:1:7 S LINE=LINE_$J($P(BDGA(WARD),U,I),4)_"  "
 . S LINE=LINE_$J($P(BDGA(WARD),U,7)/BDGDAYS,6,2)          ;adpl
 . S LINE=LINE_$J($P(BDGA(WARD),U,8),6)_" /"          ;losdsch
 . S X=$P(BDGA(WARD),3)+$P(BDGA(WARD),U,4)+$P(BDGA(WARD),U,5)
 . S LINE=LINE_$J($P(BDGA(WARD),U,8)\$S(X=0:1,1:X),3)      ;alos
 . S X=$P(BDGA(WARD),U)+$P(BDGA(WARD),U,2) S:X=0 X=1       ;#admit+txi
 . S LINE=LINE_$J($P(BDGA(WARD),U,7)\X,8)                  ;losadmit
 . D SET(LINE,.VALMCNT)
 ;
 ; add totals to display array
 S LINE=$$PAD("TOTAL:",10)
 F I=1:1:7 S LINE=LINE_$J($P(TOTAL,U,I),4)_"  "
 S LINE=LINE_$J($P(TOTAL,U,7)/BDGDAYS,6,2)      ;adpl
 S LINE=LINE_$J($P(TOTAL,U,8),7)_" /"      ;los
 S X=$P(TOTAL,U,3)+$P(TOTAL,U,4)+$P(TOTAL,U,5)  ;#txo+dsc+deaths
 S LINE=LINE_$J($P(TOTAL,U,8)\$S(X=0:1,1:X),3)  ;alos
 S X=$P(TOTAL,U)+$P(TOTAL,U,2) S:X=0 X=1        ;#admits+txi
 S LINE=LINE_$J($P(TOTAL,U,7)\X,8)              ;losadmit
 D SET($$REPEAT^XLFSTR("=",80),.VALMCNT),SET(LINE,.VALMCNT)
 ;
 ; add newborn stats to display array
 I $D(BDGNB) D
 . S LINE=$$PAD("NEWBORN:",10)
 . F I=1:1:7 S LINE=LINE_$J($P(BDGNB,U,I),4)_"  "
 . S LINE=LINE_$J($P(BDGNB,U,7)/BDGDAYS,6,2)       ;adpl
 . S LINE=LINE_$J($P(BDGNB,U,8),7)_" /"       ;losdsch
 . S X=$P(BDGNB,U,3)+$P(BDGNB,U,4)+$P(BDGNB,U,5)   ;#txo+dsc+deaths
 . S LINE=LINE_$J($P(BDGNB,U,8)\$S(X=0:1,1:X),3)   ;alos by discharge
 . S X=$P(BDGNB,U)+$P(BDGNB,U,2) S:X=0 X=1         ;#admits+txi
 . S LINE=LINE_$J($P(BDGNB,U,7)\X,8)               ;losadmit
 . D SET($$REPEAT^XLFSTR("-",80),.VALMCNT),SET(LINE,.VALMCNT)
 ;
 ; cmi/maw 04/08/2008 requirement 24 added for swing bed counts
 ; add swing bed stats to display array
 I $D(BDGSWING) D
 . S LINE=$$PAD("SWING BED:",10)
 . F I=1:1:7 S LINE=LINE_$J($P(BDGSWING,U,I),4)_"  "
 . S LINE=LINE_$J($P(BDGSWING,U,7)/BDGDAYS,6,2)       ;adpl
 . S LINE=LINE_$J($P(BDGSWING,U,8),7)_" /"       ;losdsch
 . S X=$P(BDGSWING,U,3)+$P(BDGSWING,U,4)+$P(BDGSWING,U,5)   ;#txo+dsc+deaths
 . S LINE=LINE_$J($P(BDGSWING,U,8)\$S(X=0:1,1:X),3)   ;alos by discharge
 . S X=$P(BDGSWING,U)+$P(BDGSWING,U,2) S:X=0 X=1         ;#admits+txi
 . S LINE=LINE_$J($P(BDGSWING,U,7)\X,8)               ;losadmit
 . D SET($$REPEAT^XLFSTR("-",80),.VALMCNT),SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGSTAT2",$J)) D SET("No data found",.VALMCNT)
 ;
 D LEGEND
 ;
 Q
 ;
ONLY(WARD,NAME,DATE) ;  find data by inpt service
 NEW SRV,X,Y,I
 S SRV=0 F  S SRV=$O(^BDGCWD(WARD,1,DATE,1,SRV)) Q:'SRV  D
 . S SRVNM=$$GET1^DIQ(45.7,SRV,.01)
 . I BDGTYP=1 Q:SRVNM["OBSERVATION"
 . I BDGTYP=2 Q:SRVNM'["OBSERVATION"
 . I BDGTYP=3 Q:SRVNM'="DAY SURGERY"  ;ihs/cmi/maw 04/15/2011 PATCH 1013 RQMT155
 . ;
 . S X=$G(^BDGCWD(WARD,1,DATE,1,SRV,0))      ;grab data node
 . ;
 . ; put data in column order (adm, txi)
 . S Y=($P(X,U,3)+$P(X,U,13))_U_($P(X,U,5)+$P(X,U,15))
 . ;  then add txo and dsch
 . S Y=Y_U_($P(X,U,6)+$P(X,U,16))_U_($P(X,U,4)+$P(X,U,14))
 . ;  and death
 . S Y=Y_U_($P(X,U,7)+$P(X,U,17))
 . ;  then add 1day pts
 . S Y=Y_U_($P(X,U,8)+$P(X,U,18))
 . ;  and pat days (remaining + 1day pts)
 . S Y=Y_U_($P(X,U,2)+$P(X,U,12)+$P(X,U,8)+$P(X,U,18))
 . ;  then los (includes observation - converted from hours)
 . S Y=Y_U_($P(X,U,9)+$P(X,U,19)+($P(X,U,11)\24)+($P(X,U,21)\24))
 . ;
 . ; increment array for totals
 . I SRVNM="NEWBORN" D  Q
 .. F I=1:1:8 S $P(BDGNB,U,I)=$P($G(BDGNB),U,I)+$P(Y,U,I)
 . I SRVNM="SWING BED" D  Q  ;cmi/maw 4/8/2008 PATCH 1009 requirement 24
 .. F I=1:1:8 S $P(BDGSWING,U,I)=$P($G(BDGSWING),U,I)+$P(Y,U,I)
 . ;
 . F I=1:1:8 S $P(BDGA(NAME),U,I)=$P($G(BDGA(NAME)),U,I)+$P(Y,U,I)
 . F I=1:1:8 S $P(TOTAL,U,I)=$P($G(TOTAL),U,I)+$P(Y,U,I)
 Q
 ;
NEWBORN(WARD,DATE,DATA) ; subtract out newborn numbers of ward and date
 NEW NEWB,X,I
 S NEWB=$O(^DIC(45.7,"B","NEWBORN",0)) Q:'NEWB
 S X=$G(^BDGCWD(WARD,1,DATE,1,NEWB,0)) Q:X=""   ;no data
 F I=1:1:11 S $P(DATA,U,I)=$P(DATA,U,I)-$P(X,U,I)
 Q
 ;
SWING(WARD,DATE,DATA) ; subtract out swing bed numbers of ward and date
 NEW SWING,X,I
 S SWING=$O(^DIC(45.7,"B","SWING BED",0)) Q:'SWING
 S X=$G(^BDGCWD(WARD,1,DATE,1,SWING,0)) Q:X=""   ;no data
 F I=1:1:11 S $P(DATA,U,I)=$P(DATA,U,I)-$P(X,U,I)
 Q
 ;
SET(DATA,NUM) ; put data into display array
 S NUM=NUM+1
 S ^TMP("BDGSTAT2",$J,NUM,0)=DATA
 Q
 ;
LEGEND ; add legend explaining column headings
 D SET("",.VALMCNT)
 D SET("ADM = admissions, TXI = ward transfers in",.VALMCNT)
 D SET("TXO = ward transfer out, DSC = discharges",.VALMCNT)
 D SET("DTH = deaths, 1DAY = admitted & discharged same day",.VALMCNT)
 D SET("DAYS = total patient days, ADPL = ave daily patient load",.VALMCNT)
 D SET("LOSD = length of stay for patients discharged: total / average",.VALMCNT)
 D SET("        (discharged = TXO + DSC + DTH)",.VALMCNT)
 D SET("LOSA = length of stay by admissions (inpt days/#ADM+TXI)",.VALMCNT)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSTAT2",$J)
 Q
 ;
PRINT ; print to paper
 NEW BDGLN,BDGPG
 U IO D INIT^BDGF,HDG
 S BDGLN=0 F  S BDGLN=$O(^TMP("BDGSTAT2",$J,BDGLN)) Q:'BDGLN  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGSTAT2",$J,BDGLN,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading if printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?31,"Statistics by Ward"
 NEW X S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X,?71,"Page: ",BDGPG
 I BDGTYP=3 S X="Includes Inpatients AND Observations"
 E  S X=$S(BDGTYP=1:"Inpatients Only",1:"Observations Only")
 W !,BDGDATE,?(80-$L(X)\2),X
 W !,"Ward",?11,"ADM",?17,"TXI",?23,"TXO",?29,"DSC",?35,"DTH",?40,"1DAY"
 W ?47,"DAYS",?55,"ADPL",?64,"LOSD",?74,"LOSA"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
