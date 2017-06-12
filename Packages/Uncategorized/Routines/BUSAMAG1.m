BUSAMAG1 ;ISI/HS/MLS-SPECIAL CODE FOR VISTA IMAGING AUDITING ; 31 Jan 2013  9:53 AM
 ;;1.0;IHS USER SECURITY AUDIT;;Nov 05, 2013;Build 65
 Q
 ;
 ; Find value located inside RPC parameter INPUT list
 ;
 ; INPUT: RPARAM = RPC Param
 ;         MATCH = String to look for
 ;         DELIM = If value needs to be parsed, provide delimeter
 ;            PC = If value needs to be parsed, provide $P #
 ;          LEAD = if EQ is null then use "[" contain match, if EQ=1 use leading char match
 ; OUTPUT:  located input value, returned via "OUT" variable
 ;
 ; EXAMPLE:  S X=$$ARRAY~BUSAMAG1(4,"IDFN",U,3)
ARRAY(RPARAM,MATCH,DELIM,PC,LEAD) ;EP
 N $ETRAP,$ESTACK S $ETRAP="D ERR^BUSAMAG1"
 N Y,Z,EXIT,OUT,ARRAY,INDIR
 K ARRAY S (OUT,EXIT)=0
 I $G(RPARAM)="" S OUT=-1 Q OUT
 S LEAD=+$G(LEAD)
 I $G(XWB(5,"P",RPARAM))="" S OUT=-1 Q OUT
 S INDIR=$G(XWB(5,"P",RPARAM)),INDIR=$TR(INDIR,".","")
 M ARRAY=@INDIR
 I $G(MATCH)="" S OUT=-1 Q OUT
 S DELIM=$G(DELIM)
 S PC=$G(PC) I +PC="" S PC=1
 S Y="" F  S Y=$O(ARRAY(Y)) Q:(Y=""!(EXIT))  D
 . I ARRAY(Y)[MATCH D
 . . I LEAD D  Q
 . . . N CHECK
 . . . S CHECK="1"""_MATCH_""".E"
 . . . I $G(ARRAY(Y))'?@CHECK Q  ; looks for leading char matches
 . . . S Z=$G(ARRAY(Y)) S OUT=Z
 . . . I DELIM'="" S OUT=$P(Z,DELIM,PC)
 . . . S EXIT=1
 . . . Q
 . . S Z=$G(ARRAY(Y)) S OUT=Z
 . . I DELIM'="" S OUT=$P(Z,DELIM,PC)
 . . S EXIT=1
 . . Q
 . Q
 Q OUT
 ;
 ; Find value located inside RPC RETURN value list
 ;
 ; INPUT:    LOC = $P location of match token
 ;        DELIM1 = delimiter used to find match token  
 ;        MATCH  = value of match token to look for (identifying string)
 ;        DELIM2 = If return value needs to be parsed, provide delimeter
 ;            PC = If return value needs to be parsed, provide $P location (place of value returned)
 ; OUTPUT:  located output value, returned via "OUT" variable
 ;
 ; EXAMPLE:  S X=$$RLIST~BUSAMAG1(1,"|","STUDY_PAT","|",2)
 ;           Where 1 (LOC) is the "|" (DELIM1) deliminated location to find the id/token string of "STUDY PAT" (MATCH)
 ;           and the value to be returned is stored in the 2nd "|" delimited piece.
 ; 
RLIST(LOC,DELIM1,MATCH,DELIM2,PC) ;EP
 N $ETRAP,$ESTACK S $ETRAP="D ERR^BUSAMAG1"
 N Y,Z,EXIT,OUT
 S (OUT,EXIT)=0
 I '$D(XWBY) S OUT=-1 Q OUT
 I $G(LOC)="" S LOC=0
 I $G(MATCH)="" S OUT=-1 Q OUT
 S DELIM1=$G(DELIM1)
 S DELIM2=$G(DELIM2)
 S PC=$G(PC) I +PC="" S PC=1
 S Y="" F  S Y=$O(XWBY(Y)) Q:(Y=""!(EXIT))  D
 . S Z=$G(XWBY(Y))
 . I Z'[MATCH Q
 . S OUT=Z
 . I LOC D  Q  ;check return string to see if specific piece matches search string
 . . I $P(Z,DELIM1,LOC)=MATCH D
 . . . I DELIM2'="" S OUT=$P(Z,DELIM2,PC)
 . . . S EXIT=1
 . . . Q
 . I DELIM2'="" S OUT=$P(Z,DELIM,PC)
 . S EXIT=1
 . Q
 Q OUT
 ;
 ; Check for redundant rpc/dfn/act calls
 ; INPUT: RPC = RPC NAME (#8994)
 ; DFN = PNT IEN (#2)
 ; ACT = ACTION value (#9002319.03,.03)
 ; OUTPUT: 0 - don't record
 ;         1 - record
 ;        -1 - error
 ;
 ; EXAMPLE:  S SKIP=$S($$REDUNCHK~BUSAMAG1("MAGG PAT INFO",+$G(XWB(5,"P",0)),"Q")=1:0,1:1)
 ;      
REDUNCHK(RPC,DFN,ACT) ;EP
 N OUT,SESSIEN S OUT=0
 Q:$G(RPC)="" OUT
 Q:$G(ACT)="" OUT
 Q:$G(DFN)="" OUT
 ; Check for MAG Session ID
 S SESSIEN=$S($G(MAGSESS):MAGSESS,$D(MAGJOB("SESSION")):MAGJOB("SESSION"),$G(TRKID)'="":$O(^MAG(2006.82,"E",TRKID,""),-1),1:0)
 ; Check Set top level XTMP node
 I '$D(^XTMP("BUSAMAG"_$J,0)) D
 . S ^XTMP("BUSAMAG"_$J,0)=(DT+1)_U_DT_U_"REDUNCHK~BUSAMAG1: Prevent redundant logging of RPC calls"
 . Q
 I $D(^XTMP("BUSAMAG"_$J,RPC,DFN,ACT)) D
 . I SESSIEN,$G(^XTMP("BUSAMAG"_$J,RPC,DFN,ACT))'=SESSIEN S ^XTMP("BUSAMAG"_$J,RPC,DFN,ACT)=SESSIEN,OUT=1 Q  ;different seession id: Record
 . S OUT=0 ;Don't record
 . Q
 I '$D(^XTMP("BUSAMAG"_$J,RPC,DFN,ACT)) S ^XTMP("BUSAMAG"_$J,RPC,DFN,ACT)=SESSIEN,OUT=1 ;Record
 Q OUT
 ;
ERR ;
 S OUT="-1^ERROR "_$$EC^%ZOSV
 D @^%ZOSF("ERRTN")
 Q:$Q 1
 Q
