INHD ; cmi/flag/maw - FRW,DGH,JSH 29 Aug 97 08:42 Interface Input Driver 07 Oct 91 6:44 AM ; [ 09/09/2004  1:23 PM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1,12**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;cmi/maw modified STORE sub to strip off |CR|
 ;
NEWO(DEST,G,ACK,TT,MID,%OUT,INORDUZ,INORDIV,INUIF6,INUIF7,INMIDGEN) ;Make a new outgoing entry
 ;INPUT:
 ;DEST   = Entry # of a destination (file #4005)
 ;G      = Global reference of lines of data:   $G@(n) n=1,2,3,...
 ;ACK    = Acknowledge required (0 = NO, 1 = YES)
 ;TT     = Originating Transaction Type (file #4000)
 ;MID    = Message ID
 ;%OUT   = Allow output controller to process (0=yes 1=no)
 ;INORDUZ = originating user, ien to USER file #3
 ;INORDIV = originating division, 
 ;          ien to MEDICAL CENTER DIVISION file 40.8
 ;INUIF6 = (opt) See INDA.
 ;INUIF7 = (opt) See INA.
 ;INMIDGEN = message ID of originating message (from node 0 piece 5)
 ; INA      - (opt) Selected subnodes of INA array are merged into
 ;                  the outbound msg after outbound script execution.
 ;                  Used by application teams' screening logic
 ;                  (@INA@("node")).  Data may already reside in
 ;                  INUIF7.
 ; INDA     - (opt) INDA array is merged into the outbound msg as it
 ;                  exists prior to outbound script execution.  Used
 ;                  by appl. teams' screening logic (@INDA@("node")).
 ;                  Data may already reside in INUIF6.
 ;
 ;OUTPUT:
 ;Function value - entry # in UIF or -1 (if error)
 ;
 S X="ERROR^INHD",@^%ZOSF("TRAP")
 I '$G(DEST)!($G(G)="")!($G(ACK)="")!'$G(TT) Q -1
 Q:'$D(^INRHD(DEST)) -1
 N H,C,I,X,DA,DIC,DR,TIME,SRC,DO,Y,DIC,DD,DIE,DLAYGO,INHNOW
 ;cmi/anch/maw 9/8/2004 made a change to call FILE^DICN
 ;S X="NOW",DLAYGO=4001,DIC="^INTHU(",DIC(0)="FL" D ^DICN  ;cmi/maw orig
 D NOW^%DTC S INHNOW=$G(%)
 K DD,DO S X=INHNOW,DLAYGO=4001,DIC="^INTHU(",DIC(0)="L" D FILE^DICN  ;cmi/anch/maw new
 I Y<0 D FAILO Q -1
 S DA=+Y L +^INTHU(DA)
 N INMID,INDEST,INSRC,ING,INNEACK,INDIR,INNEOUT,INTT,INORGIEN
 S INMIDGEN=$G(INMIDGEN)
 S INMID=MID,INDEST=DEST,ING=G,INNEACK=ACK,INDIR="OUT",INNEOUT=$G(%OUT),INSRC="",INTT=TT S INORGIEN=$S('$L(INMIDGEN):"",1:$O(^INTHU("C",INMIDGEN,0)))
 S DIE="^INTHU(",DR="[INH MESSAGE NEW]" D ^DIE
 I $D(INUIF6) M ^INTHU(DA,6)=INUIF6
 I '$D(INUIF6),$D(INDA) M ^INTHU(DA,6)=INDA
 I $D(INUIF7) M ^INTHU(DA,7)=INUIF7
 I '$D(INUIF7) D
 . I $D(INA("DMISID")) M ^INTHU(DA,7,"DMISID")=INA("DMISID")
 . I $D(INA("MSGTYPE")) M ^INTHU(DA,7,"MSGTYPE")=INA("MSGTYPE")
 D STORE
 L -^INTHU(DA)
 Q DA
 ;
STORE ;Store text in message file (INTHU)
 ;INPUT:
 ;  DA - ien in INTHU
 ;  G - location (array) of message
 ;  DEST, %OUT, TT (opt)
 ;OUTPUT:
 ;  TT - ien of Transaction Type
 ;  TIME - time to process ($H format)
 ;
 N C,I,J
 ;cmi/maw added next 3 lines to strip |CR| off of X12 messages
 I $G(BHLMIEN),$P($G(^INTHL7M(BHLMIEN,0)),U,12)="X12" D
 . S (C,I)=0 F  S I=$O(@G@(I)) Q:'I  S C=C+1,^INTHU(DA,3,C,0)=$P(@G@(I),"|CR|")_$S('$O(@G@(I,0)):"",1:"") I $O(@G@(I,0)) D
 .. S J=0 F  S J=$O(@G@(I,J)) Q:'J  S C=C+1,^INTHU(DA,3,C,0)=$P(@G@(I,J),"|CR|")_$S('$O(@G@(I,J)):"",1:"")
 I $G(BHLMIEN),$P($G(^INTHL7M(BHLMIEN,0)),U,12)'="X12" D
 . S (C,I)=0 F  S I=$O(@G@(I)) Q:'I  S C=C+1,^INTHU(DA,3,C,0)=$P(@G@(I),"|CR|")_$S('$O(@G@(I,0)):"|CR|",1:"") I $O(@G@(I,0)) D
 .. S J=0 F  S J=$O(@G@(I,J)) Q:'J  S C=C+1,^INTHU(DA,3,C,0)=$P(@G@(I,J),"|CR|")_$S('$O(@G@(I,J)):"|CR|",1:"")
 I '$G(BHLMIEN) D
 . S (C,I)=0 F  S I=$O(@G@(I)) Q:'I  S C=C+1,^INTHU(DA,3,C,0)=$P(@G@(I),"|CR|")_$S('$O(@G@(I,0)):"|CR|",1:"") I $O(@G@(I,0)) D
 .. S J=0 F  S J=$O(@G@(I,J)) Q:'J  S C=C+1,^INTHU(DA,3,C,0)=$P(@G@(I,J),"|CR|")_$S('$O(@G@(I,J)):"|CR|",1:"")
 S ^INTHU(DA,3,0)="^^"_C_"^"_C
 D TIME,SET(TIME,DEST,DA,$G(%OUT))
 ;cmi/maw end of mods
 Q
 ;
NEW(MID,DEST,SRC,G,ACK,DIR,%OUT,INMIDGEN) ;Make a new entry from an outside program
 ;INPUT:
 ;MID    = Message ID of incoming message [REQD]
 ;           If ="^" then generate one and use it
 ;DEST   = Name of a destination (file #4005) [REQD]
 ;SRC    = Free Text source [REQD]
 ;G      = Global reference of lines of data:   $G@(n) n=1,2,3,... [REQD]
 ;ACK    = Acknowledge required (0 = NO, 1 = YES) [REQD]
 ;DIR    = Direction (I:default = Incoming, O = Outgoing) [OPT]
 ;%OUT   = Allow output controller to process (0:default = YES  1 = NO) [OPT]
 ;INMIDGEN = Message ID of originating message (node 0, piece 5)
 ;
 ;OUTPUT:
 ;Function - entry # in UIF (^INTHU) or -1 (if error)
 ;
 S X="ERROR^INHD",@^%ZOSF("TRAP")
 N TT,DIC,TIME,DO,X,Y,DA,DIC,DD,DIE,DR,DLAYGO
 I $G(DEST)=""!($G(SRC)="")!($G(G)="")!($G(ACK)="")!($G(MID)="") D FAILR Q -1
 S DEST=$O(^INRHD("B",DEST,""))
 I MID'="^",'DEST D FAILR Q -1
 I $D(^INTHU("C",MID)) D FAILR Q -1
 I MID="^" S MID=$$MESSID
 S:$G(DIR)="" DIR="I" S DIR=$E(DIR) Q:"IO"'[DIR -1
 S X="NOW",DLAYGO=4001,DIC="^INTHU(",DIC(0)="FL" D ^DICN
 I Y<0 D FAILR Q -1
 S DA=+Y L +^INTHU(DA)
 N INMID,INDEST,INSRC,ING,INNEACK,INDIR,INNEOUT,INTT,INORGIEN
 S INMIDGEN=$G(INMIDGEN)
 S INMID=MID,INDEST=DEST,INSRC=SRC,ING=G,INNEACK=ACK,INDIR=DIR,INNEOUT=$G(%OUT),INTT="" S INORGIEN=$S('$L(INMIDGEN):"",1:$O(^INTHU("C",INMIDGEN,0)))
 S DIE="^INTHU(",DR="[INH MESSAGE NEW]" D ^DIE
 D STORE
 L -^INTHU(DA)
 Q DA
 ;
FAILR ;Creation of UIF entry by a receiver ( NEW ) failed
 N ERROR
 D ERRMES
 D ENR^INHE("",.ERROR)
 Q
FAILO ;Creation of UIF entry by NEWO failed
 N ERROR,INBZ,INBNZ
 D ERRMES
 ;Call appropriate erorr module
 S INBZ=+$G(INBPN),INBNZ=$P($G(^INTHPC(INBZ,0)),U,1)
 ;I INBZ=1 D ENO^INHE(
 ;I INBZ=2 D ENF^INHE(
 ;I INBNZ["RECE" D ENR^INHE("",.ERROR)
 ;I INBNZ["TRANS" D ENT^INHE(
 ;D ENR^INHE("",.ERROR)  ;cmi/anch/maw 9/8/2004 this is a bug
 D ENR^INHE(+$G(INBPN),.ERROR)  ;cmi/anch/maw 9/8/2004 this is the fix
 ;
 Q
ERRMES ;Set up "creation failed" error message
 S ERROR(1)="UIF entry creation failed:"
 S ERROR(2)=" DEST = '"_$G(DEST)_"'",ERROR(3)=" SOURCE = '"_$G(SRC)_"'",ERROR(4)=" MESS ID = '"_$G(MID)_"'",ERROR(5)=" Global Ref = '"_$G(G)_"'"
 Q
 ;
MESSID() ;Function to return a unique Message ID
 N X,Y
 L +^INTHU("MESSID")
M1 S X=$G(^INTHU("MESSID"))+1,^("MESSID")=X,Y=$P($G(^INRHSITE(1,0)),U,8)_X
 G:$D(^INTHU("C",Y)) M1
 L -^INTHU("MESSID")
 Q Y
 ;
ERROR ;Handle errors
 X ^INTHOS(1,3)
 D ENI^INHE($G(TT),$G(DEST),$$ERRMSG^INHU1)   ;CHECK CALL
 Q -1
 ;
SET(INH,IND,INU,INO,INPRIO) ;Queue an entry into ^INLHSCH
 ;INPUT:
 ;INH = $H format of when [REQ]
 ;IND = destination entry # [REQ]
 ;INU = UIF entry # [REQ]
 ;INO = if defined and non-zero, suppress setting output queue [OPT]
 ;INPRIO = if defined, sets processing priority [OPT]
 ;TT - ien of Transaction Type
 ;
 Q:'$G(IND)!'$G(INU)!$G(INO)  Q:'$D(^INRHD(IND,0))!'$D(^INTHU(INU,0))
 N H,INP,X,Y,DIE,DR,DA,TT0,INDELQ
 ;Determine destination queue
 S INDELQ=$P(^INRHD(IND,0),U,12)
 S H=$P(INH,",",2) I $L(H)<5 S H=$E("00000",1,5-$L(H))_H
 S INH=$P(INH,",")_","_H
 ;Housekeeping messages may have no TT
 S TT0=$S('$D(TT):"",TT:^INRHT(TT,0),1:"")
 S INP=$S($D(INPRIO):+INPRIO,$L(TT0):+$P(TT0,U,16),1:0)
 S DR=".16////"_INP_";.19////"_INH,DIE="^INTHU(",DA=INU D ^DIE
 ;Place in destination queue AND exit
 I INDELQ S ^INLHDEST(IND,INP,INH,INU)="" Q
 ;Defaul to OUTPUT CONTROLLER queue
 S ^INLHSCH(INP,INH,INU)=""
 Q
 ;
TIME ;Get time to process. If STAT, set to 00000,00000
 ;INPUT:
 ;  DEST - ien of destination (req)
 ;  TT - ien of transaction type (optional)
 ;OUTPUT:
 ;  TT - ien of Transaction Type
 ;  TIME - time to process
 N TTP
 ;if outgoing, TT is defined. If incoming, get from destination
 I '$D(TT) S TT=$P(^INRHD(DEST,0),U,2)
 I 'TT S TIME=$H Q
 S TTP=$P(^INRHT(TT,0),U,15)
 I TTP="" S TIME=$H Q
 I TTP="STAT" S TIME="00000,00000" Q
 ;Handle relative times (ex. NOW+30S)
 I TTP["NOW",TTP["+" D
 .  N %,P,T S T=$P(TTP,"+",2)
 .  ;Only one measure (D,H,M, or S) is supported
 .  F %="S","M","H","D" I T[% S P(%)=+T Q
 .  S TTP=$$ADDT^%ZTFDT($$NOW^%ZTFDT,$G(P("D")),$G(P("H")),$G(P("M")),$G(P("S")))
 N X,Y,%DT S X=TTP,%DT="TRS" D ^%DT S TIME=$$CDATF2H^UTDT(Y)
 S:TIME<0 TIME=$H
 Q
