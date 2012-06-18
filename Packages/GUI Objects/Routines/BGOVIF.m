BGOVIF ; IHS/BAO/TMD - Manage V INFANT FFEDING ;08-Jun-2010 09:30;MGH
 ;;1.1;BGO COMPONENTS;**1,3,6**;Mar 20, 2007
 ;---------------------------------------------
 ; Return entries from V Infant Feeding by V File Entry or by Patient or by Visit
 ;  INP = Patient IEN [1] ^ V File IEN [2] ^ Visit IEN [3]
GET(RET,INP) ;EP
 N I,X,IFDATE
 D VFGET^BGOUTL2(.RET,INP,$$FNUM,".03;.01;1201;1204")
 ;patch 6 If the 1201 field is empty, replace it with the visit date for display
 S I=0 F  S I=$O(@RET@(I)) Q:I=""  D
 .S X=$G(@RET@(I))
 .I $P(X,U,5)="" D
 ..S IFDATE=$P($P(X,U,3),"|",1)
 ..S $P(X,U,5)=IFDATE_"|"_$$CVTDATE^BGOUTL(IFDATE)
 ..S @RET@(I)=X
 Q
 ; Add/Edit infant feeding data
 ;  INP = V File IEN ^ Visit IEN ^ Feeding Choice
SET(RET,INP) ;EP
 N VIEN,VFIEN,VFNEW,TYPE,FDA,FNUM
 S RET="",FNUM=$$FNUM
 S VFIEN=$P(INP,U)
 S VFNEW='VFIEN
 S VIEN=$P(INP,U,2)
 S TYPE=$P(INP,U,3)
 I 'TYPE S RET=$$ERR^BGOUTL(1079) Q
 S RET=$$CHKVISIT^BGOUTL(VIEN)
 Q:RET
 I 'VFIEN D  Q:'VFIEN
 .D VFNEW^BGOUTL2(.RET,FNUM,TYPE,VIEN)
 .S:RET>0 VFIEN=RET,RET=""
 S FDA=$NA(FDA(FNUM,VFIEN_","))
 S @FDA@(.01)=TYPE
 S @FDA@(1201)="N"
 S @FDA@(1204)="`"_DUZ
 S RET=$$UPDATE^BGOUTL(.FDA,"E")
 I RET,VFNEW,$$DELETE^BGOUTL(FNUM,VFIEN)
 D:'RET VFEVT^BGOUTL2(FNUM,VFIEN,'VFNEW)
 S:'RET RET=VFIEN
 Q
 ; Delete a V File entry
DEL(RET,VFIEN) ;
 D VFDEL^BGOUTL2(.RET,$$FNUM,VFIEN)
 Q
 ; Return V File #
FNUM() Q 9000010.44
