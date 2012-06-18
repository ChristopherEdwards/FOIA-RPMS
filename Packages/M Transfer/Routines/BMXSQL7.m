BMXSQL7 ; IHS/OIT/HMW - BMX REMOTE PROCEDURE CALLS ;
 ;;4.0;BMX;;JUN 28, 2010
 ;
 ;
CHKCR(BMXFNUM,BMXFLDNU,BMXRET) ;Returns cross reference to iterate on for related file
 N BMXREF,BMXHIT,BMXRNOD,BMXTMP,BMXTMPV,BMXTMPI,BMXTMPP,BMXPFFN,BMXPFF,Q
 N BMXHIT,BMXREF,BMXGL,BMXNOD,BMXRNAM,BMXTMPL,BMXTMPN,BMXTST
 ;
 S BMXNOD=^DD(BMXFNUM,BMXFLDNU,0)
 S BMXGL=^DIC(BMXFNUM,0,"GL") ;Subfile global
 S BMXREF=0,BMXHIT=0,Q=$C(34),BMXRET=""
 F  S BMXREF=$O(^DD(BMXFNUM,BMXFLDNU,1,BMXREF)) Q:'+BMXREF  D  Q:BMXHIT
 . Q:'$D(^DD(BMXFNUM,BMXFLDNU,1,BMXREF,0))
 . S BMXRNOD=^DD(BMXFNUM,BMXFLDNU,1,BMXREF,0)
 . Q:$P(BMXRNOD,U,3)]""
 . S BMXRNAM=$P(BMXRNOD,U,2)
 . S BMXTMP=BMXGL_Q_BMXRNAM_Q_")"
 . S BMXTST=$P(BMXTMP,")")_",IEN0,"
 . Q:'$D(@BMXTMP)
 . S BMXTMPV=0,BMXTMPV=$O(@BMXTMP@(BMXTMPV))
 . Q:BMXTMPV=""
 . S BMXTMP=BMXGL_Q_BMXRNAM_Q_","_Q_BMXTMPV_Q_")"
 . S BMXTMPI=0,BMXTMPI=$O(@BMXTMP@(BMXTMPI))
 . S BMXTMP=$S(BMXGL[",":$P(BMXGL,",")_")",1:$P(BMXGL,"("))
 . Q:'$D(@BMXTMP@(BMXTMPI))
 . S BMXTMPL=$P(BMXNOD,U,4)
 . S BMXTMPP=$P(BMXTMPL,";",2)
 . S BMXTMPL=$P(BMXTMPL,";")
 . Q:BMXTMPL=""
 . S BMXTMP=BMXGL_BMXTMPI_")"
 . Q:'$D(@BMXTMP@(BMXTMPL))
 . S BMXTMPN=@BMXTMP@(BMXTMPL)
 . S BMXTMPP=$P(BMXTMPN,"^",BMXTMPP)
 . I BMXTMPP=BMXTMPV S BMXRET=BMXTST,BMXHIT=1
 Q BMXHIT
 ;
 ;
WHERE ;EP - WHERE-clause processing
 ;
 ;Set up the defualt iterator in BMXX(1) to scan the entire file.
 ;For now, just use first file in the FROM group
 ;Later, pick the smallest file if more than one file
 ;
 ;Set up BMXFF array for each expression element
 ;  BMXFF(n)=FILENAME^FIELDNAME^OPERATOR^VALUE^FILENUMBER^FIELDNUMBER
 ;           ^FILE GLOBAL^FIELD DATA LOCATION
 ;  BMXFF(n,0)=Field descriptor ^DD(FILE,FIELD,0)
 ;
 N BMXGL,BMXOP,BMXTYP,BMXV,BMXV1,BMXV2,BMXFILE,BMXTMP
 N BMXINTNL,BMXTMPLT
 N BMXIEN
 S BMXGL=^DIC(BMXFO(1),0,"GL")
 S BMXX=1
 S BMXX(1)="S D0=0 F  S D0=$O("_BMXGL_"D0)) Q:'+D0  Q:BMXM>BMXXMAX  "
 S BMXTMP=BMXGL
 I BMXTMP["," S BMXTMP=$TR(BMXTMP,",",")")
 E  S BMXTMP=$P(BMXTMP,"(",1)
 I $D(@BMXTMP@("B")) D
 . S BMXX(1)="S BMXTMP=0 F  S BMXTMP=$O("_BMXGL_$C(34)_"B"_$C(34)_",BMXTMP)) Q:BMXTMP=""""  S D0=0 F  S D0=$O("_BMXGL_$C(34)_"B"_$C(34)_",BMXTMP,D0)) Q:'+D0  Q:BMXM>BMXXMAX  "
 ;
 ;--->BMXFF array:
 ;
 S T=$G(BMXTK("WHERE"))
 S BMXFF=0,C=0
 Q:'+T
 F  S T=$O(BMXTK(T)) Q:'+T  Q:T=$G(BMXTK("ORDER BY"))  Q:T=$G(BMXTK("GROUP BY"))  D  Q:$D(BMXERR)
 . ;Get the file of the field
 . I "AND^OR^(^)"[BMXTK(T) D  Q
 . . S C=C+1
 . . S BMXFF(C)=BMXTK(T)
 . . S BMXFF=C
 . S BMXTK(T)=$TR(BMXTK(T),"_"," ")
 . S BMXTK(T)=$TR(BMXTK(T),"'","")
 . S BMXINTNL=0
 . S BMXTMPLT=0
 . S BMXIEN=0
 . I BMXTK(T)["INTERNAL[" S BMXINTNL=1,BMXTK(T)=$P(BMXTK(T),"[",2),BMXTK(T)=$P(BMXTK(T),"]",1)
 . I BMXTK(T)["TEMPLATE[" S BMXTMPLT=1,BMXTK(T)=$P(BMXTK(T),"[",2),BMXTK(T)=$P(BMXTK(T),"]",1),BMXIEN=1
 . I BMXTK(T)["BMXIEN" S BMXIEN=1
 . S BMXFILE=$$FLDFILE^BMXSQL2(BMXTK(T))
 . Q:$D(BMXERR)
 . S C=C+1
 . S BMXFF=C ;This is a count of the where fields
 . I BMXFILE]"" D
 . . S $P(BMXFF(C),U,1)=$P(BMXFILE,U,1) ;FILENAME
 . . S $P(BMXFF(C),U,2)=$P(BMXFILE,U,2) ;FIELDNAME
 . . S $P(BMXFF(C),U,5)=$P(BMXFILE,U,3) ;FILENUMBER
 . . S $P(BMXFF(C),U,6)=$P(BMXFILE,U,4) ;FIELDNUMBER
 . . I $P(BMXFILE,U,3),$D(^DIC($P(BMXFILE,U,3),0,"GL")) S $P(BMXFF(C),U,7)=^DIC($P(BMXFILE,U,3),0,"GL")
 . . I BMXIEN S BMXFF(C,0)="IEN",BMXFF(C,"IEN")=1,BMXFF(C,"TYPE")="IEN"
 . . E  S BMXFF(C,0)=$S(+$P(BMXFILE,U,3):^DD($P(BMXFILE,U,3),$P(BMXFILE,U,4),0),1:"")
 . . I BMXINTNL S BMXFF(C,"INTERNAL")=1
 . ;
 . ;If BMXFF(C) is a pointer, traverse pointer chain to retrieve type
 . I $P(BMXFF(C,0),U,2)["P" D
 . . ;B  ;WHERE Pointer Type
 . . N BMXFILN,BMXFLDN,BMXDD
 . . S BMXDD=BMXFF(C,0)
 . . F  Q:$P(BMXDD,U,2)'["P"  D:$P(BMXDD,U,2)["P"
 . . . S BMXFILN=$P(BMXDD,U,2)
 . . . S BMXFILN=+$P(BMXFILN,"P",2)
 . . . S BMXDD=^DD(BMXFILN,".01",0)
 . . S BMXFF(C,"TYPE")=$S($P(BMXDD,U,2)["D":"DATE",$P(BMXDD,U,2)["S":"SET",1:"OTHER")
 . . I BMXFF(C,"TYPE")="SET" S $P(BMXFF(C,"TYPE"),U,2)=$P(BMXDD,U,3)
 . ;B  ;WHERE Set Type
 . I ($P(BMXFF(C,0),U,2)["S")!($P($G(BMXFF(C,"TYPE")),U)="SET") D  ;Set
 . . N BMXSET,BMXSETP
 . . I $P(BMXFF(C,0),U,2)["S" D
 . . . S BMXFF(C,"TYPE")="SET"
 . . . S $P(BMXFF(C,"TYPE"),U,2)=$P(BMXFF(C,0),U,3)
 . . S BMXSET=$P(BMXFF(C,"TYPE"),U,2)
 . . F J=1:1:$L(BMXSET,";") D
 . . . S BMXSETP=$P(BMXSET,";",J)
 . . . Q:BMXSETP=""
 . . . S BMXFF(C,"SET",$P(BMXSETP,":",2))=$P(BMXSETP,":")
 . ;
 . ;Set up comparisons based on operators
 . S T=T+1
 . S BMXOP=BMXTK(T)
 . I BMXTMPLT S BMXOP="="
 . I "^<^>^=^[^<>^>=^<=^LIKE"[BMXOP D  Q
 . . S $P(BMXFF(C),U,3)=BMXTK(T)
 . . ;Get the comparison value
 . . S T=T+1
 . . S BMXTMP=BMXTK(T)
 . . S BMXTMP=$TR(BMXTMP,"'","")
 . . I BMXOP="LIKE" S BMXTMP=$P(BMXTMP,"%"),$P(BMXFF(C),U,4)=BMXTMP Q
 . . I BMXTMPLT D TMPLATE Q
 . . I BMXTMP="*" S T=T+1,BMXTMP=BMXTK(T) D OTM Q
 . . I BMXTMP[".",BMXTK(T)'["'" D  ;This is a join  ;TODO: Extended pointers
 . . . ;Setting BMXFJ("JOIN"
 . . . S BMXTMP=BMXTK(T)
 . . . I $D(BMXF($P(BMXTMP,"."))),BMXF($P(BMXTMP,"."))=BMXFO(1) D  Q
 . . . . S BMXTMP=BMXTK(T-2)
 . . . . D OTM
 . . . N BMXJN
 . . . S BMXFF(C,"JOIN")="Pointer chain"
 . . . S BMXJN=+$P($P(BMXFF(C,0),U,2),"P",2)
 . . . S BMXFJ("JOIN",+$P($P(BMXFF(C,0),U,2),"P",2))=C
 . . . S:+$P($P(BMXFF(C,0),U,2),"P",2)=2 BMXFJ("JOIN",9000001)=C ;IHS Only -- auto join PATIENT to VA PATIENT
 . . I ($P(BMXFF(C,0),U,2)["D")!($G(BMXFF(C,"TYPE"))="DATE") D  ;Date
 . . . Q:$D(BMXFF(C,"INTERNAL"))
 . . . I BMXTMP]"" S X=BMXTMP,%DT="T" D ^%DT S BMXTMP=Y
 . . I $P($G(BMXFF(C,"TYPE")),U)="SET" D
 . . . Q:$D(BMXFF(C,"INTERNAL"))
 . . . Q:BMXTMP=""
 . . . I $G(BMXFF(C,"SET",BMXTMP))="" S BMXTMP="ZZZZZZ" Q
 . . . S BMXTMP=$G(BMXFF(C,"SET",BMXTMP))
 . . S $P(BMXFF(C),U,4)=BMXTMP
 . . Q
 . I BMXOP="BETWEEN" D
 . . S $P(BMXFF(C),U,3)="BETWEEN"
 . . ;Get the comparison value
 . . S T=T+1
 . . S BMXV1=BMXTK(T)
 . . S:BMXV1["'" BMXV1=$P(BMXV1,"'",2)
 . . S T=T+1
 . . I BMXTK(T)'="AND" S BMXERR="'BETWEEN' VALUES NOT SPECIFIED" D ERROR Q
 . . S T=T+1
 . . S BMXV2=BMXTK(T)
 . . S:BMXV2["'" BMXV2=$P(BMXV2,"'",2)
 . . I ($P(BMXFF(C,0),U,2)["D")!($G(BMXFF(C,"TYPE"))="DATE") D  ;Date
 . . . Q:$D(BMXFF(C,"INTERNAL"))
 . . . S X=BMXV1,%DT="T" D ^%DT S BMXV1=Y
 . . . S X=BMXV2,%DT="T" D ^%DT S BMXV2=Y
 . . I BMXV1>BMXV2 S BMXTMP=BMXV1,BMXV1=BMXV2,BMXV2=BMXTMP
 . . S $P(BMXFF(C),U,4)=BMXV1_"~"_BMXV2
 . . Q
 . I $P(BMXFF(C),U,3)="" S BMXERR="INVALID OPERATOR" D ERROR Q
 . I $D(BMXTK(T+1)),BMXTK(T+1)["[INDEX:" D
 . . S T=T+1
 . . N BMXIND
 . . S BMXIND=$P(BMXTK(T),"INDEX:",2)
 . . S:BMXIND["]" BMXIND=$P(BMXIND,"]")
 . . S:BMXIND["'" BMXIND=$P(BMXIND,"'",2)
 . . S BMXFF("INDEX")=BMXIND
 . Q
 ;
 Q:$D(BMXERR)
 D JOIN^BMXSQL4
 Q
 ;
TMPLATE ;
 N BMXTNUM,BMXTNOD
 I BMXTMP["[" S BMXTMP=$P(BMXTMP,"[",2),BMXTMP=$P(BMXTMP,"]")
 S BMXTMP=$TR(BMXTMP,"_"," ")
 ;Test template validity
 I '$D(^DIBT("B",BMXTMP)) S BMXERR="TEMPLATE NOT FOUND" D ERROR Q
 S BMXTNUM=$O(^DIBT("B",BMXTMP,0))
 I '$D(^DIBT(BMXTNUM,0)) S BMXERR="TEMPLATE NOT FOUND" D ERROR Q
 S BMXTNOD=^DIBT(BMXTNUM,0)
 I $P(BMXTNOD,U,4)'=$P(BMXFF(C),U,5) S BMXERR="TEMPLATE DOES NOT MATCH FILE" D ERROR Q
 I '$D(^DIBT(BMXTNUM,1)) S BMXERR="TEMPLATE HAS NO ENTRIES" D ERROR Q
 S BMXFF(C,0)="IEN",BMXFF(C,"IEN")="TEMPLATE",BMXFF(C,"TYPE")="IEN"
 S $P(BMXFF(C),U,4)=BMXTMP
 ;
 Q
 ;
OTM ;One-To-Many
 N BMXUPFN,BMXSUBFN,BMXA,BMXB,BMXSBFLD,BMXFNAM
 I BMXTMP["INTERNAL[" S BMXTMP=$P(BMXTMP,"INTERNAL[",2),BMXTMP=$P(BMXTMP,"]")
 S BMXUPFN=BMXFO(1)
 S BMXA=$TR($P(BMXTMP,"."),"_"," ")
 S BMXB=$TR($P(BMXTMP,".",2),"_"," ")
 S BMXFNAM=BMXB ;Required by SETMFL.  Won't work if filename BMXB [ "."
 ;Get the subfile
 I '$D(BMXF(BMXA)) S BMXERR="Related File Not Found" Q
 S BMXSUBFN=BMXF(BMXA)
 I '$D(^DD(BMXSUBFN,0)) S BMXERR="Related file not found" Q
 ;Get the field that points to the main file
 I '$D(^DD(BMXSUBFN,"B",BMXB)) S BMXERR="Related field not found" Q
 S BMXSBFLD=$O(^DD(BMXSUBFN,"B",BMXB,0))
 I '+BMXSBFLD S BMXERR="Related field not found" Q
 ;
 ;Find a normal index on that field
 ;Set up for call to CHKCR^BMXSQL7
 N BMXEXEC
 I '$$CHKCR^BMXSQL7(BMXSUBFN,BMXSBFLD,.BMXEXEC) S BMXERR="Related File not indexed" Q
 ;
 ;
 S BMXFF(C,"JOIN")="One-to-many Join"
 ;
 ;Call SETMFL^BMXSQL5 to set up the iteration code
 D SETMFL^BMXSQL5(BMXUPFN,BMXSUBFN,BMXEXEC,1,1)
 ;
 ;
 ;Upfile is the mainfile, Subfile is the related file
 ;BMXOFF is 1 but What is BMXGL?
 ;
 Q
 ;
ERROR Q
