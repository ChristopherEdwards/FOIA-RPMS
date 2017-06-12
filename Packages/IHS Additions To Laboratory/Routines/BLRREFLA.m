BLRREFLA ;IHS/MSC/MKK - REFerence Lab Address functions ; 17-Oct-2014 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034**;NOV 01, 1997;Build 88
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
 ; API Function.
PCCRLADR(VFILENUM,VFILEIEN,ARRAY) ; EP - Get Address for Lab V File entry
 ; VFILENUM = Number of the Lab V File
 ; VFILEIEN = IEN of the test in the Lab V File
 ;
 ; Returns 1 if successful or 0 if failure.
 ;
 ;    If successful, the ARRAY will be set as:
 ;         ARRAY("ST1")=Street Address 1
 ;         ARRAY("ST2")=Street Address 2 (array element only exists if Street Address 2 element exists)
 ;         ARRAY("CITY")=City
 ;         ARRAY("STATE")=STATE
 ;         ARRAY("ZIP")=Zipcode
 ;
 ; If failure, the returned string is of the form
 ;      0^VFILENUM^DESCRIPTION
 ;           where DESCRIPTION is a brief explanation of its failure (if possible)
 ;
 ; Uses the INSTITUTION number to determine the address.
 ;
 ; Initialize the array
 K ARRAY
 ;
 Q:+$G(VFILENUM)<1 "0^^V FILE NUMBER < 1"
 Q:+$G(VFILEIEN)<1 "0^"_VFILENUM_"^Lab V FILE IEN missing"
 ;
 Q:VFILENUM=9000010.09 $$CHPCCSUB(VFILEIEN,.ARRAY)
 ;
 Q:VFILENUM=9000010.25 $$MIPCCSUB(VFILEIEN,.ARRAY)
 ;
 Q "0^Lab V FILE NUMBER '"_VFILENUM_"' INVALID"
 ;
CHPCCSUB(VLABIEN,ARRAY) ; EP - "CH" subscripted tests
 NEW (ARRAY,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,VLABIEN,XPARSYS,XQXFLG)
 ;
 S INST=0
 ;
 S F60IEN=+$$GET1^DIQ(9000010.09,VLABIEN,.01,"I")       ; File 60 IEN
 S LRDN=+$$GET1^DIQ(60,F60IEN,400,"I")                  ; DataName IEN
 ;
 S DFN=$$GET1^DIQ(9000010.09,VLABIEN,.02,"I")           ; DFN = File 2 IEN
 S LRDFN=+$$GET1^DIQ(2,DFN,63)                          ; File 63 IEN
 ;
 S COLLDATE=+$$GET1^DIQ(9000010.09,VLABIEN,1201,"I")    ; Collection Date
 ;
 S LRIDT=9999999-COLLDATE                               ; Inverse Date
 S LRSS="CH"                                            ; File 63 Subscript
 ;
 I LRDN,LRDFN,COLLDATE D
 . S INST=+$P($G(^LR(LRDFN,LRSS,LRIDT,LRDN)),"^",9)     ; Get Institution from Lab Data file
 ;
 S IENS=LRIDT_","_LRDFN_","
 ;
 S VPIEN=+$$GET1^DIQ(63.04,IENS,.04,"I")                ; Verify Person
 ;
 ; If Institution IEN still < 1, use Verify Person
 S:INST<1 INST=+$$IHSDIV^XUS1(VPIEN)
 ;
 ; If Institution IEN still < 1, set to Accessioning Institution
 S:INST<1 INST=+$$GET1^DIQ(63.04,IENS,.112,"I")
 ;
 I INST<1 D     ; If Institution IEN still < 1, use Requesting Location
 . S REQLOC=+$$GET1^DIQ(63.04,IENS,.111,"I")
 . S INST=+$$GET1^DIQ(44,REQLOC,"INSTITUTION","I")
 ;
 ; If Institution IEN still < 1, set to Default Institution in 69.9
 S:INST<1 INST=+$$GET1^DIQ(69.9,1_",",3,"I")
 ;
 ; If cannot determine Institution, Quit with 0 (failure)
 Q:INST<1 "0^9000010.09^Institution < 1"
 ;
 ; Call 'Get Address' function
 Q $$RLADDRES(INST,.ARRAY)
 ;
MIPCCSUB(VLMICIEN,ARRAY) ; EP - "MI" subscripted tests
 NEW (ARRAY,DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,VLMICIEN,XPARSYS,XQXFLG)
 ;
 S INST=0
 ;
 S F60IEN=+$$GET1^DIQ(9000010.25,VLMICIEN,.01,"I")      ; File 60 IEN
 S DFN=$$GET1^DIQ(9000010.09,VLMICIEN,.02,"I")          ; DFN = File 2 IEN
 S LRDFN=+$$GET1^DIQ(2,DFN,63)                          ; File 63 IEN
 ;
 S COLLDATE=+$$GET1^DIQ(9000010.09,VLMICIEN,1201,"I")    ; Collection Date
 S LRIDT=9999999-COLLDATE                               ; Inverse Date
 ;
 S IENS=LRIDT_","_LRDFN_","
 ;
 S VPIEN=+$$GET1^DIQ(63.04,IENS,.04,"I")                ; Verify Person
 ;
 ; Use Verify Person
 S:INST<1 INST=+$$IHSDIV^XUS1(VPIEN)
 ;
 ; If Institution IEN still < 1, set to Accessioning Institution
 S:INST<1 INST=+$$GET1^DIQ(63.04,IENS,.112,"I")
 ;
 S VFLRAS=$$GET1^DIQ(9000010.25,VLMICIEN,.06)            ; Accession Number
 S LRAAAB=$P(VFLRAS," ")
 ;
 K ERRS
 S LRAA=$$FIND1^DIC(68,,,LRAAAB,,,"ERRS")               ; Get Accession IEN
 ;
 ; Find the Institution associated with the Accession's IEN
 I F60IEN,LRAA D
 . S (INSTIEN,INST)=0
 . F  S INSTIEN=$O(^LAB(60,F60IEN,8,INSTIEN))  Q:INSTIEN<1!(INST)  D
 .. S:$P($G(^LAB(60,F60IEN,8,INSTIEN,0)),"^",2)=LRAA INST=INSTIEN
 ;
 ; If Institution IEN still < 1, set to Default Institution in 69.9
 S:INST<1 INST=+$$GET1^DIQ(69.9,1_",",3,"I")
 ;
 ; If cannot determine Institution, Quit with 0 (failure)
 Q:INST<1 "0^9000010.25^Institution < 1"
 ;
 ; Call 'Get Address' function
 Q $$RLADDRES(INST,.ARRAY)
 ;
 ; API Function.
 ; Given an IEN from file 4.
 ;
 ; If not successful, the function returns 0.
 ; 
 ; If successful, the fucntion returns returns 1.
 ; The Reference Lab ADDRESS is returned in the ARRAY from file 4
 ; The array will be defined as the following:
 ;     ARRAY("ST1")=Street Address 1
 ;     ARRAY("ST2")=Street Address 2 (array element only exists if Street Address 2 element exists)
 ;     ARRAY("CITY")=City
 ;     ARRAY("STATE")=STATE
 ;     ARRAY("ZIP")=Zipcode
 ;
RLADDRES(F4IEN,ARRAY) ; EP
 ; F4IEN = IEN from INSTITUTION (#4) file.
 ;      Output (if any) will be put into the ARRAY
 ; Returns 1 if successful or 0 if failure.
 NEW (ARRAY,DILOCKTM,DISYS,DT,DTIME,DUZ,F4IEN,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 K ARRAY        ; Make sure array is initialized
 ;
 ; File IEN not positive.  Quit with 0 (failure)
 Q:+$G(F4IEN)<1 "0^INSTITUTION"
 ;
 S NAME=$$GET1^DIQ(4,F4IEN,"NAME")
 S ST1=$$GET1^DIQ(4,F4IEN,"STREET ADDR. 1")
 S ST2=$$GET1^DIQ(4,F4IEN,"STREET ADDR. 2")
 S CITY=$$GET1^DIQ(4,F4IEN,"CITY")
 S STATE=$$GET1^DIQ(4,F4IEN,"STATE")
 S ZIP=$$GET1^DIQ(4,F4IEN,"ZIP")
 ;
 ; All necessary address entries exist.  Put into ARRAY and exit.
 I $L(NAME),$L(ST1),$L(CITY),$L(STATE),$L(ZIP) D  Q 1
 . S ARRAY("NAME")=NAME,ARRAY("ST1")=ST1
 . S:$L(ST2) ARRAY("ST2")=ST2
 . S ARRAY("CITY")=CITY,ARRAY("STATE")=STATE,ARRAY("ZIP")=ZIP
 ;
 ;
 ; Data does NOT exist.  Quit with 0 (failure)
 Q "0^"_F4IEN_"^ADDRESS missing"
 ;
FINDSOME ; EP - DEBUG
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 W !!,"DUZ(2)=",DUZ(2),!!,?4
 ;
 S (CNTACC,CNT)=0,MAX=29
 S LRDFN=.9999999
 F  S LRDFN=$O(^LR(LRDFN))  Q:LRDFN<1!(CNT>MAX)  D
 . S LRIDT=.9999999
 . F  S LRIDT=$O(^LR(LRDFN,"CH",LRIDT))  Q:LRIDT<1!(CNT>MAX)  D
 .. S IENS=LRIDT_","_LRDFN_","
 .. ;
 .. S IFIELD=.112
 .. S INST=+$$GET1^DIQ(63.04,IENS,.112,"I")      ; Accessioning Institution
 .. I INST<1 D                                   ; If no Accessioning Institution, use Requesting Location
 ... S REQLOC=+$$GET1^DIQ(63.04,IENS,.111,"I")
 ... S INST=$$GET1^DIQ(44,REQLOC,"INSTITUTION","I")
 ... S IFIELD=.111
 .. ;
 .. Q:INST=DUZ(2)
 .. ;
 .. S REFLAB=+$$GET1^DIQ(9009029,INST,3001,"I")
 .. Q:REFLAB<1
 .. ;
 .. S REFLNAME=$$GET1^DIQ(9009026,REFLAB,.01)
 .. ;
 .. S CNTACC=CNTACC+1
 .. I CNT<1  W:(CNTACC#100)=0 "."  W:$X>74 !,?4
 .. ;
 .. S CNT=CNT+1
 .. W:CNT=1 !!
 .. W LRDFN
 .. W ?9,LRIDT
 .. W ?25,IFIELD
 .. W ?35,INST
 .. W ?45,REFLAB
 .. W ?55,REFLNAME
 .. W !
 ;
 Q
 ;
FINDVISL ; EP - Find VLAB visits
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S TESTIEN=175  ; Hard set to Glucose
 ;
 S HEADER(1)="VLAB Visits"
 S HEADER(2)=" "
 S HEADER(3)="IEN"
 S $E(HEADER(3),10)="Visit IEN"
 S $E(HEADER(3),20)="LR ACCESSION"
 S $E(HEADER(3),35)="ICD CODE"
 S $E(HEADER(3),45)="LOINC"
 S $E(HEADER(3),55)="PROVIDER NARRATIVE"
 ; S $E(HEADER(3),75)="LABPC"
 S $E(HEADER(3),75)="DFN"
 ;
 D HEADERDT^BLRGMENU
 ;
 S CNT=0,MAX=15
 S VLABIEN="A"
 F  S VLABIEN=$O(^AUPNVLAB(VLABIEN),-1)  Q:VLABIEN<1!(CNT>MAX)  D
 . K TARGET,ERRS
 . D GETS^DIQ(9000010.09,VLABIEN,".01;.02;.03;.06;1112;1113;1601;1602","I","TARGET","ERRS")
 . ;
 . ; Don't duplicate patient
 . S DFN=$G(TARGET(9000010.09,VLABIEN_",",.02,"I"))
 . Q:$D(DFN(DFN))
 . S DFN(DFN)=""
 . ;
 . W VLABIEN
 . W ?9,$G(TARGET(9000010.09,VLABIEN_",",.03,"I"))
 . W ?19,$G(TARGET(9000010.09,VLABIEN_",",.06,"I"))
 . ; W ?34,$G(TARGET(9000010.09,VLABIEN_",",1112,"I"))
 . W ?34,$$SHOWICD($G(TARGET(9000010.09,VLABIEN_",",1112,"I"))) ; IHS/MSC/MKK - LR*5.2*1034
 . W ?44,$G(TARGET(9000010.09,VLABIEN_",",1113,"I"))
 . W ?54,$E($G(TARGET(9000010.09,VLABIEN_",",1601,"I")),1,18)
 . ; W ?74,$E($G(TARGET(9000010.09,VLABIEN_",",1602,"I")),1,6)
 . W:$D(^DPT(DFN,"LR")) ?73,"*"
 . W ?74,DFN
 . W !
 . S CNT=CNT+1
 ;
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
SHOWICD(ICD) ; EP - 
 NEW ICDSTR
 ;
 S ICDSTR=$P($$ICDDX^ICDEX(ICD),"^",2)
 S:ICDSTR["No Code Selected" ICDSTR=""
 S:ICDSTR["Invalid" ICDSTR=ICD
 Q ICDSTR
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
VLABDATA(VLABIEN) ; EP - Display VLAB Data
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,VLABIEN,XPARSYS,XQXFLG)
 ;
 S F60IEN=+$$GET1^DIQ(9000010.09,VLABIEN,.01,"I")
 S VISITIEN=+$$GET1^DIQ(9000010.09,VLABIEN,.03,"I")
 S DFN=$$GET1^DIQ(9000010.09,VLABIEN,.02,"I")
 S COLLDATE=+$$GET1^DIQ(9000010.09,VLABIEN,1201,"I")
 ;
 S DATANAME=$$GET1^DIQ(60,F60IEN,400,"I")
 S LRDFN=+$$GET1^DIQ(2,+DFN,63)
 ;
 S LRIDT=$S(+COLLDATE:(9999999-COLLDATE),1:" ")
 ;
 S VISIENS=VISITIEN_","
 S VLOCEIEN=$$GET1^DIQ(9000010,VISIENS,.06,"I")
 S VLOCENIEN=$$GET1^DIQ(9999999.06,+VLOCEIEN,.01,"I")
 S VHLOCIEN=$$GET1^DIQ(9000010,VISIENS,.22,"I")
 ;
 W !!
 W "VLABIEN:",VLABIEN,!
 W ?4,"F60IEN:",F60IEN
 W ?24,"DFN:",DFN
 W ?39,"COLLDATE:",COLLDATE
 W !!
 ;
 W ?4,"DATANAME:",DATANAME
 W ?19,"LRDFN:",LRDFN
 W ?34,"LRIDT:",LRIDT
 W !!
 ;
 W ?4,"VISIT ",VISIENS," Data:",!
 W ?9,"LOC. OF ENCOUNTER:",VLOCEIEN
 W:$L(VLOCENIEN) ?39,VLOCENIEN,?49,$$GET1^DIQ(4,VLOCENIEN,.01)
 W !
 W ?9,"HOSPITAL LOCATION:",VHLOCIEN
 W !!
 ;
 S IENS=LRIDT_","_LRDFN_","
 ;
 W "Last $PIECE from File 63 '",DATANAME,"' Node: ",$RE($P($RE($G(^LR(+LRDFN,"CH",+LRIDT,+DATANAME))),"^")),!
 W ?4,"Raw Data:",$E($G(^LR(+LRDFN,"CH",+LRIDT,+DATANAME)),1,65),!!
 ;
 S VPIEN=$$GET1^DIQ(63.04,IENS,.04,"I")
 W "'Division' from File 63 Verify Person '",VPIEN,"' IEN: ",$$IHSDIV^XUS1(VPIEN),!!
 ;
 S REQLOC=$TR($$GET1^DIQ(63.04,IENS,.11),".")
 W "Requesting Location: ",REQLOC,!
 I $L(REQLOC) D
 . S F44IEN=$$FIND1^DIC(44,,,REQLOC)
 . W:+F44IEN<1 ?4,"Lookup of ",REQLOC,": ",!
 . I +F44IEN D
 .. W ?4,"Lookup of '",REQLOC,"' in File 44 --",!
 .. W ?19,"IEN: ",F44IEN,!
 .. W ?19,"NAME: ",$$GET1^DIQ(44,F44IEN,"NAME"),!
 .. W ?19,"INSTITUTION: ",$$GET1^DIQ(44,F44IEN,"INSTITUTION","I")
 .. W !
 . W !
 ;
 W "Requesting LOC/DIV: ",$$GET1^DIQ(63.04,IENS,.111),!!
 ;
 W "Accessioning Institituion: ",$$GET1^DIQ(63.04,IENS,.112),!!
 ;
 S REQLOC=$$GET1^DIQ(63.04,IENS,.111,"I")
 W:$L(REQLOC)<1 "Requesting Location Institution:",!!
 W:$L(REQLOC) "Requesting Location '",REQLOC,"' Institution:",$$GET1^DIQ(44,REQLOC,"INSTITUTION","I"),!!
 ;
 W "Default Institution in 69.9: ",$$GET1^DIQ(69.9,1_",",3,"I"),!!
 Q
 ;
FINDVFVI ; EP - Find V File visits
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S HEADER(1)="VFile Visits"
 S HEADER(2)=" "
 S HEADER(3)="V File"
 S $E(HEADER(3),13)="Visit"
 S $E(HEADER(3),23)="File 60"
 S HEADER(4)="Number"
 S $E(HEADER(4),13)="IEN"
 S $E(HEADER(4),23)="IEN"
 S $E(HEADER(4),33)="LR ACCESSION"
 S $E(HEADER(4),53)="DFN"
 S $E(HEADER(4),63)="LRDFN"
 ;
 D HEADERDT^BLRGMENU
 ;
 ; First, VLAB entries
 S TESTIEN=175  ; Hard set to Glucose
 S CNT=0,MAX=15
 S VLABIEN="A"
 F  S VLABIEN=$O(^AUPNVLAB(VLABIEN),-1)  Q:VLABIEN<1!(CNT>MAX)  D
 . K TARGET,ERRS
 . ;
 . D LISTVISD(9000010.09,VLABIEN)
 ;
 W !
 ;
 ; NEXT, V MICRO Entries
 S CNT=0,MAX=15
 S VMICIEN=.9999999
 F  S VMICIEN=$O(^AUPNVMIC(VMICIEN))  Q:VMICIEN<1!(CNT>MAX)  D
 . D LISTVISD(9000010.25,VMICIEN)
 ;
 Q
 ;
LISTVISD(VFILEIEN,VISITIEN) ; EP - List Visit Data
 K TARGET,ERRS
 ;
 D GETS^DIQ(VFILEIEN,VISITIEN,".01;.02;.06","I","TARGET","ERRS")
 ;
 S DFN=+$G(TARGET(VFILEIEN,VISITIEN_",",.02,"I"))
 S LRDFN=$$GET1^DIQ(2,+DFN,63)
 Q:$L(LRDFN)<1
 ;
 W VFILEIEN
 W ?12,VISITIEN
 W ?22,$G(TARGET(VFILEIEN,VISITIEN_",",.01,"I"))
 W ?32,$G(TARGET(VFILEIEN,VISITIEN_",",.06,"I"))
 S DFN=+$G(TARGET(VFILEIEN,VISITIEN_",",.02,"I"))
 W ?52,DFN
 W ?62,LRDFN
 W !
 S CNT=CNT+1
 Q
