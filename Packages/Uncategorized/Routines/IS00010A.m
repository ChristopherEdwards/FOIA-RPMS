IS00010A ;Compiled from script 'Generated: HL IHS IZV04 IN-I' on SEP 05, 2011
 ;Part 2
 ;Copyright 2011 SAIC
EN I '$D(X) D ERROR^INHS("Variable 'MSH8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("MSH10"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("MSH10")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'MSH10' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("MSH12"))
 S:$L(X) X=+X
 S @INV@("MSH12")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'MSH12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("MSH13"))
 S:$L(X) X=+X
 S @INV@("MSH13")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'MSH13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 S (INX,X)=$G(@INV@("MSH14"))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("MSH14")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'MSH14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
D1 ;IF $D(@INV@("EVN1"))
 I $D(@INV@("EVN1"))
 D:$T
 .S (INX,X)=$G(@INV@("EVN1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("EVN1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'EVN1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("EVN2"))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("EVN2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'EVN2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("PID1"))
 I $D(@INV@("PID1"))
 D:$T
 .S (INX,X)=$G(@INV@("PID3"))
 .S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 .S @INV@("PID3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PID4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID5"))
 .S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 .S @INV@("PID5")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID6"))
 .S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 .S @INV@("PID6")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID6' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID7"))
 .I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 .S @INV@("PID7")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID7' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID11"))
 .I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 .S @INV@("PID11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID13"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PID13")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID14"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PID14")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID17"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PID17")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID17' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID19"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PID19")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID19' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("PID26"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PID26")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'PID26' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("NK11"))
 I $D(@INV@("NK11"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NK12",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("NK12",INI(1))
 ..S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 ..S @INV@("NK12",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK12' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NK13",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("NK13",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("NK13",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK13' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NK14",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("NK14",INI(1))
 ..I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 ..S @INV@("NK14",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK14' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NK15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("NK15",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("NK15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NK17",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("NK17",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("NK17",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK17' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NK113",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("NK113",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("NK113",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK113' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 ;IF $D(@INV@("ORC1"))
 I $D(@INV@("ORC1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("ORC5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("ORC5",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("ORC5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'ORC5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("ORC9",INI(1))) Q:'INI(1)  S INI=INI(1) D
9 ..D EN^IS00010B
 .D H2^IS00010B
 G H1^IS00010B
