IS00018I ;Compiled from script 'Generated: HL IHS LAB R01 UNILAB IN-I' on AUG 14, 2006
 ;Part 10
 ;Copyright 2006 SAIC
EN S @INV@("OBR46",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR46' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
H3 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR47",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR47",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR47",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR47' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 ;IF $D(@INV@("NTE1"))
 I $D(@INV@("NTE1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NTE4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("NTE4",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S INI(3)=0 F  S INI(3)=$O(@INV@("NTE4",INI(1),INI(2),INI(3))) Q:'INI(3)  S INI=INI(3) D
 ....S (INX,X)=@INV@("NTE4",INI(1),INI(2),INI(3))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("NTE4",INI(1),INI(2),INI(3))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NTE4' failed input transform in iteration #"_INI(1)_","_INI(2)_","_INI(3)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..Q
 .K DXS
 .Q
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
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX3",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX3",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX3",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX3' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX4",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX4",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX4",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX4' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX5",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX5",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX5",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX5' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX6",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX6",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX6",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX6' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX7",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX7",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX7",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX7' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX8",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX8",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX8",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX8",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX8' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX9",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX9",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX9",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX9",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX9' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX10",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX10",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX10",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX10",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX10' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX11",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX11",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX11",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX11",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX11' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX12",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("OBX12",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S (INX,X)=@INV@("OBX12",INI(1),INI(2))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("OBX12",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX12' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("OBX13",INI(1))) Q:'INI(1)  S INI=INI(1) D
9 ..D EN^IS00018J
 .D H4^IS00018J
 G H3^IS00018J
