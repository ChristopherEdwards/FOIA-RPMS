IS00003H ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 9
 ;Copyright 2002 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("DTM1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'DTM1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
W2 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("DTM2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("DTM2",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("DTM2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'DTM2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 Q
W1 ;IF $D(@INV@("N11"))
 I $D(@INV@("N11"))
 D:$T
 .S (INX,X)=$G(@INV@("N11"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N12"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N12")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N13"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N13")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N14"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N14")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("N31"))
 I $D(@INV@("N31"))
 D:$T
 .S (INX,X)=$G(@INV@("N31"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N31")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N31' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N32"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N32")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N32' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("N41"))
 I $D(@INV@("N41"))
 D:$T
 .S (INX,X)=$G(@INV@("N41"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N41")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N41' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N42"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N42")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N42' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N43"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N43")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N43' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
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
 ;IF $D(@INV@("PER1"))
 I $D(@INV@("PER1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PER1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PER1",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PER1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PER2",INI(1))) Q:'INI(1)  S INI=INI(1) D
9 ..D EN^IS00003I
 .D b2^IS00003I
 G b1^IS00003I
