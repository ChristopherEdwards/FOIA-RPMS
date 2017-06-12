BLRRLMUA ; IHS/MSC/MKK - Reference Lab Meaningful use Utilities, Part A  ; 22-Oct-2013 09:22 ; MKK
 ;;5.2;IHS LABORATORY;**1033**;NOV 1, 1997
 ;
EEP ; Ersatz EP
 D EEP^BLRGMENU
 Q
 ;
MU2TEST ; Test of code that reads INCOMING HL7 message
 NEW (DILOCKTM,DISYS,DT,DTIME,DUZ,IO,IOBS,IOF,IOM,ION,IOS,IOSL,IOST,IOT,IOXY,LRUID,U,XPARSYS,XQXFLG)
 ;
 S DIR(0)="NO"
 S DIR("A")="Enter UID:"
 D ^DIR
 I +$G(DIRUT) D ENDMESG^BLRRLMU2("No/Invalid Entry.  Routine Ends.")  Q
 ;
 S LRUID=X
 ;
 I $D(^LRO(68,"C",$P(LRUID,"A")))<1 D ENDMESG^BLRRLMU2("No Accessfion File Data.  Routine Ends.")  Q     ; Skip if no UID data
 ;
 S X=$Q(^LRO(68,"C",$P(LRUID,"A"),0))
 S LRAA=$QS(X,4),LRAD=$QS(X,5),LRAN=$QS(X,6)
 ;
 S LRDFN=+$G(^LRO(68,LRAA,1,LRAD,1,LRAN,0)),LRIDT=$P($G(^(3)),"^",5)
 S LRSS=$$GET1^DIQ(68,LRAA,.02,"I")
 ;
 W !!,"LRUID:",LRUID,!
 W ?4,"LRAA:",LRAA,?19,"LRAD:",LRAD,?34,"LRAN:",LRAN,?49,"LRAS:",$G(^LRO(68,LRAA,1,LRAD,1,LRAN,.2)),!!
 ;
 K ^TMP("BLRRLMUU",$J,LRUID)                       ; DEBUG - Reset everything
 ;
 S PIEN=$$SHL7SEGS^BLRRLMUU(LRUID)                 ; Store HL7 data in ^TMP
 ;
 I PIEN<1 D ENDMESG^BLRRLMU2("No Information for PID "_LRUID_" found in 62.49.  Routine Ends.")  Q
 ;
 W "FILE 62.49 -- PIEN:",PIEN,!!
 ;
 ; Display the various HL7 segments' data
 S SEG=""
 F  S SEG=$O(^TMP("BLRRLMUU",$J,LRUID,PIEN,SEG))  Q:SEG=""  D
 . S SEGIEN=0
 . F  S SEGIEN=$O(^TMP("BLRRLMUU",$J,LRUID,PIEN,SEG,SEGIEN))  Q:SEGIEN<1  D SHOWSEG
 ;
 D PRESSKEY^BLRGMENU(9)
 Q
 ;
DISPMSH ; EP - Don't process anything in the MSH Segment
 Q
 ;
DISPPID ; EP - Don't process anything in the PID Segment
 Q
 ;
DISPOBR ; EP
 NEW CHNGDTT,DATANAME,DNDTT,F60IEN,OBRIEN,OBSDTT,RCTOSTR,TESTNAME,TSTLOINC
 ;
 S TSTLOINC=$P($P(STR,"|",5),"^")
 S TESTNAME=$P($P(STR,"|",5),"^",2)
 S ORIGTEXT=$P($P(STR,"|",5),"^",9)
 ;
 W ?9,"TSTLOINC:",TSTLOINC,?39,"TESTNAME:"
 W:$L(TESTNAME)<31 TESTNAME,!
 I $L(TESTNAME)>30 D LINEWRAP^BLRGMENU(49,TESTNAME,30)  W !
 W ?9,"ORIGTEXT:",ORIGTEXT,!
 ;
 S F60IEN=$$FIND1^DIC(60,,,ORIGTEXT_",")
 W ?9,"F60IEN:",F60IEN,!
 ;
 S DATANAME=$$GET1^DIQ(60,+F60IEN,400,"I")
 W ?9,"DATANAME:",DATANAME,!
 ;
 S OBSDTT=$P($P(STR,"|",8),"^")               ; Observation Date/Time
 W ?9,"OBSDTT:",OBSDTT
 D:$L(OBSDTT) SHOWDATE^BLRRLMU2(OBSDTT)
 W !
 ;
 S CHNGDTT=$P($P(STR,"|",23),"^")             ; Status/Result Change Date/Time
 W ?9,"CHNGDTT:",CHNGDTT
 D:$L(CHNGDTT) SHOWDATE^BLRRLMU2(CHNGDTT)
 W !
 ;
 S DNDTT=$S($L(CHNGDTT):CHNGDTT,1:OBSDTT)     ; DataName Date/Time
 W ?9,"DNDTT:",DNDTT
 D:$L(DNDTT) SHOWDATE^BLRRLMU2(CHNGDTT)
 W !
 ;
 S RCTOSTR=$P(STR,"|",29)                     ; Result Copies To
 I $L(RCTOSTR) D
 . S SUBSTR2=$TR($P(RCTOSTR,"^",2,6),"^"," ")
 . Q:$L($TR(SUBSTR2," "))<1                   ; If only spaces, skip
 . ;
 . W ?9,"RCTOSTR:",RCTOSTR,!,?14,"SUBSTR2:",SUBSTR2,!
 . ;
 . ; Assumption is that the NAME is in $P(SUBSTR," ",1,3)
 . S SUBSTR2=$P(SUBSTR2," ")_","_$P(SUBSTR2," ",2,$L(SUBSTR2," "))
 . W ?19,"SUBSTR2:",SUBSTR2,!
 ;
 Q
 ;
DISPOBX ; EP
 NEW ANSDTT,DATANAME,F60IEN,OBRIEN,STATUS,TESTNAME,TSTLOINC
 ;
 S TSTLOINC=$P($P(STR,"|",4),"^")
 S TESTNAME=$P($P(STR,"|",4),"^",2)
 S ORIGTEXT=$P($P(STR,"|",4),"^",9)
 ;
 W ?9,"TSTLOINC:",TSTLOINC,?39,"TESTNAME:"
 W:$L(TESTNAME)<31 TESTNAME,!
 I $L(TESTNAME)>30 D LINEWRAP^BLRGMENU(49,TESTNAME,30)  W !
 W ?9,"ORIGTEXT:",ORIGTEXT,!
 ;
 S F60IEN=$$FIND1^DIC(60,,,ORIGTEXT_",")
 W ?9,"F60IEN:",F60IEN,!
 ;
 S DATANAME=$$GET1^DIQ(60,+F60IEN,400,"I")
 W ?9,"DATANAME:",DATANAME,!
 ;
 S ANSDTT=$P($P(STR,"|",15),"^")               ; Analysis Date/Time
 W ?9,"ANSDTT:",ANSDTT
 D:$L(ANSDTT) SHOWDATE^BLRRLMU2(ANSDTT)
 W !
 ;
 S STATUS=$P(STR,"|",12)
 W ?9,"STATUS:",STATUS,!
 ;
 Q
 ;
DISPORC ; EP - Don't process anything in the PID Segment
 Q
 ;
DISPSPM ; EP
 NEW CONDSPEC,SPMIEN
 ;
 S CONDSPEC=$P($P(STR,"|",25),"^")            ; SPECIMEN CONDITION
 W ?9,"CONDSPEC:",CONDSPEC,!
 ;
 S REJREASN=$P($P(STR,"|",22),"^",2)
 W ?9,"REJREASN:",REJREASN,!
 Q
 ;
DISPNTE ; EP - Don't process anything in the NTE Segment
 Q
 ;
DISPTQ1 ; EP - Don't process anything in the TQ1 Segment
 Q
 ;
SHOWSEG ; EP - Show segment and setup STR variable
 NEW STR
 ;
 W ?4,SEG,!,?9,"PIEN:",PIEN,?39,"SEGIEN:",SEGIEN,!
 S STR=$G(^LAHM(62.49,PIEN,150,SEGIEN,0))
 S DOTELL="DISP"_SEG
 D @DOTELL
 Q
