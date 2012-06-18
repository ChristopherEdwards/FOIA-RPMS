BDGOPL ; IHS/ANMC/LJF - OPERATORS' LIST OF INPATIENTS ;  [ 08/12/2003  3:58 PM ]
 ;;5.3;PIMS;;APR 26, 2002
 ;
 I $$BROWSE^BDGF="B" D EN Q
 D ZIS^BDGF("QP","EN^BDGOPL","OPERATORS' LIST","")
 Q
 ;
EN ; -- main entry point for BDG OPERATORS' LIST
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG OPERATORS' LIST")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 Q
 ;
INIT ; -- init variables and list array
 NEW WD,DFN,BDGCNT,NAME
 K ^TMP("BDGOPL",$J),^TMP("BDGOPL1",$J)
 S VALMCNT=0,BDGCNT=1
 ;
 ; loop thru inpatients and put in alphabetical order
 S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S ^TMP("BDGOPL1",$J,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; pull sorted list and create display array
 S NM=0 F  S NM=$O(^TMP("BDGOPL1",$J,NM)) Q:NM=""  D
 . S DFN=0 F  S DFN=$O(^TMP("BDGOPL1",$J,NM,DFN)) Q:'DFN  D
 .. D LINE
 ;
 K ^TMP("BDGOPL1",$J)
 Q
 ;
LINE ; set up dislay line for patient
 NEW LINE,X
 ;
 S LINE=$E($$GET1^DIQ(2,DFN,.01),1,23)  ;name
 I $$OPTOUT^BDGF1(DFN) S LINE=$$REPEAT^XLFSTR("*",20)   ;if patient opted out of directory;IHS/ITSC/LJF 10/03/2003
 ;
 S LINE=$$PAD(LINE,25)_$$PHONE                                ;rm phone
 S LINE=$$PAD(LINE,33)_$G(^DPT(DFN,.101))                     ;room
 S LINE=$$PAD(LINE,42)_$$WRDABRV^BDGF1(DFN)                   ;ward
 S LINE=$$PAD(LINE,50)_$$GET1^DIQ(2,DFN,.02,"I")              ;sex
 S LINE=$$PAD(LINE,55)_$J($$GET1^DIQ(9000001,DFN,1102.98),7)  ;age
 S LINE=$$PAD(LINE,65)_$E($$GET1^DIQ(9000001,DFN,1118),1,15)  ;commun
 D SET(LINE,.VALMCNT)
 Q
 ;
SET(LINE,NUM) ; put display line into array
 S NUM=NUM+1
 S ^TMP("BDGOPL",$J,NUM,0)=LINE
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGPG
 U IO D HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGOPL",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGOPL",$J,BDGX,0)
 . W !,BDGLN
 ;
 D ^%ZISC,EXIT
 Q
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF    ;page #
 W !?16,$$CONF^BDGF,?67,$$FMTE^XLFDT(DT)
 W !?28,"Operators' Inpatient List",?70,$J($$TIME^BDGF($$NOW^XLFDT),9)
 W !,$$REPEAT^XLFSTR("-",80)
 W !,"Patient",?25,"Phone",?33,"Room",?42,"Ward",?49,"Sex"
 W ?57,"Age",?65,"Community"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
PHONE() ; returns room phone number if asked for
 NEW X,ROOM
 S ROOM=$G(^DPT(DFN,.101)) I ROOM="" Q ""
 S X=$O(^DG(405.4,"B",ROOM,0)) I 'X Q ""
 S X=$$GET1^DIQ(405.4,X,9999999.01)
 Q $S(X]"":"x"_X,1:"")
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGOPL",$J)
 K BDGSRT
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
