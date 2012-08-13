IS00005A ;Compiled from script 'Generated: HL IHS CHR R01 IN-I' on JUN 08, 2006
 ;Part 2
 ;Copyright 2006 SAIC
EN S:DO @("@INV@(""ZV119"")")=$$PIECE^INHU(.LINE,DELIM,20)
 S:DO @("@INV@(""ZV120"")")=$$PIECE^INHU(.LINE,DELIM,21)
 S:DO @("@INV@(""ZV121"")")=$$PIECE^INHU(.LINE,DELIM,22)
 S:DO @("@INV@(""ZV122"")")=$$PIECE^INHU(.LINE,DELIM,23)
 S:DO @("@INV@(""ZV123"")")=$$PIECE^INHU(.LINE,DELIM,24)
 Q:MATCH
 D:'INVS MC^INHS
 D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=0
 I 'MATCH,LINE?1"Z"1"H"1"R".ANPC S DO=1,MATCH=1
 E  S LCT=LCT-CNT,DO=0
 S:DO @("@INV@(""ZHR1"")")=$$PIECE^INHU(.LINE,DELIM,2)
 S:DO @("@INV@(""ZHR2"")")=$$PIECE^INHU(.LINE,DELIM,3)
 S:DO @("@INV@(""ZHR3"")")=$$PIECE^INHU(.LINE,DELIM,4)
 S:DO @("@INV@(""ZHR4"")")=$$PIECE^INHU(.LINE,DELIM,5)
 S:DO @("@INV@(""ZHR5"")")=$$PIECE^INHU(.LINE,DELIM,6)
 S:DO @("@INV@(""ZHR6"")")=$$PIECE^INHU(.LINE,DELIM,7)
 S:DO @("@INV@(""ZHR7"")")=$$PIECE^INHU(.LINE,DELIM,8)
 S:DO @("@INV@(""ZHR8"")")=$$PIECE^INHU(.LINE,DELIM,9)
 Q:MATCH
 Q
A1 ;WHILE $P(DATA,DELIM)="OBR"
 S INI(1)=1 F  S DATA=$$GL^INHOU(UIF,LCT) Q:'$$CHECKSEG^INHOU("OBR",0,1)  D  S INI(1)=INI(1)+1
 .D:'INVS MC^INHS
 .D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=1
 .S:DO @("@INV@(""OBR1"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,2)
 .S:DO @("@INV@(""OBR2"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,3)
 .S:DO @("@INV@(""OBR3"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,4)
 .S:DO @("@INV@(""OBR4"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,5)
 .S:DO @("@INV@(""OBR7"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,8)
 .S:DO @("@INV@(""OBR20"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,21)
 .S:DO @("@INV@(""OBR22"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,23)
 .S:DO @("@INV@(""OBR25"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,26)
 .S:DO @("@INV@(""OBR27"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,28)
 .S:DO @("@INV@(""OBR32"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,33)
 .S:DO @("@INV@(""OBR33"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,34)
 .S:DO @("@INV@(""OBR35"",INI(1))")=$$PIECE^INHU(.LINE,DELIM,36)
 .;WHILE $P(DATA,DELIM)="OBX"
 .S INI(2)=1 F  S DATA=$$GL^INHOU(UIF,LCT) Q:'$$CHECKSEG^INHOU("OBX",0,2)  D  S INI(2)=INI(2)+1
 ..D:'INVS MC^INHS
 ..D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=1
 ..S:DO @("@INV@(""OBX1"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,2)
 ..S:DO @("@INV@(""OBX2"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,3)
 ..S:DO @("@INV@(""OBX3"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,4)
 ..S:DO @("@INV@(""OBX4"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,5)
 ..S:DO @("@INV@(""OBX5"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,6)
 ..S:DO @("@INV@(""OBX6"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,7)
 ..S:DO @("@INV@(""OBX7"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,8)
 ..S:DO @("@INV@(""OBX8"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,9)
 ..S:DO @("@INV@(""OBX14"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,15)
 ..S:DO @("@INV@(""OBX16"",INI(1),INI(2))")=$$PIECE^INHU(.LINE,DELIM,17)
 ..Q
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
9 .D EN^IS00005B
 G D1^IS00005B
