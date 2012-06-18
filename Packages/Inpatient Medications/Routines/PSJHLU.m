PSJHLU ;BIR/RLW-UTILITIES USED IN BUILDING HL7 SEGMENTS ;20 Apr 98 / 9:58 AM
 ;;5.0; INPATIENT MEDICATIONS ;**1,56,72,102**;16 DEC 97
 ;
 ; Reference to ^PS(52.6 is supported by DBIA# 1231.
 ; Reference to ^PS(52.7 is supported by DBIA# 2173.
 ;
INIT ; set up HL7 application variables
 S PSJHLSDT="PS",PSJHINST=$P($$SITE^VASITE(),"^")
 S PSJCLEAR="K FIELD F J=0:1:LIMIT S FIELD(J)="""""
 Q
 ;
SEGMENT(LIMIT) ;
 K SEGMENT
 N SUBSEG,SEGLENGT S SUBSEG=0,SEGMENT="" F J=0:1:LIMIT D
 .I SEGMENT']"" S SEGMENT=FIELD(J) Q
 .S SEGMENT=SEGMENT_"|"_FIELD(J)
 F  S SEGLENGT=$L(SEGMENT) D  Q:$L(SEGMENT)'>246
 .I SEGLENGT'>246 S SEGMENT(SUBSEG)=SEGMENT
 .I SEGLENGT>245 S SEGMENT(SUBSEG)=$E(SEGMENT,1,245),SUBSEG=SUBSEG+1 D
 ..S SEGMENT=$E(SEGMENT,246,SEGLENGT),SEGMENT(SUBSEG)=$E(SEGMENT,1,245)
SET S PSJI=PSJI+1,^TMP("PSJHLS",$J,PSJHLSDT,PSJI)=SEGMENT(0)
 F J=1:1 Q:'$D(SEGMENT(J))  S ^TMP("PSJHLS",$J,PSJHLSDT,PSJI,J)=SEGMENT(J)
 Q
 ;
CALL(HLEVN) ; call DHCP HL7 package -or- protocol, to pass Orders
 ; HLEVN = number of segments in message
 K CLERK,DDIEN,DDNUM,DOSEFORM,DOSEOR,FIELD,IVTYPE,LIMIT,NAME,NDNODE,NODE1,NODE2,PRODNAME,PROVIDER,PSGS0Y,PSJHINST,PSJHLSDT,PSJI,PSJORDER,PSOC,PSREASON,ROOMBED,SPDIEN,SEGMENT
 I $G(PSJBCBU)=1 M PSJNAME=^TMP("PSJHLS",$J,"PS") Q
 S PSJMSG="^TMP(""PSJHLS"",$J,""PS"")"
 D MSG^XQOR("PS EVSEND OR",.PSJMSG)
 Q
 ;
IVTYPE(PSJORDER) ; check whether a back-door order is Inpatient IV or IV fluid
 I RXORDER["V",$P($G(@(PSJORDER_"0)")),"^",4)'="A" Q "I"
 I RXORDER["P" I $P($G(@(PSJORDER_"0)")),"^",4)'="F" S IVTYPE="" Q IVTYPE
 N SUB,AD,SOL,IVTYPE,NODE1 S SUB=0,IVTYPE="F"
 ;naked reference on line below refers to the full indirect reference of PSJORDER_...
 F TYPE="AD","SOL" S SUB=0 F  S SUB=$O(@(PSJORDER_""""_TYPE_""""_","_SUB_")")) Q:(SUB="")!(IVTYPE="I")  S NODE1=$G(^(SUB,0)) Q:NODE1=""  D  Q:IVTYPE="I"
 .I TYPE="AD" D
 ..I '$P($G(^PS(52.6,$P(NODE1,"^"),0)),"^",13) S IVTYPE="I"
 .D:TYPE="SOL"
 ..S:'$P($G(^PS(52.7,$P(NODE1,"^"),0)),"^",13) IVTYPE="I"
 Q IVTYPE
ENI ;Calculate Frequency for IV orders
 N INFUSE
 K:$L(X)<1!($L(X)>30)!(X["""")!($A(X)=45) X I '$D(X) Q
 I X?.E1L.E S INFUSE=$$ENLU^PSGMI(X) Q:(INFUSE="TITRATE")!(INFUSE="BOLUS")
 Q:(X="TITRATE")!(X="BOLUS")
 I X["=" D  Q   ; NOIS LOU-0501-42191
 .N X2,X1 S X1=$P(X,"="),X2=$P(X,"=",2)
 .I X1["ML/HR",(+X1=$P(X1,"ML/HR"))!(+X1=$P(X1," ML/HR")) D
 ..S X1=$TR(X1,"ML/HR","ml/hr")
 .I X2["ML/HR",(+X2=$P(X2,"ML/HR"))!(+X2=$P(X2," ML/HR")) D
 ..S X2=$TR(X2,"ML/HR","ml/hr")
 .I X1[" ml/hr",(+X1=$P(X1," ml/hr")) D
 ..S X1=$P(X1," ml/hr")_$P(X1," ml/hr",2,9999)
 .I X2[" ml/hr",(+X2=$P(X2," ml/hr")) D
 ..S X2=$P(X2," ml/hr")_$P(X2," ml/hr",2,9999)
 .I X1["ml/hr",(+X1=$P(X1,"ml/hr")) D
 ..S X1=$P(X1,"ml/hr")_$P(X1,"ml/hr",2,9999)
 .I X2["ml/hr",(+X2=$P(X2,"ml/hr")) D
 ..S X2=$P(X2,"ml/hr")_$P(X2,"ml/hr",2,9999)
 .I X2'=+X2 D
 ..I ($P(X2,"@",2,999)'=+$P(X2,"@",2,999)!(+$P(X2,"@",2,999)<0)) K X Q
 .I X1=+X1 S X1=X1_" ml/hr"
 .I X2=+X2 S X2=X2_" ml/hr"
 .S:$P(X2,"@")=+X2 $P(X2,"@")=$P(X2,"@")_" ml/hr"
 .S X=X1_"="_X2
 I X'=+X,($P(X,"@",2,999)'=+$P(X,"@",2,999)!(+$P(X,"@",2,999)<0)),($P(X," ml/hr")'=+$P(X," ml/hr")!(+$P(X," ml/hr")<0)) K X Q
 I X=+X S X=X_" ml/hr" D SPSOL S FREQ=$S('X:0,1:SPSOL\X*60+(SPSOL#X/X*60+.5)\1) K SPSOL Q
 I X[" ml/hr" D SPSOL S FREQ=$S('X:0,1:SPSOL\X*60+(SPSOL#X/X*60+.5)\1) K SPSOL Q
 S SPSOL=$P(X,"@",2) S:$P(X,"@")=+X $P(X,"@")=$P(X,"@")_" ml/hr" S FREQ=$S('SPSOL:0,1:1440/SPSOL\1) K SPSOL
 Q
SPSOL S SPSOL=+TVOLUME Q
