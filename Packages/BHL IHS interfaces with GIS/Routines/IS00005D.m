IS00005D ;Compiled from script 'Generated: HL IHS CHR R01 IN-I' on JUN 08, 2006
 ;Part 5
 ;Copyright 2006 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'ZHR2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZHR3"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZHR3")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZHR3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZHR4"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZHR4")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZHR4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZHR5"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZHR5")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZHR5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZHR6"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZHR6")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZHR6' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZHR7"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZHR7")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZHR7' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZHR8"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZHR8")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZHR8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
H1 ;IF $D(@INV@("OBR1"))
 I $D(@INV@("OBR1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR4",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR4",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR4' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR7",INI(1))
 ..I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 ..S @INV@("OBR7",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR7' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR20",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR20",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR20",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR20' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR22",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR22",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR22",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR22' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR27",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR27",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR27",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR27' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR32",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR32",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR32",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR32' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR33",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR33",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR33",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR33' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBR35",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("OBR35",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBR35",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR35' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .;IF $D(@INV@("OBX1"))
 .I $D(@INV@("OBX1"))
 .D:$T
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("OBX3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S INI(2)=0 F  S INI(2)=$O(@INV@("OBX3",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ....S (INX,X)=@INV@("OBX3",INI(1),INI(2))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("OBX3",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX3' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("OBX4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S INI(2)=0 F  S INI(2)=$O(@INV@("OBX4",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ....S (INX,X)=@INV@("OBX4",INI(1),INI(2))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("OBX4",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX4' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("OBX5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S INI(2)=0 F  S INI(2)=$O(@INV@("OBX5",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ....S (INX,X)=@INV@("OBX5",INI(1),INI(2))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("OBX5",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX5' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("OBX6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S INI(2)=0 F  S INI(2)=$O(@INV@("OBX6",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ....S (INX,X)=@INV@("OBX6",INI(1),INI(2))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("OBX6",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX6' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("OBX7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S INI(2)=0 F  S INI(2)=$O(@INV@("OBX7",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
9 ....D EN^IS00005E
 ...D I4^IS00005E
 ..D I3^IS00005E
 .D I2^IS00005E
 G I1^IS00005E
