IS00021F ;Compiled from script 'Generated: HL IHS LAB R01 RML IN-I' on AUG 14, 2006
 ;Part 7
 ;Copyright 2006 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC8")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC9"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC9")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC9' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC10"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC10")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC10' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC11"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC11")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC12"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC12")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC13"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC13")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC14"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC14")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC15"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC15")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC15' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC16"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC16")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC16' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC17"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC17")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC17' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC18"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC18")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC18' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC19"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC19")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC20"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC20")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC20' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC21"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC21")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC21' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC22"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC22")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC22' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC23"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC23")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC23' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC24"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC24")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC24' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ORC25"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ORC25")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ORC25' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 ;IF $D(@INV@("OBR1"))
 I $D(@INV@("OBR1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR3",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR3",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR3' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR4",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR4",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR4' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR5",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR6",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR6",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR6' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR7",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR7",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR7' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR8",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR8",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
9 ..D EN^IS00021G
 .D H3^IS00021G
 G H2^IS00021J
