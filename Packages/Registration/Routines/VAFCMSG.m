VAFCMSG ;ALB/JRP-BACKGROUND JOB TO TRANSMIT ENTRIES IN PIVOT FILE ;12-SEP-1996
 ;;5.3;Registration;**91,149**;Jun 06, 1996
 ;
MAIN ;Main entry point for background job
 ;
 ;attempt to lock non existant global.
 L +^VAT(391.71,"VAFC BATCH UPDATE ADT/HL7"):1 I '$T Q
 ;Send messages ? 0=STOP,2=SUSPEND
 N SEND
 S SEND=$P($$SEND^VAFHUTL(),"^",2)
 I (SEND=0)!(SEND=2) L -^VAT(391.71,"VAFC BATCH UPDATE ADT/HL7") Q
 ;Send Registration messages
 D BCSTA04
 ;Send changes to patient's demographical data (ADT-A08)
 D BCSTA08
 ;Send changes to patient's treating facility list (MFU-M05)
 D BCKTFMFU^VAFCTFMF
 ;unlock global
 L -^VAT(391.71,"VAFC BATCH UPDATE ADT/HL7")
 Q
 ;
BCSTA08 ;Broadcast ADT-A08 messages for all entries in ADT/HL PIVOT file
 ;(#391.71) that have been marked for transmission
 ;
 ;Input  : None
 ;Output : None
 ;
 ;Declare variables
 N PIVOTPTR,NODE,DFN,EDITDATE,TMP,INFOARR
 S INFOARR="^TMP(""VAFCMSG"","_$J_",""EVNTINFO"")"
 K @INFOARR
 ;Loop through pivot file based on demographic updates
 S PIVOTPTR=0
 F  S PIVOTPTR=+$O(^VAT(391.71,"AXMIT",4,PIVOTPTR)) Q:('PIVOTPTR)  D
 .;Bad entry in cross reference - delete it and quit
 .I ('$D(^VAT(391.71,PIVOTPTR))) K ^VAT(391.71,"AXMIT",4,PIVOTPTR) Q
 .;Get event date and pointer to patient
 .S NODE=$G(^VAT(391.71,PIVOTPTR,0))
 .S EDITDATE=+NODE
 .S DFN=+$P(NODE,"^",3)
 .;Bad pointer to patient - mark entry as transmitted and quit
 .I ('$D(^DPT(DFN,0)))!($G(^DPT(DFN,-9))) D XMITFLAG^VAFCDD01(PIVOTPTR,"",1) Q
 .;Store info into event information array
 .K @INFOARR
 .S @INFOARR@("PIVOT")=PIVOTPTR
 .;Event reason code
 .;  99 = Death     98 = Resurrection   97=Sensitivity Update
 .;  Death will overwrite any other reason code. It is the 
 .;  dominant reason code.
 .S @INFOARR@("REASON",1)=""
 .S @INFOARR@("REASON",1)=$P($G(^VAT(391.71,PIVOTPTR,0)),"^",10)
 .I (+$G(^DPT(DFN,.35))) S @INFOARR@("REASON",1)=99
 .;
 .; user/operator name from duz
 .S DIC="^VA(200,",DIC(0)="MZO",X="`"_+$P(NODE,"^",9) D ^DIC
 .S @INFOARR@("USER")=$P($G(Y),"^",2)
 .;
 .S @INFOARR@("EVENT-NUM")=$P(NODE,"^",2)
 .S @INFOARR@("VAR-PTR")=$P(NODE,"^",5)
 .;
 .;Broadcast ADT-A08 message
 .S TMP=$$BCSTADT^VAFCMSG0(DFN,"A08",EDITDATE,INFOARR)
 .;Store result in pivot file
 .S:$P(TMP,U,2)]"" TMP=$P(TMP,U,2) D FILERM^VAFCUTL(PIVOTPTR,TMP)
 .;Error broadcasting message
 .Q:(TMP<0)
 .;Mark entry in pivot file as transmitted
 .D XMITFLAG^VAFCDD01(PIVOTPTR,"",1)
 ;Done - clean up and quit
 K @INFOARR
 Q
 ;
BCSTA04 ;Broadcast ADT-A04 messages for all entries in ADT/HL PIVOT file
 ;(#391.71) that have been marked for transmission
 ;
 ;Input  : None
 ;Output : None
 ;
 ;Declare variables
 N PIVOTPTR,NODE,DFN,EDITDATE,FIELDS,RESULT
 S PIVOTPTR=0
 F  S PIVOTPTR=+$O(^VAT(391.71,"AXMIT",3,PIVOTPTR)) Q:('PIVOTPTR)  D
 .;Bad entry in cross reference - delete it and quit
 .I ('$D(^VAT(391.71,PIVOTPTR))) K ^VAT(391.71,"AXMIT",3,PIVOTPTR) Q
 .;Get event date and pointer to patient
 .S NODE=$G(^VAT(391.71,PIVOTPTR,0))
 .S FIELDS=$G(^VAT(391.71,PIVOTPTR,2))
 .S USER=+$P(NODE,"^",9)
 .S EDITDATE=+NODE
 .S DFN=+$P(NODE,"^",3)
 .;Bad pointer to patient - mark entry as transmitted and quit
 .I ('$D(^DPT(DFN,0)))!($G(^DPT(DFN,-9))) D XMITFLAG^VAFCDD01(PIVOTPTR,"",1) Q
 .;Broadcast ADT-A04 message
 .S RESULT=$$EN^VAFCA04(DFN,EDITDATE,USER,PIVOTPTR)
 .D XMITFLAG^VAFCDD01(PIVOTPTR,"",1)
 ;Done - quit
 Q
