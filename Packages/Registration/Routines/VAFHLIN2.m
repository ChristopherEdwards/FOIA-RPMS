VAFHLIN2 ;ALB/GRR - HL7 IN2 SEGMENT BUILDER ;06/08/99
 ;;5.3;Registration;**190,421**;Aug 13, 1993
 ;
 ;This routine will build an HL7 IN2 segment for an inpatient.
 ;
EN(DFN,VAFHMIEN,VAFSTR) ;Entry point of routine
 ;DFN - Patient Internal Entry Number
 ;VAFHMIEN - Patient Movement Internal Entry Number
 ;VAFSTR - Sequence numbers to be included
 ;
 N VAFINS,VAFHLREC,VAFHA,VAFHSUB,VAFHADD,VAFHLOC,VAFHNAME S VAFHSUB=""
 D ALL^IBCNS1(DFN,"VAFINS",2) ;GET INSURANCE DATA FOR PATIENT
 S $P(VAFHLREC,HL("FS"))="IN2" ;Set segment type to IN2
 I VAFSTR[",2," S $P(VAFHLREC,HL("FS"),3)=$$GET1^DIQ(2,DFN,".09","I") ;Patient SSN
 I VAFSTR[",3," S VAFHNAME=$P($G(VAFINS(2,2)),"^",9),$P(VAFHLREC,HL("FS"),4)=$E(HL("ECH"))_VAFHNAME
 I VAFSTR[",6," S $P(VAFHLREC,HL("FS"),7)=$$MEDICARE^DGRUUTL(DFN) ;Set to Medicare Number or null
 I VAFSTR[",8," S $P(VAFHLREC,HL("FS"),9)=$$MEDICAID^DGRUUTL(DFN) ;Set to Medicaid Number or null; p-421
QUITIN2 Q VAFHLREC
