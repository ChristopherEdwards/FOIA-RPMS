BEHOPTCX ;MSC/IND/DKM - Patient Context Object ;22-Jun-2011 17:41;PLS
 ;;1.1;BEH COMPONENTS;**004004,004005,004006,004007**;Mar 20, 2007
 ;=================================================================
 ; Selects patient & returns key information
 ;  1    2   3   4    5      6    7    8      9       10     11  12 13  14  15  16     17     18      19
 ; NAME^SEX^DOB^SSN^LOCIEN^LOCNM^RMBD^VET^SENSITIVE^ADMITTED^HRN^SC^SC%^ICN^DOD^TS^PRIMTEAM^PRIMPRV^ATTND
PTINFO(DATA,DFN,SLCT) ;
 N X,CA,WL,RB,TS,DOD,AT,VT,VAEL,VAERR,VDT,LINE
 K ^TMP("ORWPCE",$J)
 Q:'$D(^DPT(+DFN,0))
 S X=^DPT(DFN,0),WL=$P($G(^(.1)),U),RB=$P($G(^(.101)),U),CA=+$G(^(.105)),TS=+$G(^(.103)),DOD=+$G(^(.35)),AT=+$G(^(.1041)),VT=$G(^("VET"))
 S DATA=$P(X,U,1,3)_U_$$FMTSSN($P(X,U,9))_U_U_WL_U_RB
 S:$L(WL) $P(DATA,U,5)=+$G(^DIC(42,+$O(^DIC(42,"B",WL,0)),44))
 S $P(DATA,U,8)=VT="Y"
 S $P(DATA,U,9)=$$ISSENS(DFN)
 S:CA $P(DATA,U,10)=$P($G(^DGPM(CA,0)),U)
 S:'$D(IOST) IOST="P-OTHER"
 I $G(DUZ("AG"))="I" D
 .S $P(DATA,U,11)=$$HRN(DFN)
 E  S $P(DATA,U,11)=$$EPI(DFN)
 D ELIG^VADPT
 S $P(DATA,U,12,13)=$P($G(VAEL(3)),U,1,2)
 S $P(DATA,U,14)=$$ICN(DFN)
 S $P(DATA,U,15)=DOD
 S $P(DATA,U,16)=TS
 S $P(DATA,U,17)=$P($$OUTPTTM^BEHOPTPC(DFN),U,2)
 S $P(DATA,U,18)=$P($$OUTPTPR^BEHOPTPC(DFN),U,2)
 S $P(DATA,U,19)=$S(AT:$P($G(^VA(200,AT,0)),U),1:"")
 D:$G(SLCT) LAST(,DFN)
 Q
 ; Save/retrieve last patient selected for current institution
LAST(DATA,DFN) ;
 D:$$ISACTIVE($G(DFN)) EN^XPAR("USR","BEHOPTCX LAST PATIENT","`"_DUZ(2),"`"_DFN)
 S DATA=$$GET^XPAR("USR","BEHOPTCX LAST PATIENT",DUZ(2),"I")
 S:DATA ^DISV(DUZ,"^DPT(")=DATA
 S:'$$GET^XPAR("ALL","BEHOPTCX RECALL LAST") DATA=""
 Q
 ; Return message if data on the legacy system
 ; DATA(0)=1 if data,  DATA(n)=display message if data
LEGACY(DATA,DFN) ;
 S DATA(0)=0
 I $L($T(HXDATA^A7RDPAGU)) D
 .D HXDATA^A7RDPAGU(.DATA,DFN)
 .S:$O(DATA(0)) DATA(0)=1
 Q
 ; Return a patient's current location
INPLOC(DATA,DFN) ;
 N X
 S X=$G(^DPT(DFN,.102)),DATA=0
 S:X X=$P($G(^DGPM(X,0)),U,6)
 S:X DATA=+$G(^DIC(42,X,44)),$P(DATA,U,2)=$P($G(^DIC(42,X,0)),U),X=$P($G(^DIC(42,X,0)),U,3)
 S $P(DATA,U,3)=X
 Q
 ; Returns true if selectable patient
ISACTIVE(DFN,QUALS) ;EP
 N X
 S:'$D(DEMO) DEMO=+$$GET^XPAR("ALL","BEHOPTCX DEMO MODE",,"Q")
 S X=$G(^DPT(+DFN,0))
 Q:'$L(X)!$P(X,U,19) 0
 I '$P(X,U,21),$$LKPQUAL("@BEHOPTCX DEMO MODE",.QUALS) Q 0
 Q:$$LKPQUAL("MSC DG ALL SITES HIPAA",.QUALS) 1
 Q:'$O(^AUPNPAT(DFN,41,0)) '$$LKPQUAL("@BEHOPTCX REQUIRES HRN",.QUALS)
 Q ''$L($$HRN(DFN))
 ; Return requested lookup qualifier
LKPQUAL(QUAL,CACHE) ;EP
 N RET
 S RET=$G(CACHE(QUAL))
 S:'$L(RET) (RET,CACHE(QUAL))=+$$HASKEY^BEHOUSCX(QUAL)
 Q RET
 ; Returns sensitive patient status
ISSENS(DFN) ;
 N RET
 D PTSEC^DGSEC4(.RET,DFN,0)
 Q $G(RET(1))
 ; Get DFN from ICN
ICN2DFN(DATA,ICN) ;
 S DATA=$S($L($T(GETDFN^MPIF001)):$$GETDFN^MPIF001(ICN),1:"")
 S:DATA<1 DATA=""
 Q
 ; Return ICN
ICN(DFN) N X
 S X=$S($L($T(GETICN^MPIF001)):+$$GETICN^MPIF001(DFN),1:"")
 Q $S(X>0:X,1:"")
 ; Return HRN given DFN
HRN(DFN) ;EP
 N X
 S X=$G(^AUPNPAT(DFN,41,+$G(DUZ(2)),0))
 Q $S($P(X,U,3):"",1:$P(X,U,2))
 ; Return MFN given DFN
EPI(DFN) ;EP
 Q $S($$TEST^CIAUOS("MSCDPTID"):$$^MSCDPTID(DFN),1:"")
 ; Return formatted patient detail report
PTINQ(DATA,DFN) ;
 S DATA=$$TMPGBL^CIAVMRPC
 D CAPTURE^CIAUHFS($TR($$GET^XPAR("ALL","BEHOPTCX DETAIL REPORT"),"~",U),DATA,80)
 Q
 ; Build Patient Inquiry
PTINQB(DFN) ;
 N DOC,TEAM,X,VAOA,PH,DOD,CAUSE,CAUSE2,NARR
 S DOD=$$GET1^DIQ(2,DFN,.351)
 I $L(DOD) D
 .W !,"******** PATIENT IS DECEASED ************"
 .W !,"Date of Death: ",DOD
 .I DUZ("AG")="I" D
 ..S CAUSE=$$GET1^DIQ(9000001,DFN,1114,"I")
 ..S CAUSE2=$$GET1^DIQ(80,CAUSE,.01)
 ..S NARR=$$GET1^DIQ(80,CAUSE,3)
 ..W:$L(NARR) !,"Underlying Cause: ",CAUSE2_" ("_NARR_")"
 D EN^BEHOPTC1                                                            ; mas patient inquiry
 S DOC=$$OUTPTPR^BEHOPTPC(DFN)
 S TEAM=$$OUTPTTM^BEHOPTPC(DFN)
 I DOC!TEAM  D
 .W !!,"Primary Care Information:"
 .W:DOC !,"Primary Practitioner:  ",$P(DOC,U,2)
 .W:TEAM !,"Primary Care Team:     ",$P(TEAM,U,2)
 W !!,"Service Connection/Rated Disabilities:"
 D DIS^DGRPDB
 ;IHS/MSC/MGH Added EHR patch 8 Insurance
 I DUZ("AG")="I" D
 .S VDT="TODAY",VDT=$$DT^CIAU(VDT),LINE=""
 .I $$MCR^AUPNPAT(DFN,VDT)=1 S LINE="MEDICARE #"_$$MCR^BTIULO2(DFN)_"/"
 .I $$MCD^AUPNPAT(DFN,VDT)=1 S LINE=LINE_"MEDICAID #"_$$MCD^BTIULO2(DFN)_"/"
 .I $$PI^AUPNPAT(DFN,VDT)=1 S LINE=LINE_"PVT INS ("_$$PIN^AUPNPAT(DFN,VDT,"E")_")/"
 .I LINE]"" D
 ..W !!,"INSURANCE:"
 ..W !,?5,$E(LINE,1,$L(LINE)-1)
 E  D
 .D DISP^DGIBDSP
 ;Added EHR patch 7
 I DUZ("AG")="I" D
 .S PH=$$GET1^DIQ(9000001,DFN,1801)
 .I PH'="" W !!,"Other Phone Contact: "_PH
 D OAD^VADPT                                                           ; get NOK address
 D:$L(VAOA(9))
 .W !!,"Next of Kin Information:"
 .W !,"Name:  ",VAOA(9)                                                ; nok name
 .W:$L(VAOA(10)) " (",VAOA(10),")"                                     ; relationship
 .W:$L(VAOA(1)) !?7,VAOA(1)                                            ; address line 1
 .W:$L(VAOA(2)) !?7,VAOA(2)                                            ; line 2
 .W:$L(VAOA(3)) !?7,VAOA(3)                                            ; line 3
 .D:$L(VAOA(4))
 ..W !?7,VAOA(4)                                                       ; city
 ..W:$L(VAOA(5)) ", "_$P(VAOA(5),U,2)                                  ; state
 ..W "  ",$P(VAOA(11),U,2)                                             ; zip+4
 .W:$L(VAOA(8)) !!?7,"Phone number:  ",VAOA(8)                         ; phone
 ;IHS/MSC/MGH Find Language Data Patch 8
 I DUZ("AG")="I" D
 .N PRILAN,PRETER,PREFLAN,PROF,LANDT,IEN
 .S LANDT=9999999 S LANDT=$O(^AUPNPAT(DFN,86,LANDT),-1) Q:LANDT=""  D
 ..S IEN=LANDT_","_DFN
 ..S PRILAN=$$GET1^DIQ(9000001.86,IEN,.02)
 ..S PRETER=$$GET1^DIQ(9000001.86,IEN,.03)
 ..S PREFLAN=$$GET1^DIQ(9000001.86,IEN,.04)
 ..S PROF=$$GET1^DIQ(9000001.86,IEN,.06)
 ..W !!,"Language Information:"
 ..W:$L(PRILAN) !?5,"Primary Language: ",PRILAN
 ..W:$L(PRETER) ?40,"Interpreter Needed: ",PRETER
 ..W:$L(PREFLAN) !,?5,"Preferred Language: ",PREFLAN
 ..W:$L(PROF) ?40,"English Proficiency: ",PROF
 ;IHS/MSC/MGH Communication method
 I DUZ("AG")="I" D
 .N MOC,GEN
 .W !!,"METHOD OF COMMUNICATION:"
 .S GEN=$$GET1^DIQ(9000001,DFN,4001)
 .S MOC=$$GET1^DIQ(9000001,DFN,4002)
 .I GEN'="" W !?5,"PERMISSION FOR E-MAIL: "_GEN
 .I MOC'="" W !?5,"PREFERRED METHOD: "_MOC
 D KVAR^VADPT
 K PRILAN,PRETER,LANDT,PREFLAN,PROF
 Q
SETCTX(DFN) ;PEP - Set the patient context
 N UID
 S UID=$$GETUID^CIANBUTL
 D:$L(UID) QUEUE^CIANBEVT("CONTEXT.PATIENT",+DFN,UID)
 Q:$Q ''$L(UID)
 Q
 ; Check for possible dups
CHKDUP(DATA,DFN) ; EP
 N DUPS,CNT,X
 D GUIBS5A^DPTLK6(.DUPS,DFN)
 I DUPS(1)<1 M DATA=DUPS Q
 F X=1:0 S X=$O(DUPS(X)) Q:'X  D
 .I 'DUPS(X) K DUPS(X) Q
 .I $P(DUPS(X),U,2)=DFN D
 ..S DUPS(1)=$$CD1(DUPS(X))
 ..K DUPS(X)
 .E  S DUPS(X)=$$CD1(DUPS(X))
 S CNT=0
 D CD2(1),CD2("You have selected the following patient:"),CD2(DUPS(1)),CD2()
 D CD2("However, these patients also have the same last name")
 D CD2("and the same last 4 digits of their SSNs:"),CD2()
 F X=1:0 S X=$O(DUPS(X)) Q:'X  D CD2(DUPS(X))
 D CD2(),CD2("Are you sure this is the correct patient?")
 Q
CD1(VAL) Q $P(VAL,U,3)_"   DOB: "_$$ENTRY^CIAUDT($P(VAL,U,4))_"   SSN: "_$$SSN^CIAU($P(VAL,U,5))_"   HRN: "_$$HRN($P(VAL,U,2))
CD2(VAL) S CNT=CNT+1,DATA(CNT)=$G(VAL)
 Q
 ;
FMTSSN(SSN) ;EP - P7
 N X
 S X=$E(SSN,6,$L(SSN))
 Q "XXX-XX-"_$S($L(X):X,1:"XXXX")
