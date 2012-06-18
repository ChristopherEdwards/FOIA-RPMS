IS00003O ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 16
 ;Copyright 2002 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CAS15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
k2 K DXS
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
k1 ;IF $D(@INV@("NM11"))
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
 ;IF $D(@INV@("NM11"))
 I $D(@INV@("NM11"))
 D:$T
 .S (INX,X)=$G(@INV@("NM11"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NM11")=$G(X)
9 .D EN^IS00003P
 G m1^IS00003P
