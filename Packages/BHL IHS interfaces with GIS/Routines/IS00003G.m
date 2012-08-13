IS00003G ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 8
 ;Copyright 2002 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'BPR14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("BPR15"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("BPR15")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'BPR15' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("BPR16"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("BPR16")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'BPR16' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
R1 ;IF $D(@INV@("TRN1"))
 I $D(@INV@("TRN1"))
 D:$T
 .S (INX,X)=$G(@INV@("TRN1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TRN1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TRN1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TRN2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TRN2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TRN2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TRN3"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TRN3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TRN3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TRN4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TRN4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TRN4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("CUR1"))
 I $D(@INV@("CUR1"))
 D:$T
 .S (INX,X)=$G(@INV@("CUR1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CUR1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'CUR1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("CUR2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CUR2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'CUR2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("CUR3"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("CUR3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'CUR3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
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
 ;IF $D(@INV@("DTM1"))
 I $D(@INV@("DTM1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("DTM1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("DTM1",INI(1))
9 ..D EN^IS00003H
 .D W2^IS00003H
 G W1^IS00003H
