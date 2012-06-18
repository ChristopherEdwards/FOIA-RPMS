BHLUP ; cmi/anchorage/maw - BHL Update Specific Fields;
 ;;3.01;BHL IHS Interfaces with GIS;**11,13,14**;AUG 01, 2004
 ;
 ;
 ;
 ;this routine will always change based on the need of updating fields in GIS
 ;
FLDS ;EP - update various fields in this subroutine
 D DOB
 D EMPH
 ;D RAD
 Q
 ;
DOB ;-- change the DOB to reflect a new output transform
 N BHLDA
 S BHLDA=$O(^INTHL7F("B","HL IHS PID DOB (PID-7)",0))
 Q:'BHLDA
 S DIE="^INTHL7F(",DA=BHLDA
 S DR=".02///STRING;3///"_"""OUTPUT TRANSFORM"""
 D ^DIE
 K DIE,DR,DA
 S ^INTHL7F(BHLDA,5)="S X=$P($G(^DPT(INDA,0)),U,3),%DT=""X"" D ^%DT S X=$$DATE^INHUT(Y)"
 Q
 ;
EMPH ;-- change the employer phone
 N BHLDA
 S BHLDA=$O(^INTHL7F("B","HL IHS GT1 EMP PH (GT1-18)",0))
 Q:'BHLDA
 S ^INTHL7F(BHLDA,5)="S X="",BHLEMPHN=$$VALI^XBDIQ1(9000003.1,INDA,.16) I BHLEMPHN'="" S X=$$VAL^XBDIQ1(9999999.75,BHLEMPHN,.06)"
 Q
 ;
RAD ;-- disable new RAD transaction types if not being used
 N BHLPC,BHLDLS
 S BHLPC=$O(^INTHPC("B","HL IHS GE PACS TRANSMITTER",0))
 I 'BHLPC D RADDIS Q
 S BHLDLS=$P($P($G(^INTHPC(BHLPC,0)),U,5),".")
 I BHLDLS<3040101 D RADDIS Q
 Q
 ;
RADDIS ;-- disable the tt's
 N BHLTT
 S BHLTT=$O(^INRHT("B","HL IHS O01 GE OUT PARENT",0))
 I BHLTT D
 . S DIE="^INRHT(",DA=BHLTT,DR=".05///0" D ^DIE
 . K DIE,DR
 S BHLTT=$O(^INRHT("B","HL IHS R01 GE OUT PARENT",0))
 I BHLTT D
 . S DIE="^INRHT(",DA=BHLTT,DR=".05///0" D ^DIE
 . K DIE,DR
 Q
 ;
