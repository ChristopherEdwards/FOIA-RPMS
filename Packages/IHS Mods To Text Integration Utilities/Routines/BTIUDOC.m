BTIUDOC ; IHS/ITSC/LJF - DICTATION OP REPORT COUNTS ;
 ;;1.0;TEXT INTEGRATION UTILITIES;;NOV 04, 2004
 ;
 ;
 NEW TIUEDT,TIUBDT
 S TIUBDT=$$EDATE^TIULA("Operation",""," ") Q:TIUBDT<1
 S TIUEDT=$$LDATE^TIULA("Operation",""," ") Q:TIUEDT<1
 D ZIS^BTIUU("PQ","EN^BTIUDOC","OP RPT DICT COUNTS","TIUBDT;TIUEDT")
 Q
 ;
EN ; -- main entry point for BTIU OP RPT COUNTS
 NEW VALMCNT
 I IOST'["C-" D GATHER(TIUBDT,TIUEDT),PRINT Q
 D TERM^VALM0
 D EN^VALM("BTIU IC OP STATUS")
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
 NEW TIULN,VALMCNT
 S VALMCNT=$O(^TMP("BTIUDOC",$J,""),-1)
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K VALMCNT
 K ^TMP("BTIUDOC",$J),^TMP("BTIUDOC2",$J)
 Q
 ;
EXIT2 ;EP; -- exit code for patient listing
 K VALMCNT Q
 ;
EXPND ; -- expand code
 Q
 ;
GATHER(TIUBDT,TIUEDT) ; -- create display array
 NEW X,TIUCNT,TIUCD,DFN,DSC,TIUOPN,CD,DSCH,LINE,TIUN,TIUSRV
 K ^TMP("BTIUDOC",$J),^TMP("BTIUDOC1",$J),^TMP("BTIUDOC2",$J)
 K ^TMP("BTIUDOC3",$J)
 S (TIUCNT,TIULN)=0
 S DATE=TIUBDT-.0001,END=TIUEDT+.2400
 F  S DATE=$O(^SRF("AC",DATE)) Q:'DATE!(DATE>END)  D
 . S TIUOPN=0 F  S TIUOPN=$O(^SRF("AC",DATE,TIUOPN)) Q:'TIUOPN  D
 .. S DFN=^SRF("AC",DATE,TIUOPN)
 .. Q:$$GET1^DIQ(130,TIUOPN,17)]""                                 ;cancelled
 .. S TIUVST=$$GET1^DIQ(130,TIUOPN,9999999.01,"I") Q:'TIUVST
 .. S TIUSRV=$$GET1^DIQ(130,TIUOPN,.04) I TIUSRV="" S TIUSRV="??"
 .. S TIUOPDT=$$GET1^DIQ(130,TIUOPN,.09,"I")                       ;op date
 .. ;
 .. NEW TIUDICT,TIUAUTH
 .. S TIU=0,TIUAUTH=""
 .. F  S TIU=$O(^TIU(8925,"V",TIUVST,TIU)) Q:'TIU!($G(TIUDICT))  D
 ... I '$$CLASS(+$G(^TIU(8925,TIU,0)),TIU) Q      ;not op rpt
 ... S TIUDICT=$$GET1^DIQ(8925,TIU,1307,"I")      ;dictation date
 ... S TIUAUTH=$$GET1^DIQ(8925,TIU,1202)          ;dictated by
 .. ;
 .. S LINE=$$DATA(DFN,TIUOPN,TIUOPDT,$G(TIUDICT)) ;create display line
 .. S ^TMP("BTIUDOC3",$J,TIUSRV,TIUOPDT,TIUOPN)=LINE
 .. D TOT(TIUSRV,$$DPRV(TIUOPN,$G(TIUAUTH)),TIUOPDT,$G(TIUDICT))
 ;
 ; -- put listing in order by service and op date
 S TIULN=0,S=0 F  S S=$O(^TMP("BTIUDOC3",$J,S)) Q:S=""  D
 . D SET("",.TIULN),SET("SERVICE:  "_S,.TIULN)
 . S D=0 F  S D=$O(^TMP("BTIUDOC3",$J,S,D)) Q:D=""  D
 .. S N=0 F  S N=$O(^TMP("BTIUDOC3",$J,S,D,N)) Q:'N  D
 ... S X=^TMP("BTIUDOC3",$J,S,D,N) D SET(X,.TIULN)
 ;
 ; -- put totals in order by service and provider
 NEW TOTAL S TOTAL=0
 S TIULN=0,S=0 F  S S=$O(^TMP("BTIUDOC1",$J,S)) Q:S=""  D
 . S X=^TMP("BTIUDOC1",$J,S),LINE=$$LINE2(S,"",X)
 . D TOTL(X,.TOTAL)  ;increment grand total
 . D SET2("",.TIULN),SET2(LINE,.TIULN)
 . S P=0 F  S P=$O(^TMP("BTIUDOC1",$J,S,P)) Q:P=""  D
 .. S X=^TMP("BTIUDOC1",$J,S,P),LINE=$$LINE2("",P,X) D SET2(LINE,.TIULN)
 ;
 S LINE=$$REPEAT^XLFSTR("=",79) D SET2("",.TIULN),SET2(LINE,.TIULN)
 S LINE=$$LINE2("GRAND TOTAL","",TOTAL) D SET2(LINE,.TIULN)
 S LINE=$$LINE3(TOTAL) D SET2(LINE,.TIULN),SET2("",.TIULN)
 K ^TMP("BTIUDOC1",$J),^TMP("BTIUDOC3",$J)
 Q
 ;
 ;
DATA(DFN,OPN,OPDT,DICT) ; -- returns display line
 NEW X,TIUY
 S TIUY=$$PAD($$PAT(DFN),27)_"  "
 S TIUY=TIUY_$$PAD($$DPRV(OPN,TIUAUTH),15)
 S TIUY=TIUY_$$PAD($J($$FMTE^XLFDT(OPDT,"2D"),10),12)
 S TIUY=TIUY_$$PAD($J($$FMTE^XLFDT(DICT,"2"),10),13)
 S TIUY=TIUY_$$STATUS(DICT\1,OPDT\1)
 Q TIUY
 ;
PAT(DFN) ; -- returns patient chart # and last name
 NEW X,Y
 S X=$P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)
 S Y=$P($G(^DPT(DFN,0)),U)
 Q $J(X,7)_"  "_$E(Y,1,18)
 ;
STATUS(DICT,OPDT) ; -- returns whether dictated on time or not
 I +DICT=0 Q "NOT DONE"
 I DICT=OPDT Q "ON TIME"
 Q "LATE"
 ;
CLASS(TYPE,IEN) ; -- returns 1 if doc is in op report dic class
 I $$GET1^DIQ(8925.1,TYPE,.01)="ADDENDUM" S TYPE=$$GET1^DIQ(8925,IEN,.04,"I")
 I $$PNAME^TIULC1(+$$DOCCLASS^TIULC1(TYPE))="OPERATIVE REPORTS" Q 1
 Q 0
 ;
DPRV(IEN,AUTH) ; -- author or surgeon if not dictated yet
 I AUTH]"" Q AUTH
 NEW X S X=$$GET1^DIQ(130,IEN,.14)  ;surgeon
 Q $S(X]"":X,1:"??")
 ;
 ;
SET(LINE,TIULN) ; -- sets ^tmp
 S TIULN=TIULN+1
 S ^TMP("BTIUDOC",$J,TIULN,0)=LINE
 Q
 ;
SET2(LINE,TIULN) ; -- sets ^tmp
 S TIULN=TIULN+1
 S ^TMP("BTIUDOC2",$J,TIULN,0)=LINE
 Q
 ;
PRINT ; -- print lists to paper
 NEW TIUX,TIUL,TIUPG
 D INIT^BTIUU
 F TIUX="BTIUDOC2","BTIUDOC" D
 . D HDG
 . S TIUL=0 F  S TIUL=$O(^TMP(TIUX,$J,TIUL)) Q:'TIUL  D
 .. I $Y>(IOSL-4) D HDG
 .. D MSG^BTIUU(^TMP(TIUX,$J,TIUL,0),1,0,0)
 D ^%ZISC,PRTKL^BTIUU,EXIT
 Q
 ;
HDG ; -- prints 2nd half of heading
 S TIUPG=$G(TIUPG)+1 I TIUPG>1 W @IOF
 W !,TIUTIME,?16,$$CONFID^BTIUU,?71,"Page: ",TIUPG
 W !,TIUDATE,?24,"OPERATIVE REPORTS DICTATION STATISTICS",?76,TIUUSR
 W !?($L(TIUFAC\2)),TIUFAC,!,$$REPEAT^XLFSTR("-",80)
 ;
 I TIUX="BTIUDOC2" S X=" Service"_$$SP(13)_"Provider"_$$SP(12)_"#Sur   Dict:  On Time  Late  Not Done"
 E  S X="  HRCN   Patient Name"_$$SP(8)_"Provider"_$$SP(5)_"Surgery    Dictated    Status"
 W !,X,!,$$REPEAT^XLFSTR("=",80)
 Q
 ;
TOT(SRV,PRV,DSC,DICT) ; -- increment ^tmp for totals
 NEW X,Y
 S X=$G(^TMP("BTIUDOC1",$J,SRV,PRV)),Y=$G(^TMP("BTIUDOC1",$J,SRV))
 D INCREM
 S ^TMP("BTIUDOC1",$J,SRV)=Y,^TMP("BTIUDOC1",$J,SRV,PRV)=X
 Q
 ;
TOTL(DATA,TOTAL) ; increment grand total
 F I=1:1:4 S $P(TOTAL,U,I)=$P(TOTAL,U,I)+$P(DATA,U,I)
 Q
 ;
INCREM ; -- increment # discharges,dictated on time, late or not at all
 S $P(X,U)=$P(X,U)+1,$P(Y,U)=$P(Y,U)+1  ;total surgeries
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
 D HDR S VALMCNT=$O(^TMP("BTIUDOC2",$J,""),-1) Q
 ;
PAD(DATA,LENGTH) ; -- SUBRTN to pad length of data
 Q $E(DATA_$$REPEAT^XLFSTR(" ",LENGTH),1,LENGTH)
 ;
SP(NUM) ; -- SUBRTN to pad spaces
 Q $$PAD(" ",NUM)
 ;
PROV() ; -- ask for provider
 Q $$READ^TIUU("PO^200","Select PROVIDER NAME")
