BDGSTAT3 ; IHS/ANMC/LJF - INPT STATS BY SERV ;  [ 06/16/2003  2:47 PM ]
 ;;5.3;PIMS;**1013**;APR 26, 2002
 ;
 ;ihs/cmi/maw 04/15/2011 PATCH 1013 RQMT155
 ;
 NEW BDGBD,BDGED,BDGIA,BDGTYP
 ;
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning Date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select Ending Date") Q:BDGED<1
 ;
 S BDGIA=$$READ^BDGF("Y","Include INACTIVE Services","NO")
 ;
 ;S BDGTYP=$$READ^BDGF("S^1:Inpatient Services Only;2:Observation Services Only;3:Both","Select Patient Type","BOTH") Q:BDGTYP=U
 S BDGTYP=$$READ^BDGF("S^1:Inpatients Only;2:Observation Patients Only;3:Day Surgery Patients Only;4:All","Select Patient Type","ALL") Q:BDGTYP=U  ;ihs/cmi/maw 04/15/2011 PATCH 1013 RQMT155  
 ;
 D ZIS^BDGF("PQ","EN^BDGSTAT3","STATS BY SERV","BDGBD;BDGED;BDGIA;BDGTYP")
 Q
 ;
EN ; -- main entry point for BDG STAT BY SERV
 I $E(IOST,1,2)="P-" D INIT,PRINT Q     ;if printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG STAT BY SERVICE")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(1)=$$SP(75-$L(X)\2)_X
 I BDGTYP=4 S X="Includes Inpatients, Observations AND Day Surgery"
 E  S X=$S(BDGTYP=1:"Inpatients Only",BDGTYP=2:"Observations Only",1:"Day Surgery Only")
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW BDGDAYS,SERV,SVABV,DATE,X,BDGA,Y,Y1,LINE,I,TOTAL,AGE
 K ^TMP("BDGSTAT3",$J)
 S (VALMCNT,TOTAL,TOTAL("A"),TOTAL("P"))=0
 S BDGDAYS=$$FMDIFF^XLFDT(BDGED,BDGBD)+1   ;# of days for division
 ;
 S SERV=0 F  S SERV=$O(^BDGCTX(SERV)) Q:'SERV  D
 . ;
 . ; quit if inactive and not including inactives
 . I BDGIA=0,$$ACTSRV^BDGPAR(SERV,BDGBD)=0 Q
 . ;
 . S SVABV=$$GET1^DIQ(45.7,SERV,99)        ;serv abbrev
 . I SVABV="" S SVABV=SERV_"??"
 . I BDGTYP=1 Q:$$GET1^DIQ(45.7,SERV,.01)["OBSERVATION"   ;inpt only
 . I BDGTYP=2 Q:$$GET1^DIQ(45.7,SERV,.01)'["OBSERVATION"  ;obser only
 . I BDGTYP=3 Q:$$GET1^DIQ(45.7,SERV,.01)'="DAY SURGERY"  ;day surgery only ihs/cmi/maw PATCH 1013
 . ;
 . S DATE=BDGBD-.001
 . F  S DATE=$O(^BDGCTX(SERV,1,DATE)) Q:DATE>BDGED  Q:'DATE  D
 .. ;
 .. S X=$G(^BDGCTX(SERV,1,DATE,0))     ;grab data node
 .. ;
 .. ; put adult data in column order (adm, txi, txo, dsc, dth)
 .. S Y=$P(X,U,3)_U_$P(X,U,5)_U_$P(X,U,6)_U_$P(X,U,4)_U_$P(X,U,7)
 .. ;  then add 1day pts, pat days (remaining + 1day pts)
 .. S Y=Y_U_$P(X,U,8)_U_($P(X,U,2)+$P(X,U,8))
 .. ;  then los (includes observation - converted from hours)
 .. S Y=Y_U_($P(X,U,9)+($P(X,U,11)\24))
 .. ;
 .. ; put peds data in column order (adm, txi, txo, dsc, dth)
 .. S Y1=$P(X,U,13)_U_$P(X,U,15)_U_$P(X,U,16)_U_$P(X,U,14)_U_$P(X,U,17)
 .. ;  then add 1day pts, pat days (remaining + 1day pts)
 .. S Y1=Y1_U_$P(X,U,18)_U_($P(X,U,12)+$P(X,U,18))
 .. ;  then los (includes observation - converted from hours)
 .. S Y1=Y1_U_($P(X,U,19)+($P(X,U,21)\24))
 .. ;
 .. ; increment array for totals
 .. F I=1:1:8 S $P(BDGA("A",SVABV),U,I)=$P($G(BDGA("A",SVABV)),U,I)+$P(Y,U,I)
 .. F I=1:1:8 S $P(BDGA("P",SVABV),U,I)=$P($G(BDGA("P",SVABV)),U,I)+$P(Y1,U,I)
 .. F I=1:1:8 S $P(TOTAL,U,I)=$P($G(TOTAL),U,I)+$P(Y,U,I)+$P(Y1,U,I)
 .. F I=1:1:8 S $P(TOTAL("A"),U,I)=$P($G(TOTAL("A")),U,I)+$P(Y,U,I)
 .. F I=1:1:8 S $P(TOTAL("P"),U,I)=$P($G(TOTAL("P")),U,I)+$P(Y1,U,I)
 ;
 ;
 F AGE="A","P" D
 . S X=$S(AGE="A":"Adult",1:"Pediatric")_" Patients"
 . D SET(X,.VALMCNT)
 . S SERV=0 F  S SERV=$O(BDGA(AGE,SERV)) Q:SERV=""  D
 .. Q:SERV="NEWBORN"    ;list newborn data at end
 .. S LINE=$$PAD(SERV,10)
 .. F I=1:1:7 S LINE=LINE_$J($P(BDGA(AGE,SERV),U,I),4)_"  "
 .. S LINE=LINE_$J($P(BDGA(AGE,SERV),U,7)/BDGDAYS,6,2)  ;adpl
 .. S LINE=LINE_$J($P(BDGA(AGE,SERV),U,8),7)_" /"   ;los
 .. S X=$P(BDGA(AGE,SERV),U,3)+$P(BDGA(AGE,SERV),U,4)+$P(BDGA(AGE,SERV),U,5)
 .. S LINE=LINE_$J($P(BDGA(AGE,SERV),U,8)\$S(X=0:1,1:X),3)    ;alos
 .. ; los based on admissions (inpt days/# admissions)
 .. S X=$P(BDGA(AGE,SERV),U)+$P(BDGA(AGE,SERV),U,2) S:X=0 X=1
 .. S LINE=LINE_$J($P(BDGA(AGE,SERV),U,7)\X,8)
 .. D SET(LINE,.VALMCNT)
 . ;
 . ; add totals to display array
 . S LINE=$$PAD("SUBTOTAL:",10)
 . F I=1:1:7 S LINE=LINE_$J($P(TOTAL(AGE),U,I),4)_"  "
 . S LINE=LINE_$J($P(TOTAL(AGE),U,7)/BDGDAYS,6,2)  ;adpl
 . S LINE=LINE_$J($P(TOTAL(AGE),U,8),7)_" /"   ;los
 . S X=$P(TOTAL(AGE),U,3)+$P(TOTAL(AGE),U,4)+$P(TOTAL(AGE),U,5)
 . S LINE=LINE_$J($P(TOTAL(AGE),U,8)\$S(X=0:1,1:X),3)    ;alos
 . S X=$P(TOTAL(AGE),U)+$P(TOTAL(AGE),U,2) S:X=0 X=1
 . S LINE=LINE_$J($P(TOTAL(AGE),U,7)\X,8)
 . D SET($$REPEAT^XLFSTR("=",80),.VALMCNT),SET(LINE,.VALMCNT)
 . D SET("",.VALMCNT)
 ;
 ; add grand totals to display array
 S LINE=$$PAD("TOTAL:",10)
 F I=1:1:7 S LINE=LINE_$J($P(TOTAL,U,I),4)_"  "
 S LINE=LINE_$J($P(TOTAL,U,7)/BDGDAYS,6,2)  ;adpl
 S LINE=LINE_$J($P(TOTAL,U,8),7)_" /"   ;los
 S X=$P(TOTAL,U,3)+$P(TOTAL,U,4)+$P(TOTAL,U,5) S:X=0 X=1
 S LINE=LINE_$J($P(TOTAL,U,8)\X,3)    ;alos
 S X=$P(TOTAL,U)+$P(TOTAL,U,2) S:X=0 X=1
 S LINE=LINE_$J($P(TOTAL,U,7)\X,8)  ;losadmit
 D SET($$REPEAT^XLFSTR("=",80),.VALMCNT),SET(LINE,.VALMCNT)
 ;
 ; add newborn stats to display array
 I $D(BDGA("P","NEWBORN")) D
 . NEW LINE,NEW
 . S LINE=$$PAD("NEWBORN",10),NEW=BDGA("P","NEWBORN")
 . F I=1:1:7 S LINE=LINE_$J($P(NEW,U,I),4)_"  "
 . S LINE=LINE_$J($P(NEW,U,7)/BDGDAYS,6,2)  ;adpl
 . S LINE=LINE_$J($P(NEW,U,8),7)_" /"   ;los
 . S X=$P(NEW,U,3)+$P(NEW,U,4)+$P(NEW,U,5) S:X=0 X=1
 . S LINE=LINE_$J($P(NEW,U,8)\X,3)    ;alos
 . S X=$P(NEW,U)+$P(NEW,U,2) S:X=0 X=1
 . S LINE=LINE_$J($P(NEW,U,7)\X,8)   ;losadmit
 . D SET($$REPEAT^XLFSTR("-",80),.VALMCNT),SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGSTAT3",$J)) D SET("No data found",.VALMCNT)
 ;
 D LEGEND
 ;
 Q
 ;
NEWBORN(SERV,DATE,DATA) ; subtract out newborn numbers of ward and date
 NEW NEWB
 S NEWB=$O(^DIC(45.7,"B","NEWBORN",0)) Q:'NEWB
 S X=$G(^BDGCTX(SERV,1,DATE,1,NEWB,0)) Q:X=""   ;no data
 F I=1:1:11 S $P(DATA,U,I)=$P(DATA,U,I)-$P(X,U,I)
 Q
 ;
SET(DATA,NUM) ; put data into display array
 S NUM=NUM+1
 S ^TMP("BDGSTAT3",$J,NUM,0)=DATA
 Q
 ;
LEGEND ; add legend explaining column headings
 D SET("",.VALMCNT)
 D SET("ADM = admissions, TXI = ward transfers in",.VALMCNT)
 D SET("TXO = ward transfer out, DSC = discharges",.VALMCNT)
 D SET("DTH = deaths, 1DAY = admitted & discharged same day",.VALMCNT)
 D SET("TPD = total patient days, ADPL = ave daily patient load",.VALMCNT)
 D SET("LOSD = length of stay for patients discharged: total / average",.VALMCNT)
 D SET("        (discharged = TXO + DSC + DTH)",.VALMCNT)
 D SET("LOSA = length of stay by admissions (inpt days/# ADM+TXI)",.VALMCNT)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSTAT3",$J)
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print to paper
 NEW BDGLN,BDGPG
 U IO D INIT^BDGF,HDG
 S BDGLN=0 F  S BDGLN=$O(^TMP("BDGSTAT3",$J,BDGLN)) Q:'BDGLN  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGSTAT3",$J,BDGLN,0)
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading if printing to paper
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?30,"Statistics by Service"
 NEW X S X="For "_$$FMTE^XLFDT(BDGBD)_" through "_$$FMTE^XLFDT(BDGED)
 W !,BDGTIME,?(80-$L(X)\2),X,?71,"Page: ",BDGPG
 ;I BDGTYP=3 S X="Includes Inpatients AND Observations"
 ;E  S X=$S(BDGTYP=1:"Inpatient Services",1:"Observation Services")_" Only"
 I BDGTYP=4 S X="Includes Inpatients, Observations AND Day Surgery"
 E  S X=$S(BDGTYP=1:"Inpatients Only",BDGTYP=2:"Observations Only",1:"Day Surgery Only")
 W !,BDGDATE,?(80-$L(X)\2),X
 W !,"Service",?11,"ADM",?17,"TXI",?23,"TXO",?29,"DSC",?35,"DTH"
 W ?40,"1DAY",?47,"DAYS",?55,"ADPL",?64,"LOSD",?74,"LOSA"
 W !,$$REPEAT^XLFSTR("=",80),!
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
