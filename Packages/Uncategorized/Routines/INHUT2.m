INHUT2 ; cmi/flag/maw - 16 Oct 98 15:11 GIS utilities ; [ 05/09/2002 11:06 AM ]
 ;;3.01;BHL IHS Interfaces with GIS;**1**;JUN 01, 2002
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q
 ;
ISNAMSPC(X) ;is the value properly name spaces according to current
 ;GIS specifications
 N NAMSPC,PATMAT,RON,ROF
 I " HL HL7 DGM TEST "[(" "_$P(X," ")_" ") Q 1
 S RON=$P(DIJC("RON")," ",2),ROF=$P(DIJC("ROF")," ",2)
 S @("RON="_RON),@("ROF="_ROF)
 ;Modified for IHS
 W RON_"Invalid Name-space!"_ROF S Y=.01 Q 0
 ;D MESS^UTWRD(RON_"Invalid Name-space!"_ROF) S Y=.01 Q 0
 ;
ISNS(X) ;is the input value properly name spaced
 ;input:
 ;  X --> input value of the .01 field
 ; "Grandfather" existing Transactions and Destinations
 ;cmi/flag/maw modified for namespace type
 N INAME,INDAD S INDAD=0
 F I=1:1 S INAME=$T(EXCLUDE+I) Q:INAME'[";;"  D  Q:INDAD
 .I $P(INAME,";;",2)=X S INDAD=1
 Q:INDAD 1
 Q:$P(X," ")="" 0
 ;Q $O(^INRHNS("B",$P(X," "),""))
 I $O(^INRHNS("B",$P(X," "),""))="" Q 0
 I $O(^INRHNS("B",$P(X," ",3),""))="" Q 0
 I $O(^INRHNS("ADS",$P(X," ",2),""))="" Q 0
 Q 1
 ;
EXCLUDE ;List of existing entries to exclude from namespace requirement
 ;;ANATOMIC PATHOLOGY
 ;;MASTER FILE NOTIFICATION
 ;;IV ORDER
 ;;LAB ORDER
 ;;PATIENT APPOINTMENT
 ;;PRESCRIPTION
 ;;RAD ORDER
 ;;RADIOLOGY PROCEDURE
 ;;INCOMING ACK
 ;
MHC(X) ;Return number embedded in string value of MHCMIS .01 field
 ;1-Called from ISNS to validate entry to Int. Destination File.
 ;2-Called from MHCMIS transmitter (INHVMTR) to identify correct dest.
 ;3-Called from Input Transform of MHCMIS SITE PARAMTER FILE
 ; INPUT: X=String value of .01 field
 ; RETURN: Number embedded in the string
 ;Allow the basic MHCMIS entry for Int. Dest. File.
 ;Basic MHCMIS entry corrosponds to IEN 1 of MHCMIS SITE PARM FILE
 I X="MHCMIS" Q 1
 ;Force other MHCMIS entries to include a number
 S OK=$TR(X,"ABCDEFGHIJKLMNOPQRSTUVWXYZ()/ ","")
 Q OK
 ;
MSG ;message display for Interface Name Space control
 N HON,HOF,INI,DWLRF,DWLB,DY
 S HON=$P(DIJC("H")," ",2),HOF=$P(DIJC("L")," ",2)
 S @("HON="_HON),@("HOF="_HOF)
 S INI="",DY=$Y-1,DWLRF="INS",DWLB="2^"_DY_"^10^78",DWL="SWZF"
 S @DWLRF@(1)=" Valid Name-spaces:"
 F I=2:1 S INI=$O(^INRHNS("B",INI)) Q:INI=""  D
 .S @DWLRF@(I)="     "_HOF_INI_HON,@DWLRF@(I,0)=""
 D ^DWL W HOF
 Q
 ;
UNIQUE(X) ;See if ID is being used already
 ; Input:
 ; X --> input value of Unique ID
 ; Returns 0-ID does not exist
 ;         1-ID exists
 Q '$D(^INRHT("ID",X,DA))
UNQ(DA) ;Set unique ID Called from DD 4000,.01
 ; DA - IEN
 N INCNT,INID,%VOL,X,DR,DIE,INLAST
 N DG,DB,DIL,DLB,DIE17,DGO,DOW,DNM,DQ,DIEZ,D0,D1,D2,D3,D4,D5,D6,D7,X
 I $P(^INRHT(DA,0),U,4)="" D
 .S %VOL=$G(^%ZOSF("VOL")),%VOL=$E(%VOL,$L(%VOL))
 .S:%VOL="" %VOL="?"
 .S INLAST=%VOL_999
 .S INID=$O(^INRHT("ID",INLAST),-1),INCNT=+$E(INID,2,4)+1
 .S INCNT=%VOL_$$PAD(INCNT,3,0)
 .S DR=".04///^S X=INCNT",DIE="^INRHT("
 .D ^DIE
 Q
CONV ;Conversion routine to add unique id's
 N DA
 S DA=0 F  S DA=$O(^INRHT(DA)) Q:'DA  S $P(^INRHT(DA,0),U,4)=""
 S DA=0 F  S DA=$O(^INRHT(DA)) Q:'DA  D UNQ(DA)
 Q
PAD(X,Y,Z) ;Pad front with whatever you want to pad with
 ; input: X - String you are padding
 ;        Y - Pad to this size
 ;        Z - What to PAD it with
 N INHPAD
 S INHPAD="",$P(INHPAD,Z,Y+1)="",X=$E(X,1,Y)
 Q $E(INHPAD,1,Y-$L(X))_X
FMHELP(DP,D) ;Fileman help utility
 ; DP - File/Sub file Number
 ; D - Field Number
 N DZ,DQ,DV,DG,%,%X,Z,X,DIE2,DL,Y,DIC,DIE,DU
 S (DIC,DIE)=$G(^DIC(DP,0,"GL")),DIC(0)="E"
 S (X,DZ)="?",DQ=1,DQ(1)=$G(^DD(DP,D,0))
 ; If not a multiple
 I '$P(DQ(1),U,2) S DV=$P(DQ(1),U,2)
 S DU=$P(DQ(1),U,3)
 D Q^DIE2
 Q
PARSEG(INSRCTL,INSEGNM) ; Parse a segment
 ; INPUT:
 ;   INSRCTL (required):
 ;      Array containing the raw segment data to be parsed
 ;      located under the HL7 namespaced node represented by
 ;      the second parameter.
 ;       ex. INSRCTL("MSH")=...
 ;   INSEGNM HL7 segment name (required):
 ;      Valid HL7 segment name to be used to identifiy which
 ;      node of the input array will be parsed.
 ;       ex. PARSEG^INHUT2(.INSRCTL,"MSH")
 ;      where INSRCTL("MSH")="MSH^\|~&^^^^..."
 ;
 ; OUTPUTS:
 ;   INSRCTL("Segment Name"_"Field number"): Field value found in segment
 ;      NOTE: This output is raw HL7 format, not FileMan/CHCS format.
 ;
 Q:'$L($G(INSEGNM))
 Q:'$D(INSRCTL(INSEGNM))
 N INDELIM,INCOMP,INSUBCOM,INREP,INOFFSET,INSEG
 S INDELIM=$G(INSCTRL("INDELIM")),INCOMP=$G(INSRCTL("INCOMP"))
 S INSUBCOM=$G(INSRCTL("INSUBCOM")),INREP=$G(INSRCTL("INREP"))
 ;If delimiters are not defined get them
 I INDELIM=""!(INCOMP="")!(INSUBCOM="")!(INREP="") D  ;
 . I $D(INSRCTL("MSH")) S INDELIM=$E(INSRCTL("MSH"),4),INCOMP=$E(INSRCTL("MSH"),5),INSUBCOM=$E(INSRCTL("MSH"),6),INREP=$E(INSRCTL("MSH"),7)
 . E  S INDELIM=$$FIELD^INHUT,INCOMP=$$COMP^INHUT,INSUBCOM=$$SUBCOMP^INHUT,INREP=$$REP^INHUT
 . S INSRCTL("INDELIM")=INDELIM,INSRCTL("INCOMP")=INCOMP,INSRCTL("INSUBCOM")=INSUBCOM,INSRCTL("INREP")=INREP
 Q:INDELIM=""!(INCOMP="")
 ;If MSH, field numbering is a tiny bit different.
 S INOFFSET=$S(INSEGNM="MSH":2,1:1),INFIELDS=$L(INSRCTL(INSEGNM),INDELIM)
 M INSEG=INSRCTL(INSEGNM)
 F INFLD=INOFFSET:1:INFIELDS S INSRCTL(INSEGNM_INFLD)=$$PIECE^INHU(.INSEG,INDELIM,.INFLD)
 D:$D(INSRCTL(INSEGNM))>9  ;
 .  F I=1:1 Q:'$D(INSRCTL(INSEGNM,I))  D
 . . S INFIELDS=$L(INSRCTL(INSEGNM,I),INDELIM)+INFLD
 . . F INFLD=INFLD:1:INFIELDS S INSRCTL(INSEGNM_INFLD)=$$PIECE^INHU(.INSEG,INDELIM,.INFLD)
 M INSRCTL(INSEGNM)=INSEG
 Q
GETSEG(UIF,INSEGNM,INSTANCE) ; Get segment from UIF
 ; Called by S INSRCTL("MSH")=$$GETSEG^INHUT(12345,"MSH")
 ;
 ; INPUTS:
 ;  UIF (required): The IEN of the UIF from which to extract the segment.
 ;  INSEGNM (required): 
 ;    The valid HL7 segment name to be used to identify 
 ;    which node of the UIF is requested. 
 ;  INSTANCE (optional, default=1)
 ;   The instance of the segment desired.
 ;
 ; OUTPUT:
 ;  0 If segment not found,
 ;  1 if segment found in message,
 ;
 ;  INSRECTL(INSEGNM)
 ;    Returns the Segment requested.  (With overflow) in the INSRCTL array.
 ;
 Q:$G(UIF)="" 0 Q:$G(INSEGNM)="" 0
 N INLINE,INDATA,INCR,INCNT
 K INSRCTL(INSEGNM)
 S INLINE=0,INCNT=0 S:'$G(INSTANCE) INSTANCE=1
 F  D GETLINE^INHOU(UIF,.INLINE,.INDATA,0,.INCR) Q:'$D(INDATA)  D
 .  I $E(INDATA,1,3)=INSEGNM S INCNT=INCNT+1 M:INCNT=INSTANCE INSRCTL(INSEGNM)=INDATA Q
 Q (0<$D(INSRCTL(INSEGNM)))
BPSTAT(INBKGNM,INSRVR) ;-determine status of GIS background process, given name
 ;Input:  INBKGNM - name of background process to determine status
 ;        INSRVR  - server number (not currently supported)
 ;Output:  Status message string of given background process name
 ;        piece 1 =>  status  (1 - running ; 0 - not running)
 ;        piece 2 =>  status message
 ;        piece 3 =>  last run update  ($H format)
 ;        piece 4 =>  last time a message was processed ($H format)
 ;        piece 5 =>  ien of background process
 ;
 N INBKGIEN,INBKGST,INBGKSTR
 I $G(INBKGNM)="" Q "0^Process name not specified"
 S INBKGIEN=$O(^INTHPC("B",INBKGNM,0))
 I 'INBKGIEN Q "0^Unknown Process"
 I '$P($G(^INTHPC(INBKGIEN,0)),U,2) Q "0^Process inactive^^^"_INBKGIEN
 S INBKGST=$$VER^INHB(INBKGIEN)
 S INBKGSTR=$S(INBKGST=1:"1^Running",INBKGST=-1:"0^Signaled to Terminate",1:"0^Not Running")
 S INBKGSTR=INBKGSTR_U_$P($G(^INRHB("RUN",INBKGIEN)),U,1)_U_$P($G(^INRHB("RUN",INBKGIEN)),U,3)_U_INBKGIEN
 Q INBKGSTR
 ;
