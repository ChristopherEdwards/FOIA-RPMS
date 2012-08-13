IS00027A ;Compiled from script 'Generated: HL IHS IZV04 V03VXR IN-I' on SEP 05, 2011
 ;Part 2
 ;Copyright 2011 SAIC
EN S:DO @("@INV@(""IN26"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,7)
 S:DO @("@INV@(""IN28"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,9)
 Q
D1 ;WHILE $P(DATA,DELIM)="ORC"
 S INI(1)=1 F  S DATA=$$GL^INHOU(UIF,LCT) Q:'$$CHECKSEG^INHOU("ORC",0,1)  D  S INI(1)=INI(1)+1
 .D:'INVS MC^INHS
 .D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=1
 .S:DO @("@INV@(""ORC1"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,2)
 .S:DO @("@INV@(""ORC2"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,3)
 .S:DO @("@INV@(""ORC3"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,4)
 .S:DO @("@INV@(""ORC5"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,6)
 .S:DO @("@INV@(""ORC7"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,8)
 .S:DO @("@INV@(""ORC9"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,10)
 .S:DO @("@INV@(""ORC12"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,13)
 .S:DO @("@INV@(""ORC15"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,16)
 .D:'INVS MC^INHS
 .D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=1
 .I LINE?1"R"1"X"1"A".ANPC S DO=1
 .E  S LCT=LCT-CNT,DO=0
 .S:DO @("@INV@(""RXA1"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,2)
 .S:DO @("@INV@(""RXA2"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,3)
 .S:DO @("@INV@(""RXA3"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,4)
 .S:DO @("@INV@(""RXA5"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,6)
 .S:DO @("@INV@(""RXA15"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,16)
 .Q
 D:'INVS MC^INHS
 ;Entering TRANS section.
 ;IF $D(@INV@("MSH1"))
 I $D(@INV@("MSH1"))
 D:$T
 .S (INX,X)=$G(@INV@("MSH1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH3"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH5"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH5")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH6"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH6")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH6' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH7"))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("MSH7")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH7' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH8"))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("MSH8")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH10"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH10")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH10' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH12"))
 .S:$L(X) X=+X
 .S @INV@("MSH12")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH13"))
 .S:$L(X) X=+X
 .S @INV@("MSH13")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("MSH14"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("MSH14")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'MSH14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("QRD1"))
 I $D(@INV@("QRD1"))
 D:$T
 .S (INX,X)=$G(@INV@("QRD1"))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("QRD1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'QRD1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("QRD4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("QRD4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'QRD4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("QRD9"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("QRD9")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'QRD9' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("QRF1"))
 I $D(@INV@("QRF1"))
 D:$T
 .S (INX,X)=$G(@INV@("QRF1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("QRF1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'QRF1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("QRF5"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("QRF5")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'QRF5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
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
9 .D EN^IS00027B
 G I1^IS00027B
