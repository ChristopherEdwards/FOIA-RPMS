BMCALERT ; IHS/PHXAO/TMJ - RCIS ALERTS ; 02 Mar 2009  2:48 PM
 ;;4.0;REFERRED CARE INFO SYSTEM;**3,4,5**;JAN 09, 2006
 ;BMC*4.0*3 9.20.2007 IHS.OIT.FCJ ADDED NEW ALERT FOR PRIM PROV AND REF PHY
 ;BMC*4.0*4 11.12.2008 IHS.OIT.FCJ FIXED ALERT TO TRANSFER TO EHR
 ;BMC*4.0*5 3.4.2009 IHS.OIT.FCJ ADDED TXT AND COM SECTION TO RNT FOR ALERT
 ;
EN1 ; EP - POSSIBLE HIGH COST ALERT (ROLL AND SCROLL)
 Q:$P(^BMCREF(BMCRIEN,0),U,4)="O"  ;         quit if type=other
 W !,"You are entering a diagnosis that indicates this may be a high cost case.",!,"You may want to carefully explore alternative resources and alert your case",!,"manager."
 Q
 ;
EN2 ; EP - COSMETIC PROCEDURE ALERT (ROLL AND SCROLL)
 Q:$P(^BMCREF(BMCRIEN,0),U,4)="O"  ;         quit if type=other
 W !,"You are entering a cosmetic procedure that may require CMO approval."
 Q
 ;
EN3 ;EP - POSSIBLE HIGH COST PROCEDURE ALERT (ROLL AND SCROLL)
 ;
 Q:$P(^BMCREF(BMCRIEN,0),U,4)="O"  ;         quit if type=other
 W !,"You are entering a procedure that indicates this may be a high cost case.",!,"You may want to carefully explore alternative resources and alert your case",!,"manager."
 Q
 ;
EN4 ;EP - EXPERIMENTAL CPT PROCEDURE ALERT (ROLL AND SCROLL)
 ;
 ;
 Q:$P(^BMCREF(BMCRIEN,0),U,4)="O"  ;         quit if type=other
 W !,"You are entering a procedure that indicates this may be a Experimental",!,"Procedure.  If so, CHS funds cannot be used to pay for this procedure."
 Q
 ;
EN5 ;EP - 3RD PARTY LIABILITY ALERT (ROLL AND SCROLL)
 ;
 Q:$P(^BMCREF(BMCRIEN,0),U,4)="O"  ;         quit if type=other
 W !,"You are entering a diagnosis that indicates this may involve third party",!,"liability.  You may want to investigate this possibility in order to recover",!,"costs."
 Q
PALRT1 ;EP-ALERT FOR PHYS
 ;BMC*4.0*3 9.20.2007 IHS.OIT.FCJ ADDED NEW ALERT FOR PRIM PROV AND REF PHY
 ;
 W !!,"Processing alert for Physician(s)." H 1
 NEW XQAID,XQAMSG,XQAROU,XQADATA,XQAARCH,XQAFLG,XQAGUID,XQAOPT,XQASUPV,XQASURO,XQATEXT,XQALERR
 ;BMC*4.0*4 7/9/2008 IHS/OIT/FCJ Changed Package ID To "OR" and 27 which is service consult/request in the OE/RR notification file- Required for EHR
 ;S XQAID="BMC REFERRED CARE INFO SYSTEM"
 S XQAID="OR,"_BMCDFN_",46"
 S XQAMSG="Referral "_BMCRHDR_": "_BMCREC("PAT NAME")
 S XQAROU="PALRT2^BMCALERT"
 S XQADATA=BMCRIEN
 ;SETS PRIM PROV AND REF PROV TO AUTO SEND MESSAGE TO
 I '$D(XQA) D
 .I $P($G(^BMCPARM(DUZ(2),4100)),U,10)="Y" S BMCPPRV=$P(^AUPNPAT(BMCDFN,0),U,14) I BMCPPRV'="" S XQA(BMCPPRV)=""
 .I $P($G(^BMCPARM(DUZ(2),4100)),U,9)="Y" S BMCRPRV=$P(^BMCREF(BMCRIEN,0),U,6) I BMCRPRV'="" S XQA(BMCRPRV)=""
 I '$G(BMCPPRV) W !,"Primary Care Provider is not definned.",?45,"***ALERT WAS NOT SENT***"
 I '$G(BMCRPRV) W !,"Referring Provider is not definned.",?45,"***ALERT WAS NOT SENT***"
 Q:'$G(BMCPPRV)&'$G(BMCRPRV)
 D TXT S XQATEXT="BMCTXT" ;BMC*4.0*5 3.4.2009 IHS.OIT.FCJ NEW LINE
 D SETUP^XQALERT
 K XQA,XQAID,XQAMSG,XQAROU,XQADATA,XQAARCH,XQAFLG,XQAGUID,XQAOPT,XQASUPV,XQASURO,XQATEXT,XQALERR
 Q
PALRT2 ;ALERT TO DISPLAY
 S BMCRIEN=XQADATA
 S BMCREC=^BMCREF(BMCRIEN,0)
 D EN^BMCAL1
 Q
TXT ;BMC*4.0*5 3.4.2009 IHS.OIT.FCJ ADDED SECTION
 S BMCTXT(1)="Patient: "_$E($P(^DPT($P(^BMCREF(BMCRIEN,0),U,3),0),U),1,25)_"      Chart #: "_$S($D(^AUPNPAT($P(^BMCREF(BMCRIEN,0),U,3),41,DUZ(2),0)):$P(^(0),U,2),1:"None")
 S BMCTXT(2)="Date Referral Initiated: "_$$VAL^XBDIQ1(90001,BMCRIEN,.01)
 S BMCTXT(3)="Requesting Provider: "_$$VAL^XBDIQ1(90001,BMCRIEN,.06)
 S BMCTXT(4)="Purpose of Referral: "_$$VAL^XBDIQ1(90001,BMCRIEN,1201)
 S BMCTXT(5)="Referred To: "_$$TOFAC^BMC(BMCRIEN)
 S BMCTST(6)="Notes to Scheduler: ",BMCV=$$VAL^XBDIQ1(90001,BMCRIEN,1301)
 S BMCSTR="Priority: "_$$VAL^XBDIQ1(90001,BMCRIEN,.32)
 S BMCTXT(7)=BMCSTR_"  Ref Type: "_$$VAL^XBDIQ1(90001,BMCRIEN,.04)_"     Date of Service: "_$$AVDOS^BMCRLU(BMCRIEN,"C")
 S BMCT=7 D COM
 Q
COM ;BO COMMENTS;BMC*4.0*5 3.4.2009 IHS.OIT.FCJ ADDED SECTION
 Q:'$D(^BMCCOM("AD",BMCRIEN))
 S BMCCDFN="" F  S BMCCDFN=$O(^BMCCOM("AD",BMCRIEN,BMCCDFN)) Q:BMCCDFN'?1N.N  D
 .Q:$P(^BMCCOM(BMCCDFN,0),U,5)'="B"
 .S BMCT=BMCT+1,BMCTXT(BMCT)="",BMCT=BMCT+1
 .S BMCTXT(BMCT)="COMMENT DATE: "_$$VAL^XBDIQ1(90001.03,BMCCDFN,.01)_"    REVIEWER: "_$$VAL^XBDIQ1(90001.03,BMCCDFN,.04)
 .S F=0 F  S F=$O(^BMCCOM(BMCCDFN,1,F)) Q:F'?1N.N  D
 ..S BMCT=BMCT+1
 ..S BMCTXT(BMCT)=^BMCCOM(BMCCDFN,1,F,0)
 K F,BMCT Q
