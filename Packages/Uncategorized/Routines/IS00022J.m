IS00022J ;Compiled from script 'Generated: HL IHS LAB R01 SONORA QUEST IN-I' on AUG 14, 2006
 ;Part 11
 ;Copyright 2006 SAIC
EN S INI(1)=0 F  S INI(1)=$O(@INV@("OBX18",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX18",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX18",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX18",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX18' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("OBX19",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S INI(2)=0 F  S INI(2)=$O(@INV@("OBX19",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ..S (INX,X)=@INV@("OBX19",INI(1),INI(2))
 ..I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ..S @INV@("OBX19",INI(1),INI(2))=$G(X) I '$D(X) D ERROR^INHS("Variable 'OBX19' failed input transform in iteration #"_INI(1)_","_INI(2)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ..Q
 .Q
 K DXS
 ;IF $D(@INV@("NTE1"))
 I $D(@INV@("NTE1"))
 D:$T
 .S INI(1)=0 F  S INI(1)=$O(@INV@("NTE4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 ..S INI(2)=0 F  S INI(2)=$O(@INV@("NTE4",INI(1),INI(2))) Q:'INI(2)  S INI=INI(2) D
 ...S INI(3)=0 F  S INI(3)=$O(@INV@("NTE4",INI(1),INI(2),INI(3))) Q:'INI(3)  S INI=INI(3) D
 ....S (INX,X)=@INV@("NTE4",INI(1),INI(2),INI(3))
 ....I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 ....S @INV@("NTE4",INI(1),INI(2),INI(3))=$G(X) I '$D(X) D ERROR^INHS("Variable 'NTE4' failed input transform in iteration #"_INI(1)_","_INI(2)_","_INI(3)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 ....Q
 ...Q
 ..Q
 .K DXS
 .Q
 Q
F3 Q
F2 Q
F1 ;Entering REQUIRED section.
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH1"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL FIELD SEPARATOR")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH2"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL ENCODING CHARACTERS")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH9"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL MESSAGE TYPE")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH10"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL MESSAGE CONTROL ID")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH11"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL PROCESSING ID")
 I $D(@INV@("MSH1"))#2,$G(@INV@("MSH12"))="" S INREQERR=2 D KILL^INHVA1("MSH","HL VERSION ID")
 Q:$G(INSTERR) $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)  D MAIN^BHLRLABN
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 ;Entering END section.
 I $G(INSTERR) Q $S($G(INREQERR)>INSTERR:INREQERR,1:INSTERR)
 K @INV,INV,INDA,DIPA Q +$G(INREQERR)
