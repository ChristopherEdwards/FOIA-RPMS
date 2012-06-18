LA7VORU1 ;VA/DALOI/JMC - Builder of HL7 Lab Results Microbiology OBR/OBX/NTE ;JUL 06, 2010 3:14 PM
 ;;5.2;AUTOMATED LAB INSTRUMENTS;**46,64,1027**;NOV 01, 1997
 Q
 ;
 ;
MI ; Build segments for "MI" subscript
 ;
 N LA7ID,LA7IDT,LA7IENS,LA7NLT,LRDFN,LRIDT,LRSB,LRSS
 ;
 S LRDFN=LA("LRDFN"),LRSS=LA("SUB"),(LA7IENS,LRIDT)=LA("LRIDT")
 ;
 ; Bacteriology Report
 I $D(^LR(LRDFN,LRSS,LRIDT,1)) D
 . S LRSB=11,LA7NLT="87993.0000"
 . D OBR^LA7VORU
 . D NTE^LA7VORU
 . F LRSB=1,1.5,11 D RPTNTE
 . N LRSB
 . S LA7OBXSN=0
 . ; Report gram stain
 . I $D(^LR(LRDFN,LRSS,LRIDT,2)) D GS
 . ; Check for organism id
 . I '$D(^LR(LRDFN,LRSS,LRIDT,3)) Q
 . S LRSB=12
 . D ORG
 . D MIC
 ;
 ; Parasite report
 I $D(^LR(LRDFN,LRSS,LRIDT,5)) D
 . S LRSB=14,LA7NLT="87505.0000"
 . D OBR^LA7VORU
 . D NTE^LA7VORU
 . F LRSB=16.5,16.4,14 D RPTNTE
 . ; Check for organism id
 . I '$D(^LR(LRDFN,LRSS,LRIDT,6)) Q
 . N LRSB
 . S LA7OBXSN=0,LA7IDT=LRIDT,LRSB=16
 . D ORG
 ;
 ; Mycology report
 I $D(^LR(LRDFN,LRSS,LRIDT,8)) D
 . S LRSB=18,LA7NLT="87994.0000"
 . D OBR^LA7VORU
 . D NTE^LA7VORU
 . F LRSB=20.5,20.4,18 D RPTNTE
 . ; Check for organism id
 . I '$D(^LR(LRDFN,LRSS,LRIDT,9)) Q
 . N LRSB
 . S LA7OBXSN=0,LA7IDT=LRIDT,LRSB=20
 . D ORG
 ;
 ; Mycobacterium report
 I $D(^LR(LRDFN,LRSS,LRIDT,11)) D
 . S LRSB=22,LA7NLT="87995.0000"
 . D OBR^LA7VORU
 . D NTE^LA7VORU
 . F LRSB=26.5,26.4,22 D RPTNTE
 . N LRSB
 . S LA7OBXSN=0,LA7IDT=LRIDT
 . ; Report acid fast stain
 . I $L($P(^LR(LRDFN,LRSS,LRIDT,11),"^",3)) D
 . . S LRSB=24 D OBX
 . . S LRSB=25 D OBX
 . ; Check for organism id
 . I '$D(^LR(LRDFN,LRSS,LRIDT,12)) Q
 . S LRSB=26
 . D ORG
 . D MIC
 ;
 ; Virology report
 I $D(^LR(LRDFN,LRSS,LRIDT,16)) D
 . S LRSB=33,LA7NLT="87996.0000"
 . D OBR^LA7VORU
 . D NTE^LA7VORU
 . F LRSB=36.5,36.4,33 D RPTNTE
 . ; Check for virus id
 . I '$D(^LR(LRDFN,LRSS,LRIDT,17)) Q
 . N LRSB
 . S LA7OBXSN=0,LA7IDT=LRIDT,LRSB=36
 . D ORG
 ;
 Q
 ;
 ;
GS ; Report Gram stain
 ;
 N LA7GS
 ;
 S LRSB=11.6,LA7GS=0
 F  S LA7GS=$O(^LR(LRDFN,LRSS,LRIDT,2,LA7GS)) Q:'LA7GS  D
 . S LA7IDT=LRIDT_","_LA7GS
 . D OBX
 Q
 ;
 ;
RPTNTE ; Send report comments
 ;
 N LA7J,LA7ND,LA7SOC,LA7TXT
 ;
 ; Source of comment - handle special codes for other systems, i,e. DOD-CHCS
 S LA7SOC=$S($G(LA7NVAF)=1:"AC",1:"L")
 ;
 ; Bacterial preliminary/report/tests remark
 I LRSB=11 S LA7ND=4
 I LRSB=1 S LA7ND=19
 I LRSB=1.5 S LA7ND=26
 ; Parasite preliminary/report/tests remark
 I LRSB=14 S LA7ND=7
 I LRSB=16.5 S LA7ND=21
 I LRSB=16.4 S LA7ND=27
 ; Fungal preliminary/report/tests remark
 I LRSB=18 S LA7ND=10
 I LRSB=20.5 S LA7ND=22
 I LRSB=20.4 S LA7ND=28
 ; Mycobacteria preliminary/report/tests remark
 I LRSB=22 S LA7ND=13
 I LRSB=26.5 S LA7ND=23
 I LRSB=26.4 S LA7ND=29
 ; Viral preliminary/report/tests remark
 I LRSB=33 S LA7ND=18
 I LRSB=36.5 S LA7ND=20
 I LRSB=36.4 S LA7ND=30
 ;
 S LA7J=0
 F  S LA7J=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7J)) Q:'LA7J  D
 . S LA7TXT=$G(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7J,0))
 . D NTE
 Q
 ;
 ;
ORG ; Build OBR/OBX segments for MI subscript organism id
 ;
 N LA7ND,LA7ORG
 ;
 ; Bacterial organism
 I LRSB=12 S LA7ND=3
 ; Parasite organism
 I LRSB=16 S LA7ND=6
 ; Fungal organism
 I LRSB=20 S LA7ND=9
 ; Mycobacteria organism
 I LRSB=26 S LA7ND=12
 ; Viral agent
 I LRSB=36 S LA7ND=17
 ;
 S LA7ORG=0
 F  S LA7ORG=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG)) Q:'LA7ORG  D
 . S LA7IDT=LRIDT_","_LA7ORG_","
 . D OBX
 . I $L($P($G(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,0)),"^",2)) D CC
 . I LA7ND=17 Q
 . D ORGNTE
 Q
 ;
 ;
CC ; Send colony count (quantity)
 ;
 N LRSB
 ;
 I LA7ND=3 S LRSB="12,1"
 I LA7ND=9 S LRSB="20,1"
 I LA7ND=12 S LRSB="26,1"
 ;
 D OBX
 ;
 Q
 ;
 ;
ORGNTE ; Send comments on organisms.
 ;
 N LA7J,LA7SOC,LA7NTESN,LA7TXT
 ;
 ; Source of comment - handle special codes for other systems, i,e. DOD-CHCS
 S LA7SOC=$S($G(LA7NVAF)=1:"RC",1:"L")
 ;
 S (LA7J,LA7NTESN)=0
 F  S LA7J=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,1,LA7J)) Q:'LA7J  D
 . S LA7TXT=$G(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,1,LA7J,0))
 . D NTE
 Q
 ;
 ;
MIC ; Build OBR/OBX segments for MI subscript susceptibilities(MIC)
 ;
 N LA7ORG,LA7ND,LA7NLT,LA7SB,LA7SB1,LA7SOC
 ;
 ; Source of comment - handle special codes for other systems, i,e. DOD-CHCS
 S LA7SOC=$S($G(LA7NVAF)=1:"RC",1:"L")
 ;
 S (LA7NLT,LA7NLT(1))=""
 I LRSB=12 S LA7ND=3,LA7NLT="87565.0000",LA7NLT(1)="87993.0000"
 I LRSB=26 S LA7ND=12,LA7NLT="87899.0000",LA7NLT(1)="87525.0000"
 ;
 S LA7ORG=0,LA7SB=LRSB
 F  S LA7ORG=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG)) Q:'LA7ORG  D
 . N LA7NTESN,LA7PARNT
 . ; Check for susceptibiliites for this organism
 . S X=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,2))
 . I X<2!(X>2.99) Q
 . S LA7PARNT=LA7SB_"-"_LA7ORG
 . M LA7PARNT=LA7ID(LA7PARNT)
 . D OBR^LA7VORU
 . S LA7OBXSN=0,LA7SB1=2
 . F  S LA7SB1=$O(^LR(LRDFN,LRSS,LRIDT,LA7ND,LA7ORG,LA7SB1)) Q:'LA7SB1  D
 . . N LRSB
 . . S LA7IDT=LRIDT_","_LA7ORG_","_LA7SB1,LRSB=LA7SB_","_LA7SB1
 . . D OBX
 . . S X=$O(^LAB(62.06,"AD",LA7SB1,0)) Q:'X
 . . S LA7TXT=$P($G(^LAB(62.06,X,0)),"^",3)
 . . I LA7TXT'="" S LA7NTESN=0 D NTE
 Q
 ;
 ;
OBX ; Build OBX segments for MI subscript
 ; Also called by AP^LA7VORU2 to build AP OBX segments.
 ;
 N LA7DATA
 D OBX^LA7VOBX(LRDFN,LRSS,LA7IDT,LRSB,.LA7DATA,.LA7OBXSN,LA7FS,LA7ECH,LA7NVAF)
 ;
 ; If OBX failed to build then don't store
 I '$D(LA7DATA) Q
 ;
 D FILESEG^LA7VHLU(GBL,.LA7DATA)
 ;
 ; Check for flag to only build meesage but do not file
 I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7DATA)
 Q
 ;
 ;
NTE ; Build NTE segment with comment
 ;
 N LA7NTE
 ;
 S LA7NTE(0)=$$NTE^LA7VHLU3(LA7TXT,$G(LA7SOC),LA7FS,LA7ECH,.LA7NTESN)
 D FILESEG^LA7VHLU(GBL,.LA7NTE)
 ;
 ; Check for flag to only build meesage but do not file
 I '$G(LA7NOMSG) D FILE6249^LA7VHLU(LA76249,.LA7NTE)
 ;
 Q
