DGENELA ;ALB/CJM,KCL,Zoltan - Patient Eligibility API ; 12/6/00 10:23pm
 ;;5.3;Registration;**121,147,232,314**;Aug 13,1993
 ;
GET(DFN,DGELG) ;
 ;Description: Used to obtain the patient eligibility data.
 ;  The data is placed in the local DGELG array.
 ;Input:
 ;  DFN - internal entry number of a record in the PATIENT file
 ;Output:
 ;  Function Value - returns 1 on success, 0 on failure
 ;  DGELG - this is  a local array that will be used to return patient eligibility data. The array subscripts and the fields mapped to are defined below. (pass by reference)
 ;
 ;suscript             field name
 ;"DFN"                ien Patient record
 ;"ELIG","CODE"        Primary Eligibility Code
 ;"ELIG","CODE",<ien>  Patient Eligibilities
 ;"SC"                 Service Connected
 ;"SCPER"              Service Connected Percentage
 ;"POW"                POW Status Indicated
 ;"A&A"                Receiving A&A Benefits
 ;"HB"                 Receiving Housebound Benefits
 ;"VAPEN"              Receiving a VA Pension
 ;"VACKAMT"            Total Annual VA Check Amount
 ;"DISRET"             Disability Ret. From Military
 ;"MEDICAID"           Medicaid
 ;"AO"                 Exposed to Agent Orange
 ;"IR"                 Radiation Exposure Indicated
 ;"EC"                 Environmental Contaminants
 ;"MTSTA"              Means Test Status
 ;P&T                  P&T
 ;POS                  PERIOD OF SERVICE
 ;UNEMPLOY             UNEMPLOYABLE
 ;SCAWDATE             SC AWARD DATE
 ;RATEINC              RATED INCOMPETENT
 ;CLAIMNUM             CLAIM NUMBER
 ;** removed ***     CLAIMLOC             *CLAIM FOLDER LOCATION
 ;VADISAB              RECEIVING VA DISABILITY?
 ;ELIGSTA              ELIGIBILITY STATUS
 ;ELIGSTADATE          ELIGIBILITY STATUS DATE
 ;ELIGVERIF            ELIGIBILITY VERIF. METHOD
 ;ELIGENTBY            ELIGIBILITY STATUS ENTERED BY
 ;RATEDIS
 ;  <COUNT>,"RD"      RATED DISABILITY
 ;  <COUNT>,"PER"      DISABILITY %
 ;  <COUNT>,"RDSC"     SERVICE CONNECTED
 ;"VCD"               Veteran Catastrophically Disabled? (#.39)
 ;"PH"                PURPLE HEART INDICATED
 ;
 K DGELG
 S DGELG=""
 Q:'$D(^DPT(DFN)) 0
 N NODE,SUBREC,COUNT,CODE,IEN
 ;
 S DGELG("DFN")=DFN
 S DGELG("VCD")=$$VCD^DGENA5(DFN)
 ;
 ;
 S NODE=$G(^DPT(DFN,.29))
 S DGELG("RATEINC")=$P(NODE,"^",12)
 ;
 S NODE=$G(^DPT(DFN,.3))
 S DGELG("SC")=$P(NODE,"^")
 S DGELG("SCPER")=$P(NODE,"^",2)
 S DGELG("P&T")=$P(NODE,"^",4)
 S DGELG("UNEMPLOY")=$P(NODE,"^",5)
 S DGELG("SCAWDATE")=$P(NODE,"^",12)
 S DGELG("VADISAB")=$P(NODE,"^",11)
 ;
 S NODE=$G(^DPT(DFN,.31))
 S DGELG("CLAIMNUM")=$P(NODE,"^",3)
 ;S DGELG("CLAIMLOC")=$P(NODE,"^",2) ;removed
 ;
 S NODE=$G(^DPT(DFN,.32))
 S DGELG("POS")=$P(NODE,"^",3)
 ;
 S NODE=$G(^DPT(DFN,.36))
 S DGELG("ELIG","CODE")=$P(NODE,"^") ;primary eligibility
 S DGELG("DISRET")=$P(NODE,"^",2)
 ;
 S NODE=$G(^DPT(DFN,.38))
 S DGELG("MEDICAID")=$P(NODE,"^")
 ;
 S NODE=$G(^DPT(DFN,.361))
 S DGELG("ELIGSTA")=$P(NODE,"^")
 S DGELG("ELIGSTADATE")=$P(NODE,"^",2)
 S DGELG("ELIGVERIF")=$P(NODE,"^",5)
 S DGELG("ELIGENTBY")=$P(NODE,"^",6)
 ;
 S NODE=$G(^DPT(DFN,.362))
 S DGELG("VACKAMT")=$P(NODE,"^",20)
 S DGELG("VAPEN")=$P(NODE,"^",14)
 S DGELG("A&A")=$P(NODE,"^",12)
 S DGELG("HB")=$P(NODE,"^",13)
 ;
 ;
 S NODE=$G(^DPT(DFN,.321))
 S DGELG("AO")=$P(NODE,"^",2)
 S DGELG("IR")=$P(NODE,"^",3)
 ;
 S NODE=$G(^DPT(DFN,.322))
 S DGELG("EC")=$P(NODE,"^",13)
 ;
 S NODE=$G(^DPT(DFN,.52))
 S DGELG("POW")=$P(NODE,"^",5)
 ;
 ; Purple Heart Indicator
 S NODE=$G(^DPT(DFN,.53))
 S DGELG("PH")=$P(NODE,"^")
 ;
 ;means test category
 S DGELG("MTSTA")=""
 S IEN=$P($$LST^DGMTU(DFN),"^")
 I IEN S DGELG("MTSTA")=$P($G(^DGMT(408.31,IEN,0)),"^",3)
 ;
 ;get the other eligibilities multiple
 S SUBREC=0
 F  S SUBREC=$O(^DPT(DFN,"E",SUBREC)) Q:'SUBREC  D
 .S CODE=+$G(^DPT(DFN,"E",SUBREC,0))
 .;
 .;need to check the "B" x-ref, because when a code is deleted from the multiple, the kill logic is executed BEFORE the data is actuall removed - but the "B" x-ref has been deleted at this point
 .I CODE,$D(^DPT(DFN,"E","B",CODE)) S DGELG("ELIG","CODE",CODE)=SUBREC
 ;
 ;rated disability multiple
 S SUBREC=0,COUNT=0
 F  S SUBREC=$O(^DPT(DFN,.372,SUBREC)) Q:'SUBREC  D
 .S NODE=$G(^DPT(DFN,.372,SUBREC,0))
 .Q:'$P(NODE,"^")
 .S COUNT=COUNT+1
 .S DGELG("RATEDIS",COUNT,"RD")=$P(NODE,"^")
 .S DGELG("RATEDIS",COUNT,"PER")=$P(NODE,"^",2)
 .S DGELG("RATEDIS",COUNT,"RDSC")=$P(NODE,"^",3)
 ;
 Q 1
 ;
NATNAME(CODE) ;
 ;Description: Given an entry in file #8, Eligibility Code file,
 ;  finds the corresponding entry in file 8.1, MAS Eligbility Code file,
 ;  and returns the name
 ;Input:
 ;  CODE - pointer to file #8
 ;Output:
 ;  Function Value - name of corresponding code in file #8.1
 ;
 Q:'$G(CODE) ""
 Q $$CODENAME($P($G(^DIC(8,CODE,0)),"^",9))
 ;
NATCODE(CODE) ;
 ;Description: Given an entry in file #8, Eligibility Code file,
 ;  finds the corresponding entry in file 8.1, MAS Eligbility Code file
 ;Input:
 ;  CODE - pointer to file #8
 ;Output:
 ;  Function Value - pointer to file #8.1
 ;
 Q:'$G(CODE) ""
 Q $P($G(^DIC(8,CODE,0)),"^",9)
 ;
CODENAME(CODE) ;
 ;Description: Given a pointer to file #8.1, MAS Eligibility Code file,
 ;  it returns the name of the code 
 ;Input:
 ;  CODE - pointer to file #8.1
 ;Output:
 ;  Function Value - name of the code pointed to
 ;
 Q:'$G(CODE) ""
 Q $P($G(^DIC(8.1,CODE,0)),"^")
 ;
ELIGSTAT(DFN,DGELG) ;
 ;Description: Used to get the ELIGIBILITY STATUS and the 
 ;ELIGIBILITY STATUS DATE of the patient.
 ;
 ;Input:
 ;  DFN - ien of patient record
 ;
 ;Ouput:
 ;  Function Value - 1 on success, 0 on failure
 ;  DGELG array (pass by reference)
 ;    "ELIGSTA" - ELIGIBILITY STATUS
 ;    "ELIGSTADATE" - ELIGIBILITY STATUS DATE
 ;
 N NODE,SUCCESS
 D
 .S SUCCESS=1
 .I '$G(DFN) S SUCCESS=0 Q
 .S NODE=$G(^DPT(DFN,.361))
 .S DGELG("ELIGSTA")=$P(NODE,"^")
 .S DGELG("ELIGSTADATE")=$P(NODE,"^",2)
 Q SUCCESS
