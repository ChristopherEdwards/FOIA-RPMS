BGOVELD ; IHS/BAO/TMD - Manage V Elder Care ;20-Mar-2007 13:52;DKM
 ;;1.1;BGO COMPONENTS;**1,3**;Mar 20, 2007
 ; Get elder care entries by individual entry, visit, or patient
 ;  INP = Patient IEN [1] ^ V File IEN [2] ^ Visit IEN [3]
GET(RET,INP) ;EP
 D VFGET^BGOUTL2(.RET,INP,$$FNUM,".03;.04;.05;.06;.07;.08;.09;.11;.12;.13;.14;.15;.16;.17;.18;1201;1204")
 Q
 ; Add/edit V Elder Care entry
 ;  INP = V File IEN [1] ^ Visit IEN [2] ^ Toileting [3] ^ Bathing [4] ^
 ;        Dressing [5] ^ Transfers [6] ^ Feeding [7] ^ Continence [8] ^
 ;        Finances [9] ^ Cooking [10] ^ Shopping [11] ^ Chores [12] ^
 ;        Medications [13] ^ Transporation [14] ^ Func Status Change [15] ^
 ;        Caregiver [16]
SET(RET,INP) ;EP
 N VIEN,VFIEN,VFNEW,FNUM
 S RET="",FNUM=$$FNUM
 S VFIEN=+INP
 S VFNEW='VFIEN
 S VIEN=$P(INP,U,2)
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,"IHS-1-865",VIEN)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.04)=$P(INP,U,3)
 S @FDA@(.05)=$P(INP,U,4)
 S @FDA@(.06)=$P(INP,U,5)
 S @FDA@(.07)=$P(INP,U,6)
 S @FDA@(.08)=$P(INP,U,7)
 S @FDA@(.09)=$P(INP,U,8)
 S @FDA@(.11)=$P(INP,U,9)
 S @FDA@(.12)=$P(INP,U,10)
 S @FDA@(.13)=$P(INP,U,11)
 S @FDA@(.14)=$P(INP,U,12)
 S @FDA@(.15)=$P(INP,U,13)
 S @FDA@(.16)=$P(INP,U,14)
 S @FDA@(.17)=$P(INP,U,15)
 S @FDA@(.18)=$P(INP,U,16)
 S @FDA@(1201)="N"
 S @FDA@(1204)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Delete an Elder Care entry
DEL(RET,VFIEN) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 Q
 ; Return V File #
FNUM() Q 9000010.35
