PSUPR3 ;BIR/PDW - EXTRACTION FROM FILE 58.81 ;12 AUG 1999
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**1,8,16,19**;Oct 15, 1998
 ;DBIAs
 ; Reference to file #58.81 supported by DBIA 2520
 ; Reference to file #50    supported by DBIA 221
 ; Reference to file #51.5  supported by DBIA 1931
 ; Reference to file #58.8  supported by DBIA 2519
 ; Reference to file #59    supported by DBIA 2510
 ; Reference to file #42    supported by DBIA 2440
 ; Reference to file #40.8  supported by DBIA 2438
 ; Reference to file #59.5  supported by DBIA 2499
 ;
EN ;EP from PSUPR0
 S PSUEDT=PSUEDT\1+.24
 ;   setup ^XTMP node
 S:'$D(PSUPRJOB) PSUPRJOB=$J
 S:'$D(PSUPRSUB) PSUPRSUB="PSUPR_"_PSUPRJOB
 I '$D(^XTMP(PSUPRSUB)) D
 . S ^XTMP(PSUPRSUB,0)=""
 . S X1=DT,X2=6 D C^%DTC
 . S ^XTMP(PSUPRSUB,0)=X_"^"_DT_"^"_" PBMS Procurement Extraction3"
SCANDT ;   3.2.6.31  scan Transaction date time
 S PSUDT=PSUSDT
 ;  going after ^PSD(58.81,"AF",PSUDT,PSULOC,PSUTYP,PSUTRDA)
 ;
 F  S PSUDT=$O(^PSD(58.81,"AF",PSUDT)) Q:PSUDT'>0  Q:PSUDT>PSUEDT  D LOC
 Q
 ;
LOC ;EP scan thru locations
 ;
 S PSULOC="" F  S PSULOC=$O(^PSD(58.81,"AF",PSUDT,PSULOC)) Q:PSULOC=""  D TYPE
 Q
 ;
TYPE ;EP Scan Thru Types
 ;
 S PSUTYP="" F  S PSUTYP=$O(^PSD(58.81,"AF",PSUDT,PSULOC,PSUTYP)) Q:PSUTYP=""  D TRAN
 Q
 ;
TRAN ;EP Scan Thru Transactions
 ;
 S PSUTRDA=0 F  S PSUTRDA=$O(^PSD(58.81,"AF",PSUDT,PSULOC,PSUTYP,PSUTRDA)) Q:PSUTRDA'>0  D TRANDA
 Q
 ;
TRANDA ;EP work a transaction
 ;
 N PSUTR
 D GETS^PSUTL(58.81,PSUTRDA,".01;1;2;3;4;5;8;12;71;106","PSUTR","I")
 D MOVEI^PSUTL("PSUTR")
 S PSUDTDA=PSUTR(3)
 ; 3.2.6.3.2-3.4
 Q:(PSUTR(1)'=1)
 I $L(PSUTR(8)),'$L($G(PSUTR(71))) Q
 Q:$L(PSUTR(106))
 ;
 ;     setup file 50 fields
 S PSUDRDA=PSUTR(4)
 N PSUDRUG
 D GETS^PSUTL(50,PSUDRDA,".01;2;12;13;14.5;15;20;21;22;25;31","PSUDRUG","I")
 D MOVEI^PSUTL("PSUDRUG")
 ;
 ;    further process file 50 fields
 S:'$L(PSUDRUG(.01)) PSUDRUG(.01)="Unknown Generic Name" ;    Generic Name
 S:'$L(PSUDRUG(21)) PSUDRUG(21)="Unknown VA Product Name" ;   VA Product Name
 S:'$L(PSUDRUG(31)) PSUDRUG(31)="No NDC" ;                   NDC
 S PSUDRUG(12)=$$VALI^PSUTL(51.5,PSUDRUG(12),.01) ;            Order Unit
 ;
 ;    setup division  3.2.3.6.3.5
 N PSULOC
 S PSULOC=PSUTR(2)
 ;
 ;   Get division from file 58.8
 S PSUDIV="",PSUDIVI="H"
 K PSULDIV
 D GETS^PSUTL(58.8,PSULOC,".01;2;20","PSULDIV","I")
 D MOVEI^PSUTL("PSULDIV")
 ;
 ; if outpatient follow pointers
 I PSULDIV(20) D  G CONT
 . S X=$$VALI^PSUTL(59,PSULDIV(20),.06)
 . I X S PSUDIV=X,PSUDIVI="" Q
 . S PSUDIV=PSUSNDR
 ;
 ; if inpatient setup and call div^psuar1 to process AOU
 I PSULDIV(2) D  G CONT
 . S PSUARSUB=PSUPRSUB
 . S PSUDIV=$$DIV^PSUAR1(PSULDIV(2),PSUDTDA)
 . I PSUDIV="NULL" S PSUDIV=PSUSNDR Q
 . S PSUDIVI=""
 ;
 ; check to see if ward has multiples
 K PSUW
 D GETM^PSUTL(58.8,PSULOC,"21*^.01","PSUW","I")
 D MOVEMI^PSUTL("PSUW")
 S DA=0 I $D(PSUW) S DA=$O(PSUW(0))
 I DA D  G CONT
 . S X=$$VALI^PSUTL(42,PSUW(DA,.01),.015)
 . S PSUDIV=$$VALI^PSUTL(40.8,X,1)
 . I PSUDIV S PSUDIVI="" Q
 . S PSUDIV=PSUSNDR
 ;
 ; check to see if IV has multiples
 K PSUIV
 D GETM^PSUTL(58.8,PSULOC,"31*^.01","PSUIV","I")
 D MOVEMI^PSUTL("PSUIV")
 S DA=0 I $D(PSUIV) S DA=$O(PSUIV(0))
 I DA D  G CONT
 . S X=$$VALI^PSUTL(59.5,PSUIV(DA,.01),.02)
 . S X=$$VALI^PSUTL(40.8,X,1)
 . I X S PSUDIVI="" Q
 . S PSUDIV=PSUSNDR
 ;
 ; if none of the above could match set default
 S PSUDIV=PSUSNDR,PSUDIVI="H"
 ; 
 ; continue processing
CONT ;
 I $L(PSUDIV) S PSUDIVI=""
 E  S PSUDIV=PSUSNDR
 ;
 ;    Assemble Record
 S PSUREC=$$RECORD()
 ;    Store Record
 S PSULC=+$O(^XTMP(PSUPRSUB,"RECORDS",PSUDIV,""),-1)
 S PSULC=PSULC+1
 S ^XTMP(PSUPRSUB,"RECORDS",PSUDIV,PSULC)=PSUREC
 Q
 ;
 ;    assemble record
RECORD() ;EP Assemble record for storage
 ; 3.2.11.38
 N PSUR
 S PSUR(2)=PSUDIV
 S PSUR(3)=PSUDIVI
 S PSUR(4)=PSUDTDA\1
 S PSUR(5)=PSUDRUG(21)
 S PSUR(6)=PSUDRUG(2)
 S PSUR(7)=PSUDRUG(.01)
 S PSUR(9)=PSUDRUG(31)
 S PSUR(12)=PSUDRUG(14.5)
 S PSUR(13)=$$VAL^PSUTL(50,PSUDRDA,12)
 S PSUR(16)=PSUDRUG(15)
 S PSUR(17)=PSUTR(5)
 S PSUR(18)=PSUDRUG(13)
 I PSUDRUG(15) S PSUR(360)=PSUDRUG(13)*(PSUTR(5)/PSUDRUG(15))
 E  S PSUR(360)=""
 S PSUR(19)=$J(PSUR(360),12,2)
 K PSUR(360)
 S PSUR(20)=PSUTR(12)
 S PSUR(21)=PSUTR(71)
 S PSUR(22)=""
 S I=0 F  S I=$O(PSUR(I)) Q:I'>0  S PSUR(I)=$TR(PSUR(I),"^","'")
 S I=0 F  S I=$O(PSUR(I)) Q:I'>0  S $P(PSUR,"^",I)=PSUR(I)
 S PSUR=PSUR_"^"
 Q PSUR
