BLRRLMUC ;IHS/MSC/MKK - Reference Lab Meaningful Use Chemistry utilities  ; 25-Nov-2014 15:00 ; MKK
 ;;5.2;IHS LABORATORY;**1033,1034**;NOV 1, 1997;Build 88
 ;
LABSTOR(LRDFN,LRSS,LRIDT) ; Store INCOMING HL7 data into the Lab Data file
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRDFN,LRDL,LRIDT,LRSS,LRTS,U,XPARSYS,XQXFLG)
 ;
 S LRUID=$G(^LR(LRDFN,LRSS,LRIDT,"ORU"))           ; Get UID -- It can begin with zero
 Q:$L(LRUID)<1
 ;
 S PIEN=$$SHL7SEGS^BLRRLMUU(LRUID)                 ; Store HL7 data in ^TMP
 ;
 ; For non-incoming "CH" tests, store Date/Time at Test Level
 I PIEN<1,LRSS="CH",$L($G(LRDL)) D
 . S DATANAME=+$$GET1^DIQ(60,+LRTS,400,"I")
 . Q:DATANAME<1!($G(^LR(LRDFN,LRSS,LRIDT,DATANAME))="")
 . S:DATANAME ^LR(LRDFN,LRSS,LRIDT,DATANAME,"IHS")=$H
 ;
 Q:PIEN<1
 ;
 S $P(^LR(LRDFN,LRSS,LRIDT,"HL7"),"^")=PIEN        ; Store 62.49 IEN
 ;
 ; Store the various HL7 segments' data
 S SEG=0
 F  S SEG=$O(^TMP("BLRRLMUU",$J,LRUID,SEG))  Q:SEG=""  D
 . S SEGNAME=""
 . F  S SEGNAME=$O(^TMP("BLRRLMUU",$J,LRUID,SEG,SEGNAME))  Q:SEGNAME=""  D
 .. Q:$L($T(@($$VALID(SEGNAME))))<1     ; IHS/MSC/MKK - LR*5.2*1034
 .. Q:$L($T(@SEGNAME))<1  ; Skip if Segment Processing Line Label does NOT exist
 .. ;
 .. S SEGIEN=0
 .. F  S SEGIEN=$O(^TMP("BLRRLMUU",$J,LRUID,SEG,SEGNAME,SEGIEN))  Q:SEGIEN=""  D @SEGNAME
 ;
 Q
 ;
 ; ----- BEGIN IHS/MSC/MKK - LR*5.2*1034
 ; Only alphabetical characters allowed.
VALID(SEGNAME) ; EP 
 NEW CHAR,NEWSEGN
 ;
 S NEWSEGN=SEGNAME
 F CHAR=32:1:47  S NEWSEGN=$TR(NEWSEGN,$C(CHAR))
 F CHAR=58:1:64  S NEWSEGN=$TR(NEWSEGN,$C(CHAR))
 F CHAR=91:1:96  S NEWSEGN=$TR(NEWSEGN,$C(CHAR))
 F CHAR=123:1:126  S NEWSEGN=$TR(NEWSEGN,$C(CHAR))
 Q NEWSEGN
 ; ----- END IHS/MSC/MKK - LR*5.2*1034
 ;
MSH ; EP - Don't process anything in the MSH Segment
 Q
 ;
PID ; EP - Don't process anything in the PID Segment
 Q
 ;
OBR ; EP
 NEW CHNGDTT,DATANAME,DNDTT,F60IEN,OBRIEN,OBSDTT,RCTOSTR,STR,TESTNAME,TSTLOINC
 ;
 S STR=$G(^LAHM(62.49,PIEN,150,SEGIEN,0))
 ;
 S TSTLOINC=$P($P(STR,"|",5),"^")
 S TESTNAME=$P($P(STR,"|",5),"^",2)
 ;
 S F60IEN=+$$FIND1^DIC(60,,,TESTNAME_",")
 Q:F60IEN<1
 ;
 S DATANAME=+$$GET1^DIQ(60,F60IEN,400,"I")
 Q:DATANAME<1
 ;
 Q:$L($G(^LR(LRDFN,LRSS,LRIDT,DATANAME)))<1   ; Quit if no DataName data
 ;
 S OBSDTT=$P($P(STR,"|",8),"^")               ; Observation Date/Time
 S:$L(OBSDTT) OBSDTT=$$HL7TFM^XLFDT(OBSDTT)
 ;
 S CHNGDTT=$P($P(STR,"|",23),"^")             ; Status/Result Change Date/Time
 S:$L(CHNGDTT) CHNGDTT=$$HL7TFM^XLFDT(CHNGDTT)
 ;
 S DNDTT=$S($L(CHNGDTT):CHNGDTT,1:OBSDTT)     ; DataName Date/Time
 S:$L(DNDTT) $P(^LR(LRDFN,LRSS,LRIDT,DATANAME,"IHS"),"^")=DNDTT
 ;
 S RCTOSTR=$P(STR,"|",29)                     ; Result Copies To
 I $L(RCTOSTR) D
 . S SUBSTR2=$TR($P(RCTOSTR,"^",1,6),"^"," ")
 . Q:$L($TR(SUBSTR2," "))<1                   ; If only spaces, skip
 . ;
 . S SUBSTR2=$P(SUBSTR2," ")_","_$P(SUBSTR2," ",2,$L(SUBSTR2," "))
 . S $P(^LR(LRDFN,LRSS,LRIDT,"IHS"),"^",2)=SUBSTR2
 ;
 Q
 ;
OBX ; EP
 NEW ANSDTT,DATANAME,F60IEN,OBRIEN,REFLAB,RLPTR,STATUS,STR,TESTNAME,TSTLOINC
 NEW ADDRESS,ADDRL1,ADDRL2,CITY,COUNTY,COUNTRY,ERRS,FDA,HOSPITAL,ICOUNTRY,IENS,MDID,MDNAME,PERFHMDS,STATE,ZIPCODE
 ;
 S STR=$G(^LAHM(62.49,PIEN,150,SEGIEN,0))
 ;
 S RLPTR=$P($P(STR,"|",24),"^",10)
 I $L(RLPTR) D
 . S REFLAB=+$$FIND1^DIC(4,,,RLPTR,"D")
 . S:REFLAB ^LR(LRDFN,LRSS,LRIDT,"RF")=REFLAB
 ;
 S TSTLOINC=$P($P(STR,"|",4),"^")
 S TESTNAME=$P($P(STR,"|",4),"^",2)
 ;
 S F60IEN=+$$FIND1^DIC(60,,,TESTNAME)
 S:F60IEN<1 F60IEN=++$$FIND1^DIC(60,,,TSTLOINC)
 Q:F60IEN<1
 ;
 S DATANAME=+$$GET1^DIQ(60,F60IEN,400,"I")
 Q:DATANAME<1
 ;
 Q:$L($G(^LR(LRDFN,LRSS,LRIDT,DATANAME)))<1    ; Quit if no DataName data
 ;
 S ANSDTT=$P($P(STR,"|",15),"^")               ; Analysis Date/Time
 I $L(ANSDTT) D
 . S ANSDTT=$$HL7TFM^XLFDT(ANSDTT)
 . S $P(^LR(LRDFN,LRSS,LRIDT,DATANAME,"IHS"),"^")=ANSDTT
 ;
 S STATUS=$P(STR,"|",12)
 S:$L(STATUS) $P(^LR(LRDFN,LRSS,LRIDT,DATANAME,"IHS"),"^",2)=STATUS
 ;
 S:$L(TSTLOINC) $P(^LR(LRDFN,LRSS,LRIDT,DATANAME,"IHS"),"^",3)=TSTLOINC
 ;
 S IENS=LRIDT_","_LRDFN_","
 ;
 ; Performing Hospital
 S HOSPITAL=$P(STR,"|",24)
 S ADDRESS=$P(STR,"|",25)
 S ADDRL1=$P(ADDRESS,"^"),ADDRL2=$P(ADDRESS,"^",2)
 S CITY=$P(ADDRESS,"^",3),STATE=$P(ADDRESS,"^",4),ZIPCODE=$P(ADDRESS,"^",5)
 S COUNTY=$P(ADDRESS,"^",5),COUNTRY=$P(ADDRESS,"^",6)
 ;
 ; Performing Provider?
 S PERFHMDS=$P(STR,"|",26)
 S MDID=$P(PERFHMDS,"^")
 S MDNAME=$$TRIM^XLFSTR($P(PERFHMDS,"^",2)_","_$P(PERFHMDS,"^",3)_" "_$P(PERFHMDS,"^",4),"LR"," ")
 ;
 ; Get IEN into COUNTRY CODE (#779.004) file
 S ICOUNTRY=0
 I $L(COUNTRY) D
 . D FIND^DIC(779.004,,,,COUNTRY,,,,,"TARGET","ERRS")
 . S ICOUNTRY=+$O(TARGET("DILIST",2,0))
 ;
 Q:$L(COUNTY)<1&(ICOUNTRY<1)
 ;
 K FDA
 S:$L(COUNTY) FDA(63.04,IENS,9999996)=COUNTY
 S:ICOUNTRY FDA(63.04,IENS,9999997)=ICOUNTRY
 D UPDATE^DIE(,"FDA","IENS","ERRS")
 ;
 Q
 ;
ORC ; EP - Don't process anything in the PID Segment
 Q
 ;
SPM ; EP
 NEW CONDSPEC,SPMIEN,STR
 ;
 S STR=$G(^LAHM(62.49,PIEN,150,SEGIEN,0))
 ;
 S CONDSPEC=$P($P(STR,"|",25),"^")            ; SPECIMEN CONDITION
 S:$L(CONDSPEC) $P(^LR(LRDFN,LRSS,LRIDT,"IHS"),"^")=CONDSPEC
 ;
 Q
 ;
NTE ; EP - Don't process anything in the NTE Segment
 Q
 ;
PV1 ; EP - Don't process anything in the PV1 Segment
 Q
 ;
TQ1 ; EP - Don't process anything in the TQ1 Segment
 Q
 ;
BLRLA7FX ; Fix for Lab Data MU2 Errors
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,U,XPARSYS,XQXFLG)
 ;
 S LRDFN=.9999999
 F  S LR=$O(^LR(LRDFN))  Q:LRDFN<1  D
 . S LRIDT=0
 . F  S LRIDT=$O(^LR(LRDFN,"CH",LRIDT))  Q:LRIDT<1  D
 .. S LRDN=1
 .. F  S LRDN=$O(^LR(LRDFN,"CH",LRIDT,LRDN))  Q:LRDN<1  D
 ... Q:$L($G(^LR(LRDFN,"CH",LRIDT,LRDN)))
 ... ;
 ... ; There exist sub-node(s) of LRDN, but no data on LRDN.  Delete the "IHS" sub-node(s).
 ... K ^LR(LRDFN,"CH",LRIDT,LRDN,"IHS")
 ;
 Q
