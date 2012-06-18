INHSYS02 ;SLT,JPD; 25 Sep 95 08:32;GIS configuration compilation utility
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 Q
TTYPE(INY,%XIEN,INREPRT,%LEVEL) ;Check pointer pieces of 4000 file
 ;Input:
 ; INY-Data from node
 ; %XIEN-ien from 4000 file
 ; %LEVEL - Pointer level
 N %IP6,%IP9,%IP2,%IP3,%IP17,%LEN,I,J
 ; -- set Parent, Acknowlege, Destination and Script pieces (all ptr's)
 S %IP6=+$P(INY,U,6),%IP9=+$P(INY,U,9),%IP2=+$P(INY,U,2),%IP3=+$P(INY,U,3),%IP17=+$P(INY,U,17)
 ; - If parent TT pointer to file 4000 exists
 I %IP6 D XTRK0^INHSYS01(%IP6,4000,"^INRHT(",INREPRT,%LEVEL) Q:INPOP
 ; - If Acknowledge TT pointer to file 4000 exists
 I %IP9 D XTRK0^INHSYS01(%IP9,4000,"^INRHT(",INREPRT,%LEVEL) Q:INPOP
 ; - If Destination pointer to file 4005 exists
 I %IP2 D XTRK0^INHSYS01(%IP2,4005,"^INRHD(",INREPRT,%LEVEL) Q:INPOP
 ; - If Background Process Control 4004 exists
 I %IP17 D XTRK0^INHSYS01(%IP17,4004,"^INTHPC(",INREPRT,%LEVEL) Q:INPOP
 ; - If Script file pointer to file 4006 exists
 I %IP3 D  Q:INPOP
 .;If TT is a parent, and points to script files and not replicate
 .I '%IP6,'$D(^INRHR("AC",%XIEN)) W !!,"Note...Parent 4000 - ^INRHT("_%XIEN_" points to script file ^INRHS("_%IP3,!
 .;interface script file 4006
 .D XTRK0^INHSYS01(%IP3,4006,"^INRHS(",INREPRT,%LEVEL) Q:INPOP
 .;Script generator Messages
 .S INSGM=$$SGM(%XIEN,%IP3),%LEN=$L(INSGM,U)
 .F I=1:1:%LEN D  Q:INPOP
 ..S INIEN=$P(INSGM,U,I) Q:'INIEN
 ..;script generator message exists
 ..D XTRK0^INHSYS01(INIEN,4011,"^INTHL7M(",INREPRT,%LEVEL)
 Q:INPOP  F J="B","AC" S I=""  F  S I=$O(^INRHR("B",%XIEN,I)) Q:I=""  D XTRK0^INHSYS01(I,4020,"^INRHR(",INREPRT,%LEVEL) Q:INPOP
 ;Get Destination files that point to 4000 file
 Q:INPOP  S I="" F  S I=$O(^INRHD(I)) Q:I=""  D  Q:INPOP
 .N INODE
 .S INODE=$G(^INRHD(I,0)) Q:INODE=""
 .I $P(INODE,U,2)=%XIEN D XTRK0^INHSYS01(I,4005,"^INRHD(",INREPRT,%LEVEL) Q:INPOP
 .I $P(INODE,U,10)=%XIEN D XTRK0^INHSYS01(I,4005,"^INRHD(",INREPRT,%LEVEL)
 ;Get TTypes if parent
 Q:INPOP  S I="" F  S I=$O(^INRHT("AC",%XIEN,I)) Q:I=""  D XTRK0^INHSYS01(I,4000,"^INRHT(",INREPRT,%LEVEL) Q:INPOP
 Q
SGM(%T,%SIEN) ;build list of Script Generator Message iens i.e. ien^ien^...
 ;input:
 ;  %T - Transaction Type ien
 ;  %SIEN - Script ien (only save one passed in)
 ;returns:
 ;  INY  - Script Generator Message ien list i.e. ien^ien^...^ien
 ;
 N %IEN,INY,%FOUND
 S INY="",(%FOUND,%IEN)=0
 F  S %IEN=$O(^INTHL7M(%IEN)) Q:'%IEN  I $D(^INTHL7M(%IEN,2,"B",%T)) D
 .;input script or output script pointer exist
 .I $P(^INTHL7M(%IEN,"S"),U)'=%SIEN,$P(^("S"),U,2)'=%SIEN W !,"Note...  Generated Script for Transaction Type ^INRHT("_%T_" doesn't agree with Script Generator Message ^INTHL7M("_%IEN
 .S INY=INY_$S(INY]"":U,1:"")_%IEN
 .S %FOUND=%FOUND+1
 I %FOUND>1 D
 .W !,"Note... Multiple Script Generator Message files point to Transaction Type record ^INRHT("_%T,!
 .F %IEN=1:1:%FOUND W ?15,$P(INY,U,%IEN),?25,$P(^INTHL7M(%IEN,0),U),!
 Q INY
