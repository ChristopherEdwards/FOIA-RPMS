IS00026A ;Compiled from script 'Generated: HL IHS IZV04 V02VXX IN-I' on FEB 28, 2013
 ;Part 2
 ;Copyright 2013 SAIC
EN I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("MSH14")=$G(X)
 I '$D(X) D ERROR^INHS("Variable 'MSH14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 K DXS
 Q
C1 ;IF $D(@INV@("QRD1"))
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
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID2",INI(1))
 ..S:$L(X) X=+X
 ..S @INV@("PID2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID3",INI(1))
 ..S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 ..S @INV@("PID3",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID3' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID4",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PID4",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID4' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID5",INI(1))
 ..S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 ..S @INV@("PID5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID6",INI(1))
 ..S:X]"" X=$$HLPN^INHUT(X,INSUBDEL,INDELIMS,$P($G(INTHL7F2),U,4),"I")
 ..S @INV@("PID6",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID6' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID7",INI(1))
 ..I X]"" S X=$E(X,1,4)-1700_$E(X,5,8)
 ..S @INV@("PID7",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID7' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID11",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID11",INI(1))
 ..I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 ..S @INV@("PID11",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID11' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID13",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID13",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PID13",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID13' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID14",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID14",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PID14",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID14' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID17",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID17",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PID17",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID17' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID19",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID19",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PID19",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID19' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("PID26",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("PID26",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("PID26",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PID26' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 ;Entering REQUIRED section.
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH1"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL FIELD SEPARATOR")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH2"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL ENCODING CHARACTERS")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH9"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL MESSAGE TYPE")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH11"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL PROCESSING ID")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD1"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN QDTM (QRD-1)")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD2"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN QFC (QRD-2)")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD3"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN QP (QRD-3)")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD4"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN QID (QRD-4)")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD7"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN QTY (QRD-7)")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD8"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN WHO (QRD-8)")
 I $D(@INV@("QRD1"))#2,$G(@INV@("QRD9"))="" S INREQERR=2 D KILL^INHVA1("QRD","HL IHS QRD IN WHAT (QRD-9)")
9 G EN^IS00026B
