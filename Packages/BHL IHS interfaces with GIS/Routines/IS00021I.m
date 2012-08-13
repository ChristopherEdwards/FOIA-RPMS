IS00021I ;Compiled from script 'Generated: HL IHS LAB R01 RML IN-I' on AUG 14, 2006
 ;Part 10
 ;Copyright 2006 SAIC
EN S INI(1)=0 F  S INI(1)=$O(@INV@("OBX1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX1",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX1",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX1",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX1' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX2",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX2",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX2",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX2' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX3",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX3",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX3",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX3' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX4",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX4",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX4",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX4' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX5",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX5",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX5",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX5' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX6",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX6",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX6",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX6' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX7",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX7",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX7",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX7' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX8",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX8",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX8",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX8",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX8' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX9",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX9",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX9",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX9",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX9' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX10",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX10",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX10",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX10",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX10' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX11",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX11",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX11",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX11",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX11' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX12",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX12",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX12",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX12",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX12' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX13",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX13",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX13",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX13",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX13' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX14",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX14",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX14",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX14",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX14' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX15",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX15",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX15",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX15' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
9 G EN^IS00021J
