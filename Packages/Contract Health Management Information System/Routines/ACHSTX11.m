ACHSTX11 ; IHS/ITSC/PMF - EXPORT DATA.  Extract  
 ;;3.1;CONTRACT HEALTH MGMT SYSTEM;;JUN 11, 2001
 ;
 ;we get here if we are going to do an export.  REexporting
 ;goes through another program.
 ;
 ;
 ;I've looked at this process a whole lot, and this is the easiest
 ;way of doing things that I can find.  What's going to happen is
 ;that we will examine each transaction that has occurred from the
 ;start date to the end date.  We will decide if this transaction
 ;of this document will generate any records for export.
 ;
 ;If it does, we create them right away.  This is easy to do at this
 ;point because we have already pulled most of the info about this
 ;document from the detabase already.  What it means, though, is that
 ;the calls will get pretty deep.  Remember that when reading the 
 ;program for the first time and don't let it get you lost.
 ;
 ;When the records get created, they get put into different globals.
 ;When allll of the records are created, we then take them out of
 ;those globals and put them into ^ACHSDATA (the type 2 records are
 ;already in that global.)  This is done so that the final result
 ;will be a list of all of the type 2s then all of the type 3s, then
 ;all of the type 4s, etc.
 ;
 ;
 ;Deciding which records get created is complicated.  We have made it
 ;as simple as possible, but it is still complicated.  None of the
 ;records get generated due to exactly the same set of circumstances.
 ;Instead, the circumstances overlap in some places and not in others.
 ;When the code comes to that part of it, this is explained further.
 ;
 ;These programs are written more for clarity than for expediancy.  It
 ;would be easy to make some some changes and save a few milliseconds,
 ;but you would then not want to read the program.
 ;
 ;init some stuff.  If it fails, quit
 D INIT I STOP Q
 ;
 ;remove two lines for testing !!!!!
 ;D EXPRT
 ;I STOP Q
 ;
 ;
 ;W @IOF,!,ACHS("*"),!?30,"EXPORT CHS DATA",!,ACHS("*"),!
 ;
 ;record the start and end dates FDT is first date, LDT is last date 
 ;S ACHSFDT=ACHSBDT,ACHSLDAT=ACHSEDT
 ;
 ;for test!!!!!
 S ACHSBDT=ACHSSBD,ACHSEDT=ACHSSED
 ;
 ;for each day from start to end date, look for...
 F  S ACHSBDT=$O(^ACHSF(DUZ(2),"TB",ACHSBDT)) Q:ACHSBDT=""!(ACHSBDT>ACHSEDT)  D EXTRCT
 ;
 K DOLH,PMFCOUNT
 Q
 ;
EXTRCT ;
 ;if this is the first day, set record count to 0
 S:ACHSRCT=0 ACHSFDT=ACHSBDT
 ;
 ;for each transaction type except ZAs and IPs, do...
 S ACHSTY="" F  S ACHSTY=$O(^ACHSF(DUZ(2),"TB",ACHSBDT,ACHSTY)) Q:ACHSTY=""  I ACHSTY'="ZA",(ACHSTY'="IP") D EXTR2
 Q
 ;
EXTR2 ;
 ;for each document of this type on this day...
 S ACHSDIEN=0 F  S ACHSDIEN=$O(^ACHSF(DUZ(2),"TB",ACHSBDT,ACHSTY,ACHSDIEN)) Q:ACHSDIEN=""  D EXTR3
 Q
EXTR3 ;
 ;go fetch the data on this document.  if it's not okay, stop
 D ^ACHSDOCR I 'OK Q
 D ^ACHSVNDR I 'OK Q
 ;
 ;if this is a blanket order, stop
 I BLNKT=2 D KLL^ACHSDOCR,KLL^ACHSVNDR Q
 ;
 ;now that we have document data build some other pieces
 S ACHSCTY=ACHSTY
 S ACHSDOCN="0"_$P(ACHSDOCR,U,14)_ACHSFC_$E($P(ACHSDOCR,U)+100000,2,6)
 ;
 ;for each transaction within this trans type on the
 ;    document for today...
 S TNUM=0 F  S TNUM=$O(^ACHSF(DUZ(2),"TB",ACHSBDT,ACHSTY,ACHSDIEN,TNUM)) Q:TNUM=""  D EXTR4
 D KLL^ACHSDOCR,KLL^ACHSVNDR
 Q
 ;
EXTR4 ;EP from ACHSTX2R
 ;
 ;fo continuity with other programs, use DA for that last subscript
 S DA=TNUM
 ;
 ;for test
 ;W !,ACHSBDT,?15,ACHSTY,?30,ACHSDIEN,?45,TNUM R YAYA
 ;
 I $P($H,",",2)-TIME>3 W " ." S TIME=$P($H,",",2)
 ;
 ;make sure that the transaction that "TB" is pointing to actually
 ;exists
 I 'ACHSREEX,'$D(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",DA,0)) K ^ACHSF(DUZ(2),"TB",ACHSBDT,ACHSTY,ACHSDIEN,DA) Q
 ;
 S ACHSTRAN=^ACHSF(DUZ(2),"D",ACHSDIEN,"T",DA,0)
 ;
 ;get the initial payment amount and format it
 S ACHSIPA=$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",DA,0),U,4)
 S ACHSIPA=$P(ACHSIPA,".",1)_$E($P(ACHSIPA,".",2)_"00",1,2),ACHSIPA=$E(ACHSIPA+1000000000000,2,13)
 ;
 ;if the type is Cancel, don't use it.  use the trans type instead
 I ACHSCTY="C" S ACHSCTY=$P(^ACHSF(DUZ(2),"D",ACHSDIEN,"T",DA,0),U,5)
 ;
 ;now decide if this document will generate some records.
 ;each record type gets created or not based on several
 ;parameters.  Not all of the records use all of the
 ;parameters, though.  So there is OVERLAP in the way
 ;records qualify, but it's a complicated pattern of
 ;overlap.  You will see it the the next programs called.
 ;
 ;
 ;When we are done here, the transactions that got made will be
 ;in various different globals.
 ;Also, there will be an entry in ^ACHSXPRT that looks like this:
 ;
 ;^ACHSXPRT(ACHSDIEN,DA)=r2^r3^r4^r5^r6^r7
 ;
 ;where ACHSDIEN is the internal sequence number of the document
 ;      DA is the transaction subscript
 ;      rx is the action taken on the document for trans type x
 ;      for example, if r4 = "", we did not creat a type 4 trans
 ;                               and we don't know why.
 ;                               SHOULD NOT OCCUR.
 ;                   if r5 = 0, that means a type 5 trans was created
 ;                              a 0 ALWAYS means trans created.
 ;                   if r3 = 17, then the trans was not created
 ;                               for reason #17
 ;
 ;for test
 S SDA=DA
 ;
 ;
 ;AFTER the export file is created, BUT NOT BEFORE, we take the info
 ;in ^ACHSXPRT and record it in ^ACHSTXST for permanent storage.
 ;
 ;each of the routines we call expect ACHSDOCR and the standard
 ;document variables, which are returned unchanged, and the
 ;routines will return RET with their outcome
 S LIST="" F NUM=2:1:7 S ROUT="^ACHSTX"_NUM_NUM,RET="" D @ROUT S $P(LIST,U,NUM)=+RET
 ;
 ;SDA for test
 S ^ACHSXPRT(DOLRH,ACHSDIEN,SDA)=LIST K SDA
 ;
 Q
 ;
EXPRT ;
 ;set up for exporting, as opposed to REexporting
 ;
 ;beginning date starts as the end date of the last export
 S P=$O(^ACHSTXST(DUZ(2),1,""),-1)
 I P'="" S ACHSBDT=$P(^ACHSTXST(DUZ(2),1,P,0),U,3)
 ;if there is no last export, set the start date to 1/1/1800
 I P="" S ACHSBDT=1000101
 ;
 ;now get the ending date.  There is no easy way to get it.
 ;go through each child below the "AR" cross reference to get a
 ;register number.  then use that register number to see when it
 ;was last closed - that's the "W" cross reference.  As you get
 ;each one, see if it's later than the end date you got and, if
 ;it is, keep it.
 ;
 S DA=9999998-DT-1 F  S DA=$O(^ACHS(9,DUZ(2),"FY",ACHSCFY,"AR",DA)) Q:DA=""!('DA)  D
 . S DCR="" F  S DCR=$O(^ACHS(9,DUZ(2),"FY",ACHSCFY,"AR",DA,DCR)) Q:DCR=""!('DCR)  D
 .. S DAT=$G(^ACHS(9,DUZ(2),"FY",ACHSCFY,"W",DCR,0))
 .. I $P(DAT,U,2)>ACHSEDT S ACHSEDT=$P(DAT,U,2)
 .. Q
 . Q
 K DAT,DCR
 I 'ACHSEDT W !!,*7,*7,"DCR REGISTER ERROR YOU MUST CLOSE YOUR REGISTERS FIRST" D RTRN^ACHS S STOP=1 Q
 Q
 ;
INIT ;EP from ACHSTX2R
 ;set up basic vars with default values and in other ways
 ;get set to do this function
 ;
 ;S (ACHSDCR,ACHSEDT,ACHSBDT)=0,ACHSRR=""
 ;
 ;get the authorizing facility number.  will be in one of two
 ;places in the AUTTLOC global:  either in the entry for this
 ;facility, or in the entry for the area office facility. site
 ;parm makes the difference
 S ACHSAFAC=$P(^AUTTLOC(DUZ(2),0),U,10)
 I $$PARM^ACHS(2,25)="Y" S ACHSAFAC=$P(^ACHSF(DUZ(2),0),U,12) I ACHSAFAC'="" S ACHSAFAC=$P($G(^AUTTLOC(ACHSAFAC,0)),U,10)
 ;if it's not set by now, tell them about it and stop
 I 'ACHSAFAC W !!,*7,*7,"AUTHORIZING FACILITY CODE ERROR  -  JOB CANCELLED" S STOP=1 Q
 ;
 ;we use a couple of parms several times, including a busy loop, so
 ;lets load them once and keep the values around.  other parms we
 ;just use once or twice
 S ACHSF209=$$PARM^ACHS(2,9)="Y",ACHSF211=$$PARM^ACHS(2,11)="Y",ACHSF212=$$PARM^ACHS(2,12)="Y"
 ;
 ;parm 2,9 says whether we are export statistical data or not.
 ;if so, go get some object class codes
 I ACHSF209 D
 . F ACHS="252F","254V" S ACHS(ACHS)=$O(^ACHS(3,DUZ(2),1,"B",ACHS,0))
 . ; if this is a 638 facility, get even more object class codes
 . I ACHSF638="Y" F ACHS="252G","252R","254D","254L","254M" S ACHS(ACHS)=$O(^ACHS(3,DUZ(2),1,"B",ACHS,0))
 . Q
 ;
 ;this array keeps track of how many records of each type we create.
 ;init the counts to zero
 F ACHS=2:1:7 S ACHSRTYP(ACHS)=0
 ;
 Q
 ;
