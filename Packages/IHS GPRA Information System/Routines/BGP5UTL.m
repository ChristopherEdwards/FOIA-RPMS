BGP5UTL ; IHS/CMI/LAB - ;
 ;;7.0;IHS CLINICAL REPORTING;;JAN 24, 2007
 ;
 ;
 ;utility calls
 ;
STMP ;EP
 Q:BGPTIME'=1
 I BGPLIST="P",$P(^AUPNPAT(DFN,0),U,14)'=BGPLPRV Q
 X ^BGPINDV(BGPIC,2) Q:'$T
 S BGPLIST(BGPIC)=$G(BGPLIST(BGPIC))+1
 S ^XTMP("BGP5D",BGPJ,BGPH,"LIST",BGPIC,$S($P($G(^AUPNPAT(DFN,11)),U,18)]"":$P(^AUPNPAT(DFN,11),U,18),1:"UNKNOWN"),$P(^DPT(DFN,0),U,2),BGPAGEB,DFN)=$G(BGPVALUE)
 Q
D(D) ;EP
 I D="" Q ""
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)_$S($P(D,".",2)]"":$P(D,".",2),1:"")
JRNL ;EP
 N (DT,U,ZTQUEUED) S %=$$NOJOURN^ZIBGCHAR("BGPGPDCV"),%=$$NOJOURN^ZIBGCHAR("BGPGPDPV"),%=$$NOJOURN^ZIBGCHAR("BGPGPDBV"),%=$$NOJOURN^ZIBGCHAR("BGPHEDCV"),%=$$NOJOURN^ZIBGCHAR("BGPHEDPV"),%=$$NOJOURN^ZIBGCHAR("BGPHEDBV")
 S %=$$NOJOURN^ZIBGCHAR("BGPDATA"),%=$$NOJOURN^ZIBGCHAR("BGPGUI")
 S %=$$NOJOURN^ZIBGCHAR("BGPELDCV"),%=$$NOJOURN^ZIBGCHAR("BGPELDPV"),%=$$NOJOURN^ZIBGCHAR("BGPELDBV")
 Q
DATE(D) ;EP
 I D="" Q ""
 Q $E(D,4,5)_"/"_$E(D,6,7)_"/"_$E(D,2,3)
 ;
EXCELGS ;EP
 K BGPEXCT
 ;W:'$D(ZTQUEUED) !!,"writing out EISS file."
 S Y=$$OPEN^%ZISH(BGPUF,BGPFN,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file to write out EISS data.  Notify programmer." Q
 U IO
 S BGPX="",$P(BGPX,U,11)="Diabetes DX Ever",$P(BGPX,U,20)="Documented HbA1c",$P(BGPX,U,29)="Poor Glycemic Control",$P(BGPX,U,38)="Ideal Glycemic Control",$P(BGPX,U,47)="Controlled BP <130/80"
 S $P(BGPX,U,56)="LDL Assessed",$P(BGPX,U,65)="Nephropathy Assessed"
 S $P(BGPX,U,74)="Retinopathy Exam",$P(BGPX,U,83)="Dental Access Diabetes",$P(BGPX,U,92)="Dental Access General",$P(BGPX,U,101)="Dental Sealants",$P(BGPX,U,110)="Influenza 65+",$P(BGPX,U,119)="Pneumovax Ever 65+"
 S $P(BGPX,U,128)="Pap Smear Rates",$P(BGPX,U,137)="Mammogram Rates",$P(BGPX,U,146)="FAS Prevention",$P(BGPX,U,155)="IPV/DV Screen 15-40",$P(BGPX,U,164)="BMI Measured",$P(BGPX,U,173)="Tobacco Assessment"
 S $P(BGPX,U,182)="Public Health Nursing Total Visits"
 S $P(BGPX,U,191)="Blood Pressure Assessed"
 S $P(BGPX,U,200)="Childhood Immunizations"
 S $P(BGPX,U,209)="Colorectal Cancer Screening"
 S $P(BGPX,U,218)="Cholesterol Screening"
 S $P(BGPX,U,227)="Prenatal HIV Testing"
 S $P(BGPX,U,236)="Topical Fluoridation Patients"
 S $P(BGPX,U,245)="Topical Fluoridation Applications"
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
 S BGPX=0 F  S BGPX=$O(BGPEI(BGPX)) Q:BGPX'=+BGPX  W BGPEI(BGPX),!
 ;K BGPEI
 D ^%ZISC  ;close host file
EIF ;
 K BGPEXCT
 ;W:'$D(ZTQUEUED) !!,"writing out EISS file."
 I '$G(BGPAREAA) G Q
 S Y=$$OPEN^%ZISH(BGPUF,BGPFNEIS,"W")
 I Y=1 W:'$D(ZTQUEUED) !!,"Cannot open host file to write out EISS data.  Notify programmer." Q
 U IO
 S BGPX="",$P(BGPX,U,11)="Diabetes DX Ever",$P(BGPX,U,20)="Documented HbA1c",$P(BGPX,U,29)="Poor Glycemic Control",$P(BGPX,U,38)="Ideal Glycemic Control",$P(BGPX,U,47)="Controlled BP <130/80"
 S $P(BGPX,U,56)="LDL Assessed",$P(BGPX,U,65)="Nephropathy Assessed"
 S $P(BGPX,U,74)="Retinopathy Exam",$P(BGPX,U,83)="Dental Access Diabetes",$P(BGPX,U,92)="Dental Access General",$P(BGPX,U,101)="Dental Sealants",$P(BGPX,U,110)="Influenza 65+",$P(BGPX,U,119)="Pneumovax Ever 65+"
 S $P(BGPX,U,128)="Pap Smear Rates",$P(BGPX,U,137)="Mammogram Rates",$P(BGPX,U,146)="FAS Prevention",$P(BGPX,U,155)="IPV/DV Screen 15-40",$P(BGPX,U,164)="BMI Measured",$P(BGPX,U,173)="Tobacco Assessment"
 S $P(BGPX,U,182)="Public Health Nursing Total Visits"
 S $P(BGPX,U,191)="Blood Pressure Assessed"
 S $P(BGPX,U,200)="Childhood Immunizations"
 S $P(BGPX,U,209)="Colorectal Cancer Screening"
 S $P(BGPX,U,218)="Cholesterol Screening"
 S $P(BGPX,U,227)="Prenatal HIV Testing"
 S $P(BGPX,U,236)="Topical Fluoridation Patients"
 S $P(BGPX,U,245)="Topical Fluoridation Applications"
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
 S BGPX=0 F  S BGPX=$O(BGPEI(BGPX)) Q:BGPX'=+BGPX  I $P(^BGPGPDCV(BGPX,0),U,16)'="N" W BGPEI(BGPX),!
Q K BGPEI
 D ^%ZISC  ;close host file
 Q
GS ;EP
 K ^TMP($J)
 I $P($G(^BGPSITE(DUZ(2),0)),U,3)="N" Q
 L +^BGPDATA:300 E  W:'$D(ZTQUEUED) "Unable to lock global" Q
 ;NOTE:  Kill of unscripted global.  Export to area.  Using standard name.
 K ^BGPDATA S X="",C=0 F  S X=$O(^BGPGPDCV(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDCV(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDCV(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDCV(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDCV(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDCV(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDCV(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDCV(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDCV(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDCV(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDCV(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDCV(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDCV(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDCV(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDCV(BGPRPT,X,X2,X3,X4,X5)
 S X=0 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDCV"_"|"_^BGPDATA(X)
PRGS ;
 S S=C+1,X="" F  S X=$O(^BGPGPDPV(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDPV(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDPV(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDPV(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDPV(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDPV(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDPV(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDPV(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDPV(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDPV(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDPV(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDPV(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDPV(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDPV(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDPV(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDPV"_"|"_^BGPDATA(X)
BLGS ;save off baseline data
 S S=C+1,X="" F  S X=$O(^BGPGPDBV(BGPRPT,X)) Q:X'=+X!(X>99998)  D
 .I $G(^BGPGPDBV(BGPRPT,X))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",8)=^BGPGPDBV(BGPRPT,X)
 .S X2="" F  S X2=$O(^BGPGPDBV(BGPRPT,X,X2)) Q:X2'=+X2  D
 ..I $G(^BGPGPDBV(BGPRPT,X,X2))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",8)=^BGPGPDBV(BGPRPT,X,X2)
 ..S X3="" F  S X3=$O(^BGPGPDBV(BGPRPT,X,X2,X3)) Q:X3'=+X3  D
 ...I $G(^BGPGPDBV(BGPRPT,X,X2,X3))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",8)=^BGPGPDBV(BGPRPT,X,X2,X3)
 ...S X4="" F  S X4=$O(^BGPGPDBV(BGPRPT,X,X2,X3,X4)) Q:X4'=+X4  D
 ....I $G(^BGPGPDBV(BGPRPT,X,X2,X3,X4))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3,$P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",8)=^BGPGPDBV(BGPRPT,X,X2,X3,X4)
 ....S X5="" F  S X5=$O(^BGPGPDBV(BGPRPT,X,X2,X3,X4,X5)) Q:X5'=+X5  D
 .....I $G(^BGPGPDBV(BGPRPT,X,X2,X3,X4,X5))]"" S C=C+1,$P(^BGPDATA(C),"|")=X,$P(^BGPDATA(C),"|",2)=X2,$P(^BGPDATA(C),"|",3)=X3
 .....S $P(^BGPDATA(C),"|",4)=X4,$P(^BGPDATA(C),"|",5)=X5,$P(^BGPDATA(C),"|",8)=^BGPGPDBV(BGPRPT,X,X2,X3,X4,X5)
 S X=S-1 F  S X=$O(^BGPDATA(X)) Q:X'=+X  S ^BGPDATA(X)="BGPGPDBV"_"|"_^BGPDATA(X)
 NEW XBGL S XBGL="BGPDATA"
 S F="BG05"_$P(^AUTTLOC(DUZ(2),0),U,10)_"."_BGPRPT
 ;S F="BG05"_BGPRPT_"."_BGPRPT
 NEW XBFN,XBMED,XBF,XBFLT
 S XBMED="F",XBFN=F,XBTLE="SAVE OF GPRA DATA BY - "_$P(^VA(200,DUZ,0),U),XBF=0,XBFLT=1
 D ^XBGSAVE
 L -^BGPDATA
 K ^TMP($J),^BGPDATA ;NOTE:  kill of unsubscripted global for use in export to area.
 Q
REPORT ;EP
 S BGPRPT="",BGPERR=""
 I '$D(BGPGUI) W !!
 ;CREATE REPORT ENTRY IN FILEMAN FILE
 ;3 files must have the same ien
 L +^BGPGPDCV:30 I '$T S BGPERR="Unable to lock global, try later." G REPORTX
 L +^BGPGPDPV:30 I '$T S BGPERR="Unable to lock global, try later." G REPORTX
 L +^BGPGPDBV:30 I '$T S BGPERR="Unable to lock global, try later." G REPORTX
 D GETIEN
 I 'BGPIEN S BGPERR="Something wrong with control files, notify programmer!" S BGPRPT="" G REPORTX
 S DINUM=BGPIEN
 I $G(BGPNPL) S BGPRTYPE=4
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDCV(",DLAYGO=90371.03,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)_";.16///"_$P(^BGPSITE(DUZ(2),0),U,4)
 D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPT=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDPV(",DLAYGO=90371.04,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)_";.16///"_$P(^BGPSITE(DUZ(2),0),U,4)
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO,DINUM I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPTP=+Y
 K DIC S X=BGPBD,DIC(0)="L",DIC="^BGPGPDBV(",DLAYGO=90371.05,DIADD=1,DIC("DR")=".02////"_BGPED_";.03////"_BGPPBD_";.04////"_BGPPED_";.05////"_BGPBBD_";.06////"_BGPBED_";.07////"_$G(BGPPER)_";.08////"_$G(BGPQTR)
 S DIC("DR")=DIC("DR")_";.09////"_$P(^AUTTLOC(DUZ(2),0),U,10)_";.11////"_$E($P(^AUTTLOC(DUZ(2),0),U,10),1,4)_";.12////"_BGPRTYPE_";.13////"_DT_";.14////"_BGPBEN_";.15////"_$P($G(^AUTTLOC(DUZ(2),1)),U,3)_";.16///"_$P(^BGPSITE(DUZ(2),0),U,4)
 S DINUM=BGPRPT D ^DIC K DIC,DA,DR,DIADD,DLAYGO I Y=-1 S BGPERR="UNABLE TO CREATE REPORT FILE ENTRY - NOTIFY SITE MANAGER!" S BGPQUIT=1 G REPORTX
 S BGPRPTB=+Y
 ;add communities to 28 multiple
 K ^BGPGPDCV(BGPRPT,9999)
 S C=0,X="" F  S X=$O(BGPTAX(X)) Q:X=""  S C=C+1 S ^BGPGPDCV(BGPRPT,9999,C,0)=X,^BGPGPDCV(BGPRPT,9999,"B",X,C)=""
 S ^BGPGPDCV(BGPRPT,9999,0)="^90371.12999A^"_C_"^"_C
 S ^BGPGPDCV(BGPRPT,99999,0)="^90371.129999A^0^0"
 S ^BGPGPDPV(BGPRPT,99999,0)="^90371.139999A^0^0"
 S ^BGPGPDBV(BGPRPT,99999,0)="^90371.149999A^0^0"
REPORTX ;
 I BGPERR]"" W !!,BGPERR
 I $G(BGPNPL) S BGPRTYPE=1
 D ^XBFMK
 K DIC,DIADD,DLAYGO,DR,DA,DD,X,Y,DINUM
 L -^BGPGPDCV
 L -^BGPGPDPV
 L -^BGPGPDBV
 Q
GETIEN ;EP -Get next ien available in all 3 files
 S BGPF=90371.03 D ENT
 S BGPF=90371.04 D ENT
 S BGPF=90371.05 D ENT
 S BGPIEN=$P(^BGPGPDCV(0),U,3)+1
S I $D(^BGPGPDPV(BGPIEN))!($D(^BGPGPDBV(BGPIEN))) S BGPIEN=BGPIEN+1 G S
 Q
 ;
ENT ;
 NEW GBL,NXT,CTR,XBHI,XBX,XBY,ANS
 S GBL=^DIC(BGPF,0,"GL")
 S GBL=GBL_"NXT)"
 S (XBHI,NXT,CTR)=0
 F L=0:0 S NXT=$O(@(GBL)) Q:NXT'=+NXT  S XBHI=NXT,CTR=CTR+1 W:'(CTR#50) "."
 S NXT="",XBX=$O(@(GBL)),XBX=^(0),XBY=$P(XBX,U,4),XBX=$P(XBX,U,3)
 S NXT=0,$P(@(GBL),U,3)=XBHI,$P(^(0),U,4)=CTR
 ;
EOJ ;
 KILL ANS,XBHI,XBX,XBY,CTR,DIC,FILE,GBL,L,NXT,BGPF
 Q
 ;
LZERO(V,L) ;EP - left zero fill
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V="0"_V
 Q V
RZERO(V,L) ;EP - right zero fill 
 NEW %,I
 S %=$L(V),Z=L-% F I=1:1:Z S V=V_"0"
 Q V
