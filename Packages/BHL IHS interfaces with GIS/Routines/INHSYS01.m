INHSYS01 ;SLT,JPD; 1 Apr 99 10:05;GIS configuration compilation utility
 ;;3.01;BHL IHS Interfaces with GIS;;JUL 01, 2001
 ;COPYRIGHT 1991-2000 SAIC
 ;CHCS TOOLS_460; GEN 3; 17-JUL-1997
 ;COPYRIGHT 1992 SAIC
 Q
XTRK(%XIEN,%ROOT,%UTL,%FILE,INREPRT,%LEVEL) ;global data extract and store
 ;input:
 ;  %XIEN - ien of RECORD extracting data from
 ;  %ROOT - global root in fileman format
 ;  %UTL  - temporary storage buffer
 ;  %FILE - file 4000,4005,4006,4004,4011,4010,4012,4090.2,4012.1,4020 
 ;  INREPRT - 0-No report
 ;            1-Report
 ;  %LEVEL - Indentation level of report
 N ND,INY,GBL,INIEN,INCHLD,I,INBPC,INSGM,INSGS,INSGF,INSGSF
 Q:'%XIEN
 S ND=%ROOT_%XIEN_")",INREPRT=+$G(INREPRT)
 ;
 ;loop through file store in ^UTILITY and get pointer relationships
 F  S ND=$Q(@ND) Q:%XIEN'=+$P(ND,%ROOT,2)  D  Q:INPOP
 .;get data and store in UTILITY global
 .S INY=@ND,GBL=%UTL_$P(ND,%ROOT,2),@GBL=INY
 .I $$ZRONOD(ND,%XIEN,%ROOT) D  Q:INPOP
 ..;do report, store copy of node for later
 ..I INREPRT D RPRT1^INHSYSUT(%LEVEL,%FILE,ND) S ^UTILITY("SVD",$J,ND)=""
 .;
 .;Check Transaction type file for pointers
 .I %FILE=4000,$$ZRONOD(ND,%XIEN,%ROOT) D TTYPE^INHSYS02(INY,%XIEN,INREPRT,%LEVEL)
 .;
 .;Interface destination file 4005
 .I %FILE=4005,$$ZRONOD(ND,%XIEN,%ROOT) D DF(INY,%XIEN,INREPRT,%LEVEL)
 .;
 .;Background Processes file 4004
 .I %FILE=4004,$$ZRONOD(ND,%XIEN,%ROOT),+$P(INY,U,7) D XTRK0(+$P(INY,U,7),4005,"^INRHD(",INREPRT,%LEVEL)
 .;
 .;Script Generator Message File 4011
 .I %FILE=4011,$$ZRONOD(ND,%XIEN,%ROOT) D SEGS(%XIEN,INREPRT,%LEVEL)
 .;
 .;Script Generator Segment File 4010
 .I %FILE=4010,$$ZRONOD(ND,%XIEN,%ROOT) D FLDS(%XIEN,INREPRT,%LEVEL)
 .;
 .;Script Generator Field Field File 4012
 .I %FILE=4012,$$ZRONOD(ND,%XIEN,%ROOT) D MAP(%ROOT,%XIEN,INREPRT,%LEVEL)
 .;
 .;Interface Message Replication
 .I %FILE=4020,$$ZRONOD(ND,%XIEN,%ROOT),+$P(INY,U,2) D XTRK0(+$P(INY,U,2),4000,"^INRHT(",INREPRT,%LEVEL)
 .;don't take 4012.1 data type pointer
 .;I %FILE=4090.2 don't do anything with data element map func file
 .;I %FILE=4012.1 - script gen data type file points to nothing
 .;I %FILE=4006 - Points to nothing
 Q
 ;
MAP(%ROOT,%XIEN,INREPRT,%LEVEL) ;Map file
 ; Input:
 ; %ROOT - Global root in fileman format
 ; %XIEN - Map File ien
 ; %LEVEL - Pointer level
 N INIEN
 ;map pointer to 4090.2 data element map function file
 S INIEN=$G(@$E(%ROOT,1,$L(%ROOT)-1)@(%XIEN,50))
 ;extract 4090.2
 I INIEN D XTRK0(INIEN,4090.2,"^INVD(",INREPRT,%LEVEL)
 Q
XTRK0(%INP,%FL,%ND,INREPRT,%LEVEL) ;
 ; %INP - Pointer to file from piece
 ; %FL - DD file number
 ; %ND - Root
 ; INREPRT - 0 no report 1 - report
 ; %LEVEL - Pointer level
 ;
 I '$D(^UTILITY($J,%FL,%INP)) D XTRK(%INP,%ND,"^UTILITY($J,"""_%FL_""",",%FL,INREPRT,%LEVEL+1)
 Q
DF(INY,%XIEN,INREPRT,%LEVEL) ;Destination file
 ;Input:
 ; INY-Data from node
 ; %XIEN - ien of 4005
 ; INREPRT - 0 no report
 ;          1 report
 ; %LEVEL - Pointer level
 N %IP2,%IP10
 ; -- Transaction Type and Acceptance TT
 S %IP2=+$P(INY,U,2),%IP10=+$P(INY,U,10)
 ; - TT pointer to file 4000 exists
 I %IP2 D XTRK0(%IP2,4000,"^INRHT(",INREPRT,%LEVEL) Q:INPOP
 ; - Acceptance TT pointer to file 4000 exists
 I %IP10 D XTRK0(%IP10,4000,"^INRHT(",INREPRT,%LEVEL) Q:INPOP
 ; - Primary Destination pointers to 4005, backwards and forwards
 D DP(%XIEN,INREPRT,%LEVEL) Q:INPOP
 ;Look for background process which points to this 4005
 D BP(%XIEN,INREPRT,%LEVEL) Q:INPOP
 Q
DP(%XIEN,INREPRT,%LEVEL) ;Primary Destination Pointers 4005
 ; Input: 
 ; %XIEN - Ien of current entry
 ; INREPRT - 0 no report
 ;          1 report
 ; %LEVEL - Pointer level
 N INIEN
 ; If a sub-destination, Get primary
 S INIEN=$G(^INRHD(%XIEN,7)),INIEN=$P(INIEN,U,2)
 I INIEN D XTRK0(INIEN,4005,"^INRHD(",INREPRT,%LEVEL)
 ; Get sub-destinations
 S INIEN=""
 F  S INIEN=$O(^INRHD("APD",%XIEN,INIEN)) Q:'INIEN  D XTRK0(INIEN,4005,"^INRHD(",INREPRT,%LEVEL) Q:INPOP
 Q
BP(%XIEN,INREPRT,%LEVEL) ;Background processes 4004
 ; Input: 
 ; %XIEN - Ien of destination file
 ; INREPRT - 0 no report
 ;          1 report
 ; %LEVEL - Pointer level
 N INBPC,%LEN,INIEN,I
 S INBPC=$$BPC(%XIEN),%LEN=$L(INBPC,U)
 F I=1:1:%LEN D  Q:INPOP
 .S INIEN=$P(INBPC,U,I) Q:'INIEN
 .;Background Process Control entry
 .D XTRK0(INIEN,4004,"^INTHPC(",INREPRT,%LEVEL)
 Q
BPC(X) ;find all background processes which point to this destination 4004 cont
 ;input:
 ;  X - destination ien
 ;return:
 ;  INY - '^' delimited string of background process iens
 ;
 N INY,%A
 S %A=0,INY=""
 F  S %A=$O(^INTHPC(%A)) Q:'%A  D
 .I $P($G(^INTHPC(%A,0)),U,7)=X S INY=INY_$S(INY]"":U,1:"")_%A
 Q INY
SEGS(%XIEN,INREPRT,%LEVEL) ;Script segs 4011
 ; Input:
 ; %XIEN - Scripts file Ien
 ; INREPRT - 0 no report
 ;          1 report
 ; %LEVEL - Pointer level
 N INSGS,%LEN,I,INIEN
 S INSGS=$$SGS(%XIEN),%LEN=$L(INSGS,U)
 F I=1:1:%LEN D  Q:INPOP
 .S INIEN=$P(INSGS,U,I)
 .;4010's script generator segment file entries
 .I INIEN D XTRK0(INIEN,4010,"^INTHL7S(",INREPRT,%LEVEL)
 Q
SGS(%XIEN) ;return '^' delimited string of segment iens
 ;input:
 ;  %XIEN - Script Generator Message ien
 ;return:
 ;  INY - '^' delimited string of segment iens
 ;
 N INSEG,INPSEG,DA,INY
 ;figure out which 4010's to save
 S (INY,INSEG)="" F  S INSEG=$O(^INTHL7M(%XIEN,1,"B",INSEG)) Q:'INSEG  D
 .S INY=INY_$S(INY]"":U,1:"")_INSEG
 .S DA=$O(^INTHL7M(%XIEN,1,"B",INSEG,"")),INPSEG=$S(DA'="":$P($G(^INTHL7M(%XIEN,1,DA,0)),U,11),1:"")
 .S INY=INY_$S(INY]""&(INPSEG]""):U,1:"")_INPSEG
 Q INY
 ;
FLDS(%XIEN,INREPRT,%LEVEL) ;Fields file - 4012
 ; Input:
 ; %XIEN - Fields File Ien
 ; INREPRT - 0 no report
 ;          1 report
 ; %LEVEL - Pointer level
 N INSGF,INSGSF,I,INIEN,J
 ;field multiple of 4010 script gen seg file
 S INSGF=$$SGF(%XIEN,.INSGF) F I=1:1:INSGF D  Q:INPOP
 .S INIEN=INSGF(I) Q:'INIEN
 .;script generator field exists
 .Q:$D(^UTILITY($J,4012,INIEN))
 .;get sub field multiple entry of 4012 script gen field file
 .K INSGSF S INSGSF=$$SGSF(INIEN,.INSGSF) F J=1:1:INSGSF D  Q:INPOP
 ..N INIEN S INIEN=INSGSF(J)
 ..I INIEN D XTRK0(INIEN,4012,"^INTHL7F(",INREPRT,%LEVEL)
 Q
SGF(X,INSGF) ;return the number of field iens found
 ;input:
 ;  X - Segment ien
 ;  INSGF - Array of field iens built, passed by referrence
 ;
 N INFLD,INY
 S (INFLD,INY)=""
 F  S INFLD=$O(^INTHL7S(X,1,"B",INFLD)) Q:'INFLD  S INY=INY+1,INSGF(INY)=INFLD
 Q +INY
 ;
SGSF(X,INSGSF) ;return the number of sub-field iens
 ;input:
 ;  X - field ien
 ;  INSGSF - Array of subfield iens built, passed by referrence
 ;
 N INFLD,INY
 S INFLD="",INY=1,INSGSF(1)=X
 F  S INFLD=$O(^INTHL7F(X,10,"B",INFLD)) Q:'INFLD  S INY=INY+1,INSGSF(INY)=INFLD
 Q +INY
ZRONOD(N,X,R) ;is node the first level zero node?
 ;input:
 ;  N - node
 ;  X - ien
 ;  R - global root
 ;Returns 1 if node is 0 node, 0 if not
 N %ZND S %ZND=R_X_",0)"
 Q N=%ZND
