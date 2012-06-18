BGP9CPU ; IHS/CMI/LAB - calc CMS measures 26 Sep 2004 11:28 AM 04 May 2008 2:38 PM 02 Jul 2008 9:11 AM ; 
 ;;9.0;IHS CLINICAL REPORTING;;JUL 1, 2009
 ;
WDOB(P) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Date of Birth:  ",$$DATE^BGP9UTL($P(^DPT(P,0),U,3))
 Q
 ;
WRACE(P) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Race:  ",$$VAL^XBDIQ1(2,DFN,.06)
 Q
 ;
WZIP(P) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Postal Code:  ",$$VAL^XBDIQ1(2,P,.116)
 Q
WADM(I) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Admission Type: ",$$VAL^XBDIQ1(9000010.02,I,.07)
 Q
WADM92(I) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Admission Type-UB92: ",$$VAL^XBDIQ1(9000010.02,I,6101)
 Q
 ;
WADMS92(I) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Admission Source-UB92: ",$$VAL^XBDIQ1(9000010.02,I,6102)
 Q
 ;
WDSGS92(I) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 NEW T
 W !?2,"Discharge Status-UB92: " S T=$$VALI^XBDIQ1(9000010.02,I,6103) I T W $$VAL^XBDIQ1(99999.04,T,.02)
 Q
 ;
WINS(V,P) ;EP
 ;check medicare
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?2,"Insurance Status:  "
 NEW I,D,MCR,MCD,PI,RR,J,Y,X,Q,N,C
 S (MCR,MCD,PI,RR)=0
 S D=$P($P(^AUPNVSIT(V,0),U),".")
 S I=0
 F  S I=$O(^AUPNMCR(P,11,I)) Q:I'=+I!(BGPQUIT)  D
 . Q:$P(^AUPNMCR(P,11,I,0),U)>D
 . I $P(^AUPNMCR(P,11,I,0),U,2)]"",$P(^(0),U,2)<D Q
 . I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 . W !?3,"Medicare Coverage Type:  ",$P(^AUPNMCR(P,11,I,0),U,3)," Policy #:  ",$P(^AUPNMCR(P,0),U,3)," Effective Date:  ",$$DATE^BGP9UTL($P(^AUPNMCR(P,11,I,0),U))
 . S MCR=1
 . Q
 ;medicaid
 Q:BGPQUIT
 S Y=0
 S I=0 F  S I=$O(^AUPNMCD("B",P,I)) Q:I'=+I!(BGPQUIT)  D
 .Q:'$D(^AUPNMCD(I,11))
 .S J=0 F  S J=$O(^AUPNMCD(I,11,J)) Q:J'=+J!(BGPQUIT)  D
 ..Q:J>D
 ..I $P(^AUPNMCD(I,11,J,0),U,2)]"",$P(^(0),U,2)<D Q
 ..S MCD=1
 ..I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 ..W !?3,"Medicaid ",$$VAL^XBDIQ1(9000004,I,.11)," Coverage Type:  ",$P(^AUPNMCD(I,11,J,0),U,3)," Policy #:  ",$P(^AUPNMCD(I,0),U,3),!?10,"  Effective Date:  ",$$DATE^BGP9UTL($P(^AUPNMCD(I,11,J,0),U))
 ..Q
 .Q
 ;pi
 Q:BGPQUIT
 S I=0
 F  S I=$O(^AUPNPRVT(P,11,I)) Q:I'=+I!(BGPQUIT)  D
 . Q:$P(^AUPNPRVT(P,11,I,0),U)=""
 . S X=$P(^AUPNPRVT(P,11,I,0),U) Q:X=""
 . Q:$P(^AUTNINS(X,0),U)["AHCCCS"
 . Q:$P(^AUPNPRVT(P,11,I,0),U,6)>D
 . I $P(^AUPNPRVT(P,11,I,0),U,7)]"",$P(^(0),U,7)<D Q
 . S PI=1
 . W !?3,"Private  ",$P(^AUTNINS(X,0),U)
 . S Q=$P(^AUPNPRVT(P,11,I,0),U,8)
 . I Q S N=$P($G(^AUPN3PPH(Q,0)),U,4)
 . I 'Q S N=$P(^AUPNPRVT(P,11,I,0),U,2)
 . I Q S C=$$VAL^XBDIQ1(9000003.1,Q,.05)
 . I 'Q S C=$P(^AUPNPRVT(P,11,I,0),U,3) I C S C=$P($G(^AUTTPIC(C,0)),U)
 . W " Coverage Type:  ",C,!?10,"  Policy #:  ",N,"  Effective Date:  ",$$DATE^BGP9UTL($P(^AUPNPRVT(P,11,I,0),U,6))
 ;RR
 Q:BGPQUIT
 S I=0
 F  S I=$O(^AUPNRRE(P,11,I)) Q:I'=+I!(BGPQUIT)  D
 . Q:$P(^AUPNRRE(P,11,I,0),U)>D
 . I $P(^AUPNRRE(P,11,I,0),U,2)]"",$P(^(0),U,2)<D Q
 . I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 . W !?3,"Railroad Coverage Type:  ",$P(^AUPNRRE(P,11,I,0),U,3)," Policy #:  ",$P(^AUPNRRE(P,0),U,4),"  Effective Date:  ",$$DATE^BGP9UTL($P(^AUPNRRE(P,11,I,0),U))
 . S MCR=1
 . Q
 I '(MCR+MCD+PI+RR) W "No Insurance per Patient Registration"
 W !
 Q
WBETAAL ;EP - write out BETA allergy
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[8:"*",1:""),"Beta Blocker Allergy?  "
 I X="" W "No, None Recorded" Q
 W !?4,X
 Q
 ;
WLASTBB ;EP write out beta blocker status
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Beta Blocker Rx Status?  "
 I '$D(X) W "No Rxs documented"
 K BGPLETXT S BGPLETP("ICL")=0,BGPLETP("LGTH")=70,BGPLETP("NRQ")=X,BGPLETP("TXT")="",BGPLEC=0
 D GETTXT^BGP9CPU4
 S BGPZZ=0 F  S BGPZZ=$O(BGPLETXT(BGPZZ)) Q:BGPZZ'=+BGPZZ!(BGPQUIT)  D
 .D:$Y>(BGPIOSL-3) HDR^BGP9CP Q:BGPQUIT  W !?4,BGPLETXT(BGPZZ)
 ;W !?4,X
 I Z]"" W !?4,Z
 ;W !
 Q
WNMIBETA ;EP - write out nmi BETA BLOCKER
 I '$D(BGPDATA) D  Q
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !!?2,"NMI Refusal?  No"
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"NMI Refusal:  Yes"
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX  D
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPDATA(BGPXX)
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 I Z]"" W !?4,Z
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if this was"
 W !,"documented by a physician/APN/PA before it is used to exclude patients"
 W !,"from the denominator."
 Q
WCESSMED ;EP write out CESSATION DATA
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+3)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Smoking Cessation Medication Rx Status?  "
 I '$D(BGPDATA) W "No Rxs documented" Q
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,$$DATE^BGP9UTL($P(BGPDATA(X),U))," ",$P(BGPDATA(X),U,2)
 W !,"NOTE:  Per the CMS Data Abstraction Guidelines, a prescription of a smoking "
 W !,"cessation aid during hospital stay or at discharge meets the numerator "
 W !,"requirements."
 Q
WCESS ;EP write out CESSATION DATA
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Smoking Cessation Advice/Counseling:  "
 I '$D(BGPDATA) W "Nothing recorded"
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX  W !?4,$$DATE^BGP9UTL($P(BGPDATA(BGPXX),U))," ",$P(BGPDATA(BGPXX),U,2)
 ;W !
 Q
WSMOKER ;EP write out smoking data
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Smoking Data:  "
 I '$D(BGPDATA) W "Nothing recorded"
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 ;W !
 Q
WAORTIC ;EP write out DX
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[7:"*",1:""),"Moderate or Severe Aortic Stenosis?  "
 I '$D(BGPDATA) W "No Recorded Dxs"
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 ;W !
 Q
WLASTACE ;EP - write out ace/arb
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"ACEI or ARB Rx Status?  "
 I X="",Z="" W "No Rxs" Q
 W !?4,X
 W !?4,Z
 ;W !
 Q
WNMIACE(X) ;EP - write out nmi ACE/ARB
 I '$D(X) D  Q
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !!?2,"NMI Refusal?  No"
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"NMI Refusal:  Yes"
 NEW Y S Y=0 F  S Y=$O(X(Y)) Q:Y'=+Y  W !?4,X(Y)
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if this was"
 W !,"documented by a physician/APN/PA before it is used to exclude patients"
 W !,"from the denominator."
 Q
WACEALEG ;EP - write out asa allergy
 I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[6:"*",1:""),"ACEI and/or ARB Allergy?  "
 I X="",Z="" W "No, None Recorded" Q
 I X]"" W !?4,"ACEI: Yes ",$P(X,U,2)
 I Z]"" W !?4,"ARB: Yes ",$P(Z,U,2)
 Q
WDXS ;EP write out DX
 NEW X,C S (X,C)=0 F  S X=$O(BGPDX(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+4)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Angioedema, Hyperkalemia, Hypotension, Renal Artery Stenosis, or Worsening"
 W !,"Renal Function/Renal Disease/Dysfunction?  "
 I '$D(BGPDX) W !?4,"None Recorded" Q
 S X=0 F  S X=$O(BGPDX(X)) Q:X'=+X  W !?4,BGPDX(X)
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if this"
 W !,"was documented by a physician/APN/PA before it is used to exclude "
 W !,"patients from the denominator."
 ;W !
 Q
 ;
WLVSD ;EP write out lsvd/cef
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+5)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"LVSD and/or EF: " I '$D(BGPDATA) W "None Recorded" Q
 S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 W !,"NOTE:  The patient's chart still needs to be reviewed to determine if the"
 W !,"LVEF is <40% or the LVS narrative indicates moderate or severe systolic"
 W !,"dysfunction.  Refer to CMS Specification Manual for National Hospital"
 W !,"Quality Measures, Appendix H, Table 1.5 (LVSD Notes Table) for information"
 W !,"on determining if patient meets CMS LVSD criteria."
 Q
 ;
WIVUD ;EP - write out all allergies from problem list
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"ALL Unit Dose/IV Meds during Hospital Stay: ",$$DATE^BGP9UTL($P($P(^AUPNVSIT(BGPVSIT,0),U),"."))," - ",$$DATE^BGP9UTL($P($P(^AUPNVINP(BGPVINP,0),U),"."))
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 .K BGPLETXT S BGPLETP("ICL")=0,BGPLETP("LGTH")=70,BGPLETP("NRQ")=BGPDATA(BGPXX),BGPLETP("TXT")="",BGPLEC=0
 .D GETTXT^BGP9CPU4
 .S BGPZZ=0 F  S BGPZZ=$O(BGPLETXT(BGPZZ)) Q:BGPZZ'=+BGPZZ!(BGPQUIT)  D
 ..D:$Y>(BGPIOSL-3) HDR^BGP9CP Q:BGPQUIT  W !?4,BGPLETXT(BGPZZ)
 ;.I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 ;.W !?4,BGPDATA(BGPXX)
 ;W !
 Q
 ;
WWARRX ;EP - write out all warfarin rxs
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-(C+2)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[4:"*",1:""),"Warfarin/Coumadin Contraindication?:  "
 I '$D(BGPDATA) W "No, None Recorded" Q
 W "Yes" S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 Q
 ;
WASAALEG ;EP - write out asa allergy
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,$S(BGPPEX[3:"*",1:""),"Aspirin Allergy?  "
 I X="" W "No, None Recorded" Q
 W !?4,"Yes ",X
 Q
WALLALG ;EP - write out all allergies from problem list
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"ALL Allergies from Problem List:  "
 ;S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPDATA(BGPXX)
 Q
 ;
WALLALGT ;EP - write out all allergies from allergy tracking
 NEW X,C S (X,C)=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  S C=C+1
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"ALL Allergies from Allergy Tracking:  "
 ;S X=0 F  S X=$O(BGPDATA(X)) Q:X'=+X  W !?4,BGPDATA(X)
 S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !?4,BGPDATA(BGPXX)
 Q
 ;
WLASTAP ;EP - write out last rx
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Other Anti-Platelet Rx Status?  "
 ;I X="" W ""
 I X]"" W !?4,X
 I $D(BGPUD) W !?4,"UNIT DOSE/IV During Hospital Stay: " D
 .S BGPXX=0 F  S BGPXX=$O(BGPUD(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 ..K BGPLETXT S BGPLETP("ICL")=0,BGPLETP("LGTH")=70,BGPLETP("NRQ")=BGPUD(BGPXX),BGPLETP("TXT")="",BGPLEC=0
 ..D GETTXT^BGP9CPU4
 ..S BGPZZ=0 F  S BGPZZ=$O(BGPLETXT(BGPZZ)) Q:BGPZZ'=+BGPZZ!(BGPQUIT)  D
 ...D:$Y>(BGPIOSL-3) HDR^BGP9CP Q:BGPQUIT  W !?6,BGPLETXT(BGPZZ)
 ;W !
 Q
WLASTASP ;EP - write out last rx
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Aspirin Rx Status?  "
 ;I X="" W ""
 I X]"" W !?4,X
 I $D(BGPUD) W !?4,"UNIT DOSE/IV During Hospital Stay: " D
 .S BGPXX=0 F  S BGPXX=$O(BGPUD(BGPXX)) Q:BGPXX'=+BGPXX!(BGPQUIT)  D
 ..K BGPLETXT S BGPLETP("ICL")=0,BGPLETP("LGTH")=70,BGPLETP("NRQ")=BGPUD(BGPXX),BGPLETP("TXT")="",BGPLEC=0
 ..D GETTXT^BGP9CPU4
 ..S BGPZZ=0 F  S BGPZZ=$O(BGPLETXT(BGPZZ)) Q:BGPZZ'=+BGPZZ!(BGPQUIT)  D
 ...D:$Y>(BGPIOSL-3) HDR^BGP9CP Q:BGPQUIT  W !?6,BGPLETXT(BGPZZ)
 ;.S BGPXX=0 F  S BGPXX=$O(BGPUD(BGPXX)) Q:BGPXX'=+BGPXX  D
 ;..I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 ;..W !?6,BGPUD(BGPXX)
 ;S Y=0 F  S Y=$O(BGPUD(Y)) Q:Y'=+Y  W !?6,BGPUD(Y)
 Q
WASPCPT(X) ;EP
 I $G(X)="" Q
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !?4,"CPT: ",X
 Q
WNMIASP ;EP - write out nmi aspirin
 I '$D(BGPDATA) D  Q
 .I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !!?2,"NMI Refusal?  No"
 I $Y>(BGPIOSL-6) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"NMI Refusal:  Yes"
 NEW Y S Y=0 F  S Y=$O(BGPDATA(Y)) Q:Y'=+Y  D
 .S BGPXX=0 F  S BGPXX=$O(BGPDATA(BGPXX)) Q:BGPXX'=+BGPXX  D
 ..I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 ..W !?6,BGPDATA(BGPXX)
 ;W !?4,BGPDATA(Y)
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if this was"
 W !,"documented by a physician/APN/PA before it is used to exclude patients"
 W !,"from the denominator."
 Q
WCOMFORT(X) ;EP - write out comfort message
 I X="" D  Q
 .I $Y>(BGPIOSL-4) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 .W !!?2,"Comfort Measures?  None Recorded."
 I $Y>(BGPIOSL-5) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W !!?2,"Comfort Measures?  ",X
 W !,"NOTE:  The patient's chart needs to be reviewed to determine if"
 W !,"this was documented by a physician/APN/PA before it is used"
 W !,"to exclude patients from the denominator.   "
 Q
 ;
WDOD(V) ;EP - write dod
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 I $$DOD^AUPNPAT(V)]"" D
 .W !!?2,$S(BGPPEX[1!(BGPPEX[5):"*",1:""),"Date of Death: ",$$DATE^BGP9UTL($$DOD^AUPNPAT(V))
 Q
 ;
WDT(V) ;EP - write discharge type at column 3
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,$S(BGPPEX[1!(BGPPEX[5):"*",1:""),"Discharge Type:  ",$$VAL^XBDIQ1(9000010.02,V,.06)
 Q
 ;
WTT(V) ;EP - write transferred to
 I $Y>(BGPIOSL-2) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,"Transferred to:  ",$$VAL^XBDIQ1(9000010.02,V,.09)
 Q
 ;
WPPDPOV(V) ;EP
 I $Y>(BGPIOSL-3) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,"Primary Discharge POV: "_$$PRIMPOV^APCLV(V,"C"),"  ",$$PRIMPOV^APCLV(V,"N")
 Q
 ;
OTHDPOVS(V) ;EP write out other discharge povs
 NEW X,C
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S C=C+1
 .Q
 I $Y>(BGPIOSL-(C+3)) D HDR^BGP9CP Q:BGPQUIT  D L1H^BGP9CP
 W:'$D(BGPNOBA) ! W !?2,"Other Discharge POVs for this visit:",$S(C=0:"  None",1:"")
 S (X,C)=0 F  S X=$O(^AUPNVPOV("AD",BGPVSIT,X)) Q:X'=+X  D
 .Q:'$D(^AUPNVPOV(X,0))
 .Q:$P(^AUPNVPOV(X,0),U,12)="P"
 .S C=C+1
 .S I=$P(^AUPNVPOV(X,0),U),I=$P($$ICDDX^ICDCODE(I),U,2)
 .S N=$$VAL^XBDIQ1(9000010.07,X,.04),N=$$UP^XLFSTR(N)
 .W !?4,I,?11,N
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:80)-$L(X)\2)_X
 ;----------
EOP ;EP - End of page.
 Q:$E(IOST)'="C"
 Q:$D(ZTQUEUED)!'(IOT="TRM")!$D(IO("S"))
 NEW DIR
 K DIRUT,DFOUT,DLOUT,DTOUT,DUOUT
 S DIR(0)="E" D ^DIR
 Q
 ;----------
USR() ;EP - Return name of current user from ^VA(200.
 Q $S($G(DUZ):$S($D(^VA(200,DUZ,0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ UNDEFINED OR 0")
 ;----------
