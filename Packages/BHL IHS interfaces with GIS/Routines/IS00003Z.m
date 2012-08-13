IS00003Z ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 27
 ;Copyright 2002 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'PLB10' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PLB11"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PLB11")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PLB11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PLB12"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PLB12")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PLB12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PLB13"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PLB13")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PLB13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PLB14"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PLB14")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PLB14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
AH1 ;IF $D(@INV@("ST1"))
 I $D(@INV@("ST1"))
 D:$T
 .S (INX,X)=$G(@INV@("ST1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ST1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ST1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ST2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ST2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ST2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;Entering REQUIRED section.
 Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  D MAIN^BHLX835
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 ;Entering END section.
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 K @INV,INV,INDA,DIPA Q +$G(INREQERR)
