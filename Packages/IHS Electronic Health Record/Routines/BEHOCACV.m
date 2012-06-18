BEHOCACV ;MSC/IND/DKM - CWADF ;24-Aug-2009 11:54;PLS
 ;;1.1;BEH COMPONENTS;**029003**;Sep 18, 2007
 ;=================================================================
 ; Return posting list for patient
LIST(DATA,DFN) ;
 S DATA=$NA(^TMP("TIUPPCV",$J))
 D GET(DFN)
 Q
 ; Return allergy/adverse reaction info in report format
DETAIL(DATA,DFN) ;
 N CNT,LP,LP2,RXN,SEV,X
 S DATA=$$TMPGBL^CIAVMRPC,(CNT,LP)=0
 D EN1^GMRAOR1(DFN,"RXN")
 S @DATA@(1)=$S($G(RXN)="":"No allergy assessment.",'RXN:"No known allergies.",1:"No allergies found.")
 F  S LP=$O(RXN(LP)) Q:'LP  D
 .S X=RXN(LP),SEV=$P(X,U,2)
 .D ADD($P(X,U)_"     [Severity: "_$S($L(SEV):SEV,1:"Unknown")_"]")
 .S X="  Signs/symptoms:",LP2=0
 .F  S LP2=$O(RXN(LP,"S",LP2)) Q:'LP2  D ADD($P(RXN(LP,"S",LP2),";"),.X)
 Q
 ; RPC to return CWAD flags
CWAD(DATA,DFN) ;
 S DATA=$$CWADX(DFN)
 Q
 ; Return CWAD flags
CWADX(DFN) ;
 N ACRN,CTR,LST
 D GET(DFN)
 S LST="cwadf",CTR=0
 F  S CTR=$O(^TMP("TIUPPCV",$J,CTR)) Q:(CTR'>0)!(LST?4U)  S ACRN=$P($G(^(CTR)),U,2) D:$L(ACRN)=1
 .S:"CWADF"[ACRN LST=$TR(LST,$C($A(ACRN)+32),ACRN)
 K ^TMP("TIUPPCV",$J)
 Q $TR(LST,"cwadf")
 ; Add to output array
ADD(TXT,LBL,IDT) ;
 S CNT=CNT+1,@DATA@(CNT)=$S($D(LBL):$$LJ^XLFSTR(LBL,$G(IDT,20)),1:"")_$G(TXT),LBL=""
 Q
 ; Get CWAD and PRF flags
GET(DFN) N PRF,CNT,RES
 K ^TMP("TIUPPCV",$J)
 Q:'DFN
 D ENCOVER^TIUPP3(DFN)
 S RES=$$GETACT^DGPFAPI(DFN,"PRF")
 S PRF=0,CNT=$O(^TMP("TIUPPCV",$J,""),-1)
 F  S PRF=$O(PRF(PRF)) Q:'PRF  D
 .N X,Y
 .S Y=$O(^DGPF(26.13,"C",DFN,$P(PRF(PRF,"FLAG"),U),0))_"^F"
 .F X="2^FLAG","2^FLAGTYPE","1^ASSIGNDT" S Y=Y_U_$P($G(PRF(PRF,$P(X,U,2))),U,+X)
 .S CNT=CNT+1,^TMP("TIUPPCV",$J,CNT)=Y
 Q
 ; Get patient record flag detail
PRF(DATA,DFN,IEN) ;
 N CNT
 S DATA=$$TMPGBL^CIAVMRPC,CNT=0
 I '$G(IEN) D
 .S IEN=0
 .F  S IEN=$O(^DGPF(26.13,"B",DFN,IEN)) Q:'IEN  D
 ..Q:'$P($G(^DGPF(26.13,IEN,0)),U,3)
 ..D:CNT ADD($$REPEAT^XLFSTR("_",80)),ADD("")
 ..D PRFX(DFN,IEN)
 E  D PRFX(DFN,IEN)
 Q
 ; Get patient record detail for a single entry
PRFX(DFN,IEN) ;
 N PRF,CTL
 I $$GETASGN^DGPFAA(IEN,.PRF),$$GETHIST^DGPFAAH($$GETFIRST^DGPFAAH(IEN),.PRF),$$GETFLAG^DGPFUT1($P(PRF("FLAG"),U),.PRF) D
 .Q:+$G(PRF("DFN"))'=DFN
 .D:'CNT ADD($$GET1^DIQ(2,DFN,.01),"Patient:",25),ADD("")
 .F CTL="FLAG^Flag Name","TYPE^Flag Type","STATUS^Assignment Status","ASSIGNDT^Initial Assigned Date","APPRVBY^Approved by","REVIEWDT^Next Review Date","OWNER^Owner Site","ORIGSITE^Originating Site" D
 ..D ADD($P(PRF($P(CTL,U)),U,2),$P(CTL,U,2)_":",25)
 .I $D(PRF("NARR")) D
 ..D ADD(""),ADD("Assignment Narratives:"),ADD("")
 ..M @DATA@(CNT)=PRF("NARR")
 ..S CNT=CNT+1
 Q
