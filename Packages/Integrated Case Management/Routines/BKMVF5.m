BKMVF5 ;PRXM/HC/JGH - Menu Tree "Add Patient Data" functionality; Mar 21, 2005
 ;;2.1;HIV MANAGEMENT SYSTEM;;Feb 07, 2011
 QUIT
GETPAT() ;
 ; DFN,AGE,PNT,DOB, and SEX are being set here for another application.
 ; They should not be NEW'ed or KILL'ed.
 ; 
 N PIEN
 K DIC,DFN
 S DIC=90451
 S DIC(0)="AEMQZ"
 K DTOUT,DUOUT
 D ^DIC
 I $D(DTOUT)!$D(DUOUT)!($G(Y)<1) Q 0
 K DIC,DA,DD,DR,DINUM,D,DLAYGO,DIADD
 S DFN=$P(Y,"^",2),PIEN=+Y
 S PNT=$G(Y(0,0)),AGE=$G(AGE)
 S DOB=$$FMTE^XLFDT(DOB),SEX=$G(SEX)
 K X,Y
 QUIT 1
ADDPATNT ;
 S REGISTER=$$HIVIEN^BKMIXX3()
 I REGISTER="" Q
 ;
 ; The following line no longer applies
 ;I '$D(^BKM(90450,REGISTER,11,"B",DUZ)) Q
 I '$$GETPAT Q
 S HRN=$$HRN(DFN)
 S RCRDHDR=$$PAD^BKMIXX4("Patient: ",">"," ",16)_$$PAD^BKMIXX4(PNT,">"," ",34)_$$PAD^BKMIXX4("HRN: ",">"," ",16)_$$PAD^BKMIXX4(HRN,">"," ",34)
 D ADDDATA^BKMVA1(DFN)
 K HRN,RCRDHDR,REGISTER
 QUIT
HRN(DFN) ;
 NEW DA,IENS
 S DA(1)=DFN,DA=DUZ(2)
 S IENS=$$IENS^DILF(.DA)
 QUIT $$GET1^DIQ(9000001.41,IENS,.02,"E")
