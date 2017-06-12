APCHPWH9 ; IHS/CMI/LAB - PCC HEALTH SUMMARY - MAIN DRIVER PART 2 ;  
 ;;2.0;IHS PCC SUITE;**6,7,10,11,17**;MAY 14, 2009;Build 18
 ;
ADOLBP ;EP - BP component
 D SUBHEAD^APCHPWHU
 NEW APCHBP,APCHDM,APCHCKD,APCHST,APCHDT,APCHAGE
 S APCHAGE=$$AGE^AUPNPAT(APCHSDFN,DT)
 D S^APCHPWH1("BLOOD PRESSURE - Blood Pressure is a good measure of health.")
 D S^APCHPWH1(" ")
 S APCHBP=$$LASTBP^APCHPWH2(APCHSDFN)
 S APCHST=$P($P(APCHBP,U,3),"/",1)
 S APCHDT=$P($P(APCHBP,U,3),"/",2)
 I APCHBP="" D  Q
 .I APCHAGE<13 D S^APCHPWH1("No recent blood pressure on file.  We recommend that you have your child's"),S^APCHPWH1("blood pressure checked at your next visit.") D S^APCHPWH1(" ") Q
 .D S^APCHPWH1("No recent blood pressure on file.  We recommend that you have your blood"),S^APCHPWH1("pressure checked at your next visit.") D S^APCHPWH1(" ") Q
 I APCHBP]"" D
 .I APCHAGE<13 D S^APCHPWH1("Your child's last blood pressure was "_$P(APCHBP,U,3)_" on "_$$FMTE^XLFDT($P(APCHBP,U,1))_".") Q
 .D S^APCHPWH1("Your last blood pressure was "_$P(APCHBP,U,3)_" on "_$$FMTE^XLFDT($P(APCHBP,U,1))_".") Q
 Q
 ;
RECENTBP ;EP
 S APCHAGE=$$AGE^AUPNPAT(APCHSDFN,DT)
 D SUBHEAD^APCHPWHU
 NEW APCHHT,APCHWT,X,E
 D S^APCHPWH1("Here are "_$S(APCHAGE<13:"your child's",1:"your")_" most recent blood pressures.")
 D S^APCHPWH1(" ")
 K APCHWT
 S X=APCHSDFN_"^LAST 3 MEAS BP;DURING "_$$DOB^AUPNPAT(APCHSDFN)_"-"_DT S E=$$START1^APCLDF(X,"APCHWT(")
 I '$D(APCHWT) D S^APCHPWH1("No blood pressure values have been recorded.  We recommend that you have"),S^APCHPWH1($S(APCHAGE<13:"your child's",1:"your")_" blood pressure rechecked at your next visit.") Q
 S E="",$E(E,5)="Date",$E(E,18)="Blood Pressure" D S^APCHPWH1(E)
 S X=0 F  S X=$O(APCHWT(X)) Q:X'=+X  D
 .S E=""
 .S $E(E,2)=$$FMTE^XLFDT($P(APCHWT(X),U,1))
 .S $E(E,20)=$P(APCHWT(X),U,2)
 .D S^APCHPWH1(E)
 Q
 ;
DIABSCRN ;EP
 NEW APCHAGE,APCHBMI,APCHGLUC
 S APCHAGE=$$AGE^AUPNPAT(APCHSDFN,DT)
 Q:APCHAGE<10  ;no one under 10
 Q:$$DMDX^APCHPWH2(APCHSDFN)  ;don't display this component if the patient has diabetes
 S APCHBMI=$P($$BMI^APCLSIL2(APCHSDFN,DT),U)
 Q:APCHBMI=""   ;can't tell if they are overweight or obese so skip this component
 Q:'$$OW(APCHSDFN,APCHBMI,APCHAGE)  ;not overweight or obese
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("DIABETES SCREENING")
 D S^APCHPWH1(" ")
 S APCHGLUC=$$LASTGLUC(APCHSDFN,$$FMADD^XLFDT(DT,-(2*365)))  ;get last glucose value in past 2 years
 I APCHAGE<13 D  Q
 .I APCHGLUC="" D  Q
 ..D WRITET^APCHPWHU("DIAB SCRN - 10-13 NO GLUCOSE") Q
 .I APCHGLUC]"" D  Q
 ..D WRITET^APCHPWHU("DIAB SCRN - 10-13 HAS GLUCOSE")
 ..D S^APCHPWH1("Your child's last blood sugar was "_$P(APCHGLUC,U,3)_" on "_$$FMTE^XLFDT($P(APCHGLUC,U,1))_".")
 I APCHGLUC="" D  Q
 .D WRITET^APCHPWHU("DIAB SCRN - >13 NO GLUCOSE") Q
 I APCHGLUC]"" D  Q
 .D WRITET^APCHPWHU("DIAB SCRN - >13 HAS GLUCOSE")
 .D S^APCHPWH1("Your last blood sugar was "_$P(APCHGLUC,U,3)_" on "_$$FMTE^XLFDT($P(APCHGLUC,U,1))_".")
 Q
OW(P,BMI,A) ;EP obese or overweight, really just overweight
 NEW S,R
 I $G(BMI)="" Q ""
 S S=$P(^DPT(P,0),U,2)
 I S="" Q ""
 I S="U" Q ""
 S R=0,R=$O(^APCLBMI("H",S,A,R))
 I 'R S R=$O(^APCLBMI("H",S,A)) I R S R=$O(^APCLBMI("H",S,R,""))
 I 'R Q ""
 I BMI>$P(^APCLBMI(R,0),U,7)!(BMI<$P(^APCLBMI(R,0),U,6)) Q ""
 I BMI'<$P(^APCLBMI(R,0),U,4) Q 1
 Q ""
LASTGLUC(P,BD,ED,FORM) ;PEP - date of last GLUCOSE SCREENING
 ;  Return the last recorded GLUCOSE SCREENING:
 ;   - V Lab:  DM AUDIT GLUCOSE TESTS TAX, APCH SCREENING GLUCOSE LOINC
 I $G(P)="" Q ""
 I $G(BD)="" S BD=$$DOB^AUPNPAT(P)
 I $G(ED)="" S ED=DT
 I $G(FORM)="" S FORM="D"
 NEW APCHVAL,APCHX,R,X,Y,V,E,T,G,APCHY,APCHF
 S APCHVAL=$$LASTLAB^APCLAPIU(P,BD,ED,,$O(^ATXLAB("B","DM AUDIT GLUCOSE TESTS TAX",0)),,$O(^ATXAX("B","APCH SCREENING GLUCOSE LOINC",0)),"A")
 I FORM="D" Q $P(APCHVAL,U)
 Q APCHVAL
 ;
PROBLIST ;EP
 NEW APCHPROB,APCHX,APCHN,APCHY,APCHT,APCHI,APCHZ,S,X,APCHC,APCHS,APCHD
 K APCHPROB
 D GETPROB
 I '$D(APCHPROB) Q  ;no active problems
 D SUBHEAD^APCHPWHU
 ;D S^APCHPWH1("HEALTH PROBLEMS")
 D S^APCHPWH1("Your Health Problems (Problem List)")
 D S^APCHPWH1("A problem list is a listing of all of the medical conditions that you ")
 D S^APCHPWH1("have that don't go away quickly.")
 D S^APCHPWH1(" ")
 ;S X="Disease/Condition",$E(X,66)="Date of Onset"
 ;D S^APCHPWH1(X)
 S APCHN=0 F  S APCHN=$O(APCHPROB(APCHN)) Q:APCHN'=+APCHN  D
 .S APCHY=$$VALI^XBDIQ1(9000011,APCHN,.01)
 .S APCHY=$$ICDDX^ICDEX(APCHY)
 .S APCHT=$P(APCHY,U,4)
 .S APCHI=$P(APCHY,U,2)
 .S APCHD=$$VAL^XBDIQ1(9000011,APCHN,.13) I APCHD]"" S APCHD="Onset: "_APCHD
 .K ^UTILITY($J,"W") S X=$$VAL^XBDIQ1(9000011,APCHN,.05),DIWL=0,DIWR=48,DIWF="|" D ^DIWP
 .S X=" "_APCHI,$E(X,11)=$G(^UTILITY($J,"W",0,1,0)),$E(X,60)=APCHD D S^APCHPWH1(X)
 .F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,11)=^UTILITY($J,"W",0,F,0) D S^APCHPWH1(X)
 .K DIWL,DIWR,DIWF,^UTILITY($J,"W")
 .S APCHZ=0,APCHC=0 F  S APCHZ=$O(^AUPNPROB(APCHN,11,APCHZ)) Q:APCHZ'=+APCHZ  D
 ..S APCHS=0 F  S APCHS=$O(^AUPNPROB(APCHN,11,APCHZ,11,APCHS)) Q:APCHS'=+APCHS  D
 ...S X=$P(^AUPNPROB(APCHN,11,APCHZ,11,APCHS,0),U,3)
 ...Q:X=""
 ...S APCHC=APCHC+1
 ...K ^UTILITY($J,"W") S DIWL=0,DIWR=65 D ^DIWP
 ...F F=1:1:$G(^UTILITY($J,"W",0)) S X=$S(APCHC=1:"  Notes:  ",1:""),$E(X,$S(F=1:10,1:13))=$S(F=1:" - ",1:"")_$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 ...K ^UTILITY($J,"W")
 Q
GETPROB ;
 NEW X,Y
 S X=0 F  S X=$O(^AUPNPROB("AC",APCHSDFN,X)) Q:X'=+X  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .Q:$$VAL^XBDIQ1(9000011,X,.01)=".9999"
 .Q:$$VAL^XBDIQ1(9000011,X,.01)="ZZZ.999"
 .S APCHPROB(X)=""
 .Q
 Q
FAMHX ;EP
 NEW APCHPROB,APCHX,APCHN,APCHY,APCHT,APCHI,APCHZ,S,X,APCHC,APCHS,APCHD,APCHR
 K APCHPROB
 D GETFHX
 ;I '$D(APCHPROB) Q  ;no active problems
 D SUBHEAD^APCHPWHU
 ;D S^APCHPWH1("HEALTH PROBLEMS")
 D S^APCHPWH1("FAMILY HEALTH HISTORY")
 D S^APCHPWH1("Family health history is the gathering of information about you and ")
 D S^APCHPWH1("your family.  Knowing about your family's health history is important")
 D S^APCHPWH1("to staying healthy.")
 D S^APCHPWH1(" ")
 ;S X="",$E(X,66)="Date of Onset"
 ;D S^APCHPWH1(X)
 S APCHN=0 F  S APCHN=$O(APCHPROB(APCHN)) Q:APCHN'=+APCHN  D
 .S APCHY=$$VALI^XBDIQ1(9000014,APCHN,.01)
 .S APCHY=$$ICDDX^ICDEX(APCHY)
 .S APCHT=$P(APCHY,U,4)
 .S APCHI=$P(APCHY,U,2)
 .Q:APCHI=".9999"
 .Q:APCHI="ZZZ.999"
 .S APCHD=$$VAL^XBDIQ1(9000014,APCHN,.05) S:APCHD]"" APCHD=APCHD_" yrs" I $P(^AUPNFH(APCHN,0),U,15) S APCHD=APCHD_" (APPROXIMATE)"
 .S APCHR=$$VALI^XBDIQ1(9000014,APCHN,.09)
 .I 'APCHR S APCHRD="RELATION UNKNOWN",APCHS="UNKNOWN" G FAMHX1
 .S APCHRD=$$VAL^XBDIQ1(9000014.1,APCHR,.01),APCHRD=$E(APCHRD,1,20)
 .S APCHS=$$VAL^XBDIQ1(9000014.1,APCHR,.04) I $E(APCHS)="P" S APCHS="UNKNOWN"
FAMHX1 .K ^UTILITY($J,"W") S X=APCHT,DIWL=0,DIWR=25 D ^DIWP
 .S X=APCHRD,$E(X,23)=APCHS,$E(X,33)=$G(^UTILITY($J,"W",0,1,0)),$E(X,60)=APCHD D S^APCHPWH1(X)
 .F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,33)=^UTILITY($J,"W",0,F,0) D S^APCHPWH1(X)
 D S^APCHPWH1(" ")
 D S^APCHPWH1("You can use the online Family Health History tool to make a family health")
 D S^APCHPWH1("history by going to: https://familyhistory.hhs.gov/.")
 Q
GETFHX ;
 NEW X,Y
 S X=0 F  S X=$O(^AUPNFH("AC",APCHSDFN,X)) Q:X'=+X  D
 .Q:'$D(^AUPNFH(X,0))
 .S APCHPROB(X)=""
 .Q
 Q
APPTS ;EP
 NEW APCHAPPT,X,Y,APCHCLN,APCHSDAT,APCHSVDT,APCHX,APCHSAM,APCHSVT,APCHSN,F,APCHAGE
 ;gather up all appts in APCHAPPT
 S APCHSDAT=0,APCHSVDT=DT-.01 F  S APCHSVDT=$O(^DPT(APCHSDFN,"S",APCHSVDT)) Q:'APCHSVDT  D
 .S APCHSN=^DPT(APCHSDFN,"S",APCHSVDT,0)
 .Q:"CP"[$E($P(APCHSN,U,2)_" ")  ;SKIP CANCELLED
 .Q:$P(APCHSN,U,7)=4  ;skip unscheduled
 .S N=$P(APCHSN,U,1)
 .Q:$P($G(^BSDSC(N,0)),U,12)="C"  ;CLINIC SERVICE CATEGORY IS CHART REVIEW SO NOT A PATIENT APPT
 .S APCHAPPT(APCHSVDT)=""
 I '$D(APCHAPPT) Q  ;no appointments so skip component
 D SUBHEAD^APCHPWHU
 ;D S^APCHPWH1("YOUR APPOINTMENTS")
 ;D S^APCHPWH1(" ")
 S APCHAGE=$$AGE^AUPNPAT(APCHSDFN,DT)
 I APCHAGE<13 D
 .D S^APCHPWH1("APPOINTMENTS:  Your child is scheduled to come back for another appointment.")
 .D S^APCHPWH1("Please call us at "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.13)_" if you have any questions or need to "),S^APCHPWH1("reschedule an appointment.")
 I APCHAGE>12 D
 .D S^APCHPWH1("APPOINTMENTS:  You are scheduled to come back for another appointment.")
 .D S^APCHPWH1("Please call us at "_$$VAL^XBDIQ1(9999999.06,DUZ(2),.13)_" if you have any questions or need to "),S^APCHPWH1("reschedule an appointment.")
 S APCHSVDT=0 F  S APCHSVDT=$O(APCHAPPT(APCHSVDT)) Q:APCHSVDT=""  D APPTS1
 Q
APPTS1 ;
 S APCHSN=^DPT(APCHSDFN,"S",APCHSVDT,0)
 S APCHSAM="am"
 S APCHSVT=$E($P(APCHSVDT,".",2)_"000",1,4) S:APCHSVT>1159 APCHSAM="pm" S:APCHSVT>1300 APCHSVT=APCHSVT-1200 S:$L(APCHSVT)=3 APCHSVT=" "_APCHSVT S:$E(APCHSVT)="0" APCHSVT=" "_$E(APCHSVT,2,4) S APCHSVT=$E(APCHSVT,1,2)_":"_$E(APCHSVT,3,4)
 S APCHSVT=APCHSVT_APCHSAM
 S APCHSCP=+APCHSN,APCHSCN=$P($G(^SC(APCHSCP,0)),U,1) Q:APCHSCN=""
 ;get name of facility where clinic meets
 D S^APCHPWH1(" ")
 S F=$P(^SC(APCHSCP,0),U,4)
 I F S F=$S($P($G(^APCCCTRL(F,0)),U,13):$P(^APCCCTRL(F,0),U,13),1:$P(^DIC(4,F,0),U,1))
 S X=$$FMTE^XLFDT($P(APCHSVDT,".")),$E(X,14)=APCHSVT,$E(X,24)=APCHSCN I F]"" S X=X_"  ("_F_")"
 D S^APCHPWH1(X)
 ;now display provider
 S P=$$PRV(APCHSCP)
 I P]"" D S^APCHPWH1("Provider: "_$P(P,U,2))
 Q
PRV(CLINIC) ;EP; -- returns default provider for clinic
 ; Y returns as ien^provider name
 NEW X,Y
 S Y=""
 S X=0 F  S X=$O(^SC(CLINIC,"PR",X)) Q:'X  D
 . I $P($G(^SC(CLINIC,"PR",X,0)),U,2)=1 S Y=+^SC(CLINIC,"PR",X,0)
 I $G(Y) S Y=Y_U_$$GET1^DIQ(200,Y,.01)
 ;I '$G(Y) S Y="0^UNAFFILIATED CLINICS"
 Q $G(Y)
PEDSCRN ;EP
 NEW APCHAGE,APCHAM,APCHLVAE,APCHDMPV,APCHLDE
 S APCHAGE=$$AGE^AUPNPAT(APCHSDFN,DT)
 Q:APCHAGE>18
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("PEDIATRIC SCREENING")
 D S^APCHPWH1(" ")
 ;EYE EXAM
 S APCHSAM=$$AGE^APCLSILU(APCHSDFN,2,DT)  ;age in months
 I APCHSAM<15 G DENTAL
 ;
 S APCHLVAE=$$LASTVAE^APCLAPI1(APCHSDFN,$$FMADD^XLFDT(DT,-365),DT)
 I APCHLVAE="" D
 .D S^APCHPWH1("We recommend that your child have an eye exam.  Be sure to discuss")
 .D S^APCHPWH1("this with your child's provider.")
 I APCHLVAE]"" D
 .D S^APCHPWH1("Your child's last vision test was performed on "_$$FMTE^XLFDT($P(APCHLVAE,U))_".")
DENTAL ;
 ;how many dm pov's?  if 2 or more go to age 18, if not then go to age 11
 S APCHDMPV=$$DMPV(APCHSDFN)
 I 'APCHDMPV Q:APCHAGE<12
 S APCHLDE=$$LASTDENT^APCLAPI2(APCHSDFN)
 I APCHLDE="" D
 .D S^APCHPWH1("We recommend that your child have a dental checkup.  Be sure to discuss")
 .D S^APCHPWH1("this with your child's provider.")
 I APCHLDE]"" D
 .D S^APCHPWH1("Your child's last dental checkup was performed on "_$$FMTE^XLFDT($P(APCHLDE,U))_".")
 Q
DMPV(P) ;EP - how many dm povs?
 NEW X,E,APCHX
 S X=P_"^LAST 2 DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,"APCHX(")
 I '$D(APCHX(2)) Q 0
 Q 1
ANTICOAG ;EP
 NEW APCHGOAL,APCHV,APCHD,G
 Q:'$$ACTWARF^APCHSTP1(APCHSDFN,$$FMADD^XLFDT(DT,-45),DT)  ;not a candidate for this component, not active prescription for warfarin
 D SUBHEAD^APCHPWHU
 D S^APCHPWH1("ANTICOAGULATION THERAPY - You are taking Warfarin to prevent dangerous types")
 D S^APCHPWH1("of blood clots.")
 D S^APCHPWH1(" ")
 S APCHGOAL=$$MRGOAL^APCHSACG(APCHSDFN)
 I APCHGOAL="" D
 .D S^APCHPWH1("Your INR Target is not on file.  We recommend that you ask your health")
 .D S^APCHPWH1("care provider about your INR Target at your next visit.")
 I APCHGOAL]"" D
 .S G=$P(APCHGOAL,U,2)
 .S G=$P(G,"-")_"and"_$P(G,"-",2)
 .D S^APCHPWH1("Your INR Target is between "_G_" documented on "_$$FMTE^XLFDT($P(APCHGOAL,U)))
 K APCHV
 S APCHV="APCHV"
 D ALLLAB^APCLAPIU(APCHSDFN,$$FMADD^XLFDT(DT,-(3*365)),DT,$O(^ATXLAB("B","BJPC INR LAB TESTS",0)),$O(^ATXAX("B","BJPC INR LAB LOINCS",0)),"INR",.APCHV)
 ;reorder by date
 K APCHD
 S G=0 F  S G=$O(APCHV(G)) Q:G'=+G  S APCHD(9999999-$P(APCHV(G),U,1),$P(APCHV(G),U,4))=APCHV(G)
 I '$D(APCHD) D  I 1
 .D S^APCHPWH1("Your last 3 INR results were:",1)
 .D S^APCHPWH1("  None Documented.  We recommend that you ask your health care"),S^APCHPWH1("provider about your INR results.")
 E  D
 .S G=0,C=0 F  S G=$O(APCHD(G)) Q:G'=+G!(C>2)  D
 ..S X=0 F  S X=$O(APCHD(G,X)) Q:X'=+X!(C>2)  D
 ...S C=C+1 D S^APCHPWH1($S(C=1:"Your last 3 INR results were: ",1:"")_$P(APCHD(G,X),U,3)_"  on "_$$FMTE^XLFDT($P(APCHD(G,X),U,1)),$S(C=1:1,1:0),0,$S(C=1:0,1:30))
 K APCHMEDS
 D GETMEDS^APCHSMU1(DFN,$$FMADD^XLFDT(DT,-160),DT,"BGP CMS WARFARIN MEDS",,,"WARFARIN",.APCHMEDS)
 ;REORDER BY DATE
 S X=0 F  S X=$O(APCHMEDS(X)) Q:X'=+X  S APCHMEDD(9999999-$P(APCHMEDS(X),U,1),X)=APCHMEDS(X)
 S G=$O(APCHMEDD(0)),H=$O(APCHMEDD(G,0))
 I G,H S G=APCHMEDD(G,H) D
 .D S^APCHPWH1("Your most recent medication to prevent blood clots is:")
 .D S^APCHPWH1("      "_$P(G,U,2)_"    "_$$FMTE^XLFDT($P(G,U,1)))
 .;sig
 .K ^UTILITY($J,"W") S X=$$VAL^XBDIQ1(9000010.14,$P(G,U,4),.05),DIWL=0,DIWR=58 D ^DIWP
 .S X="",$E(X,7)="Directions: "_$S($L($G(^UTILITY($J,"W",0,1,0)))>1:$G(^UTILITY($J,"W",0,1,0)),$L($G(^UTILITY($J,"W",0,1,0)))=1:"No directions on file",1:" ") D S^APCHPWH1(X)
 .I $G(^UTILITY($J,"W",0))>1 F F=2:1:$G(^UTILITY($J,"W",0)) S X="",$E(X,19)=$G(^UTILITY($J,"W",0,F,0)) D S^APCHPWH1(X)
 .K ^UTILITY($J,"W")
 ;Any appt after $$NOW that has a clinic stop of D1?  if so, display it, if not display nothing
 K APCHMEDS,APCHMEDD
 NEW APCHSDAT,APCHSVDT,APCHSN,APCHSD1
 S APCHSD1=""  ;will contain appt if one found
 S APCHSDAT=0,APCHSVDT=$$NOW^XLFDT() F  S APCHSVDT=$O(^DPT(APCHSDFN,"S",APCHSVDT)) Q:'APCHSVDT!(APCHSD1)  D ONEVIS
 Q
 ;
ONEVIS S APCHSN=^DPT(APCHSDFN,"S",APCHSVDT,0)
 Q:"CP"[$E($P(APCHSN,U,2)_" ")
 Q:$P(APCHSN,U,7)=4  ;skip unscheduled
 S C=$P(APCHSN,U,1)
 Q:C=""
 S C=$P($G(^SC(C,0)),U,7)
 Q:C=""
 S C=$P($G(^DIC(40.7,C,0)),U,2)
 I C'="D1" Q  ;not anticoag clinic
 S APCHSD1=1
 S APCHSAM="am"
 S Y=APCHSVDT\1 S Y=$$FMTE^XLFDT(Y) S APCHSDAT=Y  ;,APCHSNDM=APCHSNDM-1
 S APCHSVT=$E($P(APCHSVDT,".",2)_"000",1,4) S:APCHSVT>1159 APCHSAM="pm" S:APCHSVT>1300 APCHSVT=APCHSVT-1200 S:$L(APCHSVT)=3 APCHSVT=" "_APCHSVT S:$E(APCHSVT)="0" APCHSVT=" "_$E(APCHSVT,2,4) S APCHSVT=$E(APCHSVT,1,2)_":"_$E(APCHSVT,3,4)
 D S^APCHPWH1(" ")
 D S^APCHPWH1("Your next anticoagulation appointment is on "_APCHSDAT_" "_APCHSVT_APCHSAM)
 Q
