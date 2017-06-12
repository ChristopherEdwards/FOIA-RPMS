APCLSIL1 ;IHS/CMI/LAB - ILI SURVEILLANCE; 
 ;;3.0;IHS PCC REPORTS;**24,25,26,27,28,29,30**;FEB 05, 1997;Build 27
 ;
WT(V) ;EP - get last wt
 NEW X,Y,Z
 S Y=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVMSR(X,2)),U,1)  ;ENTERED IN ERROR
 .Q:$$VAL^XBDIQ1(9000010.01,X,.01)'="WT"
 .S Y=$P(^AUPNVMSR(X,0),U,4)
 Q Y
HT(V) ;EP - get last wt
 NEW X,Y,Z
 S Y=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",V,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVMSR(X,2)),U,1)  ;ENTERED IN ERROR
 .Q:$$VAL^XBDIQ1(9000010.01,X,.01)'="HT"
 .S Y=$P(^AUPNVMSR(X,0),U,4)
 Q Y
HASADVN6(APCLV) ;EP - PATCH 27 - if return 1 then count visit and put pieces 2 through n in columns 66 through 75
 NEW X,P,Y,Z,APCLCLIN,T,G,C,D,CLNTAX,E
 S CLNTAX=$O(^ATXAX("B","SURVEILLANCE ILI CLINICS",0))
 I "AORSH"'[$P(^AUPNVSIT(APCLV,0),U,7) Q ""
 S APCLCLIN=$$CLINIC^APCLV(APCLV,"I")  ;get clinic code
 ;is there a PHN
 S X=0,P=0 F  S X=$O(^AUPNVPRV("AD",APCLV,X)) Q:X'=+X!(P)  D
 .Q:'$D(^AUPNVPRV(X,0))
 .S Y=$P(^AUPNVPRV(X,0),U)
 .S Z=$$VALI^XBDIQ1(200,Y,53.5)
 .Q:'Z
 .I $P($G(^DIC(7,Z,9999999)),U,1)=13 S P=1
 I P G HASADN61
 I $P(^AUPNVSIT(APCLV,0),U,7)'="H" I APCLCLIN="" Q ""
 I $P(^AUPNVSIT(APCLV,0),U,7)'="H" I '$D(^ATXAX(CLNTAX,21,"B",APCLCLIN)) Q ""  ;not in clinic taxonomy
HASADN61 ;
 S G=0,D="",E=""
 S C=0,P1=0,P2=0
 S X=0 F  S X=$O(^AUPNVPOV("AD",APCLV,X)) Q:X'=+X!(C>4)  D
 .S T=$P(^AUPNVPOV(X,0),U)
 .I $$ICD^APCLSILU(T,$O(^ATXAX("B","SURVEILLANCE ADV EVENTS DXS",0)),9) D SET6 Q
 .I $$ICD^APCLSILU(T,$O(^ATXAX("B","SURVEILLANCE ADV EVENTS LIVE",0)),9) D  Q
 ..S A=$$AGE^APCLSILU(DFN,2,$$VD^APCLV(APCLV))
 ..Q:A<24
 ..Q:A>59
 ..D SET6
 ..Q
 .I $$ICD^APCLSILU(T,$O(^ATXAX("B","SURVEILLANCE ADV EVENT FEBRILE",0)),9) D  Q
 ..S A=$$AGE^APCLSILU(DFN,2,$$VD^APCLV(APCLV))
 ..Q:A>59
 ..D SET6
 I 'C Q ""  ;no diagnosis
 Q 1_U_D_U_E
SET6 ;
 S C=C+1,P1=P1+1,P2=P2+1
 S $P(D,",",P1)=$$VAL^XBDIQ1(9000010.07,X,.01)
 S $P(E,",",P1)=$$VD^APCLV(APCLV)
 Q
OTHVAC(P,VD) ;EP - get all vaccine history up to this visit date
 NEW C,X,Y,V,G,Z,R,P1,P2
 S R="",X=0,G=0
 S C=0,P1=-1,P2=0
 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X!(C>34)  D
 .Q:'$D(^AUPNVIMM(X,0))
 .S V=$$VD^APCLV($P(^AUPNVIMM(X,0),U,3))
 .;Q:V<3100801
 .Q:V>VD
 .S Y=$P($G(^AUPNVIMM(X,0)),U)
 .Q:'Y
 .Q:'$D(^AUTTIMM(Y,0))
 .S Z=$P(^AUTTIMM(Y,0),U,3)
 .S C=C+1,P1=P1+2,P2=P2+2
 .S $P(R,",",P1)=Z
 .S $P(R,",",P2)=V
 .Q
 Q R
PN(P,V) ;EP
 I $P(^DPT(P,0),U,2)'="F" Q ""
 NEW T,X,Y,Q,ED,BD,APCL,LPD,%,G
 S ED=$$VD^APCLV(V)
 S BD=$$FMADD^XLFDT(ED,-60)
 S G=""
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DX",0))
 D ALLV^APCLAPIU(P,BD,ED,"APCL")
 I '$D(APCL) Q ""
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not asthma
 NEW APCLJ
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AORSHI"'[$P(^AUPNVSIT(V,0),U,7)
 .S (G,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^APCLSILU(Q,T,9)  ;not in taxonomy
 ..S G=1
 ..S APCLJ(9999999-$P(APCL(X),U,1))=$P(APCL(X),U,1)  ;set by date to eliminate 2 on same day
 .Q
 S LPD=$O(APCLJ(0))
 I LPD="" Q ""
 S LPD=9999999-LPD  ;date of prenatal dx, find miscarriage, abortion or delivery between this date and ED
 NEW APCLF
 S APCLF=""
 ;check abortion / misc dxs
 K APCL S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;K APCL S X=P_"^LAST PROC [BGP ABORTION PROCEDURES;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 K APCL S APCL=$$LASTPRCT^APCLSILU(P,LPD,ED,"BGP ABORTION PROCEDURES","D")
 I APCL Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT ABORTION","D")
 I %]"" Q ""
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT MISCARRIAGE","D")
 I %]"" Q ""
 K APCL S X=P_"^LAST DX [SURVEILLANCE H1N1 DELIVERY DX;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;K APCL S X=P_"^LAST PROC [SURVEILLANCE H1N1 DEL PROC;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 K APCL S APCL=$$LASTPRCT^APCLSILU(P,LPD,ED,"SURVEILLANCE H1N1 DEL PROC","D")
 I APCL Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"SURVEILLANCE H1N1 DELIVERY CPT","D")
 I %]"" Q ""
 Q "Y"
MONUP ;EP
 K APCLUP,APCLAC
 S APCLBD=$$FMADD^XLFDT(DT,-(3*365))
 S APCLCHS=$P(^BGPSITE(DUZ(2),0),U,6)
 S APCLFITI=$P(^BGPSITE(DUZ(2),0),U,9)
 S APCLDFN=0 F  S APCLDFN=$O(^AUPNPAT(APCLDFN)) Q:APCLDFN'=+APCLDFN  D
 .Q:'$D(^DPT(APCLDFN,0))
 .Q:$P(^DPT(APCLDFN,0),U)["DEMO,PATIENT"
 .Q:$$DEMO^APCLUTL(APCLDFN,"E")
 .Q:$P(^DPT(APCLDFN,0),U,19)  ;merged away
 .Q:$P($G(^AUPNPAT(APCLDFN,-9)),U)
 .;S G=0,X=0 F  S X=$O(^BGPSITE(X)) Q:X'=+X  I $P($G(^BGPSITE(X,0)),U,12) I $D(^DIBT($P(^BGPSITE(X,0),U,12),1,APCLDFN)) S G=1
 .;Q:G
 .S APCLACUP=0,APCLACCL=0
 .;S APCLX=0 F  S APCLX=$O(^BGPSITE(APCLX)) Q:APCLX'=+APCLX!(APCLACUP)  S APCLACUP=$$ACTUP(APCLDFN,APCLBD,DT,$P(^BGPSITE(APCLX,0),U,5),1)
 .S APCLACUP=$$ACTUP(APCLDFN,APCLBD,DT)
 .Q:'APCLACUP
 .S APCLAGE=$$AGE^AUPNPAT(APCLDFN,DT)
 .I APCLAGE=0 S X=$$FMDIFF^XLFDT(DT,$P(^DPT(APCLDFN,0),U,3)),X=X\30.5,X=$P(X,".",1) D
 ..I X<6 S APCLAGE="0-5 months" Q
 ..S APCLAGE="6-11 months"
 .;APCLUP(APCLAGE)=TOT UP^TOT UP ASTHMA^TOT UP DM^TOT UP PREG
 .S $P(APCLUP(APCLAGE),U,1)=$P($G(APCLUP(APCLAGE)),U,1)+1
 .S (APCLDM,APCLAST,APCLPREG)=0  ;set all flags to 0
 .S APCLDM=$$ASTDM^APCLSIL2(APCLDFN,DT)
 .S APCLAST=$P(APCLDM,U)
 .S APCLDM=$P(APCLDM,U,2)
 .S APCLPREG=$$PNM(APCLDFN,DT)
 .I APCLAST="Y" S $P(APCLUP(APCLAGE),U,2)=$P($G(APCLUP(APCLAGE)),U,2)+1
 .I APCLDM="Y" S $P(APCLUP(APCLAGE),U,3)=$P($G(APCLUP(APCLAGE)),U,3)+1
 .I APCLPREG="Y" S $P(APCLUP(APCLAGE),U,4)=$P($G(APCLUP(APCLAGE)),U,4)+1
 .S APCLACCL=$$ACTCL(APCLDFN,APCLBD,DT,APCLCHS)
 .Q:'APCLACCL
 .S $P(APCLAC(APCLAGE),U,1)=$P($G(APCLAC(APCLAGE)),U,1)+1
 .I APCLAST="Y" S $P(APCLAC(APCLAGE),U,2)=$P($G(APCLAC(APCLAGE)),U,2)+1
 .I APCLDM="Y" S $P(APCLAC(APCLAGE),U,3)=$P($G(APCLAC(APCLAGE)),U,3)+1
 .I APCLPREG="Y" S $P(APCLAC(APCLAGE),U,4)=$P($G(APCLAC(APCLAGE)),U,4)+1
 .Q
 ;FIND HIGHEST AGE
 S H="",X="" F  S X=$O(APCLUP(X)) Q:X'=+X  S H=X
 I '$D(APCLUP("0-5 months")) S APCLUP("0-5 months")="0^0^0^0"
 I '$D(APCLUP("6-11 months")) S APCLUP("6-11 months")="0^0^0^0"
 I '$D(APCLAC("0-5 months")) S APCLAC("0-5 months")="0^0^0^0"
 I '$D(APCLAC("6-11 months")) S APCLAC("6-11 months")="0^0^0^0"
 F X=1:1:H D
 .I '$D(APCLUP(X)) S APCLUP(X)="0^0^0^0"
 .I '$D(APCLAC(X)) S APCLAC(X)="0^0^0^0"
 ;write out file using xbgsave
 K ^APCLDATA($J)
 ;
 S C=1,^APCLDATA($J,C)="0-5 months"_","_+$P(APCLUP("0-5 months"),U,1)_","_+$P(APCLAC("0-5 months"),U,1) D
 .F P=2:1:4 S ^APCLDATA($J,C)=^APCLDATA($J,C)_","_+$P(APCLUP("0-5 months"),U,P)
 .F P=2:1:4 S ^APCLDATA($J,C)=^APCLDATA($J,C)_","_+$P(APCLAC("0-5 months"),U,P)
 ;
 S C=2,^APCLDATA($J,C)="6-11 months"_","_+$P(APCLUP("6-11 months"),U,1)_","_+$P(APCLAC("6-11 months"),U,1) D
 .F P=2:1:4 S ^APCLDATA($J,C)=^APCLDATA($J,C)_","_+$P(APCLUP("6-11 months"),U,P)
 .F P=2:1:4 S ^APCLDATA($J,C)=^APCLDATA($J,C)_","_+$P(APCLAC("6-11 months"),U,P)
 ;
 K APCLUP("0-5 months"),APCLUP("6-11 months"),APCLAC("0-5 months"),APCLAC("6-11 months")
 ;
 S X=0,C=2 F  S X=$O(APCLUP(X)) Q:X=""  S C=C+1,^APCLDATA($J,C)=X_","_+$P(APCLUP(X),U,1)_","_+$P(APCLAC(X),U,1) D
 .F P=2:1:4 S ^APCLDATA($J,C)=^APCLDATA($J,C)_","_+$P(APCLUP(X),U,P)
 .F P=2:1:4 S ^APCLDATA($J,C)=^APCLDATA($J,C)_","_+$P(APCLAC(X),U,P)
 ;
 S ^APCLDATA($J,0)=$P($G(^AUTTLOC(DUZ(2),1)),U,3)_","_(C+1)  ;COUNTS HEADER RECORD
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBGL="APCLDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="ILI SURVEILLANCE EXPORT-POPULATION"
 S APCLASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 ;S XBFN="FLUPOP_"_APCLASU_"_"_$$DATE^APCLSILI(DT)_".txt"
 NEW TST
 S TST=0
 ;I '$$PROD^XUPROD() S TST=1
 I $P($G(^APCLILIC(1,0)),U,5)="T" S TST=1
 S (XBFN,APCLDFN)=$S(TST:"FLZPOP",$G(APCLFLF):"FLFPOP",1:"FLUPOP")_"_"_APCLASU_"_"_$$DATE^APCLSILI(DT)_"_P30.txt"
 S XBS1="SURVEILLANCE ILI SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT ILI file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT ILI file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to IHS/CDC",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 K ^APCLDATA($J)
 Q
ACTUP(P,BDATE,EDATE) ;EP - is this patient in user pop?
 S X=$$LASTVD(P,BDATE,EDATE)
 Q $S(X:1,1:0)
 ;
ACTCL(P,BDATE,EDATE,CHS) ;EP - clinical user
 I CHS G CHSACTCL
 NEW APCLYR
 S APCLYR=$$GPRAIEN()
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(F)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(APCLFITI),'$D(^ATXAX(APCLFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S B=$$CLINIC^APCLV(V,"C")
 .Q:B=""
 .I 'G,$D(^BGPCTRL(APCLYR,11,"B",B)) S G=V  ;must be a primary clinic S G=V
 .I V'=G,$D(^BGPCTRL(APCLYR,12,"B",B)) S S=1
 .I G,S S F=1
 .Q
 Q $S(F:1,1:0)
 ;
GPRAIEN() ;EP
 ;---> Return GPRA Control File IEN
 ;
 ;---> Get the most recent GPRA Year Control file entry.
 N APCLYR,APCLPIEN
 S APCLYR=$O(^BGPCTRL("B",""),-1)
 Q:'APCLYR 0
 S APCLPIEN=$O(^BGPCTRL("B",APCLYR,0))
 Q:'APCLPIEN 0
 Q:('$G(^BGPCTRL(APCLPIEN,0))) 0
 Q APCLPIEN
 ;
CHSACTCL ;chs only sites active clinical defintion
 ;2 chs visits in past 3 years
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(F>1)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHOI"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"C"'[$P(^AUPNVSIT(V,0),U,3)
 .S F=F+1
 Q $S(F>1:1,1:0)
 ;
LASTVD(P,BDATE,EDATE) ;
 I '$D(^AUPNVSIT("AC",P)) Q ""
 K ^TMP($J,"A")
 S A="^TMP($J,""A"",",B=P_"^ALL VISITS;DURING "_$$FMTE^XLFDT(BDATE)_"-"_$$FMTE^XLFDT(EDATE),E=$$START1^APCLDF(B,A)
 I '$D(^TMP($J,"A",1)) Q ""
 S (X,G)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(G)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(APCLFITI),'$D(^ATXAX(APCLFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S G=1
 .Q
 Q G
 ;
PNM(P,ED) ;EP
 I $P(^DPT(P,0),U,2)'="F" Q ""
 NEW T,X,Y,Q,BD,APCL,LPD,%,G
 S BD=$$FMADD^XLFDT(ED,-60)
 S G=""
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DX",0))
 D ALLV^APCLAPIU(P,BD,ED,"APCL")
 I '$D(APCL) Q ""
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not asthma
 NEW APCLJ
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AORSHI"'[$P(^AUPNVSIT(V,0),U,7)
 .S (G,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^APCLSILU(Q,T,9)  ;not in taxonomy
 ..S G=1
 ..S APCLJ(9999999-$P(APCL(X),U,1))=$P(APCL(X),U,1)  ;set by date to eliminate 2 on same day
 .Q
 S LPD=$O(APCLJ(0))
 I LPD="" Q ""
 S LPD=9999999-LPD  ;date of prenatal dx, find miscarriage, abortion or delivery between this date and ED
 NEW APCLF
 S APCLF=""
 ;check abortion / misc dxs
 K APCL S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 K APCL S APCL=$$LASTPRCT^APCLSILU(P,LPD,ED,"BGP ABORTION PROCEDURES","D")
 I APCL Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT ABORTION","D")
 I %]"" Q ""
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT MISCARRIAGE","D")
 I %]"" Q ""
 K APCL S X=P_"^LAST DX [SURVEILLANCE H1N1 DELIVERY DX;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 I $D(APCL) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;K APCL S X=P_"^LAST PROC [SURVEILLANCE H1N1 DEL PROC;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCL(")
 K APCL S APCL=$$LASTPRCT^APCLSILU(P,LPD,ED,"SURVEILLANCE H1N1 DEL PROC","D")
 I APCL Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"SURVEILLANCE H1N1 DELIVERY CPT","D")
 I %]"" Q ""
 Q "Y"
