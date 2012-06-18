BDGSVL1 ; IHS/ANMC/LJF - SCHED VISIT LISTING ; 
 ;;5.3;PIMS;;APR 26, 2002
 ;
EN ; -- main entry point for BDG SCHED VISITS
 I $E(IOST,1,2)'="C-" D INIT,PRINT Q
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG SCHED VISITS")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X="For "_$$FMTE^XLFDT(BDGBD)_" to "_$$FMTE^XLFDT(BDGED)
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 S X="Scheduled "_$S(BDGVT="A":"Admissions",BDGVT="D":"Day Surgeries",BDGVT="O":"Outpatient Visits",1:"Visits - All Types")
 S X=X_" (Sorted by "_$P(BDGS1,U,2)_" & "_$P(BDGS2,U,2)_")"
 S VALMHDR(3)=$$SP(79-$L(X)\2)_X
 ;
 S X="CAP"_BDGRT D @X     ;set up captions based on type for report
 ;
 S VALMSG=$$SP(5)_"Authorizing Provider/Case Mgr/Referred By"
 Q
 ;
INIT ; -- init variables and list array
 NEW DATE,END,BDGN,TYPE,SORT1,SORT2,X
 K ^TMP("BDGSVL",$J),^TMP("BDGSVL1",$J)
 S VALMCNT=0
 ;
 S DATE=BDGBD-.0001,END=BDGED+.24
 F  S DATE=$O(^BDGSV("D",DATE)) Q:'DATE  Q:(DATE>END)  D
 . S BDGN=0
 . F  S BDGN=$O(^BDGSV("D",DATE,BDGN)) Q:'BDGN  D
 .. ;
 .. S TYPE=$$GET1^DIQ(9009016.7,BDGN,.03,"I")
 .. I (BDGVT'=4),(BDGVT'=TYPE) Q   ;not type selected
 .. ;
 .. ; screen out no-shows, cancels and errors if asked to
 .. I 'BDGEX S X=$$GET1^DIQ(9009016.7,BDGN,.16,"I") I X]"",X'="PA" Q
 .. ;
 .. S SORT1=$$GET1^DIQ(9009016.7,BDGN,+BDGS1)
 .. I SORT1="" S X=$P($P(BDGS1,U),";",2) I X S SORT1=$$GET1^DIQ(9009016.7,BDGN,X)  ;if other fields can be used (i.e. service)
 .. I SORT1="" S SORT1="??"
 .. ;
 .. S SORT2=$$GET1^DIQ(9009016.7,BDGN,+BDGS2)
 .. I SORT2="" S X=$P($P(BDGS2,U),";",2) I X S SORT2=$$GET1^DIQ(9009016.7,BDGN,X)  ;if other fields can be used (i.e. service)
 .. I SORT2="" S SORT2="??"
 .. ;
 .. ; build sorted list
 .. S ^TMP("BDGSVL1",$J,SORT1,SORT2,BDGN)=""
 ;
 ; now take sorted list and build display (detailed or brief)
 S SORT1=0
 F  S SORT1=$O(^TMP("BDGSVL1",$J,SORT1)) Q:SORT1=""  D
 . S SORT2=0
 . F  S SORT2=$O(^TMP("BDGSVL1",$J,SORT1,SORT2)) Q:SORT2=""  D
 .. S BDGN=0
 .. F  S BDGN=$O(^TMP("BDGSVL1",$J,SORT1,SORT2,BDGN)) Q:'BDGN  D
 ... I BDGRT="D" D DETAIL(BDGN) Q
 ... I BDGRT="B" D BRIEF(BDGN)
 ;
 I '$D(^TMP("BDGSVL",$J)) D SET("No data found",.VALMCNT)
 K ^TMP("BDGSVL1",$J)
 Q
 ;
DETAIL(IEN) ;build detailed display
 NEW LINE,X
 S LINE=$E($$GET1^DIQ(9009016.7,IEN,.01),1,18)                  ;patient
 S LINE=$$PAD(LINE,20)_$J($$GET1^DIQ(9009016.7,IEN,.011),6)     ;chart #
 S LINE=$$PAD(LINE,28)_$$GET1^DIQ(9009016.7,IEN,.012)           ;age
 S LINE=$$PAD(LINE,33)_$$GET1^DIQ(2,+$G(^BDGSV(IEN,0)),.02,"I")  ;sex
 S LINE=$$PAD(LINE,36)_$$GET1^DIQ(9009016.7,IEN,.02)             ;date
 S LINE=$$PAD(LINE,49)_$$VSTTYPE(IEN)                         ;vst type
 S X=$$GET1^DIQ(9009016.7,IEN,.16) I X="" S X="OPEN/PENDING"
 S LINE=$$PAD($$PAD(LINE,54)_X,67)                    ;disposition
 S LINE=LINE_$$GET1^DIQ(9009016.7,IEN,.013)           ;community
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$SP(5)_$$LOC(IEN)                             ;location
 S LINE=$$PAD(LINE,14)_$$SRV(IEN)                      ;service
 S LINE=$$PAD(LINE,21)_"LOS:"_$$GET1^DIQ(9009016.7,IEN,.13)  ;expctd los
 S LINE=$$PAD(LINE,27)_$E($$GET1^DIQ(9009016.7,IEN,.04),1,18)   ;prov
 S LINE=LINE_"/"_$E($$GET1^DIQ(9009016.7,IEN,.05),1,18)   ;case mgr
 S LINE=LINE_"/"_$E($$GET1^DIQ(9009016.7,IEN,.06),1,18)   ;ref prov
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$SP(5)_"Dx: "_$$GET1^DIQ(9009016.7,IEN,201)   ;diagnosis
 S X=$$GET1^DIQ(9009016.7,IEN,101,"I")
 I X]"" S LINE=$$PAD(LINE,58)_" TRVL:"_X               ;travel
 S LINE=LINE_" "_$$HOUSING(IEN)                  ;housing
 D SET(LINE,.VALMCNT)
 ;
 S X=$$GET1^DIQ(9009016.7,IEN,202) I X]"" D      ;procedure, if any
 . S LINE=$$PAD($$SP(5)_X,53)_"Scheduled for "
 . S LINE=LINE_$$GET1^DIQ(9009016.7,IEN,.14)
 . D SET(LINE,.VALMCNT)
 ;
 S X=$$GET1^DIQ(9009016.7,IEN,102),Y=$$GET1^DIQ(9009016.7,IEN,106)
 I (X]"")!(Y]"") D                       ;travel details or escort info
 . S LINE=$$SP(5)_$S(X]"":X_"  "_Y,1:Y)
 . S LINE=$$PAD(LINE,$L(LINE)+2)_$$ESCORT(IEN)
 . D SET(LINE,.VALMCNT)
 ;
 ; other comments
 S X=$$GET1^DIQ(9009016.7,IEN,203) I X]"" D SET($$SP(5)_X,.VALMCNT)
 D SET("",.VALMCNT)     ;blank line between patients
 ;
 Q
 ;
BRIEF(IEN)  ;build brief display
 NEW LINE,X,Y,Z
 S LINE=$E($$GET1^DIQ(9009016.7,IEN,.01),1,18)              ;patient
 S LINE=$$PAD(LINE,20)_$J($$GET1^DIQ(9009016.7,IEN,.011),6)  ;chart #
 S LINE=$$PAD(LINE,28)_$$GET1^DIQ(9009016.7,IEN,.02)        ;date
 S LINE=$$PAD(LINE,41)_$$VSTTYPE(IEN)                       ;vst type
 S LINE=$$PAD(LINE,46)_$$LOC(IEN)                           ;location
 S LINE=$$PAD(LINE,55)_$$SRV(IEN)                           ;service
 S LINE=$$PAD(LINE,61)_$$GET1^DIQ(9009016.7,IEN,.04)        ;provider
 D SET(LINE,.VALMCNT)
 ;
 S LINE=$$SP(5)_"("_$E($$GET1^DIQ(9009016.7,IEN,.013),1,20)  ;community
 S X=$$GET1^DIQ(9009016.7,IEN,.16) I X="" S X="OPEN/PENDING"
 S LINE=$$PAD($$PAD(LINE,28)_X,40)                         ;disposition
 ;
 S LINE=LINE_" TRVL:"_$$GET1^DIQ(9009016.7,IEN,101,"I")    ;travel
 S LINE=$$PAD(LINE,50)_$$HOUSING(IEN)                      ;housing
 ;
 ;
 S LINE=$$PAD(LINE,65)_$$GET1^DIQ(9009016.7,IEN,.06)_")"  ;ref prov
 D SET(LINE,.VALMCNT)
 D SET("",.VALMCNT)          ;blank line between patients
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGSVL",$J,NUM,0)=DATA
 Q
 ;
CAPB ; set up brief caption
 S VALMCAP=$$PAD(" Patient/Community",20)_"Chart#  Expected On  Type"
 S VALMCAP=$$PAD(VALMCAP_" Ward/Cln Srv   Provider/Referring",79)
 Q
 ;
CAPD ; set up detailed caption
 S VALMCAP=$$PAD(" Patient",20)_"Chart#  Age Sex Expected On  Type"
 S VALMCAP=$$PAD(VALMCAP_"  Status      Community",79)
 Q
 ;
PRINT ; print report to paper
 U IO D HDG
 NEW LINE
 S LINE=0 F  S LINE=$O(^TMP("BSDSVL",$J,LINE)) Q:'LINE  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BSDSVL",$J,LINE,0)
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 D HDR W @IOF,?30,"Scheduled Visit Listing"
 NEW I F I=1:1 Q:'$D(VALMHDR(I))  W !,VALMHDR(I)
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGSVL",$J)
 K BDGBD,BDGED,BDGVT,BDGEX,BDGS1,BDGS2,BDGRT
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
 ;
VSTTYPE(N) ; returns printable abbreviated visit type
 NEW X,Y,Z
 S X=$$GET1^DIQ(9009016.7,N,.03,"I")            ;visit type
 S Y=$$GET1^DIQ(9009016.7,N,.17)                ;observation?
 S Z=$$GET1^DIQ(9009016.7,N,.15)                ;same day admit?
 Q $S(X="O":"OPT",Y="YES":"DSO",Z="YES":"SDA",X="A":"INP",X="D":"DS",1:"")
 ;
LOC(N) ; return hospital location (ward or clinic)
 NEW X,Y
 ; get ward abbreviation
 S X=$$GET1^DIQ(9009016.7,N,.09,"I")
 I X S X=$$GET1^DIQ(9009016.5,X,.02)
 ; get clinic abbreviation
 S Y=$$GET1^DIQ(9009016.7,N,.11,"I") I Y S Y=$$GET1^DIQ(44,Y,1)
 ; set location (ward or clinic or "" if day surgery)
 Q $S(X]"":X,Y]"":Y,BDGVT="D":"",1:"Loc ??")
 ;
SRV(N) ; return service (treating specialty or surgical service)
 NEW X,Y,Z
 S X=$$GET1^DIQ(9009016.7,N,.08,"I") I X S X=$$GET1^DIQ(45.7,X,99)
 S Y=$E($$GET1^DIQ(9009016.7,N,.121),1,5)
 S Z=$$GET1^DIQ(9009016.7,N,.03,"I")   ;visit type
 Q $S(X]"":X,Y]"":Y,Z="O":"",1:"Srv ??")
 ;
HOUSING(N) ; returns brief summary of housing data
 NEW X,Y
 S X=$$GET1^DIQ(9009016.7,IEN,103,"I") I X="" Q ""  ;housing authorized?
 S Y=$$GET1^DIQ(9009016.7,IEN,104)        ;# of days
 S Z=$$GET1^DIQ(9009016.7,IEN,105,"I")    ;housing status
 Q "HOUS:"_X_$S(Y]"":"x"_Y,1:"")_$S(Z]"":"("_Z_")",1:"")
 ;
ESCORT(N) ; return summary of escort info
 NEW X,Y
 S X=$$GET1^DIQ(9009016.7,N,107,"I") I X]"" S X="TRVL:"_X
 S Y=$$GET1^DIQ(9009016.7,N,108),Y1=$$GET1^DIQ(9009016.7,N,109)
 S Y2=$$GET1^DIQ(9009016.7,N,110)
 I Y]"" S Y="HOUS:"_Y_$S(Y1]"":"x"_Y1,1:"")_$S(Y2]"":"("_Y2_")",1:"")
 Q X_" "_Y_" "_$$GET1^DIQ(9009016.7,N,111)
