IS00026B ;Compiled from script 'Generated: HL IHS IZV04 V02VXX IN-I' on SEP 05, 2011
 ;Part 3
 ;Copyright 2011 SAIC
EN S @INV@("NK13",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK13' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
F3 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("NK14",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("NK14",INI(1))
 .I $L(X) S:$P(X,INSUBDEL,4)="" $P(X,INSUBDEL,4)=INSUBDEL
 .S @INV@("NK14",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK14' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("NK15",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("NK15",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NK15",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK15' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("NK17",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("NK17",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NK17",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK17' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("NK113",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("NK113",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("NK113",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NK113' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 Q
F2 Q
F1 ;Entering REQUIRED section.
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
 Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  D MAIN^BHLV02I
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 ;Entering END section.
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 K @INV,INV,INDA,DIPA Q +$G(INREQERR)
