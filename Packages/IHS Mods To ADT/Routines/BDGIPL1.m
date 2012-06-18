BDGIPL1 ; IHS/ANMC/LJF - ALPHA LIST OF CURRENT INPTS ; 
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;
 ;cmi/anch/maw 2/22/2007 added code in PRINT to not close device if multiple copies PATCH 1007 item 1007.39
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG IPL ALPHA
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL ALPHA")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 Q
 ;
INIT ; -- init variables and list array
 NEW WD,DFN,BDGCNT,NAME
 I $E(IOST,1,2)="C-" D MSG^BDGF("Please wait while I compile the listing...",2,0)
 K ^TMP("BDGIPL",$J),^TMP("BDGIPL1",$J)
 S VALMCNT=0,BDGCNT=1
 ;
 ; loop thru inpatients and put in alphabetical order
 S WD=0 F  S WD=$O(^DPT("CN",WD)) Q:WD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WD,DFN)) Q:'DFN  D
 .. S ^TMP("BDGIPL1",$J,$$GET1^DIQ(2,DFN,.01),DFN)=""
 ;
 ; pull sorted list and create display array
 S NM=0 F  S NM=$O(^TMP("BDGIPL1",$J,NM)) Q:NM=""  D
 . S DFN=0 F  S DFN=$O(^TMP("BDGIPL1",$J,NM,DFN)) Q:'DFN  D
 .. D LINE
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
LINE ; set up dislay line for patient
 NEW LINE,X
 S LINE=$S($E(IOST,1,2)="P-":$$SP(5),1:$J(BDGCNT,3)_") ")
 S LINE=$$PAD(LINE,5)_$E($$GET1^DIQ(2,DFN,.01),1,18)          ;name
 S LINE=$$PAD(LINE,25)_$$HRCND^BDGF2($$HRCN^BDGF2(DFN,DUZ(2)))
 S LINE=$$PAD(LINE,35)_$$AGE(DFN)                             ;age
 S LINE=$$PAD(LINE,43)_$E($$GET1^DIQ(9000001,DFN,1118),1,15)  ;commun
 S LINE=$$PAD(LINE,60)_$$INS                         ;insurnace coverage
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ;
 S LINE=$$SP(6)_"Admitted to "_$$WRDABRV^BDGF1(DFN)           ;ward
 S X=$G(^DPT(DFN,.101))
 I X]"" S LINE=LINE_" ("_X_")"                                ;room
 S LINE=$$PAD(LINE,30)_$$GET1^DIQ(45.7,+$G(^DPT(DFN,.103)),99)  ;srv
 S LINE=$$PAD(LINE,37)_$$CURPRV^BDGF1(DFN,30)                ;attn prov
 S LINE=$$PAD(LINE,57)_" on "_$P($$INPT1^BDGF1(DFN,DT),"@")  ;admit date
 S LINE=$$PAD(LINE,69)_"("_$$CURLOS^BDGF1(DFN,1)_")"           ;los
 D SET(LINE,.VALMCNT,BDGCNT,DFN)
 D SET("",.VALMCNT,BDGCNT,DFN)
 ;
 ; increment counter
 S BDGCNT=BDGCNT+1
 Q
 ;
SET(LINE,NUM,COUNT,IEN) ;EP - put display line into array
 S NUM=NUM+1
 S ^TMP("BDGIPL",$J,NUM,0)=LINE
 S ^TMP("BDGIPL",$J,"IDX",NUM,COUNT)=IEN
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGLN,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 ; loop thru display array
 S BDGX=0 F  S BDGX=$O(^TMP("BDGIPL",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . S BDGLN=^TMP("BDGIPL",$J,BDGX,0)
 . W !,BDGLN
 I '$G(BDGCOP) D ^%ZISC  ;cmi/anch/maw 2/22/2007 added for no close of device if multiple copies PATCH 1007 item 1007.39
 D PRTKL^BDGF,EXIT
 ;D ^%ZISC,PRTKL^BDGF,EXIT cmi/anch/maw 2/22/2007 orig line
 Q
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGTIME,?16,$$CONF^BDGF,?71,"Page: ",BDGPG
 W !,BDGDATE,?24,"Alphabetical List of Current Inpatients",?76,BDGUSR
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient",?25,"HRCN",?35,"Age",?43,"Community",?60,"Insurance"
 W !?6,"Ward (Room)",?29,"Srv",?36,"Provider",?60,"Admit Date (LOS)"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
INS() ; returns combination of MCR/MCD/PI
 NEW DATE,ANS
 S DATE=$G(^DPT(DFN,.105)) I 'DATE Q ""     ;admission ien
 S DATE=+$G(^DGPM(DATE,0))                  ;admit date
 Q $$INSUR^BDGF2(DFN,DATE)
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGIPL",$J)
 Q
 ;
EXPND ; -- expand code
 D FULL^VALM1
 NEW X,Y,Z
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 K DFN S X=0 F  S X=$O(VALMY(X)) Q:X=""  D
 . S Y=0 F  S Y=$O(^TMP("BDGIPL",$J,"IDX",Y)) Q:Y=""  Q:$G(DFN)  D
 .. S Z=$O(^TMP("BDGIPL",$J,"IDX",Y,0))
 .. Q:^TMP("BDGIPL",$J,"IDX",Y,Z)=""
 .. I Z=X S DFN=^TMP("BDGIPL",$J,"IDX",Y,Z)
 Q
 ;
PAD(D,L) ;EP -- SUBRTN to pad length of data
 ; -- D=data L=length
 Q $E(D_$$REPEAT^XLFSTR(" ",L),1,L)
 ;
SP(N) ; -- SUBRTN to pad N number of spaces
 Q $$PAD(" ",N)
 ;
AGE(P) ; return formatted age
 NEW X S X=$$GET1^DIQ(9000001,DFN,1102.98)
 S X=$J($P(X," "),3)_" "_$E($P(X," ",2),1,2)
 Q X
