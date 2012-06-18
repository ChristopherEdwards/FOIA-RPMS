BDGIPL5 ; IHS/ANMC/LJF - CURR INPTS BY SRV & PROV ;  
 ;;5.3;PIMS;**1007**;FEB 27, 2007
 ;
 ;
 ;cmi/anch/maw 2/22/2007 added code in PRINT to not close device if multiple copies PATCH 1007 item 1007.39
 ;
 I $E(IOST,1,2)="P-" D INIT,PRINT Q
 ;
EN ; -- main entry point for BDG IPL BY PROVIDER
 ; assumes BDGSRT and BDGSRT1 are set
 NEW VALMCNT D TERM^VALM0,CLEAR^VALM1
 D EN^VALM("BDG IPL BY PROVIDER")
 D CLEAR^VALM1
 Q
 ;
HDR ; -- header code
 NEW X
 S VALMHDR(1)=$$SP(12)_"** "_$$CONF^BDGF_" **"
 S X=$S(BDGSRT="A":"For ALL Treating Specialties",1:$P(BDGSRT,U,2))
 S X=X_" / "_$S(BDGSRT1="A":"For ALL Providers",1:$P(BDGSRT1,U,2))
 S VALMHDR(2)=$$SP(79-$L(X)\2)_X
 I $G(BDGSRT2) D
 . S X=$S(BDGSRT2=1:"Inpatients Only",BDGSRT2=2:"Observations Only",1:"")
 . I X]"" S VALMHDR(3)=$$SP(75-$L(X)\2)_X
 Q
 ;
INIT ; -- init variables and list array
 NEW BDGSRV,BDGSVN,BDGCNT,SRV,PROV,LINE,DFN,X
 K ^TMP("BDGIPL",$J),^TMP("BDGIPL1",$J)
 S VALMCNT=0,BDGCNT=1
 ;11/1/O2 WAR - following change per P37 LJF30
 ;IHS/ANMC/LJF 10/31/2002 add ability to print >1 service
 ;S BDGSRV=$S(BDGSRT="A":0,1:+BDGSRT)
 ;I BDGSRV S BDGSVN=$P(BDGSRT,U,2) D PATLOOP,TRANSFER I 1  ;one service
 ;
 ; if user asked for all services
 ;E  F  S BDGSRV=$O(^DPT("ATR",BDGSRV)) Q:'BDGSRV  D
 I '$D(BDGSRT2) S BDGSRT2=""
 S BDGSRV=0 F  S BDGSRV=$O(^DPT("ATR",BDGSRV)) Q:'BDGSRV  D
 . I BDGSRT=0,'$D(BDGSRT(BDGSRV)) Q       ;not in list of selected services
 . ;IHS/ANMC/LJF 10/31/2002 end of mods
 . S BDGSVN=$$GET1^DIQ(45.7,BDGSRV,.01)   ;service name
 . I BDGSRT2=1,BDGSVN["OBSERVATION" Q     ;inpt only
 . I BDGSRT2=2,BDGSVN'["OBSERVATION" Q    ;observation only
 . D PATLOOP,TRANSFER
 ;
 ; pull sorted list and create display array
 S SRV=0 F  S SRV=$O(^TMP("BDGIPL1",$J,SRV)) Q:SRV=""  D
 . ;
 . ; set up service name subheading
 . I SRV'["**" D SET($G(IORVON)_SRV_$G(IORVOFF),.VALMCNT,BDGCNT,"")
 . ;
 . S PROV=0 F  S PROV=$O(^TMP("BDGIPL1",$J,SRV,PROV)) Q:PROV=""  D
 .. ;
 .. ; if SRV contains "**" means list of transfers out of service
 .. I SRV["**" D
 ... S X="Admitted to "_$P(SRV,"**")_" ("_PROV_")"_" then tranferred:"
 ... D SET(X,.VALMCNT,BDGCNT,"")
 .. ;
 .. ; set up provider subheading
 .. E  D
 ... S X=$$SP(3)_$G(IORVON)_PROV_$G(IORVOFF)
 ... D SET(X,.VALMCNT,BDGCNT,"")
 .. ;
 .. S DFN=0 F  S DFN=$O(^TMP("BDGIPL1",$J,SRV,PROV,DFN)) Q:'DFN  D
 ... ;
 ... S LINE=$S($E(IOST,1,2)="P-":$$SP(5),1:$J(BDGCNT,3)_") ")
 ... S LINE=LINE_$E($$GET1^DIQ(2,DFN,.01),1,20)  ;patient
 ... S LINE=$$PAD(LINE,27)_$J($$HRCN^BDGF2(DFN,DUZ(2)),6)     ;chart#
 ... S LINE=$$PAD(LINE,36)_$$GET1^DIQ(9000001,DFN,1102.98)    ;age
 ... S LINE=$$PAD(LINE,44)_$$GET1^DIQ(2,DFN,.02,"I")          ;sex
 ... S LINE=$$PAD(LINE,47)_$E($$GET1^DIQ(9000001,DFN,1118),1,15)  ;comm
 ... S LINE=$$PAD(LINE,64)_$E($$CURDX^BDGF1(DFN),1,16)        ;adm dx
 ... D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ... ; 
 ... S LINE=$$SP(10)_"Admitted: "
 ... S LINE=LINE_$P($$INPT1^BDGF1(DFN,DT),":",1,2)            ;admit dt
 ... S LINE=LINE_" ("_$$CURLOS^BDGF1(DFN,1)_")"               ;los
 ... S LINE=$$PAD(LINE,50)_$$WRDABRV^BDGF1(DFN)_" Ward"       ;ward
 ... S X=$G(^DPT(DFN,.101)) I X]"" S LINE=LINE_" ("_X_")"     ;room-bed
 ... D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ... ;
 ... ; if transferred, display date and new service
 ... S X=^TMP("BDGIPL1",$J,SRV,PROV,DFN) I X]"" D
 .... S LINE=$$SP(12)_"To "_$$GET1^DIQ(2,DFN,.103)
 .... S LINE=LINE_" ("_$$CURPRV^BDGF1(DFN,32)_")"
 .... S LINE=LINE_" on "_$P(X,":",1,2)
 .... D SET(LINE,.VALMCNT,BDGCNT,DFN)
 ... ;
 ... D SET("",.VALMCNT,BDGCNT,DFN)  ;blank line between patients
 ... ; increment counter
 ... S BDGCNT=BDGCNT+1
 .. ;
 .. ; skip line between services
 .. I $O(^TMP("BDGIPL1",$J,SRV,PROV))="" D SET("",.VALMCNT,BDGCNT,"")
 ;
 K ^TMP("BDGIPL1",$J)
 Q
 ;
PATLOOP ; loop by dfn then sort results by provider
 NEW DFN,X
 Q:BDGSVN=""   ;in case of incomplete admissions in file
 S DFN=0 F  S DFN=$O(^DPT("ATR",BDGSRV,DFN)) Q:'DFN  D
 . S X=$$CURPRV^BDGF1(DFN) I X="" S X="??"
 . I BDGSRT1,(X'=$P(BDGSRT1,U,2)) Q   ;not provider selected
 . S ^TMP("BDGIPL1",$J,BDGSVN,X,DFN)=""
 Q
 ;
TRANSFER ; returns new service and date if transferred from admtg service
 NEW CA,SRV,DATE,X,DFN
 S WARD=0 F  S WARD=$O(^DPT("CN",WARD)) Q:WARD=""  D
 . S DFN=0 F  S DFN=$O(^DPT("CN",WARD,DFN)) Q:'DFN  D
 .. S CA=$G(^DPT(DFN,.105))                          ;admission ien
 .. S SRV=$$ADMSRV^BDGF1(CA,DFN) S:SRV="" SRV="??"   ;admission service
 .. ;
 .. ; if adm service not equal current service, continue
 .. I SRV'=$$GET1^DIQ(2,DFN,.103) D
 ... ;11/1/O2 WAR - following change per P37 LJF30
 ... ;IHS/ANMC/LJF 10/31/2002 check array of sevices
 ... ;I BDGSRT'="A" Q:SRV'=BDGSVN  ;not looking for this service
 ... I BDGSRT'="A" NEW X S X=$O(^DIC(45.7,"B",SRV,0)) Q:'X  I '$D(BDGSRT(X)) Q
 ... ;IHS/ANMC/LJF 10/31/2002 end of mods
 ... I BDGSRT="A",$G(BDGSRT2)=2 Q:SRV'["OBSERVATION"
 ... S DATE=$$GET1^DIQ(405,+$$LASTTXN^BDGF1(CA,DFN),.01)   ;transf date
 ... ;
 ... ; subscript is adm service
 ... S X=$$ADMPRV^BDGF1(CA,DFN,"PRM") S:X="" X="??"   ;primary inpt prv
 ... S ^TMP("BDGIPL1",$J,SRV_"**",X,DFN)=DATE
 Q
 ;
SET(LINE,NUM,COUNT,IEN) ; put display line into array
 D SET^BDGIPL1(LINE,.NUM,COUNT,IEN)
 Q
 ;
PRINT ; print report to paper
 NEW BDGX,BDGPG
 U IO D INIT^BDGF,HDG
 ;
 S BDGX=0 F  S BDGX=$O(^TMP("BDGIPL",$J,BDGX)) Q:'BDGX  D
 . I $Y>(IOSL-4) D HDG
 . W !,^TMP("BDGIPL",$J,BDGX,0)
 I '$G(BDGCOP) D ^%ZISC  ;cmi/anch/maw 2/22/2007 added for no close of device if multiple copies PATCH 1007 item 1007.39
 D PRTKL^BDGF,EXIT
 ;D ^%ZISC,PRTKL^BDGF,EXIT  cmi/anch/maw 2/22/2007 orig line
 Q  ;cmi/anch/maw 7/11/2007 was appended to previous line PATCH 1007
 ;
HDG ; heading for paper report
 S BDGPG=$G(BDGPG)+1 I BDGPG>1 W @IOF
 W !,BDGUSR,?16,$$CONF^BDGF
 W !,BDGDATE,?20,"Current Inpatients by Service/Provider"
 ;11/1/O2 WAR - following change per P37 LJF30
 ;S X=$S(BDGSRT="A":"For ALL Treating Specialties",1:$P(BDGSRT,U,2))  ;IHS/ANMC/LJF 10/31/2002
 S X=$S(BDGSRT="A":"For ALL Treating Specialties",1:$$SERVS)          ;IHS/ANMC/LJF 10/31/2002
 W ?70,"Page: ",BDGPG
 S X=X_$S(BDGSRT1="A":" / For ALL Providers",1:$P(BDGSRT1,U,2))
 W !,BDGTIME,?(80-$L(X)\2),X
 I $G(BDGSRT2) D
 . S X=$S(BDGSRT2=1:"Inpatients",BDGSRT2=2:"Observations",1:"")
 . I X]"" S X="("_X_" Only)" W !?(80-$L(X)\2),X
 W !,$$REPEAT^XLFSTR("-",80)
 W !?5,"Patient Name",?27,"Chart #",?36,"Age",?43,"Sex  Community"
 W ?64,"Admitting Dx"
 W !,$$REPEAT^XLFSTR("=",80)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ^TMP("BDGIPL",$J)
 ;K BDGSRT,BDGSRT1,DGPMIFN  cmi/anch/maw 7/25/2007 is needed for multiple copies patch 1007
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
 ;11/1/O2 WAR - following change per P37 LJF30
SERVS() ; returns service name or "selected services";IHS/ANMC/LJF 10/31/2002
 NEW X
 S X=$O(BDGSRT(0)) I $O(BDGSRT(X)) Q "Selected Services"
 Q BDGSRT(X)
