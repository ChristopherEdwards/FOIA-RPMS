BGOVSTR2 ; MSC/JS - Utility calls for V STROKE ;12-Nov-2014 14:03;PLS
 ;;1.1;BGO COMPONENTS;**13,14**;Mar 20, 2007
 ;01.24.14 - MSC/JS - move SET here to keep within 15k routine size limits
 ;02.06.14 - MSC/MGH Changed field .17 to store text
 ;05.01.14 - MSC/DKA Allow neither Fib Init nor Fib Not Init.
 ;
 ;Add/edit V STROKE entry
SET(RET,INP) ;EP
 ; INP is an array of strings.
 ; The first string is the VFIEN^NumberOfLines^VisitIsLocked
 ; Each subsequent string is prefixed with a letter indicating the type of record:
 ; A   - Arrival
 ; AT  - Arrival Text (Comment)
 ; F   - Fibrinolytic Therapy
 ; FT  - Fibrinolytic Therapy Text (Comment)
 ; N   - NIH Stroke Scale (Multiple)
 ; P   - Protocol Standing Orders (Multiple)
 ; PT  - Standing Order Comment (Multiple)
 ; SS  - Stroke Symptoms (Multiple)
 ; ST  - Stroke Symptoms EKG Findings Comment (Multiple)
 ; MA  - NIH Motor Arm Comments
 ; ML  - NIH Motor Limb Comments
 ; LA  - NIH Limb Ataxia Comment
 ; DY  - NIH Dysarthria Comment
 N BASELINE,DESCT,I,FDA,FNUM,NI,NIHDATE,NIHTOTAL,NOW,NUMNEW,NARR,NARRPTR,REFUSED,AARDT,EVTDT,EVTSTR,FIBTXT,REFDT,DFN
 N QIEN,DEL,QUAL,QUALS,SNOMED,SUBIEN,SUM,TYPE,VCODE,VFIEN,VFLDERR,VFNEW,VFSTR,VI,VIEN,VMIEN,VMINP,VISDAT,ARRDT,VFCOMM,VFVAL,FI
 S RET="",FNUM=$$FNUM
 S VFIEN=+INP(0)
 S VFNEW='VFIEN
 S VIEN=$P(INP(1),U,4)
 S VISDAT=$G(^AUPNVSIT(VIEN,0))
 S DFN=$P(VISDAT,U,5)
 I $G(DFN)="" S RET=$$ERR^BGOUTL(1062) Q
 S NOW=$$NOW^XLFDT ; Use the same value for Date/Time Entered fields
 S RET=$$CHKVISIT^BGOUTL(VIEN) Q:RET
 I VFNEW I VFIEN=0 S VFIEN=NOW
 I VFNEW D VFNEW^BGOUTL2(.RET,FNUM,VFIEN,VIEN) S:RET>0 VFIEN=RET,RET=""
 I 'VFIEN S RET=$$ERR^BGOUTL(1070) Q
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 F VI=1:1:$P(INP(0),U,2) D
 .S VFSTR=$G(INP(VI)) Q:VFSTR=""
 .S VCODE=$P(VFSTR,U)
 .I VCODE="A" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S ARRDT=$P(VFSTR,U,2)
 ..I ARRDT>0,ARRDT'["." S ARRDT=(ARRDT-1)+.24
 ..S @FDA@(.01)=ARRDT ;ArrivalDateTime
 ..S @FDA@(.04)=$P(VFSTR,U,3) ;Handedness
 ..S @FDA@(1203)=$$GET1^DIQ(44,$P(VFSTR,U,5),8,"I") ;Clinic
 ..S @FDA@(1204)=$P(VFSTR,U,6) ;EncounterProvider
 ..S EVTDT=$P(VFSTR,U,7)
 ..I EVTDT>0,EVTDT'["." S EVTDT=(EVTDT-1)+.24
 ..S @FDA@(1201)=EVTDT ;EventDateTime
 ..S BASELINE=EVTDT
 .E  I VCODE="AT" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S VFCOMM=$P(VFSTR,U,2) ; Comment (Date/Time Arrival)
 ..I VFCOMM="" S @FDA@(1)="@" ; Delete the comment, whether or not it already exists.
 ..E  D
 ...S @FDA@(1)=$NA(FDA(FNUM,VFIEN_",",1))
 ...S @FDA@(1,0)=$G(@FDA@(1,0))+1
 ...S @FDA@(1,@FDA@(1,0))=VFCOMM
 .E  I VCODE="F" D
 ..; 2014-05-01 DKA If no date is sent, then clear both FibInit and FibNotInit fields,
 ..;                else if a reason is not sent, set FibInit and clear FibNotInit fields,
 ..;                otherwise set FibNotInit and clear FibInit fields.
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..;First check to see if neither FT Initiated nor FT Not Initiated (None button checked)
 ..I $P(VFSTR,U,2,3)=U F FI=.11:.01:.17 S @FDA@(FI)="@" ; Clear all the FibInit and FibNotInit fields
 ..E  I $P(VFSTR,U,4)="" D
 ...; FT Initiated
 ...S @FDA@(.11)=$P(VFSTR,U,2) ;FibrinolyticTherapyInitiated
 ...S:@FDA@(.11)'=""&(@FDA@(.11)'[".") @FDA@(.11)=@FDA@(.11)-1+.24
 ...S @FDA@(.12)=NOW,@FDA@(.13)=DUZ
 ...S @FDA@(.14)="@"
 ...S @FDA@(.15)="@"
 ...S @FDA@(.16)="@"
 ...S @FDA@(.17)="@"
 ...;IHS/MSC/MGH Try to remove any refusal reason if this is an edit
 ...D DELREF^BGOVSTR1(VFIEN)
 ..E  D
 ...; FT Not Initiated
 ...S (@FDA@(.14),REFDT)=$P(VFSTR,U,3) ;DidNotInit
 ...S:@FDA@(.14)'=""&(@FDA@(.14)'[".") @FDA@(.14)=@FDA@(.14)-1+.24
 ...S @FDA@(.15)=NOW,@FDA@(.16)=DUZ
 ...;S (@FDA@(.17),REFUSED)=$P(VFSTR,U,4) ;DidnotInitReason
 ...S REFUSED=$P(VFSTR,U,4)
 ...S FIBTXT=$$GET1^DIQ(9999999.102,REFUSED,.01)
 ...S @FDA@(.17)=FIBTXT
 ...S @FDA@(.11)="@"
 ...S @FDA@(.12)="@"
 ...S @FDA@(.13)="@"
 .E  I VCODE="FT" D
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S VFCOMM=$P(VFSTR,U,2) ; Fibrinolytic Therapy Comment
 ..I VFCOMM="" S @FDA@(4)="@" ; Delete the comment, whether or not it already exists.
 ..E  D
 ...S @FDA@(4)=$NA(FDA(FNUM,VFIEN_",",4))
 ...S @FDA@(4,0)=$G(@FDA@(4,0))+1
 ...S @FDA@(4,@FDA@(4,0))=VFCOMM
 .E  I VCODE="N" D  ;NIH Stroke Scale (Multiple-9000010.6315), [15;0]
 ..S SUBIEN=$P(VFSTR,U,2)
 ..I $G(SUBIEN)]"" Q:'$D(^AUPNVSTR(VFIEN,15,+SUBIEN))
 ..S DEL=$P(VFSTR,U,5)  ;Delete flag
 ..I +SUBIEN&(DEL="@") D DEL(RET,VFIEN,SUBIEN) Q
 ..I SUBIEN="" S NUMNEW=$G(NUMNEW)+1,SUBIEN="+"_NUMNEW
 ..S SUBIEN=SUBIEN_","_VFIEN_","
 ..S FDA=$NA(FDA(FNUM_15,SUBIEN))
 ..;$p3 = .01 field (DateTime)
 ..S @FDA@(.01)=$S($P(VFSTR,U,3)>0:$P(VFSTR,U,3),1:NOW)
 ..S:@FDA@(.01)'=""&(@FDA@(.01)'[".") @FDA@(.01)=@FDA@(.01)-1+.24
 ..S @FDA@(.02)=$P(VFSTR,U,4) ;.02
 ..S:@FDA@(.02)'=""&(@FDA@(.02)'[".") @FDA@(.02)=@FDA@(.02)-1+.24
 ..S @FDA@(.03)=DUZ ;.03
 ..S VFVAL=$P(VFSTR,U,6),@FDA@(.04)=$S(VFVAL="":"@",1:VFVAL) ;.04
 ..S VFVAL=$P(VFSTR,U,7),@FDA@(.05)=$S(VFVAL="":"@",1:VFVAL) ;.05
 ..S VFVAL=$P(VFSTR,U,8),@FDA@(.06)=$S(VFVAL="":"@",1:VFVAL) ;.06
 ..S VFVAL=$P(VFSTR,U,9),@FDA@(.07)=$S(VFVAL="":"@",1:VFVAL) ;.07
 ..S VFVAL=$P(VFSTR,U,10),@FDA@(.08)=$S(VFVAL="":"@",1:VFVAL) ;.08
 ..S VFVAL=$P(VFSTR,U,11),@FDA@(.09)=$S(VFVAL="":"@",1:VFVAL) ;.09
 ..S VFVAL=$P(VFSTR,U,12),@FDA@(.1)=$S(VFVAL="":"@",1:VFVAL) ;.1
 ..S VFVAL=$P(VFSTR,U,13),@FDA@(.11)=$S(VFVAL="":"@",1:VFVAL) ;.11
 ..S VFVAL=$P(VFSTR,U,14),@FDA@(.12)=$S(VFVAL="":"@",1:VFVAL) ;.12
 ..S VFVAL=$P(VFSTR,U,15),@FDA@(.13)=$S(VFVAL="":"@",1:VFVAL) ;.13
 ..S VFVAL=$P(VFSTR,U,16),@FDA@(.14)=$S(VFVAL="":"@",1:VFVAL) ;.14
 ..S VFVAL=$P(VFSTR,U,17),@FDA@(.15)=$S(VFVAL="":"@",1:VFVAL) ;.15
 ..S VFVAL=$P(VFSTR,U,18),@FDA@(.16)=$S(VFVAL="":"@",1:VFVAL) ;.16
 ..S VFVAL=$P(VFSTR,U,19),@FDA@(.17)=$S(VFVAL="":"@",1:VFVAL) ;.17
 ..S VFVAL=$P(VFSTR,U,20),@FDA@(.18)=$S(VFVAL="":"@",1:VFVAL) ;.18
 ..S NIHTOTAL=0 F SUM=6:1:20 S NIHTOTAL=NIHTOTAL+$P($G(VFSTR),U,SUM)
 ..S @FDA@(.19)=NIHTOTAL ;.19
 ..N COMCODE,COMSTR,ZI D  ;check for NIH comment fields
 ...;F ZI=1:1:$P(INP(0),U,2) D
 ...F ZI=VI+1:1:VI+4 D
 ....S COMSTR=$G(INP(ZI)) Q:COMSTR=""
 ....S COMCODE=$P(COMSTR,U)
 ....I COMCODE="MA" D
 .....S VFCOMM=$P(COMSTR,U,3) ;1.01
 .....S @FDA@(1.01)=$S(VFCOMM="":"@",1:VFCOMM)
 .....S VFCOMM=$P(COMSTR,U,4) ;1.02
 .....S @FDA@(1.02)=$S(VFCOMM="":"@",1:VFCOMM)
 ....I COMCODE="ML" D
 .....S VFCOMM=$P(COMSTR,U,3) ;2.01
 .....S @FDA@(2.01)=$S(VFCOMM="":"@",1:VFCOMM)
 .....S VFCOMM=$P(COMSTR,U,4) ;2.02
 .....S @FDA@(2.02)=$S(VFCOMM="":"@",1:VFCOMM)
 ....I COMCODE="LA" D
 .....S VFCOMM=$P(COMSTR,U,3) ;3.01
 .....S @FDA@(3.01)=$S(VFCOMM="":"@",1:VFCOMM)
 ....I COMCODE="DY" D
 .....S VFCOMM=$P(COMSTR,U,3) ;3.02
 .....S @FDA@(3.02)=$S(VFCOMM="":"@",1:VFCOMM)
 .E  I VCODE="P" D  ; Protocol Standing Orders (Sub-File)
 ..S SUBIEN=$P(VFSTR,U,2)
 ..I $G(SUBIEN)]"" Q:'$D(^AUPNVSTR(VFIEN,13,+SUBIEN))
 ..I SUBIEN["@" N NODE S NODE=",13," D DMULT^BGOVSTR1(RET,VFIEN,SUBIEN,NODE) Q
 ..I SUBIEN="" S NUMNEW=$G(NUMNEW)+1,SUBIEN="+"_NUMNEW
 ..S SUBIEN=SUBIEN_","_VFIEN_","
 ..S FDA=$NA(FDA(FNUM_13,SUBIEN))
 ..S @FDA@(.01)=$P(VFSTR,U,3)
 ..S @FDA@(.02)=$P(VFSTR,U,4)
 ..S:@FDA@(.02)'=""&(@FDA@(.02)'[".") @FDA@(.02)=@FDA@(.02)-1+.24
 ..S @FDA@(.03)=NOW
 ..S @FDA@(.04)=DUZ
 .E  I VCODE="PT" D  ;
 ..Q:+SUBIEN&(SUBIEN["@")
 ..S VFCOMM=$P(VFSTR,U,3)
 ..I VFCOMM="" S @FDA@(1)="@"
 ..E  D
 ...S @FDA@(1)=$NA(FDA(FNUM_13,SUBIEN,1))
 ...S @FDA@(1,0)=$G(@FDA@(1,0))+1
 ...S @FDA@(1,@FDA@(1,0))=VFCOMM
 .E  I VCODE="SS" D
 ..S SUBIEN=$P(VFSTR,U,2)
 ..I $G(SUBIEN)]"" Q:'$D(^AUPNVSTR(VFIEN,14,+SUBIEN))
 ..I SUBIEN["@" N NODE S NODE=",14," D DMULT^BGOVSTR1(RET,VFIEN,SUBIEN,NODE) Q
 ..I SUBIEN="" S NUMNEW=$G(NUMNEW)+1,SUBIEN="+"_NUMNEW
 ..S SUBIEN=SUBIEN_","_VFIEN_","
 ..S FDA=$NA(FDA(FNUM_14,SUBIEN))
 ..S @FDA@(.01)=$P(VFSTR,U,4) ;Concept ID
 ..S (DESCT,@FDA@(.02))=$P(VFSTR,U,3) ;Description ID
 ..S NARR=""
 ..I DESCT]"" S NARRPTR=$$NARR^BGOVSTR1(DESCT,NARR)
 ..S @FDA@(.03)=$S($G(NARRPTR)>0:NARRPTR,1:"")
 ..S @FDA@(.06)=$P(VFSTR,U,6) ;Witnessed?
 ..S @FDA@(.07)=$P(VFSTR,U,7) ;Witnessed By
 ..S:@FDA@(.07)="" @FDA@(.07)="@"
 ..S @FDA@(.08)=$P(VFSTR,U,8) ;Date/Time Witnessed
 ..I @FDA@(.08)="" S @FDA@(.08)="@"
 ..E  S:@FDA@(.08)'["." @FDA@(.08)=@FDA@(.08)-1+.24
 ..I $P(VFSTR,U,6)=1 I $P(VFSTR,U,8)="" S @FDA@(.08)=NOW
 ..S @FDA@(.09)=$P(VFSTR,U,9) ;Baseline State LOINC
 ..S @FDA@(.1)=$P(VFSTR,U,10) ;Baseline State Date/Time
 ..S:@FDA@(.1)'=""&(@FDA@(.1)'[".") @FDA@(.1)=@FDA@(.1)-1+.24
 ..S @FDA@(.04)=NOW ;          Date/Time Entered
 ..S @FDA@(.05)=DUZ ;          Entered By
 .E  I VCODE="ST" D
 ..Q:+SUBIEN&(SUBIEN["@")
 ..S VFCOMM=$P(VFSTR,U,3)
 ..I VFCOMM="" S @FDA@(1)="@"
 ..E  D
 ...S @FDA@(1)=$NA(FDA(FNUM_14,SUBIEN,1))
 ...S @FDA@(1,0)=$G(@FDA@(1,0))+1
 ...S @FDA@(1,@FDA@(1,0))=VFCOMM
 S RET=$$UPDATE^BGOUTL(.FDA,"")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN) Q RET
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 ;Patient Refusals for Service/NMI entry:
 I $G(REFUSED)]"" N RET S RET=$$SETREF^BGOVSTR1(DFN,REFUSED,REFDT,VFNEW)
 ;V Measurement LKW entry:
 I $G(BASELINE)]"" D
 .N RET1,RET2,LKW
 .S LKW=$$GET1^DIQ(9000010.63,VFIEN,1601,"I")
 .S RET1=$$SETLKW^BGOVSTR1(DFN_U_VIEN_U_BASELINE_U_LKW)
 .I +RET1 D
 ..N FDA
 ..S FDA=$NA(FDA(FNUM,VFIEN_","))
 ..S @FDA@(1601)=RET1
 ..S RET2=$$UPDATE^BGOUTL(.FDA,"")
 ;V Measurement NIH entry:
 I $G(NIHTOTAL)]"" D
 .N RET1 S RET1=$$SETNIH^BGOVSTR1(VFIEN,VIEN,.INP)
 Q RET
DEL(RET,IEN,SUBIEN) ;EP Delete the subfield
 N ERR,DA,DIK,NODE,VMIEN
 S ERR=""
 S VMIEN=$$GET1^DIQ(9000010.6315,SUBIEN_","_IEN_",",.2,"I")
 S NODE=15
 S DA(1)=IEN,DA=SUBIEN
 S DIK="^AUPNVSTR(DA(1),"_NODE_","
 S:DA ERR=$$DELETE^BGOUTL(DIK,.DA)
 I ERR'="" S RET=RET_"^"_ERR
 D STRDEL^BGOVSTR1(VMIEN)
 Q
 ; Return V File #
FNUM(RET,INP) S RET=9000010.63
 Q RET
