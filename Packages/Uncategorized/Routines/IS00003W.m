IS00003W ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 24
 ;Copyright 2002 SAIC
EN S @INV@("CAS2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
AB2 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS3",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS3",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS3' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS4",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS4",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS4' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS5",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS6",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS6",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS6' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS7",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS7",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS7' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS8",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS8",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS8",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS8' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS9",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS9",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS9",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS9' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS10",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS10",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS10",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS10' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS11",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS11",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS11",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS11' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS12",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS12",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS12",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS12' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS13",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS13",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS13",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS13' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS14",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS14",INI(1))
9 .D EN^IS00003X
 G AB2^IS00003X
