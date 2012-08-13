INHMG1 ;KN,PO; 18 Jun 99 13:58; Script Generator Message - Print Template 
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 ; MODULE NAME: Script Generator Message - Print Template (INHMG1).
 ;
 ; PURPOSE:
 ; The purpose of the module INHMG1 is used as a print template
 ; to display the message parts for the selected script generator
 ; message.  The module INHMG1 will handle the segments and fields.
 ;
 ; DESCRIPTION:
 ; The processing of the module INHMG1 is used to call other modules
 ; INHMG2 to build the DXS array. The DXS array contains
 ; the MUMPS code to search global ^INTHL7M for message, ^INTHL7S for
 ; segment, and ^INTHL7F for field to get the details of Script
 ; Generator Message Listing.  The module INHMG1 will display the
 ; message parts for the selected script generator message.  It will
 ; then call module INHMG2 to process the Script Generator Segments
 ; and Fields.
 Q
INBUILD(INCOMSEG) ; Entry point
 ;
 ; Description: INBUILD is the entry point for the module INHMG1.
 ;   It will call modules INHMG1 and INHMG2 to build the
 ;  DXS array, then display the message details for
 ;  the selected message.  It also receive option
 ;  INCOMSEG from module INHMG.
 ;
 ; Return: None
 ; Parameters:
 ;  INCOMSEG : option for display common segment
 ;       INCOMSEG: 1 = display
 ;   0 = not display
 ;
 ; Code begins:
 K DIOUT
 D:$D(DXS)<9 INDXS^INHMG
 D N:$X>0 W ?0 W "***** Message *****************************************************************"
 ;
 S X=$G(^INTHL7M(D0,0)) D N Q:$G(DUOUT)  W $E($P(X,U),1,45)
 W ?66,"Inactive:",?76 S Y=$P(X,U,8),Y=$S(Y="":Y,$D(DXS(18,Y)):DXS(18,Y),1:Y) W Y
 F D1=0:0 Q:'$O(^INTHL7M(D0,3,D1))!$G(DUOUT)  S D1=$O(^(D1)) D:$X>79 T D
 .S X=$G(^INTHL7M(D0,3,D1,0)) D N Q:$G(DUOUT)  W ?4,X
 Q:$G(DUOUT)
 ;
 D T,N Q:$G(DUOUT)  W ?5,"Standard:"
 S DXN(0)=$G(^INTHL7M(D0,0)) W ?15,$E($P(DXN(0),U,12),1,20)
 D N Q:$G(DUOUT)  W ?3,"Event Type:"
 W ?15,$E($P(DXN(0),U,2),1,20)
 ;
 W ?41,"Message Type:",?56,$E($P(DXN(0),U,6),1,3)
 D N Q:$G(DUOUT)  W ?1,"Send Applic.:"
 S X=$G(^INTHL7M(D0,7)) W ?15,$E($P(X,U),1,25)
 W ?41,"Rec. Applic.:",?55,$E($P(X,U,3),1,25)
 D N Q:$G(DUOUT)  W ?5,"Facility:",?15,$E($P(X,U,2),1,25)
 W ?45,"Facility:",?55,$E($P(X,U,4),1,25)
 D N Q:$G(DUOUT)  W "Processing ID:"
 S X=$G(DXN(0)) W ?15 S Y=$P(X,U,3),Y=$S(Y="":Y,$D(DXS(19,Y)):DXS(19,Y),1:Y) W Y
 W ?28,"HL7 Version:",?41,$E($P(X,U,4),1,5)
 W ?48,"Lookup Parameter:",?66 S Y=$P(X,U,7),Y=$S(Y="":Y,$D(DXS(20,Y)):DXS(20,Y),1:Y) W Y
 D N Q:$G(DUOUT)  W ?3,"Accept Ack:",?15 S Y=$P(X,U,10),Y=$S(Y="":Y,$D(DXS(21,Y)):DXS(21,Y),1:Y) W Y
 W ?49,"Application Ack:",?66 S Y=$P(X,U,11),Y=$S(Y="":Y,$D(DXS(22,Y)):DXS(22,Y),1:Y) W Y
 D N Q:$G(DUOUT)  W ?4,"Root File:",?15 S Y=$P(X,U,5),Y=$S(Y="":Y,$D(^DIC(Y,0))#2:$P(^(0),U),1:" "_Y) W $E(Y,1,40)
 W ?57,"Audited:",?66 S Y=$P(X,U,9),Y=$S(Y="":Y,$D(DXS(18,Y)):DXS(18,Y),1:Y) W Y
 D N Q:$G(DUOUT)  W "Routine for Lookup/Store:"
 S X=$G(^INTHL7M(D0,5)) W ?26,$E($E(X,1,200),1,54)
 D N Q:$G(DUOUT)  W "Transaction Types:"
 D RPTRANS(D0,"D N^INHMG1")
 ;
 D N Q:$G(DUOUT)  W "MUMPS Code for Lookup:"
 F D1=0:0 Q:'$O(^INTHL7M(D0,4,D1))!$G(DUOUT)  S D1=$O(^(D1)) D:$X>22 T D  Q:$G(DUOUT)
 .S X=$G(^INTHL7M(D0,4,D1,0)) D N Q:$G(DUOUT)  W ?4,X
 Q:$G(DUOUT)
 D N Q:$G(DUOUT)  W "Outgoing Initial MUMPS Code:"
 F D1=0:0 Q:'$O(^INTHL7M(D0,6,D1))!$G(DIOUT)  S D1=$O(^(D1)) D:$X>28 T D  Q:$G(DIOUT)
 .S X=$G(^INTHL7M(D0,6,D1,0)) D N Q:$G(DUOUT)  W ?4,X
 Q:$G(DUOUT)
 D N Q:$G(DUOUT)  W "Generated Scripts -"
 D N Q:$G(DUOUT)  W ?3,"Input:"
 S (DXN("S"),X)=$G(^INTHL7M(D0,"S")) D N:$X>10 W ?10 S Y=$P(X,U),Y=$S(Y="":Y,$D(^INRHS(Y,0))#2:$P(^(0),U),1:" "_Y) W $E(Y,1,60)
 D N Q:$G(DUOUT)  W ?2,"Output:"
 W ?10 S Y=$P(X,U,2),Y=$S(Y="":Y,$D(^INRHS(Y,0))#2:$P(^(0),U),1:" "_Y) W $E(Y,1,60)
 ;
 K INSAR
 ;Save D1 and Seq in array INSAR - INSAR(seq,D1)=""
 S D1=0 F  S D1=$O(^INTHL7M(D0,1,D1)) Q:D1'>0!$G(DUOUT)  D:$X>70 T S INX=$P($G(^(D1,0)),U,2),INSAR(INX,D1)=""
 ;Loop through array INSAR and display all the segments
 S INI="INSAR"  F  S INI=$Q(@INI) Q:'$L(INI)  S D1=$$QS^INHUTIL(INI,2) D INSEG(INCOMSEG,D0,D1)
 K Y,DXN,DIWF
 Q
N W !
T W:$X ! I $D(IOSL),($Y>(IOSL-3))  D HEADER^INHMG  W:$X !
 Q
 ;
INSEG(INCOMSEG,D0,D1) ; get segment details and call INHMG2 for processing
 Q:'$D(^INTHL7M(D0,1,D1,0))
 ; check for common segment, and display if INCOMSEG is Y
 S INX=$G(^INTHL7M(D0,1,D1,0)),INY=$P(INX,U) Q:'$D(^INTHL7S(INY))  S INZ=$G(^INTHL7S(INY,0)),INA=$P(INZ,U,2) Q:((INA["MSH")!(INA["PID"))&(INCOMSEG=0)
 ; INSG stores the lines for segments and fields display.
 K INSG,INFD
 ; Get all the segment info and store in array INSG and INFD
 S (DXN(0),X)=$G(^INTHL7M(D0,1,D1,0)) S Y=$P(INX,U),Y=$S(Y="":Y,$D(^INTHL7S(Y,0))#2:$P(^(0),U),1:" "_Y),INSG("NM")=$E(Y,1,45)
 N DIP X DXS(2,9.2) S D1=I(1,0) K DIP S INSG("NM",1)=$E(X,1,6)
 S X=$G(DXN(0)),Y=$P(X,U,2) S INSG("NM",2)=Y
 S Y=$P(X,U,9),INSG("NM",3)=$S(Y="":Y,$D(DXS(18,Y)):DXS(18,Y),1:Y)
 S Y=$P(X,U,3),INSG("NM",4)=$S(Y="":Y,$D(DXS(18,Y)):DXS(18,Y),1:Y)
 S Y=$P(X,U,4),INSG("NM",5)=$S(Y="":Y,$D(DXS(18,Y)):DXS(18,Y),1:Y)
 S Y=$P(X,U,11),Y=$S(Y="":Y,$D(^INTHL7S(Y,0))#2:$P(^(0),U),1:" "_Y),INSG("PS")=$E(Y,1,45)
 S Y=$P(X,U,5),Y=$S(Y="":Y,$D(^DIC(Y,0))#2:$P(^(0),U),1:" "_Y),INSG("FL")=$E(Y,1,45)
 S Y=$P(X,U,8),INSG("MF")=$E($P(X,U,8),1,30)
 S INSG("IF")=$E($P(X,U,18),1,30)
 S INSG("IV")=$E($P(X,U,19),1,30)
 S INSG("UD")=$P(X,U,12)
 S Y=$P(X,U,7),INSG("LP")=$S(Y="":Y,$D(DXS(20,Y)):DXS(20,Y),1:Y)
 S Y=$P(X,U,10),INSG("ML")=$S(Y="":Y,$D(DXS(18,Y)):DXS(18,Y),1:Y)
 S Y=$P(X,U,6),INSG("TP")=$E($P(X,U,6),1,30)
 S X=$G(^INTHL7M(D0,1,D1,3)),INSG("RT")=$E(X,1,100)
 D INFIELD^INHMG2(.INSG,D0,D1,INCOMSEG)
 Q
 ;-------------------------------------------------------------
RPTRANS(D0,XHDR,INOSTAT) ;compile and display transaction types
 ;Input:
 ;  D0  - ien of the message in the scripting generator message file
 ;  XHDR-  mumps code (for more info refer to WTRANS sub-rotuine)
 ;  INOSTAT - if set do not show the active/inactive status of transactions
 ;Output:
 ;  display the transaction types
 ; Note : this sub-routine is called from
 ;          INBUILD^INHMG1 routine and
 ;          [INHSG MESSAGE] print template
 ;
 N INRES
 D GTRANS(D0,.INRES)
 D WTRANS(.INRES,XHDR,$G(INOSTAT))
 Q
 ;
GTRANS(D0,INRES) ; get the list of transacions for a given message
 ;Input :
 ;  D0  - ien of the message in the scripting generator message file
 ;INRES -  name of the array or global, to put the transaction ien in
 ;Output :
 ;  INRES-  array containg the transaction list in its subscript.
 ;         INRES(child tran. ien)=""
 ;         INRES(child tran. replicated ien,  trans ien)=""
 ;
 ;
 N REPDEST,REPIEN,D1,TRNIEN,TRNODE,MRPIEN
 S REPDEST=+$O(^INRHD("B","HL REPLICATOR",0))  ; replicator ien in destination file
 ;   find the message's transaction in the scripting generator message
 ;   file
 S D1=0
 F  S D1=$O(^INTHL7M(D0,2,D1)) Q:'D1  D    ;loop thru transaction type multiple
 .S TRNIEN=+$G(^INTHL7M(D0,2,D1,0))    ; transaction ien
 .Q:'TRNIEN
 .S TRNODE=$G(^INRHT(TRNIEN,0))   ;interface transaction type node zero
 .S INRES(TRNIEN)=""
 .Q:$P(TRNODE,U,2)'=REPDEST       ;quit if NOT replicated transaction
 .;  loop thru "AC x-ref on originating transaction type in
 .;  interface message replication file
 .S MRPIEN=0
 .F  S MRPIEN=+$O(^INRHR("AC",TRNIEN,MRPIEN)) Q:'MRPIEN  D
 ..S REPIEN=+$P($G(^INRHR(MRPIEN,0)),U)
 ..S INRES(TRNIEN,REPIEN)=""
 ;
 Q
 ;
WTRANS(INRES,XHDR,INOSTAT) ;write the transactions
 ;Input:
 ;  INRES-  array containg the transaction list in its subscript.
 ;         INRES(child tran. ien)=""
 ;         INRES(child tran. replicated ien,  trans ien)=""
 ;  XHDR-  mumps code is used for page break and/or ask the user
 ;         if he/she want to coninue to abort.   e.g.
 ;           D N^INHMG1   or
 ;           D T^DIWW     when this is called from FileMan
 ;                        print template (transaction type)
 ;         in XHDR routines if user aborts, it should set
 ;         DUOUT to true, else is false or undefined
 ;  INOSTAT - if set to true do not show the active/inactive status of transactions
 ;
 N D0,ACTIVE,NAME,DEST,D1
 S D0=""
 F  S D0=+$O(INRES(D0)) Q:'D0!$G(DUOUT)  D
 .D GTRNDATA(D0,INOSTAT,.NAME,.ACTIVE,.DEST)
 .X XHDR
 .W NAME,?70,ACTIVE
 .I $G(DEST)'="" X XHDR W ?22,"Destination: ",DEST
 .S D1=""
 .F  S D1=+$O(INRES(D0,D1)) Q:'D1!$G(DUOUT)  D
 ..D GTRNDATA(D1,INOSTAT,.NAME,.ACTIVE,.DEST)
 ..X XHDR
 ..W "--->",NAME,?70,ACTIVE
 ..I $G(DEST)'="" X XHDR W ?22,"Destination: ",DEST
 Q
 ;
GTRNDATA(TRNIEN,INOSTAT,NAME,ACTIVE,DEST) ;get some field values for
 ;Input:
 ;  TRNIEN   -  transaction ien
 ;  INOSTAT -   if true, set the active/inactive status to null
 ;Output:
 ;  NAME     -  transaction name
 ;  ACTIVE   -  "ACTIVE" if trans is active, else null
 ;  DEST     -  destination name
 N NODE
 S NODE=$G(^INRHT(TRNIEN,0))
 S NAME=$P(NODE,U)
 S ACTIVE=$S(INOSTAT:"",$P(NODE,U,5)=1:"active",1:"inactive")
 S DEST=$P($G(^INRHD(+$P(NODE,U,2),0)),U)
 Q
 ;
