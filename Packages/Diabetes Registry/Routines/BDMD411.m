BDMD411 ; IHS/CMI/LAB -IHS -CUMULATIVE REPORT ;
 ;;2.0;DIABETES MANAGEMENT SYSTEM;**5**;JUN 14, 2007
 ;
 ;
IMM ;
 S:'$D(BDMCUML(140)) BDMCUML(140)="IMMUNIZATIONS"
 S $P(BDMCUML(140),U,2)=$P(BDMCUML(140),U,2)+1
 S V=$G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,64))
 I $E(V)="1" S $P(BDMCUML(140),U,3)=$P(BDMCUML(140),U,3)+1
 I $E(V)="3" S $P(BDMCUML(140),U,6)=$P(BDMCUML(140),U,6)+1
 S V=$G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,66))
 I $E(V)="1" S $P(BDMCUML(140),U,4)=$P(BDMCUML(140),U,4)+1
 I $E(V)="3" S $P(BDMCUML(140),U,7)=$P(BDMCUML(140),U,7)+1
 S V=$G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,68))
 I $E(V)="1" S $P(BDMCUML(140),U,5)=$P(BDMCUML(140),U,5)+1
 I $E(V)="3" S $P(BDMCUML(140),U,8)=$P(BDMCUML(140),U,8)+1
 ;HEP B
 S V=$G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,115))
 I $E(V)="1" S $P(BDMCUML(140),U,9)=$P(BDMCUML(140),U,9)+1
 I $E(V)="3" S $P(BDMCUML(140),U,10)=$P(BDMCUML(140),U,10)+1
 ;
QUAN ;
 ;145
 ;title^total pts^total YES^NO^REF^UACR^UPCR^24HR^MICRO STRIP^MICRO ONLY^DIPSTICK
 K BDMOFLG
 S BDMOFLG=0
 S:'$D(BDMCUML(145)) BDMCUML(145)="LABORATORY EXAMS"
 S $P(BDMCUML(145),U,2)=$P(BDMCUML(145),U,2)+1  ;TOTAL # of patients
 S Q=$G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,92))
 S V=$E($G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,92)))  ;test done?
 S T=$P($G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,92)),U,5)  ;type of test
 S R=$S($P(Q,U,6)]"":$P(Q,U,6),1:$P(Q,U,2))  ;value/result
 I V=1 D
 .S $P(BDMCUML(145),U,3)=$P(BDMCUML(145),U,3)+1
 .S P=$S(T=1:6,T=2:7,T=3:8,T=4:9,T=5:10,T=6:11,1:"")
 .S $P(BDMCUML(145),U,P)=$P(BDMCUML(145),U,P)+1
 ;.I T=1!(T=2)!(T=5) D
 ;..I T=5 D
 ;...S $P(BDMCUML(145),U,14)=$P(BDMCUML(145),U,14)+1
 ;..I T=1 D
 ;...I R[">" S $P(BDMCUML(145),U,14)=$P(BDMCUML(145),U,14)+1 Q
 ;...;I $$UP^XLFSTR(R)["COMMENT" S $P(BDMCUML(145),U,12)=$P(BDMCUML(145),U,12)+1 Q
 ;...S R=$$STV^BDMD418(R,8)
 ;...I R="" S $P(BDMCUML(145),U,15)=$P(BDMCUML(145),U,15)+1 Q
 ;...S R=+R
 ;...I R<30 S $P(BDMCUML(145),U,12)=$P(BDMCUML(145),U,12)+1 Q
 ;...I R<300.9999 S $P(BDMCUML(145),U,13)=$P(BDMCUML(145),U,13)+1 Q
 ;...S $P(BDMCUML(145),U,14)=$P(BDMCUML(145),U,14)+1
 ;..I T=2 D
 ;...I R["-" S $P(BDMCUML(145),U,13)=$P(BDMCUML(145),U,13)+1 Q
 ;...I R["300" S $P(BDMCUML(145),U,14)=$P(BDMCUML(145),U,14)+1 Q
 ;...I R[">" S $P(BDMCUML(145),U,14)=$P(BDMCUML(145),U,14)+1 Q
 ;...S R=$$STV^BDMD418(R,5,1) I R>300 S $P(BDMCUML(145),U,14)=$P(BDMCUML(145),U,14)+1 Q
 ;...S $P(BDMCUML(145),U,12)=$P(BDMCUML(145),U,12)+1
 I V=2 S $P(BDMCUML(145),U,4)=$P(BDMCUML(145),U,4)+1  ;no urine testing
 I V=3 S $P(BDMCUML(145),U,5)=$P(BDMCUML(145),U,5)+1  ;refused urine testing
EKG ;need date of last ekg
 S:'$D(BDMCUML(150)) BDMCUML(150)="Electrocardiogram (Age 30 and above)"
 G:$$AGE^AUPNPAT(BDMPD,BDMADAT)<30 CREAT
 S $P(BDMCUML(150),U,2)=$P(BDMCUML(150),U,2)+1
 S V=$$EKG^BDMD412(BDMPD,BDMRED,"I")
 I V]"" D
 .S E=$$FMDIFF^XLFDT(BDMADAT,V)
 .I E<(365.25*3) S $P(BDMCUML(150),U,3)=$P(BDMCUML(150),U,3)+1
 .I E<(365.25*5) S $P(BDMCUML(150),U,4)=$P(BDMCUML(150),U,4)+1
 .S $P(BDMCUML(150),U,5)=$P(BDMCUML(150),U,5)+1
CREAT ;
 S:'$D(BDMCUML(170)) BDMCUML(170)="Serum Creatinine obtained in the past 12 months"
 S $P(BDMCUML(170),U,2)=$P(BDMCUML(170),U,2)+1
 S V=$$CREAT^BDMD418(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(170),U,5)=$P(BDMCUML(170),U,5)+1 G GFR
 S V=$P(V,U)
 S V=$$STV^BDMD418(V,5,1) I $E(V)'=+$E(V),$E(V)'="." S $P(BDMCUML(170),U,6)=$P(BDMCUML(170),U,6)+1 G GFR ;unable to determine result, not a number
 I V>1.9 S $P(BDMCUML(170),U,3)=$P(BDMCUML(170),U,3)+1
 I V<2.0 S $P(BDMCUML(170),U,4)=$P(BDMCUML(170),U,4)+1
 ;
GFR ;
 G:$$AGE^AUPNPAT(BDMPD,BDMADAT)<18 TCHOL
 S:'$D(BDMCUML(175)) BDMCUML(175)="Estimated GFR documented during audit period"
 S $P(BDMCUML(175),U,2)=$P(BDMCUML(175),U,2)+1
 S V=$E($G(^XTMP("BDMDM12",BDMJOB,BDMBTH,"AUDIT",BDMPD,79)))
 I V=1 S $P(BDMCUML(175),U,5)=$P(BDMCUML(175),U,5)+1
 ;
TCHOL ;
 S:'$D(BDMCUML(180)) BDMCUML(180)="Total Cholesterol obtained in past 12 months"
 S $P(BDMCUML(180),U,2)=$P(BDMCUML(180),U,2)+1
 S V=$$CHOL^BDMD418(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(180),U,6)=$P(BDMCUML(180),U,6)+1 G LDL
 S V=$P(V,U)
 S V=$$STV^BDMD418(V,5,1)
 I V="" S $P(BDMCUML(180),U,7)=$P(BDMCUML(180),U,7)+1 G LDL
 I $E(V)'=+$E(V)!(+V=0) S $P(BDMCUML(180),U,7)=$P(BDMCUML(180),U,7)+1 G LDL ;unable to determine result, not a number or is blank
 I V<200 S $P(BDMCUML(180),U,3)=$P(BDMCUML(180),U,3)+1 G LDL
 I V<240 S $P(BDMCUML(180),U,4)=$P(BDMCUML(180),U,4)+1 G LDL
 S $P(BDMCUML(180),U,5)=$P(BDMCUML(180),U,5)+1
LDL ;
 S:'$D(BDMCUML(190)) BDMCUML(190)="LDL Cholesterol obtained in the past 12 months"
 S $P(BDMCUML(190),U,2)=$P(BDMCUML(190),U,2)+1
 S V=$$LDL^BDMD418(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(190),U,7)=$P(BDMCUML(190),U,7)+1 G HDL
 S V=$P(V,U)
 ;S V=$$STV^BDMD418(V,4)
 S V=$$STV^BDMD418(V,5,1) I $E(V)'=+$E(V)!(+V=0) S $P(BDMCUML(190),U,8)=$P(BDMCUML(190),U,8)+1 G HDL ;unable to determine result, not a number or blank
 I V<100 S $P(BDMCUML(190),U,3)=$P(BDMCUML(190),U,3)+1 G HDL
 I V<130 S $P(BDMCUML(190),U,4)=$P(BDMCUML(190),U,4)+1 G HDL
 I V<160.1 S $P(BDMCUML(190),U,5)=$P(BDMCUML(190),U,5)+1 G HDL
 S $P(BDMCUML(190),U,6)=$P(BDMCUML(190),U,6)+1
HDL ;
 S:'$D(BDMCUML(195)) BDMCUML(195)="HDL Cholesterol obtained in the past 12 months"
 S $P(BDMCUML(195),U,2)=$P(BDMCUML(195),U,2)+1
 S V=$$HDL^BDMD418(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(195),U,7)=$P(BDMCUML(195),U,7)+1 G TRIG
 S V=$P(V,U)
 S V=$$STV^BDMD418(V,5,1) I $E(V)'=+$E(V)!(+V=0) S $P(BDMCUML(195),U,8)=$P(BDMCUML(195),U,8)+1 G TRIG ;unable to determine result, not a number
 S V=$P(V,"."),V=$$STV^BDMD418(V,5,1)
 I $E(V)'=+$E(V)!(+V=0)!(V="") S $P(BDMCUML(195),U,8)=$P(BDMCUML(195),U,8)+1 G TRIG ;unable to determine result, not a number
 I V<35 S $P(BDMCUML(195),U,3)=$P(BDMCUML(195),U,3)+1 G TRIG
 I V<46 S $P(BDMCUML(195),U,4)=$P(BDMCUML(195),U,4)+1 G TRIG
 I V<55.1 S $P(BDMCUML(195),U,5)=$P(BDMCUML(195),U,5)+1 G TRIG
 S $P(BDMCUML(195),U,6)=$P(BDMCUML(195),U,6)+1
TRIG ;
 S:'$D(BDMCUML(200)) BDMCUML(200)="Triglycerides obtained in past 12 months"
 S $P(BDMCUML(200),U,2)=$P(BDMCUML(200),U,2)+1
 S V=$$TRIG^BDMD418(BDMPD,BDMBDAT,BDMADAT,"I")
 I V="" S $P(BDMCUML(200),U,7)=$P(BDMCUML(200),U,7)+1 G SELF
 S V=$P(V,U)
 S V=$$STV^BDMD418(V,5,1) I $E(V)'=+$E(V) S $P(BDMCUML(200),U,8)=$P(BDMCUML(200),U,8)+1 G SELF ;unable to determine result, not a number
 I V<150 S $P(BDMCUML(200),U,3)=$P(BDMCUML(200),U,3)+1 G SELF
 I V<200 S $P(BDMCUML(200),U,4)=$P(BDMCUML(200),U,4)+1 G SELF
 I V<401 S $P(BDMCUML(200),U,5)=$P(BDMCUML(200),U,5)+1 G SELF
 S $P(BDMCUML(200),U,6)=$P(BDMCUML(200),U,6)+1
SELF ;
 Q
CESS(P,BDATE,EDATE) ;EP - find any cessation hf in 12 months before E
 I '$G(P) Q ""
 I $P($$TOBACCO^BDMD41T(P,$$DOB^AUPNPAT(P),EDATE),U,1)'=1 Q ""
 NEW BDM,E,X,G,T,O,D,H,C
 K BDM
 S T=$O(^ATXAX("B","DM AUDIT CESSATION HLTH FACTOR",0))
 S (H,D)=0 S O=""
 S H=0 F  S H=$O(^AUPNVHF("AA",P,H)) Q:H'=+H!(O]"")  D
 .S G=0
 .I $D(^ATXAX(T,21,"AA",H)) S G=1
 .I $P(^AUTTHF(H,0),U,1)["CESSATION",$$VAL^XBDIQ1(9999999.64,H,.03)["TOBACCO" S G=1
 .Q:'G
 .S D="" F  S D=$O(^AUPNVHF("AA",P,H,D)) Q:D'=+D!(O]"")  D
 ..Q:(9999999-D)>EDATE  ;after time frame
 ..Q:(9999999-D)<BDATE  ;before time frame
 ..S O="1  Yes- "_$$FMTE^XLFDT(9999999-D)_" HF: "_$P(^AUTTHF(H,0),U)
 .Q
 I O Q O  ;found a cessation hf so quit
 S O=$$CESSOTH(P,BDATE,EDATE)
 I O Q O
 Q "2  No"
 ;
CESSOTH(P,BDATE,EDATE) ;EP
 NEW BDMALLED,X,Y,%,T,G,A,B,E,Z,BDMLPED,BDMMEDS1
 K BDMALLED
 S BDMLPED=""
 S Y="BDMALLED("
 S X=P_"^ALL EDUC;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE) S E=$$START1^APCLDF(X,Y)
 S %="" I $D(BDMALLED(1)) S %="" D  I %]"" S BDMLPED=%
 .S (X,D)=0,T="" F  S X=$O(BDMALLED(X)) Q:X'=+X  D
 ..S T=$P(^AUPNVPED(+$P(BDMALLED(X),U,4),0),U)
 ..Q:'T
 ..Q:'$D(^AUTTEDT(T,0))
 ..S T=$P(^AUTTEDT(T,0),U,2)
 ..I $P(T,"-")="TO",$P(BDMLPED,U)<$P(BDMALLED(X),U) S %=$P(BDMALLED(X),U)_U_T Q
 ..I $P(T,"-",2)="TO",$P(BDMLPED,U)<$P(BDMALLED(X),U) S %=$P(BDMALLED(X),U)_U_T Q
 ..I $P(T,"-",2)="SHS",$P(BDMLPED,U)<$P(BDMALLED(X),U) S %=$P(BDMALLED(X),U)_U_T Q
 ..I $P(T,"-",1)["305.1"!($P(T,"-")="649.00")!($P(T,"-")="649.01")!($P(T,"-")="649.02")!($P(T,"-")="649.03")!($P(T,"-")="649.04")!($P(T,"-")="V15.82"),$P(BDMLPED,U)<$P(BDMALLED(X),U) S %=$P(BDMALLED(X),U)_U_T Q
 ..I $P(T,"-",1)="D1320"!($P(T,"-")="99406")!($P(T,"-")="99407")!($P(T,"-")="G0375")!($P(T,"-")="G0376")!($P(T,"-")="4000F")!($P(T,"-")="G8402")!($P(T,"-")="G8453"),$P(BDMLPED,U)<$P(BDMALLED(X),U) S %=$P(BDMALLED(X),U)_U_T Q
 I %]"" Q "1  Yes "_$$FMTE^XLFDT($P(%,U,1))_" Pt Ed "_$P(%,U,2)
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 S X=0,G="" F  S X=$O(^TMP($J,"A",X)) Q:X'=+X  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .S B=$$CLINIC^APCLV(V,"C")
 .I B=94,$P(BDMLPED,U)<$P($P(^AUPNVSIT(V,0),U),".") S BDMLPED=$P($P(^AUPNVSIT(V,0),U),".")_U_"Clinic 94" Q
 .S Z=0 F  S Z=$O(^AUPNVDEN("AD",V,Z)) Q:Z'=+Z!(G)  S B=$P($G(^AUPNVDEN(Z,0)),U) I B S B=$P($G(^AUTTADA(B,0)),U) I B=1320,$P(BDMLPED,U)<$P($P(^AUPNVSIT(V,0),U),".") S BDMLPED=$P($P(^AUPNVSIT(V,0),U),".")_U_"ADA 1320" Q
 .Q
 I BDMLPED]"" Q "1  Yes "_$$FMTE^XLFDT($P(BDMLPED,U,1))_" "_$P(BDMLPED,U,2)
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("D1320")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT D1320"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("D1320")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN D1320"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD(99406)) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT 99406"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD(99406)) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN 99406"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD(99407)) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT 99407"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD(99407)) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN 99407"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G0375")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT G0375"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G0376")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT G0376"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("4000F")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT 4000F"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G0375")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN G0375"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G0376")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN G0376"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("4000F")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN 4000F"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("4001F")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CESSATION MED - CPT 4001F"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("4001F")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN 4001F"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8402")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT G8402"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8402")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN G8402"
 S G=$$CPTI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8453")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"CPT G8453"
 S G=$$TRANI^BDMD4DU(P,BDATE,EDATE,+$$CODEN^ICPTCOD("G8453")) I G,$P(BDMLPED,U)<$P(G,U,2) S BDMLPED=$P(G,U,2)_U_"TRAN G8453"
 I BDMLPED]"" Q "1  Yes "_$$FMTE^XLFDT($P(BDMLPED,U,1))_" "_$P(BDMLPED,U,2)
 ;now check meds
 K BDMMEDS1
 D GETMEDS^BDMD4DU(P,BDATE,EDATE,,,,,.BDMMEDS1)
 S T=$O(^ATXAX("B","BGP CMS SMOKING CESSATION MEDS",0))
 S T1=$O(^ATXAX("B","BGP CMS SMOKING CESSATION NDC",0))
 S (X,G,M,E)=0,D="" F  S X=$O(BDMMEDS1(X)) Q:X'=+X  S V=$P(BDMMEDS1(X),U,5),Y=+$P(BDMMEDS1(X),U,4) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:$$UP^XLFSTR($P($G(^AUPNVMED(Y,11)),U))["RETURNED TO STOCK"  ;new in v11.0
 .S Z=$P($G(^AUPNVMED(Y,0)),U) ;get drug ien
 .Q:'Z
 .S N=$P($G(^PSDRUG(Z,0)),U)
 .I $D(^ATXAX(T,21,"B",Z))!(N["NICOTINE TRANS")!(N["NICOTINE PATCH")!(N["NICOTINE POLACRILEX")!(N["NICOTINE INHALER")!(N["NICOTINE NASAL SPRAY") D
 ..I $P(BDMLPED,U)<$P($P(^AUPNVSIT(V,0),U),".") S BDMLPED=$P($P(^AUPNVSIT(V,0),U),".")_U_"CESSATION MED - "_N
 .S C=$P($G(^PSDRUG(Z,2)),U,4)
 .I C]"",$D(^ATXAX(T1,21,"B",C)) I $P(BDMLPED,U)<$P($P(^AUPNVSIT(V,0),U),".") S BDMLPED=$P($P(^AUPNVSIT(V,0),U),".")_U_"CESSATION MED - "_N
 I BDMLPED]"" Q "1  Yes "_$$FMTE^XLFDT($P(BDMLPED,U,1))_" "_$P(BDMLPED,U,2)
PEDREF ; 
 S G=$$REFTOED(P,BDATE,EDATE)
 I $P(BDMLPED,U)<$P(G,U,1) Q "3 Refused "_$$FMTE^XLFDT($P(G,U,1))_" "_$P(G,U,2)
 S G=$$CPTREFT^BDMD4DU(P,BDATE,EDATE,$O(^ATXAX("B","BGP TOB CESS REFUSAL CPTS",0)))
 I $P(BDMLPED,U)<$P(G,U,1) Q "3 Refused "_$$FMTE^XLFDT($P(G,U,2))_" CPT "_$P(G,U,4)
 Q BDMLPED
REFTOED(P,BDATE,EDATE) ;EP - now check all Refusals of these education topics
 S G="",X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.09,X)) Q:X=""!(G]"")  D
 .S D=0 F  S D=$O(^AUPNPREF("AA",P,9999999.09,X,D)) Q:D=""!(G]"")  D
 ..S I=0 F  S I=$O(^AUPNPREF("AA",P,9999999.09,X,D,I)) Q:I'=+I!(G]"")  D
 ...S Z=$P($G(^AUPNPREF(I,0)),U,3)
 ...Q:Z=""
 ...I Z<BDATE Q
 ...I Z>EDATE Q
 ...S Y=$P($G(^AUTTEDT(X,0)),U,2)
 ...I $P(Y,"-")="TO"!($P(Y,"-",2)="TO")!($P(Y,"-",2)="SHS") S G=Z_U_"Refused "_Y
 ...I $P(Y,"-",1)["305.1"!($P(Y,"-")="649.00")!($P(Y,"-")="649.01")!($P(Y,"-")="649.02")!($P(Y,"-")="649.03")!($P(Y,"-")="649.04")!($P(Y,"-")="V15.82") S G=Z_U_"Ref "_Y
 Q G
