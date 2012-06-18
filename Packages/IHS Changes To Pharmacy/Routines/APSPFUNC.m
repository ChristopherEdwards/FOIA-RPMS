APSPFUNC ;IHS/CIA/PLS - MISC FUNCTIONS ;03-Aug-2011 16:15;PLS
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1002,1004,1005,1006,1007,1008,1009,1010,1011**;Sep 23, 2004;Build 17
 ;
HRC(DFN,D) ;EP; -- IHS health record number
 ; Input: IEN to File 200
 ;          D - 1 for dashes (default = 0)
 N HRCN
 S HRCN=$P($G(^AUPNPAT(+$G(DFN),41,+$G(DUZ(2)),0)),"^",2)
 S:$G(D,0) HRCN=$$HRCD(HRCN)
 Q HRCN
 ;
HRCD(X) ; Add dashes to given HRN value in X
 S X="00000"_X,X=$E(X,$L(X)-5,$L(X))
 S X=$E(X,1,2)_"-"_$E(X,3,4)_"-"_$E(X,5,6)
 Q X
 ;
 ; Return most recent vital of specified type
 ; Return value is IEN^VALUE^DATE
VITAL(DFN,TYP) ; EP
 N IDT,IEN,DAT,VIS
 S:TYP'=+TYP TYP=$O(^AUTTMSR("B",TYP,0))
 Q:'TYP ""
 S IDT=$O(^AUPNVMSR("AA",DFN,TYP,0))
 Q:'IDT ""
 S IEN=+$O(^(IDT,$C(1)),-1)
 Q:'IEN ""
 S X=$G(^AUPNVMSR(IEN,0)),DAT=+$G(^(12))
 S:'DAT DAT=+$G(^AUPNVSIT(+$P(X,U,3),0))
 Q IEN_U_$P(X,U,4)_U_DAT
 ; Return height in cm
VITCHT(VAL) ; EP
 Q $J($G(VAL)*2.54,0,2)
 ; Return weight in kg
VITCWT(VAL) ; EP
 Q $J($G(VAL)/2.2,0,2)
 ; Return vital date in format MM/DD/YYYY
VITDT(VAL) ; EP
 Q $$FMTE^XLFDT(VAL,"5DZ0")
 ; Return vital information in same format at EN6^GMRVUTL
 ; Return format: Date^Value in Imperial Unit^Value inMetric Unit
VITALF(DFN,TYP) ; EP
 N VAL,RES
 S VAL=$$VITAL(DFN,TYP)
 S RES=$$VITDT($P(VAL,U,3))_"^^^^^^^"_$P(VAL,U,2)
 Q RES
 ; Return NDC value
 ; Input: RX - Presciption IEN
 ;        RF - Refill IEN
 ; Output: NDC value
NDCVAL(RX,RF) ; EP - Return NDC Value
 ; NDC value for prescription is returned if Refill IEN is not supplied
 N IENS,FILE,FLD
 S RF=$G(RF,0)
 Q:'$G(RX) ""
 S IENS=$S(RF:RF_","_RX_",",1:RX_",")
 S FILE=$S(RF:52.1,1:52)
 S FLD=$S(RF:11,1:27)
 Q $$GET1^DIQ(FILE,IENS,FLD)
 ; Input: RX - Presciption IEN
 ;        RF = Refill IEN
 ;        NDC = NDC value to store
SETNDC(RX,RF,NDC) ; EP - Store NDC Value
 N FDA,MSG
 S RF=$G(RF,0)
 S FL=$S(RF:52.1,1:52)
 S IENS=$S(RF:RF_","_RX_",",1:RX_",")
 S FLD=$S(RF:11,1:27)
 S FDA(FL,IENS,FLD)=NDC
 D FILE^DIE("EK","FDA","MSG")
 Q $S($D(MSG):$G(MSG("DIERR",1))_" Error",1:0)
 ;Input: RX - Prescription IEN
 ;       RF - Refil IEN
 ;       OVERDUR - NCPDP 5.1 DUR segment pointer
 ;Output: Null if value stored; otherwise an error occurred
UPDRX(RX,RF,OVERDUR) ;PEP - Update DUR 5.1 information
 N FDA,MSG
 Q:'$G(RX)!'$G(OVERDUR) "-1^Required variables not present"
 Q:'$D(^PSRX(RX,0)) "-2^Prescription not present"
 S RF=$G(RF,0)
 I RF Q:'$G(^PSRX(RX,1,RF,0)) "-3^Refill not present"
 S FL=$S(RF:52.1,1:52)
 S IENS=$S(RF:RF_","_RX_",",1:RX_",")
 S FDA(FL,IENS,9999999.13)=OVERDUR
 D FILE^DIE("EK","FDA","MSG")
 Q $S($D(MSG):$G(MSG("DIERR",1))_" Error",1:0)
 ; Call POS Hook
CALLPOS(RIEN,RFIEN,ACT,REASON) ; EP - IHS/CIA/PLS - 03/31/04
 N X,ARY
 Q:'$G(RIEN)!'$L($G(ACT))
 Q:$$GET1^DIQ(52,RIEN,9999999.23,"I")  ;IHS/MSC/PLS - 11/02/07- Autofinished Rx
 S RFIEN=$G(RFIEN)
 S X=$$EN^APSQBRES(RIEN,$G(RFIEN),ACT,$G(REASON))
 I $$GET^XPAR("ALL","APSP LOG ABSP MESSAGES") D
 .S ARY(1)=$G(RIEN)_U_$G(RFIEN)_U_$G(ACT)_U_$G(X)_U_$G(REASON)
 .D LOG^APSPPOSH(.ARY)
 Q
 ; Display Future Fill Date Warning if needed.
FFDTWARN(FILLDT) ; EP
 I $G(FILLDT)>DT D
 .W !,"WARNING: The prescription has a Fill Date in the future!",!
 Q
 ; Fire EHR Patient Context Change
SETPTCX(PSODFN) ;EP
 N X
 S X="CIAVCXPT" X ^%ZOSF("TEST") I $T D SETCTX^CIAVCXPT(+PSODFN) Q
 S X="BEHOPTCX" X ^%ZOSF("TEST") I $T D SETCTX^BEHOPTCX(+PSODFN)
 Q
 ; Fire BOP message to ADS device
BOPSTAT ; EP
 N X
 S X="BOPCAP" X ^%ZOSF("TEST") I $T D STAT^BOPCAP
 Q
 ; Return fraction value
FRACVAL(WNUM,FRAC) ; EP
 N RES,OUT
 S RES=""
 Q:'FRAC&(WNUM>10) ""
 I FRAC=".5"!(FRAC=".50") S RES="1/2"
 E  I FRAC=".25" S RES="1/4"
 E  I FRAC=".33"!(FRAC=".34") S RES="1/3"
 E  I FRAC=".66"!(FRAC=".67") S RES="2/3"
 E  I FRAC=".75" S RES="3/4"
 I WNUM!RES D
 .S OUT=" ("
 .I WNUM S OUT=OUT_WNUM
 .S OUT=OUT_$S(RES&WNUM:" AND "_RES,RES:RES,1:"")
 .S:$L(OUT) OUT=OUT_")"
 Q $G(OUT)
 ; Return fraction text
FRACTXT(FRAC) ; EP
 N RES
 S FRAC=$G(FRAC)
 I FRAC=".5"!(FRAC=".50") S RES="ONE-HALF"
 E  I FRAC=".25" S RES="ONE-FOURTH"
 E  I FRAC=".33"!(FRAC=".34") S RES="ONE-THIRD"
 E  I FRAC=".66"!(FRAC=".67") S RES="TWO-THIRDS"
 E  I FRAC=".75" S RES="THREE-FOURTHS"
 Q $G(RES)
 ; Return POS status
POS(RIEN) ; EP
 N ANS,DIR
 S ANS=""
 I '$$TEST^APSQBRES("ABSPOSRX") D
 .N APSQPOS,APSQPOST,APSQIT
 .S APSQIT=0
 .S ANS="CLAIM WAS NOT RESUBMITTED TO POS"
 .S APSQPOS=$$IEN59^ABSPOSRX(RIEN,$G(RFIEN,0)) ; Get IEN in POS File
 .I $G(APSQPOS) S APSQPOST=$O(^ABSPTL("B",APSQPOS,"A"),-1)  ; Last entry in ^ABSPTBL global
 .I $G(APSQPOST) D:+$$GET1^DIQ(9002313.57,+APSQPOST_",",.15)  ; >0 indicates entry in Accounts Receivable
 ..S DIR("A",1)="There is an entry for this prescription in the Accounts Receivable Package"
 ..S DIR("A")="Do you really want to reverse this entry and resend it to the insurer and put another entry in the Accounts Receivable Package"
 ..S DIR("B")="YES"
 ..S DIR(0)="Y"
 ..D ^DIR
 ..S:Y=0 APSQIT=1
 .I 'APSQIT D
 ..S ANS="CLAIM WAS RESUBMITTED TO POS"
 ..N APSQPST,RFIEN,ARY,RET
 ..S RFIEN=$O(^PSRX(RIEN,1,$C(1)),-1)
 ..D CALLPOS^APSPFUNC(RIEN,$S(RFIEN:RFIEN,1:""),"D","Reversal caused by edit.")
 ..S ARY("RX REF")=$S(RFIEN:RFIEN,1:0)
 ..S ARY("REASON")="E"
 ..S ARY("COM")=ANS
 ..D UPTLOG^APSPFNC2(.RET,RIEN,0,.ARY)
 Q ANS
 ;
 ; Returns patient corresponding to 12 digit facility/hrn code
HRCNF(HRCN12) ; EP
 N DFN,ASUFAC,HRN,Y
 S DFN=-1
 S ASUFAC=+$E(HRCN12,1,6),HRN=+$E(HRCN12,7,12)
 Q:'ASUFAC!'HRN DFN
 S ASUFAC=$$FIND1^DIC(9999999.06,,,ASUFAC,"C")
 Q:'ASUFAC DFN
 S Y=0 F  S Y=$O(^AUPNPAT("D",HRN,Y)) Q:'Y  Q:$D(^(Y,ASUFAC))
 S:Y DFN=Y
 Q DFN
 ; Return list of prescriptions on hold for patient and date range
 ; Input: DATA - $NA of array reference
 ;         DFN - Patient IEN
 ;         BDT - Beginning date - Issue Date
 ;         EDT - End date
RXHLDLST(DATA,DFN,BDT,EDT) ;PEP -
 K @DATA
 Q:'$G(DFN)  ; Patient must be defined
 S BDT=$G(BDT,0)
 S EDT=$G(EDT,DT)+.99
 N HRSN,RXISD
 S HRSN=0 F  S HRSN=$O(^PSRX("AH",HRSN)) Q:'HRSN  D
 .S RX=0 F  S RX=$O(^PSRX("AH",HRSN,RX)) Q:'RX  D
 ..Q:$$GET1^DIQ(52,RX,2,"I")'=DFN
 ..Q:$$GET1^DIQ(52,RX,100,"I")'=3  ; Hold status
 ..S RXISD=$$GET1^DIQ(52,RX,1,"I")  ; Get Issue Date
 ..Q:RXISD<BDT!(RXISD>EDT)
 ..S @DATA@(RX)=""
 Q
 ; Pad string with character to specified length
PAD(S,P,L) ; EP
 S $P(P,P,L)=""
 Q $E(S_P,1,L)
 ;
 ; Return formatted phone number
FMTPHN(X) ;EP
 N RES
 I $E(X,1,10)?10N Q "("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_$S($L($E(X,11,20)):"  "_$E(X,11,20),1:"")
 I $E(X,1,7)?7N Q $E(X,1,3)_"-"_$E(X,4,7)_"  "_$E(8,20)
 I X?10N1" ".6UN Q "("_$E(X,1,3)_")"_$E(X,4,6)_"-"_$E(X,7,10)_$S($L($E(X,11,20)):"  "_$E(X,11,20),1:"")
 I X?3N1"-"3N1"-"4N.1" ".A Q "("_$E(X,1,3)_")"_$E(X,5,12)_"  "_$E(X,13,20)
 I X?3N1"-"4N Q X
 I X?3N1"-"4N.1" ".6UN Q X
 Q X
 ; Returns value of POE field for given prescription with DEA Class rules applied
ISPOE(RX) ;PEP -
 N POE,DRG
 S POE=+$P($G(^PSRX(RX,"POE")),U)
 Q:'POE 0
 S DRG=+$P($G(^PSRX(RX,0)),U,6)
 Q:'DRG 0
 Q '$$ISSCH^APSPFNC2(DRG,"2345")
 ; Removes RXs with future fill date from PPL string
 ; Input: PPL - List of comma delimited RXs
 ;        SFLG - Passing 1 will remove the future RXs from PPL
CHKFDT(PPL,SFLG) ; EP
 N LP,RX,PPLARY,FFLG
 Q:'$G(PPL)
 S SFLG=$G(SFLG,0)
 D BPPLARY(PPL)
 S RX=0 F  S RX=$O(PPLARY(RX)) Q:'RX  D
 .S PPLARY(RX)=$$FILLDT(RX)>$$DT^XLFDT()
 .S:PPLARY(RX) FFLG=1
 D:$G(FFLG) FDTWARN(.PPLARY)
 D:SFLG BPPLSTR(.PPLARY)
 Q
 ; Extracts PPL string into an array
BPPLARY(PPL) ;EP
 N LP,RX
 F LP=1:1 Q:$P(PPL,",",LP)=""  D
 .S RX=$P(PPL,",",LP)
 .S PPLARY(RX)=""
 Q
 ; Builds PPL string from array excluding flagged items
BPPLSTR(PPLARY) ;EP
 N RX
 S PPL=""
 S RX=0 F  S RX=$O(PPLARY(RX)) Q:'RX  D
 .S:'PPLARY(RX) PPL=PPL_RX_","
 Q
 ; Returns Fill Date of Prescription
FILLDT(RX) ;EP
 N LFN,REF,RF0,FDAT
 S LFN=+$O(^PSRX(RX,1,$C(1)),-1)
 S FDAT=$S(LFN:+$P($G(^PSRX(RX,1,LFN,0)),U),1:+$P($G(^PSRX(RX,2)),U,2))
 Q FDAT
 ; Displays warning that labels will not be printed for RXs with future fill dates
FDTWARN(PPLARY) ;EP
 N RX
 W !,"The following prescription labels will not be generated because"
 W !,"of a Future Fill date:"
 S RX=0 F  S RX=$O(PPLARY(RX)) Q:'RX  D
 .I PPLARY(RX) D
 ..W !,"RX: "_$P($G(^PSRX(RX,0)),U),"    Fill Date: "_$$FMTE^XLFDT($$FILLDT(RX),"5Z")
 W !,"Please edit the fill date(s) or place the prescription(s) on suspense."
 Q
 ; Return status of prescription
RXSTAT(RX) ;EP
 Q $G(^PSRX(RX,"STA"))
 ; Return user's DEA, or Facility DEA-VA-USPHS or null
DEAVAUS(PRV) ;EP -
 ; 1.     If provider DEA# exists in File 200 use that.
 ; 2.     If no provider DEA# exists but has VA#
 ;        then return Facility DEA-VA-USPHS
 ;        else return null
 ;        Facility DEA#-VA#-USPHS (ie AU1234567-BB1234-USPHS)
 Q:$G(PRV)="" ""
 N DEAID,VAID,RET,FACID
 S RET=""
 S DEAID=$$GET1^DIQ(200,PRV,53.2)  ;Provider DEA#
 S VAID=$$GET1^DIQ(200,PRV,53.3)   ;Provider VA#
 S FACID=$$GET1^DIQ(4,DUZ(2),52) ;Facility DEA#
 I $L(DEAID) D
 .S RET=DEAID
 E  I $L(VAID) D
 .S RET=FACID_"-"_VAID_"-"_"USPHS"
 Q RET
 ; Returns remaining refill count
 ; Input: RX : Prescription IEN - Required
 ;        FDT: Fill date - optional - If passed will restrict count to
 ;             refill count to exclude refills past the value in FDT.
RMNRFL(RX,FDT) ;EP-
 N RFS,IEN
 S RX=$G(RX,0)
 Q:'$D(^PSRX(RX,0)) 0
 S RFS=$P(^PSRX(RX,0),U,9),IEN=0 F  S IEN=$O(^PSRX(RX,1,IEN)) Q:'IEN  D
 .I $G(FDT) Q:$P(^PSRX(RX,1,IEN,0),U)>FDT
 .S RFS=RFS-1
 Q RFS
