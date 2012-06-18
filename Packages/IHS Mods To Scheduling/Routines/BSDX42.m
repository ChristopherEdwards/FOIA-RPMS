BSDX42 ; IHS/OIT/HMW/MSC/SAT - WINDOWS SCHEDULING RPCS ;
 ;;3.0;IHS WINDOWS SCHEDULING;;DEC 09, 2010
 ;
ZIS ;
 S Y=DFN
 I $D(DIRUT) D EXIT Q
 S APCHOPT=Y
 S XBRP="PRINT^BSDX42",XBRC="",XBRX="EXIT^BSDX42",XBNS="APCH;DFN"
 D ^XBDBQUE
 D EXIT
 Q
 ;
WISDW(DFN,SDATE,EMSG) ;PEP; print Wellness handout
 ; .EMSG = returned error message if error
 ;
 I +DFN=0 Q
 ;
 NEW DGPGM,VAR,VAR1,DEV,POP
 S SDX="ALL",ORDER="",SDREP=0,SDSTART="",DIV=$$DIV^BSDU
 ;
 S DGPGM="PRINT^BSDX42"
 S DEV=".11"   ;default printer fields
 S BDGDEV=$$GET1^DIQ(9009020.2,$$DIV^BSDU,DEV)
 I BDGDEV="" K BDGDEV S EMSG="PCC Health Summary could not be printed: no default "_$S(BSDMODE="CR":"chart request",1:"walk in")_" printer defined in the IHS SCHEDULING PARAMETERS table." Q
 S IOP=BDGDEV D ^%ZIS I POP D END^SDROUT1 Q
 D PRINT
 Q
 ;
EXIT ;
 D EN^XBVK("APCH")
 D ^XBFMK
 Q
 ;
PRINT ;
OUTPUT ;
 U IO
 S APCHSCVD="S:Y]"""" Y=+Y,Y=$E(Y,4,5)_""/""_$S($E(Y,6,7):$E(Y,6,7)_""/"",1:"""")_$E(Y,2,3)"
 K ^TMP("APCH",$J)
 D EP(DFN) ;gather up data
W ;write out array
 ;W:$D(IOF) @IOF
 K APCHQUIT
 W !,"********** Patient Wellness Handout ********** ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********"
 S APCHX=0 F  S APCHX=$O(^TMP($J,"APCHPWH",APCHX)) Q:APCHX'=+APCHX!($D(APCHQUIT))  D
 .I $Y>(IOSL-3) D HEADER Q:$D(APCHQUIT)
 .W !,^TMP($J,"APCHPWH",APCHX)
 .Q
 I $D(APCHQUIT) S APCHSQIT=1
 D EOJ
 D ^%ZISC
 Q
 ;
EOJ ;
 ;
 K ^TMP("APCHPHS",$J)
 K ^TMP($J,"APCHPWH")
 D EN^XBVK("APCH")
 D EN^XBVK("APCD")
 K BIDLLID,BIDLLPRO,BIDLLRUN,BIRESULT,BISITE
 K AUPNDAYS,AUPNDOB,AUPNDOD,AUPNPAT,AUPNSEX
 K N,%,T,F,X,Y,B,C,E,F,H,J,L,N,P,T,W,ST,ST0
 Q
HEADER ;
 I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCHQUIT="" Q
HEAD1 ;
 W:$D(IOF) @IOF
 W !,"********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********",!!
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
EP(APCHSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHPHS",$J,"PMH"
 ;CHANGE TO GO TO NEW PWH 
 S APCHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 D EP1(APCHSDFN,APCHPWHT)
 Q
EP1(APCHSDFN,APCHPWHT,APCHPRTH) ;PEP - PASS DFN get back array of patient wellness handout
 ;handout returned in ^TMP("APCHPHS",$J,"APCHPWH"
 ;APCHPWHT - ien of the PWH type
 ;APCHPRTH - 1 if you don't want the header line printed
 K ^TMP($J,"APCHPWH")
 S ^TMP($J,"APCHPWH",0)=0
 I '$G(APCHPWHT) S APCHPWHT=$O(^APCHPWHT("B","ADULT REGULAR",0))
 I '$G(APCHPWHT) Q
 D SETARRAY
 Q
SETARRAY ;set up array containing pwh
 ;all handouts get this demographic section
 NEW X,APCHPRV,APCHSO,APCHSCMP,APCHSCMI
 I '$G(APCHPRTH) S X="My Wellness Handout",$E(X,40)="Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X="********** CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" **********" D S(X)
 ;S X=$P($P(^DPT(APCHSDFN,0),U),",",2)_" "_$P($P(^DPT(APCHSDFN,0),U),",")_"   HRN:  "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)),$E(X,50)=$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,1)
 S X=$P(^DPT(APCHSDFN,0),U)_"   HRN:  "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)),$E(X,50)=$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,1)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.111)
 S $E(X,50)=$$VAL^XBDIQ1(9999999.06,DUZ(2),.15)_$S($$VAL^XBDIQ1(9999999.06,DUZ(2),.15)]"":", ",1:" ")_$S($P($G(^AUTTLOC(DUZ(2),0)),U,14):$P(^DIC(5,$$VALI^XBDIQ1(9999999.06,DUZ(2),.16),0),U,2),1:"")_"  "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.17) D S(X)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.114)_$S($$VAL^XBDIQ1(2,APCHSDFN,.114)]"":",  ",1:" ")_$$VAL^XBDIQ1(2,APCHSDFN,.115)_"   "_$$VAL^XBDIQ1(2,APCHSDFN,.116)
 S APCHPRV=$$DPCP(APCHSDFN)
 I APCHPRV D
 .S $E(X,50)=$P(^VA(200,APCHPRV,0),U) D S(X)
 I 'APCHPRV D S(X)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.131),$E(X,50)=$P(^AUTTLOC(DUZ(2),0),U,11) D S(X)  ;put provider phone at 50
 ;I $G(APCDVSIT)]"",$D(^AUPNVSIT("AC",APCHSDFN,APCDVSIT)) S APCHPROV=$$PRIMPROV^APCLV(APCDVSIT)
 ;S X="Hello "_$S($$SEX^AUPNPAT(APCHSDFN)="M":"Mr. ",1:"Ms. ")_$E($P($P(^DPT(APCHSDFN,0),U),","))_$$LOW^XLFSTR($E($P($P(^DPT(APCHSDFN,0),U),","),2,99))_"," D S(X,1)
 S X="Thank you for choosing "_$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U))_"." D S(X,1)
 S X="This handout is a new way for you and your doctor to look at your health." D S(X)
 ;now process each component assigned to this type
 ;
COMPS ;
 I $$AGE^AUPNPAT(APCHSDFN)<18 D S("This handout is designed for patients 18 years of age and older.",2) Q
 S APCHSORD=0 F  S APCHSORD=$O(^APCHPWHT(APCHPWHT,1,APCHSORD)) Q:APCHSORD'=+APCHSORD  D
 .S APCHSCMP=$P(^APCHPWHT(APCHPWHT,1,APCHSORD,0),U,2)
 .Q:'APCHSCMP
 .Q:'$D(^APCHPWHC(APCHSCMP,0))
 .S APCHSCMI=$P(^APCHPWHC(APCHSCMP,0),U,2)
 .D @($P(APCHSCMI,";",1)_U_$P(APCHSCMI,";",2))
 S X="******** END CONFIDENTIAL PATIENT INFORMATION ["_$P(^VA(200,DUZ,0),U,2)_"]  "_$$FMTE^XLFDT(DT)_" ********" D S(X,2)
 ;
DPCP(P) ;EP
 NEW R
 D ALLDP^BDPAPI(P,"DESIGNATED PRIMARY PROVIDER",.R)
 I $D(R("DESIGNATED PRIMARY PROVIDER")) Q $P(R("DESIGNATED PRIMARY PROVIDER"),U,2)
 S R=$P(^AUPNPAT(P,0),U,14) I R Q R
 S R=""
 Q R
 ;
S(Y,F,C,T) ;EP - set up array
 I '$G(F) S F=0
 I '$G(T) S T=0
 NEW %,X
 ;blank lines
 F F=1:1:F S X="" D S1
 S X=Y
 I $G(C) S L=$L(Y),T=(80-L)/2 D  D S1 Q
 .F %=1:1:(T-1) S X=" "_X
 F %=1:1:T S X=" "_Y
 D S1
 Q
S1 ;
 S %=$P(^TMP($J,"APCHPWH",0),U)+1,$P(^TMP($J,"APCHPWH",0),U)=%
 S ^TMP($J,"APCHPWH",%)=X
 Q
 ;
WISD(DFN,SDATE,BSDMODE,BSDDEV,BSDNHS,EMSG) ;PEP; print routing slip for walkin/same day appt
 ; .EMSG = returned error message if error
 ;
 I +DFN=0 Q
 ;***** END 10/21/04
 ;
 NEW DGPGM,VAR,VAR1,DEV,POP
 S SDX="ALL",ORDER="",SDREP=0,SDSTART="",DIV=$$DIV^BSDU
 ;
 ;IHS/ITSC/LJF 6/17/2005 PATCH 1003 adde BSDNHS to variable list
 ;S VAR="DIV^ORDER^SDX^SDATE^DFN^SDREP^SDSTART^BSDMODE"
 ;S VAR1="DIV;ORDER;SDX;SDATE;DFN;SDREP;SDSTART;BSDMODE"
 S VAR="DIV^ORDER^SDX^SDATE^DFN^SDREP^SDSTART^BSDMODE^BSDNHS"
 S VAR1="DIV;ORDER;SDX;SDATE;DFN;SDREP;SDSTART;BSDMODE;BSDNHS"
 ;end of these PATCH 1003 changes
 ;
 S DGPGM="SINGLE^BSDROUT"
 I $G(BSDDEV)]"" D ZIS^BDGF("F","SINGLE^BSDROUT","ROUTING SLIP",VAR1,BSDDEV) Q
 S DEV=$S($G(BSDMODE)="CR":".05",1:".11")   ;default printer fields
 S BDGDEV=$$GET1^DIQ(9009020.2,$$DIV^BSDU,DEV)
 I BDGDEV="" K BDGDEV S EMSG="Routing Slip could not be printed: no default "_$S(BSDMODE="CR":"chart request",1:"walk in")_" printer defined in the IHS SCHEDULING PARAMETERS table." Q
 S IOP=BDGDEV D ^%ZIS I POP D END^SDROUT1 Q
 D SINGLE
 Q
 ;
ONE ;EP; called by SDROUT to print one patient's routing slip
 S DFN=+$$READ^BDGF("PO^2:EQM","Select PATIENT") I DFN<1 D END^SDROUT Q
 D WISD(DFN,DT,"")
 Q
 ;
SINGLE ;EP; queued entry point for single routing slips
 ; called by WISD subroutine
 U IO K ^TMP("SDRS",$J)
 NEW BSDT,CLN,IEN,BSDMOD2
 ;
 ; find all appts for patient
 I BSDMODE="CR" S BSDMOD2="CR",BSDMODE=""
 S BSDT=SDATE\1
 F  S BSDT=$O(^DPT(DFN,"S",BSDT)) Q:'BSDT  Q:(BSDT\1>SDATE)  D
 . S CLN=+$G(^DPT(DFN,"S",BSDT,0)) Q:'CLN   ;clinic ien
 . S IEN=0 F  S IEN=$O(^SC(CLN,"S",BSDT,1,IEN)) Q:'IEN  Q:$P($G(^SC(CLN,"S",BSDT,1,IEN,0)),U)=DFN
 . Q:'IEN                                   ;appt ien in ^sc
 . D FIND^BSDROUT0(CLN,BSDT,IEN,ORDER,BSDMODE)
 I $D(BSDMOD2) S BSDMODE=BSDMOD2
 ;
 ; find all chart requests for patient
 S CLN=0 F  S CLN=$O(^SC("AIHSCR",DFN,CLN)) Q:'CLN  D
 . S BSDT=(SDATE\1)-.0001
 . F  S BSDT=$O(^SC("AIHSCR",DFN,CLN,BSDT)) Q:'BSDT  D
 .. D CRSET^BSDROUT2(CLN,BSDT,DFN,ORDER)
 ;
 K ^TMP("BSDX42",$J)
 MERGE ^TMP("BSDX42",$J)=^TMP("SDRS",$J)
 ; if no future appts, set something so RS will print
 I '$D(^TMP("BSDX42",$J)) S ^TMP("BSDX42",$J,$$GET1^DIQ(2,DFN,.01),$$TERM(DFN),DFN)=""
 ;
 D PRINT^BSDROUT1(ORDER,SDATE)
 Q
TERM(PAT) ; returns chart # in terminal digit format
 NEW N,T
 S N=$$HRCN^BDGF2(PAT,$G(DUZ(2)))         ;chart #
 S T=$$HRCNT^BDGF2(N)                     ;terminal digit format
 I $$GET1^DIQ(9009020.2,+$$DIV^BSDU,.18)="NO" D
 . S T=$$HRCND^BDGF2(N)                   ;use chart # per site param
 Q T
