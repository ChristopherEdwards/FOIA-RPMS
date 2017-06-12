BGP7D3B ; IHS/CMI/LAB - PNEUMO REMINDER 27 Feb 2015 7:52 AM ;
 ;;17.0;IHS CLINICAL REPORTING;;AUG 30, 2016;Build 16
 ;
I13 ;EP - PN
 NEW BGPTDAP,BGPTD,BGPFLU,BGPZOST,BGPPNEU,BGPPNEUD,BGPDTAPP
 F X=1:1:15 S Y="BGPD"_X S @Y=""
 F X=1:1:45 S Y="BGPN"_X S @Y=""
 I BGPAGEB>64,BGPACTUP S BGPD3=1
 I BGPDMD2 S BGPD2=1
 I BGPAGEB>64,BGPACTCL S BGPD1=1
 I BGPAGEB>17,BGPAGEB<65,BGPACTCL,$$HIGHRP^BGP7D3A(DFN,BGPEDATE) S BGPD4=1
 I BGPAGEB>17,BGPAGEB<65,BGPACTUP,$$HIGHRP^BGP7D3A(DFN,BGPEDATE) S BGPD5=1
 I BGPAGEB>17,BGPAGEB<65,BGPACTCL S BGPD6=1
 I BGPAGEB>17,BGPAGEB<65,BGPACTUP S BGPD7=1
 I BGPAGEB>17,BGPACTCL S BGPD8=1
 I BGPAGEB>17,BGPACTUP S BGPD9=1
 I BGPAGEB>18,BGPAGEB<60,BGPACTCL S BGPD10=1
 I BGPAGEB>18,BGPAGEB<60,BGPACTUP S BGPD11=1
 I BGPAGEB>59,BGPAGEB<65,BGPACTCL S BGPD12=1
 I BGPAGEB>59,BGPAGEB<65,BGPACTUP S BGPD13=1
 I BGPSEX="F" S X=$$PREG(DFN,BGPBDATE,BGPEDATE) I X S BGPD14=1  ;v16 pregnant women
 I BGPACTCL,BGPAGEB>18 S BGPD15=1  ;GPRA DEV V17 AC 19+
 I '(BGPD1+BGPD2+BGPD3+BGPD4+BGPD5+BGPD6+BGPD7+BGPD8+BGPD9+BGPD10+BGPD11+BGPD12+BGPD13+BGPD14) S BGPSTOP=1 Q
 S BGPVALUE="",BGPVALUD="",BGPPLPNU="",BGPDTAPP="",BGPTDAP=""
PN ;EP - called from elder
 S BGPVALUE=$$PNEU^BGP7D31(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE) ;set to date of PNEU shot
 I $P(BGPVALUE,U,3)=1!($P(BGPVALUE,U,3)=3) S BGPN1=1 ; ALL USERS HAD 1 EVER - 
 I $P(BGPVALUE,U,3)=3 S BGPN3=1  ;NMI EVER
 S BGPVAL=$$PNEU^BGP7D31(DFN,$$FMADD^XLFDT(BGPEDATE,-(5*365)),BGPEDATE)
 I $P(BGPVAL,U,3)=1!($P(BGPVAL,U,3)=3) S BGPN4=1  ;HAD IN PAST 5 YEARS SO "UP TO DATE"
 I $P(BGPVAL,U,3)=3 S BGPN6=1  ;NMI PAST 5 YRS
 ;65TH DOB DATE
 S B=$$DOB^AUPNPAT(DFN)
 S BGPA65BD=$E(B,1,3)+65_$E(B,4,7)
 S BGPN7=0,BGPA65="" I BGPAGEB>64 S BGPA65=$$PNEU^BGP7D31(DFN,BGPA65BD,BGPEDATE) I $P(BGPA65,U,3)=1!($P(BGPA65,U,3)=3) S BGPN4=1,BGPN7=1 ;65+ HAD AFTER 65TH DOB  BGPN4 IS UPTODATE
 I BGPAGEB<65,BGPN1 S BGPN4=1  ;anyone under and had 1 ever  ;BGPN4 IS UP TO DATE
 ;NATIONAL GPRA
 S BGPN8=0
 I BGPAGEB<65,BGPN1 S BGPN8=1  ;GPRA DEV UP TO DATE
 I BGPAGEB>64,BGPN1,(BGPN4+BGPN7) S BGPN8=1  ;IF 65+ HAD ONE IN PAST 5 YEARS OR AFTER AGE 65
 ;GPRA DEV V15.0
 D
 .S B=$$DOB^AUPNPAT(DFN)
 .S BGPA65BD=$E(B,1,3)+65_$E(B,4,7),BGPPNA65=""
 .;I BGPAGEB>64 S BGPPNA65=$$PNEUD(DFN,BGPA65BD,BGPEDATE)
 .;I BGPAGEB>64 I $P(BGPPNA65,U,3)=1!($P(BGPPNA65,U,3)=3) S BGPN37=1,BGPN28=1 ;HAD PNEUMO AFTER 65TH DOB UPTODATE
 .S (BGPPNEU,BGPPLPNU)=$$PNEUD(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE) ;set to date of PNEU shot EVER
 .I $P(BGPPNEU,U,3)=1!($P(BGPPNEU,U,3)=3) S BGPN23=1 ; ALL USERS HAD 1 EVER - 
 .I $P(BGPPNEU,U,3)=3 S BGPN24=1  ;NMI
 .S BGPPNEUD=$$PNEUD(DFN,$$FMADD^XLFDT(BGPEDATE,-(5*365)),BGPEDATE)
 .I $P(BGPPNEUD,U,3)=1!($P(BGPPNEUD,U,3)=3) S BGPN25=1,BGPN37=1  ;HAD IN PAST 5 YEARS SO "UP TO DATE"
 .I $P(BGPPNEUD,U,3)=3 S BGPN26=1  ;NMI PAST 5 YRS
 .S BGPN27=0,BGPA65="" I BGPAGEB>64 S BGPA65=$$PNEUD(DFN,BGPA65BD,BGPEDATE) I $P(BGPA65,U,3)=1!($P(BGPA65,U,3)=3) S BGPN25=1,BGPN27=1,BGPN37=1 ;over 65 and had one after 65
 .I BGPAGEB<65,BGPN23 S BGPN25=1,BGPN37=1  ;anyone under and had 1 ever  ;BGPN4 IS UP TO DATE
 ;GPRA DEV
 S BGPN28=0
 I BGPAGEB<65,BGPN23 S BGPN28=1  ;GPRA DEV UP TO DATE
 I BGPAGEB>64,BGPN23,(BGPN25+BGPN27) S BGPN28=1  ;IF UNDER 66 HAD 1 EVER, IF OVER 65 HAD ONE IN PAST 5 YEARS OR AFTER AGE 65
 I BGPN28 S BGPN37=1
 I 'BGPN37 S BGPPLPNU=$$PNEUCONJ(DFN,BGPBDATE,BGPEDATE) I $P(BGPPLPNU,U,3)=1!($P(BGPPLPNU,U,3)=3) S BGPN36=1,BGPN37=1
 I BGPPLPNU="" S BGPPLPNU=BGPPNEU
 S BGPDV=""
 I BGPRTYPE=1 S BGPDV="" D
 .I BGPD1 S BGPDV=BGPDV_$S(BGPDV]"":",AC",1:"AC")
 .I BGPD2 S BGPDV=BGPDV_$S(BGPDV]"":",AD",1:"AD")
 .I BGPN1 S BGPVALH=BGPVALUE,BGPVALUE=BGPDV_"|||" I BGPVALH]"" S BGPVALUE=BGPVALUE_"Pneumo: "_$$DATE^BGP7UTL($P(BGPVALH,U,1))_" "_$P(BGPVALH,U,2)_$S(BGPVALH]"":" (ever)",1:"")_" "_$S(BGPN8:" (up-to-date)",1:"") Q
 .S BGPVALUE=BGPDV_"|||"
 I BGPRTYPE=4 D
 .S BGPDV="UP"
 .I BGPD6!(BGPD1)!(BGPD8) S BGPDV=BGPDV_$S(BGPDV]"":",AC",1:"AC")
 .I BGPD4!(BGPD5) S BGPDV=BGPDV_$S(BGPDV]"":",HR",1:"HR")
 .I BGPD2 S BGPDV=BGPDV_$S(BGPDV]"":",AD",1:"AD")
 I BGPRTYPE=7 S BGPDV=$S(BGPD6:"AC",BGPD8:"AC",1:"") S:BGPD4 BGPDV=BGPDV_$S(BGPDV]"":",HR",1:"HR") S:BGPD2 BGPDV=BGPDV_$S(BGPDV]"":",AD",1:"AD")
 D
 .I BGPRTYPE'=1 S BGPVALH=BGPVALUE,BGPVALUE=BGPDV_"|||" I BGPVALH]"" S BGPVALUE=BGPVALUE_"Pneumo: "_$$DATE^BGP7UTL($P(BGPVALH,U,1))_" "_$P(BGPVALH,U,2)_$S(BGPVALH]"":" (ever)",1:"")_" "_$S(BGPN8:" (up-to-date)",1:"")
 .S BGPVALUD="AC"_"|||"
 .I BGPN28!(BGPN37) S BGPVALUD=BGPVALUD_"Pneumo: "_$$DATE^BGP7UTL($P(BGPPLPNU,U,1))_" "_$P(BGPPLPNU,U,2)_$S(BGPPLPNU]"":" (ever)",1:"")_" "
 .I BGPN28 S BGPVALUD=BGPVALUD_"(up-to-date)" ;_$S((BGPN28!(BGPN37)),'BGPN36:"(up-to-date)",1:"")
 .I BGPN36 S BGPVALUD=BGPVALUD_" (conj)"
TD ;new tdap and td stuff for v11.1
 S BGPTDAP=$$DTAP^BGP7D3A(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE)
 I BGPTDAP S BGPN9=1
 I $P(BGPTDAP,U,1)=2 S BGPN12=1
 S BGPTD=$$DTAPTD^BGP7D3A(DFN,$$FMADD^XLFDT(BGPEDATE,-(10*365)),BGPEDATE)
 I BGPTD S BGPN10=1
 I $P(BGPTD,U,1)=2 S BGPN11=1
 I BGPRTYPE=5 G TDE
 ;FLU - 14.1
 S BGPFLU=$$FLU^BGP7D3(DFN,,BGPEDATE)
 I $P(BGPFLU,U,3)=1!($P(BGPFLU,U,3)=3) S BGPN13=1
 I $P(BGPFLU,U,3)=3 S BGPN14=1
 I BGPN9,BGPN10,BGPN13 S BGPN15=1
 I BGPN9,BGPN10 S BGPN30=1  ;TD 10 YRS/TDAP EVER
 I BGPN11!(BGPN12)!(BGPN14) S BGPN16=1
 I BGPN11!(BGPN12) S BGPN31=1 ;1:1 CONTRA
 S BGPZOST=$$IZOSTER(DFN,$$DOB^AUPNPAT(DFN),BGPEDATE)
 I $P(BGPZOST,U,3)=1!($P(BGPZOST,U,3)=3) S BGPN17=1
 I $P(BGPZOST,U,3)=3 S BGPN18=1
 I BGPN9,BGPN10,BGPN13,BGPN17 S BGPN19=1
 I BGPN9,BGPN10,BGPN17 S BGPN32=1  ;1:1:1: TD/TDAP/ZOSTER
 I BGPN11!(BGPN12)!(BGPN14)!(BGPN18) S BGPN20=1
 I BGPN11!(BGPN12)!(BGPN18) S BGPN33=1  ;1:1:1 TD/TDAP/ZOSTER CONTRA
 I BGPN9,BGPN10,BGPN13,BGPN17,BGPN8 S BGPN21=1
 I BGPN9,BGPN10,BGPN17,BGPN8 S BGPN34=1
 I BGPN11!(BGPN12)!(BGPN14)!(BGPN18)!(BGPN3) S BGPN22=1
 I BGPN11!(BGPN12)!(BGPN18)!(BGPN3) S BGPN35=1
 I BGPN9,BGPN10,BGPN13,BGPN17,BGPN37 S BGPN29=1
 I BGPN9,BGPN10,BGPN17,BGPN37 S BGPN38=1
 ;NEW FOR V16.0
 S BGPTRIM=""
 I BGPD14 D
 .S BGPVALUD="AC;PREG|||"_$P(BGPVALUD,"|||",2)
 .S BGPFPRDX=$$FIRSTPDX^BGP7D3C(DFN,$$FMADD^XLFDT(BGPEDATE,-608),BGPEDATE)
 .;GET EDD
 .S BGPEDD=$$EDD^BGP7UTL2(DFN,BGPBDATE,BGPEDATE)
 .K BGPTDAPP
 .S D=BGPEDATE
 .I BGPEDD]"",BGPEDD<BGPEDATE S D=BGPEDD
 .S BGPTDAPP=$$LASTTDAP(DFN,BGPFPRDX,D)
 .I $E(BGPTDAPP) S BGPN39=1  ;A SHOT OR AN NMI
 .I $E(BGPTDAPP)=2 S BGPN40=1  ;NMI
 .I 'BGPN39 Q
 .;FIGURE OUT TRIMESTER
 .I BGPEDD D  Q
 ..;FIGURE OUT TRIMESTER FOR ALL TDAPS, IF ANY ARE 3RD USE IT, THEN DO 2ND, THEN DO 1ST
 ..;FIRST DAY OF PREG IS 280 DAYS BEFORE EDD
 ..NEW FB,FE,SB,SE,TB,TE
 ..S G=""
 ..S TB=$$FMADD^XLFDT(BGPEDD,-91)
 ..S TE=BGPEDD
 ..S SB=$$FMADD^XLFDT(BGPEDD,-182)
 ..S SE=$$FMADD^XLFDT(TB,-1)
 ..S FB=$$FMADD^XLFDT(BGPEDD,-280)
 ..S FE=$$FMADD^XLFDT(SB,-1)
 ..S X=$P(BGPTDAPP,U,2)
 ..I X'<TB,X'>TE S G=G_3
 ..I X'>SE,X'<SB S G=G_2
 ..I X>FB S G=G_1
 ..I G[3 S BGPN43=1,BGPTRIM="3rd Trimester" Q
 ..I G[2 S BGPN42=1,BGPTRIM="2nd Trimester" Q
 ..I G[1 S BGPN41=1,BGPTRIM="1st Trimester" Q
 ..I G="" S BGPN44=1,BGPTRIM="unk Trimester"
 .I BGPEDD="" D  ;try to find icd codes
 ..S X=$P(BGPTDAPP,U,2)  D
 ...;get all dxs tri, sec, 1st
 ...S G=""
 ...S Y=$$LASTDX^BGP7UTL1(DFN,"BGP PREGNANCY TRI 3 DXS",$$FMADD^XLFDT(X,-7),$$FMADD^XLFDT(X,7))
 ...I Y S G=G_3
 ...S Y=$$LASTDX^BGP7UTL1(DFN,"BGP PREGNANCY TRI 2 DXS",$$FMADD^XLFDT(X,-7),$$FMADD^XLFDT(X,7))
 ...I Y S G=G_2
 ...S Y=$$LASTDX^BGP7UTL1(DFN,"BGP PREGNANCY TRI 1 DXS",$$FMADD^XLFDT(X,-7),$$FMADD^XLFDT(X,7))
 ...I Y S G=G_1
 ..I G[3 S BGPN43=1,BGPTRIM="3rd Trimester" Q
 ..I G[2 S BGPN42=1,BGPTRIM="2nd Trimester" Q
 ..I G[1 S BGPN41=1,BGPTRIM="1st Trimester" Q
 ..I G="" S BGPN44=1,BGPTRIM="unk Trimester"
N ;
 ;GPRA DEV V17 AGE APPROPRIATE BGPN45
 I BGPD10,BGPN30 S BGPN45=1
 I BGPD12,BGPN32 S BGPN45=1
 I BGPD1,BGPN38 S BGPN45=1
 I BGPTDAP S BGPVALUE=BGPVALUE_$S($P(BGPVALUE,"|||",2)]"":"; ",1:""),BGPVALUE=BGPVALUE_"TDAP: "_$P(BGPTDAP,U,2)_" (ever)"
 I BGPTD S BGPVALUE=BGPVALUE_$S($P(BGPVALUE,"|||",2)]"":"; ",1:""),BGPVALUE=BGPVALUE_"TDAP/TD: "_$P(BGPTD,U,2)_" (past 10 yrs)"
 I BGPFLU S BGPVALUE=BGPVALUE_$S($P(BGPVALUE,"|||",2)]"":"; ",1:""),BGPVALUE=BGPVALUE_"FLU: "_$P(BGPFLU,U,2)_" (past yr)"
 I BGPZOST S BGPVALUE=BGPVALUE_$S($P(BGPVALUE,"|||",2)]"":"; ",1:""),BGPVALUE=BGPVALUE_"ZOSTER: "_$P(BGPZOST,U,2)_" (ever)"
 I BGPTDAP S BGPVALUD=BGPVALUD_$S($P(BGPVALUD,"|||",2)]"":"; ",1:""),BGPVALUD=BGPVALUD_"TDAP: "_$S($P(BGPDTAPP,U,3)]"":$P(BGPDTAPP,U,3),1:$P(BGPTDAP,U,2))_" (ever) "_$S(BGPTRIM]"":"("_BGPTRIM_")",1:"")
 I BGPTD S BGPVALUD=BGPVALUD_$S($P(BGPVALUD,"|||",2)]"":"; ",1:""),BGPVALUD=BGPVALUD_"TDAP/TD: "_$P(BGPTD,U,2)_" (past 10 yrs)"
 I BGPFLU S BGPVALUD=BGPVALUD_$S($P(BGPVALUD,"|||",2)]"":"; ",1:""),BGPVALUD=BGPVALUD_"FLU: "_$P(BGPFLU,U,2)_" (past yr)"
 I BGPZOST S BGPVALUD=BGPVALUD_$S($P(BGPVALUD,"|||",2)]"":"; ",1:""),BGPVALUD=BGPVALUD_"ZOSTER: "_$P(BGPZOST,U,2)_" (ever)"
TDE K BGPLPNU,BGPVAL,BGPA65,BGPVALH,BGPTD,BGPTDAP,BGPFLU,BGPTDAPP,BGPPNCON
 Q
IZOSTER(P,BDATE,EDATE,FORE) ;EP
 NEW BGPLPNU,BGPG,X,E,R,BD,ED,G,%
 S BGPLPNU=""
 S BD=BDATE
 S ED=EDATE
 S EDATE=$$FMTE^XLFDT(EDATE)
 S BDATE=$$FMTE^XLFDT(BDATE)
 S X=P_"^LAST IMM 121;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 121"
 S %=$$CPT^BGP7DU(P,BD,ED,$O(^ATXAX("B","BGP ZOSTER IZ CPTS",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)
 S %=$$TRAN^BGP7DU(P,BD,ED,$O(^ATXAX("B","BGP ZOSTER IZ CPTS",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)
 I BGPLPNU]"" Q BGPLPNU_U_1
 ;NOW CHECK FOR CONTRAINDICATION (NEW IN 8.0)
 F BGPZ=121 S X=$$ANIMCONT^BGP7D31(P,BGPZ,ED)
 I X]"" Q X_U_3
 ;NMI Refusal
 S G=$$NMIREF^BGP7UTL1(P,9999999.14,$O(^AUTTIMM("C",121,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S R=$$CPTREFT^BGP7UTL1(P,$$DOB^AUPNPAT(P),ED,$O(^ATXAX("B","BGP ZOSTER IZ CPTS",0)),"N")
 I R Q $P(R,U,2)_U_"NMI Refusal "_$P(R,U,4)_U_3
 Q ""
 ;
PNEUD(P,BDATE,EDATE,FORE) ;EP
 K BGPG
 S BGPLPNU=""
 S BD=BDATE
 S ED=EDATE
 S EDATE=$$FMTE^XLFDT(EDATE)
 S BDATE=$$FMTE^XLFDT(BDATE)
 S X=P_"^LAST IMM "_$S($$BI^BGP7D31:33,1:19)_";DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)) S BGPLPNU=$P(BGPG(1),U)_U_"Imm 33"
 S X=P_"^LAST IMM 109;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 109"
 K BGPG S %=P_"^LAST DX V03.82;DURING "_BDATE_"-"_EDATE,E=$$START1^APCLDF(%,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"POV "_$P(BGPG(1),U,2)
 S %=$$CPT^BGP7DU(P,BD,ED,$O(^ATXAX("B","BGP PNEUMO IZ CPT DEV",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)
 S %=$$TRAN^BGP7DU(P,BD,ED,$O(^ATXAX("B","BGP PNEUMO IZ CPT DEV",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)
 I BGPLPNU]"" Q BGPLPNU_U_1
 ;NOW CHECK FOR CONTRAINDICATION (NEW IN 8.0)
 F BGPZ=33,109 S X=$$ANCONT^BGP7D31(P,BGPZ,ED) Q:X]""
 I X]"" Q X_U_3
 ;NMI Refusal
 S G=$$NMIREF^BGP7UTL1(P,9999999.14,$O(^AUTTIMM("C",33,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP7UTL1(P,9999999.14,$O(^AUTTIMM("C",109,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S R=$$CPTREFT^BGP7UTL1(P,$$DOB^AUPNPAT(P),ED,$O(^ATXAX("B","BGP PNEUMO IZ CPT DEV",0)),"N")
 I R Q $P(R,U,2)_U_"NMI Refusal "_$P(R,U,4)_U_3
 Q ""
 ;
PNEUCONJ(P,BDATE,EDATE,FORE) ;EP
 K BGPG
 S BGPLPNU=""
 S BD=BDATE
 S ED=EDATE
 S EDATE=$$FMTE^XLFDT(EDATE)
 S BDATE=$$FMTE^XLFDT(BDATE)
 S X=P_"^LAST IMM 100;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 100"
 S X=P_"^LAST IMM 133;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 133"
 S X=P_"^LAST IMM 152;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(X,"BGPG(")
 I $D(BGPG(1)),$P(BGPLPNU,U,1)<$P(BGPG(1),U) S BGPLPNU=$P(BGPG(1),U,1)_U_"Imm 152"
 S %=$$CPT^BGP7DU(P,BD,ED,$O(^ATXAX("B","BGP PNEUMO CONJUGATE CPTS",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)_""
 S %=$$TRAN^BGP7DU(P,BD,ED,$O(^ATXAX("B","BGP PNEUMO CONJUGATE CPTS",0)),5)
 I $P(BGPLPNU,U,1)<$P(%,U,1) S BGPLPNU=$P(%,U,1)_U_"CPT "_$P(%,U,2)_""
 I BGPLPNU]"" Q BGPLPNU_U_1
 ;NOW CHECK FOR CONTRAINDICATION (NEW IN 8.0)
 F BGPZ=100,133,152 S X=$$ANCONT^BGP7D31(P,BGPZ,ED) Q:X]""
 I X]"" Q X_U_3
 ;NMI Refusal
 S G=$$NMIREF^BGP7UTL1(P,9999999.14,$O(^AUTTIMM("C",100,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP7UTL1(P,9999999.14,$O(^AUTTIMM("C",133,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S G=$$NMIREF^BGP7UTL1(P,9999999.14,$O(^AUTTIMM("C",152,0)),$$DOB^AUPNPAT(P),ED)
 I $P(G,U)=1 Q $P(G,U,2)_U_"NMI Refusal"_U_3
 S R=$$CPTREFT^BGP7UTL1(P,$$DOB^AUPNPAT(P),ED,$O(^ATXAX("B","BGP PNEUMO CONJUGATE CPTS",0)),"N")
 I R Q $P(R,U,2)_U_"NMI Refusal "_$P(R,U,4)_U_3
 Q ""
OPTOM ;EP
 G OPTOM^BGP7D213
LASTTDAP(P,BDATE,EDATE) ;EP
 NEW C,D,BGPX,X,Y,G,B,R,ID,BGPZ
 S BGPX=""
 S C=$O(^AUTTIMM("C",115,0))
 S D=0 F  S D=$O(^AUPNVIMM("AA",P,C,D)) Q:D'=+D!(BGPX)  D
 .S X=0 F  S X=$O(^AUPNVIMM("AA",P,C,D,X)) Q:X'=+X  D
 ..S ID=$P($P($G(^AUPNVIMM(X,12)),U),".")
 ..I ID="" Q:$P(^AUPNVIMM(X,0),U,3)=""
 ..I ID="" S ID=$$VD^APCLV($P(^AUPNVIMM(X,0),U,3))
 ..Q:ID<BDATE
 ..Q:ID>EDATE
 ..S BGPX=ID_U_$$DATE^BGP7UTL(ID)_" Imm 115"
 .Q
 ;now add in cpt codes if on different dates
 S C=+$$CODEN^ICPTCOD(90715)
 S D=$$CPTI^BGP7DU(P,BDATE,EDATE,C)
 I $P(D,U,2)>$P(BGPX,U,1) S BGPX=$P(D,U,2)_U_$$DATE^BGP7UTL(D)_" CPT 90715"
 I BGPX Q 1_U_BGPX
 ;now check contra/nmi
 F BGPZ=115 S X=$$ANCONT^BGP7D31(P,BGPZ,EDATE)
 I X]"" S BGPX=2_U_$P(X,U,1)_U_$$DATE^BGP7UTL($P(X,U,1))_" "_$P(X,U,2) Q BGPX
 ;now go to Refusals
 S B=$$DOB^AUPNPAT(P),E=EDATE,BGPNMI="",R=""
 F BGPIMM=115  D
 .S I=$O(^AUTTIMM("C",BGPIMM,0)) Q:'I
 .S X=0 F  S X=$O(^AUPNPREF("AA",P,9999999.14,I,X)) Q:X'=+X  S Y=0 F  S Y=$O(^AUPNPREF("AA",P,9999999.14,I,X,Y)) Q:Y'=+Y  S D=$P(^AUPNPREF(Y,0),U,3) I D'<B&(D'>E) D
 ..Q:$P(^AUPNPREF(Y,0),U,7)'="N"
 ..S R=D
 I R S BGPX=2_U_R_U_$$DATE^BGP7UTL(R)_" "_"NMI Dtap" Q BGPX
 S R="",B=+$$CODEN^ICPTCOD(90715)
 S G=$$NMIREF^BGP7UTL1(P,81,B,$$DOB^AUPNPAT(P),EDATE)
 I G S BGPX=2_U_$P(G,U,2)_U_$$DATE^BGP7UTL($P(G,U,2))_" "_"NMI Dtap 90715" Q G
 Q ""
PREG(P,BDATE,EDATE) ;
 I '$$PREG^BGP7D7(DFN,$$FMADD^XLFDT(EDATE,-608),EDATE,1,1) Q ""
 Q 1