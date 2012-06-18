BGOVAST ; IHS/BAO/TMD - Manage V ASTHMA ;02-Dec-2009 18:11;MGH
 ;;1.1;BGO COMPONENTS;**1,3,6**;Mar 20, 2007
 ;---------------------------------------------
 ; Get V Asthma entries by individual entry, visit, or patient
 ;  INP = Patient IEN [1] ^ V File IEN [2] ^ Visit IEN [3]
GET(RET,INP) ;EP
 D VFGET^BGOUTL2(.RET,INP,$$FNUM,".03;.04;.05;.06;.07;.08;.09;.11;.12;1201;1204")
 Q
 ;Get asthma control data
 ;INP = Patient IEN [1]  ^V File [IEN] ^ Visit IEN [3]
 ;Ret=Paient [1] ^Visit IEN [2] ^ date [3] ^control [4]
GET2(RET,INP) ;EP
 N DFN,DT,CONTROL,IEN,X,VST,DTE
 S CONTROL=""
 S DFN=$P(INP,U,1)
 S DT="" S DT=$O(^AUPNVAST("AAC",DFN,DT)) Q:DT=""  D
 .S IEN="" S IEN=$O(^AUPNVAST("AAC",DFN,DT,IEN),-1) Q:IEN=""  D
 ..S CONTROL=$G(^AUPNVAST("AAC",DFN,DT,IEN))
 S X=$S(CONTROL="W":"WELL CONTROLLED",CONTROL="N":"NOT WELL CONTROLLED",CONTROL="V":"VERY POORLY CONTROLLED",1:"")
 S VST=$$GET1^DIQ(9000010.41,IEN,.03,"I")
 S DTE=$$GET1^DIQ(9000010.41,IEN,.03,"E")
 S RET=DFN_U_VST_U_DTE_U_X
 Q
 ;Get asthma registry entry
GETREG(RET,DFN) ;EP
 S RET=$$GETREC^BGOUTL(90181.01,DFN,".02;.06;.07;.08;.12")
 Q
 ; Fetch asthma registry note
GETNOTE(RET,DFN) ;EP
 K RET
 I '$D(^BATREG(DFN,0)) S RET(0)=$$ERR^BGOUTL(1071) Q
 I $$GET1^DIQ(90181.01,DFN,1100,"","RET")
 Q
 ; Add/edit V Asthma Registry entry
 ;  INP = V File IEN [1] ^ Visit IEN [2] ^ Asthma Status [4]
 ;^ FEV [4] ^ FEF [5] ^ PEF [6] ^ ETS [7] ^
 ;        Matter [8] ^ Mites [9] ^ Plan [10]
SET(RET,INP) ;EP
 N VIEN,FNUM,VFIEN,VIEN,VFNEW,FDA
 S RET="",FNUM=$$FNUM
 S VFIEN=+INP
 S VFNEW='VFIEN
 S VIEN=$P(INP,U,2)
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,1,VIEN)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.14)=$P(INP,U,3)
 ;S @FDA@(.05)=$P(INP,U,4)
 ;S @FDA@(.06)=$P(INP,U,5)
 ;S @FDA@(.07)=$P(INP,U,6)
 ;S @FDA@(.08)=$P(INP,U,7)
 ;S @FDA@(.09)=$P(INP,U,8)
 ;S @FDA@(.11)=$P(INP,U,9)
 ;S @FDA@(.12)=$P(INP,U,10)
 ;S @FDA@(1201)="N"
 S @FDA@(1204)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Add/edit Asthma Registry entry
 ;  INP = Patient IEN [1] ^ Status [2] ^ Last Visit Date [3] ^ Date Due [4] ^ Next Appt Date [5] ^
 ;        Case Manager [6] ^ Note [7]
SETREG(RET,INP) ;EP
 N DFN,IENS,FDA,NOTE
 S DFN=+INP
 S IENS=$S($D(^BATREG(DFN)):DFN_",",1:"+1,")
 S FDA=$NA(FDA(90181.01,IENS))
 S:$E(IENS)="+" @FDA@(.01)="`"_DFN
 S @FDA@(.02)=$P(INP,U,2)
 S @FDA@(.06)=$P(INP,U,3)
 ;S @FDA@(.07)=$P(INP,U,4)
 S:$P(INP,U,3) @FDA@(.07)=$$FMADD^XLFDT($P(INP,U,3),180)
 S @FDA@(.08)=$P(INP,U,5)
 S @FDA@(.12)=$$PTR($P(INP,U,6))
 S NOTE=$P(INP,U,7)
 S @FDA@(1100)=$$TOWP^BGOUTL("NOTE")
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 Q
PTR(X) Q $S($L(X):"`"_X,1:"")
 ; Delete a V Allergy entry
DEL(RET,VFIEN) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 Q
 ; Return V File #
FNUM() Q 9000010.41
