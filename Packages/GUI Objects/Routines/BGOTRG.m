BGOTRG ; IHS/BAO/TMD - Triage Summary ;15-Dec-2010 11:50;DU
 ;;1.1;BGO COMPONENTS;**1,3,5,6,7**;Mar 20, 2007
 ; RPC: Returns triage summary information
 ;  INP = Visit IEN ^ Provider ^ Report List ^ Include CC Author
GETSUM(RET,INP) ;EP
 N VIEN,V0,DFN,DAT,PRV,CTL,RTN,SEQ,SCT,SEX
 S RET=$$TMPGBL^BGOUTL
 S VIEN=+INP
 Q:'VIEN
 S V0=$G(^AUPNVSIT(VIEN,0))
 Q:'V0
 S DAT=V0\1,DFN=+$P(V0,U,5),SEX=$P($G(^DPT(DFN,0)),U,2)
 S PRV=$P(INP,U,2)
 S:'PRV PRV=+$$PRIPRV^BGOUTL(VIEN)
 S CTL=$TR($P(INP,U,3),";-",",")
 S:CTL="" CTL="1,2,3,4,5,6,7,8,9,10,11"
 F SEQ=1:1 Q:'$L(CTL)  S SEQ(SEQ)=$P(CTL,",")\1,CTL=$P(CTL,",",2,999)
 S (SEQ,SCT)=0
 F  S SEQ=$O(SEQ(SEQ)) Q:'SEQ  D
 .N LP,CNT
 .S RTN="GET"_SEQ(SEQ)
 .S CTL=$P($T(@RTN),";;",2,999)
 .Q:'$L(CTL)
 .S (CNT,LP)=0
 .D @RTN,ADDHDR
 Q
GET1 ;;Chief Complaint^
 N CC,TYPE,AUTH,X,N
 S TYPE=$O(^AUTTNTYP("B","CHIEF COMPLAINT",0))
 Q:'TYPE
 S AUTH=+$P(INP,U,4)
 F  S LP=$O(^AUPNVNT("AD",VIEN,LP)) Q:'LP  D
 .Q:$P($G(^AUPNVNT(LP,0)),U)'=TYPE
 .I AUTH D
 ..S X=$P($G(^AUPNVNT(LP,12)),U,4)
 ..D:X APPEND($P($G(^VA(200,X,0)),U)_":")
 .S N=0
 .F  S N=$O(^AUPNVNT(LP,11,N)) Q:'N  D APPEND($G(^(N,0)))
 .D ADDHDR
 S X=$P($G(^AUPNVSIT(VIEN,14)),U)
 D:$L(X) APPEND(X)
 Q
GET2 ;;Vitals^;
 N MSR,TYP,EIE,VAL,VAL2,AGE,X,WT,HT,MR,BEH,DATA,DEFAULT,DEFU,ALTU
 F  S LP=$O(^AUPNVMSR("AD",VIEN,LP)) Q:'LP  D
 .S MSR=$G(^AUPNVMSR(LP,0)),X=+$G(^(12))
 .Q:'MSR
 .;IHS/MSC/MGH  Quit if entered in error
 .S EIE=$$GET1^DIQ(9000010.01,LP,2,"I")
 .Q:EIE=1
 .S TYP=$P(^AUTTMSR(+MSR,0),U),VAL=$P(MSR,U,4),MR=""
 .S AGE=$$PTAGE^BGOUTL(DFN,$S(X:X,1:DAT))
 .S BEH="" S BEH=$O(^BEHOVM(90460.01,"B",TYP,BEH))
 .I TYP="" D APPEND(TYP_": "_$$RND(VAL),MR)
 .E  D
 ..S DATA=$G(^BEHOVM(90460.01,BEH,0))
 ..S DEFAULT=$p(DATA,U,2)
 ..I DEFAULT=1 D
 ...S DEFU=$P(DATA,U,4),ALTU=$P(DATA,U,3)
 ...I ALTU=""!(DEFU=ALTU) D APPEND(TYP_": "_$$RND(VAL)_" "_DEFU)
 ...E  S X=VAL I $D(^BEHOVM(90460.01,BEH,2)) X $G(^BEHOVM(90460.01,BEH,2)) D APPEND(TYP_": "_$$RND(VAL)_" "_DEFU_" ",$$RND(X)_" "_ALTU)
 ..I DEFAULT=0 D
 ...S DEFU=$P(DATA,U,3),ALTU=$P(DATA,U,4)
 ...I ALTU=""!(DEFU=ALTU) D APPEND(TYP_": "_$$RND(VAL)_" "_DEFU)
 ...E  S X=VAL I $D(^BEHOVM(90460.01,BEH,1)) X $G(^BEHOVM(90460.01,BEH,1)) D APPEND(TYP_": "_$$RND(VAL)_" "_DEFU_" ",$$RND(X)_" "_ALTU)
 ..I DEFAULT="" D
 ...D APPEND(TYP_": "_$$RND(VAL))
 Q:$G(AGE)'>2!'$D(WT)!'$D(HT)
 S VAL=$$RND((WT*704.5)/(HT*HT))
 S MR=$S(AGE<20:"",VAL<18.5:"Underweight",VAL<25:"Normal Weight",VAL<30:"Overweight",VAL<35:"Obesity - Class 1",VAL<40:"Obesity - Class 2",1:"Extreme Obesity")
 D APPEND("BMI: "_VAL,MR)
 Q
GET3 ;;Reproductive^;
 N REC,X
 S REC=$G(^AUPNREP(DFN,0))
 Q:'$L(REC)!(SEX'="F")
 ;IHS/MSC/MGH Patch 6 updated to reflect the change in date fields in reproductive hx
 ;S X=$S($P(REC,U,3)=DAT:$P(REC,U,2),1:"")
 S TODAY=$$DT^XLFDT
 Q:TODAY'=$P(REC,U,3)
 S:$L($T(^BGOREP)) X=$$EXPHX^BGOREP($P(REC,U))
 D:$L(X) APPEND($TR(X,"=",":"))
 S X=$S($P(REC,U,5)=DAT:$P(REC,U,4),1:"")
 D:X APPEND("LMP: "_$$FMTDATE^BGOUTL(X))
 S X=$S($P(REC,U,8)=DAT:$$MCASE^BGOUTL($$EXTERNAL^DILFD(9000017,3,,$P(REC,U,6))),1:"")
 D:$L(X) APPEND("Contraceptive Method: "_X)
 Q
GET4 ;;Pregnancy^;
 N REC,X
 Q:SEX'="F"
 S REC=$G(^AUPNREP(DFN,0))
 S X=$S($P(REC,U,11)=DAT:$$FMTDATE^BGOUTL($P(REC,U,9)),1:"")
 D:$L(X) APPEND("Est. Delivery: "_X)
 Q
GET5 ;;Immunizations^;
 N IMM
 F  S LP=$O(^AUPNVIMM("AD",+VIEN,LP)) Q:'LP  D
 .S IMM=$P($G(^AUPNVIMM(LP,0)),U)
 .D:IMM APPEND($P($G(^AUTTIMM(IMM,0)),U))
 Q
GET6 ;;Skin Tests^;
 N SK
 F  S LP=$O(^AUPNVSK("AD",+VIEN,LP)) Q:'LP  D
 .S SK=$P($G(^AUPNVSK(LP,0)),U)
 .D:SK APPEND($P($G(^AUTTSK(SK,0)),U))
 Q
GET7 ;;Education^;
 N EDT
 F  S LP=$O(^AUPNVPED("AD",VIEN,LP)) Q:'LP  D
 .S EDT=$P($G(^AUPNVPED(LP,0)),U)
 .D:EDT APPEND($P($G(^AUTTEDT(EDT,0)),U))
 Q
GET8 ;;Exams^;
 N XAM
 F  S LP=$O(^AUPNVXAM("AD",VIEN,LP)) Q:'LP  D
 .S XAM=+$G(^AUPNVXAM(LP,0))
 .D:XAM APPEND($P($G(^AUTTEXAM(XAM,0)),U))
 Q
GET9 ;;Health Factors^;
 N HF
 F  S LP=$O(^AUPNVHF("AD",VIEN,LP)) Q:'LP  D
 .S HF=$P($G(^AUPNVHF(LP,0)),U)
 .D:HF APPEND($P($G(^AUTTHF(HF,0)),U))
 Q
GET10 ;;Procedures^;
 N PRC
 F  S LP=$O(^AUPNVCPT("AD",VIEN,LP)) Q:'LP  D
 .I PRV>0,$P($G(^AUPNVCPT(LP,12)),U,4)=PRV Q
 .S PRC=$P($G(^AUPNVCPT(LP,0)),U)
 .D:PRC APPEND($P($G(^ICPT(PRC,0)),U,2))
 Q
GET11 ;;Orders^
 N ORLIST,LOC,X,Y,Z
 K ^TMP("ORR",$J)
 S LOC=$P(V0,U,22)_";SC("
 D EN^ORQ1(DFN_";DPT(",,1,1,DAT,DAT,1)
 Q:'$D(ORLIST)
 F LP=0:0 S LP=$O(^TMP("ORR",$J,ORLIST,LP)) Q:'LP  D
 .N ORD
 .M ORD=^TMP("ORR",$J,ORLIST,LP)
 .S Z=$G(^OR(100,+ORD,0))
 .S Y=$P(Z,U,10)
 .I 'Y,PRV>0,$P(Z,U,4)'=PRV Q
 .I PRV>0,$P(Z,U,6)'=PRV Q
 .I Y,LOC,Y'=LOC Q
 .Q:$P(ORD,U,7)="canc"
 .S Y=0
 .F  S Y=$O(ORD("TX",Y)) Q:'Y  D APPEND(ORD("TX",Y))
 .D ADDHDR
 K ^TMP("ORR",$J)
 Q
 ; Round to 4 decimal points
 ; Patch 5 change to 2 decimal places
RND(X) Q $S(X=+X:+$J(X,0,2),1:X)
ADDHDR S:CNT>0 @RET@(SCT,0)=U_CTL,CNT=0,SCT=SCT+1
 Q
 ; Append to result string
APPEND(X,Y) ;
 S CNT=CNT+1,@RET@(SCT,CNT)=X_$S($L($G(Y)):" ("_Y_")",1:"")
 Q
