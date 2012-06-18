BGP6UTL ; IHS/CMI/LAB - 27 Apr 2006 11:01 PM ; 
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
STMP ;EP
 Q:BGPTIME'=1
 I BGPLIST="P",$P(^AUPNPAT(DFN,0),U,14)'=BGPLPRV Q
 X ^BGPINDS(BGPIC,2) Q:'$T
 S BGPLIST(BGPIC)=$G(BGPLIST(BGPIC))+1
 S ^XTMP("BGP6D",BGPJ,BGPH,"LIST",BGPIC,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEB,DFN)=$G(BGPVALUE)
 Q
D(D) ;EP
 I D="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)_$S($P(D,".",2)]"":$P(D,".",2),1:"")
JRNL ;EP
 N (DT,U,ZTQUEUED) S %=$$NOJOURN^ZIBGCHAR("BGPGPDCS"),%=$$NOJOURN^ZIBGCHAR("BGPGPDPS"),%=$$NOJOURN^ZIBGCHAR("BGPGPDBS"),%=$$NOJOURN^ZIBGCHAR("BGPHEDCS"),%=$$NOJOURN^ZIBGCHAR("BGPHEDPS"),%=$$NOJOURN^ZIBGCHAR("BGPHEDBS")
 S %=$$NOJOURN^ZIBGCHAR("BGPDATA"),%=$$NOJOURN^ZIBGCHAR("BGPGUI")
 S %=$$NOJOURN^ZIBGCHAR("BGPELDCS"),%=$$NOJOURN^ZIBGCHAR("BGPELDPS"),%=$$NOJOURN^ZIBGCHAR("BGPELDBS")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
EXCELGS ;EP
 K BGPEXCT
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 S BGPX=""
 S $P(BGPX,U,11)="DM BP Assessed"
 S $P(BGPX,U,20)="DM Depression"
 S $P(BGPX,U,29)="DM Influenza"
 S $P(BGPX,U,38)="DM Pneumovax Ever"
 S $P(BGPX,U,47)="Topical Fluoride-Applications"
 S $P(BGPX,U,56)="Tobacco Assessed"
 S $P(BGPX,U,65)="Tobacco Users"
 S $P(BGPX,U,74)="BMI Measured"
 S $P(BGPX,U,83)="BMI-Assessed as Obese"
 S $P(BGPX,U,92)="CVD 20+ BP Assessed"
 S $P(BGPX,U,101)="CVD 20+ Normal BP"
 S $P(BGPX,U,110)="CVD 20+ Pre-HTN I"
 S $P(BGPX,U,119)="CVD 20+ Pre-HTN II"
 S $P(BGPX,U,128)="CVD 20+ Stage 1 HTN"
 S $P(BGPX,U,137)="CVD 20+ Stage 2 HTN"
 S $P(BGPX,U,146)="CVD IHD BP Assessed"
 S $P(BGPX,U,155)="CVD IHD Normal BP"
 S $P(BGPX,U,164)="CVD IHD Pre-HTN I"
 S $P(BGPX,U,173)="CVD IHD Pre HTN II"
 S $P(BGPX,U,182)="CVD IHD Stage 1 HTN"
 S $P(BGPX,U,191)="CVD IHD Stage 2 HTN"
 S $P(BGPX,U,200)="Comp CVD-BP Assessed"
 S $P(BGPX,U,209)="Comp CVD-LDL Assessment"
 S $P(BGPX,U,218)="Comp CVD-Tobacco"
 S $P(BGPX,U,227)="Comp CVD-BMI"
 S $P(BGPX,U,236)="Comp CVD-Lifestyle Counseling"
 S $P(BGPX,U,245)="Comp CVD-Depression"
 W BGPX,!
 K BGPX
 S BGPX="" S P=11 F  S $P(BGPX,U,P)="Current",P=P+9 Q:P>245
 S P=14 F  S $P(BGPX,U,P)="Previous",P=P+9 Q:P>248
 S P=17 F  S $P(BGPX,U,P)="Baseline",P=P+9 Q:P>251
 W BGPX,!
 K BGPX
 S BGPX="",$P(BGPX,U,1)="Site Name",$P(BGPX,U,2)="ASUFAC",$P(BGPX,U,3)="DB Id",$P(BGPX,U,4)="Date Report Run",$P(BGPX,U,5)="Current Report Begin Date",$P(BGPX,U,6)="Current Report End Date",$P(BGPX,U,7)="Previous Year Begin Date"
 S $P(BGPX,U,8)="Previous Year End Date",$P(BGPX,U,9)="Baseline Year Begin Date",$P(BGPX,U,10)="Baseline Year End Date"
 S P=11 F  S $P(BGPX,U,P)="Num",P=P+3 Q:P>251
 S P=12 F  S $P(BGPX,U,P)="Den",P=P+3 Q:P>252
 S P=13 F  S $P(BGPX,U,P)="%",P=P+3 Q:P>253
 W BGPX,!
 S BGPX=0 F  S BGPX=$O(BGPGRAN1(BGPX)) Q:BGPX'=+BGPX  W BGPGRAN1(BGPX),!
 K BGPGRAN1
 D ^%ZISC
GPRANT2 ;
 K BGPEXCT
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN2,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 S BGPX=""
 S $P(BGPX,U,11)="Comp CVD-All Assmts"
 S $P(BGPX,U,20)="Beta-Blocker After AMI"
 S $P(BGPX,U,29)="Persistence Beta-Blocker"
 S $P(BGPX,U,38)="Cholesterol Mgmt After CV Event-LDL Assessed"
 S $P(BGPX,U,47)="Cholesterol Mgmt After CV Event-LDL<=100"
 S $P(BGPX,U,56)="Cholesterol Mgmt After CV Event-LDL 101-130"
 S $P(BGPX,U,65)="Cholesterol Mgmt After CV Event-LDL >130"
 S $P(BGPX,U,74)="Prediabetes/Msyn-All Assessments"
 S $P(BGPX,U,83)="PHN Visits"
 W BGPX,!
 K BGPX
 S BGPX="" S P=11 F  S $P(BGPX,U,P)="Current",P=P+9 Q:P>83
 S P=14 F  S $P(BGPX,U,P)="Previous",P=P+9 Q:P>86
 S P=17 F  S $P(BGPX,U,P)="Baseline",P=P+9 Q:P>89
 W BGPX,!
 K BGPX
 S BGPX="",$P(BGPX,U,1)="Site Name",$P(BGPX,U,2)="ASUFAC",$P(BGPX,U,3)="DB Id",$P(BGPX,U,4)="Date Report Run",$P(BGPX,U,5)="Current Report Begin Date",$P(BGPX,U,6)="Current Report End Date",$P(BGPX,U,7)="Previous Year Begin Date"
 S $P(BGPX,U,8)="Previous Year End Date",$P(BGPX,U,9)="Baseline Year Begin Date",$P(BGPX,U,10)="Baseline Year End Date"
 S P=11 F  S $P(BGPX,U,P)="Num",P=P+3 Q:P>89
 S P=12 F  S $P(BGPX,U,P)="Den",P=P+3 Q:P>90
 S P=13 F  S $P(BGPX,U,P)="%",P=P+3 Q:P>91
 W BGPX,!
 S BGPX=0 F  S BGPX=$O(BGPGRAN2(BGPX)) Q:BGPX'=+BGPX  W BGPGRAN2(BGPX),!
 K BGPGRAN2
 D ^%ZISC  ;close host file
EIF ;
 K BGPEXCT
 I '$G(BGPAREAA) G Q
 S Y=$$OPEN^%ZISH(BGPUF,BGPFNEIS,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file." Q
 U IO
 S BGPX=""
 S $P(BGPX,U,11)="Diabetes DX Ever"
 S $P(BGPX,U,20)="DM Documented HbA1c"
 S $P(BGPX,U,29)="DM Poor Glycemic Control"
 S $P(BGPX,U,38)="DM Ideal Glycemic Control"
 S $P(BGPX,U,47)="DM Controlled BP"
 S $P(BGPX,U,56)="DM LDL Assessed"
 S $P(BGPX,U,65)="DM Nephropathy Assessed"
 S $P(BGPX,U,74)="DM Retinopathy Exam"
 S $P(BGPX,U,83)="Dental Access General"
 S $P(BGPX,U,92)="Sealants"
 S $P(BGPX,U,101)="Top Fluoride-#Patients"
 S $P(BGPX,U,110)="Adult Influenza 65+"
 S $P(BGPX,U,119)="Adult Pneumovax 65+"
 S $P(BGPX,U,128)="Child IZ-Active Clinical"
 S $P(BGPX,U,137)="Child IZ-Active IMM Pkg"
 S $P(BGPX,U,146)="Pap Smear"
 S $P(BGPX,U,155)="Mammogram"
 S $P(BGPX,U,164)="Colorectal Cancer Screen"
 S $P(BGPX,U,173)="Tobacco Cessation"
 S $P(BGPX,U,182)="FAS Prevention"
 S $P(BGPX,U,191)="IPV/DV Screening"
 S $P(BGPX,U,200)="Depression Screening"
 S $P(BGPX,U,209)="Childhood Weight Control"
 S $P(BGPX,U,218)="CVD Cholesterol Screening"
 S $P(BGPX,U,227)="Prenatal HIV Testing"
 W BGPX,!
 K BGPX
 S BGPX="" S P=11 F  S $P(BGPX,U,P)="Current",P=P+9 Q:P>227
 S P=14 F  S $P(BGPX,U,P)="Previous",P=P+9 Q:P>230
 S P=17 F  S $P(BGPX,U,P)="Baseline",P=P+9 Q:P>233
 W BGPX,!
 K BGPX
 S BGPX="",$P(BGPX,U,1)="Site Name",$P(BGPX,U,2)="ASUFAC",$P(BGPX,U,3)="DB Id",$P(BGPX,U,4)="Date Report Run",$P(BGPX,U,5)="Current Report Begin Date",$P(BGPX,U,6)="Current Report End Date",$P(BGPX,U,7)="Previous Year Begin Date"
 S $P(BGPX,U,8)="Previous Year End Date",$P(BGPX,U,9)="Baseline Year Begin Date",$P(BGPX,U,10)="Baseline Year End Date"
 S P=11 F  S $P(BGPX,U,P)="Num",P=P+3 Q:P>233
 S P=12 F  S $P(BGPX,U,P)="Den",P=P+3 Q:P>234
 S P=13 F  S $P(BGPX,U,P)="%",P=P+3 Q:P>235
 W BGPX,!
 S BGPX=0 F  S BGPX=$O(BGPEI(BGPX)) Q:BGPX'=+BGPX  W BGPEI(BGPX),!
Q K BGPEI
 D ^%ZISC
 Q
GS ;EP
 K ^TMP($J)
 ;I $P($G(^BGPSITE(DUZ(2),0)),U,3)="N" Q
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unscripted global.  Export to area.  Using standard name.
 K ^BGPDATA S X="",C=0 F  S X=$O(^BGPGPDCS(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDCS(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDCS(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDCS(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDCS(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDCS(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDCS(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDCS(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDCS(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDCS(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDCS(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDCS(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDCS(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDCS(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDCS(BGPRPT,X,X2,X3,X4,X5)
 S X=0 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDCS"_"|"_^BGPDATA(X)
PRGS ;
 S S=C+1,X="" F  S X=$O(^BGPGPDPS(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDPS(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDPS(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDPS(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDPS(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDPS(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDPS(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDPS(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDPS(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDPS(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDPS(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDPS(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDPS(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDPS(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDPS(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDPS"_"|"_^BGPDATA(X)
BLGS ;
 S S=C+1,X="" F  S X=$O(^BGPGPDBS(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDBS(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDBS(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDBS(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDBS(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDBS(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDBS(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDBS(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDBS(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDBS(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDBS(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDBS(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDBS(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDBS(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDBS(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDBS"_"|"_^BGPDATA(X)
 NEW XBGL S XBGL="BGPDATA"
 S F="BG06"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT
 NEW XBFN,XBMED,XBF,XBFLT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF GPRA DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
REPORT ;EP
 S BGPRPT="",BGPERR=""
 I '$D(BGPGUI) W !!
 ;3 files must have the same ien
 L +^BGPGPDCS:30 I '$T S BGPERR="Unable to lock global." G REPORTX
 L +^BGPGPDPS:30 I '$T S BGPERR="Unable to lock global." G REPORTX
 L +^BGPGPDBS:30 I '$T S BGPERR="Unable to lock global." G REPORTX
 D GETIEN
 I 'BGPIEN S BGPERR="Error in control files!" S BGPRPT="" G REPORTX
 S DINUM=BGPIEN
 I $G(BGPNPL) S BGPRTYPE=4
 S BGPR12=$S($G(BGP6GPU):9,1:BGPRTYPE)
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDCS(",DLAYGO=90374.03,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPR12_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)_";.16///"_$P(^BGPSITE(DUZ(2),0),U,4)
 S DIC("DR")=DIC("DR")_";.17///"_$P(^BGPSITE(DUZ(2),0),U,6)
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY!" S BGPQUIT=1 G REPORTX
 S BGPRPT=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDPS(",DLAYGO=90374.04,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPR12_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)_";.16///"_$P(^BGPSITE(DUZ(2),0),U,4)
 S DIC("DR")=DIC("DR")_";.17///"_$P(^BGPSITE(DUZ(2),0),U,6)
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DINUM I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY!" S BGPQUIT=1 G REPORTX
 S BGPRPTP=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDBS(",DLAYGO=90374.05,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPR12_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)_";.16///"_$P(^BGPSITE(DUZ(2),0),U,4)
 S DIC("DR")=DIC("DR")_";.17///"_$P(^BGPSITE(DUZ(2),0),U,6)
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY!" S BGPQUIT=1 G REPORTX
 S BGPRPTB=+Y
 ;
 K ^BGPGPDCS(BGPRPT,9999)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPGPDCS(BGPRPT,9999,C,0)=X,^BGPGPDCS(BGPRPT,9999,"B",X,C)=""
 S ^BGPGPDCS(BGPRPT,9999,0)="^90374.12999A^"_C_"^"_C
 K ^BGPGPDCS(BGPRPT,1111)
 I $G(BGPMFITI) S C=0,X="" F  S X=$O(^ATXAX(BGPMFITI,21,"B",X)) Q:X=""  S C=C+1,Y=$P($G(^DIC(4,X,0)),U) S ^BGPGPDCS(BGPRPT,1111,C,0)=Y,^BGPGPDCS(BGPRPT,1111,"B",Y,C)=""
 S ^BGPGPDCS(BGPRPT,1111,0)="^90374.031111^"_C_"^"_C
 S ^BGPGPDCS(BGPRPT,99999,0)="^90374.129999A^0^0"
 S ^BGPGPDPS(BGPRPT,99999,0)="^90374.139999A^0^0"
 S ^BGPGPDBS(BGPRPT,99999,0)="^90374.149999A^0^0"
REPORTX ;
 I BGPERR]"" W !!,BGPERR
 I $G(BGPNPL) S BGPRTYPE=1
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 L -^BGPGPDCS
 L -^BGPGPDPS
 L -^BGPGPDBS
 Q
GETIEN ;EP -Get next ien available in all 3 files
 S BGPF=90374.03 D ENT
 S BGPF=90374.04 D ENT
 S BGPF=90374.05 D ENT
 S BGPIEN=$P(^BGPGPDCS(0),U,3)+1
S I $D(^BGPGPDPS(BGPIEN))!($D(^BGPGPDBS(BGPIEN))) S BGPIEN=BGPIEN+1 G S
 Q
 ;
ENT ;
 NEW GBL,NXT,CTR,XBHI,XBX,XBY,ANS
 S GBL=^DIC(BGPF,0,"GL")
 S GBL=GBL_"NXT)"
 S (XBHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S XBHI=NXT,CTR=CTR+1 ;W:'(CTR#50) "."
 S NXT="",XBX=$O(@(GBL)),XBX=^(0),XBY=$P(XBX,U,4),XBX=$P(XBX,U,3)
 S NXT=0,$P(@(GBL),U,3)=XBHI,$P(^(0),U,4)=CTR
 ;
EOJ ;
 KILL ANS,XBHI,XBX,XBY,CTR,DIC,FILE,GBL,L,NXT,BGPF
 Q
 ;
LZERO(V,L) ;EP
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
RZERO(V,L) ;EP
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
XTMP(N,D) ;EP
 Q:$G(N)=""
 S ^XTMP(N,0)=$$FMADD^XLFDT(DT,14)_"^"_DT_"^"_$G(D)
 Q
