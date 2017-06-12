BJPN20P1 ;GDIT/HS/BEE-Prenatal Care Module 2.0 Post Install (Cont.) ; 08 May 2012  12:00 PM
 ;;2.0;PRENATAL CARE MODULE;;Feb 24, 2015;Build 63
 ;
 Q
 ;
VOB(BJPNPL,PRBIEN,NEWPRB) ;Copy Care Plan Notes to Visit Instructions, POV info, auditing
 ;
 I $G(BJPNPL)="" Q
 ;
 NEW VBIEN,HIST
 ;
 ;Loop through VOB entries for PIP problem
 S VBIEN="" F  S VBIEN=$O(^AUPNVOB("B",BJPNPL,VBIEN)) Q:VBIEN=""  D
 . ;
 . NEW NTIEN,VIEN,DFN,VDT,EVD,EVD,EPRV,LGIEN,SC,SCND,DA,IENS,VALUE,CHGIEN,AUD,PBAUD,PAUD
 . NEW LMDT,LMBY,ENDT,ENBY,INACTIVE,ACTIVE,BPIEN
 . ;
 . ;Retrieve patient/visit info
 . S VIEN=$$GET1^DIQ(9000010.43,VBIEN_",",".03","I") Q:VIEN=""
 . S DFN=$$GET1^DIQ(9000010.43,VBIEN_",",".02","I") Q:DFN=""
 . S EVD=$$GET1^DIQ(9000010.43,VBIEN_",",1201,"I")
 . S:EVD="" EVD=$$GET1^DIQ(9000010,VIEN_",",".01","I")
 . S EPRV=$$GET1^DIQ(9000010.43,VBIEN_",",1204,"I")
 . ;
 . ;Look for notes
 . S NTIEN=0 F  S NTIEN=$O(^AUPNVOB(VBIEN,21,NTIEN)) Q:'NTIEN  D
 .. NEW RET,INP,INSTR,DA,IENS,NTDT,NTPV,VVI,EIE,EIEO,ON,BY
 .. ;
 .. ;Pull info for each note
 .. S DA(1)=VBIEN,DA=NTIEN,IENS=$$IENS^DILF(.DA)
 .. S NTDT=$$GET1^DIQ(9000010.431,IENS,".02","I") S:NTDT="" NTDT=EVD  ;Date
 .. S NTPV=$$GET1^DIQ(9000010.431,IENS,".03","I") S:NTPV="" NTPV=EPRV ;Provider
 .. S INSTR(0)=$$GET1^DIQ(9000010.431,IENS,".01","I") Q:INSTR(0)=""
 .. S INP=U_VIEN_U_PRBIEN_U_DFN_U_NTDT_U_NTPV
 .. ;
 .. ;API Call to add instruction
 .. ;INP = VVI IEN [1] ^ Visit IEN [2] ^ Problem IEN [3] ^ Patient IEN [4]^ Evnt Dt [5] ^ Provider [6]
 .. ;INSTR(N)= Array of instructions
 .. ;
 .. ;Make the API call to add
 .. D SET^BJPN20P1(.RET,INP,.INSTR)
 .. I '+RET Q
 .. S VVI=+RET
 .. ;
 .. ;Now sign the instruction
 .. S RET="" D SIGN^BJPN20P1(.RET,VVI,NTPV,NTDT)
 .. ;
 .. ;Now see if instruction needs deleted
 .. ;
 .. S EIE=$$GET1^DIQ(9000010.431,IENS,"2.03","I") Q:EIE=""
 .. S EIEO=$$GET1^DIQ(9000010.431,IENS,"2.04","I")
 .. S BY=$$GET1^DIQ(9000010.431,IENS,"2.01","I")
 .. S ON=$$GET1^DIQ(9000010.431,IENS,"2.02","I")
 .. ;
 .. ;API Call to enter in error
 .. ;INP= Visit instruction ien [1] ^ Reason for eie [2] ^ comment if other [3]
 .. ;EIE(RET,INP) ;Mark an entry entered in error
 .. S INP=VVI_U_EIE_U_EIEO_U_BY_U_ON
 .. D EIE^BJPN20P1(.RET,INP)
 . ;
 . ;Get the log type
 . S VALUE=$P($G(^AUPNVOB(VBIEN,22,1,0)),U,2)
 . ;
 . ;Process Problem Adds
 . S PBAUD=0 I VALUE="Added Problem To PIP" S PBAUD=1
 . ;
 . ;Handle POV updates/removes
 . ;
 . ;Determine service category and which node to use
 . S SC=$$GET1^DIQ(9000010,VIEN_",",".07","I") Q:SC=""
 . S SCND=14 S:SC="H" SCND=15
 . S DA(1)=VBIEN,DA=1,IENS=$$IENS^DILF(.DA)
 . ;
 . ;Set the POV
 . I VALUE="Set Problem As POV For Visit" D
 .. ;Add POV to the problem multiple
 .. Q:PRBIEN=""
 .. Q:$D(^AUPNPROB(PRBIEN,SCND,"B",VIEN))  ;Already set
 .. N PRIEN,FDA,IEN,ERR
 .. S PRIEN="+1,"_PRBIEN_","
 .. S FDA("9000011."_SCND,PRIEN,.01)=VIEN
 .. D UPDATE^DIE(,"FDA","IEN","ERR")
 . ;
 . ;Remove the POV
 . I VALUE="Removed Problem As POV For Visit" D
 .. N IEN,FDA,OKAY,ERR
 .. Q:PRBIEN=""
 .. ;
 .. ;Skip entries set by IPL
 .. I $D(^TMP("BJPNCVVOB",$J,PRBIEN,SCND,VIEN)) Q
 .. ;
 .. ;Remove the entry
 .. S IEN="" S IEN=$O(^AUPNPROB(PRBIEN,SCND,"B",VIEN,IEN)) Q:'+IEN  D
 .. S FDA("9000011."_SCND,IEN_","_PRBIEN_",",.01)="@"
 .. D UPDATE^DIE("","FDA","OKAY","ERR")
 . ;
 . ;Remove the problem from the PIP
 . I VALUE="Problem Deleted From PIP" S PBAUD=2
 . ;
 . ;Audit the entries
 . ;
 . ;Get Last Modified/Entered info
 . S LMDT=$$GET1^DIQ(9000010.43,VBIEN_",",1218,"I")
 . S LMBY=$$GET1^DIQ(9000010.43,VBIEN_",",1219,"I")
 . S ENDT=$$GET1^DIQ(9000010.43,VBIEN_",",1216,"I")
 . S ENBY=$$GET1^DIQ(9000010.43,VBIEN_",",1217,"I")
 . S AUD=ENDT_U_ENBY_U_LMDT_U_LMBY
 . ;
 . ;Get the pointer to the PIP
 . S BPIEN=$$GET1^DIQ(9000010.43,VBIEN_",",.01,"I")
 . ;
 . S CHGIEN=0 F  S CHGIEN=$O(^AUPNVOB(VBIEN,22,CHGIEN)) Q:'CHGIEN  D
 .. NEW NODE,XFLD
 .. S NODE=$G(^AUPNVOB(VBIEN,22,CHGIEN,0))
 .. I $P(NODE,U)="F" D
 ... NEW FLD,INVALUE,XNVALUE,IOVALUE,XOVALUE
 ... S (XFLD,FLD)=$P(NODE,U,2) Q:'+FLD
 ... I FLD[":" Q   ;Skip note entries
 ... ;
 ... ;Get the new field values
 ... S INVALUE=$$GET1^DIQ(9000010.43,VBIEN,FLD,"I")
 ... S XNVALUE=$$GET1^DIQ(9000010.43,VBIEN,FLD,"E")
 ... ;Convert 9000010.43 field to 90680.01 field
 ... S FLD=$S(FLD=".06":".06",FLD=".11":".05",FLD=".08":".07",FLD=".09":".08",FLD=".1":".09",FLD=".12":".04",FLD=1218:"1.03",FLD=1219:"1.04",FLD=1216:"1.01",FLD="1217":"1.02",FLD=".05":".05",1:"")
 ... ;
 ... ;Convert SNOMED if needed
 ... I FLD=".04" S (INVALUE,XNVALUE)=$$GET1^DIQ(90680.02,INVALUE_",",".03","I")
 ... ;
 ... ;Skip provider text
 ... I XFLD=".07" Q
 ... ;
 ... I FLD="" Q
 ... ;
 ... ;Get the old field values
 ... S IOVALUE=$G(HIST(FLD,"I"))
 ... S XOVALUE=$G(HIST(FLD,"X"))
 ... ;
 ... ;Quit if field hasn't changed
 ... I IOVALUE=INVALUE,(+FLD<1.01)!(+FLD>1.04) Q
 ... ;
 ... ;Handling for change to inactive/active
 ... I FLD=".08",INVALUE'="A" S INACTIVE=1
 ... I FLD=".08",INVALUE="A" S ACTIVE=1
 ... ;
 ... ;Set up audit entries
 ... S AUD(FLD,"I")=IOVALUE_U_INVALUE
 ... S AUD(FLD,"X")=XOVALUE_U_XNVALUE
 ... ;
 ... ;If change in SNOMED, also save Concept ID
 ... I FLD=".04",NEWPRB D
 .... NEW CONCID
 .... S PAUD(80002,"I")=$G(HIST(80002,"I"))_U_INVALUE
 .... S PAUD(80002,"X")=$G(HIST(80002,"X"))_U_XNVALUE
 .... S HIST(80002,"I")=INVALUE
 .... S HIST(80002,"X")=XNVALUE
 .... S CONCID=$P($$DESC^BSTSAPI(INVALUE_"^^1"),U)
 .... I CONCID]"" D
 ..... S PAUD(80001,"I")=$G(HIST(80001,"I"))_U_CONCID
 ..... S PAUD(80001,"X")=$G(HIST(80001,"X"))_U_CONCID
 ..... S HIST(80001,"I")=CONCID
 ..... S HIST(80001,"X")=CONCID
 ... ;
 ... ;Update history with new values
 ... S HIST(FLD,"I")=INVALUE
 ... S HIST(FLD,"X")=XNVALUE
 . ;
 . ;Put in Add entry
 . I PBAUD=1 S AUD(".01","I")="^"_BPIEN,AUD(".01","X")="^"_BPIEN
 . ;
 . ;File PIP audit entries
 . I $D(AUD) D AUD^BJPN20AU(.AUD,"90680.01",BJPNPL)
 . ;
 . ;Manually update Last Modified information
 . I LMDT]"" S $P(^AUPNPROB(PRBIEN,0),U,3)=LMDT
 . I LMBY]"" S $P(^AUPNPROB(PRBIEN,0),U,14)=LMBY
 . I ENDT]"" S $P(^AUPNPROB(PRBIEN,0),U,8)=$P(ENDT,".")
 . I ENBY]"" S $P(^AUPNPROB(PRBIEN,1),U,3)=ENBY
 . ;
 . ;Update PIP info in BJPNPL
 . I +$G(PBAUD)!(+$G(INACTIVE))!(+$G(ACTIVE)) D
 .. ;
 .. NEW UPPIP,DA,DIC,DLAYGO,X,Y,%,ERROR,IENS
 .. S DA(1)=BJPNPL,DIC="^BJPNPL("_DA(1)_",5,",DLAYGO=90680.015,DIC(0)=""
 .. S X=$G(ENDT) S:X="" X=$G(LMDT)
 .. I X="" D NOW^%DTC S X=%
 .. K DO,DD D FILE^DICN
 .. I +Y<0 Q
 .. S DA(1)=BJPNPL,DA=+Y,IENS=$$IENS^DILF(.DA)
 .. S X=$G(ENBY) S:X="" X=$G(LMBY)
 .. S UPPIP(90680.015,IENS,".02")=$S(+$G(INACTIVE):0,1:1)
 .. I X]"" S UPPIP(90680.015,IENS,".03")=X
 .. D FILE^DIE("","UPPIP","ERROR")
 . ;
 . ;File IPL audit entry
 . I +$G(PBAUD)!($D(PAUD)>9) D
 .. NEW CDINFO
 .. S PAUD=ENDT_U_ENBY_U_LMDT_U_LMBY
 .. S PAUD(1.03,"I")=U_$P($G(AUD(1.02,"I")),U,2)  ;Entered By - Internal
 .. S PAUD(1.03,"X")=U_$P($G(AUD(1.02,"X")),U,2)  ;Entered By - External
 .. S PAUD(1.04,"I")=U_$P($G(AUD(1.02,"I")),U,2)  ;Enc Provider - Internal
 .. S PAUD(1.04,"X")=U_$P($G(AUD(1.02,"X")),U,2)  ;Enc Provider - External
 .. S PAUD(.14,"I")=U_$P($G(AUD(1.02,"I")),U,2)  ;User Last Modified - Internal
 .. S PAUD(.14,"X")=U_$P($G(AUD(1.02,"X")),U,2)  ;User Last Modified - External
 .. S PAUD(.03,"I")=U_$P($G(AUD(1.01,"I")),U,2)  ;Date Last Modified - Internal
 .. S PAUD(.03,"X")=U_$P($G(AUD(1.01,"X")),U,2)  ;Date Last Modified - External
 .. ;
 .. ;Save first problem entry
 .. I (+$G(PBAUD)=1) D
 ... S PAUD(.01,"I")=U_$P($G(^AUPNPROB(PRBIEN,0)),U)  ;Prob Dx - Internal
 ... S CDINFO=$$ICDDX^AUPNVUTL($P(PAUD(.01,"I"),U,2),$P(PAUD(.03,"I"),U,2))
 ... I $P(CDINFO,U)>1 S PAUD(.01,"X")=U_$P(CDINFO,U,2)  ;Prob Dx - External
 ... S PAUD(.08,"I")=U_$P($P($G(AUD(1.01,"I")),U,2),".")  ;Date Entered - Internal
 ... S PAUD(.08,"X")=U_$P($P($G(AUD(1.01,"X")),U,2),"@")  ;Date Entered - External
 ... S PAUD(.12,"I")=U_"E"         ;Status - Internal
 ... S PAUD(.12,"X")=U_"EPISODIC"  ;Status - External
 ... S PAUD(.19,"I")=U_"1"                     ;PIP
 ... S PAUD(.19,"X")=U_"YES, ACTIVE IN PIP"  ;PIP - External
 .. ;
 .. ;Manually update the fields
 .. I LMDT]"" S $P(^AUPNPROB(PRBIEN,0),U,3)=LMDT
 .. I LMBY]"" S $P(^AUPNPROB(PRBIEN,0),U,14)=LMBY
 .. I ENDT]"" S $P(^AUPNPROB(PRBIEN,0),U,8)=$P(ENDT,".")
 .. I ENBY]"" S $P(^AUPNPROB(PRBIEN,1),U,3)=ENBY
 .. ;S $P(^AUPNPROB(PRBIEN,1),U,3)=$P($G(PAUD(1.03,"I")),U,2) ;Entered By
 .. ;S $P(^AUPNPROB(PRBIEN,1),U,4)=$P($G(PAUD(1.04,"I")),U,2) ;Enc Prov
 .. ;S $P(^AUPNPROB(PRBIEN,0),U,14)=$P($G(PAUD(.14,"I")),U,2) ;User Last Modified
 .. ;S $P(^AUPNPROB(PRBIEN,0),U,3)=$P($G(PAUD(.03,"I")),U,2)  ;Date Last Modified
 .. ;S $P(^AUPNPROB(PRBIEN,0),U,8)=$P($G(PAUD(.08,"I")),U,2)  ;Date Entered
 .. ;
 .. ;Audit the entries
 .. D AUD^BJPN20AU(.PAUD,"9000011",PRBIEN)
 . ;
 . ;Handle PIP problem deletes - remove PIP value and audit
 . I $G(PBAUD)=2 D
 .. S PAUD(.14,"I")=U_$P($G(AUD(1.02,"I")),U,2)  ;User Last Modified - Internal
 .. S PAUD(.14,"X")=U_$P($G(AUD(1.02,"X")),U,2)  ;User Last Modified - External
 .. S PAUD(.03,"I")=U_$P($G(AUD(1.01,"I")),U,2)  ;Date Last Modified - Internal
 .. S PAUD(.03,"X")=U_$P($G(AUD(1.01,"X")),U,2)  ;Date Last Modified - External
 .. S PAUD(".19","I")="1^"
 .. S PAUD(".19","X")="YES, ACTIVE IN PIP^"
 .. ;
 .. ;Manually update PIP field
 .. S $P(^AUPNPROB(PRBIEN,0),U,19)=""
 .. ;
 .. ;Audit the entries
 .. D AUD^BJPN20AU(.PAUD,"9000011",PRBIEN)
 ;
 Q
 ;
 ;This call is based off the SET call in BGOVVI
 ;It overrides locked visit checking so older care plan notes can be converted
 ;into visit instructions.
 ;
 ;Set data into this file
 ;INP = VVI IEN [1] ^ Visit IEN [2] ^ Problem IEN [3] ^ Patient IEN [4]^ Evnt Dt [5] ^ Provider [6]
 ;INSTR(N)= Array of instructions
SET(RET,INP,INSTR) ;EP
 N VFIEN,NEW,VIEN,PROB,EVDT,DFN,PRV,FDA,IEN,FNUM,VFNEW
 S FNUM=$$FNUM^BGOVVI
 S VFIEN=+INP
 I VFIEN="" S NEW=1
 S VFNEW='VFIEN
 S VIEN=$P(INP,U,2)
 S PROB=$P(INP,U,3)
 I 'PROB S RET="-1^No problem in input string" Q
 I 'VIEN S RET=$$ERR^BGOUTL(1008) Q
 S DFN=$P(INP,U,4)
 S EVDT=$P(INP,U,5)
 I EVDT="" S EVDT=$$NOW^XLFDT
 S PRV=$P(INP,U,6) I PRV="" S PRV=DUZ
 ;Do not check visit status
 ;S RET=$$CHKVISIT^BGOUTL(VIEN,DFN)
 ;Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,PROB,VIEN)
 .S:RET>0 VFIEN=RET ;,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(1201)=EVDT
 S @FDA@(1204)="`"_PRV
 I VFNEW D
 .S @FDA@(1216)="N"
 .S @FDA@(1217)="`"_PRV
 S @FDA@(1218)="N"
 S @FDA@(1219)="`"_PRV
 S RET=$$UPDATE^BGOUTL(.FDA,"E@")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 Q:RET
 ;Add in the text of the item
 N VAL,ICNT,I
 S ICNT=0
 S I="" F  S I=$O(INSTR(I)) Q:I=""  D
 .S ICNT=ICNT+1
 .S VAL(ICNT,0)=$G(INSTR(I))
 D WP^DIE(9000010.58,VFIEN_",",1100,,"VAL")
 S RET=VFIEN
 ;
 ;Fix the last modified and entered dates
 I +VFIEN D
 . NEW AUPNVVI
 . S AUPNVVI(9000010.58,VFIEN_",",1218)=EVDT
 . S AUPNVVI(9000010.58,VFIEN_",",1219)=PRV
 . S AUPNVVI(9000010.58,VFIEN_",",1216)=EVDT
 . S AUPNVVI(9000010.58,VFIEN_",",1217)=PRV
 . D FILE^DIE("","AUPNVVI","ERROR")
 ;
 Q
 ;
 ;This call mimics the SIGN call in BGOVVI. It allows for the date to be passed in
 ;Mark record when signed
SIGN(RET,VVII,BY,ONDT) ;EP
 N FDA,AIEN,ERR
 S RET="",ERR=""
 I $$GET1^DIQ(9000010.58,VVII,.05)'="" S RET="-1^Already signed" Q RET
 S AIEN=VVII_","
 S:$G(ONDT)="" ONDT=$$NOW^XLFDT
 S FDA(9000010.58,AIEN,.04)=BY
 S FDA(9000010.58,AIEN,.05)=ONDT
 D FILE^DIE("","FDA","ERR")
 ;
 ;Fix the last modified and entered dates
 I +AIEN D
 . NEW AUPNVVI
 . S AUPNVVI(9000010.58,AIEN_",",1218)=ONDT
 . S AUPNVVI(9000010.58,AIEN_",",1219)=BY
 . S AUPNVVI(9000010.58,AIEN_",",1216)=ONDT
 . S AUPNVVI(9000010.58,AIEN_",",1217)=BY
 . D FILE^DIE("","AUPNVVI","ERROR")
 I ERR S RET=-1_U_"Unable to sign Visit Instructions"
 Q RET
 ;
 ;This call mimics EIE in BGOVVI. It permits the user and dt to be passed in
 ;Input parameter
 ;INP= Visit instruction ien [1] ^ Reason for eie [2] ^ comment if other [3] ^ BY [4] ^ Date [5]
EIE(RET,INP) ;Mark an entry entered in error
 N FNUM,IEN2,FDA,IEN,REASON,CMMT,IENS,RET,BY,ON
 S RET=""
 S IENS=$P(INP,U,1)
 S REASON=$P(INP,U,2)
 S CMMT=$P(INP,U,3)
 S BY=$P(INP,U,4) S:BY="" BY=DUZ
 S ON=$P(INP,U,5) S:ON="" ON=$$NOW^XLFDT()
 S FNUM=9000010.58
 S IEN2=IENS_","
 S FDA=$NA(FDA(FNUM,IEN2))
 S @FDA@(.06)=1
 S @FDA@(.07)=BY
 S @FDA@(.08)=ON
 S @FDA@(.08)=REASON
 S @FDA@(.09)=CMMT
 S RET=$$UPDATE^BGOUTL(.FDA,,.IEN)
 ;
 ;Fix the last modified and entered dates
 I +IEN2 D
 . NEW AUPNVVI
 . S AUPNVVI(9000010.58,IEN2_",",1218)=ON
 . S AUPNVVI(9000010.58,IEN2_",",1219)=BY
 . S AUPNVVI(9000010.58,IEN2_",",1216)=ON
 . S AUPNVVI(9000010.58,IEN2_",",1217)=BY
 . D FILE^DIE("","AUPNVVI","ERROR")
 ;
 Q
