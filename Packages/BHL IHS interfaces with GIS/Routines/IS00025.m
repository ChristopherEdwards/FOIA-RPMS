IS00025(UIF,INOA,INODA) ;Compiled from script 'Generated: HL IHS IZV04 V01VXQ IN-I' on SEP 05, 2011
 ;Part 1
 ;Copyright 2011 SAIC
EN S X="ERROR^IS00025",@^%ZOSF("TRAP")
 G START
ERROR ;
 S X="",@^%ZOSF("TRAP") X ^INTHOS(1,3) D ERROR^INHS($$GETERR^%ZTOS)
 Q 2
START ;Initialize variables
 K FIELD,MDESC,INDA,DIPA S (INAUDIT,INLAYGO)=0
 K INREQERR,INHERR,INHERCNT,INV D SETDT^UTDT S DUZ(0)="@",DUZ("AG")="^1",DTIME=1 S (LCT,GERR)=0,INMODE="I",INVS=$P(^INRHSITE(1,0),U,12),INV=$S(INVS<2:"INV",1:"^UTILITY(""INV"",$J)"),(MULT,INSTERR)=0
 S INHLDUZ=$O(^VA(200,"B","GIS,USER",0)),DUZ=$S($G(INHLDUZ):INHLDUZ,1:.5)
 S BHLMIEN="12441"
 I $G(^INTHL7M(BHLMIEN,4,1,0))]"" X $G(^INTHL7M(BHLMIEN,4,1,0))
 K INSETID
 S INSMIN=$S($P($G(^INRHSITE(1,0)),U,14):$P(^(0),U,14),1:2500)
 S (DELIM,INDELIM)=$$FIELD^INHUT(),(SUBDELIM,INSUBDEL)=$$COMP^INHUT(),INSUBCOM=$$SUBCOMP^INHUT()
 ;Entering DATA section.
 S X=$$GL^INHOU(UIF,LCT),Y(1)=$G(X) S X=4,X=$E(Y(1),X) S DELIM=X K DXS
 S X=$$GL^INHOU(UIF,LCT),Y(1)=$G(X) S X=5,X=$E(Y(1),X) S SUBDELIM=X K DXS S INDELIMS=DELIM_$P(Y(1),DELIM,2)
 N INDEFSEG
 S INDEFSEG("MSH",0)=0
 S INDEFSEG("QRD",0)=0
 S INDEFSEG("QRF",0)=0
 ;Start of GROUP
 F  S MATCH=0 D  Q:'MATCH
 .D:'INVS MC^INHS
 .D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=0
 .I 'MATCH,LINE?1"M"1"S"1"H".ANPC S DO=1,MATCH=1
 .E  S LCT=LCT-CNT,DO=0
 .S:DO @("@INV@(""MSH1"")")=$E($G(LINE),4)
 .S:DO @("@INV@(""MSH2"")")=$$PIECE^INHU(.LINE,DELIM,2)
 .S:DO @("@INV@(""MSH3"")")=$$PIECE^INHU(.LINE,DELIM,3)
 .S:DO @("@INV@(""MSH4"")")=$$PIECE^INHU(.LINE,DELIM,4)
 .S:DO @("@INV@(""MSH5"")")=$$PIECE^INHU(.LINE,DELIM,5)
 .S:DO @("@INV@(""MSH6"")")=$$PIECE^INHU(.LINE,DELIM,6)
 .S:DO @("@INV@(""MSH7"")")=$$PIECE^INHU(.LINE,DELIM,7)
 .S:DO @("@INV@(""MSH8"")")=$$PIECE^INHU(.LINE,DELIM,8)
 .S:DO @("@INV@(""MSH9"")")=$$PIECE^INHU(.LINE,DELIM,9)
 .S:DO @("@INV@(""MSH10"")")=$$PIECE^INHU(.LINE,DELIM,10)
 .S:DO @("@INV@(""MSH11"")")=$$PIECE^INHU(.LINE,DELIM,11)
 .S:DO @("@INV@(""MSH12"")")=$$PIECE^INHU(.LINE,DELIM,12)
 .S:DO @("@INV@(""MSH13"")")=$$PIECE^INHU(.LINE,DELIM,13)
 .S:DO @("@INV@(""MSH14"")")=$$PIECE^INHU(.LINE,DELIM,14)
 .S:DO @("@INV@(""MSH15"")")=$$PIECE^INHU(.LINE,DELIM,15)
 .S:DO @("@INV@(""MSH16"")")=$$PIECE^INHU(.LINE,DELIM,16)
 .S:DO @("@INV@(""MSH17"")")=$$PIECE^INHU(.LINE,DELIM,17)
 .Q:MATCH
 .D:'INVS MC^INHS
 .D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=0
 .I 'MATCH,LINE?1"Q"1"R"1"D".ANPC S DO=1,MATCH=1
 .E  S LCT=LCT-CNT,DO=0
 .S:DO @("@INV@(""QRD1"")")=$$PIECE^INHU(.LINE,DELIM,2)
 .S:DO @("@INV@(""QRD2"")")=$$PIECE^INHU(.LINE,DELIM,3)
 .S:DO @("@INV@(""QRD3"")")=$$PIECE^INHU(.LINE,DELIM,4)
 .S:DO @("@INV@(""QRD4"")")=$$PIECE^INHU(.LINE,DELIM,5)
 .S:DO @("@INV@(""QRD7"")")=$$PIECE^INHU(.LINE,DELIM,8)
 .S:DO @("@INV@(""QRD8"")")=$$PIECE^INHU(.LINE,DELIM,9)
 .S:DO @("@INV@(""QRD9"")")=$$PIECE^INHU(.LINE,DELIM,10)
 .S:DO @("@INV@(""QRD12"")")=$$PIECE^INHU(.LINE,DELIM,13)
 .Q:MATCH
 .D:'INVS MC^INHS
 .D GET^INHOU(UIF,0) S LINE=$G(LINE),DO=0
 .I 'MATCH,LINE?1"Q"1"R"1"F".ANPC S DO=1,MATCH=1
 .E  S LCT=LCT-CNT,DO=0
 .S:DO @("@INV@(""QRF1"")")=$$PIECE^INHU(.LINE,DELIM,2)
 .S:DO @("@INV@(""QRF5"")")=$$PIECE^INHU(.LINE,DELIM,6)
 .S:DO @("@INV@(""QRF6"")")=$$PIECE^INHU(.LINE,DELIM,7)
 .S:DO @("@INV@(""QRF7"")")=$$PIECE^INHU(.LINE,DELIM,8)
 .S:DO @("@INV@(""QRF8"")")=$$PIECE^INHU(.LINE,DELIM,9)
 .S:DO @("@INV@(""QRF9"")")=$$PIECE^INHU(.LINE,DELIM,10)
 .Q:MATCH
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
9 .D EN^IS00025A
 G D1^IS00025A
