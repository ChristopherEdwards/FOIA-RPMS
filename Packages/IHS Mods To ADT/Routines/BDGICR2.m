BDGICR2 ; IHS/ANMC/LJF - INCOMPLETE CHART BY PROVIDER ;  [ 01/06/2005  11:37 AM ]
 ;;5.3;PIMS;**1001,1003,1005,1007**;MAY 28, 2004
 ;IHS/ITSC/WAR 09/27/2004 PATCH 1001 fixed call to FMDIFF^XLFDT
 ;IHS/ITSC/LJF 08/09/2004 PATCH 1001 observations need to print with day surgeries
 ;             06/02/2005 PATCH 1003 screen out "admin only" deficiencies
 ;             06/03/2005 PATCH 1003 improved reporting of totals
 ;IHS/OIT/LJF  04/06/2006 PATCH 1005 added ;EP to PROVS and EN
 ;             04/20/2006 PATCH 1005 added choice to print medical staff only
 ;cmi/anch/maw 07/10/2007 PATCH 1007 added code below to not ask for copies if subtype is terminal
 ;             07/10/2007 PATCH 1007 modified code in PRINT to use generic # of copies code in BDGF
 ;
 NEW BDGTYP,X,DEFAULT,BDGPRV,BDGRPT,BDGCOP
 ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 ;S BDGTYP=$$READ^BDGF("SO^1:Inpatients Only;2:Day Surgeries Only;3:Both","Select Visit Types to Include") Q:BDGTYP<1
 S BDGTYP=$$READ^BDGF("SO^1:Inpatients;2:Observations & Day Surgeries;3:All","Select Visit Types to Include") Q:BDGTYP<1
 ;S DEFAULT=$S(BDGTYP=1:"Discharge",BDGTYP=2:"Surgery",1:"Disch/Surg")
 S DEFAULT=$S(BDGTYP=1:"Discharge",1:"Discharge/Surgery")   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 S X=$$FMADD^XLFDT(DT,-$$GET1^DIQ(9009020.1,$$DIV^BSDU,.12))  ;days delq
 D MSG^BDGF("Charts with "_DEFAULT_" dates BEFORE "_$$FMTE^XLFDT(X)_" are flagged as DELINQUENT.",2,1)
 S BDGPRV=$$READ^BDGF("YO","Print Report for ALL Providers","NO")
 Q:BDGPRV=U  S:BDGPRV=1 BDGPRV="ALL"
 I BDGPRV=0 S BDGPRV=$$PROVS I '$O(BDGPRV(0)) Q
 S BDGRPT=$$READ^BDGF("SO^1:Individual Provider Listings Only;2:Summary Page Only;3:Both","Select Report to Print") Q:BDGRPT<1
 I $$BROWSE^BDGF="B" D EN Q
 ;S BDGCOP=$$READ^BDGF("N^1:10","Number of Copies (1-10)",1) Q:BDGCOP<1  ;cmi/anch/maw 7/10/2007 orig line patch 1007
 I $E(IOST,1,2)'="C-" S BDGCOP=$$READ^BDGF("N^1:10","Number of Copies (1-10)",1) Q:BDGCOP<1  ;cmi/anch/maw 7/10/2007 mod line for new copies code in ZIS^BDGF patch 1007
 D ZIS^BDGF("PQ","EN^BDGICR2","IC LIST BY PROVIDER","BDGTYP;BDGPRV*;BDGRPT;BDGCOP")
 Q
 ;
EN ;EP; -- main entry point for BDG IC CHARTS BY PROVIDER
 ;IHS/OIT/LJF 04/06/2006 PATCH 1005 added EP - called by BDGICS21
 ;I $E(IOST,1,2)'="C-" S BDGPRT=1 D INIT,PRINT Q   ;printing to paper
 S BDGPRT=1 D INIT,PRINT Q   ;printing to paper TEST
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IC CHARTS BY PROVIDER")
 D CLEAR^VALM1
 Q
HDR ; -- header code
 Q
INIT ; -- init variables and list array
 I '$G(BDGPRT) D MSG^BDGF("Please wait while I compile the list...",2,0)
 NEW BDGDELQ,BDGT,I,IEN,PRV,VTYP,NAME,DATE,BDGC,BDGT,BDGPT
 K ^TMP("BDGICR2",$J),^TMP("BDGICR2A",$J)
 S VALMCNT=0
 ; set delinquent date
 S BDGDELQ=$$FMADD^XLFDT(DT,-$$GET1^DIQ(9009020.1,$$DIV^BSDU,.12))
 ; initialize totals for summary page
 ;F I="ASH","OPR","SIG","SUM","IC","DQ" S BDGT(I)=0  ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 not needed
 ; first find all provider entries that qualify and sort by name
 S PRV=0 F  S PRV=$O(^BDGIC("APRV",PRV)) Q:'PRV  D
 . I BDGPRV="SRV",'$D(BDGPRV(+$$GET1^DIQ(200,PRV,29,"I"))) Q
 . I BDGPRV="CLASS",'$D(BDGPRV(+$$GET1^DIQ(200,PRV,53.5,"I"))) Q
 . I BDGPRV="NAME",'$D(BDGPRV(PRV)) Q
 . S IEN=0 F  S IEN=$O(^BDGIC("APRV",PRV,IEN)) Q:'IEN  D
 .. Q:$$GET1^DIQ(9009016.1,IEN,.17)]""       ;deleted entry
 .. S VTYP=$$GET1^DIQ(9009016.1,IEN,.0392)   ;visit type
 .. I BDGTYP=1,VTYP'["HOS" Q                 ;not inpt as asked
 .. I BDGTYP=2,VTYP["HOS" Q                  ;not day surgery as asked
 .. ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 skip provider if has no deficiencies to report
 .. Q:'$$OKAY(PRV,IEN)
 .. S NAME=$$GET1^DIQ(200,PRV,.01)
 .. ;S DATE=$$GET1^DIQ(9009016.1,IEN,$S(VTYP["HOS":.02,1:.05),"I")
 .. S DATE=$$GET1^DIQ(9009016.1,IEN,$S(VTYP["HOS":.02,VTYP["DAY":.05,1:.02),"I")   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 .. S:DATE="" DATE="??" S:NAME="" NAME="??"
 .. S ^TMP("BDGICR2A",$J,NAME,PRV,DATE,IEN)=""
 ; now take sorted list and put into display array
 NEW IEN,LINE,PRV,NAME,FIRST
 S NAME=0,FIRST=1
 F   S NAME=$O(^TMP("BDGICR2A",$J,NAME)) Q:NAME=""  D
 . S PRV=0 F  S PRV=$O(^TMP("BDGICR2A",$J,NAME,PRV)) Q:'PRV  D
 .. ; mark change between providers for printing to paper
 .. I $G(BDGPRT),BDGRPT'=2,'FIRST D SET("@@@@@",.VALMCNT)
 .. I FIRST S FIRST=0
 .. ; display provider heading
 .. S X=$G(IORVON)_"Incomplete Charts for "_NAME_$G(IORVOFF)
 .. I BDGRPT'=2 D SET("",.VALMCNT),SET($$SP(79-$L(X)\2)_X,.VALMCNT)
 .. ; initialize provider's counts
 .. K BDGC F I="ASH","OPR","SIG","SUM","IC","DQ" S BDGC(I)=0
 .. S DATE=0 F  S DATE=$O(^TMP("BDGICR2A",$J,NAME,PRV,DATE)) Q:DATE=""  D
 ... S IEN=0
 ... F  S IEN=$O(^TMP("BDGICR2A",$J,NAME,PRV,DATE,IEN)) Q:'IEN  D
 .... ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 fix way totals are calculated
 .... ; increment incomplete or delinquent list
 .... ;I DATE<BDGDELQ S BDGC("DQ")=BDGC("DQ")+1,BDGT("DQ")=BDGT("DQ")+1
 .... ;S BDGC("IC")=BDGC("IC")+1,BDGT("IC")=BDGT("IC")+1
 .... I DATE<BDGDELQ S BDGC("DQ")=$G(BDGC("DQ"))+1,BDGT("DQ",IEN)=$G(BDGT("DQ",IEN))+1
 .... S BDGC("IC")=$G(BDGC("IC"))+1,BDGT("IC",IEN)=$G(BDGT("IC",IEN))+1
 .... ;end of PATCH 1003 changes
 .... ; build display line
 .... S LINE=$$PAD($$GET1^DIQ(9009016.1,IEN,.01),20)        ;patient
 .... S LINE=LINE_$J($$GET1^DIQ(9009016.1,IEN,.011),8)      ;chart #
 .... ;IHS/ITSC/WAR 9/27/04 PATCH #1001 PER LJF9/24
 .... ;S LINE=$$PAD(LINE,30)_$$DATE(IEN)                    ;dsch/surg date
 .... S LINE=$$PAD(LINE,30)_$$NUMDATE^BDGF(DATE\1,1)        ;dsch/surg date
 .... S LINE=$$PAD(LINE,40)_$$TYPE(IEN)                     ;hos vs ds/dso
 .... ;IHS/ITSC/WAR 9/27/04 PATCH #1001 PER LJF9/24
 .... ;S DAYS=$$FMDIFF^XLFDT(DT,$$IDATE(IEN))               ;# of days inc/delq
 .... S DAYS=$$FMDIFF^XLFDT(DT,DATE)                        ;# of days inc/delq
 .... ; now list unresolved deficiencies
 .... S P=0 F  S P=$O(^BDGIC(IEN,1,"B",PRV,P)) Q:'P  D
 ..... Q:$$GET1^DIQ(9009016.11,P_","_IEN,.03)]""            ;resolved
 ..... Q:$$GET1^DIQ(9009016.11,P_","_IEN,.04)]""            ;deleted
 ..... ;IHS/ITSC/LJF 6/2/2005 PATCH 1003 screen out admin only deficiencies
 ..... Q:$$GROUPING(P,IEN)="ADM"
 ..... S LINE=$$PAD(LINE,50)_$S(DATE<BDGDELQ:"*",1:" ")     ;* for deliq
 ..... S LINE=LINE_$$GET1^DIQ(9009016.11,P_","_IEN,.02)
 ..... S LINE=$$PAD(LINE,72)_$J(DAYS,4)                     ;# days incomplete
 ..... I BDGRPT'=2 D SET(LINE,.VALMCNT) S LINE=""
 ..... ; increment grouping counts
 ..... S X=$$GET1^DIQ(9009016.11,P_","_IEN,.02,"I")         ;chart def
 ..... S Y=$$GET1^DIQ(9009016.4,+X,.03,"I")                 ;grouping
 ..... ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 change way totals are counted
 ..... ;I Y]"" S BDGC(Y)=BDGC(Y)+1,BDGT(Y)=BDGT(Y)+1
 ..... I Y]"" S BDGC(Y)=$G(BDGC(Y))+1,BDGT(Y,IEN)=$G(BDGT(Y,IEN))+1
 .... I BDGRPT'=2 D SET("",.VALMCNT)   ;blank line between patients
 .. ; at end of each provider, display summary
 .. D SUMM(NAME,PRV)
 I BDGRPT'=1 D TOTALS
 I '$D(^TMP("BDGICR2",$J)) D SET("NO DATA FOUND",.VALMCNT)
 K ^TMP("BDGICR2A",$J)
 Q
DATE(IEN) ; return dates for entry (external format)
 NEW X,TYPE
 S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392)                      ;visit type
 I TYPE="" Q "??"
 I TYPE["HOS" Q $$NUMDATE^BDGF($$GET1^DIQ(9009016.1,IEN,.02,"I")\1,1)
 Q $$NUMDATE^BDGF($$GET1^DIQ(9009016.1,IEN,.05,"I")\1,1)    ;surg date
IDATE(IEN) ; return dates for entry (internal format)
 NEW X,TYPE
 S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392)                     ;visit type
 I TYPE["HOS" Q $$GET1^DIQ(9009016.1,IEN,.02,"I")\1
 Q $$GET1^DIQ(9009016.1,IEN,.05,"I")\1                      ;surg date
TYPE(IEN) ; returns abbreviated visit type
 NEW TYPE
 S TYPE=$$GET1^DIQ(9009016.1,IEN,.0392)                     ;visit type
 ;Q $S(TYPE["HOS":"INP",TYPE["DAY":"DS",TYPE["OBS":"DSO",1:"??")
 Q $S(TYPE["HOS":"INP",TYPE["DAY":"DS",TYPE["OBS":"OBS",1:"??")   ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
SET(DATA,NUM) ; puts display line into list template array
 S NUM=NUM+1
 S ^TMP("BDGICR2",$J,NUM,0)=DATA
 Q
GROUPING(X1,X2) ; return internal form of chart deficiency grouping ;IHS/ITSC/LJF 6/2/2005 PATCH 1003
 Q $$GET1^DIQ(9009016.4,+$$GET1^DIQ(9009016.11,X1_","_X2,.02,"I"),.03,"I")
OKAY(PRV,IEN) ;return 1 if provider has at least one deficiency to report ;IHS/ITSC/LJF 6/2/2005 PATCH 1003
 NEW P,RESULT
 S (P,RESULT)=0 F  S P=$O(^BDGIC(IEN,1,"B",PRV,P)) Q:'P  Q:RESULT  D
 . Q:$$GET1^DIQ(9009016.11,P_","_IEN,.03)]""   ;resolved
 . Q:$$GET1^DIQ(9009016.11,P_","_IEN,.04)]""   ;deleted
 . Q:$$GROUPING(P,IEN)="ADM"                   ;admin only
 . S RESULT=1    ;good deficiency found
 Q RESULT
SUMM(NAME,PRV) ; display subcount summary for provider
 NEW I,X,FIRST
 F I="IC","DQ","ASH","OPR","SIG","SUM" S BDGPT(NAME,PRV,I)=BDGC(I)
 Q:BDGRPT=2    ;summary page only
 D SET($$SP(5)_"Total Delinquent Charts: "_BDGC("DQ"),.VALMCNT)
 D SET($$SP(5)_"Total Incomplete Charts: "_BDGC("IC"),.VALMCNT)
 S FIRST=1 F I="ASH","OPR","SIG","SUM" I BDGC(I)>0 D
 . I FIRST S X=$$PAD($$SP(8)_"Incomplete/Delinquent for "_$P($T(@I),";;",2),55)_BDGC(I)
 . E  S X=$$PAD($$SP(34)_$P($T(@I),";;",2),55)_BDGC(I)
 . D SET(X,.VALMCNT) S FIRST=0
 D SET("",.VALMCNT)
 Q
TOTALS ; display report totals on summary page
 NEW LINE,NAME,PRV
 ; first the summary page heading
 I $G(BDGPRT) D SET("@@@@@",.VALMCNT)
 S X=$G(IORVON)_"SUMMARY PAGE"_$G(IORVOFF)
 D SET("",.VALMCNT),SET($$SP(79-$L(X)\2)_X,.VALMCNT)
 D SET("",.VALMCNT)
 ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 enhance caption
 ;S LINE=$$SP(24)_"INCOMP"_$$SP(5)_"DELINQ" D SET(LINE,.VALMCNT)
 S LINE=$$SP(24)_"INCOMP"_$$SP(5)_"DELINQ"_$$SP(6)_"DEFICIENCY CATEGORIES" D SET(LINE,.VALMCNT)
 S LINE=$$PAD("PROVIDER",24)_"CHARTS     CHARTS  A SHEET  OP RPT  SUMM    SIG"
 D SET(LINE,.VALMCNT),SET($$REPEAT^XLFSTR("=",79),.VALMCNT)
 S NAME=0 F  S NAME=$O(BDGPT(NAME)) Q:NAME=""  D
 . S PRV=0 F  S PRV=$O(BDGPT(NAME,PRV)) Q:'PRV  D
 .. S LINE=$$PAD($E(NAME,1,20),25)
 .. S LINE=LINE_$J(((BDGPT(NAME,PRV,"IC"))),3)
 .. S LINE=$$PAD(LINE,38)_$J(BDGPT(NAME,PRV,"DQ"),3)
 .. S LINE=$$PAD(LINE,45)_$J(BDGPT(NAME,PRV,"ASH"),3)
 .. S LINE=$$PAD(LINE,53)_$J(BDGPT(NAME,PRV,"OPR"),3)
 .. S LINE=$$PAD(LINE,60)_$J(BDGPT(NAME,PRV,"SUM"),3)
 .. S LINE=$$PAD(LINE,67)_$J(BDGPT(NAME,PRV,"SIG"),3)
 .. D SET(LINE,.VALMCNT)
 ;IHS/ITSC/LJF 6/3/2005 PATCH 1003 rewrote totals section
 D SET($$REPEAT^XLFSTR("=",79),.VALMCNT)
 ;S LINE=$$PAD($$PAD("TOTALS:",25)_$J(BDGT("IC"),3),38)_$J(BDGT("DQ"),3)
 ;S LINE=$$PAD($$PAD(LINE,45)_$J(BDGT("ASH"),3),53)_$J(BDGT("OPR"),3)
 ;S LINE=$$PAD($$PAD(LINE,60)_$J(BDGT("SUM"),3),67)_$J(BDGT("SIG"),3)
 S LINE=$$PAD("# DISCHARGES:",25)
 NEW PAT,CNT
 S (PAT,CNT)=0 F  S PAT=$O(BDGT("IC",PAT)) Q:'PAT  S CNT=CNT+1    ;# incomplete charts
 S LINE=$$PAD(LINE_$J(CNT,3),38)
 S (PAT,CNT)=0 F  S PAT=$O(BDGT("DQ",PAT)) Q:'PAT  S CNT=CNT+1    ;# that are delinquent
 S LINE=$$PAD(LINE_$J(CNT,3),45)
 S (PAT,CNT)=0 F  S PAT=$O(BDGT("ASH",PAT)) Q:'PAT  S CNT=CNT+1   ;# for A Sheet deficiencies
 S LINE=$$PAD(LINE_$J(CNT,3),53)
 S (PAT,CNT)=0 F  S PAT=$O(BDGT("OPR",PAT)) Q:'PAT  S CNT=CNT+1   ;# for op report deficiencies
 S LINE=$$PAD(LINE_$J(CNT,3),60)
 S (PAT,CNT)=0 F  S PAT=$O(BDGT("SUM",PAT)) Q:'PAT  S CNT=CNT+1   ;# for disch summmary deficiencies
 S LINE=$$PAD(LINE_$J(CNT,3),67)
 S (PAT,CNT)=0 F  S PAT=$O(BDGT("SIG",PAT)) Q:'PAT  S CNT=CNT+1   ;# for A Sheet deficiencies
 S LINE=LINE_$J(CNT,3)
 ;end of PATCH 1003 changes
 D SET(LINE,.VALMCNT)
 D SET($$REPEAT^XLFSTR("=",79),.VALMCNT)
 Q
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
EXIT ; -- exit code
 K ^TMP("BDGICR2",$J)
 Q
EXPND ; -- expand code
 Q
PRINT ; print report to paper
 NEW BDGX,BDGLN,WARD,BDGI,BDGPG
 U IO
 ;see 2^BDGICR for original code here, moved due to routine size limit patch 1007
 ;cmi/anch/maw 7/10/2007 modified below patch 1007 to adhere to new # of copies in BDGF
 W @IOF   ;form feed between copies
 K BDGPG D INIT^BDGF,HDG  ;cmi/anch/maw 7/10/2007 orig line patch 1007
 ;K BDGPG D INIT^BDGF  ;cmi/anch/maw 7/10/2007 modified line patch 1007 to remove upfront header as it gets set in the ^TMP node
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGICR2",$J,BDGX)) Q:'BDGX  D
 . S BDGLN=^TMP("BDGICR2",$J,BDGX,0)
 . I BDGLN="@@@@@" D HDG Q
 . I $Y>(IOSL-4) D HDG
 . W !,BDGLN
 ;cmi/anch/maw 7/10/2007 end of mods
 ;D ^%ZISC,PRTKL^BDGF,EXIT  ;cmi/anch/maw orig 7/10/2007 patch 1007
 I '$G(BDGCOP) D ^%ZISC  ;cmi/anch/maw mod 7/10/2007 patch 1007
 D PRTKL^BDGF,EXIT  ;cmi/anch/maw mod 7/10/2007 patch 1007
 Q
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGTIME,?16,$$CONF^BDGF,?76,BDGUSR
 W !,BDGDATE,?24,"Incomplete Charts by Provider",?71,"Page: ",BDGPG
 ;IHS/ITSC/LJF 8/9/2004 PATCH #1001
 NEW X S X=$S(BDGTYP=1:"Inpatients",BDGTYP=2:"Observations & Day Surgeries",1:"Inpatients, Observations & Day Surgeries")
 W !?(80-$L(X)\2),X
 I BDGRPT=2 W !,$$REPEAT^XLFSTR("=",80) Q  ;summary page only
 W !,$$REPEAT^XLFSTR("-",80)
 W !?2,"Patient",?22,"HRCN",?30,"Date",?40,"Type",?50,"Deficiencies"
 W ?72,"Days"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
PROVS() ;EP select providers for report
 ; returns type of info in BDGPRV array
 ; also called by ^BDGICS5  ;IHS/OIT/LJF 04/06/2006 PATCH 1005
 NEW X,Y
 ;IHS/OIT/LJF 0420/2006 PATCH 1005 added choice to print only med staff
 ;S Y=$$READ^BDGF("SO^1:For a Service;2:For a Class;3:For Providers by Name","Choose Selection Criteria") I Y<1 Q 0
 S Y=$$READ^BDGF("SO^1:For a Service;2:For a Class;3:For Providers by Name;4:Medical Staff Only","Choose Selection Criteria") I Y<1 Q 0
 I Y=4 D  Q "NAME"
 . NEW FAC S FAC=$$DIV^BSDU
 . I FAC S X=0 F  S X=$O(^BDGPAR(FAC,3,X)) Q:'X  S BDGPRV(+^BDGPAR(FAC,3,X,0))=$$GET1^DIQ(9009020.13,X_","_FAC,.01)
 S X=$S(Y=1:"SRV",Y=2:"CLASS",1:"NAME") D @X
 Q X
SRV ; select providers by their hospital service designation
 NEW X,Y
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($O(BDGPRV(0)):"Another ",1:"")_"Hospital Service Name"
 . S Y=$$READ^BDGF("PO^49:EMQZ",X,"","","I $P(^DIC(49,+Y,0),U,9)=""C""")
 . I Y>0 S BDGPRV(+Y)=$P(Y,U,2)
 Q
CLASS ; select providers by their provider class
 NEW X,Y
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($O(BDGPRV(0)):"Another ",1:"")_"Provider Class"
 . S Y=$$READ^BDGF("PO^7:EMQZ",X)
 . I Y>0 S BDGPRV(+Y)=$P(Y,U,2)
 Q
NAME ; select providers by name        
 NEW X,Y
 S Y=1 F  Q:Y<1  D
 . S X="Select "_$S($O(BDGPRV(0)):"Another ",1:"")_"Provider Name"
 . S Y=$$READ^BDGF("PO^200:EMQZ",X,"","","I $D(^XUSEC(""PROVIDER"",+Y))")
 . I Y>0 S BDGPRV(+Y)=$P(Y,U,2)
 Q
GROUP ;; grouping names spelled out   
ASH ;;A Sheet     
OPR ;;Operative Report
SIG ;;Signature
SUM ;;Discharge Summary
