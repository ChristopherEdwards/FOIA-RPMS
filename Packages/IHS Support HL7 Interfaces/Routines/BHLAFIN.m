BHLAFIN ; cmi/flag/maw - BHL Auto Create Inbound HL7 Fields ;
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;;
 ;
 ;this routine will auto create inbound HL7 fields and segments for
 ;GIS based upon the listed version of HL7.
 ;
MAIN ;-- this is the main routine driver
 D SEGARRY
 D ASK
 Q:'$G(@BHLVER@("MSH"))
 D FLDS
 Q
 ;
X12 ;-- populate for X12
 Q
 ;
ASK ;-- ask which version of the HL7 standard
 S DIR(0)="S^24:2.4;23:2.3"
 S DIR("A")="Build Fields for which version of HL7 "
 D ^DIR
 Q:$D(DIRUT)
 S BHLVER=+Y
 S BHLVER="VER"_BHLVER
 I '$G(@BHLVER@("MSH")) W !,"Version not supported." Q
 K DIR
 S DIR(0)="F^1:30",DIR("A")="Use which Prefix for Fields "
 D ^DIR
 Q:$D(DIRUT)
 S BHLPRE=Y
 S BHLPRE=BHLPRE
 Q
 ;
FLDS ;-- create the fields here for each segment
 S BHLDA=0 F  S BHLDA=$O(@BHLVER@(BHLDA)) Q:BHLDA=""  D
 . S BHLFLDS=$G(@BHLVER@(BHLDA))
 . K DD,DO,DIC,Y
 . S DIC="^INTHL7S(",DIC(0)="L",X=BHLPRE_" "_BHLDA_" IN"
 . S DIC("DR")=".02///"_BHLDA
 . D FILE^DICN
 . S BHLSEG=+Y
 . F BHLI=1:1:BHLFLDS D
 .. K DD,DO,Y,DIC
 .. S DIC="^INTHL7F(",DIC(0)="L",X=BHLPRE_" "_BHLDA_"-"_BHLI_" IN"
 .. S DIC("DR")=".02///STRING;.03///999"
 .. D FILE^DICN
 .. S BHLFLDE=+Y
 .. K DD,DO,Y,DIC
 .. D SEGADD
 Q
 ;
SEGADD ;-- add the field to the segment
 S DA(1)=BHLSEG
 S DIC="^INTHL7S("_BHLSEG_",1,",DIC(0)="L"
 S DIC("P")=$P(^DD(4010,1,0),"^",2)
 D ^DIC
 S BHLSEGE=+Y
 K DIE,DR
 S DIE=DIC,DA=+Y,DR=".02///"_BHLI
 D ^DIE
 K DIC,DIE,DR
 Q
 ;
SEGARRY ;-- this is the list of segments
 S VER24("MSH")=21
 S VER24("EVN")=7
 S VER24("PID")=38
 S VER23("PID")=38
 S VER24("PD1")=21
 S VER24("NK1")=37
 S VER24("PV1")=52
 S VER23("PV1")=52
 S VER24("DG1")=19
 S VER24("PR1")=18
 S VER24("GT1")=55
 S VER24("IN1")=49
 S VER24("IN2")=72
 S VER24("ZP2")=33
 S VER24("MRG")=7
 S VER23("ORC")=25
 S VER23("OBR")=47
 S VER23("OBX")=19
 Q
 ;
XARY837 ;-- x12 array
 S X1000A("REF")=2
 S X1000A("NM1")=9
 S X1000A("N2")=1
 S X1000A("PER")=8
 S X1000B("NM1")=9
 S X1000B("N2")=1
 S X2000A("HL")=4
 S X2000A("PRV")=3
 S X2000A("CUR")=2
 S X2010AA("NM1")=9
 S X2010AA("N2")=1
 S X2010AA("N3")=2
 S X2010AA("N4")=4
 S X2010AA("REF")=2
 S X2010AA("REFCC")=2
 S X2010AA("PER")=8
 S X2010AB("NM1")=9
 S X2010AB("N2")=1
 S X2010AB("N3")=2
 S X2010AB("N4")=4
 S X2010AB("REF")=2
 S X2000B("HL")=4
 S X2000B("SBR")=9
 S X2000B("PAT")=9
 S X2010BA("NM1")=4
 S X2010BA("N2")=1
 S X2010BA("N3")=2
 S X2010BA("N4")=4
 S X2010BA("DMG")=3
 S X2010BA("REF")=2
 S X2010BA("REFPC")=2
 S X2010BB("NM1")=4
 S X2010BB("N2")=1
 S X2010BB("N3")=2
 S X2010BB("N4")=4
 S X2010BB("REF")=2
 S X2010BC("NM1")=4
 S X2010BC("N2")=1
 S X2010BC("N3")=2
 S X2010BC("N4")=4
 S X2010BD("NM1")=4
 S X2010BD("N2")=1
 S X2010BD("REF")=2
 Q
 ;
