IS00010B ;Compiled from script 'Generated: HL IHS IZV04 IN-I' on SEP 05, 2011
 ;Part 3
 ;Copyright 2011 SAIC
EN S (INX,X)=@INV@("ORC9",INI(1))
 I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 S @INV@("ORC9",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'ORC9' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
H2 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("ORC15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("ORC15",INI(1))
 .I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 .S @INV@("ORC15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'ORC15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 ;IF $D(@INV@("RXA1"))
 I $D(@INV@("RXA1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("RXA1",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("RXA1",INI(1))
 ..S:$L(X) X=+X
 ..S @INV@("RXA1",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA1' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("RXA2",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("RXA2",INI(1))
 ..S:$L(X) X=+X
 ..S @INV@("RXA2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("RXA3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("RXA3",INI(1))
 ..I X]"" S X=$$TIMEIO^INHUT10(X,$P($G(INTHL7F2),U),$P($G(INTHL7F2),U,2),$P($G(INTHL7F2),U,3),1)
 ..S @INV@("RXA3",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA3' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("RXA5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("RXA5",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("RXA5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .S INI(1)=0 F  S INI(1)=$O(@INV@("RXA15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S (INX,X)=@INV@("RXA15",INI(1))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("RXA15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'RXA15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .K DXS
 .Q
 Q
H1 ;Entering REQUIRED section.
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH1"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL FIELD SEPARATOR")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH2"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL ENCODING CHARACTERS")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH9"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL MESSAGE TYPE")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH11"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL PROCESSING ID")
 Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  D MAIN^BHLI
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 ;Entering END section.
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 K @INV,INV,INDA,DIPA Q +$G(INREQERR)
