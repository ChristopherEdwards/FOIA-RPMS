BWMDEX0 ;IHS/CIA/DKM - Export filters;25-Feb-2011 14:23;PLS
 ;;2.0;WOMEN'S HEALTH;**9,11,12**;MAY 16, 1996
 ;
 ; Generic screen for multi-valued list.
 ; BWVAL = Value to screen (or array of values)
 ; Return= Nonzero if meets inclusion criteria.
SCREEN(BWVAL) ;
 Q:$D(BWFLT(BWFLT,"V"))<10 1
 S:$L($G(BWVAL)) BWVAL(BWVAL)=""
 S BWVAL=""
 F  S BWVAL=$O(BWVAL(BWVAL)) Q:'$L(BWVAL)  Q:$D(BWFLT(BWFLT,"V",BWVAL))
 Q $L(BWVAL)
 ; Generic prompt logic for file selection.
 ;
PROMPT(BWPMT,BWFN,BWDFL,BWSET) ;
 D SELECT^BWUTLP($S(BWFLT(BWFLT,"N"):"-",1:"")_BWPMT,BWFN,$NA(BWFLT(BWFLT,"V")),"",$G(BWDFL),.BWPOP,.BWSET,0)
 Q
 ; Generic display logic for multi-valued list.
DISPLAY(BWLBL,BWFN,BWSET) ;
 N BWLP,BWDLM,X
 S BWLP=0,BWDLM=BWLBL_": "
 F  S BWLP=$O(BWFLT(BWFLT,"V",BWLP)) Q:'BWLP  D
 .I $G(BWSET) S X=$$LOW^XLFSTR($$EXTERNAL^DILFD(BWFN,BWSET,,BWLP))
 .E  S X=$$GET1^DIQ(BWFN,BWLP,.01)
 .W BWDLM
 .W:$X+$L(X)'<$G(IOM,80) !?5
 .W X
 .S BWDLM="; "
 I BWDLM="; " W ".",!
 E  W "ALL "_BWLBL_".",!
 Q
 ; Screen by age range
AGESCRN() ;
 N BWAGE,BWDOD
 S BWDOD=+$$DOD^AUPNPAT(BWDFN)
 S BWAGE=+$$AGEAT^BWUTL1(BWDFN,$S(BWDOD:BWDOD,1:DT))
 Q $S(BWAGE<$O(BWFLT(BWFLT,"V",0)):0,BWAGE>$O(BWFLT(BWFLT,"V",""),-1):0,1:1)
 ; Prompt for age range
AGEPMPT N BWAGE,BWHLP,BWLOW,BWHIGH
 W "Enter age range for this export.",!
 F BWAGE="1:99:18","1:99:64" D  Q:BWPOP
 .S BWLOW=$P(BWAGE,":"),BWHIGH=$P(BWAGE,":",2),BWDEF=$P(BWAGE,":",3)
 .S BWHLP="     Procedures for patients "_$S(BWLOW=18:"under",1:"over")_" this age will NOT be exported."
 .S BWAGE=$$DIR^BWUTLP("N^"_BWLOW_":"_BWHIGH,"   Enter an age ("_BWLOW_"-"_BWHIGH_")",BWDEF,BWHLP,.BWPOP)
 .S:'BWPOP BWFLT(BWFLT,"V",BWAGE)=""
 Q
 ; Display age range
AGEDSPL W "ages ",$O(BWFLT(BWFLT,"V",0))," to ",$O(BWFLT(BWFLT,"V",""),-1),", inclusive.",!
 Q
 ; Screen by date range
DATSCRN() ;
 Q $S(BWDT<$O(BWFLT(BWFLT,"V",0)):0,BWDT>$O(BWFLT(BWFLT,"V",""),-1):0,1:1)
 ; Prompt for date range
DATPMPT N BWSTTDT,BWDT1,BWDT2
 S BWSTTDT=$P(^BWSITE(DUZ(2),0),U,17)
 D SHOWDLG^BWUTLP(9)
 F  D ASKDATES^BWUTLP(.BWDT1,.BWDT2,.BWPOP,BWSTTDT) Q:BWPOP  Q:BWDT1'<BWSTTDT  D
 .D SHOWDLG^BWUTLP(10)
 S:'BWPOP BWFLT(BWFLT,"V",BWDT1)="",BWFLT(BWFLT,"V",BWDT2)=""
 Q
 ; Display date range
DATDSPL W "procedures from ",$$FMTE^XLFDT($O(BWFLT(BWFLT,"V",0)))," to ",$$FMTE^XLFDT($O(BWFLT(BWFLT,"V",""),-1)),", inclusive.",!
 Q
 ; Screen CDC procedures
CDCSCRN() ;
 Q:BWPT=1!(BWPT=28) 1
 I BWPT=25!(BWPT=26),$$PC^BWMDEX(2,32) Q 1
 I BWPT=27,$$PC^BWMDEX(2,39),$$CBE^BWMDEX2=1 Q 1
 Q 0
 ; Evaluate Medicare Eligibility
MCARE(BWDT,BWSC) ;
 Q $$MELIG("^AUPNMCR",BWDT,.BWSC)
 ; Evaluate Medicaid Elibibility
MCAID(BWDT,BWSC) ;
 Q $$MELIG("^AUPNMCD",BWDT,.BWSC)
 ; Returns true if eligible for Medicare/Medicaid on date given.
MELIG(BWGL,BWDT,BWSC) ;
 N S,X,Y,Z
 S (X,Z)=0,BWSC=$G(BWSC)
 F  S X=$O(@BWGL@(BWDFN,11,X)) Q:'X!Z  S Y=$G(^(X,0)) D
 .S S=$P(Y,U,3)
 .I $L(BWSC),'$L(S)!(BWSC'[S) Q
 .Q:BWDT<Y
 .S Y=$P(Y,U,2)
 .Q:Y&(BWDT'<Y)
 .S Z=1
 Q Z
 ; Return Income exclusion flag
INCCHK(BWDFN,BWDT) ;
 ; Input: BWDT - Date of procedure
 ; Returns: 0=exclude procedure; 1=include procedure
 N ELGV,ELGDT
 Q:'$G(BWDFN)!'$G(BWDT) 1                                              ; include procedure by default
 S ELGV=+$P($G(^BWP(BWDFN,0)),U,29)                                    ; Income Eligible
 S ELGDT=+$P($G(^BWP(BWDFN,0)),U,30)                                   ; Income Eligible Date
 Q:'ELGV!'ELGDT 1                                                      ; include procedure by default
 Q $S((ELGV=2)&(BWDT'<ELGDT):0,1:1)
 ; Returns true if patient had private insurance on given date
HASPI(BWDFN,BWDT) ;
 Q $$PI^BWGRVLU(BWDFN,BWDT)
PAPELG(BWDFN) ;
 N PAPELG
 S PAPELG=$$GET1^DIQ(9002086,BWDFN,.32,"I")
 Q $S(PAPELG=1:1,1:0)
MAMELG(BWDFN) ;
 N MAMELG
 S MAMELG=$$GET1^DIQ(9002086,BWDFN,.33,"I")
 Q $S(MAMELG=1:1,1:0)
 Q
