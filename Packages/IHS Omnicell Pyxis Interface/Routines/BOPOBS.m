BOPOBS ;IHS/ILC/ALG/CIA/PLS - Admits, Check OP By Location;03-Apr-2007 13:35;SM
 ;;1.0;AUTOMATED DISPENSING INTERFACE;**1,3**;Jul 26, 2005
 ;
 ;CHECKIN
 ;
CHECKIN ;EP
 Q:'$G(DFN)  S BOPDFN=DFN
 ;
 ;BOPOLOC = Has 3 pieces as in "AEC^ER TREATMENT"
 ;$P(BOPOLOC,U)   = name of outpatient location entered by user.
 ;$P(BOPOLOC,U,2) = OUTPATIENT LOCATION name (from .01 field of
 ;                   field 10 [multiple] of the BOP Site Parameters).
 ;$P(BOPOLOC,U,3) = OP SEND LOCATION (field 1 of the OUTPATIENT
 ;                   LOCATION multiple above)
 ;
 Q:'$P($G(^BOP(90355,1,2)),U)  ;is adt active
 Q:'$P($G(^BOP(90355,1,2)),U,6)  ; is send outpatient adt active
 ;
 I '$D(BOPOLOC)#10 S BOPOLOC=""
 ;
 ;BOPPDIV=Pointer to file Site PArameters for Hospital Division
 ;         field 3 = receiving facility
 ;
 S U="^",BOPPDIV=$$PRIM^VASITE()
 I BOPPDIV S BOPPDIV=$O(^BOP(90355,1,3,"B",BOPPDIV,0))
 E  S BOPPDIV=$O(^BOP(90355,1,3,0))
 ;
 D INIT^BOPCAP Q:$D(BOPQ)
 D PID^BOPCP
 I D'=5 S BOP(.02)="A01",BOP(.04)="ADT"
 E  S BOP(.02)="A03",BOP(.04)="ADT"
 ; set bop(.03)=bopadm, which is x from ihs code with check in time
 S %DT="ST",X="N" D ^%DT S BOP(.03)=$G(BOPADM)
 ;
 ;$P(BOP10,u,2) = the outpatient 'ward'.  If there is a value in
 ;the "Default Outpatient Location" field of the BOP Site Parameters
 ;file, that is used.  Otherwise, the OP SEND LOCATION that belongs to
 ;the OUTPATIENT LOCATION is used.  Finally, 'AEC' is the default.
 ;Piece 11 is the Patient Type
 ;
 S BOPSALL="N"
 I $P($G(BOPLD),U,5)=1 S BOPSALL="Y"
 S BOP10=""
 I BOP10="",$L($P(BOPOLOC,U,2)) S BOP10="O^"_$P(BOPOLOC,U,2)
 I BOP10="" S BOP10="O^AEC"
 ;
 ;Call to create HL7 Message in BOP Queue file
 K BOPQ S BOPDIV=BOPPDIV
 D MSH^BOPCAP Q:$G(BOPQ)
 ;
 ;SET READY FLAG
 S $P(^BOP(90355.1,BOPDA,0),U,10)=0
 S ^BOP(90355.1,"AS",0,BOPDA)=""
 N DA,DIK S DA=BOPDA,DIK="^BOP(90355.1," D IX1^DIK K DA,DIK
 I +$G(^BOPDTG(1))=1 D
 .S A=$G(^BOPDTG(1,+$H,DFN,0)) Q:'A  S B=$G(^BOPDTG(1,+$H,DFN,A)),$P(B,"^",3)=BOPDA
 .S ^BOPDTG(1,+$H,DFN,A)=B
 .Q
 Q
BYLOC ;This entry point is for use in outpatient environments.
 D JOB^BOPOBS
 ;Check against BOP Site Parameters.
 ;If there is no table do not invoke Interface
 ;Otherwise send patients to the Interface if the location contains
 ;    a match to any character string in field 10 (multiple) and
 ;    use the "Send Location" field as the nursing unit.
 ;
 N L,X,Y,Z,K
 ;
 ;Z=Default Location
 ;BOPOLOC=.01 field of Patient Location file (44)
 ;
 N BOPLD S BOPLD=$G(^BOP(90355,1,"SITE"))
 ; this code is maintained for backward compatability
 ;
 I '$G(BOPOLOC) G BYNEW
 S K=$P($G(^SC(BOPOLOC,0)),U)
 S X=0,L=0
 F  S X=$O(^BOP(90355,1,"OPLOC",X)) Q:'X  S Y=^(X,0) D  Q:L
 .Q:K'[$P(Y,U)
 .S $P(K,U,2,3)=$P(Y,U,1,2),L=1
 I L=1 S BOPOLOC=K G CHECKIN
 ;
BYNEW ; skip around point for BOPOLOC
 ;
 ;  new lookup code
 ;
 I +$G(BOPOLOC)<1 S:$P(BOPLD,U,5) BOPOLOC=$P(BOPLD,U,6) G BYSEND
 I +$G(BOPOLOC)<1 Q
 S A=$O(^BOP(90355,1,"OPLOC","AC",+BOPOLOC,"")) I 'A G:$P(BOPLD,U,5) BYSEND Q
 S Y=$G(^BOP(90355,1,"OPLOC",A,0)) I $P(Y,U,3)'=+BOPOLOC G:$P(BOPLD,U,5) BYSEND Q
 S A=$P($G(^SC(+BOPOLOC,0)),U,1),$P(BOPOLOC,U,2)=A,$P(BOPOLOC,U,3)=$P(Y,U,2)
 I $P(BOPOLOC,U,3)="" S $P(BOPOLOC,U,3)=$P(BOPLD,U,4)
 G CHECKIN
 ;
BYSEND ;if send all is marked and location is not in 90355 file
 I +$G(BOPOLOC)<1 Q
 S A=$P($G(^SC(+BOPOLOC,0)),U,1),$P(BOPOLOC,U,2)=A,$P(BOPOLOC,U,3)=$P(BOPLD,U,4)
 G CHECKIN
 Q
 ; set up track file by date,dfn in order
JOB ; EP
 I +$G(^BOPDTG(1))'=1 Q
 I +$G(DFN)<1 Q
 S A=$G(^BOPDTG(1,+$H,+$G(DFN),0)),A=A+1,^BOPDTG(1,+$H,+$G(DFN),0)=A
 S ^BOPDTG(1,+$H,+$G(DFN),A)=$G(BOPOLOC)_"^"_$H
 Q
SDAM ;EP -  entry from the SDAM main event
 ; SDAMEVT = type of event
 ;    1=make appointment (unscheduled)
 ;    4=check in
 ;    8=disposition an application
 ;    9=disposition edit
 ; SDCL = clinic location (pointer to ^SC   file 44
 ; DFN patient internal number
 N BOPLIEN,QT,D
 S QT=0
 I $G(SDAMEVT)="" S SDAMEVT=$S($G(SDAPTYP):4,$G(ASD)=2:4,1:1)
 I $G(SDCL)="" S SDCL=$S($G(SDSC):SDSC,1:$P(SSC,U,1))
 S BOPADM="" S BOPADM=$G(SDPR) I BOPADM=""&($G(X)'="") S BOPADM=X ; clinic appt time
 I $G(X)'="" S BOPADM=X
 I $$GET1^DIQ(90355,1,316.5,"I") D  Q:QT
 .S D=SDAMEVT I D'=1&(D'=4)&(D'=5)&(D'=8)&(D'=9) K D S QT=1 Q
 E  D  Q:QT
 .S D=SDAMEVT I (D'=4)&(D'=5)&(D'=8)&(D'=9) K D S QT=1 Q
 N I,BOPOLOC,BOPDFN,DA,X,Y,A,B,C,BOPPLD,DIC,DIK,VADM,VAPA,%DT
 S BOPDFN=$G(DFN),BOPOLOC=$G(SDCL) N DFN S DFN=BOPDFN
 I $G(DFN)=0!($G(DFN)="") D  Q:$G(DFN)=""
 .I $G(SDFN)'="" S DFN=SDFN D  Q
 ..I $D(^XTMP("BOPDISP",DUZ,SDFN)) K ^XTMP("BOPDISP",DUZ,SDFN) Q
 .S DFN=$O(^XTMP("BOPDISP",DUZ,DFN)) Q:DFN=""  S BOPDFN=DFN K ^XTMP("BOPDISP",DUZ,DFN)
 I BOPOLOC="" D
 .S BOPREC="" S BOPREC=$O(^BOP(90355,0)) Q:BOPREC=""
 .S BOPOLOC=$P(^BOP(90355,BOPREC,0),U,14)
 Q:$G(BOPOLOC)=""
 D BYLOC
 K BOPOLOC,BOPDFN,DFN,DA,X,Y,A,B,C,BOPPLD,DIC,DIK
 K VADM,BOP,BOP0,BOP1,BOP10,VAPA,BOPBAT,BOPDA,VAERR,BOPDIV
 K BOPIT,BOPPDIV,BOPRAP,BOPVER,BOPWHO,BOPY
 Q
