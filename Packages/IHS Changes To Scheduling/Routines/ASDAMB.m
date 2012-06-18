ASDAMB ; IHS/ADC/PDW/ENM - APPT MADE BY ; [ 03/25/1999  11:48 AM ]
 ;;5.0;IHS SCHEDULING;;MAR 25, 1999
 ;
PAT ; -- ask user for patient
 NEW DIC S DIC=9000001,DIC(0)="AEQM" D ^DIC Q:X=""!(X=U)
 I Y<0 W "  ??",*7 G PAT
 S DFN=+Y
 ;
DATE ; -- ask user for starting date
 K DIR,ASDBDT,ASDEDT
 S DIR(0)="DO^::EX",DIR("A")="Select beginning date"
 D ^DIR K DIR G PAT:$D(DIRUT),PAT:Y<1 S ASDBDT=Y
 I '$O(^DPT(DFN,"S",Y)) D  G PAT
 . W !!,"NO APPOINTMENTS FOUND!",!
 ;
EDATE ; -- ask user for ending date
 S DIR(0)="DO^::EX",DIR("A")="Select ending date"
 D ^DIR K DIR G PAT:$D(DIRUT),PAT:Y<1 S ASDEDT=Y
 ;
 D EN G PAT
 ;
EN ; -- main entry point for SD IHS APPT MADE BY
 D EN^VALM("SD IHS APPT MADE BY")
 D EXIT Q
 ;
HDR ; -- header code
 S VALMHDR(1)=$$PAD("",16)_$$CONF^ASDUT
 Q
 ;
INIT ; -- init variables and list array
 NEW ASDX,ASDS,ASDL,ASDEND
 K ASDLN,ASDNUM,^TMP("ASDAMB",$J)
 S ASDX=ASDBDT,ASDEND=ASDEDT+.2400
 F  S ASDX=$O(^DPT(DFN,"S",ASDX)) Q:'ASDX!(ASDX>ASDEND)  D
 . S ASDS=^DPT(DFN,"S",ASDX,0)
 . S ASDL=$$PAD($$FMTE^XLFDT(ASDX),20) ;appt dt
 . S ASDL=ASDL_$$PAD($$VAL^XBDIQ1(44,$P(ASDS,U),.01),24)_" " ;clinic
 . D FINDUSR
 . I ASDU]"" S ASDL=ASDL_$$PAD($$VAL^XBDIQ1(200,ASDU,.01),17) ;made by
 . I ASDU="" S ASDL=ASDL_$$PAD("??",17)
 . I ASDM]"" S ASDL=ASDL_" "_$$FMTE^XLFDT(ASDM) ;appt made dt
 . I ASDM="" S ASDL=ASDL_" ??"
 . S ASDLN=$G(ASDLN)+1,ASDNUM=$G(ASDNUM)+1
 . S ^TMP("ASDAMB",$J,ASDLN,0)=$J(ASDNUM,2)_". "_ASDL
 . S ^TMP("ASDAMB",$J,"IDX",ASDLN,ASDNUM)=DFN_U_+ASDS_U_ASDX
 S VALMCNT=+$G(ASDLN)
 Q
 ;
HELP ; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ; -- exit code
 K ASDBDT,ASDEDT,ASDA,ASDLN,ASDM,ASDNUM,ASDU,ASDX,AGE,SEX,DFN
 K SDC,SDIFN,SDP,SDPP,SDS,SDSTAT,SSN,VALMY,ORX
 K VALMBCK,VALMCNT,VALMHDR
 Q
 ;
EXPND ; -- expand code
 Q
 ;
RETURN ; -- reset variables for return to lt
 D TERM^VALM0 S VALMBCK="R" Q
 ;
GETAPPT ; -- select appt from listing
 D FULL^VALM1
 S ASDA=""
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("ASDAMB",$J,"IDX",Y)) Q:Y=""  Q:ASDA]""  D
 . S Z=$O(^TMP("ASDAMB",$J,"IDX",Y,0))
 . Q:^TMP("ASDAMB",$J,"IDX",Y,Z)=""
 . I Z=X S ASDA=^TMP("ASDAMB",$J,"IDX",Y,Z)
 Q:ASDA=""
 S DFN=$P(ASDA,U),SDIFN=$P(ASDA,U,2),SDA=$P(ASDA,U,3)
 Q
 ;
VA ;EP; called by View Appt action
 S (DFN,SDIFN,SDA)="" D GETAPPT
 I DFN=""!(SDIFN="")!(SDA="") D  D RETURN Q
 . W !,"Sorry data missing on this appointment!"
 D ^XBCLS,P^SDCLK,PRTOPT^ASDVAR,RETURN
 Q
 ;
FINDUSR ; -- gets user and date made from file 44
 NEW X,Y
 S Y=$P(^DPT(DFN,"S",ASDX,0),U,18,19)
 I +Y S ASDU=$P(Y,U),ASDM=$P(Y,U,2) Q
 K Y S X=0 F  S X=$O(^SC(+ASDS,"S",ASDX,1,X)) Q:X=""!($D(Y))  D
 . I +^SC(+ASDS,"S",ASDX,1,X,0)'=DFN Q
 . S Y=$P(^SC(+ASDS,"S",ASDX,1,X,0),U,6,7)
 S ASDU=$P($G(Y),U),ASDM=$P($G(Y),U,2)
 Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
