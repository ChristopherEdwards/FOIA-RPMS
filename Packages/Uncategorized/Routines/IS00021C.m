IS00021C ;Compiled from script 'Generated: HL IHS LAB R01 RML IN-I' on AUG 14, 2006
 ;Part 4
 ;Copyright 2006 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'PID14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID15"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID15")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID15' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID16"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID16")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID16' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID17"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID17")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID17' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID18"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID18")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID18' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID19"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID19")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID20"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID20")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID20' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID21"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID21")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID21' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID22"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID22")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID22' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID23"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID23")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID23' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID24"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID24")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID24' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID25"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID25")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID25' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID26"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID26")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID26' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID27"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID27")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID27' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID28"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID28")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID28' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID29"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID29")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID29' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID30"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID30")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID30' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID31"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID31")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID31' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID32"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID32")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID32' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID33"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID33")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID33' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID34"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID34")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID34' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID35"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID35")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID35' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID36"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID36")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID36' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID37"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID37")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID37' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID38"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID38")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID38' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 ;IF $D(@INV@("NTE1"))
 I $D(@INV@("NTE1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NTE4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("NTE4",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S INI(3)=0 F  S INI(3)=$O(@INV@("NTE4",INI(1),INI(2),INI(3))) Q:'INI(3)  S INI=INI(3) D
 ....S (INX,X)=@INV@("NTE4",INI(1),INI(2),INI(3))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("NTE4",INI(1),INI(2),INI(3))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NTE4' failed input transform in iteration #"_INI(1)_","_INI(2)_","_INI(3)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..Q
 .K DXS
 .Q
 Q
F1 ;IF $D(@INV@("PV11"))
 I $D(@INV@("PV11"))
 D:$T
 .S (INX,X)=$G(@INV@("PV11"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PV11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PV11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PV12"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PV12")=$G(X)
9 .D EN^IS00021D
 G G1^IS00021E
