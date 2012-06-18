BTIUDSC ; IHS/ITSC/LJF - DICTATION COUNTS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 ;
 D ^XBCLS
 S Y=$$READ^TIUU("SO^1:DISCHARGE SUMMARY DICTATIONS;2:OPERATIVE REPORT DICTATIONS","Select REPORT TYPE") Q:'Y
 I +Y=2 D ^BTIUDOC Q
 ;
 NEW TIUEDT,TIUBDT
 S TIUBDT=$$EDATE^TIULA("Discharge",""," ") Q:TIUBDT<1
 S TIUEDT=$$LDATE^TIULA("Discharge",""," ") Q:TIUEDT<1
 D ZIS^BTIUU("PQ","EN^BTIUDSC","DSUM DICT COUNTS","TIUBDT;TIUEDT")
 Q
 ;
EN ; -- main entry point for BTIU DSUM COUNTS
 NEW VALMCNT
 I IOST'["C-" D GATHER(TIUBDT,TIUEDT),PRINT Q
 D TERM^VALM0
 D EN^VALM("BTIU IC DICT STATUS")
 Q
 ;
HDR ;EP; -- header code
 Q
 ;
INIT ;EP; -- init variables and list array
 NEW TIULN
 D MSG^BTIUU("Building/Updating Display. . .Please wait.",2,0,0)
 D GATHER(TIUBDT,TIUEDT)
 S VALMCNT=TIULN
 Q
 ;
INIT2 ;EP; -- init variables and list array
 NEW TIULN
 S VALMCNT=+$O(^TMP("BTIUDSC",$J,""),-1)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K VALMCNT
 K ^TMP("BTIUDSC",$J),^TMP("BTIUDSC2",$J)
 Q
 ;
EXIT2 ;EP; -- exit code for patient listing
 K VALMCNT Q
 ;
EXPND ; -- expand code
 Q
 ;
GATHER(TIUBDT,TIUEDT) ; -- create display array
 NEW X,TIUCNT,TIUCD,DFN,DSC,IEN,CD,DSCH,LINE,TIUN,TIUSRV
 K ^TMP("BTIUDSC",$J),^TMP("BTIUDSC1",$J),^TMP("BTIUDSC2",$J)
 K ^TMP("BTIUDSC3",$J)
 S (TIUCNT,TIULN)=0
 S DATE=TIUBDT-.0001,END=TIUEDT+.2400
 F  S DATE=$O(^DGPM("ATT3",DATE)) Q:'DATE!(DATE>END)  D
 . S IEN=0 F  S IEN=$O(^DGPM("ATT3",DATE,IEN)) Q:'IEN  D
 .. S DFN=$P(^DGPM(IEN,0),U,3),TIUCA=$P(^DGPM(IEN,0),U,14)
 .. S TIUDSDT=+^DGPM(IEN,0),TIUADDT=+^DGPM(TIUCA,0)
 .. S TIUVST=$$GET1^DIQ(405,TIUCA,.27,"I") I TIUVST<1 D ERR(1) Q
 .. S TIUSRV=$$DSRV(TIUCA) Q:TIUSRV["OBSERVATION"
 .. S DAYS=$S(TIUSRV="NEWBORN":5,1:3)               ;anmc parameter for req dis summ
 .. I $$FMDIFF^XLFDT(TIUDSDT,TIUADDT,1)<DAYS Q      ;LOS<3 or 4 or 5 days
 .. ;
 .. NEW TIUDICT,TIUAUTH
 .. S TIU=0,TIUAUTH="",TIUDICT=""
 .. F  S TIU=$O(^TIU(8925,"V",TIUVST,TIU)) Q:'TIU!($G(TIUDICT))  D
 ... I '$$CLASS(+$G(^TIU(8925,TIU,0))) Q      ;not dsum
 ... S TIUDICT=$$GET1^DIQ(8925,TIU,1307,"I")  ;dictation date
 ... S TIUAUTH=$$GET1^DIQ(8925,TIU,1202)      ;dictated by
 .. ;         
 .. S LINE=$$DATA(DFN,TIUDSDT,$G(TIUDICT))    ;create display line
 .. S ^TMP("BTIUDSC3",$J,TIUSRV,TIUDSDT,IEN)=LINE
 .. D TOT(TIUSRV,$$DPRV(TIUCA,TIUAUTH),TIUDSDT,TIUDICT)
 ;
 ; -- put listing in order by service and dsch date
 S TIULN=0,S=0 F  S S=$O(^TMP("BTIUDSC3",$J,S)) Q:S=""  D
 . D SET("",.TIULN),SET("SERVICE:  "_S,.TIULN)
 . S D=0 F  S D=$O(^TMP("BTIUDSC3",$J,S,D)) Q:D=""  D
 .. S N=0 F  S N=$O(^TMP("BTIUDSC3",$J,S,D,N)) Q:'N  D
 ... S X=^TMP("BTIUDSC3",$J,S,D,N) D SET(X,.TIULN)
 ;
 ; -- put totals in order by service and provider
 NEW TOTAL S TOTAL=0
 S TIULN=0,S=0 F  S S=$O(^TMP("BTIUDSC1",$J,S)) Q:S=""  D
 . S X=^TMP("BTIUDSC1",$J,S),LINE=$$LINE2(S,"",X)
 . D TOTL(X,.TOTAL)  ;increment grand total
 . D SET2("",.TIULN),SET2(LINE,.TIULN)
 . S P=0 F  S P=$O(^TMP("BTIUDSC1",$J,S,P)) Q:P=""  D
 .. S X=^TMP("BTIUDSC1",$J,S,P),LINE=$$LINE2("",P,X) D SET2(LINE,.TIULN)
 ;
 S LINE=$$REPEAT^XLFSTR("=",79) D SET2("",.TIULN),SET2(LINE,.TIULN)
 S LINE=$$LINE2("GRAND TOTAL","",TOTAL) D SET2(LINE,.TIULN)
 S LINE=$$LINE3(TOTAL) D SET2(LINE,.TIULN),SET2("",.TIULN)
 K ^TMP("BTIUDSC1",$J),^TMP("BTIUDSC3",$J)
 Q
 ;
 ;
DATA(DFN,DSDT,DICT) ; -- returns display line
 NEW X,TIUY
 ;S TIUCNT=TIUCNT+1,TIUY=$J(TIUCNT,3)
 S TIUY=$$PAD($$PAT(DFN),27)_"  "
 S TIUY=TIUY_$$PAD($$DPRV(TIUCA,TIUAUTH),15)
 S TIUY=TIUY_$$PAD($J($$FMTE^XLFDT(DSDT,"2D"),10),12)
 S TIUY=TIUY_$$PAD($J($$FMTE^XLFDT(DICT,"2"),10),13)
 S TIUY=TIUY_$$STATUS(DICT\1,DSDT)
 Q TIUY
 ;
PAT(DFN) ; -- returns patient chart # and last name
 NEW X,Y
 S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 S Y=$P($G(^DPT(DFN,0)),U)
 Q $J(X,7)_"  "_$E(Y,1,18)
 ;
STATUS(DICT,DSCH) ; -- returns whether dictated on time or not
 I +DICT=0 Q "NOT DONE"
 I DICT'>DSCH Q "ON TIME"
 Q "LATE"
 ;
CLASS(TYPE) ; -- returns 1 if doc is in dsch summ dic class (244)
 I $$GET1^DIQ(8925.1,TYPE,.01)="ADDENDUM" S TYPE=$$GET1^DIQ(8925,IEN,.04,"I")
 I $$DOCCLASS^TIULC1(TYPE)=244 Q 1
 Q 0
 ;
DSRV(CA) ; -- discharge service
 I $L($T(^BDGF1)) Q $$LASTSRVN^BDGF1(CA,DFN)    ;PIMS V5.3
 NEW X,Y
 S Y=9999999.9999999-$G(^DGPM(+$P(^DGPM(CA,0),U,17),0)) Q:'Y 0
 S X=$O(^DGPM("ATID6",+DFN,+$O(^DGPM("ATID6",+DFN,Y)),0))
 S X=$P($G(^DGPM(+X,0)),U,9)
 Q $$GET1^DIQ(45.7,X,.01)
 ;
DPRV(CA,AUTH) ; -- discharge provider
 I AUTH]"" Q AUTH
 I $L($T(^BDGF1)) Q $$LASTPRV^BDGF1(CA,DFN,"ATT")  ;PIMS V5.3
 NEW W,X,Y,Z,AP
 S X="",Y=0 F  S Y=$O(^DGPM("ATS",DFN,TIUCA,Y)) Q:'Y!(X]"")  D
 . S Z=0 F  S Z=$O(^DGPM("ATS",DFN,TIUCA,Y,Z)) Q:'Z!(X]"")  D
 .. S W=0 F  S W=$O(^DGPM("ATS",DFN,TIUCA,Y,Z,W)) Q:'W!(X]"")  D
 ... S X=$$GET1^DIQ(405,W,.19)             ;attending
 ... I X="" S AP=$$GET1^DIQ(405,W,.08)     ;admitting
 I X="" S X=$S($G(AP)]"":AP,1:"??")
 Q X
 ;
 ;
SET(LINE,TIULN) ; -- sets ^tmp
 S TIULN=TIULN+1
 S ^TMP("BTIUDSC",$J,TIULN,0)=LINE
 Q
 ;
SET2(LINE,TIULN) ; -- sets ^tmp
 S TIULN=TIULN+1
 S ^TMP("BTIUDSC2",$J,TIULN,0)=LINE
 Q
 ;
PRINT ; -- print lists to paper
 NEW TIUX,TIUL,TIUPG
 U IO D INIT^BTIUU
 F TIUX="BTIUDSC2","BTIUDSC" D
 . D HDG
 . S TIUL=0 F  S TIUL=$O(^TMP(TIUX,$J,TIUL)) Q:'TIUL  D
 .. I $Y>(IOSL-4) D HDG
 .. W !,^TMP(TIUX,$J,TIUL,0)
 D ^%ZISC,PRTKL^BTIUU,EXIT
 Q
 ;
HDG ; -- prints 2nd half of heading
 S TIUPG=$G(TIUPG)+1 I TIUPG>1 W @IOF
 W !,TIUTIME,?16,$$CONFID^BTIUU,?71,"Page: ",TIUPG
 W !,TIUDATE,?24,"DISCHARGE SUMMARY DICTATION STATISTICS",?76,TIUUSR
 W !?($L(TIUFAC\2)),TIUFAC,!,$$REPEAT^XLFSTR("-",80)
 ;
 I TIUX="BTIUDSC2" S X=" Service"_$$SP(13)_"Provider"_$$SP(12)_"#DSCH  Dict:  On Time  Late  Not Done"
 E  S X="  HRCN   Patient Name"_$$SP(8)_"Provider"_$$SP(5)_"Dschargd   Dictated    Status"
 W !,X,!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
TOT(SRV,PRV,DSC,DICT) ; -- increment ^tmp for totals
 NEW X,Y
 S X=$G(^TMP("BTIUDSC1",$J,SRV,PRV)),Y=$G(^TMP("BTIUDSC1",$J,SRV))
 D INCREM
 S ^TMP("BTIUDSC1",$J,SRV)=Y,^TMP("BTIUDSC1",$J,SRV,PRV)=X
 Q
 ;
TOTL(DATA,TOTAL) ; increment grand total
 F I=1:1:4 S $P(TOTAL,U,I)=$P(TOTAL,U,I)+$P(DATA,U,I)
 Q
 ;
INCREM ; -- increment # discharges,dictated on time, late or not at all
 S $P(X,U)=$P(X,U)+1,$P(Y,U)=$P(Y,U)+1  ;total dsch
 I DICT="" S $P(X,U,4)=$P(X,U,4)+1,$P(Y,U,4)=$P(Y,U,4)+1 Q    ;not dict
 I DICT'>DSC S $P(X,U,2)=$P(X,U,2)+1,$P(Y,U,2)=$P(Y,U,2)+1 Q  ;on time
 S $P(X,U,3)=$P(X,U,3)+1,$P(Y,U,3)=$P(Y,U,3)+1                ;dict late
 Q
 ;
LINE2(SRV,PRV,DATA) ; -- sets up display line for totals
 NEW X
 S X=" "_$$PAD(SRV,18)_"  "_$$PAD($E(PRV,1,18),21)
 S X=X_$$PAD($J($P(DATA,U),3),15)_$$PAD($J($P(DATA,U,2),3),7)
 S X=X_$$PAD($J($P(DATA,U,3),3),7)_$J($P(DATA,U,4),3)
 Q X
 ;
LINE3(DATA) ; -- sets up display line for totals
 NEW X,T,OT,LT,ND
 S T=$P(DATA,U) I 'T S (OT,LT,ND)=0
 E  S OT=$P(DATA,U,2)/T*100,LT=$P(DATA,U,3)/T*100,ND=$P(DATA,U,4)/T*100
 S X=$$SP(57)_$$PAD($J(OT,3,0)_"%",7)
 S X=X_$$PAD($J(LT,3,0)_"%",7)_$J(ND,3,0)_"%"
 Q X
 ;
GETIC ; -- select item from list
 NEW X,Y,Z,VALMY
 D FULL^VALM1
 S TIUICN=0
 D EN^VALM2(XQORNOD(0),"OS")
 I '$D(VALMY) Q
 S X=$O(VALMY(0))
 S Y=0 F  S Y=$O(^TMP("TIUZICL",$J,"IDX",Y)) Q:Y=""  Q:TIUICN>0  D
 . S Z=$O(^TMP("TIUZICL",$J,"IDX",Y,0))
 . Q:^TMP("TIUZICL",$J,"IDX",Y,Z)=""
 . I Z=X S TIUICN=^TMP("TIUZICL",$J,"IDX",Y,Z)
 Q
 ;
ICE ;EP; -- action to edit IC file
 NEW TIUICN,DIE,DA,DR
 D GETIC I 'TIUICN D RESET2 Q
 S DIE="^BDGIC(",DA=+TIUICN,DR="[BTIU ICE UPDATE]" D ^DIE
 Q
 ;
ICP ;EP; -- action to print chart copy
 NEW TIUICN
 D GETIC Q:'TIUICN  S TIUDA=$P(TIUICN,U,2) I TIUDA="" Q
 D PRINT1^TIURA
 Q
 ;
RESET ;EP; -- action to rebuild display
 D TERM^VALM0 S VALMBCK="R"
 D INIT,HDR Q
 ;
RESET2 ;EP; -- action to rebuild display
 D TERM^VALM0 S VALMBCK="R"
 D HDR S VALMCNT=$O(^TMP("BTIUDSC2",$J,""),-1) Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
PROV() ; -- ask for provider
 Q $$READ^TIUU("PO^200","Select PROVIDER NAME")
 ;
ERR(NUM) ; -- sets errors
 S LINE="ERROR MESSAGE:  DFN="_DFN_"  TIUCA="_TIUCA_"  NO VISIT"
 D SET(LINE,.TIULN)
 Q
