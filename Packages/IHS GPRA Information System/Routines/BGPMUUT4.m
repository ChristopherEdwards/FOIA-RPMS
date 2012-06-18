BGPMUUT4 ;IHS/MSC/MGH - Find is med is active on date ;02-Mar-2011 16:53;MGH
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 Q
FIND(DFN,TAX,BDATE,MEDTYPE,EDATE) ; EP
 ;This function is designed to see if the patient has any drugs
 ;in the given taxonomy that were active on the date(s) in question
 ;
 N BGPYR,BGPIND,BGPINDIC,BGPNODE,BGPRX,BGPTYPE,BGPIDX,BGPMED,BGPEND,FOUND
 K ^TMP("PS",$J)
 ;Start by getting the patients drugs from 1 year prior to
 ;discharge date since prescriptions are only good for 1 year
 S BDATE=$P(BDATE,".",1),EDATE=$G(EDATE)        ;don't worry about time
 S BGPYR=$$FMADD^XLFDT(BDATE,-365)
 I $G(EDATE) S BGPEND=EDATE
 I $G(EDATE)="" S BGPEND=$$FMADD^XLFDT(BDATE,+1)
 D OCL^PSOORRL(DFN,BGPYR,BGPEND)
 S BGPIND=0,BGPINDIC="",FOUND=0
 F  S BGPIND=$O(^TMP("PS",$J,BGPIND))  Q:'+BGPIND!(+FOUND)  D
 .S BGPNODE=$G(^TMP("PS",$J,BGPIND,0))
 .S BGPRX=+($P(BGPNODE,U,1))
 .Q:$L($P(BGPNODE,U,2))=0   ;Discard Blank Meds
 .;Only use the type of meds chosen (OP,UD,IV)
 .S BGPTYPE=$P($P(BGPNODE,U),";",2)
 .S BGPTYPE=$S(BGPTYPE="O":"OP",BGPTYPE="I":"UD",1:"")
 .I $O(^TMP("PS",$J,BGPIND,"A",0))>0 S BGPTYPE="IV"
 .E  I $O(^TMP("PS",$J,BGPIND,"B",0))>0 S BGPTYPE="IV"
 .I BGPTYPE=MEDTYPE!(MEDTYPE="ALL") D
 ..S BGPMED=$P(BGPNODE,U,2)
 ..I MEDTYPE="OP"!(MEDTYPE="ALL") S BGPIDX=$O(^PSDRUG("B",BGPMED,0))
 ..N IDX,ID
 ..S ID=$P(BGPNODE,U),IDX=+ID,ID=$E(ID,$L(IDX)+1,$L(ID))
 ..;Check dates on outpt RX
 ..I ID="R;O" S FOUND=$$OUTPAT(BGPIDX,IDX,ID,BDATE,BGPEND,TAX) Q:+FOUND
 ..;Check date on unit dose
 ..I ID="U;I" S FOUND=$$INPAT(DFN,IDX,ID,BDATE,BGPEND,TAX) Q:+FOUND
 ..;Save for later if we need to do IVs
 ..I ID="V;I" S FOUND=$$IV(DFN,IDX,ID,BDATE,BGPEND,TAX) Q:+FOUND
 ..;Check on dates for NVA med
 ..;DC is Dc'd date, ST=start date, ED=documented date
 ..I ID="N;O" S FOUND=$$NVA(BGPIDX,IDX,BGPEND,TAX)
 ;check the V med file
 I DUZ("AG")="I"&(FOUND=0) S FOUND=$$VMED(DFN,BDATE,TAX)
 Q FOUND
OUTPAT(BGPIDX,IDX,ID,BDATE,BGPEND,TAX) ;EP
 ;Check for active prescription on date
 N N0,N2,N3,ID,RTC,EXP,CA,QD,NR,END,DS,RD,RETURN
 S RETURN=0
 Q:'+BGPIDX 0
 S N0=$G(^PSRX(IDX,0)),N2=$G(^PSRX(IDX,2)),N3=$G(^PSRX(IDX,3))
 S ID=$P(N0,U,13)             ;Issue Date
 I ID>BGPEND Q 0              ;Med was issued too late
 S RD=$P(N2,U,13),RTC=$P(N2,U,15),EXP=$P(N2,U,6)
 Q:RD="" RETURN               ;Never released
 ;Q:RTC'="" RETURN             ;Return to stock
 Q:EXP<BDATE RETURN           ;Expired before the date in question
 S CA=$P(N3,U,5)
 I +CA&(CA<BDATE) Q RETURN   ;Cancelled before the date in question
 ;Med was issued on the date in question
 I $P(ID,".",1)=BDATE!($P(ID,".",1)=$P(BGPEND,".",1)) D
 .S RETURN=$$NDC(BGPIDX,TAX)_U_RD
 ;Issue date was prior to discharge, could be already on it
 I $P(ID,".",1)<BDATE D
 .S DS=$P(N0,U,8),NR=$P(N0,U,9)
 .;Get days supply times the number of refills and add to release
 .;date to get the last date this could be active
 .I NR>0 S DS=DS*NR
 .S END=$$FMADD^XLFDT(RD,+DS)
 .;if this date is after the discharge date, it was an active med
 .;see if it is in the chosen taxonomy
 .I END>BDATE S RETURN=$$NDC(BGPIDX,TAX)_U_RD
 Q RETURN
NVA(BGPIDX,IDX,BGPEND,TAX) ;Check Non-VA meds
 N N0,STATUS,ST,ED,DC,RESULT
 S N0=$G(^PS(55,DFN,"NVA",IDX,0))
 S DC=$P(N0,U,7),ST=$P(N0,U,9),ED=$P(N0,U,10),STATUS=$P(N0,U,6)
 S RESULT=0
 Q:'+BGPIDX RESULT
 I STATUS'="" Q RESULT
 I +DC&(DC<BGPEND) Q RESULT         ;Discontinued before discharge
 I +ST&(ST>BGPEND) Q RESULT         ;Started too late
 I +ED&(ED>BGPEND) Q RESULT         ;Started too late
 S RESULT=$$NDC(BGPIDX,TAX)             ;See if drug is in taxonomy
 Q RESULT
VMED(DFN,BDATE,TAX) ;Search for V med entries
 N DRUG,VIEN,VMIEN,RESULT,VMIEN,RXNUM,DATE,RX,TEMP,RDATE,DRUG
 S RESULT=0
 Q:'$D(^AUPNVMED("AC",DFN)) RESULT
 S (VMIEN,RXNUM)=0 F  S VMIEN=$O(^AUPNVMED("AC",DFN,VMIEN)) Q:VMIEN=""!(+RESULT)  D
 .S RXNUM=$$RX(VMIEN)
 .I RXNUM="" D
 ..S TEMP=$G(^AUPNVMED(VMIEN,0))
 ..I TEMP="" Q
 ..S DRUG=$P(TEMP,U,1)
 ..I DRUG=0 Q
 ..I +$P(TEMP,U,8)&($P(TEMP,U,8)<BDATE) Q          ;Discontinued before discharge
 ..;Get the event date/time, add the days prescribed to it
 ..;If days prescribed is null, add 90 days to find an ending date
 ..S RDATE=$P($G(^AUPNVMED(VMIEN,12)),U,1)
 ..I +RDATE&(RDATE>BDATE) Q              ;Released after pt discharged
 ..I +RDATE=0 D
 ...S VIEN=$P($G(^AUPNVMED(VMIEN,0)),U,3)
 ...I VIEN S RDATE=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 ..S DATE=+$$FMADD^XLFDT(RDATE,+365)
 ..I DATE>BDATE D                ;release date+365 days is after discharge date=active
 ...;Find out if this drug is in the taxonomy
 ...S RESULT=$$NDC(DRUG,TAX)
 ...I +RESULT S RESULT=RESULT_U_RDATE
 Q RESULT
RX(VIEN) ;Send the V Med ien and check it against the cross reference in
 ;the prescription file. If its not there, this med will need to be
 ;added to the list for the reminder
 N RX
 S RX=0 S RX=$O(^PSRX("APCC",VIEN,RX))
 Q RX
NDC(BGPIDX,TAX) ;Find out if this drug is in the taxonomy
 N NDC,NDCCODE,NDCF
 Q:'BGPIDX 0
 S NDCF=0
 S NDC=$P($G(^PSDRUG(BGPIDX,2)),U,4)
 Q:'NDC 0
 ;Setup the NDC code for a proper lookup in the taxonomy
 S NDCCODE=$$RJ^XLFSTR($P(NDC,"-"),5,0)_$$RJ^XLFSTR($P(NDC,"-",2),4,0)_$$RJ^XLFSTR($P(NDC,"-",3),2,0)
 ;call the taxonomy lookup
 S NDCF=$$MEDTAX^BGPMUUT3(DFN,NDCCODE,TAX)
 Q NDCF
INPAT(DFN,IDX,ID,BDATE,BGPEND,TAX) ;EP
 N RESULT,NODE,NODE2,DISP,NDC
 S RESULT=0
 S NODE=$G(^PS(55,DFN,5,IDX,0))
 S NODE2=$G(^PS(55,DFN,5,IDX,2))
 I $P(NODE2,U,2)>BDATE D              ;Med started after start date
 .I ($P($P(NODE2,U,4),".",1)=$P(BGPEND,".",1))!($P(NODE2,U,4)>BGPEND) D
 ..;Med was active in range suggested
 ..;Now find the dispense drug(s) and see if they are in the taxonomy
 ..S X=0 F  S X=$O(^PS(55,DFN,5,IDX,1,X)) Q:'+X!(+RESULT)  D
 ...S DISP=$G(^PS(55,DFN,5,IDX,1,X,0))
 ...S DRUG=$P(DISP,U,1)
 ...I +DRUG S RESULT=$$NDC(DRUG,TAX)
 ...I +RESULT S RESULT=RESULT_U_$P(NODE,U,2)
 Q RESULT
 Q
IV(DFN,IDX,ID,BDATE,BGPEND,TAX) ;EP
 N RESULT,NODE,ADD,SOL,DRUG,GDRUG
 S RESULT=0
 S NODE=$G(^PS(55,DFN,"IV",IDX,0))
 I $P(NODE,U,2)>BDATE D     ;Med started after start date
 .I ($P($P(NODE,U,3),".",1)=$P(BGPEND,".",1))!($P(NODE,U,3)<BGPEND) D
 ..;Med was active, now find the dispense drug and see if in taxonomy
 ..S ADD=0 F  S ADD=$O(^PS(55,DFN,"IV",IDX,"AD",ADD)) Q:ADD=""!(+RESULT)  D
 ...S DRUG=$P($G(^PS(55,DFN,"IV",IDX,"AD",ADD,0)),U,1)
 ...I +DRUG S GDRUG=$P($G(^PS(52.6,DRUG,0)),U,2)
 ...S RESULT=$$NDC(GDRUG,TAX)
 ..I '+RESULT D
 ...S SOL=0 F  S SOL=$O(^PS(55,DFN,"IV",IDX,"SOL",SOL)) Q:SOL=""!(+RESULT)  D
 ....S DRUG=$P($G(^PS(55,DFN,"IV",IDX,"SOL",SOL,0)),U,1)
 ....I +DRUG S GDRUG=$P($G(^PS(52.7,DRUG,0)),U,2)
 ....S RESULT=$$NDC(GDRUG,TAX)
 ....I +RESULT S RESULT=RESULT_U_$P(NODE,U,2)
 Q RESULT
