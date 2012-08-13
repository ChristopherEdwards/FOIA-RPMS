IS00003J ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 11
 ;Copyright 2002 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'N41' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("N42"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("N42")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'N42' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("N43"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("N43")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'N43' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("N44"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("N44")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'N44' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
e1 ;IF $D(@INV@("REF1"))
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
 ;IF $D(@INV@("LX1"))
 I $D(@INV@("LX1"))
 D:$T
 .S (INX,X)=$G(@INV@("LX1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("LX1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'LX1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("TS31"))
 I $D(@INV@("TS31"))
 D:$T
 .S (INX,X)=$G(@INV@("TS31"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS31")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS31' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS32"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS32")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS32' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS33"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS33")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS33' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS34"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS34")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS34' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS35"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS35")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS35' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS36"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS36")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS36' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS37"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS37")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS37' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS38"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS38")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS38' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS39"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("TS39")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'TS39' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("TS310"))
9 .D EN^IS00003K
 G h1^IS00003K
