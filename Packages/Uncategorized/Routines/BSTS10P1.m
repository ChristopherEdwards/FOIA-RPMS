BSTS10P1 ;GDIT/HS/BEE-Version 1.0 Patch 1 Post (and Pre) Install ; 19 Nov 2012  9:41 AM
 ;;1.0;IHS STANDARD TERMINOLOGY;**1**;Sep 10, 2014;Build 7
 ;
ENV ;EP - Environmental Checking Routine
 ;
 ;Check for Version 1.0
 I $$VERSION^XPDUTL("BSTS")<1 D BMES^XPDUTL("Version 1.0 of BSTS is required!") S XPDQUIT=2 Q
 ;
 ;Make sure a refresh is not running already
 L +^BSTS(9002318.1,0):0 E  D BMES^XPDUTL("A Local BSTS Cache Refresh is Already Running. Please Try Later") S XPDQUIT=2 Q
 L -^BSTS(9002318.1,0)
 ;
 ;Make sure an ICD9 to SNOMED compile isn't running
 L +^TMP("BSTSICD2SMD"):0 E  D BMES^XPDUTL("An ICD9 to SNOMED Background Compile is Running.  Please Try later") S XPDQUIT=2 Q
 L -^TMP("BSTSICD2SMD")
 ;
 ;Make sure another install isn't running
 L +^TMP("BSTSINSTALL"):3 E  D BMES^XPDUTL("A BSTS Install is Already Running") S XPDQUIT=2 Q
 L -^TMP("BSTSINSTALL")
 ;
 Q
 ;
EN ;EP - Patch 1 post installation process front end
 ;
 ;Adapted from Lori's APCDPLFH routine which will run on 10/1/15 and convert ICD9
 ;entries to ICD10 entries in the problem and family history files.  Due to incorrect
 ;mappings delivered with BSTS v1.0, problem and family history entries may have
 ;incorrect ICD9 values.  This conversion will look at each file entry, pull the correct
 ;ICD9 value from BSTS and use that instead.
 ;
 NEW APCDX
 ;
 ;Do not perform conversion if after 9/30/2015
 I DT>3150930 G EN1
 ;
 S APCDX=0
 F  S APCDX=$O(^AUPNPROB(APCDX)) Q:APCDX'=+APCDX  D
 . NEW APCDCI,APCDICDS,APCDO01,APCDOA,X,Y,APCDN01,APCDNA,APCDLOGE
 . NEW APCDZ,APCDFNUM,APCDNODE,APCDY
 . Q:'$D(^AUPNPROB(APCDX,0))
 . S APCDCI=$P($G(^AUPNPROB(APCDX,800)),U)  ;only snomed coded problems
 . Q:APCDCI=""
 . Q:$P(^AUPNPROB(APCDX,0),U,12)="D"  ;SKIP DELETED PROBLEMS
 . S APCDICDS=$P($$CONC^BSTSAPI(APCDCI_"^^^1"),U,5)  ;ALL ICD CODES
 . S APCDO01=$P(^AUPNPROB(APCDX,0),U,1)  ;old .01
 . S APCDOA=""  ;old additional, ":" delimited
 . S X=0 F  S X=$O(^AUPNPROB(APCDX,12,X)) Q:X'=+X  D
 .. S Y=$P($G(^AUPNPROB(APCDX,12,X,0)),U)
 .. Q:'Y
 .. S Y=$P($$ICDDX^ICDCODE(Y),U,2)
 .. S APCDOA=APCDOA_Y_":"
 . ;update PROBLEM entry
 . S APCDN01=$P(APCDICDS,";")
 . I APCDN01="" S APCDN01=".9999"  ;Default to .9999 if no map
 . S APCDN01=+$$CODEN^ICDCODE(APCDN01,80)
 . I 'APCDN01 Q
 . I APCDN01=-1 Q  ;Can't change it if it isn't in file 80
 . S APCDNA=$P(APCDICDS,";",2,999)  ;new additional codes
 . ;now set AUPNPROB
 . K DIE,DA,DR S DA=APCDX,DR=".01////"_APCDN01,DIE="^AUPNPROB(" D ^DIE K DIE,DA,DR
 . ;ADDITIONAL MULTIPLE
 . ;DELETE OUT OLD ADDITIONAL MULTIPLE
 . S APCDZ=0 F  S APCDZ=$O(^AUPNPROB(APCDX,12,APCDZ)) Q:APCDZ'=+APCDZ  D
 .. NEW DIE,DA,DR
 .. S DIE="^AUPNPROB("_APCDX_",12,",DA=APCDZ,DA(1)=APCDX,DR=".01///@" D ^DIE
 . ;SET 12 NODES
 . S APCDFNUM=9000011.12
 . S APCDNODE=12
 . F APCDZ=1:1 S APCDY=$P(APCDNA,";",APCDZ) Q:APCDY=""  D
 .. NEW APCDP,APCDFDA,ERR
 .. S APCDP=+$$CODEN^ICDCODE(APCDY,80)
 ..Q:'APCDP
 ..Q:APCDP=-1
 ..S APCDFDA(APCDFNUM,"+2,"_APCDX_",",.01)=APCDP
 ..D UPDATE^DIE("","APCDFDA","","ERR")
 ;
FH ;
 S APCDX=0
 F  S APCDX=$O(^AUPNFH(APCDX)) Q:APCDX'=+APCDX  D
 . NEW APCDCI,APCDICDS,APCDO01,APCDOA,X,Y,APCDN01,APCDNA,APCDLOGE
 . NEW APCDZ,APCDFNUM,APCDY
 . Q:'$D(^AUPNFH(APCDX,0))
 . S APCDCI=$P($G(^AUPNFH(APCDX,0)),U,13)  ;only snomed coded fh ENTRIES
 . Q:APCDCI=""
 . S APCDICDS=$P($$CONC^BSTSAPI(APCDCI_"^^^1"),U,5)  ;ALL ICD CODES
 . S APCDO01=$P(^AUPNFH(APCDX,0),U,1)
 . S APCDOA=""
 . S X=0 F  S X=$O(^AUPNFH(APCDX,11,X)) Q:X'=+X  D
 .. S Y=$P($G(^AUPNFH(APCDX,11,X,0)),U)
 .. Q:'Y
 .. S Y=$P($$ICDDX^ICDCODE(Y),U,2)
 .. S APCDOA=APCDOA_Y_":"
 . ;update fh entry
 . S APCDN01=$P(APCDICDS,";")
 . I APCDN01="" S APCDN01=".9999"  ;Default to .9999 if no map
 . S APCDN01=+$$CODEN^ICDCODE(APCDN01,80)
 . I 'APCDN01 Q
 . I APCDN01=-1 Q
 . S APCDNA=$P(APCDICDS,";",2,999)
 . ;now set AUPNFH
 . K DIE,DA,DR S DA=APCDX,DR=".01////"_APCDN01,DIE="^AUPNFH(" D ^DIE K DIE,DA,DR
 . S APCDZ=0 F  S APCDZ=$O(^AUPNFH(APCDX,11,APCDZ)) Q:APCDZ'=+APCDZ  D
 .. S DIE="^AUPNFH("_APCDX_",11,",DA=APCDZ,DA(1)=APCDX,DR=".01///@" D ^DIE K DIE,DA,DR
 . ;SET 11 NODES
 . S APCDFNUM=9000014.11
 . F APCDZ=1:1 S APCDY=$P(APCDNA,";",APCDZ) Q:APCDY=""  D
 .. NEW APCDP,APCDFDA,ERR
 .. S APCDP=+$$CODEN^ICDCODE(APCDY,80)
 .. Q:'APCDP
 .. Q:APCDP=-1
 .. S APCDFDA(APCDFNUM,"+2,"_APCDX_",",.01)=APCDP
 .. D UPDATE^DIE("","APCDFDA","","ERR")
 ;
 ;Unlock installation entry
EN1 L -^TMP("BSTSINSTALL")
 ;
 ;Clear out the ICD9 to SNOMED JOB flag and kick off process
 D
 . NEW BSTSUPD,ERR,NMIEN
 . ;
 . ;Make sure we have a codeset (namespace)
 . S NMIEN=$O(^BSTS(9002318.1,"B",36,"")) Q:NMIEN=""
 . S BSTSUPD(9002318.1,NMIEN_",",.09)="@"
 . D FILE^DIE("","BSTSUPD","ERR")
 . Q:$D(ERR)
 . ;
 . ;Kick off the background process
 . D PLOAD^BSTSUTIL(NMIEN)
 ;
 Q
 ;
PRE ;Pre-Install Front End
 ;
 NEW DIU,WSIEN
 ;
 ;Perform Lock so only one install can run and DTS calls will be switched to local
 L +^TMP("BSTSINSTALL"):3 E  W !!,"A BSTS Install is Already Running - Aborting Installation" H 10 S XPDABORT=1 Q
 ;
 ;Check Web Service entries - convert old ports to new ports
 NEW WSIEN,APCDX,STS
 ;
 S WSIEN=0 F  S WSIEN=$O(^BSTS(9002318.2,WSIEN)) Q:'WSIEN  D
 . NEW URL,PORT,NWPORT
 . ;
 . ;Get the port - Quit it old DITDTS1 or Production port not found
 . S PORT=$$GET1^DIQ(9002318.2,WSIEN_",",.03,"E") Q:PORT=""
 . I PORT'=443,PORT'=8080 Q
 . S NWPORT=PORT
 . ;
 . ;Get URL - If Production or DITDTS1 change the port
 . S URL=$$GET1^DIQ(9002318.2,WSIEN_",",.02,"E")
 . I $$LOW^XLFSTR(URL)="https://dtsservices.ihs.gov" S NWPORT=444
 . I $$LOW^XLFSTR(URL)="http://ditdts1" S NWPORT=8081
 . ;
 . ;Update the port
 . I NWPORT'=PORT D
 .. NEW BSTSUPD,ERR
 .. S BSTSUPD(9002318.2,WSIEN_",",.03)=NWPORT
 .. D FILE^DIE("","BSTSUPD","ERR")
 ;
 ;Perform version check - to see if DTS works with the possible new ports
 S STS=$$VERSIONS^BSTSAPI("VAR",36)
 I +STS'=2 D  W !!,"DTS is not working properly. Please contact the BSTS Support Group - Aborting Installation" H 10 S XPDABORT=1 L -^TMP("BSTSINSTALL") Q
 . ;
 . ;Allow logins again
 . NEW LIEN,LOG,ERR
 . S LIEN=$O(^%ZIS(14.5,0)) Q:'+LIEN
 . S LOG(14.5,LIEN_",",1)="N"
 . D FILE^DIE("","LOG","ERR")
 ;
 ;Clear out existing entries
 S DIU="^BSTS(9002318.1,",DIU(0)="DST" D EN^DIU2
 S DIU="^BSTS(9002318.3,",DIU(0)="DST" D EN^DIU2
 S DIU="^BSTS(9002318.4,",DIU(0)="DST" D EN^DIU2
 Q
