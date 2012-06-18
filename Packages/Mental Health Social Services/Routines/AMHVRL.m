AMHVRL ; IHS/CMI/LAB - VIEW PT RECORD LT ;
 ;;4.0;IHS BEHAVIORAL HEALTH;;MAY 14, 2010
 ;
 ;
 ;This routine calls a list template to view a patient's record.
 ;The first screen displayed is the patient's health summary.
 ;S DIR(0)="Y",DIR("A")="Do you want to display the health summary",DIR("B")="N" KILL DA D ^DIR KILL DIR
 ;I $D(DIRUT) D EXIT Q
 ;S AMHVRLHS=Y
 S AMHVRLHS=0
 ;
 I '$$PKGCK^AMHVU("APCHS","PCC HEALTH SUMMARY") D  D EXIT Q
 . D MSG^AMHVU("**HEALTH SUMMARY SOFTWARE NOT INSTALLED**",2,1,1)
 ;
 I '$G(AMHVRLHS) D  D EXIT Q
 .K DFN K ^TMP("AMHVR",$J)
 .F  D GETPAT Q:$G(DFN)<1  D
 ..S (AMHVSAV,AMHPAT)=DFN
 ..D EN1,FULL^VALM1,EXIT
 ..Q
 .Q
 K DFN K ^TMP("AMHVR",$J)
 F  D GETPAT Q:$G(DFN)<1  D
 . NEW AMHPAT,AMHTYP,AMHTAT,AMHMTY,AMCHDAYS,AMCHDOB,AMHVSAV
 . D GETHSTYP I '$G(AMHTYP) D EXIT Q
 . S AMHPAT=DFN,AMHVSAV=DFN
 . D EN,FULL^VALM1,EXIT
 ;
EOJ ; -- end of job
 D LMKILL^AMHVU
 Q
 ;
HAVEPAT ;EP; -- entry point when patient already known
 NEW AMHPAT,AMHTYP,AMHTAT,AMHMTY,AMCHDAYS,AMCHDOB,AMHVSAV
 D GETHSTYP I '$G(AMHTYP) D EXIT Q
 S AMHPAT=DFN,AMHVSAV=DFN
 D EN,FULL^VALM1,EXIT
 Q
 ;
EN1 ;EP
 S VALMCC=1 ;1=screen mode, 0=scrolling mode
 D TERM^VALM0
 D EN^VALM("AMHV NO HS VIEW")
 D CLEAR^VALM1
 Q
 ;
EN ;EP; -- main entry point for list template AMHV HS VIEW
 S VALMCC=1 ;1=screen mode, 0=scrolling mode
 D TERM^VALM0
 D EN^VALM("AMHV HS VIEW")
 D CLEAR^VALM1
 Q
 ;
HDR ;EP; -- header code
 S VALMSG=$$VALMSG^AMHVU
 Q
 ;
HDR1 ;EP - no hs view
 S VALMSG="        Select the appropriate action   Q for QUIT"
 Q
INIT1 ;EP - no hs view
 K ^TMP("AMHVR",$J) S AMHC=8
 S ^TMP("AMHVR",$J,1,0)="Patient: "_$P(^DPT(DFN,0),U)_"   HRN: "_$$HRN^AUPNPAT(DFN,DUZ(2))
 S ^TMP("AMHVR",$J,2,0)="         "_$$VAL^XBDIQ1(2,DFN,.02)_"  DOB: "_$$FMTE^XLFDT($P(^DPT(DFN,0),U,3))_"   AGE: "_$$AGE^AUPNPAT(DFN,DT,"E")_"   SSN: "_$$SSN^AMHUTIL(DFN)
 S ^TMP("AMHVR",$J,3,0)=IORVON_"Designated Providers:"_IORVOFF
 S ^TMP("AMHVR",$J,4,0)=" Mental Health: "_$E($$VAL^XBDIQ1(9002011.55,DFN,.02),1,22),$E(^TMP("AMHVR",$J,4,0),40)="Social Services: "_$E($$VAL^XBDIQ1(9002011.55,DFN,.03),1,22)
 ;S ^TMP("AMHVR",$J,4,0)="Designated Social Services Provider: "_$$VAL^XBDIQ1(9002011.55,DFN,.03)
 ;S ^TMP("AMHVR",$J,5,0)="    A/SA/CD: "_$E($$VAL^XBDIQ1(9002011.55,DFN,.04)),1,22)
 S ^TMP("AMHVR",$J,5,0)="          A/SA: "_$E($$VAL^XBDIQ1(9002011.55,DFN,.04),1,22),$E(^TMP("AMHVR",$J,5,0),40)="          Other: "_$E($$VAL^XBDIQ1(9002011.55,DFN,.12),1,22)
 ;S ^TMP("AMHVR",$J,6,0)="          Designated OTHER Provider: "_$$VAL^XBDIQ1(9002011.55,DFN,.12)
 S ^TMP("AMHVR",$J,6,0)="     Other (2): "_$E($$VAL^XBDIQ1(9002011.55,DFN,.13),1,22),$E(^TMP("AMHVR",$J,6,0),40)="   Primary Care: "_$E($$VAL^XBDIQ1(9000001,DFN,.14),1,22)
 ;S ^TMP("AMHVR",$J,7,0)="      Designated OTHER (2) Provider: "_$$VAL^XBDIQ1(9002011.55,DFN,.13)
 ;S ^TMP("AMHVR",$J,8,0)="              Primary Care Provider: "_$$VAL^XBDIQ1(9000001,DFN,.14)
 S ^TMP("AMHVR",$J,7,0)=""
 S R=$$LVD^AMHDPEE(DFN,"I")
 I 'R S ^TMP("AMHVR",$J,8,0)="No BH Visits on File" S AMHC=AMHC+1
 I R D
 .S ^TMP("AMHVR",$J,8,0)="Last Visit (excl no shows): "_$$FMTE^XLFDT($P($P(^AMHREC(R,0),U),"."))_"  "_$$PPNAME^AMHUTIL(R)_"  "
 .NEW D S D=0 F  S D=$O(^AMHRPRO("AD",R,D)) Q:D'=+D  D
 ..S AMHC=AMHC+1 S ^TMP("AMHVR",$J,AMHC,0)="            "_$$VAL^XBDIQ1(9002011.01,D,.01)_"  "_$$VAL^XBDIQ1(9002011.01,D,.04)
 ..Q
 .Q
AXV ;
 K AMHAX5 S AMHCNT=0
 S AMHSIVD=0 F  S AMHSIVD=$O(^AMHREC("AE",DFN,AMHSIVD)) Q:AMHSIVD=""!(AMHCNT>6)  D
 .S AMHX=0 F  S AMHX=$O(^AMHREC("AE",DFN,AMHSIVD,AMHX)) Q:AMHX'=+AMHX  D
 ..Q:$P($G(^AMHREC(AMHX,0)),U,14)=""
 ..I $$ALLOWVI^AMHUTIL(DUZ,AMHX) S AMHCNT=AMHCNT+1,AMHAX5(AMHCNT)=(9999999-$P(AMHSIVD,"."))_U_$P(^AMHREC(AMHX,0),U,14)
 ..Q
 .Q
 I $D(AMHAX5) D
 .S AMHC=AMHC+1,^TMP("AMHVR",$J,AMHC,0)="**********  LAST 6 AXIS V VALUES RECORDED.  (GAF SCORES)  **********"
 .S X="",AMHJ=2 F AMHCNT=6:-1:1  I $D(AMHAX5(AMHCNT))  S $E(X,AMHJ)=$$DATE($P(AMHAX5(AMHCNT),U)) S AMHJ=AMHJ+12
 .S AMHC=AMHC+1,^TMP("AMHVR",$J,AMHC,0)=X
 .S X="",AMHJ=6 F AMHCNT=6:-1:1 I $D(AMHAX5(AMHCNT)) S $E(X,AMHJ)=$P(AMHAX5(AMHCNT),U,2) S AMHJ=AMHJ+12
 .S AMHC=AMHC+1 S ^TMP("AMHVR",$J,AMHC,0)=X
 ;pending appts
PEND ;
 S X="Pending Appointments:",AMHC=AMHC+1,^TMP("AMHVR",$J,AMHC,0)=X
 S AMHDAT=0,AMHVDT=DT-.01 F  S AMHVDT=$O(^DPT(DFN,"S",AMHVDT)) Q:'AMHVDT  D ONEVIS Q:$D(AMHQIT)
 S VALMCNT=AMHC
 Q
 ;
ONEVIS S AMHN=^DPT(DFN,"S",AMHVDT,0)
 Q:"CP"[$E($P(AMHN,U,2)_" ")
 I AMHVDT\1'=AMHDAT S Y=AMHVDT\1 S (AMHPVD,AMHDAT)=$$FMTE^XLFDT(Y)
 S AMHVT=$E($P(AMHVDT,".",2)_"000",1,4) S:AMHVT>1300 AMHVT=AMHVT-1200 S:$L(AMHVT)=3 AMHVT=" "_AMHVT S:$E(AMHVT)="0" AMHVT=" "_$E(AMHVT,2,4) S AMHVT=$E(AMHVT,1,2)_":"_$E(AMHVT,3,4)
 S AMHTST="" F AMHI=3,4,5 S AMHJ=$P(AMHN,U,AMHI) I AMHJ S:AMHTST]"" AMHTST=AMHTST_"," S AMHTST=AMHTST_$P("^^LAB^XRAY^EKG^",U,AMHI)
 S AMHCP=+AMHN,AMHCN=$P(^SC(AMHCP,0),U,1)
 S AMHTST="",AMHVNT=""
 S AMHVN=0 F AMHQ=0:0 S AMHVN=$O(^SC(AMHCP,"S",AMHVDT,1,AMHVN)) Q:'AMHVN  I +^(AMHVN,0)=DFN S AMHTST=$P(^(0),U,2),AMHVNT=$P(^(0),U,4) S:AMHTST AMHTST=AMHTST_" min."
 F AMHI=3,4,5 S AMHJ=$P(AMHN,U,AMHI) I AMHJ S:AMHTST]"" AMHTST=AMHTST_"," S AMHTST=AMHTST_$P("^^LAB^XRAY^EKG^",U,AMHI)
L1 ;
 S X="",$E(X,2)=AMHDAT,$E(X,15)=AMHVT,$E(X,22)=AMHCN I AMHTST]"" S X=X_" ("_AMHTST_")"
 S:$P(AMHN,U,2)["N" X=X_" *** DNKA ***"
 S AMHC=AMHC+1,^TMP("AMHVR",$J,AMHC,0)=X
 I AMHVNT]"" S AMHC=AMHC+1,^TMP("AMHVR",$J,AMHC,0)=AMHVNT
 Q
INIT ;EP; -- init variables and list array
 K ^TMP("AMHVR",$J)
 D GUIR^XBLM("EN^APCHS","^TMP(""AMHVR"",$J,")
 S X=0 F  S X=$O(^TMP("AMHVR",$J,X)) Q:'X  D
 . S VALMCNT=X
 . S ^TMP("AMHVR",$J,X,0)=^TMP("AMHVR",$J,X)
 S VALMSG=$$VALMSG^AMHVU
 Q
 ;
HELP ;EP; -- help code
 S X="?" D DISP^XQORM1 W !!
 Q
 ;
EXIT ;EP; -- exit code
 K ^TMP("AMHVR",$J) K DFN
 D EN^XBVK("AMH")
 D KILL^AUPNPAT
 Q
 ;
EXPND ;EP; -- expand code
 Q
 ;
PAUSE ;EP -- end of action pause
 D RETURN^AMHVU Q
 ;
RESET ;EP -- update partition for return to list manager
 I $D(VALMQUIT) S VALMBCK="Q" Q
 D TERM^VALM0 S VALMBCK="R"
 I '$G(AMHVRLHS) D INIT1,HDR1 Q
 D MSG^AMHVU("Updating Health Summary Display.  Please Wait...",1,0,0)
 D INIT,HDR Q
 ;
RESET2 ;EP -- update partition without recreating display array
 I $D(VALMQUIT) S VALMBCK="Q" Q
 I '$G(AMHVRLHS) D TERM^VALM0 S VALMBCK="R" D HDR1 Q
 D TERM^VALM0 S VALMBCK="R" D HDR Q
 ;
GETPAT ;EP -- ask user to select patient
 K DIC,DFN,AMHPAT S DIC=9000001,DIC(0)="AEMQZ" D ^DIC I Y>0 S (AMHPAT,DFN)=+Y
 Q:Y=-1
 I $G(AUPNDOD)]"" W !!?10,"***** PATIENT'S DATE OF DEATH IS ",$$FMTE^XLFDT(AUPNDOD),!! H 2 D
 .W !?25,"Ok" S %=1 D YN^DICN I %'=1 S AMHPAT="",DFN="" Q
 I DFN,'$$ALLOWP^AMHUTIL(DUZ,DFN) D NALLOWP^AMHUTIL G GETPAT
 W !?25,"Ok" S %=1 D YN^DICN I %'=1 S AMHPAT="",DFN="" G GETPAT
 Q
 ;
GETHSTYP ;EP -- ask user for health summary type
 NEW DIC,DR,DD,X
 S DIC="^APCHSCTL(",DIC(0)="AEMQ"
 S X="" I DUZ(2),$D(^APCCCTRL(DUZ(2),0))#2 S X=$P(^(0),U,3)
 I $D(^DISV(DUZ,"^APCHSCTL(")) D
 . S Y=^("^APCHSCTL(") I $D(^APCHSCTL(Y,0)) S X=$P(^(0),U,1)
 S:X="" X="ADULT REGULAR" S DIC("B")=X
 D ^DIC K DIC Q:Y<1  S APCHSTYP=+Y
 Q
LV(P) ;
 I '$G(P) Q ""
 NEW D,V
 S D=$O(^AMHREC("AE",P,0))
 I 'D Q ""
 S V=$O(^AMHREC("AE",P,D,0))
 Q V
FS ;EP -called from protcol to display face sheet
 D FULL^VALM1
 S AMHHDR="Demographic Face Sheet For "_$P(^DPT(DFN,0),U)
 D VIEWR^XBLM("START^AGFACE",AMHHDR)
 K AGOPT,AGDENT,AGMVDF,AMHHDR
 D RESET
 Q
HSDISP ;EP
 S AMHPATH=$G(DFN),AMHPAT=AMHPATH
 D EN^AMHDPP
 S (DFN,AMHPAT)=AMHPATH
 D RESET
 Q
SR ;EP
 S AMHPATH=$G(DFN),AMHPAT=AMHPATH
 NEW AMHPATH D EP^AMHPST(DFN)
 ;S (DFN,AMHPAT)=AMHPATH
 I '$G(DFN) W !!,"dfn missing"
 D RESET
 Q
DATE(D) ;EP
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_(1700+$E(D,1,3))
