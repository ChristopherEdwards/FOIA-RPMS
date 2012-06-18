IS00018H ;Compiled from script 'Generated: HL IHS LAB R01 UNILAB IN-I' on AUG 14, 2006
 ;Part 9
 ;Copyright 2006 SAIC
EN S INI(1)=0 F  S INI(1)=$O(@INV@("OBR27",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR27",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR27",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR27' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR28",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR28",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR28",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR28' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR29",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR29",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR29",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR29' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR30",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR30",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR30",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR30' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR31",INI(1))) Q:'INI(1)  S INI=INI(1) D
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
9 .D EN^IS00018I
 G H3^IS00018I
