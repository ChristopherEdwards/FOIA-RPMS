BEHORXF2 ;MSC/IND/PLS -  XML Support for Pharmacy Rx Gen service ;19-Nov-2012 14:00;DU
 ;;1.1;BEH COMPONENTS;**009009**;Sep 18, 2007
 ;=================================================================
 ; RPC: BEHORXF2 DRUGTXT
 ; Returns data from 51.7 associated with drug
 ;
DRUGTXT(DATA,DRG) ;EP-
 S DATA=$NA(^TMP("PSSDIN",$J))
 D EN^PSSDIN(,DRG)
 Q
GETALG(DFN) ;EP Get allergy data
 N ALG,GMRAL,BEHI,BEHY
 S ALG=""
 D EN1^GMRADPT
 I $D(GMRAL)'>9 D
 . I $D(GMRAL),GMRAL=0 S ALG="Patient has answered NKA"
 . E  S ALG="No Allergy Assessment"
 S BEHI=0,BEHY=""
 F  S BEHI=$O(GMRAL(BEHI)) Q:+BEHI'>0  D
 . N X,Y,BEHX
 . S BEHX=$P($G(GMRAL(BEHI)),U,2)
 . S BEHY=$$APPEND(BEHX,BEHY,250)
 . I BEHY=BEHX
 . S ALG=BEHY
 Q ALG
APPEND(X,Y,LEN) ; Append ", "_X to Y, unless Y would excede LEN
 Q $S('$L(Y):X,($L(Y_$C(44)_" "_X)'>LEN):Y_$C(44)_" "_X,1:X)
WEIGHT(DFN) ;Get latest weight
 N MSR,VMSR,OUT
 S (WT,OUT)=""
 S VMSR=$$VMSR^BEHOVM
 S MSR="WT"
 D QRYGMR:'VMSR,QRYMSR:VMSR
 S WT=$P(OUT,U,1)
 Q WT
HT(DFN) ;Get latest height
 N MSR,VMSR,OUT
 S (HT,OUT)=""
 S VMSR=$$VMSR^BEHOVM
 S MSR="HT"
 D QRYGMR:'VMSR,QRYMSR:VMSR
 S HT=$P(OUT,U,1)
 Q HT
BMI(DFN) ; Get latest BMI
 N BMI,HT,WT,WTDT,X,HTDT,OUT
 S (BMI,OUT)=""
 S VMSR=$$VMSR^BEHOVM
 S MSR="WT"
 D QRYGMR:'VMSR,QRYMSR:VMSR
 S WT=$P(OUT,U,2),WTDT=$P(OUT,U,3)
 I '+WT G END
 S MSR="HT"
 D QRYGMR:'VMSR,QRYMSR:VMSR
 S HT=$P(OUT,U,2),HTDT=$P(OUT,U,3)
 I '+HT G END
 S BMI=""
 S WT=WT*.45359,HT=HT*.0254,HT=HT*HT,BMI=+$J(WT/HT,0,2)
 S OUT="BMI: "_BMI_" on  "_$$FMTDATE^BGOUTL(WTDT)
END Q OUT
QRYMSR ; Get data from V file
 N VDT,IEN,FOUND,DATE,VALUE,MSR2
 S OUT="",VDT=0
 S FOUND=0,MSR2=0
 S MSR2=$O(^AUTTMSR("B",MSR,MSR2))
 Q:'+MSR2
 F  S VDT=$O(^AUPNVMSR("AA",DFN,MSR2,VDT))  Q:('VDT)!(+FOUND)  D
 .S IEN=0
 .F  S IEN=$O(^AUPNVMSR("AA",DFN,MSR2,VDT,IEN)) Q:'IEN!(+FOUND)  D
 ..K BEH D ENP^XBDIQ1(9000010.01,IEN,".03;.04;2;1201","BEH(","I")
 ..Q:BEH(2,"I")=1
 ..S FOUND=1
 ..S DATE=$S($G(BEH(1201,"I"))]"":+BEH(1201,"I"),1:(9999999-VDT))
 ..I MSR="HT" S Y=$G(BEH(.04)),Y=$J(Y,5,2)_" in ["_$J((Y*2.54),5,2)_" cm]",VALUE=Y
 ..I MSR="WT" S Y=$G(BEH(.04)),Y=$J(Y,5,2)_" lb ["_$J((Y*.454),5,2)_" kg]",VALUE=Y
 ..S OUT=MSR_": "_VALUE_" on "_$$FMTDATE^BGOUTL(DATE)_U_$G(BEH(.04))_U_DATE
 Q
QRYGMR ;Get data from GMR file
 N VDT,IEN,FOUND,DATE,VALUE,MSR2
 S OUT="",VDT=0
 S FOUND=0,MSR2=0
 S MSR2=$O(^GMRD(120.51,"C",MSR,MSR2))
 Q:'+MSR2
 F  S IEN=$O(^GMR(120.5,"AA",DFN,MSR2,VDT)) Q:('VDT)!(+FOUND)  D
 .S IEN=0
 .F  S IEN=$O(^GMR(120.5,"AA",DFN,MSR2,VDT,IEN)) Q:'IEN!(+FOUND)  D
 ..K BEH D ENP^XBDIQ1(120.5,IEN,".01;1.2;2","BEH(","I")
 ..Q:BEH(2,"I")=1
 ..S FOUND=1
 ..S DATE=$G(BEH(.01,"I"))
 ..I MSR="HT" S Y=$G(BEH(1.2)),Y=$J(Y,5,2)_" in ["_$J((Y*2.54),5,2)_" cm]",VALUE=Y
 ..I MSR="WT" S Y=$G(BEH(1.2)),Y=$J(Y,5,2)_" lb ["_$J((Y*.454),5,2)_" kg]",VALUE=Y
 ..S OUT=MSR_": "_VALUE_" on "_$$FMTDATE^BGOUTL(DATE)_U_$G(BEH(1.2))_U_DATE
 Q
 ;Get RxNorm for order
RXNORM(POF) ;
 N RXNORM,DIEN,NDC
 S RXNORM=""
 S DIEN=$$GET1^DIQ(52.41,POF,11,"I")
 I +DIEN D
 .S NDC=$TR($P($G(^PSDRUG(DIEN,2)),U,4),"-","")
 .Q:'$L(NDC)
 .S RXNORM=+$O(^C0CRXN(176.002,"NDC",NDC,0))
 .S RXNORM=$$GET1^DIQ(176.002,RXNORM,.01)
 Q RXNORM
