BWMPUTL ;IHS/CIA/PLS - Mammography Project Utility Calls ;03-Sep-2003 20:12;PLS
 ;;2.0;WOMEN'S PACKAGE;**9**;;10-Apr-2003 10:03
 ;=================================================================
 ;
MPPRVEXM(EXMIEN) ;
 Q $$PREVEXM(44,BWDFN,EXMIEN)
 ; Return exam previous to given exam ien
PREVEXM(PROCTYP,DFN,EXMIEN) ;
 N X,RES
 S RES=""
 S PROCTYP=$G(PROCTYP,0)
 S DFN=+$G(DFN,0)
 S EXMIEN=+$G(EXMIEN,0)
 Q:'PROCTYP!('DFN)!('EXMIEN) RES
 S X=EXMIEN
 F  S X=$O(^BWPCD("C",DFN,X),-1) Q:X<1  D
 .Q:$P(^BWPCD(X,0),U,4)'=PROCTYP
 .S RES=$$FMTE^XLFDT($$GET1^DIQ(9002086.1,X,.12,"I"),"5Z")
 Q RES
 ; Result Flag for Blood Relatives with Breast Cancer
 ; Input: Procedure IEN
 ; Output: 0 - No relatives with BC; 1=Relatives with BC
BRELBC(PROC) ;
 N RES,RELM,RELS,RELD
 S RELM=$$GET^DDSVAL(DIE,.DA,10.07)  ;$$GET1^DIQ(9002086.1,PROC,10.07,"I")
 S RELS=$$GET^DDSVAL(DIE,.DA,10.08)  ;$$GET1^DIQ(9002086.1,PROC,10.08,"I")
 S RELD=$$GET^DDSVAL(DIE,.DA,10.09)   ;$$GET1^DIQ(9002086.1,PROC,10.09,"I")
 S RES=(RELM=3)!((RELS=1)!(RELS=2))!((RELD=1)!(RELD=2))
 Q RES
