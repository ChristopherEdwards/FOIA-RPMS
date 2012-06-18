PSUPR2 ;BIR/PDW - Procurement extract from file 58.811 ;20 AUG 1999
 ;;3.0;PHARMACY BENEFITS MANAGEMENT;**1,8,17,19**;Oct 15, 1998
 ;DBIAs
 ; Reference to file #58.811 supported by DBIA 2521
 ; Reference to file #51.5   supported by DBIA 1931
 ; Reference to file #50     supported by DBIA 221
 ; Reference to file #58.8   supported by DBIA 2519
 ; Reference to file #42     supported by DBIA 2440
 ; Reference to file #40.8   supported by DBIA 2438
 ; Reference to file #59.5   supported by DBIA 2499
 ; Reference to file #59     supported by DBIA 2510
 ;
EN ;
 S PSUEDT=PSUEDT\1+.24
 S:'$D(PSUPRJOB) PSUPRJOB=$J
 S:'$D(PSUPRSUB) PSUPRSUB="PSUPR_"_$J
 I '$D(^XTMP(PSUPRSUB)) D
 . S ^XTMP(PSUPRSUB,"RECORDS",0)=""
 . S X1=DT,X2=6 D C^%DTC
 . S ^XTMP(PSUPRSUB,0)=X_"^"_DT_"^ PBMS Procurement Extraction"
 ;
 ;   check for Drug Accountability
 S X=$$VERSION^XPDUTL("DRUG ACCOUNTABILITY")
 I 'X Q  ; not installed
 ;
 S X1=PSUSDT,X2=-45 ;backup by 45 days per revision
 D C^%DTC
 S PSUDT=X
 ;    loop thru invoice date field xref
 F  S PSUDT=$O(^PSD(58.811,"ADATE",PSUDT)) Q:PSUDT>PSUEDT  Q:PSUDT'>0  D
 .  S PSUORDA=0 F  S PSUORDA=$O(^PSD(58.811,"ADATE",PSUDT,PSUORDA)) Q:PSUORDA'>0  D
 .. S PSUINVDA=0 F  S PSUINVDA=$O(^PSD(58.811,"ADATE",PSUDT,PSUORDA,PSUINVDA)) Q:PSUINVDA'>0  D INVOICE
 Q
 ;
INVOICE ;EP process an invoice within an order
 N PSUSTAT
 S PSUSTAT=$$VALI^PSUTL(58.8112,"PSUORDA,PSUINVDA",2)
 I PSUSTAT'="C" Q  ;     3.2.6.1
 N PSUORD
 D GETS^PSUTL(58.811,PSUORDA,".01;1","PSUORD")
 ;
 N PSUINV
 D GETS^PSUTL(58.8112,"PSUORDA,PSUINVDA",".01;1;2;3;4;7;13","PSUINV","I")
 D MOVEI^PSUTL("PSUINV")
 ;
 S PSUDIV=$$DIVISION()
 I $L(PSUDIV) S PSUDIVI=""
 E  S PSUDIV=PSUSNDR,PSUDIVI="H"
 K ^TMP($J,"PSUMIT") ;**3**   array for multiple items
 D GETM^PSUTL(58.8112,"PSUORDA,PSUINVDA","5*^1;2;3;4;7;13;14;15","^TMP($J,""PSUMIT"")","I")
 I '$D(^TMP($J,"PSUMIT")) Q  ;**3**
 D MOVEMI^PSUTL("^TMP($J,""PSUMIT"")")
 ;
 S PSUITDA=0 F  S PSUITDA=$O(^TMP($J,"PSUMIT",PSUITDA)) Q:PSUITDA'>0  D ITEM
 Q
ITEM ;EP  process one item within the invoice
 N PSUIT ;  array for one item
 M PSUIT=^TMP($J,"PSUMIT",PSUITDA)
 ;
 I (PSUIT(7)<PSUSDT) Q
 I (PSUIT(7)>PSUEDT) Q
 ;     pull adjustments   3.2.6.2.8
 N PSUMADJ
 D GETM^PSUTL(58.81125,"PSUORDA,PSUINVDA,PSUITDA","9*^.01;5","PSUMADJ","I")
 I $D(PSUMADJ) D MOVEMI^PSUTL("PSUMADJ")
 ;
 ;
 ;      Review/Process Adjustments
 I $D(PSUMADJ) S PSUADJDA=0 F  S PSUADJDA=$O(PSUMADJ(PSUADJDA)) Q:PSUADJDA'>0  D
 . N PSUADJ
 . M PSUADJ=PSUMADJ(PSUADJDA)
 . ;
 . I PSUADJ(.01)="D" S PSUIT(1)=PSUADJ(5)  ; 3.2.6.2.8    Drug or Supply 
 . I PSUADJ(.01)="O" S PSUIT(3)=PSUADJ(5)  ; 3.2.6.2.11   OrderUnits
 . I PSUADJ(.01)="P" S PSUIT(4)=PSUADJ(5)  ; 3.2.6.2.12   Price
 . I PSUADJ(.01)="Q" S PSUIT(2)=PSUIT(2)+PSUADJ(5) ; 3.2.6.2.10 Quantity
 . Q
 ;
 I 'PSUIT(2) Q  ; per Lina 10/7/98  if qty = 0 don't send record
 ;    work on the order unit PSUIT(3)
 I '$D(PSUADJ),+PSUIT(3)=0 S PSUIT(3)="" ; per Lina
 I PSUIT(3) S PSUIT(3)=$$VAL^PSUTL(51.5,PSUIT(3),.01) ; 3.2.6.2.11
 ;
 ;    further process item fields  3.2.6.2.9 +
 ;
 ;    look for/ construct Dispense Units per Order Unit
 ;    Store in PSUIT(9999)  3.2.6.2.13
 ;  Get Related Drug Fields 3.2.6.2.9
 ;
 N PSUDRUG
 S PSUDRDA=0
 ;  if PSUIT(1) is a supply item the following will not be computed
 I PSUIT(1)=+PSUIT(1) D
 . S PSUDRDA=PSUIT(1)
 . S PSUARJOB=PSUPRJOB,PSUARSUB="PSUAR_"_PSUARJOB
 . D GETS^PSUTL(50,PSUDRDA,".01;2;13;25;14.5;21;31","PSUDRUG","I")
 . D MOVEI^PSUTL("PSUDRUG")
 . S PSUIT(1)=PSUDRUG(.01)                          ; Generic Name
 . S:PSUDRUG(21)="" PSUDRUG(21)="Unknown VA Product Name"
 . S:PSUDRUG(31)="" PSUDRUG(31)="No NDC"
 ;   further process fields
 ;   fill in drug fields for supply items
 I 'PSUDRDA D
 . S PSUDRUG(.01)="Unknown Generic Name"
 . S PSUDRUG(21)="Unknown VA Product Name"
 . S PSUDRUG(31)="No NDC"
 ;
 ; NDC
 I PSUIT(13)="" S PSUIT(13)=$G(PSUDRUG(31)) S:PSUIT(13)="" PSUIT(13)="No NDC"
 ;
 ;      dispense units per order unit 3.2.6.2.13
 ;
 S PSUIT(9999)=0
 I $L(PSUIT(13)),$G(PSUDRDA) D
 . S X=$O(^PSDRUG("C",PSUIT(13),PSUDRDA,""))
 . I X S PSUIT(9999)=$$VALI^PSUTL(50.1,"PSUDRDA,X","403")
 ;
 I '$D(PSUADJ),'PSUIT(9999) S PSUIT(9999)="" ; per Lina
 ;
 ;   Construct record and store into ^XTMP(PSUPRSUB,"RECORDS",PSUDIV,LC)
 S PSUR=$$RECORD()
 ;   Store Records by Division
 S PSULC=+$O(^XTMP(PSUPRSUB,"RECORDS",PSUDIV,""),-1)
 S PSULC=PSULC+1
 S ^XTMP(PSUPRSUB,"RECORDS",PSUDIV,PSULC)=PSUR
 Q
 ;
RECORD() ;EP Assemble record
 N PSUR
 S PSUR(2)=$G(PSUDIV)
 S PSUR(3)=$G(PSUDIVI)
 S PSUR(4)=PSUIT(7)\1      ; 3.2.6.2.2
 S PSUR(5)=$G(PSUDRUG(21)) ; 3.2.6.2.9
 S PSUR(6)=$G(PSUDRUG(2))  ;  ""
 S PSUR(7)=PSUIT(1)     ; 3.2.6.2.8
5 S PSUR(9)=PSUIT(13)    ; 3.2.6.2.9
 S PSUR(10)=PSUIT(14)    ;    ""
 S PSUR(11)=PSUIT(15)    ;    ""
 S PSUR(12)=$G(PSUDRUG(14.5)) ; ""
 S PSUR(13)=PSUIT(3)     ; 3.2.6.2.11
 S PSUR(16)=PSUIT(9999)  ; 3.2.6.2.13
 S PSUR(17)=PSUIT(2)     ; 3.2.6.2.10
 S PSUR(18)=PSUIT(4)     ; 3.2.6.2.12
 S PSUR(19)=PSUR(17)*PSUR(18) ; 3.2.6.2.14
 S PSUR(20)=PSUORD(1)    ; 3.2.6.2.5
 S PSUR(21)=PSUINV(.01)  ; 3.2.6.2.6
 S PSUR(22)=""
 S PSUR=""
 S I=0 F  S I=$O(PSUR(I)) Q:I'>0  S PSUR(I)=$TR(PSUR(I),"^","'")
 S I=0 F  S I=$O(PSUR(I)) Q:I'>0  S $P(PSUR,U,I)=PSUR(I)
 S PSUR=PSUR_U
 Q PSUR
 ;
DIVISION() ;EP Process to get Division
 ;   3.2.6.2.3
 N PSULOC,PSUDIV
 S PSULOC=PSUINV(4)
 S PSUDIV=$$PSLOCDIV(PSULOC,PSUDT)
 Q PSUDIV
 ;
PSLOCDIV(PSULOC,PSUDT) ;EP  Get division from 58.8
 S PSULOC(.01)=$$VAL^PSUTL(58.8,PSULOC,.01)
 S PSULOC(1)=$$VALI^PSUTL(58.8,PSULOC,1)
 ;
 ;  Process for Division according to 3.2.6.2.3
 ;   uses PSULOC,PSUDT
 S PSUDIV=""
 ;    WRD-ward INP-inpatient IV-iv OUT-outpatient
 I PSULOC(.01)["INPATIENT",PSULOC(1)="P" S PSUDIV=$$WRD() S:'$L(PSUDIV) PSUDIV=$$INP()
 I $L(PSUDIV) Q PSUDIV
 I PSULOC(.01)["OUTPATIENT",PSULOC(1)="P" S PSUDIV=$$IV() S:'$L(PSUDIV) PSUDIV=$$OUT()
 I $L(PSUDIV) Q PSUDIV
 I PSULOC(.01)["COMBINED (IP/OP)",PSULOC(1)="P" D
 . S PSUDIV=$$OUT()
 . I '$L(PSUDIV) S PSUDIV=$$WRD()
 . I '$L(PSUDIV) S PSUDIV=$$IV()
 . I '$L(PSUDIV) S PSUDIV=$$INP()
 I $L(PSUDIV) Q PSUDIV
 ;
 I PSUDIV="",PSUINV(13) S PSULOC=PSUINV(13) S PSUDIV=$$INP() S:'$L(PSUDIV) PSUDIV=$$OUT()
 ;
 Q PSUDIV
 ;
WRD() ;EP    Process for ward
 N PSUWD,PSUWDDA,PSUDIV
 S PSUDIV=""
 D GETM^PSUTL(58.8,PSULOC,"21*^.01","PSUWD","I")
 D MOVEMI^PSUTL("PSUWD")
 ; loop ward pointers
 S PSUWDDA=0
 F  S PSUWDDA=$O(PSUWD(PSUWDDA)) Q:PSUWDDA'>0  D  Q:$L(PSUDIV)
 . S X=$$VALI^PSUTL(42,PSUWDDA,.015)
 . Q:'X
 . S X=$$VALI^PSUTL(40.8,X,1)
 . I $L(X) S PSUDIV=X
 ; return value of PSUDIV "" or = facility number
 Q PSUDIV
 ;
INP() ;EP  Process for Inpatient
 ; within package call to AR/WS that pulls/builds Inpatient AOU Site
 ; uses IEN Value to AOU STATs file 58.5
 N PSUARSUB,PSUARJOB
 S PSULOCA=$$VALI^PSUTL(58.8,PSULOC,2)
 N PSULOC
 S PSUARSUB=PSUPRSUB,PSUARJOB=PSUPRJOB
 S X=$$DIV^PSUAR1(PSULOCA,PSUDT) ;returns "NULL" if none found
 S:X="NULL" X=""
 Q X
 ;
IV() ;EP  Process,PSUIVDA for IV
 ; PSULOC IEN  pharmacy location in file 58.8 (DRUG ACCOUNTABILITY)
 N PSUIV,PSUDIV
 S PSUDIV=""
 D GETM^PSUTL(58.8,PSULOC,"31*^.01","PSUIV","I")
 D MOVEMI^PSUTL("PSUIV")
 S PSUIVDA=0
 F  S PSUIVDA=$O(PSUIV(PSUIVDA)) Q:PSUIVDA'>0  D  Q:$L(PSUDIV)
 . S X=$$VALI^PSUTL(59.5,PSUIVDA,.02)
 . I X S X=$$VALI^PSUTL(40.8,X,1)
 . I $L(X) S PSUDIV=X
 ;
 Q PSUDIV
 ;
OUT() ;EP  Process for Outpatient
 S X=$$VALI^PSUTL(58.8,PSULOC,20)
 I X S X=$$VALI^PSUTL(59,X,.06)
 Q X
