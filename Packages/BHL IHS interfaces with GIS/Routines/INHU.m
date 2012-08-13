INHU ;DGH,JSH; 19 Apr 99 11:53;Generic Interface utility routines 
 ;;3.01;BHL IHS Interfaces with GIS;**16**;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1988, 1989, 1990 SAIC
 ;
GRET(UIF,TT) ;Returns  retry interval^max # of retries
 ;for entry # UIF running transaction type TT
 N DEST,X,RR,MR S (RR,MR)=""
 G:'$G(TT) G1
 S RR=$P($G(^INRHT(+$G(TT),0)),U,10),MR=$P($G(^(0)),U,11)
 I RR]"",MR]"" Q RR_"^"_MR
G1 S DEST=+$P($G(^INTHU(+$G(UIF),0)),U,2)
 G:'DEST G2
 S:RR="" RR=$P($G(^INRHD(DEST,0)),U,5)
 S:MR="" MR=$P($G(^INRHD(DEST,0)),U,6)
 I RR]"",MR]"" Q RR_"^"_MR
G2 S:RR="" RR=$P(^INRHSITE(1,0),U,3)
 S:MR="" MR=+$P(^INRHSITE(1,0),U,2)
 Q RR_"^"_MR
 ;
ULOG(UIF,ACT,INMSG,REPUIF,INNOACT) ;Make an activity log entry in UIF
 ;UIF (required) = entry # in UIF
 ;ACT (required) = log action
 ;INMSG (opt) = array containing lines of message (passed by reference)
 ;       if $D(INMSG)<9 then INMSG contains a 1 line message
 ;REPUIF (opt) = Pointer to another UIF, used to track replicated
 ;               messages from UIF to multiple other UIFs.
 ;INNOACT (opt)= Boolean: 0 update message action,
 ;                        1 don't update message, only activity log.
 ;             (Used for selective routing suppression logging.)
 ;
 Q:'$D(^INTHU(UIF,0))  ;Quit if entry non-existent
 N DIC,DO,DINUM,DA,Y,DIE,DR,DUZ S DUZ=.5,DUZ(0)="@"
 S DA(1)=UIF,DIC="^INTHU("_DA(1)_",1,",DIC(0)="FL",X="""NOW"""
 S:'$D(^INTHU(UIF,1,0)) ^(0)="^4001.01DA^^"
 D ^DIC Q:Y<0  S (INZ,DA)=+Y
 I $G(ACT)]"" S DIE="^INTHU("_DA(1)_",1,",DR=".02///"_$E(ACT) S:$D(REPUIF) DR=DR_";.03////"_REPUIF D ^DIE D:$P(^INTHU(UIF,0),U,3)'=$E(ACT)
 . Q:$G(INNOACT)  S DIE="^INTHU(",DA=UIF,DR=".03////"_$E(ACT) D ^DIE
 Q:'$D(INMSG)
 S:$D(INMSG)=1 INMSG(1)=INMSG
 S (I,%)=0 F  S I=$O(INMSG(I)) Q:'I  S %=%+1,^INTHU(UIF,1,INZ,1,%,0)=INMSG(I)
 S ^INTHU(UIF,1,INZ,1,0)=U_U_%_U_%
 Q
 ;
ACKLOG(%M,%AM,%S,%L) ;Log an acknowledgement to a message
 ;%M  (reqd) = UIF entry # of current message
 ;%AM (reqd) = ID of message to acknowledge
 ;%S  (reqd) = ack status (0 = NAK, 1=ACK)
 ;%L  (opt)  = message to store if NAK
 ;
 Q:'$D(^INTHU(+$G(%M)))
 N AMID,MESS,STAT
 S AMID=$O(^INTHU("C",%AM,0)) Q:'AMID
 S $P(^INTHU(%M,0),U,7)=AMID
 S $P(^INTHU(AMID,0),U,6)=%M,STAT=$S('%S:"K",1:"C")
 S DIE="^INTHU(",DA=AMID,DR=".03///"_STAT D ^DIE
 I %S S MESS(1)="Positive Acknowledge received"
 I '%S S MESS(1)="Negative Acknowledge received" S:$G(%L)]"" MESS(2)=%L
 S MESS(1)=MESS(1)_" in transaction with ID="_$P(^INTHU(%M,0),U,5)_" for transaction with ID="_%AM
 D:'%S ENK^INHE(AMID,.MESS)
 D ULOG^INHU(AMID,STAT,.MESS)
 Q
 ;
PIECE(%L,%D,%N) ;Function to get a piece of a line that may be over 250 characters long
 ;%L = variable (passed by reference with overflow nodes)
 ;%D = delimiter
 ;%N = piece number
 Q:$D(%L)<9 $P(%L,%D,%N)
 N I,L1,X,L0 S L0=$L(%L,%D)
 Q:L0>%N $P(%L,%D,%N)
 Q:L0=%N $P(%L,%D,%N)_$P($G(%L(1)),%D)
 F I=1:1 Q:'$D(%L(I))  S L1=$L(%L(I),%D)-1 D  Q:$D(X)
 . I L1+L0'<%N S X=$P(%L(I),%D,%N-L0+1) S:L0+L1=%N X=X_$P($G(%L(I+1)),%D) Q
 . S L0=L0+L1
 Q $G(X)
 ;
EXTRACT(%L,%1,%2) ;Function to extract from a line that may be over 250 characters
 ;%L = variable (passed by reference with overflow nodes)
 ;%1 = starting position
 ;%2 = ending position
 S:'$D(%2) %2=%1
 Q:$D(%L)<9!($L(%L)'<%2) $E(%L,%1,%2)
 N L0,L1,I,X S X=""
 S L0=$L(%L) I L0'<%1 S X=$E(%L,%1,L0)
 F I=1:1 Q:'$D(%L(I))  S L1=$L(%L(I)) D  Q:L0+L1'<%2  S L0=L0+L1
 . I X="",L0+L1'<%1 S X=$E(%L(I),%1-L0,%2-L0)
 . I %1'>L0 S X=X_$E(%L(I),1,%2-L0)
 Q X
 ;
SETPIECE(%L,%D,%N,%X,%C) ;Set a piece in a line which may be more than 250 characters
 ;%L = variable (pass by reference with overflow nodes)
 ;%D = delimiter
 ;%N = piece #
 ;%X = data to place
 ;%C = current number of pieces (pass by reference)
 N Z,Y,I
 S $P(Z,%D,%N-%C+''%C)="",Z=Z_%X
S1 I $D(%L)<9 D  S %C=%N Q
 . S %L=$G(%L) I $L(%L)+$L(Z)<251 S %L=%L_Z Q
 . S Y=250-$L(%L),%L=%L_$E(Z,1,Y),%L(1)=$E(Z,Y+1,999)
 F I=0:1 Q:'$D(%L(I+1))
 I $L(%L(I))+$L(Z)<251 S %L(I)=%L(I)_Z,%C=%N Q
 S Y=250-$L(%L(I)),%L(I)=%L(I)_$E(Z,1,Y),%L(I+1)=$E(Z,Y+1,999),%C=%N
 Q
 ;
CONCAT(%L,%X,%D) ;Concatenate a string onto another with length greater than 250
 ;%L = variable to add to (pass by value with overflow nodes)
 ;%X = data to concatenate
 ;%D = 1 if delimter is used  ;added by dgh for test
 N L0,Z,%C,%N
 ;;S Z=%X,%N=0 G S1 ;;commented out by dgh, following inserted
 ;S Z=DELIM_%X,%N=0 G S1
 S Z=$S($G(%D):DELIM_%X,1:%X),%N=0 G S1
 ;
REPLCE(%L,%X,%P) ;Replace a portion of a string
 ;For fixed length, non-delimited strings, this function replaces
 ;a portion of the data (e.g. a fixed length field in the string)
 ;with a new value. Both old and new lengths must be the same.
 ;%L = Current string
 ;%X = data to insert
 ;%P = starting position to insert
 N LEN
 S LEN=$L(%X)
 Q
ECHK(UIF) ;Resolve errors for UIF entry 
 ;UIF = entry # in file 4001
 Q:X'="C"
 N INI
 S INI=0 F  S INI=$O(^INTHER("U",UIF,INI)) Q:'INI  I $D(^INTHER(INI,0)) K ^INTHER("AE",0,INI) S $P(^INTHER(INI,0),"^",10)=1,^INTHER("AE",1,INI)=""
 Q
 ;
MAIL ;Input Xform on MAIL RECIPIENT field in file #4005
 N XMY,XMDUZ,DIC,DA,Y,INX,XMLOC
 K:$E(X,1,2)="G."!($E(X,1,2)="g.")&(X'["@") X
 S XMDUZ=0 D WHO^XMA21 K:'$D(XMY) X S:$D(X) X=$O(XMY(""))
