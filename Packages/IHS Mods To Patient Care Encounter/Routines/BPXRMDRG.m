BPXRMDRG ; IHS/CIA/MGH - Use V Meds in reminder resolution. ;25-Jan-2006 10:36;MGH
 ;;1.5;CLINICAL REMINDERS;**1003,1004**;Jun 19, 2000
 ;===================================================================
VMEDS(DFN) ;EP  Find a patients meds in the V Med file
 ;Check each med to see if its already in the array
 ;If not, add it to the list to be used in the reminder
 ;The list is kept in
 ;^XTMP(PXRMDFN,"PSDRUG",DRUG,DATE)=ORDER_U_STATUS_U_RDATE_U_DSUP
 ;===================================================================
 N ORDER,DRUG,SDATE,VMIEN,RXNUM,DSUP,DATE,RX
 Q:'$D(^AUPNVMED("AC",DFN))
 S (VMIEN,RXNUM)=0 F  S VMIEN=$O(^AUPNVMED("AC",DFN,VMIEN)) Q:VMIEN=""  D
 .S RXNUM=$$RX(VMIEN)
 .I RXNUM="" D STORE
 Q
RX(VIEN) ;Send the V Med ien and check it against the cross reference in
 ;the prescription file. If its not there, this med will need to be
 ;added to the list for the reminder
 S RX=0 S RX=$O(^PSRX("APCC",VIEN,RX))
 Q RX
STORE ;Store the needed data into XTMP for use in reminders
 N TEMP,STATUS,RDATE
 S TEMP=$G(^AUPNVMED(VMIEN,0))
 Q:TEMP=""
 S DRUG=$P(TEMP,U,1)
 I (DRUG=0)!('$D(^PSDRUG(DRUG))#10) Q  ;IHS/OKCAO/POC
 S DRUG=$P($G(^PSDRUG(DRUG,0)),U,1)
 S STATUS="ACTIVE",ORDER="O"
 I $P(TEMP,U,8)'="" S STATUS="DISCONTINUED"
 ;Get the event date/time, add the days prescribed to it
 ;If days prescribed is null, add 90 days to find an ending date
 S RDATE=$P($G(^AUPNVMED(VMIEN,12)),U,1)
 S DSUP=$P(TEMP,U,7)
 S DATE=+$$FMADD^XLFDT(RDATE,DSUP)
 S ^XTMP(PXRMDFN,"PSDRUG",DRUG,DATE)=ORDER_U_STATUS_U_RDATE_U_DSUP
 Q
