SCMSVUT0 ;ALB/ESD HL7 Segment Validation Utilities ;05/09/96
 ;;5.3;Scheduling;**44,55,66,132,245,254**;Aug 13, 1993
 ;
 ;
CONVERT(SEG,HLFS,HLQ) ; Convert HLQ ("") to null in segment
 ;      Input:  SEG  = HL7 segment
 ;             HLFS  = HL7 field separator
 ;              HLQ  = HL7 "" character
 ;
 ;     Output:  SEG  = Segment where HLQ replaced with null
 ;
 ;
 N I
 F I=1:1:55 I $P(SEG,HLFS,I)=HLQ S $P(SEG,HLFS,I)=""
 Q SEG
 ;
SETID(SDOE,SDDELOE) ; Set PCE Unique Visit Number in field #.2 of #409.68
 ;      Input:   SDOE = IEN of Outpatient Encounter (#409.68) file
 ;            SDDELOE = IEN of Deleted Outpatient Encounter (#409.74) file
 ;
 ;     Output:   Unique Visit Number set in field #.2 of #409.68
 ;               or field #.2 of #409.74
 ;
 ;
 N SDOEC,SDARRY
 S SDOEC=0
 S SDOE=+$G(SDOE)
 S SDDELOE=+$G(SDDELOE)
 ;
 ;-Outpatient Enc pointer passed in; use file #409.68
 S SDARRY="^SCE("_SDOE_",0)"
 ;
 ;-Deleted Outpatient Enc pointer passed in; use file #409.74
 S:(SDDELOE) SDARRY="^SD(409.74,"_SDDELOE_",1)"
 ;
 ;-Quit if no encounter record or deleted encounter record
 Q:($G(@SDARRY)="")
 ;-Add unique ID to parent
 D GETID
 ;
 ;-Add unique ID to children for Outpatient Enc only (quit if no child encounter record)
 I (SDOE) F  S SDOEC=+$O(^SCE("APAR",SDOE,SDOEC)) Q:'SDOEC  S SDARRY="^SCE("_SDOEC_",0)" Q:($G(@SDARRY)="")  D GETID
 Q
 ;
GETID ;Get unique visit ID
 S:$P($G(@SDARRY),"^",20)="" $P(@SDARRY,"^",20)=$$IEN2VID^VSIT($P(@SDARRY,"^",5))
 Q
 ;
SETPRTY(SDOE) ;Set outpatient provider type in field #.06 of V PROVIDER
 ;      Input:  SDOE = IEN of Outpatient Encounter (#409.68) file
 ;
 ;     Output:  Provider Type set in field #.06 of V PROVIDER
 ;
 ;
 N SDPRTYP,SDVPRV,SDPRVS
 S SDOE=+$G(SDOE),SDVPRV=0
 ;
 ;- Get all provider IENs for encounter
 D GETPRV^SDOE(SDOE,"SDPRVS")
 F  S SDVPRV=+$O(SDPRVS(SDVPRV)) Q:'SDVPRV  D
 . S SDPRTYP=0
 . ;
 . ;- If no prov type, call API and add provider type to record
 . S:$P(SDPRVS(SDVPRV),"^",6)="" SDPRTYP=$$GET^XUA4A72(+SDPRVS(SDVPRV),+$G(^SCE(SDOE,0)))
 . I +$G(SDPRTYP)>0 D PCLASS^PXAPIOE(SDVPRV)
 Q
 ;
SETMAR(PIDSEG,PID1SEG,HLQ,HLFS) ; Set marital status prior to PID segment validation
 ;     Input:   PIDSEG = PID segment (< or = 245 chars)
 ;             PID1SEG = Remainder of PID segment (> 245 chars)
 ;                 HLQ = HL7 null variable
 ;                HLFS = HL7 field separator
 ;
 ;    Output:  Marital status changed from null to "U" (UNKNOWN) prior to validation of PID segment and transmittal to AAC
 ;
 ;
 N LSTP
 S PIDSEG=$G(PIDSEG)
 S:PIDSEG="" PIDSEG="VAFPID"
 S PID1SEG=$G(PID1SEG)
 S:PID1SEG="" PID1SEG="VAFPID"
 G SETMARQ:(($G(@PIDSEG)="")&($G(@PID1SEG@(1))=""))
 ;
 ;- Piece 17 of PID segment is marital status (piece 1 = segment name)
 I $G(@PID1SEG@(1))="" S:($P(@PIDSEG,HLFS,17)=""!($P(@PIDSEG,HLFS,17)=HLQ)) $P(@PIDSEG,HLFS,17)="U" G SETMARQ
 I $G(@PID1SEG@(1))]"" D
 . S LSTP=+($L(@PIDSEG,HLFS))
 .;
 .;- If PID segment = or > 17th piece, check marital status in PIDSEG
 . I ((LSTP=17)!(LSTP>17)) S:($P(@PIDSEG,HLFS,17)=""!($P(@PIDSEG,HLFS,17)=HLQ)) $P(@PIDSEG,HLFS,17)="U" Q
 .;
 .;- If PID segment < 17th piece, check marital status in PID1SEG
 . I (LSTP<17) S:($P(@PID1SEG@(1),HLFS,(17-(LSTP-1)))=""!($P(@PID1SEG@(1),HLFS,(17-(LSTP-1)))=HLQ)) $P(@PID1SEG@(1),HLFS,(17-(LSTP-1)))="U"
 ;
SETMARQ Q
 ;
SETPOW(DFN,ZPDSEG,HLQ,HLFS)     ; Set POW Status Indicated field prior to ZPD segment validation
 ;
 ;     Input:      DFN = IEN of Patient (#2) file
 ;              ZPDSEG = HL7 ZPD segment
 ;                 HLQ = HL7 null variable
 ;                HLFS = HL7 field separator
 ;
 ;    Output:  If Veteran and POW Status Indicated field = null, set to
 ;              U (Unknown)
 ;             If Non-Veteran, set to null
 ;
 S DFN=$G(DFN),ZPDSEG=$G(ZPDSEG)
 G SETPOWQ:(DFN="")!(ZPDSEG="")
 I $P($G(^DPT(DFN,"VET")),"^")="Y",($P(ZPDSEG,HLFS,18)=""!($P(ZPDSEG,HLFS,18)=HLQ)) S $P(ZPDSEG,HLFS,18)="U"
 I $P($G(^DPT(DFN,"VET")),"^")="N" S $P(ZPDSEG,HLFS,18)=HLQ
 ;
SETPOWQ Q ZPDSEG
 ;
 ;
SETVSI(DFN,ZSPSEG,HLQ,HLFS) ;Set Vietnam Service Indicated field prior to ZSP segment validation
 ;
 ;     Input:      DFN = IEN of Patient (#2) file
 ;              ZSPSEG = HL7 ZSP segment
 ;                 HLQ = HL7 null variable
 ;                HLFS = HL7 field separator
 ;
 ;    Output:  If Veteran and Vietnam Service Indicated field = null,
 ;              set to U (Unknown)
 ;             If Non-Veteran, set to null
 ;
 S DFN=$G(DFN),ZSPSEG=$G(ZSPSEG)
 G SETVSIQ:(DFN="")!(ZSPSEG="")
 I $P($G(^DPT(DFN,"VET")),"^")="Y",($P(ZSPSEG,HLFS,6)=""!($P(ZSPSEG,HLFS,6)=HLQ)) S $P(ZSPSEG,HLFS,6)="U"
 I $P($G(^DPT(DFN,"VET")),"^")="N" S $P(ZSPSEG,HLFS,6)=HLQ
 ;
SETVSIQ Q ZSPSEG
 ;
 ;
 ;
 ;The following subroutines all have to do with the validation of
 ;data using the same edit checks that are used by Austin.
 ;
HL7SEGNM(SEG,DATA) ;checks the validity of the HL7 segment name passed in.
 ;INPUT    SEG  - the HL7 segment name
 ;         DATA - the data to compare. In this case the HL7 segment name.
 ;
 ;OUTPUT   0 (ZERO) if not validate
 ;         1 if validated
 ;
 I '$D(SEG)!('$D(DATA)) Q 0
 Q $S(SEG=DATA:1,1:0)
 ;
EVTTYP(SEG,DATA) ;checks the event type of the segment passed in.
 ;INPUT  SEG  - The HL7 segment name in question
 ;       DATA - The event type from the HL7 segment in question.
 ;
 ;OUTPUT   0 (ZERO) if not validate
 ;         1 if validated
 ;
 I '$D(SEG)!('$D(DATA)) Q 0
 I SEG="EVN"&(DATA="A08"!(DATA="A23")) Q 1
 Q 0
 ;
EVTDTTM(DATA) ;Checks the date and time to ensure it is correct.
 ;INPUT  DATA - this is the date and time in quesiton.
 ;
 ;OUTPUT  0 (ZERO) if not validate
 ;        1 if validated
 ;
 I '$D(DATA) Q 0
 N STRTDT,%DT,X,Y
 S STRTDT=+$O(^SD(404.91,0))
 S STRTDT=$P($G(^SD(404.91,STRTDT,"AMB")),U,2)
 I 'STRTDT Q 0
 S %DT="T",%DT(0)=STRTDT,X=DATA
 D ^%DT
 Q $S(Y=-1:0,1:1)
 ;
VALIDATE(SEG,DATA,ERRCOD,VALERR,CTR) ;
 ;
 N ERRIEN,ERRCHK,RES
 S ERRIEN=+$O(^SD(409.76,"B",ERRCOD,""))
 I 'ERRIEN S @VALERR@(SEG,CTR)=ERRCOD D INCR Q
 S ERRCHK=$G(^SD(409.76,ERRIEN,"CHK"))
 I ERRCHK="" S @VALERR@(SEG,CTR)=ERRCOD D INCR Q
 X ERRCHK
 I 'RES S @VALERR@(SEG,CTR)=ERRCOD D INCR
 Q
 ;
DFN(DATA) ;
 ;INPUT   DATA - the DFN of the patient
 ;
 I '$D(DATA) Q 0
 I DATA=""!(DATA=0) Q 0
 I DATA'?1.N.".".N Q 0
 Q 1
 ;
PATNM(DATA) ;
 ;INPUT  DATA - The name of the patient
 ;
 I '$D(DATA) Q 0
 I DATA="" Q 0
 I DATA?.N.",".N Q 0
 I DATA?1.C Q 0
 Q 1
 ;
DOB(DATA,ENCDT) ;
 ;INPUT  DATA - The DOB to be tested.
 ;      ENCDT - The date/time of the encounter
 ;
 N %DT,X,Y
 I '$D(DATA) Q 0
 I '$D(ENCDT) Q 0
 I DATA'?1.N Q 0
 S %DT="T",%DT(0)=-ENCDT,X=DATA
 D ^%DT
 Q $S(Y=-1:0,1:1)
 ;
SEX(DATA) ;
 ;INPUT  DATA - The sex code to be validated
 ;
 I '$D(DATA) Q 0
 I "FMUO"'[DATA Q 0
 Q 1
 ;
RACE(DATA) ;
 ;INPUT  DATA - the race code to be validated (NNNN-C-XXX)
 ;
 N VAL,MTHD
 I '$D(DATA) Q 0
 I DATA="" Q 1
 S VAL=$P(DATA,"-",1,2)
 S MTHD=$P(DATA,"-",3)
 I VAL'?4N1"-"1N Q 0
 I ",SLF,UNK,PRX,OBS,"'[MTHD Q 0
 Q 1
 ;
STR1(DATA) ;
 ;INPUT   DATA - Street address line 1
 ;
 N LP,VAR
 I '$D(DATA) Q 0
 I DATA="" Q 0
 I DATA?1.N Q 0
 I DATA=" " Q 0
 F LP=1:1:$L(DATA) S VAR=$E(DATA,LP,LP) I $A(VAR)>32,($A(VAR)<127) S LP="Y" Q
 Q $S(LP="Y":1,1:0)
 ;
STR2(DATA) ;
 ;INPUT  DATA - Street address line 2
 I DATA?1.N Q 0
 Q 1
 ;
CITY(DATA) ;
 ;INPUT  DATA - The city code to be validated
 ;
 I DATA="" Q 0
 I DATA?1.N Q 0
 Q 1
 ;
STATE(DATA) ;
 ;INPUT  DATA - State code to be validated.
 ;
 I '$D(DATA) Q 0
 I DATA="" Q 0
 I '$D(^DIC(5,"C",DATA)) Q 0
 Q 1
 ;
ZIP(DATA) ;
 ;INPUT  DATA - The zipo code to be validated
 ;
 I '$D(DATA) Q 0
 I $E(DATA,1,5)="00000" Q 0
 I DATA'?5N."-".4N Q 0
 Q 1
 ;
COUNTY(DATA,STATE) ;
 ;INPUT  DATA  - The county code to be validated
 ;       STATE - STATE file IEN 
 ;
 I DATA="" Q 0
 I STATE="" Q 0
 I '$D(^DIC(5,+$G(STATE),1,"C",DATA)) Q 0
 Q 1
 ;
MARITAL(DATA) ;
 ;INPUT   DATA - The marital status code to be validated.
 ;
 I $L(DATA)>1 Q 0
 I "ADMSWU"'[DATA Q 0
 Q 1
 ;
REL(DATA) ;
 ;INPUT   DATA - The religion abbreviation to the validated
 ;
 I '$D(DATA) Q 0
 I DATA="" Q 0
 I '$D(^DIC(13,"C",+DATA)) Q 0
 Q 1
 ;
SSN(DATA,NOPCHK) ;
 ;INPUT   DATA - The SSN to be validated
 ;        NOPCHK - O = Check pseudo indicator (default)
 ;                 1 = Don't check pseudo indicator
 ;
 I '$D(DATA) Q 0
 N SSN,PSD
 S SSN=$E(DATA,1,9),PSD=$E(DATA,10)
 I SSN'?9N Q 0
 I '$G(NOPCHK) I (PSD'=" "),(PSD'=""),(PSD'="P") Q 0
 I $E(SSN,1,5)="00000" Q 0
 Q 1
 ;
INCR ;increases the counter
 S CTR=CTR+1
 Q
 ;
REMOVE(SEG,ERR,VALERR,CNT) ;
 ;INPUT SEG - The segment being worked on
 ;    VALERR - The array holding the information
 ;      CNT - the counter to use
 ;      ERR - error code to remove
 ;
 N LP
 F LP=1:1:CNT I $G(@VALERR@(SEG,LP))=ERR K @VALERR@(SEG,LP)
 Q
 ;
DECR(CNT) ;
 S CNT=CNT-1
 Q
 ;
