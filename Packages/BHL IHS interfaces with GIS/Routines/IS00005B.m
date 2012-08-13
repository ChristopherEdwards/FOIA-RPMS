IS00005B ;Compiled from script 'Generated: HL IHS CHR R01 IN-I' on JUN 08, 2006
 ;Part 3
 ;Copyright 2006 SAIC
EN S @INV@("PID11")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID13"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID13")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID14"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID14")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID17"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID17")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID17' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID19"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID19")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("PID26"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PID26")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'PID26' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
D1 ;IF $D(@INV@("ZP21"))
 I $D(@INV@("ZP21"))
 D:$T
 .S (INX,X)=$G(@INV@("ZP21"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP21")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP21' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP22"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP22")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP22' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP23"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP23")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP23' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP24"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP24")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP24' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP25"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP25")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP25' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP26"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP26")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP26' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP28"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP28")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP28' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP29"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP29")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP29' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP210"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP210")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP210' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP211"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP211")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP211' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP212"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP212")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP212' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP213"))
 .I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 .S @INV@("ZP213")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP213' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP214"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP214")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP214' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP215"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP215")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP215' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP216"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP216")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP216' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP217"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP217")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP217' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP218"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP218")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP218' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP219"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP219")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP219' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP221"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP221")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP221' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP222"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP222")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP222' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP223"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP223")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP223' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP225"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("ZP225")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP225' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP226"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP226")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ZP226' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ZP227"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ZP227")=$G(X)
9 .D EN^IS00005C
 G E1^IS00005C
