APSPPCCV ;IHS/CIA/DKM/PLS - PCC Data Management ;21-Jun-2010 16:22;SM
 ;;7.0;IHS PHARMACY MODIFICATIONS;**1003,1004,1005,1006,1007,1009**;Sep 23, 2004
 ; Modified - IHS/CIA/PLS - 10/07/05
 ;            IHS/MSC/PLS - 04/03/06
 ;                        - 10/31/06
 ;                        - 01/03/07 - Added logic to find an ancillary rx visit when more than one visit is returned
 ;                        - 09/26/07 - Added $GET to FNDVIS+5
 ;                        - 11/08/07 - Added RXV line label
 ;                        - 03/28/08 - Added logic to set Prescription Number into field 1102 of V MED file
 ;                        - 06/21/10 - Added line RXV+9
 ; RPC: Update PCC data
 ; DATA = Returned as 0 if successful
 ; PCC  = Array of PCC data to process
 ; X,Y  = Not used (but required)
SAVE(DATA,PCC,X,Y) ;EP
 N IDX,TYP,CODE,VST,VSTR,ADD,DEL,VAL,DFN,PRV,FLD,DAT,COM,EVT
 S IDX=0,DATA=0,PRV=0
 F  S IDX=$O(PCC(IDX)) Q:'IDX!DATA  D
 .S VAL=PCC(IDX),TYP=$P(VAL,U),CODE=$P(VAL,U,2),ADD=TYP["+",DEL=TYP["-",TYP=$TR(TYP,"+-")
 .D LOOK("COM",.COM)
 .I TYP?1.3AN,$T(@TYP)'="" D @TYP
 S EVT=""
 F  S EVT=$O(EVT(EVT)) Q:'$L(EVT)  D
 .D BRDCAST^CIANBEVT("PCC."_EVT(EVT)_"."_EVT)
 Q
 ; Look ahead for modifiers
 ; TYP = modifier type
 ; ARY = array to receive data
LOOK(TYP,ARY) ;EP
 K ARY
 N IDX2,CNT
 S IDX2=IDX
 F CNT=0:1 S IDX2=$O(PCC(IDX2)) Q:'IDX2  Q:$P(PCC(IDX2),U)'=TYP  D
 .I CNT S ARY(CNT)=PCC(IDX2)
 .E  S ARY=PCC(IDX2)
 .S IDX=IDX2
 Q
SET(FLN,PC,CV) ;EP
 S PC=$P(VAL,U,PC),FLD(FLN)=$S($D(CV):$$SET^CIAU(PC,CV),$L(PC):PC,1:"@")
 Q
 ; Find an existing V file entry
 ; CRT = Scalar or array of additional criteria in (field|format|value) format
FIND(FN,CODE,VST,CRT) ;EP
 N GBL,IEN
 S GBL=$$ROOT^DILFD(FN,,1),IEN=0
 S:$L($G(CRT)) CRT(-1)=CRT
 F  S IEN=+$O(@GBL@("AD",VST,IEN)) Q:'IEN  Q:$P($G(@GBL@(IEN,0)),U)=CODE&$$EVAL(.CRT)
 Q IEN
 ; Evaluate list of additional fields and values
EVAL(ARY) ;EP
 N LP,RES,ITM,TYP,FLD
 S RES=1,LP=""
 F  S LP=$O(CRT(LP)) Q:LP=""  D  Q:'RES
 .S ITM=CRT(LP),FLD=$P(ITM,"|"),TYP=$P(ITM,"|",2),TYP=$S($L(TYP):TYP,1:"E"),ITM=$P(ITM,"|",3,99)
 .I FLD=.001 S RES=IEN=ITM
 .E  S RES=$$GET1^DIQ(FN,IEN,FLD,TYP)=ITM
 Q RES
 ; Store the data in the specified V file
 ; FN = Fractional portion of V file file #
 ; CF = Field # of comment field (0=none; defaults to 81101)
 ; CRT = Additional lookup criteria
STORE(FN,CF,CRT) ;EP
 N CIAFLD,CIAERR,CIAIEN,IEN
 S:'$G(VST) VST=$$VSTR2VIS(DFN,.VSTR,'DEL)
 I VST'>0 S:'DEL DATA="-1^Cannot create visit." G STXIT
 S FN=9000010+FN
 S:'$D(CF) CF=81101
 I ADD S IEN="+1"
 E  S IEN=$$FIND(FN,CODE,VST,.CRT) I 'IEN G:DEL STXIT S IEN="+1"
 S:'$D(FLD(.01)) FLD(.01)=$S(DEL:"@",1:CODE)
 S FLD(.02)=DFN
 S FLD(.03)=VST
 S:CF&$D(COM) FLD(CF)=$P(COM,U,3,999)
 S:'$D(FLD(1204))&(PRV>0) FLD(1204)=PRV
 S:'$D(FLD(1201))&$G(DAT) FLD(1201)=DAT
 M CIAFLD(FN,IEN_",")=FLD
 K FLD
 D UPDATE^DIE("","CIAFLD","CIAIEN","CIAERR")
 S:$G(DIERR) DATA=-CIAERR("DIERR",1)_U_CIAERR("DIERR",1,"TEXT",1)
 S:$G(CIAIEN(1)) IEN=$G(CIAIEN(1))
 ;IHS/CIA/PLS - 10/07/05 - Remove a pharmacy created visit if no dependents
 I VST,DEL D
 .Q:$$GET1^DIQ(9000010,VST,.09)  ;Quit if dependent count not zero
 .Q:$$GET1^DIQ(9000010,VST,.25,"I")'=$$GETPROT()  ;Quit if protocol is not pharmacy protocol
 .Q:$$GET1^DIQ(9000010,VST,.24,"I")'=$$GETOPT()  ; Quit if option is not pharmacy option
 .D DELVSIT(VST)
 S EVT(TYP)=DFN
 ;IHS exemption approved on 3/29/2007
STXIT Q:$Q $G(IEN)
 Q
HDR ;; Visit string
 S VSTR=$P(VAL,U,4)
 Q
VST ;; Patient and encounter date
 S:CODE="PT" DFN=+$P(VAL,U,3)
 S:CODE="DT" DAT=+$P(VAL,U,3)
 Q
PRV ;; Provider
 S PRV=+CODE,ADD=0
 D:PRV>0 SET(.04,6,"1:P;0:S;:@"),STORE(.06)
 Q
POV ;; Purpose of visit
 S CODE=$$FIND1^DIC(80,,"X",CODE_" ","BA")
 D:CODE>0 SET(.04,4),SET(.12,5,"1:P;0:S;:@"),SET(.08,6),STORE(.07)
 Q
CPT ;; CPT codes
 S CODE=+$$CPT^ICPTCOD(CODE)
 D:CODE>0 SET(.16,5),STORE(.18)
 Q
 ;
RX ; Prescriptions
 N SIG,IEN,VMED,CRT
 D LOOK("SIG",.SIG)
 S FLD(.05)=$P($G(SIG),U,3)
 D SET(1202,6),SET(.06,7),SET(.07,8),SET(.08,9),SET(1102,10)
 S VMED=$P(VAL,U,3)
 S:VMED CRT=".001|I|"_VMED
 S IEN=$$STORE(.14,1101,.CRT)
 I IEN!DEL D
 .N RXN,RFN,FN,IENS,CIAFLD,CIAIEN,CIAERR
 .S RXN=$P(VAL,U,4),RFN=$P(VAL,U,5)
 .S IENS=$S(RFN:RFN_","_RXN_",",1:RXN_",")
 .S FN=$S(RFN:52.1,1:52)
 .S CIAFLD(FN,IENS,9999999.11)=$S(DEL:"@",1:IEN)
 .D UPDATE^DIE("","CIAFLD","CIAIEN","CIAERR")
 .S:$G(DIERR) DATA=-CIAERR("DIERR",1)_U_CIAERR("DIERR",1,"TEXT",1)
 Q
RXV ; Non-VA Meds
 N SIG,IEN,VMED,CRT
 D LOOK("SIG",.SIG)
 D SET(1108,4)
 S FLD(.05)=$P($G(SIG),U,3)
 D SET(1202,6),SET(.06,7),SET(.07,8),SET(.08,9)
 S VMED=$P(VAL,U,3)
 S:VMED CRT=".001|I|"_VMED
 S IEN=$$STORE(.14,1101,.CRT)
 S:IEN="+1" IEN=""  ;IHS/MSC/PLS - 06/21/10
 I IEN!DEL D
 .N NVA,RFN,FN,IENS,CIAFLD,CIAIEN,CIAERR,DFN
 .S IENS=+$P(VAL,U,4)_","_$P(VAL,U,5)_","
 .S FN=55.05
 .S CIAFLD(FN,IENS,9999999.11)=$S(DEL:"@",1:IEN)
 .D UPDATE^DIE("","CIAFLD","CIAIEN","CIAERR")
 .S:$G(DIERR) DATA=-CIAERR("DIERR",1)_U_CIAERR("DIERR",1,"TEXT",1)
 Q
 ; RPC: Fetch visit IEN given visit id
VID2IEN(DATA,VID) ;EP
 S DATA=$$VID2IEN^VSIT(VID)
 Q
 ; Find a visit (internal use only)
 ;   DFN = Patient IEN
 ;   DAT = Visit date/time
 ;   CAT = Service category
 ;   LOC = Hospital Location IEN(44) Defaults to zero (A nonzero value indicates that the Clinic was defined during prescription processing)
 ;   CRE = Force create?
 ;   PRV = Provider IEN to restrict search (optional)
 ;  PDIV = Pharmacy division (File 59 IEN)
 ;   PRF = Paperless refill flag
 ;   TYP = Visit Type
 ;  OLOC = Other location
 ;  OSID = Outside Location
FNDVIS(DFN,DAT,CAT,LOC,CRE,PRV,PDIV,PRF,TYP,OLOC,OSID) ;
 N IN,OUT,IEN,DIF,FVST
 S IN("PAT")=DFN
 S IN("VISIT DATE")=DAT
 S IN("SITE")=$S($G(OLOC):$$ABS(OLOC),1:DUZ(2))
 I $G(TYP)="O" D
 .S IN("APCDOLOC")=$S($L($G(OSID)):OSID,1:"OUTSIDE MED")
 .S IN("APCDLOC")=$$ABS(OLOC)
 S IN("VISIT TYPE")=$S($L($G(TYP)):TYP,$P($G(^APCCCTRL(DUZ(2),0)),U,4)]"":$P(^(0),U,4),1:"I")
 S IN("SRV CAT")=CAT
 S IN("USR")=DUZ
 S IN("APCDOPT")=$$GETOPT()
 S IN("APCDPROT")=$$GETPROT()
 I LOC D
 .S IN("HOS LOC")=LOC
 .I LOC=$$GET1^DIQ(9009033,$G(PDIV),317,"I") D
 ..S IN("TIME RANGE")=0
 ..S:$G(PRV)&PRF IN("PROVIDER")=PRV
 .E  D
 ..S IN("TIME RANGE")=-1
 ..S:$G(PRV) IN("PROVIDER")=PRV
 ..S IN("ANCILLARY")=1   ; IHS/MSC/PLS - 04/03/06
 E  D
 .S IN("TIME RANGE")=0
 .S IN("HOS LOC")=$$GET1^DIQ(9009033,$G(PDIV),317,"I")
 .S:$G(PRV)&PRF IN("PROVIDER")=PRV
 K:CAT="E" IN("HOS LOC")
 I CRE<0 D  Q IEN
 .S IN("FORCE ADD")=1
 .S IEN=$$MAKEVST(.IN)  ; Force Create and return visit
 E  D
 .K:'CRE IN("ANCILLARY")
 .S IN("NEVER ADD")=1
 .S FVST=$$FNDVSTX(.IN)
 Q $S(FVST:FVST,CRE>0:$$MAKEVST(.IN),1:0)
 ; Return whether an existing visit can be used or need to create one.
FNDVSTX(CRIT) ;
 N IEN,RET,EFLG
 S RET=0
 D GETVISIT^BSDAPI4(.CRIT,.OUT)
 Q:'OUT(0) RET  ; No visits were found
 S IEN=0,EFLG=0
 F  S IEN=$O(OUT(IEN)) Q:'IEN  D  Q:EFLG
 .D:OUT(IEN)="ADD" BRDCAST^CIANBEVT("PCC."_DFN_".VST",IEN)
 .I PRF,$$CKRXVST(IEN,13) S EFLG=1,RET=IEN Q
 .I 'PRF,$$CKRXVST(IEN,13) D
 ..K OUT(IEN)
 ..S OUT(0)=OUT(0)-1
 Q $S(RET:RET,OUT(0)=1:$O(OUT(0)),1:$$ANCVCK(.OUT))
 ;
MAKEVST(CRIT) ;
 N RET,OUT
 K CRIT("NEVER ADD")
 S CRIT("FORCE ADD")=1
 S CRIT("HOS LOC")=$S(IN("SRV CAT")="E":"",LOC:+LOC,1:$$GET1^DIQ(9009033,$G(PDIV),317,"I"))  ;SET TO PHARMACY HOSPITAL LOCATION
 S CRIT("CLINIC CODE")=$$GET1^DIQ(44,CRIT("HOS LOC"),8,"I")
 D GETVISIT^BSDAPI4(.CRIT,.OUT)
 Q:'OUT(0) OUT(0)
 S RET=+$O(OUT(0))
 D:OUT(RET)="ADD" BRDCAST^CIANBEVT("PCC."_DFN_".VST",RET)
 Q RET
 ; Check visit for a Pharmacy visit (ancillary or paperless refill) and matching time
 ; Time is passed, Protocol and Option to Create are pharmacy options
CKRXVST(VIEN,TM) ; EP
 N PRT,OPT
 S TM=$P($$GET1^DIQ(9000010,VIEN,.01,"I"),".",2)=TM
 S PRT=$$GET1^DIQ(9000010,VIEN,.25,"I")=$$GETPROT()
 S OPT=$$GET1^DIQ(9000010,VIEN,.24,"I")=$$GETOPT()
 Q TM&PRT&OPT
 ; Check visits in array for existence of RX ancillary visit and return first ancillary visit
ANCVCK(VARY) ; EP
 ;Q 0
 N VIEN,RES
 S RES=0
 S VIEN=0
 F  S VIEN=$O(VARY(VIEN)) Q:'VIEN  D  Q:RES
 .S:$$CKRXVST(VIEN,12) RES=VIEN
 Q RES
 ; Return absolute value
ABS(X) Q $S(X<0:-X,1:X)
 ; Return a visit ien from a visit string (create if necessary)
 ;   DFN    = Patient IEN
 ;   VSTR   = Visit string (format: Hospital Location IEN or zero;Date of Service;Service Category;Visit IEN;outside med other location (- number = outside med, + number = other pharmacy)
 ;   CREATE = Create flag
 ;            0 = Don't create
 ;           >0 = Create if not found
 ;           <0 = Always create
 ;   PRV    = Provider IEN to restrict visit search (optional)
 ;   PDIV   = Pharmacy Division (optional) Used for lookup of associated Hospital Location
 ;    PRF   = Paperless Refill Flag
VSTR2VIS(DFN,VSTR,CREATE,PRV,PDIV,PRF) ;EP
 N IEN,DAT,CAT,LOC,FLG,VSIT,LP,APCDALVR,TYP,OLOC,OSID
 S LOC=+VSTR,DAT=+$P(VSTR,";",2),CAT=$P(VSTR,";",3),IEN=+$P(VSTR,";",4),CREATE=+$G(CREATE)
 S OLOC=$P(VSTR,";",5),TYP=$S(OLOC:"O",1:""),OSID=$P(VSTR,";",6)
 S:'IEN IEN=$$FNDVIS(DFN,DAT,CAT,LOC,CREATE,.PRV,+$G(PDIV),+$G(PRF),TYP,OLOC,OSID)
 I IEN>0 D
 .S VSTR=$G(^AUPNVSIT(+IEN,0))
 .I '$L(VSTR) S IEN="-1^Visit does not exist"
 .E  I $P(VSTR,U,5)'=DFN S IEN="-1^Visit does not belong to current patient"
 .E  S VSTR=$S($P(VSTR,U,22):$P(VSTR,U,22),1:LOC)_";"_+VSTR_";"_$P(VSTR,U,7)_";"_+IEN  ; IHS/MSC/PLS - 10/31/06 - Correct issue with Hosp Loc piece
 Q IEN
 ; Build PCC array
ADDPCC(X) ;
 S:'$D(PCC) PCC(1)="HDR^^^"_VSTR,PCC(2)="VST^PT^"_DFN
 S PCC($O(PCC(""),-1)+1)=X
 Q
 ; Return Option IEN used to Create
GETOPT() ;EP
 N RET
 S RET=$$FIND1^DIC(19,,"O","PSO LM BACKDOOR ORDERS")
 Q $S(RET:RET,1:"")
 ; Return Protocol IEN used to Create
GETPROT() ;EP
 N RET
 S RET=$$FIND1^DIC(101,,"O","IHS PS HOOK")
 Q $S(RET:RET,1:"")
 ;
DELVSIT(VST) ;EP
 N APCDVLDT,U,APCDVFLE,AUPNVSIT,APCDVNM,APCDVDG,APCDVIGR,APCDVDFN
 N APCDVI,DIK,DA
 S APCDVDLT=VST
 D EN^APCDVDLT
 Q
