BDGICR5 ; IHS/ANMC/LJF - CHARTS COMPLETED BY DATE ; 
 ;;5.3;PIMS;**1005**;MAY 28,2004
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added display of observations
 ;
 NEW BDGSTG,BDGBD,BDGED,DEFAULT,BDGTYP,BDGSRT
 S BDGSTG=$$READ^BDGF("SO^1:Coded;2:Completed;3:Bill Prep Done","Select Completion Stage") Q:BDGSTG<1
 ;
 S DEFAULT=$S(BDGSTG=1:"Coded",BDGSTG=2:"Completed",1:"Bill Prep Done")
 S BDGBD=$$READ^BDGF("DO^::E","Enter Beginning Date "_DEFAULT)
 Q:'BDGBD
 S BDGED=$$READ^BDGF("DO^::E","Enter Ending Date "_DEFAULT)
 Q:'BDGED
 ;
 S BDGSRT=$$READ^BDGF("SO^1:Alphabetical;2:By Date "_DEFAULT,"Select Sorting Choice")
 Q:BDGSRT<1
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 add observations
 ;S BDGTYP=$$READ^BDGF("SO^1:Inpatients Only;2:Day Surgeries Only;3:Both","Select Visit Types To Include") Q:'BDGTYP
 S BDGTYP=$$READ^BDGF("SO^1:Inpatients Only;2:Day Surgeries & Observations;3:All Types","Select Visit Types To Include") Q:'BDGTYP
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQ","EN^BDGICR5","DAILY/WEEKLY IC REPORT","BDGSTG;BDGBD;BDGED;BDGTYP;BDGSRT")
 Q
 ;
EN ;EP; -- main entry point for BDG IC COMPLETED WEEKLY
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q   ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC COMPLETED WEEKLY")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added observations
 ;S X=$S(BDGTYP=1:"Inpatients Only",BDGTYP=2:"Day Surgeries Only",1:"Inpatients & Day Surgeries")
 S X=$S(BDGTYP=1:"Inpatients Only",BDGTYP=2:"Day Surgeries & Observations",1:"Inpatients, Observations & Day Surgeries")
 ;
 S X=X_$$SP(4)_"-"_$$SP(4)_$P($T(CHOICE+BDGSTG),";;",2)
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 S X=$$RANGE^BDGF(BDGBD,BDGED)     ;date range
 S VALMHDR(3)=$$SP(75-$L(X)\2)_X
 ;
 S X=$S(BDGSTG=1:" Coded",BDGSTG=2:" Complt",1:" BillPrep")
 S X=$$PAD($$PAD($$PAD(X,13)_"HRCN",19)_"Patient Name",46)
 S X=$$PAD($$PAD($$PAD(X_"Typ",51)_"Dsch/Sur",62)_"WHO",67)
 S X=X_$S(BDGSTG=1:"Compl BPrep",BDGSTG=2:$$SP(6)_"BPrep",1:"")
 S VALMCAP=$$PAD(X,79)
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait; compiling list...",2,0)
 NEW XREF,DATE,IEN,LINE,X,SORT1,SORT2,COUNT
 S VALMCNT=0 K ^TMP("BDGICR5",$J),^TMP("BDGICR5A",$J)
 ;
 ; find charts at completion stage for date range & sort
 S XREF=$S(BDGSTG=1:"AC",BDGSTG=2:"AE",1:"AF")
 S DATE=BDGBD-.0001
 F  S DATE=$O(^BDGIC(XREF,DATE)) Q:'DATE  Q:DATE>BDGED  D
 . S IEN=0 F  S IEN=$O(^BDGIC(XREF,DATE,IEN)) Q:'IEN  D
 .. ; screen out entries
 .. Q:$$GET1^DIQ(9009016.1,IEN,.17)]""     ;deleted
 .. ;
 .. ;IHS/OIT/LJF 04/14/2006 PATCH 1005 use different logic to screen for visit type
 .. ;I BDGTYP=1 Q:$$GET1^DIQ(9009016.1,IEN,.02)=""  ;ip needs disch date
 .. ;I BDGTYP=2 Q:$$GET1^DIQ(9009016.1,IEN,.04)=""  ;ds needs surg date
 .. ;I BDGTYP=2 Q:$$GET1^DIQ(9009016.1,IEN,.02)]""  ;no sda for ds
 .. NEW CAT S CAT=$$GET1^DIQ(9009016.1,IEN,.0392)              ;visit service category
 .. I (BDGTYP=1),(CAT'="HOSPITALIZATION") Q                    ;skip if asked for inpt and not H visit
 .. I (BDGTYP=2),(CAT'="DAY SURGERY"),(CAT'="OBSERVATION") Q   ;skip if not correct service category
 .. ;
 .. I BDGSRT=1 S (SORT1,SORT2)=$$GET1^DIQ(9009016.1,IEN,.01)
 .. E  D
 ... I BDGSTG=1 S SORT1=$$GET1^DIQ(9009016.1,IEN,.13,"I") Q:SORT1=""
 ... I BDGSTG=2 S SORT1=$$GET1^DIQ(9009016.1,IEN,.14,"I") Q:SORT1=""
 ... I BDGSTG=3 S SORT1=$$GET1^DIQ(9009016.1,IEN,.15,"I") Q:SORT1=""
 ... ;
 ... ; sort by completion date and then by disch/surg date
 ... S SORT2=$$GET1^DIQ(9009016.1,IEN,.02,"I")
 ... I SORT2="" S SORT2=$$GET1^DIQ(9009016.1,IEN,.05,"I")
 ... I SORT2="" S SORT2="??"
 .. ;
 .. ; store by primary & secondary sorts
 .. S ^TMP("BDGICR5A",$J,SORT1,SORT2,IEN)=DATE
 ;
 ; now take sorted list and create display lines
 S COUNT=0
 S SORT1=0 F  S SORT1=$O(^TMP("BDGICR5A",$J,SORT1)) Q:SORT1=""  D
 . S SORT2=0
 . F  S SORT2=$O(^TMP("BDGICR5A",$J,SORT1,SORT2)) Q:SORT2=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGICR5A",$J,SORT1,SORT2,IEN)) Q:'IEN  D
 ... S DATE=^TMP("BDGICR5A",$J,SORT1,SORT2,IEN)
 ... S LINE=$$NUMDATE^BDGF(DATE,1)                         ;date
 ... S LINE=$$PAD(LINE,10)_$J($$GET1^DIQ(9009016.1,IEN,.011),7)  ;hrcn
 ... S LINE=$$PAD(LINE,19)_$E($$GET1^DIQ(9009016.1,IEN,.01),1,25)
 ... S X=$$GET1^DIQ(9009016.1,IEN,.0392)                   ;visit type
 ... ;S LINE=$$PAD(LINE,46)_$S(X["HOSP":"IP",X["OBSER":"DSO",1:"DS")
 ... S LINE=$$PAD(LINE,46)_$S(X["HOSP":"IP",X["OBSER":"OBS",1:"DS")
 ... S X=$$GET1^DIQ(9009016.1,IEN,.02,"I")                 ;disch date
 ... I X="" S X=$$GET1^DIQ(9009016.1,IEN,.05,"I")          ;surg date
 ... I X="" S LINE=$$PAD(LINE,51)_"??"
 ... E  S LINE=$$PAD(LINE,51)_$$NUMDATE^BDGF(X\1,1)
 ... I BDGSTG<3 S X=$$GET1^DIQ(9009016.1,IEN,.22,"I")      ;coder
 ... I BDGSTG=3 S X=$$GET1^DIQ(9009016.1,IEN,.23,"I")      ;bill prep
 ... I X S LINE=$$PAD(LINE,62)_$$GET1^DIQ(200,X,1)         ;initials
 ... ;
 ... ; if listing coded charts, show any that are completed also
 ... I BDGSTG=1,$$GET1^DIQ(9009016.1,IEN,.14)]"" S LINE=$$PAD(LINE,69)_"X"
 ... ; if listing coded or completed charts, show any already bill prepd
 ... I BDGSTG<3,$$GET1^DIQ(9009016.1,IEN,.15)]"" S LINE=$$PAD(LINE,75)_"X"
 ... D SET(LINE,.VALMCNT)
 ... S COUNT=COUNT+1,COUNT(SORT1)=$G(COUNT(SORT1))+1
 ;
 I COUNT D
 . D SET("",.VALMCNT),SET("Total Charts:"_$J(COUNT,4),.VALMCNT)
 . S X=0 F  S X=$O(COUNT(X)) Q:'X  D
 .. S LINE=$$SP(3)_$$NUMDATE^BDGF(X\1)_":"_$J(COUNT(X),5)
 .. D SET(LINE,.VALMCNT)
 ;
 I '$D(^TMP("BDGICR5",$J)) S VALMCNT=1,^TMP("BDGICR5",$J,1,0)="NO DATA FOUND"
 K ^TMP("BDGICR5A",$J)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICR5",$J) K BDGPRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
SET(DATA,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGICR5",$J,NUM,0)=DATA
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGPG
 U IO D INIT^BDGF    ;initialize heading variables
 D HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGICR5",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGICR5",$J,BDGX,0)
 . W !,BDGLN
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading for paper report
 NEW X
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?11,"*****",$$CONF^BDGF,"*****"
 W !,BDGDATE,?25,"Completed Charts Report",?70,"Page: ",BDGPG
 ;
 ;IHS/OIT/LJF 04/14/2006 PATCH 1005 added observations
 ;NEW X S X=$S(BDGTYP=1:"Inpatient Charts Only",BDGTYP=2:"Day Surgery Charts Only",1:"Inpatient and Day Surgery Charts")
 NEW X S X=$S(BDGTYP=1:"Inpatient Charts Only",BDGTYP=2:"Day Surgery & Observation Charts",1:"Inpatient, Observaiton and Day Surgery Charts")
 ;
 S X=X_$$SP(4)_"-"_$$SP(4)_$P($T(CHOICE+BDGSTG),";;",2)
 W !,BDGTIME,?(80-$L(X)\2),X
 S X=$$RANGE^BDGF(BDGBD,BDGED) W !?(80-$L(X)\2),X   ;date range
 ;
 W !,$$REPEAT^XLFSTR("-",80)
 S X=$S(BDGSTG=1:" Coded",BDGSTG=2:" Complt",1:" BillPrep")
 W !,X,?13,"HRCN",?19,"Patient Name",?46,"Typ",?51,"Dsch/Surg"
 S X=$S(BDGSTG=1:"Compl BPrep",BDGSTG=2:$$SP(6)_"BPrep",1:"")
 W ?62,"WHO",?67,X
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
CHOICE ;;
 ;;Coded Charts;;
 ;;Completed Charts;;
 ;;Bill Prep Done;;
