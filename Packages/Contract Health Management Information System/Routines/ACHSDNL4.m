ACHSDNL4 ; IHS/ITSC/PMF - DENIAL LTR/FS (FS1) (5/6) ;7/27/10  16:17
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;**3,14,18**;JUN 11,2001
 ;ACHS*3.1*3  change chart number display
 ;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES
 ;ACHS*3.1*18 4/1/2010;IHS/OIT/ABK;Change every occurrance of Deferred to Unmet Need
 ;
START ;
 D CPI^ACHS    ;CONFIDENTIAL INFO MESSAGE
 ;{ABK, 4/2/10}W !!,$$C^ACHS("CHS DENIAL/DEFERRED SERVICES",80),!,$$C^ACHS("DENIAL FACT SHEET",80),!,$$REPEAT^XLFSTR("=",79),!,$$C^ACHS("Document number: "_$$DN^ACHS(0,1),80),!,$$REPEAT^XLFSTR("-",79),!
 W !!,$$C^ACHS("CHS DENIAL",80),!,$$C^ACHS("DENIAL FACT SHEET",80),!,$$REPEAT^XLFSTR("=",79),!,$$C^ACHS("Document number: "_$$DN^ACHS(0,1),80),!,$$REPEAT^XLFSTR("-",79),!
 ;
 G NOT:$$DN^ACHS(0,6)="N"          ;PATIENT NOT REGISTERED
 S DFN=$$DN^ACHS(0,7)              ;PATIENT POINTER
 I DFN']"" D END Q
 I '$D(^DPT(DFN,0)) D END Q
 ;
 S ACHDNAME=$P($G(^DPT(DFN,0)),U)
 S ACHDNAME=$P(ACHDNAME,",",2,99)_" "_$P(ACHDNAME,",")
 ;
 ;11/29/01  pmf  special data needed at the Pawnee facility.
 ;W ?4,ACHDNAME,?35,"CHART #: " W:$D(^AUPNPAT(DFN,41,DUZ(2),0)) $P($G(^AUPNPAT(DFN,41,DUZ(2),0)),U,2)," ",$P($G(^DIC(4,DUZ(2),0)),U) W:'$D(^DIC(4,DUZ(2),0)) "(No Chart At This Facility)" W !  ; ACHS*3.1*3
 W ?4,ACHDNAME  ; ACHS*3.1*3
 D SETCHT^ACHSDNL2  ; ACHS*3.1*3
 W ?35,ACHDCH,!  ; ACHS*3.1*3
 ;
 ;
 S A=$G(^DPT(DFN,.11))
 W ?4,$P(A,U),!?4,$P(A,U,4)
 S ACHDST=$P(A,U,5)
 I ACHDST]"",$D(^DIC(5,ACHDST,0)) W " ",$P($G(^DIC(5,ACHDST,0)),U,2)
 W " ",$P(A,U,6),!!
 G DATE
 ;
NOT ;
 ;1/8/02  pmf  dont go date, quit instead
 ;I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,10)) W "(No patient on file)" G DATE  ; ACHS*3.1*3
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,10)) W "(No patient on file)" Q  ; ACHS*3.1*3
 ;
 S X=$G(^ACHSDEN(DUZ(2),"D",ACHSA,10))
 S Y=$$DN^ACHS(10,1)
 W ?4,$P(Y,",",2,99)
 W:$P(Y,",",2,99)'="" " "
 W $P(Y,","),?35,"CHART #: ",$S($P(X,U,6)]"":$P(X,U,6),1:"(No Chart At This Facility)"),!?4,$P(X,U,2),!?4,$P(X,U,3)
 S ACHDST=$P(X,U,4)
 I ACHDST]"",$D(^DIC(5,ACHDST,0)) W " ",$P($G(^DIC(5,ACHDST,0)),U,2)
 W " ",$P(X,U,5),!!
DATE ;
 S ACHSUMET=1
 W !,"DATE OF SERVICES: ",$$FMTE^XLFDT($$DN^ACHS(0,4)),".",!," REQUEST MADE TO: ",$P($G(^DIC(4,DUZ(2),0)),U),!,"DATE REQUEST REC: ",$$FMTE^XLFDT($$DN^ACHS(0,5))
 ;
APPEAL ;
 I $$DN^ACHS(400,3) W !,"   APPEAL STATUS: ",$P($G(^ACHSDENA($$DN^ACHS(400,3),0)),U)
TYPE ;
 S X=$$DN^ACHS(100,10)
 I $L(X) W !," TYPE OF SERVICE: " S Y=$P($G(^DD(9002071.01,110,0)),U,3) F %=1:1 D  Q:'%
 . I $P(Y,";",%)="" W "<unknown>" S %=0 Q
 . I $P($P(Y,";",%),":")=X W $P($P(Y,";",%),":",2) S %=0 Q
 ;
PRIOR ; --- Medical Priority
 I $$DN^ACHS(400,2) W !,"        PRIORITY: ",$P($G(^ACHSMPRI($$DN^ACHS(400,2),0)),U)
 W !,"   DATE OF ISSUE: ",$$FMTE^XLFDT($$DN^ACHS(0,2)),!,"       ISSUED BY: "
 S X=$$DN^ACHS(0,3)
 I X W $P($G(^VA(200,X,0)),U)
 W !,$$REPEAT^XLFSTR("-",79),!,$$C^ACHS("DENIAL REASON(S)",80)
 S ACHDPDR=0,X=$$DN^ACHS(250,1)
 I X W !!,"PRIMARY DENIAL REASON: ",$P($G(^ACHSDENS(X,0),"UNDEFINED"),U) S ACHDPDR=1
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,300,0)),$P($G(^(0)),U,4)>0 G R1
 I 'ACHDPDR W !,$S(ACHSUMET=1:"(No reasons on file)",1:"UN-MET NEED") G RLINE
R1 ;
 ;new var reason pointer
 N RSNPTR
 F X=0:0 S X=$O(^ACHSDEN(DUZ(2),"D",ACHSA,300,X)) Q:'X  D
 . S RSNPTR=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,300,X,0)),U)
 . I RSNPTR="" Q
 . W !,?23,$P($G(^ACHSDENS(RSNPTR,0)),U)
 . Q
 ;
RLINE ;
 ;
 G DLINE:"OI"'[$$DN^ACHS(100,10)
 W !,$$REPEAT^XLFSTR("-",79),!," TYPE    CODE",?30,"DIAGNOSIS"
 ;
 I '$D(^ACHSDEN(DUZ(2),"D",ACHSA,700,0)),'$D(^ACHSDEN(DUZ(2),"D",ACHSA,500,0)) W "(No diagnosis on file)" G COMMENT
 ;
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,500,0)) F X=0:0 S X=$O(^ACHSDEN(DUZ(2),"D",ACHSA,500,X)) Q:+X=0  D
 .;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 3 LINES
 .;S Y=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,500,X,0)),U) I Y]"",$D(^ICD9(Y,0)) W !,"(ICD9)   ",$P($G(^ICD9(Y,0)),U),?20,$P($G(^ICD9(Y,0)),U,3)
 .S Y=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,500,X,0)),U)
 .I Y]"",$D(^ICD9(Y,0)) W !,"(ICD9)   ",$P($$ICDDX^ICDCODE(Y),U,2),?20,$P($$ICDDX^ICDCODE(Y),U,4)
 ;
 I $D(^ACHSDEN(DUZ(2),"D",ACHSA,700,0)) F X=0:0 S X=$O(^ACHSDEN(DUZ(2),"D",ACHSA,700,X)) Q:+X=0  D
 .;3.1*14 12.4.2007 IHS/OIT/FCJ ADDED CSV CHANGES NXT 2 LINES
 .;S Y=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,700,X,0)),U) I Y]"",$D(^ICPT(Y,0)) W !,"(CPT)    ",$P($G(^ICPT(Y,0)),U),?20,$P($G(^ICPT(Y,0)),U,2)
 .S Y=$P($G(^ACHSDEN(DUZ(2),"D",ACHSA,700,X,0)),U) I Y]"",$D(^ICPT(Y,0)) W !,"(CPT)    ",$P($$CPT^ICPTCOD(Y),U,2),?20,$P($$CPT^ICPTCOD(Y),U,3)
COMMENT ;
DLINE ;
 W !,$$REPEAT^XLFSTR("-",79),!
 G ^ACHSDNL5
 ;
END ;
 D END^ACHSDNL5
 Q
 ;
