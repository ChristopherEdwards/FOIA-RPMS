IS00005C ;Compiled from script 'Generated: HL IHS CHR R01 IN-I' on JUN 08, 2006
 ;Part 4
 ;Copyright 2006 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'ZP227' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZP228"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZP228")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZP228' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZP229"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZP229")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZP229' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZP230"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("ZP230")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZP230' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZP231"))
 S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 S @INV@("ZP231")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZP231' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZP232"))
 I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 S @INV@("ZP232")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZP232' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("ZP233"))
 I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 S @INV@("ZP233")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'ZP233' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
E1 ;IF $D(@INV@("PV11"))
 I $D(@INV@("PV11"))
 D:$T
 .S (INX,X)=$G(@INV@("PV144"))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("PV144")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PV144' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PV145"))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("PV145")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PV145' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("ZV11"))
 I $D(@INV@("ZV11"))
 D:$T
 .S (INX,X)=$G(@INV@("ZV11"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZV11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV12"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV12")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV14"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZV14")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV15"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV15")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV15' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV16"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV16")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV16' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV17"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV17")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV17' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV18"))
 .S:$L(X) X=+X
 .S @INV@("ZV18")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV18' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV19"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV19")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV110"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV110")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV110' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV111"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV111")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV111' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV112"))
 .S:$L(X) X=+X
 .S @INV@("ZV112")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV112' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV116"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV116")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV116' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV117"))
 .S:$L(X) X=+X
 .S @INV@("ZV117")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV117' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV118"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV118")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV118' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV119"))
 .S:$L(X) X=+X
 .S @INV@("ZV119")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV119' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV120"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV120")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV120' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV121"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZV121")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV121' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV122"))
 .S:$L(X) X=+X
 .S @INV@("ZV122")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV122' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZV123"))
 .S:$L(X) X=+X
 .S @INV@("ZV123")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZV123' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("ZHR1"))
 I $D(@INV@("ZHR1"))
 D:$T
 .S (INX,X)=$G(@INV@("ZHR1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZHR1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZHR1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZHR2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZHR2")=$G(X)
9 .D EN^IS00005D
 G H1^IS00005D
