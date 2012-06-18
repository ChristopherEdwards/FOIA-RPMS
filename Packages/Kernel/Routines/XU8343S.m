XU8343S ;BPOIFO/DW-CONVERSION OF NEW PERSON FILE ENTRIES ;10:39 AM  10 Mar 2000
 ;;8.0;KERNEL;**343**;Jul 10, 1995
 ; Modified from XLFNAME3 by MKO.
NEWPERS(XUFLAG,XUIEN) ;Convert New Person file names
 ;In: XUFLAG [ "C"  : Update Name Components file (#20) and pointer
 ;           [ "K"  : Kill ^XTMP("XLFNAME") up front
 ;           [ "P"  : Update New Person Names
 ;           [ "R"  : Record changes/problems in ^XTMP
 ;    XUIEN  = ien of last record converted;
 ;             conversion will begin with the next record
 ;
 N XUCNT,XUDEG,XUF,XUIENL,XUIENS,XUMSG,XUNAM,XUNMSP,XUNODEGT,XUNOTRIG
 N XUNOSIGT,XUPVAL,XUSTOP,XPDIDTOT,I,XUT,XUINV,XUIN
 S XUFLAG=$G(XUFLAG)_"M35"
 S (XUNOTRIG,XUNOSIGT,XUNODEGT)=1
 S XUNMSP="XUNAME",XUCNT=0
 ;
 K:XUFLAG["K" ^XTMP(XUNMSP)
 S:XUFLAG["R" $P(^XTMP(XUNMSP,0),U,1,2)=$$FMADD^XLFDT(DT,90)_"^"_DT
 ;
 ;Loop through New Person file
 I '$D(ZTQUEUED),'$D(XPDNM) D
 . W !!," NOTE: To cancel this process, type '^' at any time."
 . W !," Please wait..."
 ;
 S XUIEN=+$G(XUIEN)
 ;
 ;Get XPDIDTOT = total number of entries to convert
 I XUFLAG["P" D
 . I 'XUIEN S XPDIDTOT=$P($G(^VA(200,0)),U,4) Q:XPDIDTOT>0
 . S XUMSG="   Obtaining number of entries to convert. Please wait..."
 . I '$D(XPDNM) W !,XUMSG
 . E  D MES^XPDUTL(XUMSG)
 . K XUMSG
 . S I=XUIEN,XPDIDTOT=0
 . F  S I=$O(^VA(200,I)) Q:'I  S:$P($G(^(I,0)),U)]"" XPDIDTOT=XPDIDTOT+1
 . S:'XUIEN $P(^VA(200,0),U,4)=XPDIDTOT
 ;
 S XUMSG="   Converting New Person Names..."
 I '$D(XPDNM) W !,XUMSG
 E  D MES^XPDUTL(XUMSG)
 K XUMSG
 ;
 S XUSTOP=0
 F  S XUIEN=$O(^VA(200,XUIEN)) Q:'XUIEN  D  D STPCHK Q:XUSTOP
 . S XUNAM=$P($G(^VA(200,XUIEN,0)),U)
 . S:XUNAM'="" XUCNT=XUCNT+1
 . I XUNAM=""!$D(^VA(200,XUIEN,-9))!(XUNAM?1"MERGING INTO".E) Q
 . S XUIENS=XUIEN_","
 . ;
 . S XUPVAL=$P($G(^VA(200,XUIEN,3.1)),U)
 . S XUDEG=$P($G(^VA(200,XUIEN,3.1)),U,6)
 . ;
 . ;Process .01 field of file 200
 . S XUF=$S(XUNAM="POSTMASTER"&(XUIEN=.5):$TR(XUFLAG,"R"),1:XUFLAG)
 . D UPDATE(XUF,200,XUIENS,.01,XUNAM,10.1,XUPVAL,XUNMSP,XUDEG) K XUF
 . ;
 . ;Remember this ien if entries are being converted
 . I XUFLAG["P",XUFLAG["R" S $P(^XTMP(XUNMSP,0),U,4)=XUIEN
 ;
 S XUMSG(1)=$S(XUSTOP:"   Process cancelled.",1:"   DONE!")
 S XUMSG(2)="   Number of records processed: "_XUCNT
 S:XUCNT XUMSG(3)="   Entry number last processed: "_$G(XUIENL)
 I '$D(XPDNM) W ! F I=1:1:3 W:$D(XUMSG(I))#2 !,XUMSG(I)
 E  D MES^XPDUTL(.XUMSG)
 ;
 S XUT(1)=$G(XUCNT)
 S XUT(2)=$G(XUIENL)
 S XUT(3)=$G(XPDIDTOT)
 S XUT(4)=$G(XUSTOP)
 D NOTICE^XU8343R(.XUT)
 ;
 D REPORT^XU8343R
 ;
 Q
 ;
STPCHK ;Every 200 records, check whether to stop
 S XUIENL=XUIEN
 D:'(XUCNT#200)
 . I $D(ZTQUEUED),$$S^%ZTLOAD S (ZTSTOP,XUSTOP)=1 Q
 . I '$D(ZTQUEUED),'$D(XPDNM) W "." I $$STOP S XUSTOP=1 Q
 . I '$D(ZTQUEUED),$D(XPDNM) D UPDATE^XPDID(XUCNT)
 Q
 ;
UPDATE(XUFLAG,XUFIL,XUIENS,XUFLD,XUNAM,XUPTR,XUPVAL,XUNMSP,XUDEG) ;Process name field
 N XUAUD,XUDA,XUFDA,XUMAX,XUMSG,XUORIG,DIERR,XUOLD,XUNAME,XUCHG
 S XUFLAG=$G(XUFLAG)
 S XUOLD=XUNAM
 I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1
 ;
 ;Get maximum length of standard name
 S XUMAX=+$P(XUFLAG,"M",2,999)
 ;
 ;Standardize/parse name; Record uncertainties in ^XTMP
 ;Have name components before standardization
 S XUNAME=$$FORMAT^XLFNAME7(.XUNAM,3,XUMAX,,,.XUAUD,0,2)
 ;
 S XUCHG=$$CHANGED(.XUAUD,XUNAME)
 ;
 I XUCHG'=0 D RCD(XUNAME,XUCHG,XUNMSP,XUIENS,XUOLD)
 ;
 ;Update file #20 and pointer to file #20
 I XUFLAG["C",$G(XUCHG)=1 D
 . S:$D(XUDEG)#2 XUNAM("DEGREE")=XUDEG
 . D UPDCOMP^XLFNAME2(XUFIL,XUIENS,XUFLD,.XUNAM,XUPTR,.XUPVAL)
 ;
 ;Update source name if different
 I XUFLAG["P",$G(XUCHG)=1 D
 . S XUFDA(XUFIL,XUIENS,XUFLD)=XUNAME
 . D FILE^DIE("","XUFDA","XUMSG") K DIERR,XUMSG
 Q
 ;
RCD(XUNAME,XUCHG,XUNMSP,XUIENS,XUOLD) ;Record changes & problems
 ;XUOLD = Name before conversion
 ;XUNAME = Name after conversion
 ;
 S XUNAME=$G(XUNAME),XUIENS=$G(XUIENS),XUOLD=$G(XUOLD)
 ;
 ;Do not record if no change was made
 Q:$G(XUCHG)=0
 ;
 N XUSUB
 S XUSUB="REST"
 S XUCHG=$G(XUCHG)
 ;
 ;If name is changed
 I XUCHG=1 S XUSUB="CHANGED"
 ;If name could not be converted
 I XUCHG=2 S XUSUB="UNCHANGED"
 ;
 ;Get IEN from XUIENS
 S XUINV=$P(XUIENS,",")
 ;
 S ^XTMP(XUNMSP,XUSUB,XUINV,"OLD")=XUOLD
 S ^XTMP(XUNMSP,XUSUB,XUINV,"NEW")=XUNAME
 Q
 ;
STOP() ;Check whether to stop
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,X,Y
 ;R Y#1:0 Q:Y="" 0
 ;F  R *X:0 E  Q
 R Y:0 Q:Y="" 0
 S Y=$E(Y,1,1)
 Q:Y'=U 0
 S DIR(0)="Y",DIR("A")="Are you sure you want to stop",DIR("B")="NO"
 S:XUFLAG["P" DIR("?")="If you stop a conversion, you can continue later where you left off."
 W ! D ^DIR
 Q Y=1
 ;
POST ;The Post-Install entry point (run conversion)
 N XUIEN,XUNMSP
 S XUNMSP="XUNAME"
 S XUIEN=+$P($G(^XTMP(XUNMSP,0)),U,4)
 D NEWPERS("CPR"_$E("K",'XUIEN),+XUIEN)
 I $D(^XTMP(XUNMSP,0))#2,XUIEN'=+$P(^XTMP(XUNMSP,0),U,4) S $P(^XTMP(XUNMSP,0),U,3)="Created by POST~XU8343P (Post Install Conversion of XU*8.0*343)"
 Q
 ;
CHANGED(XUAUD,XUNAME) ;Decide if the name is convertible.
 ; RESULT: 2 if the name is not convertible
 ;         1 if the name is convertible
 ;         0 if the name is not changed 
 N XUR
 S XUR=1
 I $G(XUAUD)=0 Q 0
 I $G(XUAUD)=2 Q 2
 ;
 S XUNAME=$G(XUNAME)
 I $L(XUNAME)>35!($L(XUNAME)<3)!($L(XUNAME,",")'=2)!(XUNAME'?1.E1","1.E) Q 2
 Q XUR
 ;
CONVERT ;Convert Names
 N DIR,DIROUT,DIRUT,DTOUT,DUOUT,XUIEN,XUNMSP,X,Y
 I $G(XUNMSP)="" S XUNMSP="XUNAME"
 ;
 W !,"This routine will run the New Person Name Standardization conversion."
 W !!,"It will loop through the entries in the New Person file, convert "
 W !,"the Name field (#.01) of the New Person file to standard form, and"
 W !,"update the corresponding Name Component entries of converted names."
 ;
 S DIR(0)="YO",DIR("A")="Do you wish to continue"
 S DIR("?",1)="  Enter 'Y' to convert the Names in the New Person file"
 S DIR("?",2)="  to standard form, and to update the corresponding"
 S DIR("?")="  entries of changed Names in the Name Components file."
 W ! D ^DIR K DIR Q:$D(DIRUT)!'Y
 ;
 ;Check if the conversion was already run.
 ;Determine which record to start with.
 S XUIEN=+$P($G(^XTMP(XUNMSP,0)),U,4)
 I XUIEN D  Q:$D(DIRUT)
 . I $O(^VA(200,XUIEN)) D
 .. W !!,"It appears that the conversion has already been performed through"
 .. W !,"record #"_XUIEN_" in the New Person file."
 .. W !!,"Do you want to continue the conversion from after this point"
 .. W !,"or convert the entries from the beginning of the file."
 .. S DIR(0)="S^C:Continue the conversion after record #"_XUIEN_";S:Start again from the beginning of the file"
 .. S DIR("?",1)="  Enter 'C' to start the conversion and parsing process from the"
 .. S DIR("?",2)="  after record #"_XUIEN_" in the New Person file."
 .. S DIR("?",3)=" "
 .. S DIR("?",4)="  Enter 'B' to start the conversion and parsing process from the"
 .. S DIR("?",5)="  the beginning of the New Person file."
 .. S DIR("?",6)=" "
 .. S DIR("?",7)="  NOTE: There is no harm in running the conversion again from the"
 .. S DIR("?",8)="  beginning. However, if the conversion routine previously parsed a name"
 .. S DIR("?",9)="  into its component parts incorrectly, and you corrected those problems"
 .. S DIR("?",10)="  by manually editing the name components, your corrections will be lost"
 .. S DIR("?")="  if you run the conversion again."
 .. D ^DIR K DIR Q:$D(DIRUT)
 .. S:Y="S" XUIEN=0
 . E  D
 .. W !!,"It appears that the conversion has already been performed on all entries"
 .. W !,"in the New person file.",!
 .. S DIR(0)="YO",DIR("A")="Do you want to run the conversion again"
 .. S DIR("?",1)="  Enter 'Y' if you wish to run the New Person Name conversion again."
 .. S DIR("?",2)=" "
 .. S DIR("?",3)="  NOTE: There is no harm in running the conversion again. However, if the"
 .. S DIR("?",4)="  conversion routine previously parsed a name into its component parts"
 .. S DIR("?",5)="  incorrectly, and you corrected those problems by manually editing the"
 .. D ^DIR K DIR S:'Y DIRUT=1 Q:$D(DIRUT)
 .. S XUIEN=0
 ;
 D NEWPERS^XU8343S("CPR"_$E("K",'XUIEN),+XUIEN)
 S:$D(^XTMP(XUNMSP,0))#2 $P(^(0),U,3)="Created by CONVERT~XU8343S"
 Q
