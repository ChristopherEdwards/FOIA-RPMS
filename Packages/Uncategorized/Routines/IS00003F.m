IS00003F ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 7
 ;Copyright 2002 SAIC
EN D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=0
 I 'MATCH,LINE?1"S"1"T".ANPC S DO=1,MATCH=1
 E  S LCT=LCT-CNT,DO=0
 S:DO @("@INV@(""ST1"")")=$$PIECE^INHU(.LINE,DELIM,2)
 S:DO @("@INV@(""ST2"")")=$$PIECE^INHU(.LINE,DELIM,3)
 Q:MATCH
 Q
P1 D:'INVS MC^INHS
 ;Entering TRANS section.
 ;IF $D(@INV@("ST1"))
 I $D(@INV@("ST1"))
 D:$T
 .S (INX,X)=$G(@INV@("ST1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ST1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ST1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("ST2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("ST2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'ST2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("BPR1"))
 I $D(@INV@("BPR1"))
 D:$T
 .S (INX,X)=$G(@INV@("BPR1"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR1")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR1' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR2"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR2")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR2' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR3"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR3")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR3' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR4"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR4")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR4' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR5"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR5")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR5' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR6"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR6")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR6' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR7"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR7")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR7' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR8"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR8")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR8' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR9"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR9")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR9' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR10"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR10")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR10' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR11"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR12"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR12")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR13"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR13")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'BPR13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("BPR14"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("BPR14")=$G(X)
9 .D EN^IS00003G
 G R1^IS00003G
