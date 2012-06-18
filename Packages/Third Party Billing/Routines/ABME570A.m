ABME570A ; IHS/ASDST/DMJ - UB92 V5 EMC RECORD 70-1 (Medical) cont'd ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;Original;DMJ;
 ;
 ; IHS/SD/SDR - v2.6 CSV
 ;
LOOP ;LOOP HERE
 F I=10:10:120 D
 .D @I
 .I $D(^ABMEXLM("AA",+$G(ABMP("INS")),+$G(ABMP("EXP")),70,I)) D @(^(I))
 .I '$G(ABMP("NOFMT")) S ABMREC(70)=$G(ABMREC(70))_ABMR(70,I)
 Q
 ;
10 ;Record type, 1-2
 S ABMR(70,10)=70
 Q
 ;
20 ;Sequence , 3-4
 S ABMR(70,20)="01"
 Q
 ;
30 ;Patient Control Number, 5-24 (SOURCE: FILE=9000001.41,FIELD=.02)
 S ABMR(70,30)=$$EX^ABMER20(30,ABMP("BDFN"))
 S ABMR(70,30)=$$FMT^ABMERUTL(ABMR(70,30),20)
 Q
 ;
40 ;Principle Diagnosis Code, 25-30 (SOURCE: FILE=9002274.4017 FIELD=.01)
 ; from locator #67
 D GET17
 S ABMR(70,40)=ABM(17,1)
 S ABMR(70,40)=$$FMT^ABMERUTL(ABMR(70,40),6)
 Q
 ;
50 ;Other Diagnosis Code #1, 31-36 (SOURCE: FILE=9002274.4017, FIELD=.01) 
 ; from locator #68
 D GET17
 S ABMR(70,50)=ABM(17,2)
 S ABMR(70,50)=$$FMT^ABMERUTL(ABMR(70,50),6)
 Q
 ;
60 ;Other Diagnosis Code #2, 37-42 (SOURCE: FILE=9002274.4017, FIELD=.01)
 ; from locator #69
 D GET17
 S ABMR(70,60)=ABM(17,3)
 S ABMR(70,60)=$$FMT^ABMERUTL(ABMR(70,60),6)
 Q
 ;
70 ;Other Diagnosis Code #3, 43-48 (SOURCE: FILE=9002274.4017, FIELD=.01)
 ; from locator #70
 D GET17
 S ABMR(70,70)=ABM(17,4)
 S ABMR(70,70)=$$FMT^ABMERUTL(ABMR(70,70),6)
 Q
 ;
80 ;Other Diagnosis Code #4, 49-54 (SOURCE: FILE=9002274.4017, FIELD=.01)
 ; from locator #71
 D GET17
 S ABMR(70,80)=ABM(17,5)
 S ABMR(70,80)=$$FMT^ABMERUTL(ABMR(70,80),6)
 Q
 ;
90 ;Other Diagnosis Code #5, 55-60 (SOURCE: FILE=9002274.4017, FIELD=.01)
 ; from locator #72
 D GET17
 S ABMR(70,90)=ABM(17,6)
 S ABMR(70,90)=$$FMT^ABMERUTL(ABMR(70,90),6)
 Q
 ;
100 ;Other Diagnosis Code #6, 61-66 (SOURCE: FILE=9002274.4017, FIELD=.01)
 ; from locator #73
 D GET17
 S ABMR(70,100)=ABM(17,7)
 S ABMR(70,100)=$$FMT^ABMERUTL(ABMR(70,100),6)
 Q
 ;
110 ;Other Diagnosis Code #7, 67-72 (SOURCE: FILE=9002274.4017, FIELD=.01)
 ; from locator #74
 D GET17
 S ABMR(70,110)=ABM(17,8)
 S ABMR(70,110)=$$FMT^ABMERUTL(ABMR(70,110),6)
 Q
 ;
120 ;Other Diagnosis Code #8, 73-78 (SOURCE: FILE=9002274.4017, FIELD=.01)     
 ; from locator #75
 D GET17
 S ABMR(70,120)=ABM(17,9)
 S ABMR(70,120)=$$FMT^ABMERUTL(ABMR(70,120),6)
 Q
 ;
GET17 ;GET DIAGNOSES CODES FROM BILL FILE
 Q:$D(ABM(17))
 N I,J
 S I=0,CNT=0
 F  S I=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",I)) Q:'I  D
 .S J=0
 .F  S J=$O(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,"C",I,J)) Q:'J  D
 ..S CNT=CNT+1
 ..S ABM(17,CNT)=$P(^ABMDBILL(DUZ(2),ABMP("BDFN"),17,J,0),U) ; ICD Diagnosis IEN
 ..S ABM(17,CNT)=$P($$DX^ABMCVAPI(+ABM(17,CNT),ABMP("VDT")),U,2) ; ICD Diagnosis code  ;CSV-c
 ..Q:$P($G(^ABMDEXP(ABMP("EXP"),1)),"^",5)'="E"
 ..S ABM(17,CNT)=$TR(ABM(17,CNT),".")
 F I=1:1:9 S:'$D(ABM(17,I)) ABM(17,I)=""
 Q
 ;
EX(ABMX,ABMY)      ;EXTRINSIC FUNCTION HERE
 ;
 ;  INPUT:  ABMX = data element
 ;          Y    = bill internal entry number
 ;
 ; OUTPUT:  Y    = bill internal entry number
 ;
 I '$G(ABMP("NOFMT")) S ABMP("FMT")=0
 D @ABMX
 S Y=ABMR(70,ABMX)
 I $D(ABMP("FMT")) S ABMP("FMT")=1
 K ABMR(70,ABMX),ABMX,ABMY
 Q Y
