PXRMLOG ; SLC/PKR - Clinical Reminders logic routines. ;15-Apr-2008 14:00;MGH
 ;;1.5;CLINICAL REMINDERS;**2,5,8,1005**;Jun 19, 2000
 ;
 ;=======================================================================
EVALPCL(FREQ,PCLOGIC,FIEVAL) ;Evaluate the Patient Cohort Logic.
 ;Determine the applicable frequency age range set.
 ;Get the baseline
 N MAXAGE,MINAGE
 N AGEFI,IND,FINDING,FLIST,FREQDAY,NAK,NOFREQ,NUMAFI
 N RANKAR,RANK,RANKFI,TEMP
 D MMF^PXRMAGE(.MINAGE,.MAXAGE,.FREQ,.FIEVAL)
 ;If there is no match with any of the baseline values FREQ=-1.
 ;If there was no frequency in the definition then FREQ="".
 ;
 ;See if any findings override the baseline.
 S TEMP=$G(^PXD(811.9,PXRMITEM,40))
 S NUMAFI=+$P(TEMP,U,1)
 ;If there are no age findings use the baseline.
 I NUMAFI=0 G ACHK
 S FLIST=$P(TEMP,U,2)
 F IND=1:1:NUMAFI D
 . S FINDING=$P(FLIST,";",IND)
 . I (FIEVAL(FINDING))&('$D(FIEVAL(FINDING,"EXPIRED"))) D
 .. S TEMP=^PXD(811.9,PXRMITEM,20,FINDING,0)
 .. S RANK=+$P(TEMP,U,5)
 .. I RANK=0 S RANK=9999
 .. S FREQDAY=$$FRQINDAY^PXRMDATE($P(TEMP,U,4))
 ..;If there is no frequency with this rank ignore it.
 .. I FREQDAY>0 S RANKAR(RANK,FREQDAY,FINDING)=""
 ;If there was a ranking use it otherwise use the greatest frequency.
 I '$D(RANKAR) G ACHK
 S RANK=0
 S RANK=+$O(RANKAR(RANK))
 S FREQDAY=+$O(RANKAR(RANK,""))
 S FINDING=+$O(RANKAR(RANK,FREQDAY,""))
 I FINDING>0 D
 . S TEMP=^PXD(811.9,PXRMITEM,20,FINDING,0)
 . S FREQ=$P(TEMP,U,4)
 . S MINAGE=$P(TEMP,U,2)
 . S MAXAGE=$P(TEMP,U,3)
 .;Remove the baseline age findings since they have been overridden.
 . K FIEVAL("AGE")
ACHK ;
 I FREQ="" D
 . S NOFREQ=1
 . S AGEFI=0
 . S ^TMP(PXRMPID,$J,PXRMITEM,"INFO","FREQ")="There is no reminder frequency!"
 E  D
 . S NOFREQ=0
 . I FREQ=-1 S AGEFI=0
 . E  S AGEFI=$$AGECHECK^PXRMAGE(PXRMAGE,MINAGE,MAXAGE)
 I 'AGEFI D
 . S ^TMP(PXRMPID,$J,PXRMITEM,"N/A","AGE")=""
 . S ^TMP(PXRMPID,$J,PXRMITEM,"INFO","AGE")="Patient does not meet any age criteria!"
 E  D
 .;Save the final frequency and age range for display.
 . S TEMP="Due every "_$$FMTFREQ^PXRMAGE(FREQ)_$$FMTAGE^PXRMAGE(MINAGE,MAXAGE)
 .;Use the z so this will be the last of the info text.
 . S ^TMP(PXRMPID,$J,PXRMITEM,"zFREQARNG")=TEMP
 ;
 ;Evaluate the patient cohort logic
 N FUNCTION,FUNLIST,NUM,PCLOG,PCLSTR,SEXFI,TEST,VAR
 D BFUNLIST^PXRMLOGF(.FUNLIST)
 S SEXFI=1
 S TEMP=$G(^PXD(811.9,PXRMITEM,32))
 S NUM=+$P(TEMP,U,1)
 S NAK=$C(21)
 S (PCLOG,PCLSTR)=$TR(^PXD(811.9,PXRMITEM,31),NAK,"^")
 S PCLOG=$$STRREP^PXRMUTIL(PCLOG,"SEX",SEXFI)
 S PCLOG=$$STRREP^PXRMUTIL(PCLOG,"AGE",AGEFI)
 S FLIST=$P(TEMP,U,2)
 F IND=1:1:NUM D
 . S FINDING=$P(FLIST,";",IND)
 . S TEMP="FI("_FINDING_")"
 . S PCLOG=$$STRREP^PXRMUTIL(PCLOG,TEMP,FIEVAL(FINDING))
 ;Look for functions that need values replaced.
 S FUN=""
 F  S FUN=$O(FUNLIST(FUN)) Q:FUN=""  D
 . S VAR=$P(FUNLIST(FUN),";",1)
 . S FUNCTION=$P(FUNLIST(FUN),";",2)
 . I PCLOG[FUNCTION D
 . F IND=1:1:NUM D
 .. S FINDING=$P(FLIST,";",IND)
 .. S TEMP="FI("_FINDING_","""_VAR_""")"
 .. S PCLOG=$$STRREP^PXRMUTIL(PCLOG,TEMP,$G(FIEVAL(FINDING,VAR)))
 I @PCLOG
 S TEST=$T
 ;Check for a dead patient.
 I +$G(^XTMP(PXRMDFN,"DOD"))>0 S PCLOGIC=0_U_PCLSTR_U_PCLOG
 E  S PCLOGIC=TEST_U_PCLSTR_U_PCLOG
 I 'TEST S ^TMP(PXRMPID,$J,PXRMITEM,"N/A","COHORT")=""
 I $D(PXRMDEV) S ^TMP(PXRMPID,$J,PXRMITEM,"PATIENT COHORT LOGIC")=PCLOGIC
 Q
 ;
 ;=======================================================================
EVALRESL(RESDATE,RESLOGIC,FIEVAL) ;Evaluate the Resolution Logic.
 N IND,FINDING,FIV,FLIST,NUM,RESLOG,RESLSTR,TEST
 S TEMP=$G(^PXD(811.9,PXRMITEM,36))
 S NUM=+$P(TEMP,U,1)
 I NUM=0 Q
 S (RESLOG,RESLSTR)=^PXD(811.9,PXRMITEM,35)
 S FLIST=$P(TEMP,U,2)
 F IND=1:1:NUM D
 . S FINDING=$P(FLIST,";",IND)
 . S TEMP="FI("_FINDING_")"
 . S RESLOG=$$STRREP^PXRMUTIL(RESLOG,TEMP,FIEVAL(FINDING))
 I @RESLOG
 S TEST=$T
 S RESLOGIC=TEST_U_RESLSTR_U_RESLOG
 I $D(PXRMDEV) S ^TMP(PXRMPID,$J,PXRMITEM,"RESOLUTION LOGIC")=RESLOGIC
 I TEST S RESDATE=$$RESDATE(RESLSTR,.FIEVAL)
 E  S RESDATE=0
 ;
 ;If the reminder was not resolved because of an expired finding
 ;find and save the expired resolution date for display.
 I RESDATE=0 D
 . S RESLOG=RESLSTR
 . F IND=1:1:NUM D
 .. S FINDING=$P(FLIST,";",IND)
 .. S FIV=FIEVAL(FINDING)
 .. I $D(FIEVAL(FINDING,"EXPIRED")) D
 ... S FIV=1
 .. S TEMP="FI("_FINDING_")"
 .. S RESLOG=$$STRREP^PXRMUTIL(RESLOG,TEMP,FIV)
 . I @RESLOG
 . S TEST=$T
 . I TEST S RESDATE=$$RESDATE(RESLSTR,.FIEVAL)_"X"
 Q
 ;
 ;=======================================================================
MINRD(DT1,DT2) ;Return the minimum date. If one of the dates is 0 then return
 ;the other date.
 S DT1=+DT1
 S DT2=+DT2
 I DT1=0 Q DT2
 I DT2=0 Q DT1
 Q $$MIN^XLFMTH(DT1,DT2)
 ;
 ;=======================================================================
POP(STACK,SP) ;Pop an element off of the stack.
 N TEMP
 S TEMP=STACK(SP)
 K STACK(SP)
 S SP=SP-1
 Q TEMP
 ;
 ;=======================================================================
PUSH(STACK,SP,ELEM) ;Push an element on the stack.
 S SP=SP+1
 S STACK(SP)=ELEM
 Q
 ;
 ;=======================================================================
LOGOP(DT1,DT2,LOP) ;Given two dates return the most recent if the logical
 ;operator is ! and the oldest if it is &.
 I LOP="!" Q $$MAX^XLFMTH(DT1,DT2)
 I LOP="&" Q $$MINRD(DT1,DT2)
 Q
 ;
 ;=======================================================================
RESDATE(RESLSTR,FIEVAL) ;Return the resolution date based on the following
 ;rules:
 ; Dates that are ORed use the most recent.
 ; Dates that are ANDed use the oldest.
 N DATE,DSTRING,DT1,DT2,DT3,FITEMP,IND,INDEX,JND,LEN
 N NOT,OPER,PFSTACK,SP,STACK,TEMP
 ;Remove leading (n) entries.
 I ($E(RESLSTR,1,4)="(0)!")!($E(RESLSTR,1,4)="(1)&") S $E(RESLSTR,1,4)=""
 ;The NOT operator is not relevant for the date calculation so remove
 ;any NOTs.
 S DSTRING=$TR(RESLSTR,"'","")
 ;Replace true findings with their dates. This includes false findings
 ;that are notted in the logic.
 S SP=1
 F  Q:SP=0  D
 . S IND=$F(RESLSTR,"FI(",SP)
 . I $E(RESLSTR,IND-4)="'" S NOT=1
 . E  S NOT=0
 . I IND=0 S SP=0 Q
 . S JND=$F(RESLSTR,")",IND)
 . S INDEX=$E(RESLSTR,IND,JND-2)
 . S SP=JND
 . S TEMP="FI("_INDEX_")"
 . I NOT S FITEMP="'"_"FIEVAL("_INDEX_")"
 . E  S FITEMP="FIEVAL("_INDEX_")"
 . ;I @FITEMP S DATE=+$G(FIEVAL(INDEX,"DATE"))
 . ;IHS/MSC/MGH Edited to display the last done date
 . I +$G(FIEVAL(INDEX,"DATE")) S DATE=+$G(FIEVAL(INDEX,"DATE"))
 . E  S DATE=0
 . S DSTRING=$$STRREP^PXRMUTIL(DSTRING,TEMP,DATE)
 ;
 ;Convert the string to postfix form for evaluation.
 D POSTFIX^PXRMUTIL(.PFSTACK,DSTRING,"!&")
 ;Set the allowable logic operators.
 S OPER="!&"
 S SP=0
 F IND=1:1:PFSTACK(0) D
 . S TEMP=PFSTACK(IND)
 . I OPER[TEMP D
 ..;Pop the top two elements on the stack and do the operation.
 .. S DT1=$$POP(.STACK,.SP)
 .. S DT2=$$POP(.STACK,.SP)
 .. S DT3=$$LOGOP(DT1,DT2,TEMP)
 ..;Save the result back on the stack
 .. D PUSH(.STACK,.SP,DT3)
 . E  D PUSH(.STACK,.SP,TEMP)
 ;The result is the only thing left on the stack.
 Q $$POP(.STACK,.SP)
 ;
 ;=======================================================================
SEX() ;Return FALSE (0) if the patient is the wrong sex for
 ; the reminder, TRUE (1) is the patient is the right sex.
 N REMSEX
 S REMSEX=$P($G(^PXD(811.9,PXRMITEM,0)),U,9)
 I ($P(PXRMSEX,U,1)=REMSEX)!(REMSEX="") Q 1
 E  D  Q 0
 . S ^TMP(PXRMPID,$J,PXRMITEM,"N/A","SEX")=""
 . S ^TMP(PXRMPID,$J,PXRMITEM,"INFO","SEX")="Patient is the wrong sex!"
 Q
 ;
 ;=======================================================================
VALID(LOGSTR,MINLEN,MAXLEN) ;Make sure that LOGSTR is a valid logic string.
 ;This is called by the input transform for PATIENT COHORT LOGIC and
 ;RESOLUTION LOGIC. Return 1 if LOGSTR is ok.
 ;
 ;Don't do this if this is being called as a result of an install
 ;through the Exchange Utility.
 I $G(PXRMEXCH) Q 1
 I LOGSTR="" Q 0
 ;
 ;Check the length.
 N LEN
 S LEN=$L(LOGSTR)
 I (LEN<MINLEN)!(LEN>MAXLEN) Q 0
 ;
 ;Use the FileMan code validator to check the code.
 N TEST,X
 S X="S Y="_$TR(LOGSTR,";","")
 D ^DIM
 I $D(X)=0 D  Q 0
 . S TEXT(1)="LOGIC string: "_LOGSTR
 . S TEXT(2)="contains invalid MUMPS code!"
 . D EN^DDIOL(.TEXT)
 ;
 N ELE1,ELE2,FUNLIST,SEP,SP,SS,STACK,TEXT,TSTSTR,VALID
 ;Make sure the entries in LOGSTR are valid elements or function.
 D BFUNLIST^PXRMLOGF(.FUNLIST)
 S FUNLIST("AGE")=""
 S FUNLIST("SEX")=""
 S TSTSTR=LOGSTR
 S TSTSTR=$TR(TSTSTR,"'","")
 S TSTSTR=$TR(TSTSTR,"&",U)
 S TSTSTR=$TR(TSTSTR,"!",U)
 S VALID=1
 ;Set the allowable logic separators.
 S SEP="^,<>="
 ;Convert the string to postfix form for evaluation.
 D POSTFIX^PXRMUTIL(.STACK,TSTSTR,SEP)
 S SP=STACK(0)
 F  Q:(SP=0)  D
 . S ELE1=$$POP^PXRMLOG(.STACK,.SP)
 . I SEP[ELE1 Q
 .;If the element is a number then the next element should be "FI".
 . I ELE1=+ELE1 D  Q
 .. S ELE2=$$POP^PXRMLOG(.STACK,.SP)
 .. I ELE2="FI" D
 ... I '$D(^PXD(811.9,DA,20,ELE1)) D
 .... S TEXT="FI("_ELE1_") is not in this reminder definition!"
 .... D EN^DDIOL(TEXT)
 .... S VALID=0
 .. E  D
 ... S TEXT=ELE2_" is not a valid logic element!"
 ... D EN^DDIOL(TEXT)
 ... S VALID=0
 .;Check for a valid function
 . I '$D(FUNLIST(ELE1)) D  Q
 .. S TEXT=ELE1_" is not a valid logic function!"
 .. D EN^DDIOL(TEXT)
 .. S VALID=0
 Q VALID
 ;
