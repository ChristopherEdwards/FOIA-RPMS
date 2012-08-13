IS00003X ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 25
 ;Copyright 2002 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CAS14",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS14' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
AB2 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS15",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS16",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS16",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS16",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS16' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS17",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS17",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS17",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS17' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS18",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS18",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS18",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS18' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("CAS19",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("CAS19",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CAS19",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS19' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 Q
AB1 ;IF $D(@INV@("REF1"))
 I $D(@INV@("REF1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("REF1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("REF1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("REF1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'REF1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("REF2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("REF2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("REF2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'REF2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 ;IF $D(@INV@("REF1"))
 I $D(@INV@("REF1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("REF1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("REF1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("REF1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'REF1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("REF2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("REF2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("REF2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'REF2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 ;IF $D(@INV@("AMT1"))
 I $D(@INV@("AMT1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("AMT1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("AMT1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("AMT1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'AMT1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("AMT2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("AMT2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
9 ..D EN^IS00003Y
 .D AE2^IS00003Y
 G AE1^IS00003Y
