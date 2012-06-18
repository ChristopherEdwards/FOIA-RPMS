INTSTR2 ;DGH; 5 Aug 97 14:20;Continuation of Required Field functions
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;
 Q  ;no top entry
 ;
LOOP(INUIF,LVL,UIFMES,UCNT,INCDEC,DEFMES,INERR) ;Recursive logic
 ;Compares message segment id at the current LVL
 ;with the UIF segment id at the current UCNT.
 ;INPUT:
 ;   INUIF = Entry in UIF being evaluated
 ;   LVL = level array LVL(1), LVL(2) set to segment being validated.
 ;   UIFMES = UIF message array.
 ;   UCNT = UIF array node being validated. UCNT is incremented inside
 ;          LOOP if MSID=USID. Otherwise, it stays the same.
 ;          Note that USID=UIFMES(UCNT)=segment id for the
 ;   INCDEC = 1 to increment levels and work deeper into nests
 ;          = 0 to decrement levels and back out of nests
 ;          required segments only checked if INCDEC=1
 ;   DEFMES = Defined message array.
 ;   INERR = (PRB) flag. Initialized=0, will be set to 1 or 2
 ;           if error conditions are found.
 ;INPUT not passed
 ;   INDELIM = delimiter. Must be local variable set previously
 ;   INSUBDEL = subdelimiter set of all but INDELIM.
 ;
 ;set arrays for comparison
 I $D(DEBUG) D
 .D IO^INTSTR("==========================================================")
 .D IO^INTSTR("Entering LOOP tag with UCNT= "_UCNT_" INCDEC= "_INCDEC)
 .D IO^INTSTR("LVL array:")
 .S QX=$Q(LVL) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D IO^INTSTR(INMSG)
 .F  S QX=$Q(@(QX)) Q:'$L(QX)  S INMSG=QX_"="_$G(@(QX)) D IO^INTSTR(INMSG)
 N MESS,CURLVL,CURCNT,ORD,USID,MSID,G,MREP,MREQ,OUT2
 Q:'$D(LVL)  Q:'UCNT
 S CURLVL=$O(LVL(""),-1),CURCNT=LVL(CURLVL) S:'$D(LCT) LCT=0
 ;If current level is 1 and current count=0, nothing left to do
 I CURLVL=1,CURCNT=0 Q
 S ORD="",I="" F  S I=$O(LVL(I)) Q:'I  D
 .S ORD=ORD_LVL(I)_","
 S G="DEFMES("_$E(ORD,1,($L(ORD)-1))_")"
 S MESS(0)=$G(@G@(0))
 S MSID=$P(MESS(0),U),MREP=$P(MESS(0),U,2),MREQ=$P(MESS(0),U,3),USID=UIFMES(UCNT)
 I $G(DEBUG)>1 D
 .S INMSG=G_"="_MESS(0) D IO^INTSTR(INMSG)
 .S INMSG="MSID= "_MSID_"  USID= "_USID_" Repeating= "_MREP_" Required="_MREQ D IO^INTSTR(INMSG)
 Q:'$L(MSID)
 ;For navigational segments, increment LVL and recurse
 I MSID="NAVIGATE" D  D LOOP(INUIF,.LVL,.UIFMES,.UCNT,.INCDEC,.DEFMES,.INERR) Q
 .;Navigational segment should be a "parent segment" with a level below
 .I $O(@G@(0)) S LVL(CURLVL+1)=1 Q
 .;If another level does not exist, increment at current level and
 .;see if node exists
 .S LVL(CURLVL)=CURCNT+1 S X=$$EXIST(.LVL,.DEFMES) Q:X
 .;If neither condition is met, back out
 .D FNDNXT(.LVL,CURLVL,.DEFMES)
 ;If this segment is not defined, print message, increment both the
 ;USID and LCT counters, and recurse.
 I '$D(DEFMES(USID)) S INMSG="Message contains unexpected segment "_USID,UCNT=$O(UIFMES(UCNT)) D GETLINE^INHOU(INUIF,.LCT,.LINE),IO^INTSTR(INMSG),LOOP(INUIF,.LVL,.UIFMES,.UCNT,.INCDEC,.DEFMES,.INERR) Q
 ;If segments match (FNDNXT may have reset MSID, MREQ and MREP)
 S MATCH=$S(MSID=USID:1,1:0)
 I MATCH D
 .I INEXPND S INMSG=$S(MREQ:"Required",1:"Optional")_" segment "_MSID_" found" D IO^INTSTR(INMSG)
 .S INCDEC=1
 .;Validate required fields if there are any
 .D VALID^INTSTR1(.LCT,.DEFMES,MSID,.UIFMES,UCNT,INUIF,.INERR)
 .;Check for repeating segments. Increment uif counter until
 .;segments no longer match.
 .S OUT=0 F  D  Q:OUT
 ..S UCNT=$O(UIFMES(UCNT)) I 'UCNT S OUT=1 Q
 ..S USID=$P(UIFMES(UCNT),U) I MSID'=USID S OUT=1 Q
 ..;S INMSG=$S('MREP:"Unexpected repeating ",1:"Repeating ")_MSID_" segment found" S:'MREP INERR=1 I INEXPND!'MREP D IO^INTSTR(INMSG)
 ..S INMSG="Repeating "_MSID_" segment found" I INEXPND D IO^INTSTR(INMSG)
 ..D VALID^INTSTR1(.LCT,.DEFMES,MSID,.UIFMES,UCNT,INUIF,.INERR)
 ;End of processing if segments match. At this point, the USID counter
 ;has been incremented to the next segment (if another segment exists).
 ;Quit if another segment does not exist. (But verify if another
 ;segment Should exist)
 ;Q:'UCNT
 ;Q:'$D(UIFMES(UCNT))
 S OUT=0 D
 .;If UCNT has value, we are still looping through segments
 .Q:UCNT
 .;Otherwise no more segments in message being checked
 .S OUT=1
 .;quit if no other level exists
 .Q:'$O(@G@(0))
 .;otherwise see if next level is required
 .S OUT2=0 F  D  Q:OUT2
 ..S LVL(CURLVL+1)=1 S X=$$EXIST(.LVL,.DEFMES,.MESS) I 'X S OUT2=1 Q
 ..;If next segment is navigational, look deeper
 ..I $P(MESS,U)["NAVIGATE" S CURLVL=CURLVL+1 Q
 ..I $P(MESS,U,3) S INMSG="Required segment "_$P(MESS,U,1)_" missing. Message ended abruptly.",INERR=2 D IO^INTSTR(INMSG) S OUT2=1
 Q:OUT
 ;Otherwise, fall through to recursive tag.
 ;
 ;If segment ids did not match, logic depends on whether we need
 ;to look deeper into nesting (INCDEC=1) or are backing out (INCDEC=0)
 D
 .I INCDEC D  Q
 ..;Check for required segment (only check going into nest)
 ..I 'MATCH,MREQ S INMSG="Required segment "_MSID_" missing, "_USID_" segment found in it's place" D IO^INTSTR(INMSG)
 ..;If another level exists, create another level counter. BUT don't
 ..;go into nest if segments didn't match.
 ..;First see if another level exists.
 ..I MATCH,$O(@G@(0)) D  Q
 ...S LVL(CURLVL+1)=1
 ..;Else another level doesn't exist, increment at current level
 ..;and see if node exists
 ..S LVL(CURLVL)=CURCNT+1 S X=$$EXIST(.LVL,.DEFMES) Q:X
 ..;If neither condition is met, set INCDEC=0 and back out
 ..S INCDEC=0
 ..I CURLVL>1 K LVL(CURLVL)
 .I 'INCDEC D
 ..;Test logic as of 4/28!!!!!
 ..D FNDNXT(.LVL,CURLVL,.DEFMES)
 ;Now that UCNT may have been incremented, and LVL definitely
 ;has been modified, loop recursively
 D LOOP(INUIF,.LVL,.UIFMES,.UCNT,.INCDEC,.DEFMES,.INERR)
 Q
 ;
FNDNXT(LVL,CURLVL,DEFMES) ;Find next "nest"
 ;If backing out of one nest, must find LVL at which another exists
 ;or recursion will continually traverse up and down same nest.
 ;INPUT:
 ; LVL=Level array
 ; LVL(CURLVL) = the current level in the LVL array
 ; DEFMES = the defined message array
 ;OUTPUT:
 ; A new LVL at which a defined message exists
 ; MREQ and MREP will be redefined if a match is found.
 N OUT,ID,REP,REQ
 ;If LVL=1, can't back out any further, increment LVL(1)
 I CURLVL=1 S LVL(1)=LVL(1)+1 Q
 S OUT=0 F  D  Q:OUT
 .;Kill current level to back out one level
 .K LVL(CURLVL)
 .;Identify the deepest remaining level and its current count
 .S CURLVL=$O(LVL(""),-1),CURCNT=LVL(CURLVL)
 .;Again see if back out to LVL=1, can't back out any further
 .I CURLVL=1 S LVL(1)=LVL(1)+1,OUT=1 Q
 .;At current backed out level, if MSID=USID, it's a repeating segment.
 .D MESSID(.LVL,.ID,.REP,.REQ) I ID=USID D  Q
 ..;Be sure segment is allowed to repeat
 ..I 'REP S INMSG="WARNING: Repeating segment "_ID_" is not defined as repeating" D IO^INTSTR(INMSG)
 ..S MSID=ID,MREP=REP,MREQ=REQ,OUT=1
 .;If no match on MSID, increment at this level and see if node exists.
 .;If not, this function will continue to kill levels.
 .S LVL(CURLVL)=CURCNT+1 S OUT=$$EXIST(.LVL,.DEFMES)
 Q
 ;
EXIST(LVL,DEFMES,MESS) ;Return whether node exists at current level
 ;INPUT:
 ; LVL=the current nesting level
 ; DEFMES = Defined message array
 ; MESS (OPT) (PBR) = returns the 0 node
 ;RETURN VALUE:
 ;  1=YES 0=NO
 S ORD="",I="" F  S I=$O(LVL(I)) Q:'I  D
 .S ORD=ORD_LVL(I)_","
 S G="DEFMES("_$E(ORD,1,($L(ORD)-1))_")"
 I $D(MESS) S MESS=$G(@G@(0))
 Q:$D(@G@(0)) 1
 Q 0
 ;
MESSID(LVL,ID,REP,REQ) ;Lookup message id for segment at current level
 ;This tag duplicates logic at LOOP+33, but it's too late in DIT
 ;to consolidate.
 ;INPUT:
 ; ID=MESSAGE ID
 ; LVL=LVL ARRAY
 ; REP=Repeatable?
 ; REQ=Required?
 N ORD,I,G,MESS
 S ORD="",I="" F  S I=$O(LVL(I)) Q:'I  D
 .S ORD=ORD_LVL(I)_","
 S G="DEFMES("_$E(ORD,1,($L(ORD)-1))_")"
 S MESS(0)=$G(@G@(0))
 S ID=$P(MESS(0),U),REP=$P(MESS(0),U,2),REQ=$P(MESS(0),U,3)
 Q
 ;
