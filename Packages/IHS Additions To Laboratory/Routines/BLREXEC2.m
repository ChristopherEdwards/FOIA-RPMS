BLREXEC2 ;IHS/OIT/MKK - IHS MDRD STUDY EQUATION EXECUTE CODES ;MAY 06, 2009 9:58 AM
 ;;5.2T1;IHS LABORATORY;**1025,1026**;NOV 01, 1997
 ;
 ; Cloned from BLREXECU
 ;
 ; There are a total of four MDRD Study Equation tests in this file.
 ; 
 ;      Two are NON IDMS-Traceable MDRD Study Equation tests.
 ;      Two are IDMS-Traceable MDRD Study Equation tests.
 ; 
 ; Equations are from the National Kidney Disease website:
 ;               www.nkdep.nih.gov/resources
 ;
 ; IDMS-Traceable MDRD Study Equation 1 -- Conventional Units
GFRSE1CU(CRET) ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("GFRSE1CU^BLREXEC2")
 ;
 S %X=$$CHKERRS             ; Check for Errors
 I %X'="OK" Q %X            ; If NOT OK, quit with error
 ;
 NEW CONSTA,CRETEXP,AGEEXP,SEXFACTR,RACEFACT
 D SETVARS1                 ; Setup constants & exponents
 ;
 S %X=CONSTA*(CRET**CRETEXP)*(AGE**AGEEXP)*$G(SEXFACTR)*$G(RACEFACT)
 ;
 S %X=$TR($FN(%X,"",0)," ")          ;ROUND RESULT
 ;
 ; See www.nkdep.nih.gov/resources/laboratory_reporting.htm
 I %X>60 S %X=">60"
 ;
 Q %X
 ;
CHKERRS() ; EP
 N BLRERR
 S BLRERR="N/A"
 ;
 I $TR($G(CRET)," ")="" Q BLRERR   ; If creatinine null, then quit
 ;
 ; If 1st character not numeric, then quit
 ; I $E($G(CRET))'?1N Q BLRERR
 I $G(CRET)?1A.A S %X=BLRERR Q %X  ; IHS/OIT/MKK - LR*5.2*1026
 ;
 ; Following lines added to handle errors sent by some instruments
 ; Quit if any are true
 I $E($G(CRET))="" Q BLRERR        ; If Null
 I $E($G(CRET))="#" Q BLRERR       ; Out of Range
 I $E($G(CRET))="<" Q BLRERR       ; Vitros results with "<"
 I ($G(CRET))="-" Q BLRERR         ; Negative results
 ;
 I +$G(CRET)=0 Q BLRERR            ; If zero results, then quit
 ;
 I AGE["DYS"!(AGE["MOS")!(AGE<17) Q BLRERR  ; 16 & younger not done, quit
 ;
 I SEX="" Q BLRERR                 ; Cannot calculate without SEX
 ;
 Q "OK"
 ;
SETVARS1 ; EP
 ;CONSTANTS, EXPONENTS
 S SEXFACTR=$S(SEX="M":1,1:.742)   ; Sex Factor
 ;
 S RACEFACT=$S($$RACE(DFN)="B":1.21,1:1)
 ;
 S CONSTA=186       ; CONSTANT A
 S CRETEXP=-1.154   ; CREATININE EXPONENT
 S AGEEXP=-.203     ; AGE EXPONENT
 ;
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("SETVARS1^BLREXEC2")
 Q
 ;
 ; Race of patient: defined as black or non-black
RACE(DFN) ; EP
 NEW RACEPTR,RACEENT
 ;
 S RACEPTR=$P($G(^DPT(+$G(DFN),0)),U,6)
 Q:RACEPTR="" "N"             ; If no entry, consider non-black
 ;
 S RACEENT=$P($G(^DIC(10,RACEPTR,0)),U)
 Q:RACEENT[("BLACK") "B"      ; If RACEENT contains BLACK => race = Black
 Q "N"                        ; otherwise, non-black
 ;
 ; IDMS-Traceable MDRD Study Equation 1 -- SI Units
GFRSE1SI(CRET) ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("GFRSE1SI^BLREXEC2")
 Q:$G(CRET)="" ""           ; If creatinine null, then quit
 ;
 S %X=$$CHKERRS             ; Check for Errors
 I %X'="OK" Q %X            ; If NOT OK, quit with error
 ;
 NEW CONSTA,CRETEXP,AGEEXP,SEXFACTR,RACEFACT
 D SETVARS1                 ; Setup constants & exponents
 ;
 S %X=CONSTA*((CRET/88.4)**CRETEXP)*(AGE**AGEEXP)*$G(SEXFACTR)*$G(RACEFACT)
 ;
 S %X=$TR($FN(%X,"",0)," ")          ;ROUND RESULT
 ;
 ; See www.nkdep.nih.gov/resources/laboratory_reporting.htm
 I %X>60 S %X=">60"
 ;
 Q %X
 ;
 ; IDMS-Traceable MDRD Study Equation 2 -- Conventional units
 ; GFRSE2CU ; EP
GFRSE2CU(CRET) ; EP -- Added paramater -- IHS/OIT/MKK - LR*5.2*1026
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("GFRSE2CU^BLREXEC2")
 Q:$G(CRET)="" ""           ; If creatinine null, then quit
 ;
 S %X=$$CHKERRS             ; Check for Errors
 I %X'="OK" Q %X            ; If NOT OK, quit with error
 ;
 NEW CONSTA,CRETEXP,AGEEXP,SEXFACTR,RACEFACT
 D SETVARS2                 ; Setup constants & exponents
 ;
 S %X=CONSTA*(CRET**CRETEXP)*(AGE**AGEEXP)*$G(SEXFACTR)*$G(RACEFACT)
 ;
 S %X=$TR($FN(%X,"",0)," ")          ;ROUND RESULT
 ;
 ; See www.nkdep.nih.gov/resources/laboratory_reporting.htm
 I %X>60 S %X=">60"
 ;
 Q %X
 ;
SETVARS2 ; EP
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("SETVARS2^BLREXEC2")
 ;CONSTANTS, EXPONENTS
 S SEXFACTR=$S($G(SEX)="M":1,1:.742)   ; Sex Factor
 ;
 S RACEFACT=$S($$RACE($G(DFN))="B":1.21,1:1)
 ;
 S CONSTA=175       ; CONSTANT A
 S CRETEXP=-1.154   ; CREATININE EXPONENT
 S AGEEXP=-.203     ; AGE EXPONENT
 ;
 Q
 ;
 ; IDMS-Traceable MDRD Study Equation 2 -- SI units
 ; GFRSE2SI ; EP
GFRSE2SI(CRET) ; EP -- Added paramater -- IHS/OIT/MKK - LR*5.2*1026
 D:$G(SNAPSHOT) ENTRYAUD^BLRUTIL("GFRSE2SI^BLREXEC2")
 Q:$G(CRET)="" ""           ; If creatinine null, then quit
 ;
 S %X=$$CHKERRS             ; Check for Errors
 I %X'="OK" Q %X            ; If NOT OK, quit with error
 ;
 NEW CONSTA,CRETEXP,AGEEXP,SEXFACTR,RACEFACT
 D SETVARS2                 ; Setup constants & exponents
 ;
 S %X=CONSTA*((CRET/88.4)**CRETEXP)*(AGE**AGEEXP)*$G(SEXFACTR)*$G(RACEFACT)
 ;
 S %X=$TR($FN(%X,"",0)," ")          ;ROUND RESULT
 ;
 ; See www.nkdep.nih.gov/resources/laboratory_reporting.htm
 I %X>60 S %X=">60"
 ;
 Q %X
 ;
 ; Get the Data Name of the test
GETDNAM(NAME) ; EP
 S DNAME=$O(^DD(63.04,"B",NAME,0))
 Q:DNAME="" "NULL"
 Q DNAME
