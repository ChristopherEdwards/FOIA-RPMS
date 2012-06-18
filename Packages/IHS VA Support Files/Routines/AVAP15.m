AVAP15 ;IHS/OIRM/DSD/AEF - PATCH AVA*93.2*15 RESTORE X-REFS ON FILE 200 FOR KERNEL UPDATE [ 01/28/2003  4:14 PM ]
 ;;93.2;VA SUPPORT FILES;**15**;JAN 31, 2003
 ;
 ;This is a special patch for the FileMan22/Kernel Update.  Some of
 ;the Kernel patches deleted or reset some of the IHS crossreferences
 ;on the New Person file #200 and the Institution file #4.  This routine
 ;resets the IHS crossreferences.  It also restores the trigger and
 ;crossreferences on the .01 field of file 200 used to keep files
 ;3-16-200 in sync.  These are restored because some IHS sites may
 ;not have done the File 200 Conversion or may have local packages
 ;still pointing to files 3 or 16.
 ;
EN ;EP -- MAIN ENTRY POINT
 ;
 D X401AD
 D X20001
 D X200535
 Q
X401AD ;----- RESET AD X-REF IN INSTITUTION FILE
 ;ADDS QUIT TO SET AND KILL LOGIC TO PREVENT DELETION OF THE LOCATION
 ;FILE ENTRY WHEN A NAME IS CHANGED IN THE INSTITUTION FILE
 ;
 I $D(^DD(4,.01,1,3,1)) D
 . S ^DD(4,.01,1,3,1)="Q  ;I $D(^AUTTLOC(0))#2 N DIC,DD,DO,DINUM S DIC=""^AUTTLOC("",DIC(0)="""",(X,DINUM)=DA D FILE^DICN"
 . S ^DD(4,.01,1,3,2)="Q  ;I $D(^AUTTLOC(0))#2 N DIK S DIK=""^AUTTLOC("" D ^DIK"
 Q
X20001 ;----- KILL AND RESET THE CROSSREFERENCES ON .01 FIELD OF FILE 200
 ;
 ;----- KILL X-REFS
 ;
 K ^DD(200,.01,1)
 ;
 ;----- SET TOP ZERO NODE
 ;
 S ^DD(200,.01,1,0)="^.1"
 ;
1 ;----- SET "B" XREF #1
 ;
 S ^DD(200,.01,1,1,0)="200^B"
 S ^DD(200,.01,1,1,1)="S ^VA(200,""B"",$E(X,1,30),DA)="""""
 S ^DD(200,.01,1,1,2)="K ^VA(200,""B"",$E(X,1,30),DA)"
 ;
2 ;----- SET "AE" XREF #2
 ;
 S ^DD(200,.01,1,2,0)="200^AE^MUMPS"
 S ^DD(200,.01,1,2,1)="S X1=$P($G(^VA(200,DA,1)),""^"",8) I X1="""" S $P(^VA(200,DA,1),""^"",7,8)=DT_""^""_DUZ"
 S ^DD(200,.01,1,2,2)="Q"
 S ^DD(200,.01,1,2,3)="Stuffing Creator and date"
 S ^DD(200,.01,1,2,"%D",0)="^^1^1^2990617^^"
 S ^DD(200,.01,1,2,"%D",1,0)="This X-ref stuffs the DATE ENTERED and CREATOR fields on a new entry."
 S ^DD(200,.01,1,2,"DT")="2990617"
 ;
3 ;----- SET "AF" XREF #3
 ;
 S ^DD(200,.01,1,3,0)="200^AF^MUMPS"
 S ^DD(200,.01,1,3,1)="S $P(^VA(200,DA,20),""^"",2)=$P(X,"","",2)_"" ""_$P(X,"","",1)"
 S ^DD(200,.01,1,3,2)="Q"
 S ^DD(200,.01,1,3,3)="Stuff SIGNATURE BLOCK PRINTED NAME"
 ;
5 ;----- SET "BS5" XREF #5
 ;
 S ^DD(200,.01,1,5,0)="200^BS5^MUMPS"
 S ^DD(200,.01,1,5,1)="Q:$P($G(^VA(200,DA,1)),U,9)']""""  S ^VA(200,""BS5"",$E(X,1)_$E($P(^(1),U,9),6,9),DA)="""""
 S ^DD(200,.01,1,5,2)="Q:$P($G(^VA(200,DA,1)),U,9)']""""  K ^VA(200,""BS5"",$E(X,1)_$E($P(^(1),U,9),6,9),DA)"
 S ^DD(200,.01,1,5,3)="Special BS5 lookup X-ref"
 S ^DD(200,.01,1,5,"%D",0)="^^3^3^2990617^^"
 S ^DD(200,.01,1,5,"%D",1,0)="This X-ref builds the 'BS5' X-ref on name changes."
 S ^DD(200,.01,1,5,"%D",2,0)="The BS5 is the first letter of the last name concatinated with the last"
 S ^DD(200,.01,1,5,"%D",3,0)="four digits of the SSN."
 ;
8 ;----- SET "AG" XREF #8
 ;
 S ^DD(200,.01,1,8,0)="200^AG^MUMPS"
 S ^DD(200,.01,1,8,1)="F X1=0:0 S X1=$O(^VA(200,""AB"",X1)) Q:X1'>0  I $D(^VA(200,""AB"",X1,DA)),$S($D(^DIC(19.1,X1,0)):$P(^(0),U,3)[""l"",1:0) S X2=^(0),^VA(200,""AK.""_$P(X2,U),X,DA)="""""
 S ^DD(200,.01,1,8,2)="S X1=""AK."" F X2=0:0 S X1=$O(^VA(200,X1)) Q:$E(X1,3)'="".""  K ^VA(200,X1,X,DA)"
 S ^DD(200,.01,1,8,3)="Updates the AK.key special lookup X-ref."
 S ^DD(200,.01,1,8,"%D",0)="^^1^1^2920513^"
 S ^DD(200,.01,1,8,"%D",1,0)="Builds the AK.key special lookup X-ref when there is a name change."
 S ^DD(200,.01,1,8,"DT")="2890929"
 ;
9 ;----- SET "ASX" XREF #9
 ;
 S ^DD(200,.01,1,9,0)="200^ASX^MUMPS"
 S ^DD(200,.01,1,9,1)="S ^VA(200,""ASX"",$$EN^XUA4A71(X),DA)="""""
 S ^DD(200,.01,1,9,2)="K ^VA(200,""ASX"",$$EN^XUA4A71(X),DA)"
 S ^DD(200,.01,1,9,3)="LAYGO SOUNDEX X-REF"
 S ^DD(200,.01,1,9,"%D",0)="^^3^3^2920513^^"
 S ^DD(200,.01,1,9,"%D",1,0)="This builds a soundex X-ref so that a check for simular names can be"
 S ^DD(200,.01,1,9,"%D",2,0)="done at the time of LAYGOing to the file."
 S ^DD(200,.01,1,9,"%D",3,0)="It calls XUA4A71 to convert X. The LAYGO test calls XUA4A7."
 S ^DD(200,.01,1,9,"DT")="2920117"
 ;
10 ;----- SET BULLETIN XREF #10
 ;
 S ^DD(200,.01,1,10,0)="^^BULLETIN MESSAGE"
 S ^DD(200,.01,1,10,1)="S Y(0)=X,D0=DA Q:$P($G(^VA(200,D0,1)),U,7)'=DT  K XMB,XMY S XMB(1)=Y(0),XMB=""XMNEWUSER"" D ^XMB:$D(^XMB(3.6,""B"",XMB)) K Y,XMB"
 S ^DD(200,.01,1,10,2)="Q"
 S ^DD(200,.01,1,10,3)="New User Bulletin"
 S ^DD(200,.01,1,10,"%D",0)="^^1^1^3000719^"
 S ^DD(200,.01,1,10,"%D",1,0)="This bulletin is sent whenever a new user is added to the New Person file."
 S ^DD(200,.01,1,10,"CREATE CONDITION")="#30=TODAY"
 S ^DD(200,.01,1,10,"CREATE PARAMETER #1")="NAME"
 S ^DD(200,.01,1,10,"CREATE VALUE")="XMNEWUSER"
 S ^DD(200,.01,1,10,"DELETE VALUE")="NO EFFECT"
 S ^DD(200,.01,1,10,"DT")="3000719"
 ;
11 ;----- SET RAI MDS MONITOR TRIGGER #11
 ;
 S ^DD(200,.01,1,11,0)="^^TRIGGER^46.11^.02"
 S ^DD(200,.01,1,11,1)="Q"
 S ^DD(200,.01,1,11,2)="K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$P($G(^DG(43,1,""HL7"")),U,4)=1 I X S X=DIV X ^DD(200,.01,1,11,89.2) S Y(101)=$S($D(^DGRU(46.11,D0,0)):^(0),1:"""") S X=$P(Y(101),U,2) S D0=I(0,0) S DIU=X K Y S X=DIV S X=X X ^DD(200,.01,1,11,2.4)"
 S ^DD(200,.01,1,11,2.4)="S DIH=$S($D(^DGRU(46.11,DIV(0),0)):^(0),1:""""),DIV=X I $D(^(0)) S $P(^(0),U,2)=DIV,DIH=46.11,DIG=.02 D ^DICR:$O(^DD(DIH,DIG,1,0))>0"
 S ^DD(200,.01,1,11,89.2)="S I(0,0)=$S($D(D0):D0,1:""""),Y(1)=$S($D(^VA(200,D0,0)):^(0),1:"""") S X=$P(Y(1),U,1),X=X S X=X K DIC S DIC=""^DGRU(46.11,"",DIC(0)=""NMFL"",X=""""""""_X_"""""""" D ^DIC S (D,D0,DIV(0))=+Y"
 S ^DD(200,.01,1,11,"%D",0)="^^2^2^2991018^"
 S ^DD(200,.01,1,11,"%D",1,0)="Trigger the Name field before it was changed into the RAI MDS MONITOR"
 S ^DD(200,.01,1,11,"%D",2,0)="file whenever the Name field of the New Person file is added or changed."
 S ^DD(200,.01,1,11,"CREATE VALUE")="NO EFFECT"
 S ^DD(200,.01,1,11,"DELETE CONDITION")="S X=$P($G(^DG(43,1,""HL7"")),U,4)=1"
 S ^DD(200,.01,1,11,"DELETE VALUE")="OLD NAME"
 S ^DD(200,.01,1,11,"DIC")="LOOKUP"
 S ^DD(200,.01,1,11,"DT")="2991018"
 S ^DD(200,.01,1,11,"FIELD")="NAME:RAI MDS MONITOR:#.02"
 ;
12 ;----- SET RAI MDS MONITOR TRIGGER #12      
 ;
 S ^DD(200,.01,1,12,0)="^^TRIGGER^46.11^.03"
 S ^DD(200,.01,1,12,1)="K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$P($G(^DG(43,1,""HL7"")),U,4)=1 I X S X=DIV X ^DD(200,.01,1,12,89.2) S Y(101)=$S($D(^DGRU(46.11,D0,0)):^(0),1:"""") S X=$P(Y(101),U,3) S D0=I(0,0) S DIU=X K Y S X=DIV S X=200 X ^DD(200,.01,1,12,1.4)"
 S ^DD(200,.01,1,12,1.4)="S DIH=$S($D(^DGRU(46.11,DIV(0),0)):^(0),1:""""),DIV=X I $D(^(0)) S $P(^(0),U,3)=DIV,DIH=46.11,DIG=.03 D ^DICR:$O(^DD(DIH,DIG,1,0))>0"
 S ^DD(200,.01,1,12,2)="Q"
 S ^DD(200,.01,1,12,89.2)="S I(0,0)=$S($D(D0):D0,1:""""),Y(1)=$S($D(^VA(200,D0,0)):^(0),1:"""") S X=$P(Y(1),U,1),X=X S X=X K DIC S DIC=""^DGRU(46.11,"",DIC(0)=""NMFL"" D ^DIC S (D,D0,DIV(0))=+Y"
 S ^DD(200,.01,1,12,"%D",0)="^^2^2^2991018^"
 S ^DD(200,.01,1,12,"%D",1,0)="Trigger the New Person file number (#200) into the RAI MDS MONITOR"
 S ^DD(200,.01,1,12,"%D",2,0)="file whenever the New Person name field is added or changed."
 S ^DD(200,.01,1,12,"CREATE CONDITION")="S X=$P($G(^DG(43,1,""HL7"")),U,4)=1"
 S ^DD(200,.01,1,12,"CREATE VALUE")="S X=200"
 S ^DD(200,.01,1,12,"DELETE VALUE")="NO EFFECT"
 S ^DD(200,.01,1,12,"DIC")="LOOKUP"
 S ^DD(200,.01,1,12,"DT")="2991018"
 S ^DD(200,.01,1,12,"FIELD")="NAME:RAI MDS MONITOR:#.03"
 ;
13 ;----- SET RAI MDS MONITOR TRIGGER #13
 ;
 S ^DD(200,.01,1,13,0)="^^TRIGGER^46.11^.04"
 S ^DD(200,.01,1,13,1)="K DIV S DIV=X,D0=DA,DIV(0)=D0 S Y(0)=X S X=$P($G(^DG(43,1,""HL7"")),U,4)=1 I X S X=DIV X ^DD(200,.01,1,13,89.2) S Y(101)=$S($D(^DGRU(46.11,D0,0)):^(0),1:"""") S X=$P(Y(101),U,4) S D0=I(0,0) S DIU=X K Y S X=DIV S X=DA X ^DD(200,.01,1,13,1.4)"
 S ^DD(200,.01,1,13,1.4)="S DIH=$S($D(^DGRU(46.11,DIV(0),0)):^(0),1:""""),DIV=X I $D(^(0)) S $P(^(0),U,4)=DIV,DIH=46.11,DIG=.04 D ^DICR:$O(^DD(DIH,DIG,1,0))>0"
 S ^DD(200,.01,1,13,2)="Q"
 S ^DD(200,.01,1,13,89.2)="S I(0,0)=$S($D(D0):D0,1:""""),Y(1)=$S($D(^VA(200,D0,0)):^(0),1:"""") S X=$P(Y(1),U,1),X=X S X=X K DIC S DIC=""^DGRU(46.11,"",DIC(0)=""NMF"" D ^DIC S (D,D0,DIV(0))=+Y"
 S ^DD(200,.01,1,13,"%D",0)="^^2^2^2991018^"
 S ^DD(200,.01,1,13,"%D",1,0)="Trigger the internal entry number of the entry which was changed or added"
 S ^DD(200,.01,1,13,"%D",2,0)="in the New Person file, into the RAI MDS MONITOR file."
 S ^DD(200,.01,1,13,"CREATE CONDITION")="S X=$P($G(^DG(43,1,""HL7"")),U,4)=1"
 S ^DD(200,.01,1,13,"CREATE VALUE")="S X=DA"
 S ^DD(200,.01,1,13,"DELETE VALUE")="NO EFFECT"
 S ^DD(200,.01,1,13,"DIC")="LOOKUP"
 S ^DD(200,.01,1,13,"DT")="2991018"
 S ^DD(200,.01,1,13,"FIELD")="NAME:RAI MDS MONITOR:#.04"
 ;
90007 ;----- SET TRIGGER IN FILE 200 TO KEEP FILES 3-6-16-200 IN SYNC
 ;      THIS USED TO BE TRIGGER #7 BEFORE THE FILE 200 CONVERSION
 ;      AND BEFORE THE KERNEL PATCHES DELETED IT
 ;
 S ^DD(200,.01,1,90007,0)="^^TRIGGER^16^.01"
 S ^DD(200,.01,1,90007,1)="K DIV S DIV=X,(D0,DIV(0))=DA X ^DD(200,.01,1,90007,89.2) S DIU=$S($D(^DIC(16,D0,0)):$P(^(0),""^"",1),1:""""),D0=DA K Y S X=DIV X ^DD(200,.01,1,90007,1.4)"
 S ^DD(200,.01,1,90007,1.4)="S DIH=$S($D(^DIC(16,DIV(0),0)):$P(^(0),""^"",1),1:"""") I DIH'=DIV,$D(^(0)) S $P(^(0),U,1)=DIV,DIH=16,DIG=.01 D ^DICR:$O(^DD(DIH,DIG,1,0))>0"
 S ^DD(200,.01,1,90007,2)="Q"
 S ^DD(200,.01,1,90007,3)="Edited trigger"
 S ^DD(200,.01,1,90007,89.2)="S Y=$S($D(^DIC(3,D0,0))#2:$P(^(0),""^"",16),1:"""") X:Y'>0 ^DD(200,.01,1,90007,89.3) S (D,D0,DIV(0))=+Y"
 S ^DD(200,.01,1,90007,89.3)="N DD,DO K DIC,DINUM S DIC=""^DIC(16,"",DIC(0)=""NMFL"",DLAYGO=16,XU200=DA,Y=$G(XU16) D:'Y FILE^DICN K DLAYGO,XU200"
 S ^DD(200,.01,1,90007,"%D",0)="^^2^2^2920513^"
 S ^DD(200,.01,1,90007,"%D",1,0)="This is the X-ref that keeps names in 3-16 the same as in 200."
 S ^DD(200,.01,1,90007,"%D",2,0)="It also will LAYGO new entries if they are missing."
 S ^DD(200,.01,1,90007,"%D",3,0)="It used to be x-ref #7 before File 200 conversion."
 S ^DD(200,.01,1,90007,"CREATE VALUE")="NAME"
 S ^DD(200,.01,1,90007,"DELETE VALUE")="NO EFFECT"
 S ^DD(200,.01,1,90007,"DIC")="LOOKUP"
 S ^DD(200,.01,1,90007,"FIELD")="NAME:PERSON"
 ;
90008 ;----- SET CROSSREFERENCE 'IHSAH' IN NEW PERSON FILE TO UPDATE
 ;      THE PERSON FILE POINTER FIELD.  THIS USED TO BE THE 'AH'
 ;      CROSSREFERENCE #10 BEFORE THE FILE 200 CONVERSION AND BEFORE
 ;      THE KERNEL PATCHES CHANGED IT
 ;
 S ^DD(200,.01,1,90008,0)="200^IHSAH^MUMPS"
 S ^DD(200,.01,1,90008,1)="N % S:'$P(^VA(200,DA,0),U,16) %=$P($G(^DIC(3,DA,0)),U,16) S:$G(%) $P(^VA(200,DA,0),U,16)=%,^VA(200,""A16"",%,DA)="""""
 S ^DD(200,.01,1,90008,2)="I 0 S X=X"
 S ^DD(200,.01,1,90008,3)="Special PERSON FILE POINTER"
 S ^DD(200,.01,1,90008,"%D",0)="^^2^2^2920810^"
 S ^DD(200,.01,1,90008,"%D",1,0)="This MUMPS cross-reference sets the PERSON FILE POINTER in place and sets"
 S ^DD(200,.01,1,90008,"%D",2,0)="the 'A16' X-ref of that field. See the field description for more details."
 S ^DD(200,.01,1,90008,"%D",3,0)="This used to be the 'AH' xref before the file 200 conversion."
 S ^DD(200,.01,1,90008,"DT")="2920810"
 Q
X200535 ;----- RESET AIHS CROSSREFERENCE ON FIELD 53.5 OF FILE 200
 ;
 S ^DD(200,53.5,1,1,0)="200^AIHS^MUMPS"
 S ^DD(200,53.5,1,1,1)="G F6S^AVA4A7"
 S ^DD(200,53.5,1,1,2)="G F6K^AVA4A7"
 S ^DD(200,53.5,1,1,3)="GIVES PROVIDER KEY; UPDATES ENTRY IN FILE 6"
 S ^DD(200,53.5,1,1,"DT")="2960516"
 Q
