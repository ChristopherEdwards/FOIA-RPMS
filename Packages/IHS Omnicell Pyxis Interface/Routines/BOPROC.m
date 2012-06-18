BOPROC ; ILC/IHS/ALG - Process FT1 statments;14-Nov-2006 10:45;SM;
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1,2**;Jul 26, 2005
 Q
DFT(BOPI) ;EP -  This is the entry point to process the FT1/DFT messages
 ; BOPI = IEN for file 90355.1  (BOP QUEUE File)
 ;
 N INPAT,A,B,C,BOMS,BOPORDT,BOPDTA,BOPDT,BOPDRGI,BOPVDT
 ;IHS/MSC/PLS - 10/24/06 - Next line commented out for patch 2
 ;Q:$$VENDTYP()'="P"  ;Only Pyxis devices orders are supported in patch 1
 S (BOPTT,BOPTC,BOPMSU,BOPPRDN,BOPDT,BOPMID,BOPSITE)=""
 S (BOPTYP,BOPAMID,BOPDFN,BOPTQ,BOPTQA,BOPOB,BOPNU)=""
 S (OPMSUN,BOPPYNM,BOPNAME)=""
 S BOPSITE=+$P(^BOP(90355.1,BOPI,0),U,12)  ;Set to Receiving Facility
 S BOPSITE=+$P($G(^BOP(90355,1,3,BOPSITE,0)),U,9)  ;Set to Outpatient Site (File 59)
 Q:'BOPSITE
 S BOPJ=0 K BOPARY
ONE ;
 S BOPJ=$O(BOPIN(BOPJ)) I BOPJ="" D:$G(BOPARY(2))'="" LOOP G DONE
 S X=BOPIN(BOPJ)
 I X?1"MSH".E S BOMS=BOPJ G ONE
 I X?1"EVN".E G ONE
 ; collect one group
 I X?1"PID".E D  D:$G(BOPARY(2))'="" LOOP S BOPJ=BOPJ-1 G ONE
 .K BOPARY S BOPARY=1,BOPARY(1)=X
 . F  S OUT=0,K=BOPJ,BOPJ=$O(BOPIN(BOPJ)) D  Q:OUT  I 'BOPJ S BOPJ=K+1 Q
 ..I 'BOPJ D  Q
 ...I 'BOMS Q
 ...; evn is before pid
 ...N I,X F I=BOMS:1:K S X=$G(BOPIN(I)) I X?1"EVN".E S BOPARY(4)=X Q
 ...K I,X Q
 ..S X=$G(BOPIN(BOPJ))
 ..I X?1"PID".E S OUT=1 Q
 ..I X?1"PV1".E S F=BOPARY,F=F+1,BOPARY=F,BOPARY(F)=X Q
 ..I X?1"FT1".E S F=BOPARY,F=F+1,BOPARY=F,BOPARY(F)=X Q
 ..I X?1"EVN".E S BOPARY(4)=X Q
 ..S OUT=1 Q
 ; process BOPARY
LOOP S (A,B,C,BOMS)=0
L1 ;
 S A=$O(BOPARY(A)) I 'A K BOPARY Q
 S X=$G(BOPARY(A))
 I X?1"PID".E S BOPPID=X G L1
 I X?1"PV1".E S BOPPV1=X G L1
 I X?1"EVN".E S BOPEVN=X G L1
 I X?1"FT1".E S BOPFT1=X
 I $G(BOPEVN)="" S BOPEVN=$G(BOPARY(4))
 ; above is for the possibilty of multiple FT1's for a pt. PID and PV1
 ; stay the same but FT1 can change
RUN ; first check if supply or drug
 S BOPUSER="" S BOPUSER=$P(BOPPID,"|",21) S BOPUSER=$P(BOPUSER,"^",3)_" "_$P(BOPUSER,"^",2)
 S BOPDFN="" S BOPDFN=$P(BOPPID,"|",4) I BOPDFN="" D LOGEXN(5) G L1
 I '$D(^DPT(BOPDFN,0)) D LOGEXN(6) G L1
 ; Determine patient status
 S INPAT=$$ISINPT(BOPDFN)
 S BOPDRGI=$$DRGIEN(BOPFT1)
 I BOPDRGI="" D LOGEXN(3) G L1
 S X=BOPFT1,BOPDB=$E($P(X,"|",18),1),BOPDB=$TR(BOPDB,"ds","DS")
 ; Check to see if item is in BOP DRUG file
 S BOPDREC=$O(^BOP(90355.5,"BOP",BOPDRGI,""))
 ; If drug not in BOP DRUG file, process as Supply Item
 I BOPDREC=""!INPAT G SUPFILE
 S BOPCRCH=$$TRANTYP(BOPFT1)
 ; Process Credit transaction
 I BOPCRCH="CR" D  G L1
 .N PSONOOR,%APSITE,%APSITE2,%APSITE3,APSDRTDA,BOPPSRX
 .S BOPPSRX=""
 .S %APSITE=$G(^APSPCTRL(BOPSITE,0))
 .S %APSITE2=$G(^APSPCTRL(BOPSITE,2))
 .S %APSITE3=$G(^APSPCTRL(BOPSITE,3))
 .S BOPPSRX=$O(^BOP(90355.44,"DRUG",BOPDFN,BOPDRGI,BOPPSRX),-1)
 .; A prescription was found, now mark as deleted.
 .I BOPPSRX D
 ..N PSOIB,DA,RX,RXN,DIK,PSOABCDA,PSOZVER,DFN,I,STAT,COM,PSONOOR
 ..S PSONOOR="S"  ; Set Nature of Order to Service Correction
 ..S PSOZVER=1  ; Control flag used by PSORXDL. Setting to 1 allows inventory adjustment and POS call to be made.
 ..; Set prescription status to DELETED
 ..S DA=BOPPSRX D ENQ^PSORXDL
 ; Process Charge transaction on drug/create NON-VERIFIED prescription
 I BOPDB["D" D  D:BOPDAS ENTRY^BOPUVER(BOPDAS)
 .S BOPDT=$$NOW^XLFDT
 .N DIC K DO,DD S DIC="^BOP(90355.44,",DIC(0)="L",X=BOPDT D FILE^DICN
 .S BOPDAS=+Y,D=$G(^BOP(90355.44,BOPDAS,0))
 .S E=BOPDB_U_BOPI_U_$P(BOPPID,"|",4)_U_$P(BOPPID,"|",19)_U S:$P(BOPPID,"|",20) E=E_$P(BOPPID,"|",20)
 .S $P(^BOP(90355.44,BOPDAS,0),U,2,6)=E
 .F I=1:1:3 S ^BOP(90355.44,BOPDAS,I)=$S(I=1:BOPPID,I=2:BOPPV1,I=3:BOPFT1,1:"")
 .N DA,DIK S DA=BOPDAS,DIK="^BOP(90355.44," D IX1^DIK K DA,DIK
 .S ^BOP(90355.1,BOPI,"TRACE4")=BOPDAS_U_$P(BOPPID,"|",4)_U_BOPDRGI
 G L1 ; if drug in 90355.5 file, create unverified drug, but don't put it into ihs hl7 supply file
 ;
SUPFILE ; Set item into IHS HL7 Supply Interface file
 ; supply file only - don't create unverified order
 S BOPNAME=$P(BOPPID,"|",6)
 ;S BOPDFN=$P(BOPPID,"|",4)
 S BOPEXFN=$P(BOPPID,"|",19)
 S BOPSSN=$P(BOPPID,"|",20)
IHSHRN I 'BOPDFN D    ; Lookup up using HRN if in record
 .Q:'BOPEXFN  ;alternate ID not available
 .N A,B,D,E,F,G
 .S (A,B,D,E,F,G)=""
 .S (A,B)="^AUPNPAT(""D"","_BOPEXFN S A=A_")"
 .I BOPEXFN?1N.N D  ; make sure that it is a number
 ..S D="" F  S A=$Q(@A) Q:A=""!($E(A,1,$L(B))'=B)  D  Q:D'=""
 ...S E=$P(A,",",3),F=$P($P(A,",",4),")",1)
 ...S G=$G(^AUPNPAT(E,0)) Q:G=""
 ...S G=$G(^DPT(E,0)) Q:G=""
 ...S D=E
 .S BOPDFN=D
 S BOPLOC=$P($P(BOPPV1,"|",4),U)   ; assigned patient location
 S BOPATDOC=$P(BOPPV1,"|",8)       ; attending doc
 S BOPDESC=$S($$VENDTYP()="O":$P(BOPFT1,"|",9),$$VENDTYP()="P":$P($P(BOPFT1,"|",8),U,2))        ; charge description
 S BOPDT=$P(BOPFT1,"|",5)          ; HL7 transaction dt/time
 S BOPTT=$$TRANTYP(BOPFT1)  ;$P(BOPFT1,"|",7)          ; transaction type CHarge or CRedit
 S BOPTC=$P($P(BOPFT1,"|",8),U)          ; transaction code  (charge id)
 S BOPTQ=$P(BOPFT1,"|",11)         ; transaction qty
 S BOPTQA=$S(BOPTT["CR":(BOPTQ*-1),1:BOPTQ)
 S BOPMSU=$P(BOPFT1,"|",14)        ; code for station used map to ^BOP(90355.41)
 S BOPOB=$P(BOPFT1,"|",22),BOPOB=$P(BOPOB,U,2)_","_$TR($P(BOPOB,U,3,4),U," ")    ; ordered by
 I BOPOB]"" S BOPOB=$O(^VA(200,"B",BOPOB,0))
 S BOPORDN=$$ORDNUM(BOPFT1)       ; order number.  nn-nnn pt order nnnn just item
 I 'BOPORDN D  ;Check for previously linked dispenses
 .S BOPORDN=$$GETLINK^BOPSD(BOPDFN,BOPDRGI)
 ;
CHK ; chk point
 ; basic check
 S BOP3PCM="",BOP3PPRC=""
 S BOPPRICE="",BOPDRUG=""
 I 'BOPDFN D LOGEXN(5) G L1
 I '$D(^DPT(BOPDFN,0)) D LOGEXN(6) G L1
 I BOPDESC="" D LOGEXN(4) G L1
 S BOPDTA=$$FMDATE^HLFNC(BOPDT),(BOPVDT,BOPORDT)=BOPDTA
 ; check for visit date from ^AUPNVSIT("AC"
 S X="zzzzzz",BOPAUVST=""
 F  S X=$O(^AUPNVSIT("AC",BOPDFN,X),-1) Q:'X  S OUT="" D  Q:OUT=1  ; get most recent
 .S B=$G(^AUPNVSIT(X,0)) Q:B=""  ; no data
 .S B=$P(B,U,1) Q:B=""  ; no date
 .I B=BOPDTA!(B<BOPDTA) S BOPORDT=B,BOPAUVST=X,OUT=1 Q
 I BOPORDT=BOPDTA&(BOPAUVST="")&(+BOPORDN) D  ; chk for order dt in 55 if not visit
 .S G=+$P($G(^PS(55,BOPDFN,5,+BOPORDN,0)),U,14)
 .S:G BOPORDT=G
 ;
 ; Add dispense record to IHS HL7 Supply File
 N DIC K DO,DD S DIC="^AUPNSUP(",DIC(0)="L",X=BOPDESC D FILE^DICN
 I '$P(Y,U,3) D LOGEXN(7) G L1
 S BOPAUDA=+Y
 S X=BOPDFN_U_BOPORDT_U_U_BOPDTA
 S $P(^AUPNSUP(BOPAUDA,0),U,2,5)=X
 I BOPDB="D" D
 .S ^AUPNSUP(BOPAUDA,1)=$$GET1^DIQ(50,+BOPTC,31)_"^^"_BOPTC  ;NDC^^Drug IEN
 E  D
 .S ^AUPNSUP(BOPAUDA,1)=BOPTC  ; Supply Code
 S ^AUPNSUP(BOPAUDA,2)=BOPDESC_U_BOPORDT_U_BOPTQA
 ;
 I BOPDB="S" D  ;-> if supply get chg code price
 .S BOP3PCM=$O(^ABMCM("D",BOPTC,BOP3PCM))
 .I $G(BOP3PCM) S BOP3PPRC=$P($G(^ABMDFEE(1,32,BOP3PCM,0)),U,2)
 .S $P(^AUPNSUP(BOPAUDA,2),U,4)=BOP3PPRC
 I BOPDB="D" D  ;-> if drug get price from psdrug
 .S $P(^AUPNSUP(BOPAUDA,2),U,4)=$$GDRGPRC($$DRGIEN(BOPFT1),1)
 ;
 N DA,DIK S DA=BOPAUDA,DIK="^AUPNSUP(" D IX1^DIK K DA,DIK ; do xreff
 ;
 ; put BOPAUVST into 90355.1 node TRK by BOPJ, BOPDFN, BOPAUVST
 ; BOPJ is the current FT1 node being worked on
 ;
 S X=$G(^BOP(90355.1,BOPI,0)) I X'="" S ^BOP(90355.1,BOPI,"TRK",(BOPJ+0),BOPDFN,(BOPAUVST+0))=$G(BOPAUDA)
 ; Update Extra Units for inpatient med order
 I BOPDB="D",INPAT,+BOPORDN D
 .D ADDXTRA
 ; Add inpatient dispense to BOP RECEIVE DRUG file
 I BOPDB="D",INPAT D
 .D ADDRECDG(BOPDRGI,BOPDFN,BOPVDT,BOPORDN,BOPTQA,+BOPOB,"S","")
 .;D ADDRECDG(BOPDRGI,BOPDFN,BOPORDT,BOPORDN,BOPTQA,+BOPOB,"S","")
 G L1
 ;
DONE Q
 ; Return Inpatient status
ISINPT(DFN) ;EP
 N VAIN,VAERR
 D INP^VADPT
 Q +$G(VAIN(1))
 ;
 ; Update Dispense Drug Extra Units Dispensed
ADDXTRA ; EP
 Q:'BOPDFN!'BOPORDN!'BOPDRGI
 N FDA,DIEN,MSG
 S DIEN=$O(^PS(55,BOPDFN,5,+BOPORDN,1,"B",BOPDRGI,0))
 Q:'DIEN
 S IENS=DIEN_","_+BOPORDN_","_BOPDFN_","
 S FDA(55.07,IENS,.11)=BOPTQA
 D FILE^DIE("K","FDA","MSG")
 Q
 ; Return drug price
GDRGPRC(DIEN,AWPFLG) ; EP
 Q:'DIEN ""
 S AWPFLG=$G(AWPFLG,0)
 N BOPPRICE
 S BOPPRICE=""
 S:AWPFLG BOPPRICE=$$GET1^DIQ(50,DIEN,9999999.32)
 S:'BOPPRICE BOPPRICE=$$GET1^DIQ(50,DIEN,16)
 Q BOPPRICE
 ; Return Order Number for Inpatient Order
ORDNUM(BOPFT1) ;EP
 N RES,VEND
 S VEND=$$VENDTYP()
 I VEND="O" D     ; Process Omnicell Message
 .S RES=+$P(BOPFT1,"|",24)
 E  I VEND="P" D  ; Process Pyxis Message
 .S RES=+$P(BOPFT1,"|",10)
 Q RES
 ; Return DRUG IEN
DRGIEN(BOPFT1) ;EP
 N RES,VEND
 S VEND=$$VENDTYP()
 ;I VEND="O" D   ; Process Omnicell message
 ;.S RES=$P(BOPFT1,"|",24)  ; Filler Order Number (Order Number-Drug IEN)
 ;.S RES=$P(RES,"-",$L(RES,"-"))  ; Last piece contains Drug IEN
 ;E  I VEND="P" D  ; Process Pyxis message
 S RES=+$P($P(BOPFT1,"|",8),U)  ; Format=Drug IEN^Description or NDC^Description
 Q $G(RES)
 ; Return Vendor type (internal format)
VENDTYP() ;EP
 Q $$GET1^DIQ(90355,1,2.5,"I")
 ; Return CHarge or CRedit for Transaction Type
TRANTYP(BOPFT1) ;EP
 N RES,VEND
 S VEND=$$VENDTYP()
 S RES=$P(BOPFT1,"|",7)
 I VEND="P" D  ; Process Pyxis message
 .S RES=$S(RES["V":"CH",1:"CR")
 Q RES
 ; Add entry to BOP RECEIVE DRUG file
ADDRECDG(DRUG,PAT,VDATE,ORDNUM,QVEND,ORDBY,ORDTYP,DISNAM) ;
 N MSG,FDA,IEN,ARY
 S IENS="+1,"
 ; Combine quantity of extraneous entries
 I '$G(ORDNUM) D
 .D FINDITMS^BOPSD(PAT,DRUG,.ARY)
 .S IEN=$O(ARY(0))
 .Q:'IEN
 .D COMBINE^BOPSD(IEN,.ARY)
 .S IENS=IEN_","
 .S QVEND=QVEND+$P(^BOP(90355.2,IEN,0),U,5)
 Q:'$G(DRUG)
 S FDA(90355.2,IENS,.01)=DRUG
 S FDA(90355.2,IENS,.02)=$G(PAT)
 S FDA(90355.2,IENS,.03)=$G(VDATE)
 S:$G(ORDNUM) FDA(90355.2,IENS,.04)=+ORDNUM
 S FDA(90355.2,IENS,.05)=$G(QVEND)
 S:$G(ORDBY) FDA(90355.2,IENS,.06)=ORDBY
 S:'$G(ORDNUM)&($G(ORDTYP)="S") FDA(90355.2,IENS,.07)=$G(ORDTYP)
 S FDA(90355.2,IENS,.09)=BOPI
 S FDA(90355.2,IENS,.1)=$G(DISNAM)
 S:$G(ORDNUM) FDA(90355.2,IENS,.08)="R"
 D UPDATE^DIE(,"FDA",,"MSG")
 Q
 ; Add exception to log
LOGEXN(BOPERR) ; EP
 N FDA,FN,MSG,IENS
 S FN=90355.4,IENS="+1,"
 S FDA(FN,IENS,.01)=$$NOW^XLFDT
 S FDA(FN,IENS,.02)=$G(BOPDFN)
 S FDA(FN,IENS,.03)=$G(BOPORDT)
 S FDA(FN,IENS,.04)=$G(BOPORDN)
 S FDA(FN,IENS,.05)=$G(BOPTQA)
 ;S FDA(FN,IENS,.06)=  ;ORDERED BY
 ;S FDA(FN,IENS,.07)=  ;ORDER TYPE ( PREPAK, OBS, STARTER DOSE, NORMAL OR SUPPLY)
 S FDA(FN,IENS,.08)=$G(BOPORDN)
 ;S FDA(FN,IENS,.1)=  ;ITEM NAME
 S FDA(FN,IENS,.09)=BOPERR
 S FDA(FN,IENS,.11)=$G(BOPDRGI)
 ;S FDA(FN,IENS,.12)=  ;CHARGE DESCRIPTION
 S FDA(FN,IENS,.13)=$G(BOPI)  ;QUEUE IEN
 D UPDATE^DIE(,"FDA",,"MSG")
 Q
