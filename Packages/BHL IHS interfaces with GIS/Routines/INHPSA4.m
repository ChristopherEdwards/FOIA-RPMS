INHPSA4 ; KAC ; 21 Jun 99 13:19; Interface Control Program (continued) 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
TTBASE(DA,INST,INHIER) ; $$ function - Deactivate/activate one base (and associated
 ; parent) transaction type based on replicant transaction type (DA).
 ;
 ; Input:
 ; DA = INTERFACE TRANSACTION TYPE IEN for replicant
 ; INST = 0 - deactivate
 ;        1 - activate
 ;        2 - show
 ;
 ; Variables:
 ; INBASEDA - INTERFACE TRANSACTION TYPE IEN for base associated with replicant
 ; INCUSTAT - current status of base TT (0=inactive, 1=active)
 ; INRHRDA  - INTERFACE MESSAGE REPLICATION IEN for replicant
 ; OK       - "OK to deactivate TT" flag
 ; REPTT    - INTERFACE TRANSACTION TYPE IEN for other replicants associated
 ;            with this base TT
 ; RHRTT    - INTERFACE MESSAGE REPLICATION IEN for other entries associated
 ;            with this base TT
 ;
 ; Output:
 ; 1 = successful de/activation
 ; 0 = error
 ;
 N INBASEDA,INCUSTAT,INRHRDA,OK,REPTT,RHRTT
 Q:'$D(^INRHR("B",DA)) 1  ; DA is NOT a Replicant TT
 S INRHRDA=$O(^INRHR("B",DA,0))
 I 'INRHRDA D  Q 0
 .D T^INHMG1 W "ERROR:  Replicant Transaction Type, "_$P($G(^INRHT(+DA,0)),U)
 .D T^INHMG1 W "        not found in INTERFACE MESSAGE REPLICATION file - B Xef missing."
 .D T^INHMG1 W !
 S INBASEDA=$P(^INRHR(INRHRDA,0),U,2)
 I $S('INBASEDA:1,'$D(^INRHT(INBASEDA)):1,1:0) D  Q 0
 .D T^INHMG1 W "ERROR:  Base Transaction Type not found in INTERFACE MESSAGE REPLICATION"
 .D T^INHMG1 W "        file for Replicant Transaction Type, "_$P($G(^INRHT(+DA,0)),U)_"."
 .D T^INHMG1 W !
 ;
 S INCUSTAT=$P(^INRHT(INBASEDA,0),U,5) ; get current status of base TT
 ;
 ; Perform activation process
 I INST=1 D:'INCUSTAT
 .; Base is NOT active - check for active replicants
 .S RHRTT="" F  S RHRTT=$O(^INRHR("AC",INBASEDA,RHRTT)) Q:'RHRTT  S REPTT=+$P(^INRHR(RHRTT,0),U) D
 ..; no warning if REPTT is calling replicant or is inactive
 ..Q:(REPTT=DA)!('$P($G(^INRHT(REPTT,0)),U,5))
 ..D T^INHMG1 W "WARNING:  Transaction type ",$P(^INRHT(REPTT,0),U)," was active.  "
 ..D T^INHMG1 W "          Messages will now be generated for this transaction type."
 ;
 ; Perform deactivation process
 I 'INST S OK=1 D:INCUSTAT  Q:'OK 1  ; exit if NOT OK to deactivate base & parent
 .; Base is active - check for active replicants
 .; no deactivation if REPTT is NOT the calling replicant & is active
 .S RHRTT="" F  S RHRTT=$O(^INRHR("AC",INBASEDA,RHRTT)) Q:'RHRTT  S REPTT=+$P(^INRHR(RHRTT,0),U) I REPTT'=DA,$P($G(^INRHT(REPTT,0)),U,5) S OK=0 Q
 ;
 ; De/Activate Base TT
 Q:'$$TTEDT^INHPSA(INBASEDA,INST,.INHIER,"BASE") 0
 ;
 ; De/Activate associated Parent TT
 Q:'$$TTPAR^INHPSA(INBASEDA,INST,.INHIER) 0
 ;
 Q 1
 ;-----------------
WRITE(INHIER,INST) ; write the transaction type, parent, base and child
 ;Input:
 ; INST   = 0 - deactivate
 ;          1 - activate
 ;          2 - show
 ;
 ; INHIER -  array where
 ;    INHIER("PARENT") = INTERFACE TRANSACTION TYPE IEN for parent
 ;    INHIER("BASE")   = INTERFACE TRANSACTION TYPE IEN for base
 ;    INHIER("CHILD")  = INTERFACE TRANSACTION TYPE IEN for child
 ;
 N P,B,C,INMRG
 S P=$G(INHIER("PARENT"))
 S B=$G(INHIER("BASE"))
 S C=$G(INHIER("CHILD"))
 I $P($G(^INRHT(+C,0)),U,8)'="I" D
 .S INMRG=0
 .I P D T^INHMG1 Q:$G(DUOUT)  W "Parent: ",$P($G(^INRHT(+P,0)),U),?68,$$GACT(+P,INST) S INMRG=INMRG+3
 .I B D T^INHMG1 Q:$G(DUOUT)  W ?INMRG,"Base:   ",$P($G(^INRHT(+B,0)),U),?68,$$GACT(+B,INST) S INMRG=INMRG+3
 .D T^INHMG1 Q:$G(DUOUT)
 .I P&B W ?INMRG,"Rep - TT:  "
 .E  W ?INMRG,$S(P:"Child:  ",1:"Trans:  ")
 .W $P($G(^INRHT(+C,0)),U),?68,$$GACT(+C,INST)
 .D T^INHMG1 Q:$G(DUOUT)  W ?22,"Destination: ",$P($G(^INRHD(+$P($G(^INRHT(+C,0)),U,2),0)),U)
 E  D
 .D T^INHMG1 Q:$G(DUOUT)
 .W "IN - TT: ",$S('C:"NONE",1:$P($G(^INRHT(+C,0)),U)),?68,$$GACT(+C,INST)
 D T^INHMG1 Q:$G(DUOUT)  W !
 Q
 ;
GACT(DA,INST) ; returns the verbos status of the transaction
 ;Input:
 ; DA     = INTERFACE TRANSACTION TYPE IEN
 ; INST   = 0 - deactivate
 ;          1 - activate
 ;          2 - show
 ;Output:
 ;  returns the verbos status of the transaction
 ;
 N ISACT,INSTMSG
 I 'DA Q ""
 S ISACT=$P($G(^INRHT(DA,0)),U,5)
 I INST>1 S INSTMSG=$S('ISACT:"INACTIVE",1:"ACTIVE")
 E  S INSTMSG=$S('ISACT:"DEACTIVATED",1:"ACTIVATED")
 Q INSTMSG
 ;
DISCREP(ININT,INDAT) ;report this disrepancies
 ; Input:
 ;   ININT - interface application to activate
 ;   INDAT = data array of control file records fo application
 ;
 ;  Note:  For a future enhancement, you may want to add more than
 ;         one destination ( entries in file# 4005) to the INHPSA1,
 ;   INHPSA3 and INHPSA5 tables,  Then make the INNAME, 
 ;         INDES arrays, with subscripts containing these destinations.
 ;         Doing this prevent the program from generating bugus, 
 ;         report for interfaces like CRSPL or CRPSR that has 
 ;         more than one destination.
 N INNAME
 N INREC,TTNMA,INARR,FOUND,X
 S INNAME=$G(INDAT(ININT,4005,1))
 D T^INHMG1 Q:$G(DUOUT)
 S X="Discrepancies Report for "_INNAME
 W ?(IOM-$L(X))\2,X
 S Y="" S $P(Y,"*",$L(X)+1)=""
 D T^INHMG1 Q:$G(DUOUT)
 W ?(IOM-$L(X))\2,Y
 I INNAME="" D T^INHMG1 Q:$G(DUOUT)  W "ERROR: No destination found in "_ININT Q
 S INDES=+$O(^INRHD("B",$$UPCASE^%ZTF(INNAME),0))
 I 'INDES D T^INHMG1 Q:$G(DUOUT)  W "ERROR: "_INNAME_" not found in interface destination file" Q
 S INREC=0
 F  S INREC=$O(INDAT(ININT,4000,INREC)) Q:'INREC!$G(DUOUT)  D
 .S TTNAM=$P(INDAT(ININT,4000,INREC),U)
 .Q:TTNAM=""
 .S INTTIEN=$O(^INRHT("B",TTNAM,0))
 .I 'INTTIEN D T^INHMG1 W "ERROR: "_TTNAM_" not found in Interface Transaction file" Q
 .Q:$P($G(^INRHT(INTTIEN,0)),U,8)="I"
 .I $P($G(^INRHT(INTTIEN,0)),U,2)'=INDES D  Q
 ..D T^INHMG1 W "WARNING: "_TTNAM_" has destination  "
 ..D T^INHMG1 W "         "_$P($G(^INRHD(+$P($G(^INRHT(INTTIEN,0)),U,2),0)),U)
 ..;--D T^INHMG1 W "       Interface Destination file is not "_INNAME
 .S INARR(TTNAM,"PRG")=INTTIEN
 Q:$G(DUOUT)
 ;
 S INTTIEN=0
 F  S INTTIEN=$O(^INRHT(INTTIEN)) Q:'INTTIEN  D
 .Q:$P($G(^INRHT(INTTIEN,0)),U,8)="I"
 .Q:$P($G(^INRHT(INTTIEN,0)),U,2)'=INDES
 .S TTNAM=$P($G(^INRHT(INTTIEN,0)),U)
 .S INARR(TTNAM,"FM")=INTTIEN
 ;W !
 ;ZW INARR
 ;W !
 D T^INHMG1 Q:$G(DUOUT)  W !
 S FOUND=0
 D T^INHMG1 Q:$G(DUOUT)  W !
 D T^INHMG1 Q:$G(DUOUT)  W "List of transactions that point to destination: "_INNAME_"."
 D T^INHMG1 Q:$G(DUOUT)  W "But, are not activated/deactivated in EN^INHPSAM"
 S FOUND=0
 S TTNAM=""
 F  S TTNAM=$O(INARR(TTNAM)) Q:$G(TTNAM)=""!$G(DUOUT)  D
 .I $D(INARR(TTNAM,"FM")),'$D(INARR(TTNAM,"PRG")) D
 ..D T^INHMG1 W ?4,TTNAM S FOUND=1
 I 'FOUND D T^INHMG1 W "    **** No transaction found *****"
 Q
