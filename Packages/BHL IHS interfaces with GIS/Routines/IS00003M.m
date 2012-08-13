IS00003M ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 14
 ;Copyright 2002 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP1")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP2"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP2")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP3"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP3")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP4"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP4")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP5"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP5")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP6"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP6")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP6' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP7"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP7")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP7' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP8"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP8")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP9"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP9")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP9' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP10"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP10")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP10' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP11"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP11")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP12"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP12")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("CLP13"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("CLP13")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'CLP13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
j1 ;IF $D(@INV@("CAS1"))
 I $D(@INV@("CAS1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("CAS1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("CAS1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("CAS1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("CAS2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("CAS2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("CAS2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'CAS2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("CAS3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("CAS3",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
9 ..D EN^IS00003N
 .D k2^IS00003N
 G k1^IS00003O
