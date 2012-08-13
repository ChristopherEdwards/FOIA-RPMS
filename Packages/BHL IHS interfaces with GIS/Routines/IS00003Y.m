IS00003Y ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 26
 ;Copyright 2002 SAIC
EN S @INV@("AMT2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'AMT2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
AE2 K DXS
 Q
AE1 ;IF $D(@INV@("QTY1"))
 I $D(@INV@("QTY1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("QTY1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("QTY1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("QTY1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'QTY1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("QTY2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("QTY2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("QTY2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'QTY2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 ;IF $D(@INV@("LQ1"))
 I $D(@INV@("LQ1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("LQ1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("LQ1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("LQ1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'LQ1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("LQ2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("LQ2",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("LQ2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'LQ2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 ;IF $D(@INV@("PLB1"))
 I $D(@INV@("PLB1"))
 D:$T
 .S (INX,X)=$G(@INV@("PLB1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB3"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB5"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB5")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB6"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB6")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB6' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB7"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB7")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB7' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB8"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB8")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB9"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB9")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PLB9' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PLB10"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PLB10")=$G(X)
9 .D EN^IS00003Z
 G AH1^IS00003Z
