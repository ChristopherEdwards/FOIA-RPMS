APCHPST1 ; IHS/CMI/LAB - Patient Health Summary - Post Visit ;
 ;;2.0;IHS PCC SUITE;**5,7,11**;MAY 14, 2009;Build 58
 ;
 ;
 ;
EP(APCHSDFN) ;PEP - PASS DFN get back array of patient care summary
 ;at this point you are stuck with ^TMP("APCHPHS",$J,"PHS"
 K ^TMP("APCHPHS",$J,"PHS")
 S ^TMP("APCHPHS",$J,"PHS",0)=0
 D SETARRAY
 Q
SETARRAY ;set up array containing dm care summary
 ;CHECK TO SEE IF START1^APCLDF EXISTS
 S X="APCLDF" X ^%ZOSF("TEST") I '$T Q
 S X="PATIENT HEALTH SUMMARY                 Report Date:  "_$$FMTE^XLFDT(DT) D S(X)
 S X=$P($P(^DPT(APCHSDFN,0),U),",",2)_" "_$P($P(^DPT(APCHSDFN,0),U),",")_"   HRN:  "_$$HRN^AUPNPAT(APCHSDFN,DUZ(2)),$E(X,50)=$S($P(^APCCCTRL(DUZ(2),0),U,13)]"":$P(^APCCCTRL(DUZ(2),0),U,13),1:$P(^DIC(4,DUZ(2),0),U)) D S(X,2)
 I $G(APCDVSIT)]"",$D(^AUPNVSIT("AC",APCHSDFN,APCDVSIT)) S APCHPROV=$$PRIMPROV^APCLV(APCDVSIT)
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.111),$E(X,50)=$S($G(APCHPROV)]"":APCHPROV,1:$$VAL^XBDIQ1(9000001,APCHSDFN,.14)) D S(X)  ;GARY - ADD CHECK FOR CURRENT VISIT PROVIDER
 S X=$$VAL^XBDIQ1(2,APCHSDFN,.114)_$S($$VAL^XBDIQ1(2,APCHSDFN,.114)]"":",  ",1:" ")_$$VAL^XBDIQ1(2,APCHSDFN,.115)_"   "_$$VAL^XBDIQ1(2,APCHSDFN,.116),Y=$P(^AUTTLOC(DUZ(2),0),U,11),$E(X,50)=Y D S(X)
 S X=$$FMTE^XLFDT(DT) D S(X)
 S X="Hello "_$S($$SEX^AUPNPAT(APCHSDFN)="M":"Mr. ",1:"Ms. ")_$E($P($P(^DPT(APCHSDFN,0),U),","))_$$LOW^XLFSTR($E($P($P(^DPT(APCHSDFN,0),U),","),2,99))_","  D S(X,1)
 S X="Thank you for visiting with us!  Here's some information about your visit." D S(X,1)
 S X="When you have any questions, contact your health care provider or write them" D S(X)
 S X="down and ask them at your next visit." D S(X)
 ;
MEDS ; 
 D EP^APCHPST2  ;meds/ allergies/ measurements
CKDP ;
 ;does pt have chronic kidney disease?
 D CKD
 I $G(APCHX("BP"))]"" S APCHHBP=0 D
 .I $G(APCHDBP)<80,$G(APCHSBP)<140 Q
 .I $G(APCHDBP)>90!($G(APCHSBP)>140) S APCHHBP=1 Q
 .I $$DMDX(APCHSDFN)="Yes",$G(APCHDBP)>80!($G(APCHSBP)>130) S APCHHBP=1
 .I $G(APCHCKD)=1,$G(APCHDBP)>80!($G(APCHSBP)>130) S APCHHBP=1
 I $G(APCHHBP)=0 S X="",$E(X,5)="Your blood pressure is good.  That's great news!" D S(X)
 I $G(APCHHBP)=1 D
 .S X="",$E(X,5)="Your blood pressure is too high. Easy ways to make it better are" D S(X)
 .S X="",$E(X,5)="eating healthy foods and walking or getting more physical activity." D S(X)
 .S X="",$E(X,5)="If you take medicine to lower your blood pressure, be sure to take" D S(X)
 .S X="",$E(X,5)="it every day." D S(X)
 ;
LABTESTS ;
 ;S X="Lab tests can help measure health and some check to make sure that your" D S(X,1)
 ;S X="medicines are working right." D S(X)
 ;diabetes
 S APCHLHD=""
 I $$DMDX(APCHSDFN)="Yes" S T=$O(^ATXLAB("B","DM AUDIT HGB A1C TAX",0)) I $G(T)]"" S APCHLA1V=$$LAB(APCHSDFN,T),APCHLA1D=$P($G(APCHLA1V),"|||",2),APCHLA1V=$P($G(APCHLA1V),"|||") D
 .I APCHLA1D="",APCHLHD="" D APCHLHD S APCHLHD=1 S X="",$E(X,5)="You need to have your A1C checked to see if your diabetes is under control." D S(X)
 .I APCHLA1D]"" S X=APCHLA1D D ^%DT S APCHLA1D=Y S X1=DT,X2=APCHLA1D I $$FMDIFF^XLFDT(X1,X2)>180 D
 ..I APCHLHD=1 S X="",$E(X,5)="You need to have your A1C checked to see if your diabetes is under control." D S(X)
 ..I APCHLHD="" D APCHLHD S APCHLHD=1 S X="",$E(X,5)="You need to have your A1C checked to see if your diabetes is under control." D S(X)
 ..S T=$O(^ATXLAB("B","DM AUDIT CHOLESTEROL TAX",0)) I $G(T)]"" D
 ...S APCHLCHV=$$LAB(APCHSDFN,T),APCHLCHD=$P($G(APCHLCHV),"|||",2),APCHLCHV=$P($G(APCHLCHV),"|||") I APCHLCHD]"" S X=APCHLCHD D ^%DT S APCHLCHD=Y S X1=DT,X2=APCHLCHD I $$FMDIFF^XLFDT(X1,X2)>180 D
 ....I APCHLHD=1 S APCHCKCH=1 S X="",$E(X,5)="You need to have your cholesterol checked to prevent heart disease." D S(X)
 ....I APCHLHD="" D APCHLHD S APCHLHD=1 S X="",$E(X,5)="You need to have your cholesterol checked to prevent heart disease." D S(X)
 .Q
 ;cholesterol
 I $G(APCHCKCH)']"",$$AGE^AUPNPAT(APCHSDFN)>18,$$DMDX(APCHSDFN)="No" S T=$O(^ATXLAB("B","DM AUDIT CHOLESTEROL TAX",0)) I $G(T)]"" S APCHLCHV=$$LAB(APCHSDFN,T),APCHLCHD=$P($G(APCHLCHV),"|||",2),APCHLCHV=$P($G(APCHLCHV),"|||") D
 .I APCHLCHD="" D APCHLHD S APCHLHD=1 S X="",$E(X,5)="You need to have your cholesterol checked to prevent heart disease." D S(X)
 .I APCHLCHD]"" S X=APCHLCHD D ^%DT S APCHLCHD=Y S X1=DT,X2=APCHLCHD I $$FMDIFF^XLFDT(X1,X2)>1825 D APCHLHD S APCHLHD=1 S X="",$E(X,5)="You need to have your cholesterol checked to prevent heart disease." D S(X)
 ;
 D GETLABS
 I $D(APCHTST),$G(APCHLHD)=""  D APCHLHD S APCHLHD=1
 I $D(APCHTST) S X="",$E(X,5)="Lab tests ordered today:" D S(X)
 S APCHSLAB=""
 F  S APCHSLAB=$O(APCHTST(APCHSLAB)) Q:$G(APCHSLAB)']""  D
 .S X="",$E(X,10)=APCHSLAB D S(X)
 .I $O(APCHTST(APCHSLAB,0)) S APCHCTR=0 F  S APCHCTR=$O(APCHTST(APCHSLAB,APCHCTR)) Q:'APCHCTR  D
 ..S X="",$E(X,12)=$P(APCHTST(APCHSLAB,APCHCTR),U) D S(X)
 .Q
 ;
IMMUN ;
 S X="Immunizations make your body stronger to fight infections." D S(X,1)
 ;
 D IMMFORC^BIRPC(.APCHIMM,APCHSDFN)
 I $E($G(APCHIMM),1,2)="No" S X="",$E(X,5)="You have all your immunizations.  That's Great!" D S(X)
 I $E($G(APCHIMM),1,2)="  " F APCHIMMN=1:1 S APCHIMMT=$P($P(APCHIMM,U,APCHIMMN),"|") Q:$G(APCHIMMT)']""  D
 .I $E(APCHIMMT,1,2)="  " S APCHIMMT=$E(APCHIMMT,3,99)
 .I $G(APCHIMMT)]"" S APCHI(APCHIMMN)=APCHIMMT
 .Q
 I $G(APCHIMM)]"",+APCHIMM S X="",$E(X,5)="Immunizations are due." D S(X)
 I $D(APCHI) S APCHICTR=0 D
 .S X="",$E(X,5)="You can get these immunizations today:" D S(X)
 .F  S APCHICTR=$O(APCHI(APCHICTR)) Q:APCHICTR'=+APCHICTR  D
 ..S APCHIMDU=$P(APCHI(APCHICTR),U),X="",$E(X,5)=APCHIMDU D S(X)
 ..Q
 ;
MISC ;
 S X="Good health starts with you.  Some basic rules can keep you safe." D S(X,1)
 S X="Here are two checklists to help you and your family safe." D S(X)
 S X="",$E(X,5)="To help protect yourself at home:" D S(X)
 S X="",$E(X,10)="Use smoke detectors.  Remember to check the batteries every month." D S(X)
 S X="",$E(X,10)="Change the batteries every year.  You may want to use a reminder." D S(X)
 S X="",$E(X,10)="For example, change the batteries around your birthday, some holiday" D S(X)
 S X="",$E(X,10)="or at daylight savings time." D S(X)
 S X="",$E(X,10)="Lock up guns and ammunition, and store them separately." D S(X)
 S X="",$E(X,10)="Keep good lights on in hallways, stairways and porches." D S(X)
 S X="",$E(X,10)="Fix, or get rid of, things you can trip on such as loose rugs," D S(X)
 S X="",$E(X,10)="electrical cords and toys." D S(X)
 S X="",$E(X,5)="To help protect you away from home:"  D S(X,1)
 S X="",$E(X,10)="Wear seat belts - ALWAYS!" D S(X)
 S X="",$E(X,10)="Never drive after drinking alcohol-or get in a car with a driver" D S(X)
 S X="",$E(X,10)="who was drinking." D S(X)
 S X="",$E(X,10)="Always wear a safety helmet while riding a motorcycle or bicycle." D S(X)
 S X="",$E(X,10)="Look out for hazards where you work.  Follow workplace safety rules." D S(X)
 Q
CKD ;Does patient have chronic kidney disease (CKD)?
 S APCHCKD=0
 ;get last serum creatinine value
 S T=$O(^ATXLAB("B","DM AUDIT CREATININE TAX",0)) I $G(T)]"" S APCHLCRV=$$LAB(APCHSDFN,T),APCHLCRD=$P($G(APCHLCRV),"|||",2),APCHLCRV=$P($G(APCHLCRV),"|||") I $G(APCHLCRV)]"" D
 .I $$SEX^AUPNPAT(APCHSDFN)="F",APCHLCRV>1.3 S APCHCKD=1
 .I $$SEX^AUPNPAT(APCHSDFN)="M",APCHLCRV>1.5 S APCHCKD=1
 ;get last urine protein value
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","DM AUDIT URINE PROTEIN TAX",0)) I $G(T)]"" S APCHLUPV=$$LAB(APCHSDFN,T),APCHLUPD=$P($G(APCHLUPV),"|||",2),APCHLUPV=$P($G(APCHLUPV),"|||") I $G(APCHLUPV)]"" D
 .I +APCHLUPV>200 S APCHCKD=1
 ;get last A/C ratio value
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","DM AUDIT A/C RATIO TAX",0)) I $G(T)]"" S APCHLACV=$$LAB(APCHSDFN,T),APCHLACD=$P($G(APCHLACV),"|||",2),APCHLACV=$P($G(APCHLACV),"|||") I $G(APCHLACV)]"" D
 .I +APCHLACV>200 S APCHCKD=1
 ;get estimated GFR
 Q:APCHCKD=1  S T=$O(^ATXLAB("B","BGP GPRA ESTIMATED GFR TAX",0)) I $G(T)]"" S APCHLEGV=$$LAB(APCHSDFN,T),APCHLEGD=$P($G(APCHLEGV),"|||",2),APCHLEGV=$P($G(APCHLEGV),"|||") I $G(APCHLEGV)]"" D
 .I APCHLEGV<60 S APCHCKD=1
 Q
 ;
 ; 
S(Y,F,C,T) ;set up array
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
 S %=$P(^TMP("APCHPHS",$J,"PHS",0),U)+1,$P(^TMP("APCHPHS",$J,"PHS",0),U)=%
 S ^TMP("APCHPHS",$J,"PHS",%)=X
 Q
DMDX(P) ;
  ;check problem list OR must have 3 diagnoses
 N T S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 I 'T Q ""
 N X,Y,I S (X,Y,I)=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(I)  I $D(^AUPNPROB(X,0)),$P(^AUPNPROB(X,0),U,12)'="D" S Y=$P(^AUPNPROB(X,0),U) I $$ICD^ATXAPI(Y,T,9) S I=1
 I I Q "Yes"
 NEW APCHX
 S APCHX=""
 S X=P_"^LAST 3 DX [SURVEILLANCE DIABETES" S E=$$START1^APCLDF(X,"APCHX(") G:E DMX I $D(APCHX(3)) S APCHX="Yes"
 I $G(APCHX)="" S APCHX="No"
DMX ;
 Q APCHX
 ;
LAB(P,T,LT) ;EP
 I '$G(LT) S LT=""
 NEW D,V,G,X,J S (D,G)=0 F  S D=$O(^AUPNVLAB("AE",P,D)) Q:D'=+D!(G)  D
 .S X=0 F  S X=$O(^AUPNVLAB("AE",P,D,X)) Q:X'=+X!(G)  D
 ..S Y=0 F  S Y=$O(^AUPNVLAB("AE",P,D,X,Y)) Q:Y'=+Y!(G)  D
 ...I $D(^ATXLAB(T,21,"B",X)),$P(^AUPNVLAB(Y,0),U,4)]"" S G=Y Q
 ...Q:'LT
 ...S J=$P($G(^AUPNVLAB(Y,11)),U,13) Q:J=""
 ...Q:'$$LOINC(J,LT)
 ...S G=Y
 ...Q
 ..Q
 .Q
 I 'G S R=$$REF(P,T) Q "||||||"_R
 Q $P(^AUPNVLAB(G,0),U,4)_"|||"_$$FMTE^XLFDT($P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_$$REF(P,T,$P($P(^AUPNVSIT($P(^AUPNVLAB(G,0),U,3),0),U),"."))_"|||"_G
LOINC(A,B) ;
 NEW %
 S %=$P($G(^LAB(95.3,A,9999999)),U,2)
 I %]"",$D(^ATXAX(B,21,"B",%)) Q 1
 S %=$P($G(^LAB(95.3,A,0)),U)_"-"_$P($G(^LAB(95.3,A,0)),U,15)
 I $D(^ATXAX(B,21,"B",%)) Q 1
 Q ""
 ;
DATE(D) ;EP - convert to slashed date
 I $G(D)="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
REF(P,T,D) ;return refusal string after date D for test is tax T
 I '$G(P) Q ""
 I '$G(T) Q ""
 I '$G(D) S D=""
 N APCHREF,APCHT,V S APCHT=0 F  S APCHT=$O(^ATXLAB(T,21,"B",APCHT)) Q:APCHT'=+APCHT  D
 .S V=$$REF1(P,60,APCHT,D) I V]"" S APCHREF(9999999-$P(V,U,3))=V
 I $D(APCHREF) S %=0,%=$O(APCHREF(%)) I % S V=APCHREF(%) Q V
 Q ""
REF1(P,F,I,D,T) ; ;
 I '$G(P) Q ""
 I '$G(F) Q ""
 I '$G(I) Q ""
 I $G(D)="" S D=""
 I $G(T)="" S T="E"
 NEW X,N S X=$O(^AUPNPREF("AA",P,F,I,0))
 I 'X Q ""  ;none of this item was refused
 S N=$O(^AUPNPREF("AA",P,F,I,X,0))
 NEW Y S Y=9999999-X
 I D]"",Y>D Q $S(T="I":Y,1:$$TYPEREF(N)_"-"_$$DATE(Y))
 I T="I" Q Y  ;quit on internal form of date
 Q $$TYPEREF(N)_"-"_$$DATE(Y)
 ;
TYPEREF(N) ;
 NEW % S %=$P(^AUPNPREF(N,0),U,7)
 I %="R"!(%="") Q "Declined"
 I %="N" Q "Not Med Ind"
 I %="F" Q "No Resp to F/U"
 Q ""
 ; 
 ;
GETLABSX ;get lab tests ordered today
 ;
 S APCHLR=$G(^DPT(APCHSDFN,"LR"))
 I $G(APCHLR)]"" S APCHLRO=0,APCHTSTP=0 D
 .F  S APCHLRO=$O(^LRO(69,DT,1,"AA",APCHLR,APCHLRO)) Q:APCHLRO=""  Q:APCHLRO'=+APCHLRO  D
 ..F  S APCHTSTP=$O(^LRO(69,DT,1,APCHLRO,2,"B",APCHTSTP)) Q:APCHTSTP'=+APCHTSTP  D
 ...S APCHTCTR=$O(^LRO(69,DT,1,APCHLRO,2,"B",APCHTSTP,0))
 ...S APCHTEST=$P(^LAB(60,APCHTSTP,0),U)
 ...S APCHTST(APCHTEST)=""
 ...Q
 ;
 ;
GETLABS ;get todays labs from V Lab File
 S APCHSIVD=9999999-DT
 I $D(^AUPNVLAB("AE",APCHSDFN,APCHSIVD)) S APCHTSTP=0,APCHVLAB=0 D
 .F  S APCHTSTP=$O(^AUPNVLAB("AE",APCHSDFN,APCHSIVD,APCHTSTP)) Q:APCHTSTP=""  Q:APCHTSTP'=+APCHTSTP  D
 ..S APCHTEST=$P(^LAB(60,APCHTSTP,0),U),APCHTST(APCHTEST)=""
 ..S APCHVLAB=$O(^AUPNVLAB("AE",APCHSDFN,APCHSIVD,APCHTSTP,APCHVLAB)) Q:APCHVLAB'=+APCHVLAB
 ..I $D(^AUPNVLAB(APCHVLAB,21)) S APCHCTR=0 F  S APCHCTR=$O(^AUPNVLAB(APCHVLAB,21,APCHCTR)) Q:'APCHCTR  D
 ...Q:APCHCTR'=+APCHCTR
 ...S APCHTST(APCHTEST,APCHCTR)=$P(^AUPNVLAB(APCHVLAB,21,APCHCTR,0),U)
 ..Q
 Q
 ;
APCHLHD ;
 S X="Lab tests can help measure health and some check to make sure that your" D S(X,1)
 S X="medicines are working right." D S(X)
 ;
