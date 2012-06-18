IS00027C ;Compiled from script 'Generated: HL IHS IZV04 V03VXR IN-I' on SEP 05, 2011
 ;Part 4
 ;Copyright 2011 SAIC
EN D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("IN23",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("IN23",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("IN23",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'IN23' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("IN26",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("IN26",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("IN26",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'IN26' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("IN28",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("IN28",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("IN28",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'IN28' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 Q
M1 ;IF $D(@INV@("ORC1"))
 I $D(@INV@("ORC1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("ORC5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("ORC5",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("ORC5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'ORC5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("ORC9",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("ORC9",INI(1))
 ..I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 ..S @INV@("ORC9",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'ORC9' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("ORC15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("ORC15",INI(1))
 ..I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 ..S @INV@("ORC15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'ORC15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .;IF $D(@INV@("RXA1"))
 .I $D(@INV@("RXA1"))
 .D:$T
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("RXA1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S (INX,X)=@INV@("RXA1",INI(1))
 ...S:$L(X) X=+X
 ...S @INV@("RXA1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("RXA2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S (INX,X)=@INV@("RXA2",INI(1))
 ...S:$L(X) X=+X
 ...S @INV@("RXA2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("RXA3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S (INX,X)=@INV@("RXA3",INI(1))
 ...I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 ...S @INV@("RXA3",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA3' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("RXA5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S (INX,X)=@INV@("RXA5",INI(1))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("RXA5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..K DXS
 ..S INI(1)=0 F  S INI(1)=$O(@INV@("RXA15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ...S (INX,X)=@INV@("RXA15",INI(1))
 ...I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ...S @INV@("RXA15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ...Q
 ..K DXS
 ..Q
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
 I $D(@INV@("QRF1"))#2,$G(@INV@("QRF1"))="" S INREQERR=2 D KILL^INHVA1("QRF","HL IHS QRF IN WHERE (QRF-1)")
 Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  D MAIN^BHLI
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 ;Entering END section.
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 K @INV,INV,INDA,DIPA Q +$G(INREQERR)
