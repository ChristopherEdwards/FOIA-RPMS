BGOVER ; IHS/BAO/TMD - Manage V EMERGENCY ROOM ;20-Mar-2007 13:52;DKM
 ;;1.1;BGO COMPONENTS;**1,3**;Mar 20, 2007
 ;---------------------------------------------
 ; Get V Emergency Visit entries for individual entry, visit, or patient
 ;  INP = Patient IEN [1] ^ V File IEN [2] ^ Visit IEN [3]
GET(RET,INP) ;EP
 D VFGET^BGOUTL2(.RET,INP,$$FNUM,".03;.04;.05;.06;.07;.08;.09;.11;.12;.13;.14;.15;.16;1201;1204")
 Q
 ; Add/edit V ER Visit entry
 ;  INP = V File IEN [1] ^ Visit IEN [2] ^ Urgency [3] ^ Ambulation Mode [4] ^ Transport Mode [5] ^ Other Means [6] ^
 ;        Notified [7] ^ Informant [8] ^ Disposition [9] ^ Other Disposition [10] ^ Depart Date/Time [11] ^
 ;        Left Area Date/Time [12] ^ Condition on Departure [13] ^ Transferred To [14]
SET(RET,INP) ;
 N VIEN,VFIEN,VFNEW,FNUM,FDA
 S RET="",FNUM=$$FNUM
 S VFIEN=+INP
 S VFNEW='VFIEN
 S VIEN=+$P(INP,U,2)
 I $P($G(^AUPNVSIT(VIEN,0)),U,8)'=30 S RET=$$ERR^BGOUTL(1076) Q
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 S:'VFIEN VFIEN=$O(^AUPNVER("AD",VIEN,0))
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,"IHS-114 ER",VIEN)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.04)=$P(INP,U,3)
 S @FDA@(.07)=$P(INP,U,4)
 S @FDA@(.05)=$P(INP,U,5)
 S @FDA@(.06)=$P(INP,U,6)
 S @FDA@(.09)=$P(INP,U,7)
 S @FDA@(.08)=$P(INP,U,8)
 S @FDA@(.11)=$P(INP,U,9)
 S @FDA@(.12)=$P(INP,U,10)
 S @FDA@(.13)=$P(INP,U,11)
 S @FDA@(.14)=$P(INP,U,12)
 S @FDA@(.15)=$P(INP,U,13)
 S @FDA@(.16)=$P(INP,U,14)
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Delete a V ER Visit entry
DEL(RET,VFIEN) ;EP
 D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 Q
 ; Return V File #
FNUM() Q 9000010.29
