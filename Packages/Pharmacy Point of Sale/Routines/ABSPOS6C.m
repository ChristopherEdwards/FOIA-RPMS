ABSPOS6C ; IHS/FCS/DRS - continuation of ABSPOS6* ; 
 ;;1.0;PHARMACY POINT OF SALE;**32**;JUN 21, 2001
 Q
DEFTIME() Q .0015 ; fifteen minutes is the default default
UPDFREQ() Q 15 ; every fifteen seconds is the usual case
NEW ; Data entry screen - protocol ABSP P1 NEW CLAIMS
 D FULL^VALM1 W:$D(IOF) @IOF
 D ^ABSPOSI
 D TERM^VALM0 ; not documented!
 S VALMBCK="R" ; is this in here twice for a reason?
 N NODISPLY S NODISPLY=1 D UPD^ABSPOS6A ; update, but don't display!
 ;   when you QUIT with VALMBCK="R", the repainting will take care of it
 S VALMBCK="R"
 Q
MYPARAMS ;EP - from ABSPOS6A
 S ^TMP("ABSPOS",$J,"USER")=$S($D(USER):USER,$G(DUZ):DUZ,1:0)
 S ^TMP("ABSPOS",$J,"TIME")=$S($D(TIME):TIME,1:$$DEFTIME) ; time window
 S ^TMP("ABSPOS",$J,"FREQ")=$$UPDFREQ ; frequency of continuous updates
 S ^TMP("ABSPOS",$J,"LAST UPDATE")=""
 S ^TMP("ABSPOS",$J,"PATIENT")=0 ; all patients
 S ^TMP("ABSPOS",$J,"PATIENT TIME")=30 ; # of days
 S ^TMP("ABSPOS",$J,"MAX LINES")=1000 ; max lines on display
 S DISP="^TMP(""ABSPOS"",$J,""DISP"")"
 S DISPLINE="^TMP(""ABSPOS"",$J,""DISPLINE"")"
 S DISPIDX="^TMP(""ABSPOS"",$J,""VALM"",""IDX"")"
 S DISPHIST="^TMP(""ABSPOS"",$J,""HIST"")"
 ;
 ; Right now:  always display prescription detail.
 ; Detail: If = 0, default is to not display any prescription detail.
 ;    If >0, default is:
 ;  display prescrip detail if pat has at least this many prescriptions
 ;     so if it's =1, we always show prescription line item detail
 ;  don't display detail if pat has < this many prescripts
 ;
 S ^TMP("ABSPOS",$J,"DETAIL")=1 ; do we do prescription detail?
 ;
 ; ^TMP("ABSPOS",$J,"DISP",...
 ;  ,PATNAME)    =line #^sum statuses^datetime last chg^count prescs
 ;    ^#rejected^#otherFails^#paid
 ;  ,PATNAME,RXI)=line #^status      ^datetime last chg
 ;    Note:  status 99 is stored here as 100, as in 100% done
 ;
 ; ^TMP("ABSPOS",$J,"DISPLINE")=how many lines of items
 ; ^TMP("ABSPOS",$J,"DISPLINE",n)=patname or patname^rxi on this line
 ;
 ; ^TMP("ABSPOS",$J,"DISMISS",patname)=time
 ; ^TMP("ABSPOS",$J,"DISMISS",patname,rxi)=time
 ;
 ;  Dismiss any mention of this patient until the given time.
 ;  If a patient is dismissed, so are all of his prescriptions.
 ;  But if a prescription has activity, the patient and that
 ;  active prescription will appear again.
 ;
 S DISMISS="^TMP(""ABSPOS"",$J,""DISMISS"")"
 ;
 ;^TMP("ABSPOS",$J,"VALM",...) is the array we tell listman to use.
 ;^TMP("ABSPOS",$J,"VALM","IDX",LINE,PATIEN) for a patient line
 Q
HDR ;EP - from ABSPOS6A ; -- header code
 N USER,ONEPAT,%
 S USER=^TMP("ABSPOS",$J,"USER")
 S ONEPAT=^TMP("ABSPOS",$J,"PATIENT")
 I USER S %="Transmitted by "_$P($G(^VA(200,USER,0)),U)
 E  D
 . S %="All prescriptions"
 . I ONEPAT S %=%_" for patient "_$P(^DPT(ONEPAT,0),U)
 S VALMHDR(1)=%
 S VALMHDR(2)="With activity in the past"
 S XQORM("B")="UC" ; the default is Update Continuously
 S XQORM("B")="UD" ; but we'd like to do U1 continuously from top lvl
 ; S DTIME=10 ; can't set this time out (wanted to do it to default a continuous update, but:  it affects all reads, so you need to always undo/redo it, and, if first read times out, List Mgr quits on you
 N T,X S X=""
 I ONEPAT S T=^TMP("ABSPOS",$J,"PATIENT TIME")
 E  S T=$G(^TMP("ABSPOS",$J,"TIME"))
 I 'T S T=$$DEFTIME
 I $P(T,".") S X=" "_$P(T,".")_" da"
 S T=$P(T,".",2)_"000000"
 I $E(T,1,2) S X=X_" "_+$E(T,1,2)_" hr"
 I $E(T,3,4) S X=X_" "_+$E(T,3,4)_" min"
 I $E(T,5,6) S X=X_" "_+$E(T,5,6)_" sec"
 S VALMHDR(2)=VALMHDR(2)_X
 Q
ONEPAT() ;EP - from ABSPOS6B 
 ; overflow from ABSPOS - extra date & time info printed in onepat mode
 ; POS time and FILL time
 ;start with kludgey var name machinations (sigh)
 N IEN59 S IEN59=RXI N RXI S RXI=$P(^ABSPT(IEN59,1),U,11)
 N POS S POS=$P(^ABSPT(IEN59,0),U,8)
 N RXR S RXR=$P(^ABSPT(IEN59,1),U)
 ;IHS/OIT/SCR 06/05/09 START CHANGES pre-patch 32 to avoid undefined when RXI AND RXR are ""
 ;N FILL I RXR S FILL=$P($G(^PSRX(RXI,1,RXR,0)),U)
 ;E  S FILL=$P($G(^PSRX(RXI,2)),U,2)
 N FILL
 S FILL=""
 I (RXR&RXI>0) S FILL=$P($G(^PSRX(RXI,1,RXR,0)),U)
 I ('RXR&RXI>0) S FILL=$P($G(^PSRX(RXI,2)),U,2)
 ;IHS/OIT/SCR 06/05/09 END CHANGES pre-patch 32
 N Y S Y=POS D DATEHH S POS=Y
 S Y=FILL D DATEHH S FILL=Y
 I $P(POS,"@")=$P(FILL,"@") D
 . S $P(FILL,"@",1)="" ; don't duplic date
 . I $P(FILL,"@",2)="" S FILL=""
 I FILL="" Q POS
 Q POS_", FILL "_FILL
DATEHH ; given Y, format it and reset it  
 I 'Y S Y="?" Q
 X ^DD("DD") S Y=$P(Y,":",1,2)
 I $P($P(Y,"@"),",",2)-1700-$E(DT,1,3)=0 S Y=$P(Y,",")_"@"_$P(Y,"@",2)
 Q
