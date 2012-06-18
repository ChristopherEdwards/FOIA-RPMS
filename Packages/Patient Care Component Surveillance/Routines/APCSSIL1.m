APCSSIL1 ;IHS/CMI/LAB - ILI SURVEILLANCE; 
 ;;2.0;IHS PCC SUITE;**5**;MAY 14, 2009
 ;
PN(P,V) ;EP
 I $P(^DPT(P,0),U,2)'="F" Q ""
 NEW T,X,Y,Q,ED,BD,APCS,LPD,%,G
 S ED=$$VD^APCLV(V)
 S BD=$$FMADD^XLFDT(ED,-60)
 S G=""
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DX",0))
 D ALLV^APCLAPIU(P,BD,ED,"APCS")
 I '$D(APCS) Q ""
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not asthma
 NEW APCSJ
 S X=0 F  S X=$O(APCS(X)) Q:X'=+X  D
 .S V=$P(APCS(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AORSHI"'[$P(^AUPNVSIT(V,0),U,7)
 .S (G,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S G=1
 ..S APCSJ(9999999-$P(APCS(X),U,1))=$P(APCS(X),U,1)  ;set by date to eliminate 2 on same day
 .Q
 S LPD=$O(APCSJ(0))
 I LPD="" Q ""
 S LPD=9999999-LPD  ;date of prenatal dx, find miscarriage, abortion or delivery between this date and ED
 NEW APCSF
 S APCSF=""
 ;check abortion / misc dxs
 K APCS S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 K APCS S X=P_"^LAST PROC [BGP ABORTION PROCEDURES;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT ABORTION","D")
 I %]"" Q ""
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT MISCARRIAGE","D")
 I %]"" Q ""
 K APCS S X=P_"^LAST DX [SURVEILLANCE H1N1 DELIVERY DX;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 K APCS S X=P_"^LAST PROC [SURVEILLANCE H1N1 DEL PROC;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"SURVEILLANCE H1N1 DELIVERY CPT","D")
 I %]"" Q ""
 Q "Y"
MONUP ;EP
 K APCSUP,APCSAC
 S APCSBD=$$FMADD^XLFDT(DT,-(3*365))
 S APCSCHS=$P(^BGPSITE(DUZ(2),0),U,6)
 S APCSFITI=$P(^BGPSITE(DUZ(2),0),U,9)
 S APCSDFN=0 F  S APCSDFN=$O(^AUPNPAT(APCSDFN)) Q:APCSDFN'=+APCSDFN  D
 .Q:'$D(^DPT(APCSDFN,0))
 .Q:$P(^DPT(APCSDFN,0),U)["DEMO,PATIENT"
 .Q:$$DEMO^APCLUTL(APCSDFN,"E")
 .Q:$P(^DPT(APCSDFN,0),U,19)  ;merged away
 .Q:$P($G(^AUPNPAT(APCSDFN,-9)),U)
 .;S G=0,X=0 F  S X=$O(^BGPSITE(X)) Q:X'=+X  I $P($G(^BGPSITE(X,0)),U,12) I $D(^DIBT($P(^BGPSITE(X,0),U,12),1,APCSDFN)) S G=1
 .;Q:G
 .S APCSACUP=0,APCSACCL=0
 .;S APCSX=0 F  S APCSX=$O(^BGPSITE(APCSX)) Q:APCSX'=+APCSX!(APCSACUP)  S APCSACUP=$$ACTUP(APCSDFN,APCSBD,DT,$P(^BGPSITE(APCSX,0),U,5),1)
 .S APCSACUP=$$ACTUP(APCSDFN,APCSBD,DT)
 .Q:'APCSACUP
 .S APCSAGE=$$AGE^AUPNPAT(APCSDFN,DT)
 .I APCSAGE=0 S X=$$FMDIFF^XLFDT(DT,$P(^DPT(APCSDFN,0),U,3)),X=X\30.5,X=$P(X,".",1) D
 ..I X<6 S APCSAGE="0-5 months" Q
 ..S APCSAGE="6-11 months"
 .;APCSUP(APCSAGE)=TOT UP^TOT UP ASTHMA^TOT UP DM^TOT UP PREG
 .S $P(APCSUP(APCSAGE),U,1)=$P($G(APCSUP(APCSAGE)),U,1)+1
 .S (APCSDM,APCSAST,APCSPREG)=0  ;set all flags to 0
 .S APCSDM=$$ASTDM^APCLSIL2(APCSDFN,DT)
 .S APCSAST=$P(APCSDM,U)
 .S APCSDM=$P(APCSDM,U,2)
 .S APCSPREG=$$PNM(APCSDFN,DT)
 .I APCSAST="Y" S $P(APCSUP(APCSAGE),U,2)=$P($G(APCSUP(APCSAGE)),U,2)+1
 .I APCSDM="Y" S $P(APCSUP(APCSAGE),U,3)=$P($G(APCSUP(APCSAGE)),U,3)+1
 .I APCSPREG="Y" S $P(APCSUP(APCSAGE),U,4)=$P($G(APCSUP(APCSAGE)),U,4)+1
 .S APCSACCL=$$ACTCL(APCSDFN,APCSBD,DT,APCSCHS)
 .Q:'APCSACCL
 .S $P(APCSAC(APCSAGE),U,1)=$P($G(APCSAC(APCSAGE)),U,1)+1
 .I APCSAST="Y" S $P(APCSAC(APCSAGE),U,2)=$P($G(APCSAC(APCSAGE)),U,2)+1
 .I APCSDM="Y" S $P(APCSAC(APCSAGE),U,3)=$P($G(APCSAC(APCSAGE)),U,3)+1
 .I APCSPREG="Y" S $P(APCSAC(APCSAGE),U,4)=$P($G(APCSAC(APCSAGE)),U,4)+1
 .Q
 ;FIND HIGHEST AGE
 S H="",X="" F  S X=$O(APCSUP(X)) Q:X'=+X  S H=X
 I '$D(APCSUP("0-5 months")) S APCSUP("0-5 months")="0^0^0^0"
 I '$D(APCSUP("6-11 months")) S APCSUP("6-11 months")="0^0^0^0"
 I '$D(APCSAC("0-5 months")) S APCSAC("0-5 months")="0^0^0^0"
 I '$D(APCSAC("6-11 months")) S APCSAC("6-11 months")="0^0^0^0"
 F X=1:1:H D
 .I '$D(APCSUP(X)) S APCSUP(X)="0^0^0^0"
 .I '$D(APCSAC(X)) S APCSAC(X)="0^0^0^0"
 ;write out file using xbgsave
 K ^APCSDATA($J)
 ;
 S C=1,^APCSDATA($J,C)="0-5 months"_","_+$P(APCSUP("0-5 months"),U,1)_","_+$P(APCSAC("0-5 months"),U,1) D
 .F P=2:1:4 S ^APCSDATA($J,C)=^APCSDATA($J,C)_","_+$P(APCSUP("0-5 months"),U,P)
 .F P=2:1:4 S ^APCSDATA($J,C)=^APCSDATA($J,C)_","_+$P(APCSAC("0-5 months"),U,P)
 ;
 S C=2,^APCSDATA($J,C)="6-11 months"_","_+$P(APCSUP("6-11 months"),U,1)_","_+$P(APCSAC("6-11 months"),U,1) D
 .F P=2:1:4 S ^APCSDATA($J,C)=^APCSDATA($J,C)_","_+$P(APCSUP("6-11 months"),U,P)
 .F P=2:1:4 S ^APCSDATA($J,C)=^APCSDATA($J,C)_","_+$P(APCSAC("6-11 months"),U,P)
 ;
 K APCSUP("0-5 months"),APCSUP("6-11 months"),APCSAC("0-5 months"),APCSAC("6-11 months")
 ;
 S X=0,C=2 F  S X=$O(APCSUP(X)) Q:X=""  S C=C+1,^APCSDATA($J,C)=X_","_+$P(APCSUP(X),U,1)_","_+$P(APCSAC(X),U,1) D
 .F P=2:1:4 S ^APCSDATA($J,C)=^APCSDATA($J,C)_","_+$P(APCSUP(X),U,P)
 .F P=2:1:4 S ^APCSDATA($J,C)=^APCSDATA($J,C)_","_+$P(APCSAC(X),U,P)
 ;
 N XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBGL="APCSDATA",XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBNAR="ILI SURVEILLANCE EXPORT-POPULATION"
 S APCSASU=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="FLUPOP_"_APCSASU_"_"_$$DATE^APCLSILI(DT)_".txt"
 S XBS1="SURVEILLANCE ILI SEND"
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" W:'$D(ZTQUEUED) !!,"VISIT ILI file successfully created",!!
 . I XBFLG(1)]"" W:'$D(ZTQUEUED) !!,"VISIT ILI file NOT successfully created",!!
 . W:'$D(ZTQUEUED) !,"File was NOT successfully transferred to IHS/CDC",!,"you will need to manually ftp it.",!
 . W:'$D(ZTQUEUED) !,XBFLG(1),!!
 K ^APCSDATA($J)
 Q
ACTUP(P,BDATE,EDATE) ;EP - is this patient in user pop?
 S X=$$LASTVD(P,BDATE,EDATE)
 Q $S(X:1,1:0)
 ;
ACTCL(P,BDATE,EDATE,CHS) ;EP - clinical user
 I CHS G CHSACTCL
 S (X,G,F,S)=0 F  S X=$O(^TMP($J,"A",X)) Q:X'=+X!(F)  S V=$P(^TMP($J,"A",X),U,5) D
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:'$P(^AUPNVSIT(V,0),U,9)
 .Q:$P(^AUPNVSIT(V,0),U,11)
 .Q:'$D(^AUPNVPRV("AD",V))
 .Q:"SAHO"'[$P(^AUPNVSIT(V,0),U,7)
 .Q:"V"[$P(^AUPNVSIT(V,0),U,3)
 .Q:$P(^AUPNVSIT(V,0),U,6)=""
 .I $G(APCSFITI),'$D(^ATXAX(APCSFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S B=$$CLINIC^APCLV(V,"C")
 .Q:B=""
 .I 'G,$D(^BGPCTRL($O(^BGPCTRL("B",2009,0)),11,"B",B)) S G=V  ;must be a primary clinic S G=V
 .I V'=G,$D(^BGPCTRL($O(^BGPCTRL("B",2009,0)),12,"B",B)) S S=1
 .I G,S S F=1
 .Q
 Q $S(F:1,1:0)
 ;
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
 .I $G(APCSFITI),'$D(^ATXAX(APCSFITI,21,"B",$P(^AUPNVSIT(V,0),U,6))) Q
 .S G=1
 .Q
 Q G
 ;
PNM(P,ED) ;EP
 I $P(^DPT(P,0),U,2)'="F" Q ""
 NEW T,X,Y,Q,BD,APCS,LPD,%,G
 S BD=$$FMADD^XLFDT(ED,-60)
 S G=""
 S T=$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DX",0))
 D ALLV^APCLAPIU(P,BD,ED,"APCS")
 I '$D(APCS) Q ""
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not asthma
 NEW APCSJ
 S X=0 F  S X=$O(APCS(X)) Q:X'=+X  D
 .S V=$P(APCS(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AORSHI"'[$P(^AUPNVSIT(V,0),U,7)
 .S (G,Y)=0 F  S Y=$O(^AUPNVPOV("AD",V,Y)) Q:Y'=+Y!(G)  D
 ..S Q=$P($G(^AUPNVPOV(Y,0)),U)
 ..Q:Q=""
 ..Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 ..S G=1
 ..S APCSJ(9999999-$P(APCS(X),U,1))=$P(APCS(X),U,1)  ;set by date to eliminate 2 on same day
 .Q
 S LPD=$O(APCSJ(0))
 I LPD="" Q ""
 S LPD=9999999-LPD  ;date of prenatal dx, find miscarriage, abortion or delivery between this date and ED
 NEW APCSF
 S APCSF=""
 ;check abortion / misc dxs
 K APCS S X=P_"^LAST DX [BGP MISCARRIAGE/ABORTION DXS;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 K APCS S X=P_"^LAST PROC [BGP ABORTION PROCEDURES;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT ABORTION","D")
 I %]"" Q ""
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"BGP CPT MISCARRIAGE","D")
 I %]"" Q ""
 K APCS S X=P_"^LAST DX [SURVEILLANCE H1N1 DELIVERY DX;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 K APCS S X=P_"^LAST PROC [SURVEILLANCE H1N1 DEL PROC;DURING "_LPD_"-"_ED S E=$$START1^APCLDF(X,"APCS(")
 I $D(APCS) Q ""  ;FOUND SO NOT PREG ANYMORE
 ;now check CPTs for Abortion and Miscarriage
 S %=$$LASTCPTT^APCLAPIU(P,LPD,ED,"SURVEILLANCE H1N1 DELIVERY CPT","D")
 I %]"" Q ""
 Q "Y"
