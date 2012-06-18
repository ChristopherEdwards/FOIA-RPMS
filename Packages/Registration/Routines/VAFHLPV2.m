VAFHLPV2 ;ALB/GRR - HL7 PV2 SEGMENT BUILDER ;06/08/99
 ;;5.3;Registration;**190**;Aug 13, 1993
 ;
 ;This routine will build an HL7 PV2 segment for an inpatient.
 ;
EN(DFN,VAFHMIEN,VAFSTR) ;Entry point of routine
 ;DFN - Patient Internal Entry Number
 ;VAFHMIEN - Patient Movement Internal Entry Number
 ;VAFSTR - Sequence numbers to include in message
 ;
 N VAFHLREC,VAFHA,VAFHSUB S VAFHSUB="" ;Initialize variables
 S $P(VAFHLREC,HL("FS"))="PV2" ;Set segment type to PV2
 S VAFHMIEN=$$GETAMOV^DGRUUTL(DFN) I VAFHMIEN="" G QUITPV2 ;If movement ien not passed, get admission movement and quit if none
 I VAFSTR[",3," D
 .S VAFHA=$$GET1^DIQ(405,VAFHMIEN,".11","I") ;retrieve 'Admitted for SC Condition' field
 .I VAFHA=1 D  ;If admitted for SC condition do following
 ..S $P(VAFHSUB,$E(HL("ECH")),4)="SC"
 ..S $P(VAFHSUB,$E(HL("ECH")),5)="ADMITTED FOR SC CONDITION"
 ..S $P(VAFHSUB,$E(HL("ECH")),6)="VA0039"
 .I VAFHA'=1 D  ;If not admitted for SC condition do following
 ..S $P(VAFHSUB,$E(HL("ECH")),4)="NSC"
 ..S $P(VAFHSUB,$E(HL("ECH")),5)="NOT ADMITTED FOR SC CONDITION"
 ..S $P(VAFHSUB,$E(HL("ECH")),6)="VA0039"
 .S $P(VAFHLREC,HL("FS"),4)=VAFHSUB
QUITPV2 Q VAFHLREC
