ABMDE0B ; IHS/ASDST/DMJ - Claim Summary-Part 2 ; 
 ;;2.6;IHS 3P BILLING SYSTEM;;NOV 12, 2009
 ;
 ; *********************************************************************
IDEN ;EP - Entry Point from ABMDE0A for Iden display
 S ABMZ(1)="W !,""_______ Pg-1 (Claim Identifiers) ________"""
 S ABMZ(2)="W !,""Location..: "",ABM(1),?40,""|"""
 S ABMZ(3)="W !,""Clinic....: "",ABM(2),?40,""|"""
 S ABMZ(4)="W !,""Visit Type: "",ABM(3),?40,""|"""
 S ABMZ(5)="W !,""Bill From: "",ABM(4),"" Thru: "",ABM(5),?40,""|"""
 Q
 ;
 ; *********************************************************************
INS ;EP - Entry Point from ABMDE0A for Insurer display
 S ABMZ(ABM("C"))="W !,""________ Pg-2 (Billing Entity) _________|"""
 D CNT
 I '$D(ABM("I1")) D
 . S ABM("I1")="NO COVERAGE FOUND"
 .S ABM("I1S")=""
 S ABMZ(ABM("C"))="W !,ABM(""I1""),?30,ABM(""I1S""),?40,""|"""
 D CNT
 ;
I2 ;
 I $D(ABM("I2")),ABM("I2")]"" D
 . S ABMZ(ABM("C"))="W !,ABM(""I2""),?30,ABM(""I2S""),?40,""|"""
 . D CNT
 ;
I3 ;
 I $D(ABM("I3")),ABM("I3")]"" D
 . S ABMZ(ABM("C"))="W !,ABM(""I3""),?30,ABM(""I3S""),?40,""|"""
 . D CNT
 Q
 ;
 ; *********************************************************************
QUES ;EP - Entry Point from ABMDE0A for questions display
 S ABMZ(ABM("C"))="W !,""___________ Pg-3 (Questions) ___________|"""
 D CNT
 S ABMZ(ABM("C"))="W !,""Release Info: "",ABM(""RELS""),?20,""Assign Benef: "",ABM(""ASGN""),?40,""|"""
 D CNT
 Q
 ;
 ; *********************************************************************
CNT ;
 S ABM("C")=ABM("C")+1
 Q
