IS00003R ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 19
 ;Copyright 2002 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("NM18")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'NM18' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("NM19"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("NM19")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'NM19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
p1 ;IF $D(@INV@("NM11"))
 I $D(@INV@("NM11"))
 D:$T
 .S (INX,X)=$G(@INV@("NM11"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM12"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM12")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM13"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM13")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM14"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM14")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM15"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM15")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM15' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM16"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM16")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM16' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM17"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM17")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM17' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM18"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM18")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM18' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("NM19"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM19")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'NM19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("MIA1"))
 I $D(@INV@("MIA1"))
 D:$T
 .S (INX,X)=$G(@INV@("MIA1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MIA1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MIA1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MIA2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MIA2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MIA2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MIA3"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MIA3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MIA3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MIA4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MIA4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MIA4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MIA5"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MIA5")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MIA5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MIA6"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MIA6")=$G(X)
9 .D EN^IS00003S
 G r1^IS00003T
