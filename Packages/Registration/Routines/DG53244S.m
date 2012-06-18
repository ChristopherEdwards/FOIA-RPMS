DG53244S ;BPOIFO/KEITH - Post-init continuation for DG*5.3*244 ; 26 Jan 2002 10:44 PM
 ;;5.3;Registration;**244**;Aug 13, 1993
 ;
POST ;Post-init functions
 ;
 ;Install INDEX records
 D IXBLD
 ;Update AMPIMIS cross reference
 D AMPX
 ;Update input transforms and field descriptions
 D ITXDES^DG53244R
 ;Build 'NOP' x-ref
 D NOP
 ;Recompile input templates
 D RECOMP
 ;Update triggered fields
 D TRIG
 Q
 ;
AMPX ;Update AMPIMIS cross reference
 N DGI
 D BMES^XPDUTL("Updating the AMPIMIS cross reference...")
 S DGI=0 F  S DGI=$O(^DD(2,.01,1,DGI)) Q:'DGI  D
 .Q:$P($G(^DD(2,.01,1,DGI,0)),U,2)'="AMPIMIS"
 .S ^DD(2,.01,1,DGI,1)="I $T(SET^VAFCMIS)'=""""&('$D(VAFCNO)) D SET^VAFCMIS(DA)"
 .S ^DD(2,.01,1,DGI,2)="I $T(KILL^VAFCMIS)'=""""&('$D(VAFCNO)) D KILL^VAFCMIS(DA)"
 .S ^DD(2,.01,1,DGI,"DT")=DT
 .Q
 Q
 ;
NOP ;Build the 'NOP' cross reference
 N DGX,DGY,DFN,DG,DGCT,XPDIDTOT
 D BMES^XPDUTL("Building patient name 'NOP' cross reference...")
 D FILE^DID(2,,"ENTRIES","DG") S XPDIDTOT=DG("ENTRIES"),DGCT=0
 D UPDATE^XPDID(0)
 K ^DPT("NOP") S DGX=""
 F  S DGX=$O(^DPT("B",DGX)) Q:DGX=""  S DFN=0 D
 .F  S DFN=$O(^DPT("B",DGX,DFN)) Q:'DFN  D
 ..Q:'($D(^DPT("B",DGX,DFN))#2)
 ..S DGCT=DGCT+1
 ..I DGCT#100=0 D UPDATE^XPDID(DGCT)
 ..S DGY=$$NOP^DPTNAME(DGX) Q:'$L(DGY)
 ..S ^DPT("NOP",DGY,DFN)=""
 ..Q
 .Q
 D UPDATE^XPDID(0)
 Q
 ;
RECOMP ;Recompile input templates
 N DGFLD
 D BMES^XPDUTL("Recompiling templates...")
 F DGFLD=.01,.211,.2191,.2401,.2402,.2403,.331,.3311,.341 S DGFLD(2,DGFLD)=""
 D DIEZ^DIKCUTL3(2,.DGFLD)
 K DGFLD S DGFLD(2.01,.01)="" D DIEZ^DIKCUTL3(2.01,.DGFLD)
 K DGFLD S DGFLD(2.101,30)="" D DIEZ^DIKCUTL3(2.101,.DGFLD)
 Q
 ;
TRIG ;Update trigger definitions
 N DGFLD
 D BMES^XPDUTL("Updating trigger field definitions...")
 F DGFLD=.01,.211,.2191,.2401,.2402,.2403,.331,.3311,.341 S DGFLD(2,DGFLD)=""
 D T1(.DGFLD)
 K DGFLD S DGFLD(2.01,.01)="" D T1(.DGFLD)
 K DGFLD S DGFLD(2.101,30)="" D T1(.DGFLD)
 Q
 ;
T1(DGFLD) ;Check/update triggering field definitions
 ;Input: DGFLD=array of fields to update
 N DGOUT,DGFILE
 D TRIG^DICR(.DGFLD,.DGOUT)
 S DGFILE=0 F  S DGFILE=$O(DGOUT(DGFILE)) Q:'DGFILE  D
 .S DGFLD=0 F  S DGFLD=$O(DGOUT(DGFILE,DGFLD)) Q:'DGFLD  D
 ..D MES^XPDUTL("         Field #"_DGFLD_" of file #"_DGFILE_" updated.")
 ..Q
 .Q
 Q
 ;
IXBLD ;Build INDEX records
 N DGI,DGII,DGFDA,DGIEN,DGERR,DIERR,DGVAL,DGOUT,DGWP,DGXR
 D BMES^XPDUTL("Filing INDEX records...")
 F DGI=72,100:1:111 D:DGI'=108
 .K DGFDA,DIERR,DGIEN,DGERR
 .;Create filer array
 .D:(DGI<110) @(DGI_"^DG53244Q") D:(DGI>109) @DGI
 .D DES^DG53244R(DGI,.DGWP,DGFDA(.114,"+2,+1,",3))
 .;Check for existing record
 .S DGVAL(1)=DGFDA(.11,"+1,",.01)
 .S (DGXR,DGVAL(2))=DGFDA(.11,"+1,",.02)
 .D FIND^DIC(.11,"","@;IXIE","KP",.DGVAL,"","","","","DGOUT")
 .I $D(DGOUT("DILIST",1)) D  Q
 ..D MES^XPDUTL("     >>> Cross reference "_DGXR_" already exists, nothing filed.")
 ..Q
 .D UPDATE^DIE("","DGFDA","DGIEN","DGERR")
 .I $D(DGERR) D  Q
 ..N DGI S DGI=""
 ..D MES^XPDUTL("     >>> A problem has occurred during the filing of x-ref. ADGFM"_$P(DGFLD,".",2)_"!")
 ..D MES^XPDUTL("         Please contact Customer Support.")
 ..F  S DGI=$O(DGERR("DIERR",1,"TEXT",DGI)) Q:DGI=""  D
 ...D MES^XPDUTL(DGERR("DIERR",1,"TEXT",DGI))
 ...Q
 ..Q
 .D MES^XPDUTL("     >>> "_DGXR_" cross reference filed.")
 .;File DESCRIPTION field
 .D WP^DIE(.11,DGIEN(1)_",",.1,"","DGWP")
 Q
 ;
110 ;Set values for ANAM3311 index
 D MES^XPDUTL("Filing the 'ANAM3311' index")
 S DGFDA(.11,"+1,",.01)="2"
 S DGFDA(.11,"+1,",.02)="ANAM3311"
 S DGFDA(.11,"+1,",.11)="This index keeps the NAME COMPONENTS file in synch with field #.3311."
 S DGFDA(.11,"+1,",.2)="MU"
 S DGFDA(.11,"+1,",.4)="F"
 S DGFDA(.11,"+1,",.41)="IR"
 S DGFDA(.11,"+1,",.5)="I"
 S DGFDA(.11,"+1,",.51)="2"
 S DGFDA(.11,"+1,",.42)="A"
 S DGFDA(.11,"+1,",1.1)="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^DPTNAME(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.3311,.DG20NAME,1.08,+$P($G(^DPT(DA,""NAME"")),U,8),""CL35"") K DG20NAME Q"
 S DGFDA(.11,"+1,",2.1)="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.3311,1.08) Q"
 S DGFDA(.114,"+2,+1,",.01)="1"
 S DGFDA(.114,"+2,+1,",1)="F"
 S DGFDA(.114,"+2,+1,",2)="2"
 S DGFDA(.114,"+2,+1,",3)=".3311"
 S DGFDA(.114,"+2,+1,",7)="F"
 S DGFDA(.114,"+2,+1,",.5)="1"
 Q
 ;
111 ;Set values for ANAM341 index
 D MES^XPDUTL("Filing the 'ANAM341' index")
 S DGFDA(.11,"+1,",.01)="2"
 S DGFDA(.11,"+1,",.02)="ANAM341"
 S DGFDA(.11,"+1,",.11)="This index keeps the NAME COMPONENTS file in synch with field #.341."
 S DGFDA(.11,"+1,",.2)="MU"
 S DGFDA(.11,"+1,",.4)="F"
 S DGFDA(.11,"+1,",.41)="IR"
 S DGFDA(.11,"+1,",.5)="I"
 S DGFDA(.11,"+1,",.51)="2"
 S DGFDA(.11,"+1,",.42)="A"
 S DGFDA(.11,"+1,",1.1)="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1,DG20NAME=X D NARY^DPTNAME(.DG20NAME),UPDCOMP^XLFNAME2(2,.DA,.341,.DG20NAME,1.09,+$P($G(^DPT(DA,""NAME"")),U,9),""CL35"") K DG20NAME Q"
 S DGFDA(.11,"+1,",2.1)="I '$G(XUNOTRIG) N XUNOTRIG S XUNOTRIG=1 D DELCOMP^XLFNAME2(2,.DA,.341,1.09) Q"
 S DGFDA(.114,"+2,+1,",.01)="1"
 S DGFDA(.114,"+2,+1,",1)="F"
 S DGFDA(.114,"+2,+1,",2)="2"
 S DGFDA(.114,"+2,+1,",3)=".341"
 S DGFDA(.114,"+2,+1,",7)="F"
 S DGFDA(.114,"+2,+1,",.5)="1"
 Q
