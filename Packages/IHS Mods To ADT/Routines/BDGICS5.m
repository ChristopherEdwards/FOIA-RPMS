BDGICS5 ; IHS/ANMC/LJF - INCOMPLETE STATS BY PROVIDER ;
 ;;5.3;PIMS;**1005**;MAY 28, 2004
 ;IHS/OIT/LJF 04/06/2006 PATCH 1005 new routine
 ;
 NEW BDGRPT,DEFAULT,BDGBD,BDGED,BDGSRT,BDGPRV
 ;
 S BDGRPT=$$READ^BDGF("S0^1:Statistics Only;2:List Charts Only;3:Both Statistics & Listing","Select Report Format") Q:BDGRPT<1
 ;
 S BDGBD=$$READ^BDGF("DO^::EX","Select Beginning Discharge/Surgery Date") Q:BDGBD<1
 S BDGED=$$READ^BDGF("DO^::EX","Select Ending Discharge/Surgery Date") Q:BDGED<1
 ;
 S BDGPRV=$$READ^BDGF("YO","Print Report for ALL Providers","NO")
 Q:BDGPRV=U  S:BDGPRV=1 BDGPRV="ALL"
 I BDGPRV=0 S BDGPRV=$$PROVS^BDGICR2 I '$O(BDGPRV(0)) Q
 ;
 S BDGSRT=$$READ^BDGF("SO^1:Chart Deficiency;2:Discharge/Surgery Date","Within Provider Sort By") Q:BDGSRT<1
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("PQM","EN^BDGICS5","IC STATS BY PROVIDER","BDGRPT;BDGBD;BDGED;BDGSRT;BDGPRV*")
 Q
 ;
 ;
EN ; -- main entry point for BDG IC CHARTS BY PATIENT
 I $E(IOST,1,2)="P-" S BDGPRT=1 D INIT,PRINT Q   ;printing to paper
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC STATS BY PROVIDER")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(15)_$$CONF^BDGF
 S X="Sorted by "_$S(BDGSRT=1:"Chart Deficiency",1:"Discharge/Surgery Date")
 S VALMHDR(2)=$$SP(75-$L(X)\2)_X
 S X=$$RANGE^BDGF(BDGBD,BDGED),VALMHDR(3)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",2,0)
 K ^TMP("BDGICS5",$J),^TMP("BDGICS5A",$J)
 S VALMCNT=0
 ;
 ; first find incomplete entries by date range & sort by patient
 NEW DATE,END
 S DATE=BDGBD-.0001,END=BDGED+.24
 D FIND                   ;gather visits by provider
 ;
 ; now take sorted list and put into display array
 NEW SORT,IEN,LINE,PRV,NAME,IEN2,STR,BDGCNT,FIRST
 S FIRST=1
 S PRV=0 F  S PRV=$O(^TMP("BDGICS5A",$J,PRV)) Q:PRV=""  D
 . I FIRST S FIRST=0
 . E  D SET("",.VALMCNT)
 . D SET($$SP(15)_"**** "_PRV_" ****",.VALMCNT)
 . K BDGCNT
 . ;
 . S SORT=0 F   S SORT=$O(^TMP("BDGICS5A",$J,PRV,SORT)) Q:SORT=""  D
 .. S IEN=0 F  S IEN=$O(^TMP("BDGICS5A",$J,PRV,SORT,IEN)) Q:'IEN  D
 ... S IEN2=0 F  S IEN2=$O(^TMP("BDGICS5A",$J,PRV,SORT,IEN,IEN2)) Q:'IEN2  D
 .... S STR=^TMP("BDGICS5A",$J,PRV,SORT,IEN,IEN2)
 .... ;
 .... ; build display line if requested
 .... I BDGRPT>1 D
 ..... S LINE=$$PAD($J($$GET1^DIQ(9009016.1,IEN,.011),7),10)             ;chart #
 ..... S LINE=LINE_$E($$GET1^DIQ(9009016.1,IEN,.0392),1,3)               ;service category
 ..... S LINE=$$PAD(LINE,18)_$$NUMDATE^BDGF(+STR\1)                      ;dsch/surg date
 ..... S LINE=$$PAD(LINE,31)_$E($P(STR,U,2),1,20)                        ;deficiency name
 ..... S LINE=$$PAD(LINE,53)_$$GET1^DIQ(9009016.11,IEN2_","_IEN,.0393)   ;def status
 ..... S LINE=$$PAD(LINE,66)_$$GET1^DIQ(9009016.11,IEN2_","_IEN,.0392)   ;days to complete
 ..... D SET(LINE,.VALMCNT)
 .... ;
 .... Q:BDGRPT=2   ;no stats if requested listing only
 .... ;
 .... ; build statistical counts
 .... NEW DELQ,RESV,X
 .... S BDGCNT("TOTAL")=$G(BDGCNT("TOTAL"))+1                               ;add to incomplete count
 .... S X=$$GET1^DIQ(9009016.1,IEN,.0392)                                   ;visit's service category
 .... S BDGCNT("TOTAL",X)=$G(BDGCNT("TOTAL",X))+1                           ;IC count by service category
 .... ;
 .... I $$GET1^DIQ(9009016.4,$P(STR,U,3),.03)="ADMIN ONLY" Q                ;quit if deficiency not to be counted
 .... S DELQ=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.0391) Q:DELQ=""            ;date delinquent (computed)
 .... S %DT="",X=DELQ D ^%DT S DELQ=Y                                       ;convert to internal format
 .... S RESV=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.03,"I") S:'RESV RESV=DT    ;date resolved
 .... I (DELQ<RESV) D
 ..... S BDGCNT("DELQ")=$G(BDGCNT("DELQ"))+1                                ;add to delinquent count
 ..... S BDGCNT("DELQ",$P(STR,U,2))=$G(BDGCNT("DELQ",$P(STR,U,2)))+1        ;DQ counts by deficiency
 . ;
 . Q:BDGRPT=2    ;don't display if requested listing only
 . ; now display provider's statistics
 . D SET("",.VALMCNT)
 . D SET($$PAD("TOTAL INCOMPLETE CHARTS",30)_(+$G(BDGCNT("TOTAL"))),.VALMCNT)
 . I $G(BDGCNT("TOTAL")) D
 .. S X=0 F  S X=$O(BDGCNT("TOTAL",X)) Q:X=""  D SET($$PAD($$SP(7)_"Incomplete "_X_" Charts",45)_BDGCNT("TOTAL",X),.VALMCNT)
 .. D SET("",.VALMCNT)
 .. D SET($$PAD("# OF DELINQUENT CHARTS",30)_(+$G(BDGCNT("DELQ"))),.VALMCNT)
 .. S X=0 F  S X=$O(BDGCNT("DELQ",X)) Q:X=""  D SET($$PAD($$SP(7)_"Delinquent for "_X,45)_BDGCNT("DELQ",X),.VALMCNT)
 ;
 I '$D(^TMP("BDGICS5",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGICS5A",$J)
 Q
 ;
FIND ; find all entries for date range
 NEW SUB,DATE,END,IEN,SORT,IEN2,PROV,DEF,DEF1
 F SUB="AD","AS" D
 . S DATE=BDGBD-.0001,END=BDGED+.24
 . F  S DATE=$O(^BDGIC(SUB,DATE)) Q:'DATE  Q:(DATE>END)  D
 .. S IEN=0 F  S IEN=$O(^BDGIC(SUB,DATE,IEN)) Q:'IEN  D
 ... ;
 ... I $$GET1^DIQ(9009016.1,IEN,.14)]"" Q         ;quit if deleted
 ... I BDGSRT=2 S X=$$GET1^DIQ(9009016.1,IEN,.02,"I"),SORT=$S(X]"":X,1:$$GET1^DIQ(9009016.1,IEN,.05,"I"))
 ... ;
 ... ; find all providers with deficiencies
 ... S IEN2=0 F  S IEN2=$O(^BDGIC(IEN,1,IEN2)) Q:'IEN2  D
 .... Q:$$GET1^DIQ(9009016.11,IEN2_","_IEN,.04)]""               ;don't count if deleted
 .... ;
 .... S PROV=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.01,"I")               ;provider pointer
 .... I BDGPRV="SRV",'$D(BDGPRV(+$$GET1^DIQ(200,PROV,29,"I"))) Q       ;skip if prov not in requested service
 .... I BDGPRV="CLASS",'$D(BDGPRV(+$$GET1^DIQ(200,PROV,53.5,"I"))) Q   ;skip if prov not in requested class
 .... I BDGPRV="NAME",'$D(BDGPRV(PROV)) Q                              ;skip if provider not requested by name
 .... ;
 .... S PROV=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.01)           ;provider name
 .... S DEF=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.02)            ;deficiency name
 .... S DEFI=$$GET1^DIQ(9009016.11,IEN2_","_IEN,.02,"I")       ;deficiency pointer
 .... I BDGSRT=1 S SORT=DEF
 .... S ^TMP("BDGICS5A",$J,PROV,SORT,IEN,IEN2)=DATE_U_DEF_U_DEFI        ;put into sorted list
 Q
 ;
SET(DATA,NUM) ; puts display line into list template array
 S NUM=NUM+1
 S ^TMP("BDGICS5",$J,NUM,0)=DATA
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGICS5",$J) K BDGPRT
 Q
 ;
EXPND ; -- expand code
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGPG
 U IO D INIT^BDGF    ;initialize heading variables
 D HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGICS5",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGICS5",$J,BDGX,0)
 . W !,BDGLN
 D ^%ZISC,PRTKL^BDGF,EXIT
 Q
 ;
HDG ; heading for paper report
 NEW X
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?11,"*****",$$CONF^BDGF,"*****"
 W !,BDGDATE,?23,"Incomplete Statistics by Provider",?70,"Page: ",BDGPG
 S X="Sorted by "_$S(BDGSRT=1:"Chart Deficiency",1:"Discharge/Surgery Date")
 W !,BDGTIME,?(80-$L(X)\2),X
 S X=$$RANGE^BDGF(BDGBD,BDGED) W !,?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 I BDGRPT>1 D
 . W !?2,"Chart#",?10,"Type",?18,"Dsch/Surg",?31,"Deficiency",?53,"Status",?63,"Days to Complete"
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
