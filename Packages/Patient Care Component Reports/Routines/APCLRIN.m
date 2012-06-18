APCLRIN ; IHS/CMI/LAB - INTERNET ACCESS ;
 ;;2.0;IHS PCC SUITE;;MAY 14, 2009
 ;
 ;
START ;
INFORM ;
 W:$D(IOF) @IOF
 W !,$$CTR($$LOC)
 W !,$$CTR($$USR)
 W !!,"This report will tally the number of Patients with internet access"
 W !,"documented, the number with internet access and the method of internet"
 W !,"access.  You will be asked to run this for the user population, "
 W !,"the GPRA defined active clinical population or for a search template"
 W !,"of patients.",!!
 D EXIT
GROUP ;what set of patients
 S APCLGRP=""
 S DIR(0)="S^U:User Population (1 visit past 3 yrs);C:Active Clinical Patients (see GPRA definition);S:Search Template of Patients (created inQMAN, etc);A:ALL Patients"
 S DIR("A")="Which set of patients should the report include",DIR("B")="C"
 KILL DA D ^DIR KILL DIR
 G:$D(DIRUT) EXIT
 S APCLGRP=Y
 I APCLGRP="S" D TEMPLATE G:APCLSEAT="" GROUP  G DATE
COMM ;
 W !!,"User Population and Active Clinical Definitions usually only include"
 W !,"patients who live in communities in your service area.  You can "
 W !,"limit this report to patients in certain communities or you can include"
 W !,"all ",$S(APCLGRP="U":"User Population",APCLGRP="C":"Active Clinical",1:""),"patients or just those living in certain communities.",!
 K DIR
 W !,"Do you wish to limit the patients reviewed to those living in a particular set"
 S DIR(0)="Y",DIR("A")="of communities",DIR("B")="Y"
 KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G GROUP
 S APCLYN=Y
 I Y=0 S APCLTAXI="" G MFIC
 W !!,"Specify the community taxonomy to determine which patients will be",!,"included in the report.  You should have created this taxonomy using QMAN.",!
 K APCLTAX
 S APCLTAXI=""
 D ^XBFMK
 S DIC("S")="I $P(^(0),U,15)=9999999.05",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Community Taxonomy: "
 S B=$P($G(^BGPSITE(DUZ(2),0)),U,5) I B S DIC("B")=$P(^ATXAX(B,0),U)
 D ^DIC
 I Y=-1 Q
 S APCLTAXI=+Y
COM1 ;
 S X=0
 F  S X=$O(^ATXAX(APCLTAXI,21,X)) Q:'X  D
 .S APCLTAX($P(^ATXAX(APCLTAXI,21,X,0),U))=""
 .Q
 I '$D(APCLTAX) W !!,"There are no communities in that taxonomy." G COMM
 S X=0,G=0
 F  S X=$O(^ATXAX(APCLTAXI,21,X)) Q:'X  D
 .S C=$P(^ATXAX(APCLTAXI,21,X,0),U)
 .I '$D(^AUTTCOM("B",C)) W !!,"***  Warning: Community ",C," is in the taxonomy but was not",!,"found in the standard community table." S G=1
 .Q
 I G D  I APCLQUIT D EXIT Q
 .W !!,"These communities may have been renamed or there may be patients"
 .W !,"who have been reassigned from this community to a new community and this"
 .W !,"could reduce your patient population."
 .S APCLQUIT=0
 .S DIR(0)="Y",DIR("A")="Do you want to cancel the report and review the communities" KILL DA D ^DIR KILL DIR
 .I $D(DIRUT) S APCLQUIT=1
 .I Y S APCLQUIT=1
 .Q
MFIC K APCLQUIT
 I $P($G(^BGPSITE(DUZ(2),0)),U,8)=1 D  I APCLMFIY="" G COMM
 .S APCLMFIY=""
 .W !!,"Specify the LOCATION taxonomy to determine which patient visits will be"
 .W !,"used to determine whether a patient is in the denominators for the report."
 .W !,"You should have created this taxonomy using QMAN.",!
 .K APCLMFIT
 .S APCLMFIY=""
 .D ^XBFMK
 .S DIC("S")="I $P(^(0),U,15)=9999999.06",DIC="^ATXAX(",DIC(0)="AEMQ",DIC("A")="Enter the Name of the Location/Facility Taxonomy: "
 .S B=$P($G(^BGPSITE(DUZ(2),0)),U,9) I B S DIC("B")=$P(^ATXAX(B,0),U)
 .D ^DIC
 .I Y=-1 Q
 .S APCLMFIY=+Y
 ;
BEN ;
 S APCLBEN=""
 S DIR(0)="S^1:Indian/Alaskan Native (Classification 01);2:Not Indian Alaskan/Native (Not Classification 01);3:All (both Indian/Alaskan Natives and Non 01)",DIR("A")="Select Beneficiary Population to include in this report"
 S DIR("B")="1" KILL DA D ^DIR KILL DIR
 I $D(DIRUT) G COMM
 S APCLBEN=Y
 ;
DATE ;
 K APCLED,APCLBD
 W !!,"You can run this report based on the current status of patient's internet"
 W !,"or run it based on internet access data as of a certain date in the past.",!
 W !,"Please enter the 'As of Date', enter T for today to get current information.",!
 K DIR W ! S DIR(0)="DO^::EXP",DIR("A")="Enter as of Date"
 D ^DIR K DIR G:Y<1 BEN S APCLBD=Y
 ;
ZIS ;call to XBDBQUE
DEMO ;
 D DEMOCHK^APCLUTL(.APCLDEMO)
 I APCLDEMO=-1 G DATE
 S XBRP="PRINT^APCLRIN",XBRC="PROC^APCLRIN",XBRX="EXIT^APCLRIN",XBNS="APCL"
 D ^XBDBQUE
 D EXIT
 Q
EXIT ;clean up and exit
 D EN^XBVK("APCL")
 D ^XBFMK
 D KILL^AUPNPAT
 Q
TEMPLATE ;If Template was selected
 S APCLSEAT=""
 ;
 W ! S DIC("S")="I $P(^(0),U,4)=9000001!($P(^(0),U,4)=2)" S DIC="^DIBT(",DIC("A")="Enter Patient SEARCH TEMPLATE name: ",DIC(0)="AEMQ" D ^DIC K DIC,DA,DR,DICR
 I Y=-1 W !!,"No search template selected.",! H 2 Q
 S APCLSEAT=+Y
 Q
 ;
PROC ;
 K APCLDATA
 S APCLDATA("TOTAL PATS")=0
 S APCLDATA("W/DOC")=0
 S APCLDATA("YN","YES")=0
 S APCLDATA("YN","NO")=0
 S DFN=0 F  S DFN=$O(^AUPNPAT(DFN)) Q:DFN'=+DFN  D
 .Q:'$D(^DPT(DFN,0))
 .Q:$P(^DPT(DFN,0),U,19)  ;merged away
 .Q:$$DEMO^APCLUTL(DFN,$G(APCLDEMO))
 .K ^TMP($J,"A")
 .I APCLGRP="A" Q:'$$ALL^APCLRIN1(DFN,APCLBD,APCLTAXI,APCLBEN)
 .I APCLGRP="U" Q:'$$UP^APCLRIN1(DFN,$$FMADD^XLFDT(APCLBD,-(3*365)),APCLBD,APCLTAXI,APCLBEN)
 .I APCLGRP="C" Q:'$$ACTCL^APCLRIN1(DFN,$$FMADD^XLFDT(APCLBD,-(3*365)),APCLBD,APCLTAXI,APCLBEN,$P($G(^BGPSITE(DUZ(2),0)),U,6))
 .I APCLGRP="S" Q:'$D(^DIBT(APCLSEAT,1,DFN))  ;pt not in search template
 .S APCLDATA("TOTAL PATS")=$G(APCLDATA("TOTAL PATS"))+1
 .I '$D(^AUPNPAT(DFN,81)) Q  ;no internet access
 .I '$O(^AUPNPAT(DFN,81,0)) Q  ;no documentation of internet access
 .S %="" S D=0 F  S D=$O(^AUPNPAT(DFN,81,"B",D)) Q:D'=+D!(D>APCLBD)  S X=0 F  S X=$O(^AUPNPAT(DFN,81,"B",D,X)) Q:X'=+X  S %=1
 .Q:'%
 .S APCLDATA("W/DOC")=$G(APCLDATA("W/DOC"))+1
 .I $P(^DPT(DFN,0),U,2)="F" S APCLDATA("W/DOC","FEMALE")=$G(APCLDATA("W/DOC","FEMALE"))+1
 .I $P(^DPT(DFN,0),U,2)="M" S APCLDATA("W/DOC","MALE")=$G(APCLDATA("W/DOC","MALE"))+1
 .K APCLLYN,APCLLIM S D=0 F  S D=$O(^AUPNPAT(DFN,81,"B",D)) Q:D'=+D!(D>APCLBD)  S X=0 F  S X=$O(^AUPNPAT(DFN,81,"B",D,X)) Q:X'=+X  D
 ..S APCLLD=D
 ..S APCLLYN=$$GET1^DIQ(9000001.81,X_","_DFN_",",.02)
 ..S APCLLIM=$$GET1^DIQ(9000001.81,X_","_DFN_",",.03)
 .Q:'$D(APCLLYN)
 .S I=$S(APCLLYN="":"NO",1:APCLLYN) S APCLDATA("YN",I)=$G(APCLDATA("YN",I))+1
 .I I="YES" D
 ..I $P(^DPT(DFN,0),U,2)="F" S APCLDATA("HAS INTERNET","FEMALE")=$G(APCLDATA("HAS INTERNET","FEMALE"))+1
 ..I $P(^DPT(DFN,0),U,2)="M" S APCLDATA("HAS INTERNET","MALE")=$G(APCLDATA("HAS INTERNET","MALE"))+1
 ..I $$AGE^AUPNPAT(DFN,APCLLD)<18 S APCLDATA("YNAGE","< 18")=$G(APCLDATA("YNAGE","< 18"))+1
 ..I $$AGE^AUPNPAT(DFN,APCLLD)>17,$$AGE^AUPNPAT(DFN,APCLLD)<36 S APCLDATA("YNAGE","18-35")=$G(APCLDATA("YNAGE","18-35"))+1
 ..I $$AGE^AUPNPAT(DFN,APCLLD)>35,$$AGE^AUPNPAT(DFN,APCLLD)<56 S APCLDATA("YNAGE","36-55")=$G(APCLDATA("YNAGE","36-55"))+1
 ..I $$AGE^AUPNPAT(DFN,APCLLD)>55 S APCLDATA("YNAGE","> 55")=$G(APCLDATA("YNAGE","> 55"))+1
 ..S X=$$COMMRES^AUPNPAT(DFN,"E")
 ..I X="" S X="UNKNOWN"
 ..S APCLDATA("COM",X)=$G(APCLDATA("COM",X))+1
 .S I=$S(APCLLIM]"":APCLLIM,APCLLYN="NO":"",1:"NOT DOCUMENTED")
 .I I]"" S APCLDATA("IM",I)=$G(APCLDATA("IM",I))+1
 .Q
 K ^TMP($J,"A")
 Q
 ;
SUB ;
 W !!,?55,"#",?68,"%"
 W !,$$REPEAT^XLFSTR("-",80)
 Q
PRINT ;EP - called from xbdbque
 S APCLPG=0,APCLQUIT="",APCLQH="",APCLIOSL=$S($G(APCLGUI):55,1:IOSL)
 D HEADER
 I $Y>(APCLIOSL-15) D HDR I APCLQUIT Q
 ;D SUB
 W !!,"Total # of Patients ",?55,$$C($G(APCLDATA("TOTAL PATS")),0,7)
 W !!?2,"Total # w/Internet Access Screening ",?55,$$C($G(APCLDATA("W/DOC")),0,7)
 W ?68,$$PER(APCLDATA("W/DOC"),APCLDATA("TOTAL PATS"))
 ;W ?68,$$PER(APCLDATA("W/DOC"),APCLDATA("TOTAL PATS"))
 W !!?4,"# with Internet Access w/% of those screened ",?55,$$C($G(APCLDATA("YN","YES")),0,7)
 W ?68,$$PER(APCLDATA("YN","YES"),APCLDATA("W/DOC"))
 I $Y>(APCLIOSL-5) D HDR I APCLQUIT Q
 W !!?3,"GENDER BREAKDOWN:"
 W !?6,"# Females w/internet access",!?10,"with % of those with access",?55,$$C($G(APCLDATA("HAS INTERNET","FEMALE")),0,7)
 W ?68,$$PER($G(APCLDATA("HAS INTERNET","FEMALE")),$G(APCLDATA("YN","YES")))
 W !?6,"# Males w/internet access",!?10,"with % of those with access",?55,$$C($G(APCLDATA("HAS INTERNET","MALE")),0,7)
 W ?68,$$PER($G(APCLDATA("HAS INTERNET","MALE")),$G(APCLDATA("YN","YES")))
 I $Y>(APCLIOSL-7) D HDR I APCLQUIT Q
 W !!,"AGE BREAKDOWN:"
 W !?6,"# < 18 yrs old w/internet access",!?10,"with % of those with access",?55,$$C($G(APCLDATA("YNAGE","< 18")),0,7)
 W ?68,$$PER($G(APCLDATA("YNAGE","< 18")),$G(APCLDATA("YN","YES")))
 W !?6,"# 18-35 yrs old w/internet access",!?10,"with % of those with access",?55,$$C($G(APCLDATA("YNAGE","18-35")),0,7)
 W ?68,$$PER($G(APCLDATA("YNAGE","18-35")),$G(APCLDATA("YN","YES")))
 W !?6,"# 36-55 yrs old w/internet access",!?10,"with % of those with access",?55,$$C($G(APCLDATA("YNAGE","36-55")),0,7)
 W ?68,$$PER($G(APCLDATA("YNAGE","36-55")),$G(APCLDATA("YN","YES")))
 W !?6,"# > 55 yrs old w/internet access",!?10,"with % of those with access",?55,$$C($G(APCLDATA("YNAGE","> 55")),0,7)
 W ?68,$$PER($G(APCLDATA("YNAGE","> 55")),$G(APCLDATA("YN","YES")))
 I $Y>(APCLIOSL-10) D HDR I APCLQUIT Q
 W !!,"COMMUNITY BREAKDOWN: (w/ % of total with access)"
 S APCLX="" F  S APCLX=$O(APCLDATA("COM",APCLX)) Q:APCLX=""!(APCLQUIT)  D
 .I $Y>(APCLIOSL-2) D HDR I APCLQUIT Q
 .W !?6,APCLX,?55,$$C(APCLDATA("COM",APCLX),0,7)
 .W ?68,$$PER(APCLDATA("COM",APCLX),APCLDATA("YN","YES"))
 ;W ?68,$$PER(APCLDATA("YN","YES"),APCLDATA("TOTAL PATS"))
 ;W !!?4,"#  without Internet Access ",?45,$$C($G(APCLDATA("YN","NO")),0,7)
 ;W ?55,$$PER(APCLDATA("YN","NO"),APCLDATA("W/DOC"))
 ;W ?68,$$PER(APCLDATA("YN","NO"),APCLDATA("TOTAL PATS"))
 ;W !!?6,"Type of Internet Access: "
 ;I $Y>(APCLIOSL-4) D HDR Q:APCLQUIT  D SUB
 ;S APCLX="" F  S APCLX=$O(APCLDATA("IM",APCLX)) Q:APCLX=""!(APCLQUIT)  D
 ;.I $Y>(APCLIOSL-3) D HDR Q:APCLQUIT  D SUB
 ;.W !?8,APCLX
 ;.W ?45,$$C(APCLDATA("IM",APCLX),0,7)
 ;.W ?55,$$PER(APCLDATA("IM",APCLX),APCLDATA("YN","YES"))
 ;.W ?68,$$PER(APCLDATA("IM",APCLX),APCLDATA("TOTAL PATS"))
 Q
 ;
 ;
HEADER ;
 D HDR
 W !!,"PATIENTS INCLUDED IN THIS REPORT:",!
 I APCLGRP="U" W !?5,"User Population: ",$S(APCLBEN=1:"AI/AN Only (Classification 01)",APCLBEN=2:"non AI/AN Only (Classification NOT 01)",APCLBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 I APCLGRP="C" W !?5,"Active Clinical Population: ",$S(APCLBEN=1:"AI/AN Only (Classification 01)",APCLBEN=2:"non AI/AN Only (Classification NOT 01)",APCLBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 I APCLGRP="S" W !?5,"Population: Patients in Search Template:  ",$P(^DIBT(APCLSEAT,0),U)
 I APCLGRP="A" W !?5,"All Patients: ",$S(APCLBEN=1:"AI/AN Only (Classification 01)",APCLBEN=2:"non AI/AN Only (Classification NOT 01)",APCLBEN=3:"All (Both AI/AN and non AI/AN)",1:"")
 I $G(APCLTAXI)="" W !!,"All Communities Included.",! G MFIX
 W !?10,"Community Taxonomy Name: ",$P(^ATXAX(APCLTAXI,0),U)
 W !?10,"The following communities are included in this report:",! D
 .S APCLZZ="",APCLN=0,APCLY="" F  S APCLZZ=$O(APCLTAX(APCLZZ)) Q:APCLZZ=""!(APCLQH)  S APCLN=APCLN+1,APCLY=APCLY_$S(APCLN=1:"",1:";")_APCLZZ
 .S APCLZZ=0,C=0 F APCLZZ=1:3:APCLN D  Q:APCLQH
 ..I $Y>(APCLIOSL-2) D HDR Q:APCLQH
 ..W !?10,$E($P(APCLY,";",APCLZZ),1,20),?30,$E($P(APCLY,";",(APCLZZ+1)),1,20),?60,$E($P(APCLY,";",(APCLZZ+2)),1,20)
 ..Q
 Q:APCLQH
 I $G(APCLMFIY) W !!?10,"MFI Visit Location Taxonomy Name: ",$P(^ATXAX(APCLMFIY,0),U)
 I $G(APCLMFIY) W !?10,"The following Locations are used for patient visits in this report:",! D
 .S APCLZZ="",APCLN=0,APCLY="" F  S APCLZZ=$O(^ATXAX(APCLMFIY,21,"B",APCLZZ)) Q:APCLZZ=""  S APCLN=APCLN+1,APCLY=APCLY_$S(APCLN=1:"",1:";")_$P($G(^DIC(4,APCLZZ,0)),U)
 .S APCLZZ=0,C=0 F APCLZZ=1:3:APCLN D  Q:APCLQH
 ..I $Y>(APCLIOSL-2) D HDR Q:APCLQH
 ..W !?10,$E($P(APCLY,";",APCLZZ),1,20),?30,$E($P(APCLY,";",(APCLZZ+1)),1,20),?60,$E($P(APCLY,";",(APCLZZ+2)),1,20)
 ..Q
MFIX ;
 K APCLX,APCLY,APCLZZ,APCLN
 Q
HDR ;
 I 'APCLPG G HDR1
 K DIR I $E(IOST)="C",IO=IO(0) W ! S DIR(0)="EO" D ^DIR K DIR I Y=0!(Y="^")!($D(DTOUT)) S APCLQUIT=1 Q
HDR1 ;
 W:$D(IOF) @IOF
 S APCLPG=APCLPG+1
 W ?70,"Page ",APCLPG,!
 W !,$$CTR("*** PATIENT INTERNET ACCESS ***",80)
 W !,$$CTR("Date Report Run: "_$$FMTE^XLFDT(DT),80)
 W !,$$CTR("Site where Run: "_$P(^DIC(4,DUZ(2),0),U),80)
 W !,$$CTR("Report Generated by: "_$$USR,80)
 S X="Internet Access as of Date:  "_$$FMTE^XLFDT(APCLBD) W !,$$CTR(X,80)
 W !,$$REPEAT^XLFSTR("-",80)
 Q
CTR(X,Y) ;EP - Center X in a field Y wide.
 Q $J("",$S($D(Y):Y,1:IOM)-$L(X)\2)_X
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
LOC() ;EP - Return location name from file 4 based on DUZ(2).
 Q $S($G(DUZ(2)):$S($D(^DIC(4,DUZ(2),0)):$P(^(0),U),1:"UNKNOWN"),1:"DUZ(2) UNDEFINED OR 0")
 ;----------
PER(N,D) ;return % of n/d
 I 'D Q "0%"
 NEW Z
 S Z=N/D,Z=Z*100,Z=$J(Z,3,0)
 Q $$STRIP^XLFSTR(Z," ")_"%"
 ;
C(X,X2,X3) ;
 D COMMA^%DTC
 Q X
 ;Q $STRIP^XLFSTR(X," ")
 ;
PAD(D,L) ; -- SUBRTN to pad length of data
 ; -- D=data L=length
 S L=L-$L(D)
 Q $E($$REPEAT^XLFSTR(" ",L),1,L)_D
 ;
