IS00003I ;Compiled from script 'Generated: X1 IHS 835 IN-I' on DEC 03, 2002
 ;Part 10
 ;Copyright 2002 SAIC
EN S (INX,X)=@INV@("PER2",INI(1))
 I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 S @INV@("PER2",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER2' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 Q
b2 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("PER3",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("PER3",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PER3",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER3' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("PER4",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("PER4",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PER4",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER4' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("PER5",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("PER5",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PER5",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER5' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("PER6",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("PER6",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PER6",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER6' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("PER7",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("PER7",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PER7",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER7' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 S INI(1)=0 F  S INI(1)=$O(@INV@("PER8",INI(1))) Q:'INI(1)  S INI=INI(1) D
 .S (INX,X)=@INV@("PER8",INI(1))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("PER8",INI(1))=$G(X) I '$D(X) D ERROR^INHS("Variable 'PER8' failed input transform in iteration #"_INI(1)_". Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .Q
 K DXS
 Q
b1 ;IF $D(@INV@("N11"))
 I $D(@INV@("N11"))
 D:$T
 .S (INX,X)=$G(@INV@("N11"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N11")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N11' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N12"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N12")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N12' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N13"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N13")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N13' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N14"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N14")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N14' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("N31"))
 I $D(@INV@("N31"))
 D:$T
 .S (INX,X)=$G(@INV@("N31"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N31")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N31' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .S (INX,X)=$G(@INV@("N32"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N32")=$G(X)
 .I '$D(X) D ERROR^INHS("Variable 'N32' failed input transform. Processing continues.",0),ERROR^INHS("  Value = '"_INX_"'",0)
 .K DXS
 .Q
 ;IF $D(@INV@("N41"))
 I $D(@INV@("N41"))
 D:$T
 .S (INX,X)=$G(@INV@("N41"))
 .I $P($G(INTHL7F2),U,4) S X=$$SUBESC^INHUT7(X,INDELIMS,"I")
 .S @INV@("N41")=$G(X)
9 .D EN^IS00003J
 G e1^IS00003J
