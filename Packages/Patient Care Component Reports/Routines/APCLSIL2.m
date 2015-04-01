APCLSIL2 ; IHS/CMI/LAB - H1N1 SURVEILLANCE EXPORT 02 Nov 2009 8:28 AM ; 09 Dec 2009  2:54 PM
 ;;3.0;IHS PCC REPORTS;**22,23,24,25,26,27,28,29**;FEB 05, 1997;Build 35
 ;
 ;
SETREC ;EP - called from
 S C=","
 S APCLREC=$$UID(DFN)
 S $P(APCLREC,",",2)=$S($$HRN^AUPNPAT(DFN,APCLLOC)]"":$$HRN^AUPNPAT(DFN,APCLLOC),1:$$HRN^AUPNPAT(DFN,DUZ(2)))
 S $P(APCLREC,",",3)=$P(^DPT(DFN,0),U,2)
 S $P(APCLREC,",",4)=$P(^DPT(DFN,0),U,3)
 S $P(APCLREC,",",5)=$$COMMRES^AUPNPAT(DFN,"C")
 S $P(APCLREC,",",6)=$P(^AUTTLOC(APCLLOC,0),U,10)
 S $P(APCLREC,",",7)=APCLDATE
 ;povs
 S X=0,APCLC=7 S Y=$P(APCLILI,U,2,99) F X=1:1 S Z=$P(Y,U,X) Q:APCLC>9!(Z="")  I Z]"" S APCLC=APCLC+1,$P(APCLREC,",",APCLC)=Z
 S APCLTEMP=""
 S X=0 F  S X=$O(^AUPNVMSR("AD",APCLV,X)) Q:X'=+X  D
 .Q:$P($G(^AUPNVMSR(X,2)),U,1)
 .Q:$$VAL^XBDIQ1(9000010.01,X,.01)'="TMP"
 .S V=$P(^AUPNVMSR(X,0),U,4)
 .S APCLTEMP=$S(V>APCLTEMP:V,1:APCLTEMP)
 .S $P(APCLREC,",",11)="TMP^"_APCLTEMP_"^"_$$VD^APCLV(APCLV)
 S $P(APCLREC,",",12)=$S($P($G(^AUPNVSIT(APCLV,11)),U,14)]"":$P($G(^AUPNVSIT(APCLV,11)),U,14),1:$$UIDV^AUPNVSIT(APCLV))
 S $P(APCLREC,",",14)=$P(^AUPNVSIT(APCLV,0),U,13)
 S $P(APCLREC,",",15)=$P(^AUPNVSIT(APCLV,0),U,7)
 S $P(APCLREC,",",16)=$$DSCHTYPE(APCLV)
 S $P(APCLREC,",",17)=$$DSCHDATE(APCLV)
 S APCLREF="" I APCLH1N1!(APCLILI) S APCLREF=$$REF(APCLV) D
 .S $P(APCLREC,",",18)=$P(APCLREF,U)
 .S $P(APCLREC,",",19)=$P(APCLREF,U,2)
 S $P(APCLREC,",",21)=$P(APCLHVAC,U,2)
 S $P(APCLREC,",",22)=$P(APCLIVAC,U,2)
 S APCLASDM=$$ASTDM(DFN,$$VD^APCLV(APCLV))
 S $P(APCLREC,",",33)=$P(APCLASDM,U,1)
 S $P(APCLREC,",",34)=$P(APCLASDM,U,2)
 S APCLPN=$$PN^APCLSIL1(DFN,APCLV)
 S $P(APCLREC,",",36)=APCLPN
 S APCLBMI="" I APCLPN'="Y" S APCLBMI=$$BMI(DFN,$$VD^APCLV(APCLV))
 I APCLPN'="Y" S $P(APCLREC,",",35)=$$OB(DFN,$P(APCLBMI,U,1),$$AGE^AUPNPAT(DFN,$P(APCLBMI,U,6)))
 S $P(APCLREC,",",37)=$$R($P(APCLBMI,U,1))
 S $P(APCLREC,",",38)=$P(APCLBMI,U,6)
 S %=$$PNEU(DFN,DT)
 S $P(APCLREC,",",39)=$P(%,U,2)
 S $P(APCLREC,",",40)=$P(%,U,1)
 S $P(APCLREC,",",41)=$$CLINIC^APCLV(APCLV,"C")
 S $P(APCLREC,",",43)=$P(APCLH1N1,U,2)
 S $P(APCLREC,",",45)=$P(APCLSRD,U,2)
 S $P(APCLREC,",",46)=$P(APCLSRD,U,3)
 S $P(APCLREC,",",47)=$P(APCLSRD,U,4)
 S $P(APCLREC,",",48)=$P(APCLSRD,U,5)
 S $P(APCLREC,",",59)=$$STRIP^XLFSTR($P(APCLAVM,U,2),",")
 S $P(APCLREC,",",60)=$$STRIP^XLFSTR($P(APCLAVM,U,3),",")
 S $P(APCLREC,",",61)=$$STRIP^XLFSTR($P(APCLHVAC,U,3),",")
 S $P(APCLREC,",",62)=$$STRIP^XLFSTR($P(APCLHVAC,U,4),",")
 S $P(APCLREC,",",63)="p29"
 S $P(APCLREC,",",64)=$$STRIP^XLFSTR($P(APCLIVAC,U,3),",")
 S $P(APCLREC,",",65)=$$STRIP^XLFSTR($P(APCLIVAC,U,4),",")
 S $P(APCLREC,",",66)=$P(APCLADVE,U,2)
 S $P(APCLREC,",",71)=$P(APCLOVAC,",",1,36)
 S $P(APCLREC,",",107)=$P(APCLPVAC,U,2)
 S $P(APCLREC,",",108)=$P(APCLADVE,U,3)
 S $P(APCLREC,",",113)=APCLPCVF
 S $P(APCLREC,",",115)=APCLPCVE
 S $P(APCLREC,",",117)=APCLPCVA
 S $P(APCLREC,",",119)=APCLPCVS
 S $P(APCLREC,",",121)=APCLPCVI
 I APCLIVAC S $P(APCLREC,",",123)=APCLDATE
 I APCLHVAC S $P(APCLREC,",",124)=APCLDATE
 D
 .;PER EMAIL, USE WT AND HT FROM THE BMI CALCULATION, IF NO BMI USE MOST RECENT WT AND HT ON OR BEFORE VISIT DATE
 .I $P(APCLBMI,U,5)]"" S $P(APCLREC,",",125)="WT^"_$P(APCLBMI,U,5)_U_$P(APCLBMI,U,6) Q
 .S X=$$LASTITEM^APCLAPIU(DFN,"WT","MEASUREMENT",,$$VD^APCLV(APCLV),"A") I X]"" S $P(APCLREC,",",125)="WT^"_$P(X,U,3)_U_$P(X,U,1)
 D
 .I $P(APCLBMI,U,2)]"" S $P(APCLREC,",",126)="HT^"_$P(APCLBMI,U,2)_U_$P(APCLBMI,U,3) Q
 .S X=$$LASTITEM^APCLAPIU(DFN,"HT","MEASUREMENT",,$$VD^APCLV(APCLV),"A") I X]"" S $P(APCLREC,",",126)="HT^"_$P(X,U,3)_U_$P(X,U,1)
 S APCLVTOT=APCLVTOT+1
 S ^APCLDATA($J,APCLVTOT)=APCLREC
 Q
PNEU(P,EDATE) ;EP
 I $G(P)="" Q ""
 NEW V,X,Y,F,I,APCLLAST,T,X,BDATE,CVX
 S APCLLAST="",V=""
 S BDATE=$$DOB^AUPNPAT(P)
 S T=$O(^ATXAX("B","SURVEILLANCE PNEUMO CVX CODES",0))
 S X=0 F  S X=$O(^AUPNVIMM("AC",P,X)) Q:X'=+X  D
 .S I=$P($G(^AUPNVIMM(X,0)),U,1)
 .I 'I Q
 .S CVX=$P($G(^AUTTIMM(I,0)),U,3)
 .Q:CVX=""
 .I '$D(^ATXAX(T,21,"B",CVX)) Q  ;NOT IN TAXONOMY
 .S D=$P($$VALI^XBDIQ1(9000010.11,X,1201),".")
 .I D="" S D=$$VD^APCLV($P(^AUPNVIMM(X,0),U,3))
 .Q:D<BDATE
 .Q:D>EDATE
 .S V=D_U_"IMMUNIZATION"_U_CVX
 .D E
 S V=$$LASTITEM^APCLAPIU(P,"[BGP PNEUMO IZ DXS","DX",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:$$DOB^AUPNPAT(P)),EDATE,"A")
 I V]"" S V=$P(V,U,1)_U_"DX"_U_$$VAL^XBDIQ1($P(V,U,5),$P(V,U,6),.01)
 D E
 ;S V=$$LASTITEM^APCLAPIU(P,"[BGP PNEUMO IZ PROCEDURES","PROCEDURE",$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:$$DOB^AUPNPAT(P)),EDATE,"A")
 ;I V]"" S V=$P(V,U,1)_U_"DX"_U_$$VAL^XBDIQ1($P(V,U,5),$P(V,U,6),.01)
 ;D E
 S V=$$LASTCPTT^APCLAPIU(P,$S($P(APCLLAST,U)]"":$P(APCLLAST,U),1:$$DOB^AUPNPAT(P)),EDATE,"BGP PNEUMO IZ CPTS","A")
 I V]"" S %=$P(V,U,1)_U_"CPT"_U_$$VAL^XBDIQ1($P(V,U,5),$P(V,U,6),.01),V=%
 D E
 Q $P(APCLLAST,U,1)_U_$P(APCLLAST,U,3)
 ;
E ;
 I $P(V,U,1)>$P(APCLLAST,U,1) S APCLLAST=V
 Q
 ;
OB(P,BMI,A) ;EP obese
 NEW S,R
 I $G(BMI)="" Q ""
 S S=$P(^DPT(P,0),U,2)
 I S="" Q ""
 S R=0,R=$O(^APCLBMI("H",S,A,R))
 I 'R S R=$O(^APCLBMI("H",S,A)) I R S R=$O(^APCLBMI("H",S,R,""))
 I 'R Q ""
 I BMI>$P(^APCLBMI(R,0),U,7)!(BMI<$P(^APCLBMI(R,0),U,6)) Q ""
 I BMI'<$P(^APCLBMI(R,0),U,5) Q "Y"
 Q ""
R(V) ;EP
 I $G(V)="" Q ""
 I $L($P(V,".",2))<3 Q V
 S V=V+.005
 Q $P(V,".",1)_"."_$E($P(V,".",2),1,2)
BMI(P,EDATE) ;EP - get last calulable bmi as of EDATE and date of wt
 ;return value:  will be a "^" pieced string with the following pieces:
 ;   1 - BMI value  (not rounded)
 ;   2 - HT value used  (not rounded)
 ;   3 - Date of HT value used in internal fileman format
 ;   4 - visit ien of visit on which HT found
 ;   5 - WT used (not rounded)
 ;   6 - date of weight used
 ;   7 - visit ien of visit on which weight found
 ;
 ;NOTE:  any weight taken on a prenatal visit is excluded and a prior weight is used
 ;NOTE:  if you add warnings, please use the word WARNING (caps) in the error message
 ;NOTE:  pts <18 must have ht/wt on same day and within past year
 ;       pts >50 must have ht/wt within past 2 years
 ;       pts 19-50 must have ht/wt within past5 years
 ;
 NEW %,W,H,B,D,%DT,BDATE,AGE,WD,HD,VALUE,V,ERRC,ERR,BMI,CD,WD,HD,WV,HV,OW,OH
 S ERRC=0
 S VALUE=""
 I $G(EDATE)="" S EDATE=DT
 I $G(P)="" Q "^^^^^^^PATIENT DFN INVALID"
 I '$D(^AUPNPAT(P,0)) Q "^^^^^^^PATIENT DFN INVALID"
 I '$D(^DPT(P,0)) Q "^^^^^^^PATIENT DFN INVALID"
 S AGE=$$AGE^AUPNPAT(P,EDATE)
 S VALUE=""
 I AGE>18,AGE<50 D  Q VALUE
 .S BDATE=$$FMADD^XLFDT(EDATE,-(5*365))  ;5 yrs
 .S EDATE=$$FMTE^XLFDT(EDATE)
 .;get last weight on file
 .S V=$$WT(P,BDATE,EDATE)
 .S (W,OW)=$P(V,U,1)
 .I W=""!(W="?") S ERR="NO WEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S WD=$P(V,U,2)  ;weight date
 .S WV=$P(V,U,3)
 .S V=$$HT(P,BDATE,EDATE)
 .S (H,OH)=$P(V,U,1)
 .I H="" S ERR="NO HEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S HD=$P(V,U,2)
 .S HV=$P(V,U,3)
 .S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 .D SETV
 I AGE>49 D  Q VALUE
 .S BDATE=$$FMADD^XLFDT(EDATE,-(2*365))  ;2 yrs
 .S EDATE=$$FMTE^XLFDT(EDATE)
 .;get last weight on file
 .S V=$$WT(P,BDATE,EDATE)
 .S (W,OW)=$P(V,U,1)
 .I W=""!(W="?") S ERR="NO WEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S WD=$P(V,U,2)  ;weight date
 .S WV=$P(V,U,3)
 .S V=$$HT(P,BDATE,EDATE)
 .S (H,OH)=$P(V,U,1)
 .I H="" S ERR="NO HEIGHT FOUND ON OR PRIOR TO "_$$FMTE^XLFDT(EDATE) D ERR Q
 .S HD=$P(V,U,2)
 .S HV=$P(V,U,3)
 .S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 .D SETV
 .Q
 I AGE<19 D  Q VALUE
 .S BDATE=$$FMADD^XLFDT(EDATE,-365)
 .S EDATE=$$FMTE^XLFDT(EDATE)
 .S X=$$HTWTSD(P,BDATE,EDATE)
 .I '$P(X,"^") S ERR="NO WEIGHT FOUND ON SAME DAY AS HT ON OR PRIOR TO "_EDATE D ERR Q
 .I '$P(X,"^",4) S ERR="NO HEIGHT FOUND ON SAME DAY AS WT ON OR PRIOR TO "_EDATE D ERR Q
 .S (W,OW)=$P(X,"^")
 .S (H,OH)=$P(X,"^",4)
 .S WD=$P(X,U,2)
 .S WV=$P(X,U,3)
 .S HD=$P(X,U,5)
 .S HV=$P(X,U,6)
 .S W=W*.45359,H=(H*.0254),H=(H*H),BMI=(W/H)
 .D SETV
 .Q
 Q
HTWTSD(P,BDATE,EDATE) ;EP - get last ht / wt on same day
 I '$G(P) Q ""
 NEW APCLWTS,APCLHTS,%,X,APCLWTS1,APCLHTS1,Y
 ;get all hts during time frame
 S %=P_"^ALL MEAS HT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"APCLHTS(")
 S Y=0 F  S Y=$O(APCLHTS(Y)) Q:Y'=+Y  I $P(APCLHTS(Y),U,2)="?"!($P(APCLHTS(Y),U,2)="") K APCLHTS(Y)
 K APCLHTS1 S X=0 F  S X=$O(APCLHTS(X)) Q:X'=+X  S APCLHTS1($P(APCLHTS(X),U))=X
 ;get all wts during time frame
 S %=P_"^ALL MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"APCLWTS(")
 S Y=0 F  S Y=$O(APCLWTS(Y)) Q:Y'=+Y  I $P(APCLWTS(Y),U,2)="?"!($P(APCLWTS(Y),U,2)="") K APCLWTS(Y)
 ;set the array up by date
 K APCLWTS1 S X=0 F  S X=$O(APCLWTS(X)) Q:X'=+X  S APCLWTS1($P(APCLWTS(X),U))=X
 S APCLCHT="",X=9999999 F  S X=$O(APCLWTS1(X),-1) Q:X=""!(APCLCHT]"")  I $D(APCLHTS1(X))  D
 .S APCLCHT=$P(APCLWTS(APCLWTS1(X)),U,2)_U_$P(APCLWTS(APCLWTS1(X)),U,1)_U_$P(APCLWTS(APCLWTS1(X)),U,5)_U_$P(APCLHTS(APCLHTS1(X)),U,2)_U_$P(APCLHTS(APCLHTS1(X)),U,1)_U_$P(APCLHTS(APCLHTS1(X)),U,5)
 Q APCLCHT
 ;
HT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,APCLARRY,H,E
 S %=P_"^LAST MEAS HT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(%,"APCLARRY(")
 S H=$P($G(APCLARRY(1)),U,2)
 I H="" Q H
 I H["?" Q ""
 S H=H_U_$P(APCLARRY(1),U,1)_U_$P(APCLARRY(1),U,5)
 Q H
 ;
WT(P,BDATE,EDATE) ;EP
 I 'P Q ""
 NEW %,E,APCLLW,X,APCLLN,APCLL,APCLLD,APCLLZ,APCLLX,APCLICD
 K APCLL S APCLLW="" S APCLLX=P_"^LAST 24 MEAS WT;DURING "_BDATE_"-"_EDATE S E=$$START1^APCLDF(APCLLX,"APCLL(")
 S APCLLN=0 F  S APCLLN=$O(APCLL(APCLLN)) Q:APCLLN'=+APCLLN!(APCLLW]"")  D
 .S APCLLZ=$P(APCLL(APCLLN),U,5)
 .I '$D(^AUPNVPOV("AD",APCLLZ)) S APCLLW=$P(APCLL(APCLLN),U,2)_U_$P(APCLL(APCLLN),U,1)_U_$P(APCLL(APCLLN),U,5) Q
 . S APCLLD=0 F  S APCLLD=$O(^AUPNVPOV("AD",APCLLZ,APCLLD)) Q:'APCLLD!(APCLLW]"")  D
 .. S APCLICD=$P($$ICDDX^ICDCODE($P(^AUPNVPOV(APCLLD,0),U)),U,2) D
 ...Q:$$ICD^ATXCHK(APCLICD,$O(^ATXAX("B","SURVEILLANCE H1N1 PREGNANCY DXS",0)),9)
 ...S APCLLW=$P(APCLL(APCLLN),U,2)_U_$P(APCLL(APCLLN),U,1)_U_$P(APCLL(APCLLN),U,5)
 ..Q
 Q APCLLW
 ;
ERR ;EP
 S ERRC=ERRC+1
 NEW C
 S C=$P(VALUE,U,8)
 S $P(C,"|",ERRC)=ERR
 S $P(VALUE,U,8)=C
 Q
 ;
SETV ;EP
 S $P(VALUE,U,1)=BMI
 S $P(VALUE,U,2)=OH
 S $P(VALUE,U,3)=HD
 S $P(VALUE,U,4)=HV
 S $P(VALUE,U,5)=OW
 S $P(VALUE,U,6)=WD
 S $P(VALUE,U,7)=WV
 Q
 ;
ASTDM(P,EDATE) ;EP
 ;asthma active problem list
 NEW X,Y,Q,G,T,APCL,%,E,V,TD,APCLAS,APCLDM,APCLDMC,APCLASC
 S APCLAS="",APCLDM="",APCLASC=0,APCLDMC=0
 S T=$O(^ATXAX("B","BGP ASTHMA DXS",0))
 S TD=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 S G=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)="I"
 .Q:$P(^AUPNPROB(X,0),U,12)="D"
 .I $P(^AUPNPROB(X,0),U,8)>EDATE Q
 .S Q=$P(^AUPNPROB(X,0),U)
 .I $$ICD^ATXCHK(Q,T,9) S APCLAS="Y" Q
 .I $$ICD^ATXCHK(Q,TD,9) S APCLDM="Y" Q
 I APCLAS]"",APCLDM]"" Q APCLAS_U_APCLDM
 ;now for 2 povs on 2 different days, primary dx only, aorsh only
 D ALLV^APCLAPIU(P,,EDATE,"APCL")
 I '$D(APCL) Q APCLAS_U_APCLDM
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not asthma OR DM
 NEW APCLJ,APCLK
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X!(APCLAS]""&(APCLDM]""))  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AORSH"'[$P(^AUPNVSIT(V,0),U,7)
 .S Q=$$PRIMPOV^APCLV(V,"I")
 .Q:Q=""  ;no primary dx
 .I $$ICD^ATXCHK(Q,T,9),'$D(APCLJ($P(APCL(X),U,1))) S APCLJ($P(APCL(X),U,1))="",APCLASC=APCLASC+1 I APCLASC>1 S APCLAS="Y"  ;not in taxonomy
 .I $$ICD^ATXCHK(Q,TD,9),'$D(APCLK($P(APCL(X),U,1))) S APCLK($P(APCL(X),U,1))="",APCLDMC=APCLDMC+1 I APCLDMC>1 S APCLDM="Y"  ;not in taxonomy
 .Q
 Q APCLAS_U_APCLDM
DM(P,EDATE) ;EP
 ;dm on problem list
 NEW X,Y,Q,G,T,APCL,%,E,V,D
 S T=$O(^ATXAX("B","SURVEILLANCE DIABETES",0))
 S G=""
 S X=0 F  S X=$O(^AUPNPROB("AC",P,X)) Q:X'=+X!(G]"")  D
 .Q:'$D(^AUPNPROB(X,0))
 .Q:$P(^AUPNPROB(X,0),U,12)'="A"
 .I $P(^AUPNPROB(X,0),U,8)>EDATE Q  ;added after visit date
 .S Q=$P(^AUPNPROB(X,0),U)
 .Q:Q=""
 .Q:'$$ICD^ATXCHK(Q,T,9)
 .S G="Y"
 I G]"" Q G
 ;now for 2 povs on 2 different days
 D ALLV^APCLAPIU(P,,EDATE,"APCL")
 I '$D(APCL) Q ""
 ;now get rid of non-amb, non-H visits, and those whose primary dx is not DM
 NEW APCLJ
 S X=0 F  S X=$O(APCL(X)) Q:X'=+X  D
 .S V=$P(APCL(X),U,5)
 .Q:'$D(^AUPNVSIT(V,0))
 .Q:"AORSH"'[$P(^AUPNVSIT(V,0),U,7)
 .S Q=$$PRIMPOV^APCLV(V,"I")
 .Q:Q=""
 .Q:'$$ICD^ATXCHK(Q,T,9)  ;not in taxonomy
 .S APCLJ($P(APCL(X),U,1))=""  ;set by date to eliminate 2 on same day
 .Q
 I '$O(APCLJ(0)) Q ""
 K APCL
 S (X,Q)=0 F  S X=$O(APCLJ(X)) Q:X'=+X  S Q=Q+1
 I Q>1 Q "Y"
 Q ""
REF(V) ;EP
 ;is there a referral with a referral date of the visit date or 1 day later
 NEW B,E,X,Y,Z,P,C
 S C=""
 S B=$P($P(^AUPNVSIT(V,0),U),".")
 S E=$$FMADD^XLFDT($S($P(^AUPNVSIT(V,0),U,7)="H":$$DSCHDATE(V),1:B),1)
 S P=$P(^AUPNVSIT(V,0),U,5)
 S X=0 F  S X=$O(^BMCREF("D",P,X)) Q:X'=+X  D
 .S D=$P($G(^BMCREF(X,0)),U,1)
 .Q:D=""
 .I D<B Q
 .I D>E Q
 .I $P(^BMCREF(X,0),U,14)'="I"
 .S C="Y"_U_D
 .Q
 Q C
 ;
DSCHTYPE(V) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I $P(^AUPNVSIT(V,0),"^",7)'="H" Q ""
 NEW %,Y,Z
 I $P(^AUPNVSIT(V,0),"^",3)="C" G CHSDT
 S %="",Z=$O(^AUPNVINP("AD",V,0))
 I 'Z Q Z
 S Y=$$VALI^XBDIQ1(9000010.02,Z,.06)
 I 'Y Q ""
 I $P(^DD(9000010.02,.06,0),"^",2)[42.2 Q $P($G(^DIC(42.2,Y,0)),"^")
 I $P(^DD(9000010.02,.06,0),"^",2)[405.1 Q $P($G(^DG(405.1,Y,0)),"^")
 Q ""
CHSDT ;
 S Z=$O(^AUPNVCHS("AD",V,0)) I 'Z Q ""
 S Y=$$VAL^XBDIQ1(9000010.03,Z,.08)
 Q Y
DSCHDATE(V) ;EP
 I 'V Q ""
 I '$D(^AUPNVSIT(V)) Q ""
 I $P(^AUPNVSIT(V,0),"^",7)'="H" Q ""
 NEW Y,Z
 S Z=$O(^AUPNVINP("AD",V,0)) I 'Z G CHSDD
 S Y=$P(^AUPNVINP(Z,0),"^")
 I Y="" Q Y
 Q $P(Y,".")
CHSDD ;
 S Z=$O(^AUPNVCHS("AD",V,0)) I 'Z Q Z
 S Y=$P(^AUPNVCHS(Z,0),"^",7)
 I Y="" Q Y
 Q $P(Y,".")
 ;
DATE(D) ;
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
JDATE(D) ;EP
 I $G(D)="" Q ""
 NEW A
 S A=$$FMTE^XLFDT(D)
 Q $E(D,6,7)_$$UP^XLFSTR($P(A," ",1))_(1700+$E(D,1,3))
 ;
UID(APCLA) ;Given DFN return unique patient record id.
 I '$G(APCLA) Q ""
 I '$D(^AUPNPAT(APCLA)) Q ""
 ;
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(APCLA))_APCLA
 ;
