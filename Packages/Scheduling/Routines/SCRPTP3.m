SCRPTP3 ;ALB/CMM - List of Team's Patients ; 29 Jun 99  04:11PM
 ;;5.3;Scheduling;**41,48,98,177,231**;AUG 13, 1993
 ;IHS/ANMC/LJF 11/03/2000 used IHS code for last/next appts
 ;
 ;List of Team's Patients Report
 ;
HITS(ARRY,TIEN) ;
 ;ARRY - list of patients for a given team
 ;TIEN - team ien
 ;
 N PTIEN,PIEN,PTNAME,PNAME,PTAI,NXT,NODE,CIEN,CNAME,INAME,INST,LAST,NEXT
 N PAIEN,PC,PHONE,PNODE,PTPA,PTPAN,ROL,PID,TINFO,TNAME,TPIEN,TPNODE
 N CNT,TPA,FLAG,DFN,VA,VAERR,PCAP,ROLN
 S INACTIVE=0
 S NXT=0
 F  S NXT=$O(@ARRY@(NXT)) Q:NXT=""!(NXT'?.N)  D
 .S NODE=$G(@ARRY@(NXT))
 .Q:NODE=""
 .S PTIEN=+$P(NODE,"^") ;patient ien
 .S PTNAME=$P(NODE,"^",2) ;patient name
 .S PTAI=+$P(NODE,"^",3) ;patient team assignment ien (#404.42)
 .;
 .S PNODE=$G(^DPT(PTIEN,0))
 .Q:PNODE=""
 .S DFN=PTIEN
 .D PID^VADPT6
 .S PID=VA("BID")
 .;
 .S TPA=$$TPAR(PTAI,"")
 .I TPA'=-1 D
 ..S PIEN=$P(TPA,"^")
 ..S PNAME=$P(TPA,"^",2)
 ..S CNAME=$P(TPA,"^",3)
 ..S LAST=$P(TPA,"^",4)
 ..S NEXT=$P(TPA,"^",5)
 ..;
 ..S FLAG="Y"
 ..S TINFO=$$TINF^SCRPTP(TIEN) ;team information
 ..S INST=+$P(TINFO,"^") ;institution ien
 ..S INAME=$P($G(^DIC(4,INST,0)),"^") ;institution name
 ..S PHONE=$P(TINFO,"^",4) ;team phone
 ..S PC=$P(TINFO,"^",3) ;primary care?
 ..S TNAME=$P(TINFO,"^",2) ;team name
 ..;
 ..D TFORMAT^SCRPTP2(INST,INAME,TIEN,TNAME,PHONE,PC)
 ..D FORMAT^SCRPTP(INST,TIEN,PTIEN,PTNAME,PID,PIEN,PNAME,CNAME,LAST,NEXT)
 .;
 .;check for other assignments
 .N TPIN
 .S CNT=""
 .F  S CNT=$O(^SCPT(404.43,"B",PTAI,CNT)) Q:CNT=""!(CNT'?.N)  D
 ..S TPIN=$$TPAR(PTAI,CNT)
 ..Q:TPIN=-1
 ..S PIEN=$P(TPIN,"^")
 ..S PNAME=$P(TPIN,"^",2)
 ..S CNAME=$P(TPIN,"^",3)
 ..S LAST=$P(TPIN,"^",4)
 ..S NEXT=$P(TPIN,"^",5)
 ..S ROLN=$P(TPIN,U,6)
 ..S PCAP=$P(TPIN,U,7)
 ..I '$D(FLAG) D
 ...S TINFO=$$TINF^SCRPTP(TIEN) ;team information
 ...S INST=+$P(TINFO,"^") ;institution ien
 ...S INAME=$P($G(^DIC(4,INST,0)),"^") ;institution name
 ...S PHONE=$P(TINFO,"^",4) ;team phone
 ...S PC=$P(TINFO,"^",3) ;primary care?
 ...S TNAME=$P(TINFO,"^",2) ;team name
 ...;
 ...D TFORMAT^SCRPTP2(INST,INAME,TIEN,TNAME,PHONE,PC)
 ..D FORMAT^SCRPTP(INST,TIEN,PTIEN,PTNAME,PID,PIEN,PNAME,CNAME,LAST,NEXT,ROLN,PCAP)
 I INACTIVE S @STORE@(INST,TIEN,"INACT")=""
 Q
 ;
TPAR(PTAI,START) ;
 N PTPA,TPIEN,TPNODE,ROL,CNAME,CIEN,ENROLL,OKAY,PNAME,NEXT,LAST,PAIEN
 N ROLN,PCAP
 I '$D(^SCPT(404.43,"B",PTAI)) Q "0^[Not Assigned]"
 ; ^ no patient team position assignment
 IF START="" D
 .S PTPA=$O(^SCPT(404.43,"B",PTAI,START))
 ELSE  D
 .S PTPA=START
 I PTPA="" Q "0^[Not Assigned]"
 S PTPAN=$G(^SCPT(404.43,PTPA,0)) ;patient team position assignment node
 I PTPAN=""!(PTPAN=0) Q "0^[Not Assigned]"
 I $P(PTPAN,"^",4)'="",$P(PTPAN,"^",4)<DT Q -1
 S TPIEN=+$P(PTPAN,"^",2) ;team position ien (#404.57)
 I '$D(^SCTM(404.57,TPIEN,0)) Q "0^[Not Assigned]"
 S TPNODE=$G(^SCTM(404.57,TPIEN,0))
 I TPNODE="" Q "0^[Not Assigned]"
 S ROL=+$P(TPNODE,"^",3) ;role for position (ien)
 Q:'$D(ROLE(ROL))&(ROLE'=1) -1
 ; ^ not a selected role
 S ROLN=$P($G(^SD(403.46,ROL,0)),U) ;role name
 ;
 S PCAP=$S($P(PTPAN,U,5)<1:"NPC",+$$OKPREC3^SCMCLK(TPIEN,DT)>0:" AP",1:"PCP") ;PC?
 ;
 S CIEN=+$P(TPNODE,"^",9) ;associated clinic ien
 S CNAME=$P($G(^SC(CIEN,0)),"^") ;clinic name
 ;check patient status
 S OKAY=""
 I CIEN>0&(PSTAT'=1) S OKAY=$$PST^SCRPTP(PTIEN,CIEN)
 Q:(CIEN>0)&('OKAY)&(PSTAT'=1) -1
 ; ^ not selected patient status
 ;
 S ENROLL=$$ENRL(PTIEN,CIEN) ;enrolled in associated clinic
 I 'ENROLL S CNAME="",CIEN=0
 ;
 S PAIEN=$$CHK(TPIEN)
 I +PAIEN'=0 S PIEN=+PAIEN,PNAME=$P(PAIEN,"^",2) ; practitioner's name
 ;SD*5.3*231
 I +PAIEN=0 S PIEN=0,PNAME="[Inactive Position]"
 ;
 S (NEXT,LAST)=""
 ;I +CIEN>0 S NEXT=$$GETNEXT^SCRPU3(PTIEN,CIEN) ;next appointment;IHS/ANMC/LJF 11/03/2000
 ;I +CIEN>0 S LAST=$$GETLAST^SCRPU3(PTIEN,CIEN) ;last appointment;IHS/ANMC/LJF 11/03/2000
 S NEXT=$$GETAPPT^BSDSCEC(PTIEN,TIEN,"NEXT")  ;IHS/ANMC/LJF 11/03/2000
 S LAST=$$GETAPPT^BSDSCEC(PTIEN,TIEN,"LAST")  ;IHS/ANMC/LJF 11/03/2000
 ;
 Q PIEN_U_PNAME_U_CNAME_U_LAST_U_NEXT_U_ROLN_U_PCAP
 ;
ENRL(PTIEN,CLIEN) ;
 ;
 N FOUND,ENODE,EN,NXT
 S FOUND=0
 Q:'$D(^DPT(PTIEN,"DE","B",CLIEN)) FOUND
 S EN=$O(^DPT(PTIEN,"DE","B",CLIEN,""))
 Q:EN=""!'$D(^DPT(PTIEN,"DE",EN,1)) FOUND
 S NXT=""
 F  S NXT=$O(^DPT(PTIEN,"DE",EN,1,NXT)) Q:(FOUND)!(NXT="")!(NXT'?.N)  D
 .;check if active enrollment
 .S ENODE=$G(^DPT(PTIEN,"DE",EN,1,NXT,0))
 .I $P(ENODE,"^",3)'="",$P(ENODE,"^",3)<DT+1!$P(ENODE,"^")>DT Q  ;not active enrollment
 .;                      ^ discharge date     ^ enrollment date
 .S FOUND=1
 Q FOUND
 ;
CHK(TPIEN) ;assigned to a position
 ;TPIEN - ien of 404.57 Team Position file
 ;returns:  ien of 200 New Person file
 N EN,PLIST,PERR,ERR,NAME
 S PLIST="PLST",PERR="PRR"
 K @PLIST,@PERR
 S ERR=$$PRTP^SCAPMC8(TPIEN,,.PLIST,.PERR)
 I '$D(@PERR) D
 .S EN=$P($G(@PLIST@(1)),"^") ;ien of new person file
 .S NAME=$P($G(@PLIST@(1)),"^",2) ; new person name
 K @PLIST,@PERR
 Q EN_"^"_NAME
 ;
