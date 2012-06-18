IS00022G ;Compiled from script 'Generated: HL IHS LAB R01 SONORA QUEST IN-I' on AUG 14, 2006
 ;Part 8
 ;Copyright 2006 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("OBR11",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR11' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
F3 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR12",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR12",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR12",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR12' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR13",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR13",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR13",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR13' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR14",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR14",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR14",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR14' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR15",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR16",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR16",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR16",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR16' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR17",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR17",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR17",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR17' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR18",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR18",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR18",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR18' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR19",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR19",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR19",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR19' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR20",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR20",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR20",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR20' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR21",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR21",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR21",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR21' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR22",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR22",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR22",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR22' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR23",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR23",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR23",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR23' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR24",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR24",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR24",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR24' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR25",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR25",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR25",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR25' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR26",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("OBR26",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("OBR26",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBR26' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBR27",INI(1))) Q:'INI(1)  S INI=INI(1) D
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
9 G EN^IS00022H
