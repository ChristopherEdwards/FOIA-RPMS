BQICAEXP ;VNGT/HS/ALA-Community Alerts Export ; 01 Sep 2010  8:35 PM
 ;;2.1;ICARE MANAGEMENT SYSTEM;**1**;Feb 07, 2011;Build 5
 ;
 ;
EN ; Entry Point
 NEW DIC,DLAYGO,X,DA,IENS,DATA,CMN,ALTYP,ALERT,CTN,CAT,DX,DFN,GRN,GRP,DIAG,DXN,LOC
 NEW ASUFAC,ASUN,ASUNM,CT,DATE,DELIM,EXIEN,HDR,IEN,IN,N,VISIT,XBFLG,XBPAFN,XBS1,ZISHFL
 NEW RECORD,VDATE,XBE,XBF,ZTQUEUED,FRM,VFILE,DTLMD,SUFLG,BQIUPD,ERROR,ZISHC,ZISHDA1
 ;
 S ZTQUEUED=1
 ; Send suicide data flag
 S SUFLG=+$P(^BQI(90508,1,0),U,3)
 I +$P(^BQI(90508,1,0),U,5)=1 Q
 ; Create entry in file to log output
 S DIC(0)="L",DLAYGO=90507.7,DIC="^BQI(90507.7,",X=DT
 K DO,DD D FILE^DICN
 S EXIEN=+Y
 ; Go through already calculated Community alerts
 S CMN=0
 F  S CMN=$O(^BQI(90507.6,CMN)) Q:'CMN  D
 . S ALTYP=0
 . F  S ALTYP=$O(^BQI(90507.6,CMN,1,ALTYP)) Q:'ALTYP  D
 .. S ALERT=$P(^BQI(90507.6,CMN,1,ALTYP,0),U,1)
 .. ; if suicide alerts and export flag is not turned on, quit
 .. I ALERT="Suicidal Behavior",'SUFLG Q
 .. S CTN=0
 .. F  S CTN=$O(^BQI(90507.6,CMN,1,ALTYP,1,CTN)) Q:'CTN  D
 ... S CAT=$P(^BQI(90507.6,CMN,1,ALTYP,1,CTN,0),U,1)
 ... S DX=0
 ... F  S DX=$O(^BQI(90507.6,CMN,1,ALTYP,1,CTN,1,DX)) Q:'DX  D
 .... S DATA=^BQI(90507.6,CMN,1,ALTYP,1,CTN,1,DX,0)
 .... S DFN=$P(DATA,U,4),VISIT=$P(DATA,U,3),DATE=$P(DATA,U,2),DXN=$P(DATA,U,1)
 .... S VFILE=$P(DATA,U,5)
 .... I $D(^BQI(90507.7,"AC",DFN,CAT,VISIT,DATE)) Q
 .... I $G(^DPT(DFN,0))="" Q
 .... I VFILE=9000010,$G(^AUPNVSIT(VISIT,0))="" Q
 .... S GRN=$O(^BQI(90507.8,"B",$E(CAT,1,30),""))
 .... S GRP="O" I GRN'="" S GRP=$P(^BQI(90507.8,GRN,0),U,3)
 .... ; If flag to not export is set for this alert definition, quit
 .... I GRN'="",$P($G(^BQI(90507.8,GRN,2)),U,3)=1 Q
 .... S DA(1)=EXIEN,DIC="^BQI(90507.7,"_DA(1)_",10,",DLAYGO=90507.701,X=DFN
 .... K DO,DD D FILE^DICN
 .... S DA=+Y,IENS=$$IENS^DILF(.DA)
 .... S BQIUPD(90507.701,IENS,.02)=VISIT,BQIUPD(90507.701,IENS,.03)=ALERT
 .... S BQIUPD(90507.701,IENS,.05)=GRP,BQIUPD(90507.701,IENS,.06)=DXN
 .... S BQIUPD(90507.701,IENS,.07)=CAT,BQIUPD(90507.701,IENS,.08)=DATE
 .... S BQIUPD(90507.701,IENS,.09)=VFILE
 .... D FILE^DIE("","BQIUPD","ERROR")
 ;
 S ASUN=$P(^AUTTSITE(1,0),U),ASUFAC=$P($G(^AUTTLOC(ASUN,0)),U,10),ASUNM=$P(^DIC(4,ASUN,0),U)
 S CT=0,N=0,DELIM=","
 F  S N=$O(^BQI(90507.7,EXIEN,10,N)) Q:'N  S CT=CT+1
 S BQIUPD(90507.7,EXIEN_",",.04)=CT
 D FILE^DIE("","BQIUPD","ERROR")
 ;
 K ^BQIDATA($J)
 ; Get export format type 'D' is delimited and 'H' or blank is HL7
 S FRM=$P($G(^BQI(90508,1,0)),U,2)
 S IN=$S(FRM="D":1,1:0)
 I FRM="D" S HDR=$$JDATE(DT)_DELIM_CT_DELIM_ASUNM,^BQIDATA($J,IN)=HDR
 S IEN=0
 F  S IEN=$O(^BQI(90507.7,EXIEN,10,IEN)) Q:'IEN  D
 . S DATA=^BQI(90507.7,EXIEN,10,IEN,0)
 . S DFN=$P(DATA,U,1),VISIT=$P(DATA,U,2),ALERT=$P(DATA,U,3),DIAG=$P(DATA,U,7),GRP=$P(DATA,U,5)
 . S DXN=$P(DATA,U,6),VDATE=$P(DATA,U,8),VFILE=$P(DATA,U,9)
 . S LOC=$P($G(^AUPNVSIT(VISIT,0)),U,6)
 . S DIAG=$$STRIP^XLFSTR(DIAG,",")
 . ; Unique Identifier
 . S RECORD=$$UID(DFN)
 . ; HRN
 . S $P(RECORD,DELIM,2)=$S($$HRN^AUPNPAT(DFN,LOC)]"":$$HRN^AUPNPAT(DFN,LOC),1:$$HRN^AUPNPAT(DFN,DUZ(2)))
 . ; Gender
 . S $P(RECORD,DELIM,3)=$P(^DPT(DFN,0),U,2)
 . ; DOB
 . S $P(RECORD,DELIM,4)=$S(FRM="D":$$JDATE($P($G(^DPT(DFN,0)),U,3)),1:$$FMTHL7^XLFDT($P($G(^DPT(DFN,0)),U,3)))
 . ; Age
 . S $P(RECORD,DELIM,5)=$P($$AGE^BQIAGE(DFN,"",1)," ",1)
 . ; Age Units
 . S $P(RECORD,DELIM,6)=$P($$AGE^BQIAGE(DFN,"",1)," ",2)
 . ; Patient Street Address
 . S $P(RECORD,DELIM,7)=$$GET1^DIQ(2,DFN_",",.111,"E")
 . ; Patient Address City
 . S $P(RECORD,DELIM,8)=$$GET1^DIQ(2,DFN_",",.114,"E")
 . ; Patient Address State
 . NEW ST
 . S ST=$$GET1^DIQ(2,DFN_",",.115,"I")
 . S $P(RECORD,DELIM,9)=$$PTR^BQIUL2(2,.115,ST,1)
 . ; Patient Address Zip
 . S $P(RECORD,DELIM,10)=$S($$GET1^DIQ(2,DFN_",",.1112,"E")'="":$$GET1^DIQ(2,DFN_",",.1112,"E"),1:$$GET1^DIQ(2,DFN_",",.116,"E"))
 . ; Patient County
 . S $P(RECORD,DELIM,11)=$$COUN^BQIULPT(DFN)
 . ; Current community of residence
 . S $P(RECORD,DELIM,12)=$$COMMRES^AUPNPAT(DFN,"C")
 . ; Race
 . NEW RACE,RCN
 . S RACE=$$RCE^BQIPTDMG(DFN,.01),RCN=$P(RACE,$C(28),1)
 . I RCN'="" S $P(RECORD,DELIM,13)=$P(^DIC(10,RCN,0),U,3)
 . ; Ethnicity
 . NEW ETHN,ETN
 . S ETHN=$$ETHN^BQIPTDMG(DFN,.01),ETN=$P(ETHN,$C(28),1)
 . I ETN'="" S $P(RECORD,DELIM,14)=$P(^DIC(10.2,ETN,0),U,2)
 . ; ASUFAC of encounter location
 . S $P(RECORD,DELIM,15)=$S(LOC'="":$P($G(^AUTTLOC(LOC,0)),U,10),1:"")
 . ; Visit Date
 . S $P(RECORD,DELIM,16)=$S(FRM="D":$$JDATE(VDATE),1:$$FMTHL7^XLFDT(VDATE))
 . ; Visit ID
 . S $P(RECORD,DELIM,17)=$S($P($G(^AUPNVSIT(VISIT,11)),U,14)]"":$P($G(^AUPNVSIT(VISIT,11)),U,14),1:$$UIDV^AUPNVSIT(VISIT))
 . ; Dxn ICD9 code
 . S $P(RECORD,DELIM,18)=DXN
 . ; CDC diagnosis narrative
 . S $P(RECORD,DELIM,19)=DIAG
 . ; Type of alert
 . S $P(RECORD,DELIM,20)=ALERT
 . ; Group
 . S $P(RECORD,DELIM,21)=GRP
 . ; Visit last modified
 . S DTLMD=$S(VFILE'=9000010:$P($G(^AMHREC(VISIT,11)),U,14),1:$P($G(^AUPNVSIT(VISIT,0)),U,13))
 . S $P(RECORD,DELIM,22)=$S(FRM="D":$$JDATE(DTLMD),1:$$FMTHL7^XLFDT(DTLMD))
 . ; Highest Temperature for OBX
 . I VDATE'="" D
 .. NEW TMN,RVDT,IEN,ZZ,RESULT
 .. S TMN=$O(^AUTTMSR("B","TMP","")) I TMN="" Q
 .. S RVDT=9999999-VDATE
 .. S IEN=""
 .. F  S IEN=$O(^AUPNVMSR("AA",DFN,TMN,RVDT,IEN)) Q:IEN=""  D
 ... S RESULT=$P($G(^AUPNVMSR(IEN,0)),"^",4) I RESULT="" Q
 ... S ZZ(RESULT)=""
 .. S $P(RECORD,DELIM,23)=$O(ZZ(""),-1)
 . ; Vitals for OBX
 . I VFILE=9000010 D
 .. NEW VITALS,BMI,IEN,TYP,RESULT,MEAS,XX,UID
 .. S VITALS="",UID=$J
 .. S BMI=$P($$OBMI^BQITBMI(DFN,"T-36M"),"^",1),VITALS=VITALS_"BMI="_BMI_";"
 .. S IEN=""
 .. F  S IEN=$O(^AUPNVMSR("AD",VISIT,IEN)) Q:IEN=""  D
 ... S TYP=$P($G(^AUPNVMSR(IEN,0)),"^",1) I TYP="" Q
 ... S MEAS=$P(^AUTTMSR(TYP,0),"^",1),RESULT=$P(^AUPNVMSR(IEN,0),"^",4)
 ... S XX="BP,RS,PU,WT,HT"
 ... I '$F(XX,MEAS) Q
 ... S VITALS=VITALS_MEAS_"="_RESULT_";"
 .. S $P(RECORD,DELIM,24)=$$TKO^BQIUL1(VITALS,";")
 . ;
 . S IN=IN+1,^BQIDATA($J,IN)=RECORD
 ;
 ; If HL7
 I FRM'="D" D ^BQICAHLO
 D WRITE
 Q
 ;
UID(BQIDFN) ;EP - Given DFN return unique patient record id.
 I $G(BQIDFN)="" Q ""
 I $G(^AUPNPAT(BQIDFN,0))="" Q ""
 I $G(^DPT(BQIDFN,0))="" Q ""
 Q $$GET1^DIQ(9999999.06,$P(^AUTTSITE(1,0),U),.32)_$E("0000000000",1,10-$L(BQIDFN))_BQIDFN
 ;
JDATE(DATE) ;EP - Format the date
 I $G(DATE)="" Q ""
 NEW A
 S A=$$FMTE^XLFDT(DATE)
 Q $E(DATE,6,7)_$$UP^XLFSTR($P(A," ",1))_(1700+$E(DATE,1,3))
 ;
DATE(D) ;
 Q (1700+$E(D,1,3))_$E(D,4,5)_$E(D,6,7)
 ;
 ;send file
WRITE ; use XBGSAVE to save the temp global (BQIDATA) to a file that is exported
 ;
 NEW XBGL,XBQ,XBQTO,XBNAR,XBMED,XBFLT,XBUF,XBFN
 S XBMED="F",XBQ="N",XBFLT=1,XBF=$J,XBE=$J
 S XBGL=$S(FRM="D":"BQIDATA",1:"BQIHL7")
 S XBNAR="CANE SURVEILLANCE EXPORT"
 S ASUFAC=$P($G(^AUTTLOC($P(^AUTTSITE(1,0),U),0)),U,10)  ;asufac for file name
 S XBFN="CANES_"_ASUFAC_"_"_$$DATE(DT)_".txt"
 ;S XBFN=$S(FRM="D":"CANES_"_ASUFAC_"_"_$$DATE(DT)_".txt",1:"CANES_"_ASUFAC_"HL7"_"_"_$$DATE(DT)_".txt")
 S XBS1="CANE SURVEILLANCE SEND"
 S XBUF=$P($G(^AUTTSITE(1,1)),"^",2)
 I XBUF="" S XBUF=$P($G(^XTV(8989.3,1,"DEV")),"^",1)
 ;
 D ^XBGSAVE
 ;
 I XBFLG'=0 D
 . I XBFLG(1)="" S BQIUPD(90507.7,EXIEN_",",.03)=1
 . I XBFLG(1)'="" S BQIUPD(90507.7,EXIEN_",",.03)=0
 . D FILE^DIE("I","BQIUPD","ERROR")
 . Q
 K ^BQIDATA($J),^BQIHL7($J)
 Q
