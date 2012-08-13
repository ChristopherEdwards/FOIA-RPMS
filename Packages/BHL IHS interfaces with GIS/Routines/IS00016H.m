IS00016H ;Compiled from script 'Generated: HL IHS LAB R01 QUEST IN-I' on AUG 14, 2006
 ;Part 9
 ;Copyright 2006 SAIC
EN S INI(1)=0 F  S INI(1)=$O(@INV@("OBR31",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR31",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR31",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR31' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR32",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR32",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR32",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR32' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR33",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR33",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR33",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR33' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR34",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR34",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR34",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR34' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR35",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR35",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR35",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR35' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR36",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR36",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR36",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR36' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR37",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR37",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR37",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR37' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR38",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR38",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR38",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR38' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR39",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR39",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR39",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR39' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR40",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR40",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR40",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR40' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR41",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR41",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR41",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR41' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR42",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR42",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR42",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR42' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR43",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR43",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR43",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR43' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR44",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR44",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR44",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR44' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR45",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR45",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR45",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR45' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR46",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR46",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR46",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR46' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR47",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR47",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR47",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR47' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 ;IF $D(@INV@("OBX1"))
 I $D(@INV@("OBX1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX1",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX1",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX1",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX1' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX2",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX2",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX2",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX2' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
9 .D EN^IS00016I
 G F3^IS00016J
