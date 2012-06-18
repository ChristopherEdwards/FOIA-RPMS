BGPMUUT8 ;IHS/MSC/MGH - Find is med is active on date ;14-Jul-2011 11:20;DU
 ;;11.1;IHS CLINICAL REPORTING SYSTEM;**1**;JUN 27, 2011;Build 106
 Q
FIND(DFN,TAX,BDATE,EP,EDATE,VALID) ; EP
 ;This function is designed to see if the patient has any drugs
 ;in the given taxonomy that were active on the date(s) in question
 ;
 N BGPYR,BGPIND,BGPINDIC,BGPNODE,BGPRX,BGPTYPE,BGPIDX,BGPMED,BGPEND,FOUND
 K ^TMP("PS",$J)
 ;Start by getting the patients drugs from 1 year prior to
 ;discharge date since prescriptions are only good for 1 year
 S BDATE=$P(BDATE,".",1),EDATE=$G(EDATE)        ;don't worry about time
 S BGPYR=$$FMADD^XLFDT(BDATE,-365)
 I $G(EDATE)="" S EDATE=BGPEDATE
 D OCL^PSOORRL(DFN,BGPYR,EDATE)
 S BGPIND=0,BGPINDIC="",FOUND=0
 F  S BGPIND=$O(^TMP("PS",$J,BGPIND))  Q:'+BGPIND!(+FOUND)  D
 .S BGPNODE=$G(^TMP("PS",$J,BGPIND,0))
 .S BGPRX=+($P(BGPNODE,U,1))
 .Q:$L($P(BGPNODE,U,2))=0   ;Discard Blank Meds
 .;Only use outpt meds
 .S BGPTYPE=$P($P(BGPNODE,U),";",2)
 .I BGPTYPE="O" D
 ..S BGPMED=$P(BGPNODE,U,2)
 ..S BGPIDX=$O(^PSDRUG("B",BGPMED,0))
 ..N IDX,ID
 ..S ID=$P(BGPNODE,U),IDX=+ID,ID=$E(ID,$L(IDX)+1,$L(ID))
 ..;Check dates on outpt RX
 ..I ID="R;O" S FOUND=$$OUTPAT(BGPIDX,IDX,ID,BDATE,EDATE,TAX,EP,$G(VALID))
 ..I EP=""&('+FOUND) D
 ...I ID="N;O" S FOUND=$$NVA(BGPIDX,IDX,BDATE,EDATE,TAX)
 ;check the V med file
 I EP=""&('+FOUND) S FOUND=$$VMED(DFN,BDATE,EDATE,TAX)
 Q FOUND
OUTPAT(BGPIDX,IDX,ID,BDATE,EDATE,TAX,EP,VALID) ;EP
 ;Check for active prescription on date
 N MATCH,N0,N2,N3,ID,RTC,EXP,CA,QD,NR,END,DS,RD,RETURN,PROV
 S RETURN=0,MATCH=0
 Q:'+BGPIDX 0
 S N0=$G(^PSRX(IDX,0)),N2=$G(^PSRX(IDX,2)),N3=$G(^PSRX(IDX,3))
 S EP=$G(EP)
 ;If the rule is that the RX has to be written by the EP, check it right away
 I EP'="" D
 .S PROV=$P(N0,U,4)            ;Ordering provider
 .I PROV=EP  S MATCH=1         ;Quit if not EP
 I EP'=""&(MATCH=0) Q RETURN
 S ID=$P(N0,U,13)              ;Issue Date
 I ID>EDATE Q 0                ;Med was issued too late
 I VALID=1&(ID<BDATE) Q 0
 S RD=$P(N2,U,13),RTC=$P(N2,U,15),EXP=$P(N2,U,6)
 ;Q:RD="" RETURN               ;Never released
 ;Q:RTC'="" RETURN             ;Return to stock
 Q:EXP<BDATE RETURN           ;Expired before the date in question
 S CA=$P(N3,U,5)
 I +CA&(CA<BDATE) Q RETURN     ;Cancelled before the date in question
 ;Issue date was prior to enddate
 I $P(ID,".",1)<EDATE D
 .S DS=$P(N0,U,8),NR=$P(N0,U,9)
 .;Get days supply times the number of refills and add to release
 .;date to get the last date this could be active
 .I NR>0 S DS=DS*NR
 .S END=$$FMADD^XLFDT(ID,+DS)
 .;if this date is after the discharge date, it was an active med
 .;see if it is in the chosen taxonomy
 .I END>BDATE S RETURN=$$NDC(BGPIDX,TAX)
 Q RETURN_U_ID
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
NVA(BGPIDX,IDX,BDATE,EDATE,TAX) ;Check Non-VA meds
 N N0,STATUS,ST,ED,DC,RESULT
 S N0=$G(^PS(55,DFN,"NVA",IDX,0))
 S DC=$P(N0,U,7),ST=$P(N0,U,9),ED=$P(N0,U,10),STATUS=$P(N0,U,6)
 S RESULT=0
 Q:'+BGPIDX RESULT
 I STATUS'="" Q RESULT
 I ST="" S ST=ED
 I +DC&(DC<BDATE) Q RESULT          ;Discontinued before start of reporting period
 I +ST&(ST>EDATE) Q RESULT          ;Started too late
 S RESULT=$$NDC(BGPIDX,TAX)         ;See if drug is in taxonomy
 I +RESULT S RESULT=RESULT_U_ST
 Q RESULT
VMED(DFN,BDATE,EDATE,TAX) ;Search for V med entries
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
 ..I +$P(TEMP,U,8)&($P(TEMP,U,8)<BDATE) Q          ;Discontinued beginning
 ..;Get the event date/time, add the days prescribed to it
 ..;If days prescribed is null, add 90 days to find an ending date
 ..S RDATE=$P($G(^AUPNVMED(VMIEN,12)),U,1)
 ..I +RDATE=0 D
 ...S VIEN=$P($G(^AUPNVMED(VMIEN,0)),U,3)
 ...I VIEN S RDATE=$P($G(^AUPNVSIT(VIEN,0)),U,1)
 ..I +RDATE&(RDATE>EDATE) Q              ;Released after reporting period
 ..I +RDATE&(RDATE<BDATE) Q              ;Released before reporting period
 ..;Find out if this drug is in the taxonomy
 ..;Find out if this drug is in the taxonomy
 ..S RESULT=$$NDC(DRUG,TAX)
 ..I +RESULT S RESULT=RESULT_U_RDATE
 Q RESULT
RX(VIEN) ;Send the V Med ien and check it against the cross reference in
 ;the prescription file. If its not there, this med will need to be
 ;added to the list for the reminder
 N RX
 S RX=0 S RX=$O(^PSRX("APCC",VIEN,RX))
 Q RX
